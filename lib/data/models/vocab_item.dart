class VocabItem {
  final int id;
  final String term;
  final String? reading;
  final String meaning;
  final String? meaningEn;
  final String? kanjiMeaning;
  final String level;

  const VocabItem({
    required this.id,
    required this.term,
    this.reading,
    required this.meaning,
    this.meaningEn,
    this.kanjiMeaning,
    required this.level,
  });
}
