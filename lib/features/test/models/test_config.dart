import '../../learn/models/question_type.dart';

/// Configuration for a test session
class TestConfig {
  final int questionCount;
  final List<QuestionType> enabledTypes;
  final int? timeLimitMinutes; // null = no time limit
  final bool shuffleQuestions;
  final bool showCorrectAfterWrong;

  const TestConfig({
    this.questionCount = 20,
    this.enabledTypes = const [
      QuestionType.multipleChoice,
      QuestionType.trueFalse,
      QuestionType.fillBlank,
    ],
    this.timeLimitMinutes,
    this.shuffleQuestions = true,
    this.showCorrectAfterWrong = true,
  });

  TestConfig copyWith({
    int? questionCount,
    List<QuestionType>? enabledTypes,
    int? timeLimitMinutes,
    bool clearTimeLimit = false,
    bool? shuffleQuestions,
    bool? showCorrectAfterWrong,
  }) {
    return TestConfig(
      questionCount: questionCount ?? this.questionCount,
      enabledTypes: enabledTypes ?? this.enabledTypes,
      timeLimitMinutes: clearTimeLimit ? null : (timeLimitMinutes ?? this.timeLimitMinutes),
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
      showCorrectAfterWrong: showCorrectAfterWrong ?? this.showCorrectAfterWrong,
    );
  }
}
