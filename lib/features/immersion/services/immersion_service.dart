import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../models/immersion_article.dart';

enum ImmersionSource {
  local,
  nhkEasy,
}

class ImmersionService {
  static const _assetPath = 'assets/data/immersion/immersion_samples.json';
  static const nhkSourceLabel = 'NHK Easy';
  static const nhkLevelLabel = 'Easy';
  static const _nhkTopListUrl =
      'https://www3.nhk.or.jp/news/easy/top-list.json';
  static const _nhkNewsListUrl =
      'https://www3.nhk.or.jp/news/easy/news-list.json';
  static const _cacheDirName = 'immersion_cache';
  static const _listCacheFile = 'nhk_list.json';
  static const Duration _listCacheTtl = Duration(hours: 6);
  static const Duration _articleCacheTtl = Duration(days: 7);

  Future<List<ImmersionArticle>> loadLocalSamples() async {
    final raw = await rootBundle.loadString(_assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = json['articles'] as List<dynamic>? ?? const [];
    return list
        .map((e) => ImmersionArticle.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ImmersionArticle>> loadNhkEasySummaries({
    bool forceRefresh = false,
    int limit = 12,
  }) async {
    if (!forceRefresh) {
      final cached = await _readCacheList();
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
    }

    final items = await _fetchNhkList();
    final summaries = <ImmersionArticle>[];
    final seen = <String>{};
    for (final item in items) {
      final id = _string(item['news_id'] ?? item['id'] ?? item['newsId']);
      if (id == null || id.isEmpty || seen.contains(id)) {
        continue;
      }
      seen.add(id);
      final title = _string(item['title']) ?? id;
      final timeRaw = _string(item['news_prearranged_time']) ??
          _string(item['news_published_time']) ??
          _string(item['publish_time']) ??
          _string(item['date']);
      final publishedAt = _parseDate(timeRaw) ?? DateTime.now();

      summaries.add(
        ImmersionArticle(
          id: id,
          title: title,
          titleFurigana: null,
          level: nhkLevelLabel,
          source: nhkSourceLabel,
          publishedAt: publishedAt,
          paragraphs: const [],
          translation: null,
        ),
      );
      if (summaries.length >= limit) break;
    }

    if (summaries.isNotEmpty) {
      await _writeCacheList(summaries);
    }
    if (summaries.isEmpty) {
      final cached = await _readCacheList(ignoreTtl: true);
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
    }
    return summaries;
  }

  Future<ImmersionArticle?> loadNhkArticleDetail(
    String newsId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await _readCacheArticle(newsId);
      if (cached != null) {
        return cached;
      }
    }

    final url = 'https://www3.nhk.or.jp/news/easy/$newsId/$newsId.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return _readCacheArticle(newsId, ignoreTtl: true);
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    final article = _parseNhkArticle(decoded, fallbackId: newsId);
    if (article == null) {
      return _readCacheArticle(newsId, ignoreTtl: true);
    }
    await _writeCacheArticle(article);
    return article;
  }

  Future<List<Map<String, dynamic>>> _fetchNhkList() async {
    final urls = [_nhkTopListUrl, _nhkNewsListUrl];
    for (final url in urls) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        continue;
      }
      final decoded = jsonDecode(response.body);
      final items = _extractListItems(decoded);
      if (items.isNotEmpty) {
        return items;
      }
    }
    return [];
  }

  List<Map<String, dynamic>> _extractListItems(dynamic decoded) {
    final items = <Map<String, dynamic>>[];
    if (decoded is List) {
      for (final entry in decoded) {
        if (entry is Map) {
          final hasListValue = entry.values.any((value) => value is List);
          if (hasListValue) {
            for (final value in entry.values) {
              if (value is List) {
                for (final item in value) {
                  if (item is Map<String, dynamic>) {
                    items.add(item);
                  } else if (item is Map) {
                    items.add(Map<String, dynamic>.from(item));
                  }
                }
              }
            }
          } else {
            items.add(Map<String, dynamic>.from(entry));
          }
        }
      }
    } else if (decoded is Map) {
      final data = decoded['data'];
      if (data is List) {
        for (final item in data) {
          if (item is Map<String, dynamic>) {
            items.add(item);
          } else if (item is Map) {
            items.add(Map<String, dynamic>.from(item));
          }
        }
      }
    }
    return items;
  }

