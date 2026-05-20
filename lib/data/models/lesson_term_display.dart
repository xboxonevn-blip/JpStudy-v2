import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/data/db/app_database.dart';

extension UserLessonTermDisplay on UserLessonTermData {
  String displayDefinition(AppLanguage language) {
    final vi = definition.trim();
    final en = definitionEn.trim();
    switch (language) {
      case AppLanguage.vi:
        return vi;
      case AppLanguage.en:
        return en.isNotEmpty ? en : vi;
      case AppLanguage.ja:
        return en.isNotEmpty ? en : '';
    }
  }
}
