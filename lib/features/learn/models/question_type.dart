/// Question types available in Learn Mode
enum QuestionType {
  multipleChoice,
  trueFalse,
  fillBlank,
}

extension QuestionTypeExtension on QuestionType {
  String get label {
    switch (this) {
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.trueFalse:
        return 'True/False';
      case QuestionType.fillBlank:
        return 'Fill in the Blank';
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
