class KanjiItem {
  const KanjiItem({
    required this.id,
    required this.lessonId,
    required this.character,
    required this.strokeCount,
    this.onyomi,
    this.kunyomi,
    required this.meaning,
    this.meaningEn,
    this.mnemonicVi,
    this.mnemonicEn,
    required this.examples,
    required this.jlptLevel,
  });

  final int id;
  final int lessonId;
  final String character;
  final int strokeCount;
  final String? onyomi;
  final String? kunyomi;
  final String meaning;
  final String? meaningEn;
  final String? mnemonicVi;
  final String? mnemonicEn;
  final List<KanjiExample> examples;
  final String jlptLevel;
}

class KanjiExample {
  const KanjiExample({
    this.word = '',
    this.reading = '',
    this.meaning = '',
    this.meaningEn,
    this.sourceVocabId,
    this.sourceSenseId,
  });

  final String word;
  final String reading;
  final String meaning;
  final String? meaningEn;
  final String? sourceVocabId;
  final String? sourceSenseId;

  bool get hasSourceRef =>
      (sourceSenseId?.trim().isNotEmpty ?? false) ||
      (sourceVocabId?.trim().isNotEmpty ?? false);

  KanjiExample resolvedWith({
    required String word,
    required String reading,
    required String meaning,
    String? meaningEn,
  }) {
    return KanjiExample(
      word: word,
      reading: reading,
      meaning: meaning,
      meaningEn: meaningEn,
      sourceVocabId: sourceVocabId,
      sourceSenseId: sourceSenseId,
    );
  }

  Map<String, dynamic> toJson() => {
    if (word.trim().isNotEmpty) 'word': word,
    if (reading.trim().isNotEmpty) 'reading': reading,
    if (meaning.trim().isNotEmpty) 'meaning': meaning,
    if (meaningEn != null && meaningEn!.trim().isNotEmpty)
      'meaningEn': meaningEn,
    if (sourceVocabId != null && sourceVocabId!.trim().isNotEmpty)
      'sourceVocabId': sourceVocabId,
    if (sourceSenseId != null && sourceSenseId!.trim().isNotEmpty)
      'sourceSenseId': sourceSenseId,
  };

  factory KanjiExample.fromJson(Map<String, dynamic> json) {
    String? readOptional(String key) {
      final raw = json[key];
      if (raw == null) return null;
      final value = raw.toString().trim();
      return value.isEmpty ? null : value;
    }

    return KanjiExample(
      word: readOptional('word') ?? '',
      reading: readOptional('reading') ?? '',
      meaning: readOptional('meaning') ?? '',
      meaningEn: readOptional('meaningEn'),
      sourceVocabId: readOptional('sourceVocabId'),
      sourceSenseId: readOptional('sourceSenseId'),
    );
  }
}
