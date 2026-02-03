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
    required this.word,
    required this.reading,
    required this.meaning,
    this.meaningEn,
  });

  final String word;
  final String reading;
  final String meaning;
  final String? meaningEn;

  Map<String, dynamic> toJson() => {
    'word': word,
    'reading': reading,
    'meaning': meaning,
    'meaningEn': meaningEn,
  };

  factory KanjiExample.fromJson(Map<String, dynamic> json) {
    return KanjiExample(
      word: json['word'] as String,
      reading: json['reading'] as String,
      meaning: json['meaning'] as String,
      meaningEn: json['meaningEn'] as String?,
    );
  }
}
