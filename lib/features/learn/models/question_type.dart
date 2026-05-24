import 'package:jpstudy/core/app_language.dart';

/// Question types available in Learn Mode
enum QuestionType { multipleChoice, trueFalse, fillBlank, listening }

extension QuestionTypeExtension on QuestionType {
  String label(AppLanguage language) {
    switch (this) {
      case QuestionType.multipleChoice:
        return language.multipleChoiceLabel;
      case QuestionType.trueFalse:
        return language.trueFalseChoiceLabel;
      case QuestionType.fillBlank:
        return language.fillBlankLabel;
      case QuestionType.listening:
        return switch (language) {
          AppLanguage.en => 'Listening',
          AppLanguage.vi => 'Nghe',
          AppLanguage.ja => '聴解',
        };
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
      case QuestionType.listening:
        return '🔊';
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
      case QuestionType.listening:
        return 2; // Audio-first recognition
    }
  }
}
