import '../../learn/models/question.dart';
import '../../learn/models/question_type.dart';

/// Represents a complete test session with results
class TestSession {
  final String sessionId;
  final int lessonId;
  final DateTime startedAt;
  DateTime? completedAt;

  final List<Question> questions;
  final List<TestAnswer> answers;
  final Set<int> flaggedQuestions;
  final int? timeLimitMinutes;

  int currentQuestionIndex;

  TestSession({
    required this.sessionId,
    required this.lessonId,
    required this.startedAt,
    this.completedAt,
    required this.questions,
    List<TestAnswer>? answers,
    Set<int>? flaggedQuestions,
    this.timeLimitMinutes,
    this.currentQuestionIndex = 0,
  }) : answers = answers ?? [],
       flaggedQuestions = flaggedQuestions ?? {};

  int get totalQuestions => questions.length;
  int get answeredCount => answers.where((a) => a.userAnswer != null).length;
  int get correctCount => answers.where((a) => a.isCorrect).length;
  int get wrongCount => totalQuestions - correctCount;

  double get score {
    if (totalQuestions == 0) return 0.0;
    return correctCount / totalQuestions * 100;
  }

  double get progress => answeredCount / totalQuestions;

  bool get isComplete => completedAt != null;

  Duration get timeElapsed {
    final endTime = completedAt ?? DateTime.now();
    return endTime.difference(startedAt);
  }

  Duration? get timeRemaining {
    if (timeLimitMinutes == null) return null;
    final limit = Duration(minutes: timeLimitMinutes!);
    final remaining = limit - timeElapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool get isTimeUp => timeRemaining?.inSeconds == 0;

  Question? get currentQuestion {
    if (currentQuestionIndex >= questions.length) return null;
    return questions[currentQuestionIndex];
  }

  /// Get answer for a specific question index
  TestAnswer? getAnswer(int index) {
    if (index >= answers.length) return null;
    return answers[index];
  }

  /// Submit or update answer for current question
  void submitAnswer(String? answer) {
    while (answers.length <= currentQuestionIndex) {
      answers.add(TestAnswer(questionIndex: answers.length));
    }

    final question = questions[currentQuestionIndex];
    final isCorrect = answer != null && question.checkAnswer(answer);

    answers[currentQuestionIndex] = TestAnswer(
      questionIndex: currentQuestionIndex,
      userAnswer: answer,
      isCorrect: isCorrect,
      answeredAt: DateTime.now(),
    );
  }

  void toggleFlag(int index) {
    if (flaggedQuestions.contains(index)) {
      flaggedQuestions.remove(index);
    } else {
      flaggedQuestions.add(index);
    }
  }

  bool isFlagged(int index) => flaggedQuestions.contains(index);

  /// Calculate grade based on score
  String get grade {
    if (score >= 90) return 'A';
    if (score >= 80) return 'B';
    if (score >= 70) return 'C';
    if (score >= 60) return 'D';
    return 'F';
  }

  /// Get breakdown by question type
  Map<QuestionType, TypeBreakdown> get breakdownByType {
    final breakdown = <QuestionType, TypeBreakdown>{};

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final answer = i < answers.length ? answers[i] : null;

      breakdown.putIfAbsent(
        question.type,
        () => TypeBreakdown(type: question.type),
      );

      breakdown[question.type]!.total++;
      if (answer?.isCorrect == true) {
        breakdown[question.type]!.correct++;
      }
    }

    return breakdown;
  }

  /// Get list of weak terms (answered wrong)
  List<int> get weakTermIds {
    final weak = <int>[];
    for (int i = 0; i < answers.length; i++) {
      if (!answers[i].isCorrect || answers[i].userAnswer == null) {
        weak.add(questions[i].targetItem.id);
      }
    }
    for (int i = answers.length; i < questions.length; i++) {
      weak.add(questions[i].targetItem.id);
    }
    return weak;
  }

  /// Calculate XP earned
  int get xpEarned {
    int xp = correctCount * 5;

    // Bonus for high score
    if (score >= 90) {
      xp += 50;
    } else if (score >= 80) {
      xp += 30;
    } else if (score >= 70) {
      xp += 20;
    }

    // Speed bonus (completed in under time limit)
    if (timeLimitMinutes != null && timeElapsed.inMinutes < timeLimitMinutes!) {
      xp += 10;
    }

    return xp;
  }
}

/// Answer record for a single question
class TestAnswer {
  final int questionIndex;
  final String? userAnswer;
  final bool isCorrect;
  final DateTime? answeredAt;

  const TestAnswer({
    required this.questionIndex,
    this.userAnswer,
    this.isCorrect = false,
    this.answeredAt,
  });
}

/// Breakdown of performance by question type
class TypeBreakdown {
  final QuestionType type;
  int total;
  int correct;

  TypeBreakdown({required this.type, this.total = 0, this.correct = 0});

  double get accuracy => total > 0 ? correct / total * 100 : 0;
}
