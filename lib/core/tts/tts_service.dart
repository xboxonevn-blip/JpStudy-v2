import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String _ttsBaseUrl =
    String.fromEnvironment('TTS_BASE_URL', defaultValue: '');

class TtsNotConfiguredException implements Exception {
  const TtsNotConfiguredException();
}

class TtsRequestException implements Exception {
  const TtsRequestException(this.statusCode, this.body);

  final int statusCode;
  final String body;
}

class TtsService {
  TtsService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final Map<String, Future<File>> _inflight = {};

  Future<File> synthesize({
    required String text,
    required String locale,
    String? voice,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('text is empty');
    }
    if (_ttsBaseUrl.isEmpty) {
      throw const TtsNotConfiguredException();
    }
    final cacheKey = '$locale|${voice ?? ''}|$trimmed';
    final hash = sha256.convert(utf8.encode(cacheKey)).toString();
    final cacheDir = await _cacheDirectory();
    final basePath = p.join(cacheDir.path, hash);
    final existing = await _existingCacheFile(basePath);
    if (existing != null) {
      return existing;
    }
    final inFlight = _inflight[hash];
    if (inFlight != null) {
      return inFlight;
    }
    final future = _fetchAndCache(basePath, trimmed, locale, voice);
    _inflight[hash] = future;
    try {
      return await future;
    } finally {
      _inflight.remove(hash);
    }
  }

  void dispose() {
    _client.close();
  }

  Future<File> _fetchAndCache(
    String basePath,
    String text,
    String locale,
    String? voice,
  ) async {
    final uri = Uri.parse('$_ttsBaseUrl/tts');
    final response = await _client.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'text': text,
        'locale': locale,
        if (voice != null) 'voice': voice,
      }),
    );
    if (response.statusCode != 200) {
      throw TtsRequestException(response.statusCode, response.body);
    }
    final ext = _extensionFromResponse(response.headers['content-type']);
    final target = File('$basePath.$ext');
    await target.writeAsBytes(response.bodyBytes, flush: true);
    return target;
  }

  Future<File?> _existingCacheFile(String basePath) async {
    final mp3 = File('$basePath.mp3');
    if (await mp3.exists()) {
      return mp3;
    }
    final wav = File('$basePath.wav');
    if (await wav.exists()) {
      return wav;
    }
    return null;
  }

  String _extensionFromResponse(String? contentType) {
    final type = (contentType ?? '').toLowerCase();
    if (type.contains('wav')) {
      return 'wav';
    }
    return 'mp3';
  }

  Future<int> cacheSizeBytes() async {
    final dir = await _cacheDirectory();
    if (!await dir.exists()) {
      return 0;
    }
    var total = 0;
    await for (final entity in dir.list()) {
      if (entity is File) {
        total += await entity.length();
      }
    }
    return total;
  }

  Future<void> clearCache() async {
    final dir = await _cacheDirectory();
    if (!await dir.exists()) {
      return;
    }
    await for (final entity in dir.list()) {
      await entity.delete(recursive: true);
    }
  }

  Future<Directory> _cacheDirectory() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(root.path, 'tts_cache'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}
