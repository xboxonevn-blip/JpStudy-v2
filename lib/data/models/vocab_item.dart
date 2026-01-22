class VocabItem {
  final int id;
  final String term;
  final String? reading;
  final String meaning;
  final String? meaningEn;
  final String? kanjiMeaning;
  final String level;
  final List<String>? tags;

    this.kanjiMeaning,
    this.mnemonicVi,
    this.mnemonicEn,
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
  final String level;
  final List<String>? tags;
}
