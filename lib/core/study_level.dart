import 'package:jpstudy/core/app_language.dart';

enum StudyLevel {
  n5,
  n4,
  n3,
}

extension StudyLevelLabels on StudyLevel {
  String get shortLabel {
    switch (this) {
      case StudyLevel.n5:
        return 'N5';
      case StudyLevel.n4:
        return 'N4';
      case StudyLevel.n3:
        return 'N3';
    }
  }

  String description(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return _descriptionEn;
      case AppLanguage.vi:
        return _descriptionVi;
      case AppLanguage.ja:
        return _descriptionJa;
    }
  }

  String get _descriptionEn {
    switch (this) {
      case StudyLevel.n5:
        return 'Beginner fundamentals';
      case StudyLevel.n4:
        return 'Lower intermediate';
      case StudyLevel.n3:
        return 'Intermediate';
    }
  }

  String get _descriptionVi {
    switch (this) {
      case StudyLevel.n5:
        return 'Nhập môn căn bản';
      case StudyLevel.n4:
        return 'Sơ trung cấp';
      case StudyLevel.n3:
        return 'Trung cấp';
    }
  }

  String get _descriptionJa {
    switch (this) {
      case StudyLevel.n5:
        return '入門の基礎';
      case StudyLevel.n4:
        return '初中級';
      case StudyLevel.n3:
        return '中級';
    }
  }
}