  ImmersionArticle? _parseNhkArticle(
    Map<String, dynamic> json, {
    required String fallbackId,
  }) {
    final root = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final id = _string(root['news_id'] ?? root['id'] ?? fallbackId) ?? fallbackId;
    final titleWithRuby = _string(root['title_with_ruby']);
    final title = _string(root['title']) ??
        (titleWithRuby != null ? _stripTags(titleWithRuby) : null) ??
        id;

    final titleFurigana =
        titleWithRuby == null ? null : _renderRubyText(titleWithRuby);

    final timeRaw = _string(root['news_prearranged_time']) ??
        _string(root['news_published_time']) ??
        _string(root['publish_time']) ??
        _string(root['date']);
    final publishedAt = _parseDate(timeRaw) ?? DateTime.now();

    final dict = _parseWordList(root['word_list'] ?? root['dictionary']);

    final paragraphs = <List<ImmersionToken>>[];
    final body = root['body'] ?? root['news_body'] ?? root['text'];
    if (body is List) {
      for (final entry in body) {
        final text = _extractBodyText(entry);
        if (text == null || text.trim().isEmpty) {
          continue;
        }
        paragraphs.addAll(_parseParagraphs(text, dict));
      }
    } else if (body is String) {
      paragraphs.addAll(_parseParagraphs(body, dict));
    }

    if (paragraphs.isEmpty) {
      final outline = _string(root['outline'] ?? root['outline_with_ruby']);
      if (outline != null && outline.trim().isNotEmpty) {
        paragraphs.addAll(_parseParagraphs(outline, dict));
      }
    }

    return ImmersionArticle(
      id: id,
      title: title,
      titleFurigana: titleFurigana,
      level: nhkLevelLabel,
      source: nhkSourceLabel,
      publishedAt: publishedAt,
      paragraphs: paragraphs,
      translation: null,
    );
  }

  String? _extractBodyText(dynamic entry) {
    if (entry is String) {
      return entry;
    }
    if (entry is Map) {
      return _string(entry['text_with_ruby']) ??
          _string(entry['text']) ??
          _string(entry['body']) ??
          _string(entry['content']);
    }
    return null;
  }

  List<List<ImmersionToken>> _parseParagraphs(
    String html,
    Map<String, _NhkWord> dict,
  ) {
    final normalized = html.replaceAll(
      RegExp(r'<br\s*/?>', caseSensitive: false),
      '\n',
    );
    final parts = normalized.split(RegExp(r'\n+'));
    final paragraphs = <List<ImmersionToken>>[];
    for (final part in parts) {
      final tokens = _parseRubyText(part, dict);
      if (tokens.isNotEmpty) {
        paragraphs.add(tokens);
      }
    }
    return paragraphs;
  }

  List<ImmersionToken> _parseRubyText(
    String html,
    Map<String, _NhkWord> dict,
  ) {
    final tokens = <ImmersionToken>[];
    final rubyRegex = RegExp(r'<ruby[^>]*>.*?</ruby>', dotAll: true);
    var cursor = 0;
    for (final match in rubyRegex.allMatches(html)) {
      if (match.start > cursor) {
        final before = html.substring(cursor, match.start);
        tokens.addAll(_plainTokens(before, dict));
      }
      final ruby = match.group(0) ?? '';
      final token = _tokenFromRuby(ruby, dict);
      if (token != null) {
        tokens.add(token);
      }
      cursor = match.end;
    }
    if (cursor < html.length) {
      tokens.addAll(_plainTokens(html.substring(cursor), dict));
    }
    return tokens.where((t) => t.surface.trim().isNotEmpty).toList();
  }

