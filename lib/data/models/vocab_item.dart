import 'package:jpstudy/core/app_language.dart';

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

  String displayMeaning(AppLanguage language) {
    final english = meaningEn?.trim() ?? '';
    switch (language) {
      case AppLanguage.vi:
        return meaning;
      case AppLanguage.en:
        return english.isNotEmpty ? english : meaning;
      case AppLanguage.ja:
        return english.isNotEmpty ? english : meaning;
    }
  }
}
