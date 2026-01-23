import 'package:jpstudy/core/app_language.dart';

/// Question types available in Learn Mode
enum QuestionType {
  multipleChoice,
  trueFalse,
  fillBlank,
}

extension QuestionTypeExtension on QuestionType {
  String label(AppLanguage language) {
    switch (this) {
      case QuestionType.multipleChoice:
        return language.multipleChoiceLabel;
      case QuestionType.trueFalse:
        return language.trueFalseChoiceLabel;
      case QuestionType.fillBlank:
        return language.fillBlankLabel;
    }
  }

  String get icon {
    switch (this) {
      case QuestionType.multipleChoice:
        return '🔘';
      case QuestionType.trueFalse:
        return '✓✗';
      case QuestionType.fillBlank:
        return '✏️';
    }
  }

  /// Difficulty level (1-3)
  int get difficulty {
    switch (this) {
      case QuestionType.multipleChoice:
        return 1; // Easiest
      case QuestionType.trueFalse:
        return 2;
      case QuestionType.fillBlank:
        return 3; // Hardest
    }
  }
}