  ImmersionToken? _tokenFromRuby(String rubyHtml, Map<String, _NhkWord> dict) {
    final rtRegex = RegExp(r'<rt[^>]*>(.*?)</rt>', dotAll: true);
    final rbRegex = RegExp(r'<rb[^>]*>(.*?)</rb>', dotAll: true);
    final reading = rtRegex
        .allMatches(rubyHtml)
        .map((m) => _stripTags(m.group(1) ?? ''))
        .join();
    final rbMatches = rbRegex.allMatches(rubyHtml).toList();
    String surface;
    if (rbMatches.isNotEmpty) {
      surface =
          rbMatches.map((m) => _stripTags(m.group(1) ?? '')).join();
    } else {
      surface = _stripTags(rubyHtml
          .replaceAll(rtRegex, '')
          .replaceAll(RegExp(r'<rp[^>]*>.*?</rp>'), ''));
    }
    surface = surface.trim();
    if (surface.isEmpty) return null;
    final dictWord = dict[surface];
    return ImmersionToken(
      surface: surface,
      reading: reading.isEmpty ? dictWord?.reading : reading,
      meaningEn: dictWord?.meaningEn,
      meaningVi: null,
    );
  }

  List<ImmersionToken> _plainTokens(
    String text,
    Map<String, _NhkWord> dict,
  ) {
    final cleaned = _decodeEntities(_stripTags(text));
    final tokens = <ImmersionToken>[];
    final buffer = StringBuffer();
    for (final rune in cleaned.runes) {
      final char = String.fromCharCode(rune);
      if (_isWhitespace(char)) {
        _flushBuffer(buffer, tokens, dict);
        continue;
      }
      if (_isPunctuation(char)) {
        _flushBuffer(buffer, tokens, dict);
        tokens.add(_tokenFromSurface(char, dict));
        continue;
      }
      buffer.write(char);
    }
    _flushBuffer(buffer, tokens, dict);
    return tokens;
  }

  void _flushBuffer(
    StringBuffer buffer,
    List<ImmersionToken> tokens,
    Map<String, _NhkWord> dict,
  ) {
    if (buffer.isEmpty) return;
    final surface = buffer.toString();
    tokens.add(_tokenFromSurface(surface, dict));
    buffer.clear();
  }

  ImmersionToken _tokenFromSurface(
    String surface,
    Map<String, _NhkWord> dict,
  ) {
    final dictWord = dict[surface];
    return ImmersionToken(
      surface: surface,
      reading: dictWord?.reading,
      meaningEn: dictWord?.meaningEn,
      meaningVi: null,
    );
  }

  Map<String, _NhkWord> _parseWordList(dynamic raw) {
    final map = <String, _NhkWord>{};
    if (raw is List) {
      for (final item in raw) {
        if (item is! Map) continue;
        final surface = _string(item['word'] ??
                item['surface'] ??
                item['text'] ??
                item['kanji'] ??
                item['term']) ??
            '';
        if (surface.trim().isEmpty) continue;
        final reading = _string(item['ruby'] ??
            item['furigana'] ??
            item['reading'] ??
            item['kana']);
        final meaning = _string(item['meaning'] ??
            item['meaning_en'] ??
            item['definition'] ??
            item['translation']);
        if (reading == null && meaning == null) continue;
        map[surface] = _NhkWord(
          surface: surface,
          reading: reading,
          meaningEn: meaning,
        );
      }
    }
    return map;
  }

