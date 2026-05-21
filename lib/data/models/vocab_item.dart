import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/utils/japanese_text.dart';
import 'dart:convert';

class VocabItem {
  const VocabItem({
    required this.id,
    required this.term,
    this.reading,
    required this.meaning,
    this.meaningEn,
    this.kanjiMeaning,
    this.mnemonicVi,
    this.mnemonicEn,
    this.exampleSentences = const [],
    required this.level,
    this.tags,
  });

  final int id;
  final String term;
  final String? reading;
  final String meaning;
  final String? meaningEn;
  final String? kanjiMeaning;
  final String? mnemonicVi;
  final String? mnemonicEn;
  final List<VocabExampleSentence> exampleSentences;
  final String level;
  final List<String>? tags;

  bool get hasDisplayReading => shouldShowReading(term: term, reading: reading);

  String displayMeaning(AppLanguage language) {
    final english = meaningEn?.trim() ?? '';
    switch (language) {
      case AppLanguage.vi:
        return meaning;
      case AppLanguage.en:
        return english.isNotEmpty ? english : meaning;
      case AppLanguage.ja:
        return english.isNotEmpty ? english : '';
    }
  }

  String? displayMnemonic(AppLanguage language) {
    final vi = mnemonicVi?.trim();
    final en = mnemonicEn?.trim();
    switch (language) {
      case AppLanguage.vi:
        return vi != null && vi.isNotEmpty ? vi : null;
      case AppLanguage.en:
      case AppLanguage.ja:
        return en != null && en.isNotEmpty ? en : null;
    }
  }
}

class VocabExampleSentence {
  const VocabExampleSentence({
    required this.exampleId,
    required this.ja,
    required this.vi,
    this.audioUrl,
    required this.source,
  });

  final String exampleId;
  final String ja;
  final String vi;
  final String? audioUrl;
  final String source;

  bool get hasAudio => (audioUrl ?? '').trim().isNotEmpty;

  factory VocabExampleSentence.fromJson(Map<String, dynamic> json) {
    return VocabExampleSentence(
      exampleId: (json['example_id'] ?? json['exampleId'] ?? '').toString(),
      ja: (json['ja'] ?? '').toString(),
      vi: (json['vi'] ?? '').toString(),
      audioUrl: _nullableText(json['audio_url'] ?? json['audioUrl']),
      source: (json['source'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'example_id': exampleId,
      'ja': ja,
      'vi': vi,
      'audio_url': audioUrl ?? '',
      'source': source,
    };
  }

  static String? _nullableText(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }
}

List<VocabExampleSentence> parseVocabExampleSentences(String? raw) {
  final text = raw?.trim() ?? '';
  if (text.isEmpty) return const [];
  try {
    final decoded = json.decode(text);
    if (decoded is! List) return const [];
    return [
          for (final item in decoded)
            if (item is Map)
              VocabExampleSentence.fromJson(
                item.map((key, value) => MapEntry(key.toString(), value)),
              ),
        ]
        .where((item) => item.ja.trim().isNotEmpty && item.vi.trim().isNotEmpty)
        .toList();
  } catch (_) {
    return const [];
  }
}

String encodeVocabExampleSentences(List<VocabExampleSentence> examples) {
  return json.encode(examples.map((item) => item.toJson()).toList());
}
