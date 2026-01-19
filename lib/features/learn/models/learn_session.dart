import 'question.dart';

/// Represents a Learn Mode session
class LearnSession {
  final String sessionId;
  final int lessonId;
  final DateTime startedAt;
  DateTime? completedAt;
  
  final List<Question> questions;
  final List<QuestionResult> results;
  
  int currentRound;
  int currentQuestionIndex;

  LearnSession({
    required this.sessionId,
    required this.lessonId,
    required this.startedAt,
    this.completedAt,
    required this.questions,
    List<QuestionResult>? results,
    this.currentRound = 1,
    this.currentQuestionIndex = 0,
  }) : results = results ?? [];

  /// Total questions in session
  int get totalQuestions => questions.length;

  /// Questions answered so far
  int get answeredCount => results.length;

  /// Number of correct answers
  int get correctCount => results.where((r) => r.isCorrect).length;

  /// Number of wrong answers
  int get wrongCount => results.where((r) => !r.isCorrect).length;

  /// Current accuracy percentage
  double get accuracy {
    if (answeredCount == 0) return 0.0;
    return correctCount / answeredCount;
  }

  /// Progress percentage (0.0 - 1.0)
  double get progress {
    if (totalQuestions == 0) return 0.0;
    return answeredCount / totalQuestions;
  }

  /// Current question
  Question? get currentQuestion {
    if (currentQuestionIndex >= questions.length) return null;
    return questions[currentQuestionIndex];
  }

  /// Is session complete?
  bool get isComplete => completedAt != null;

  /// Total XP earned
  int get totalXP => results.fold(0, (sum, r) => sum + r.xpEarned);

  /// Total time spent
  Duration get totalTime {
    if (completedAt == null) {
      return DateTime.now().difference(startedAt);
    }
    return completedAt!.difference(startedAt);
  }

  /// Terms that need more practice (answered wrong)
  List<int> get weakTermIds {
    return results
        .where((r) => !r.isCorrect)
        .map((r) => r.question.targetItem.id)
        .toSet()
        .toList();
  }

  /// Terms that are mastered (answered correct 3+ times)
  final Map<int, int> _correctCountByTerm = {};
  
  void recordResult(QuestionResult result) {
    results.add(result);
    
    // Track correct count per term
    if (result.isCorrect) {
      final termId = result.question.targetItem.id;
      _correctCountByTerm[termId] = (_correctCountByTerm[termId] ?? 0) + 1;
    }
  }

  /// Check if a term is mastered (3+ consecutive correct)
  bool isTermMastered(int termId) {
    return (_correctCountByTerm[termId] ?? 0) >= 3;
  }

  /// Get terms not yet mastered
  List<int> get unmasteredTermIds {
    final allTermIds = questions.map((q) => q.targetItem.id).toSet();
    return allTermIds.where((id) => !isTermMastered(id)).toList();
  }

  LearnSession copyWith({
    String? sessionId,
    int? lessonId,
    DateTime? startedAt,
    DateTime? completedAt,
    List<Question>? questions,
    List<QuestionResult>? results,
    int? currentRound,
    int? currentQuestionIndex,
  }) {
    return LearnSession(
      sessionId: sessionId ?? this.sessionId,
      lessonId: lessonId ?? this.lessonId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      questions: questions ?? this.questions,
      results: results ?? this.results,
      currentRound: currentRound ?? this.currentRound,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    );
  }
}