  Future<Directory> _getCacheDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, _cacheDirName));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  Future<List<ImmersionArticle>?> _readCacheList({
    bool ignoreTtl = false,
  }) async {
    final dir = await _getCacheDir();
    final file = File(p.join(dir.path, _listCacheFile));
    if (!file.existsSync()) return null;
    try {
      final raw = await file.readAsString();
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final savedAt = DateTime.tryParse(decoded['savedAt']?.toString() ?? '');
      if (!ignoreTtl &&
          (savedAt == null ||
              DateTime.now().difference(savedAt) > _listCacheTtl)) {
        return null;
      }
      final data = decoded['data'] as List<dynamic>? ?? const [];
      return data
          .map((e) => ImmersionArticle.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCacheList(List<ImmersionArticle> articles) async {
    final dir = await _getCacheDir();
    final file = File(p.join(dir.path, _listCacheFile));
    final payload = {
      'savedAt': DateTime.now().toIso8601String(),
      'data': articles.map((a) => a.toJson()).toList(),
    };
    await file.writeAsString(jsonEncode(payload), flush: true);
  }

  Future<ImmersionArticle?> _readCacheArticle(
    String id, {
    bool ignoreTtl = false,
  }) async {
    final dir = await _getCacheDir();
    final file = File(p.join(dir.path, 'nhk_$id.json'));
    if (!file.existsSync()) return null;
    try {
      final raw = await file.readAsString();
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final savedAt = DateTime.tryParse(decoded['savedAt']?.toString() ?? '');
      if (!ignoreTtl &&
          (savedAt == null ||
              DateTime.now().difference(savedAt) > _articleCacheTtl)) {
        return null;
      }
      final data = decoded['data'] as Map<String, dynamic>;
      return ImmersionArticle.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCacheArticle(ImmersionArticle article) async {
    final dir = await _getCacheDir();
    final file = File(p.join(dir.path, 'nhk_${article.id}.json'));
    final payload = {
      'savedAt': DateTime.now().toIso8601String(),
      'data': article.toJson(),
    };
    await file.writeAsString(jsonEncode(payload), flush: true);
  }

  String? _string(dynamic value) {
    if (value == null) return null;
    final text = value.toString();
    return text.trim().isEmpty ? null : text;
  }

  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final trimmed = raw.trim();
    if (RegExp(r'^\d{8}$').hasMatch(trimmed)) {
      final year = int.tryParse(trimmed.substring(0, 4));
      final month = int.tryParse(trimmed.substring(4, 6));
      final day = int.tryParse(trimmed.substring(6, 8));
      if (year != null && month != null && day != null) {
        return DateTime(year, month, day);
      }
    }
    var normalized = trimmed.replaceAll('/', '-');
    if (normalized.contains(' ')) {
      normalized = normalized.replaceFirst(' ', 'T');
    }
    if (RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$')
        .hasMatch(normalized)) {
      normalized = '$normalized:00';
    }
    return DateTime.tryParse(normalized);
  }

  String _stripTags(String input) {
    return input.replaceAll(RegExp(r'<[^>]+>'), '');
  }

  String _renderRubyText(String html) {
    final rubyRegex = RegExp(r'<ruby[^>]*>(.*?)</ruby>', dotAll: true);
    var output = html;
    for (final match in rubyRegex.allMatches(html)) {
      final ruby = match.group(0) ?? '';
      final token = _tokenFromRuby(ruby, const <String, _NhkWord>{});
      if (token == null) continue;
      final replacement = token.reading == null || token.reading!.isEmpty
          ? token.surface
          : '${token.surface}(${token.reading})';
      output = output.replaceFirst(ruby, replacement);
    }
    return _decodeEntities(_stripTags(output));
  }

  String _decodeEntities(String input) {
    return input
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
  }

  bool _isWhitespace(String char) =>
      char.trim().isEmpty || char == '\u00A0';

  bool _isPunctuation(String char) {
    const punctuation = '。、！？.,!?「」『』（）()[]{}・：:';
    return punctuation.contains(char);
  }
}

class _NhkWord {
  const _NhkWord({
    required this.surface,
    this.reading,
    this.meaningEn,
  });

  final String surface;
  final String? reading;
  final String? meaningEn;
}
