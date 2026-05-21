enum ExerciseType {
  recognition,
  production,
  recall,
  readingComp,
  listening,
  conjugationDrill,
}

enum BloomLevel { l1Remember, l2Understand, l3Apply, l4Analyze }

enum ExerciseSource { authored, generated, ttsReady }

class Exercise {
  const Exercise({
    required this.id,
    required this.itemId,
    required this.type,
    required this.bloomLevel,
    required this.prompt,
    required this.correctAnswer,
    required this.source,
    this.options = const [],
    this.explanation,
    this.sourceQuestionId,
    this.audioText,
    this.tags = const [],
    this.metadata = const {},
  });

  final String id;
  final String itemId;
  final ExerciseType type;
  final BloomLevel bloomLevel;
  final String prompt;
  final String correctAnswer;
  final List<String> options;
  final String? explanation;
  final String? sourceQuestionId;
  final String? audioText;
  final ExerciseSource source;
  final List<String> tags;
  final Map<String, Object?> metadata;

  bool get isChoiceBased {
    switch (type) {
      case ExerciseType.recognition:
      case ExerciseType.readingComp:
      case ExerciseType.listening:
        return options.isNotEmpty;
      case ExerciseType.production:
      case ExerciseType.recall:
      case ExerciseType.conjugationDrill:
        return false;
    }
  }
}
