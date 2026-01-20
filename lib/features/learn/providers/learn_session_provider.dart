import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/database_provider.dart';
import '../../../data/daos/learn_dao.dart';
import '../../../data/daos/achievement_dao.dart';
import '../../../data/models/vocab_item.dart';
import '../models/learn_session.dart';
import '../models/question.dart';
import '../models/question_type.dart';
import '../services/question_generator.dart';
import '../services/learn_session_service.dart';

/// Provider for managing Learn Mode sessions
class LearnSessionNotifier extends StateNotifier<LearnSession?> {
  final QuestionGenerator _questionGenerator = QuestionGenerator();
  final LearnSessionService _learnService;

  LearnSessionNotifier(this._learnService) : super(null);

  /// Start a new learn session
  void startSession({
    required int lessonId,
    required List<VocabItem> items,
    List<QuestionType> enabledTypes = const [
      QuestionType.multipleChoice,
      QuestionType.trueFalse,
      QuestionType.fillBlank,
    ],
  }) {
    final questions = _questionGenerator.generateQuestions(
      items: items,
      enabledTypes: enabledTypes,
      count: items.length,
    );

    state = LearnSession(
      sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
      lessonId: lessonId,
      startedAt: DateTime.now(),
      questions: questions,
    );
  }

  /// Start an adaptive round based on previous performance
  void startAdaptiveRound({
    required List<VocabItem> items,
    required int round,
  }) {
    if (state == null) return;

    final questions = _questionGenerator.generateAdaptiveRound(
      items: items,
      round: round,
      weakTermIds: state!.weakTermIds,
    );

    state = state!.copyWith(
      questions: questions,
      currentRound: round,
      currentQuestionIndex: 0,
    );
  }

  /// Submit answer for current question
  QuestionResult? submitAnswer(String answer) {
    if (state == null || state!.currentQuestion == null) return null;

    final question = state!.currentQuestion!;
    final startTime = DateTime.now().subtract(const Duration(seconds: 5)); // Approximate
    
    final isCorrect = question.checkAnswer(answer);
    final result = QuestionResult(
      question: question,
      userAnswer: answer,
      isCorrect: isCorrect,
      timeTaken: DateTime.now().difference(startTime),
      answeredAt: DateTime.now(),
    );

    // Audio removed

    state!.recordResult(result);
    
    // Notify listeners
    state = state!.copyWith();

    return result;
  }

  /// Move to next question
  void nextQuestion() {
    if (state == null) return;

    if (state!.currentQuestionIndex < state!.questions.length - 1) {
      state = state!.copyWith(
        currentQuestionIndex: state!.currentQuestionIndex + 1,
      );
    } else {
      // Session complete
      _completeSession();
    }
  }

  /// Complete the session
  Future<void> _completeSession() async {
    if (state == null) return;
    
    // Update state first
    state = state!.copyWith(completedAt: DateTime.now());
    
    // Save to database
    await _learnService.saveSession(state!);
    
    // Audio removed
  }

  /// Reset session
  void reset() {
    state = null;
  }
}

/// Provider instance
final learnSessionProvider =
    StateNotifierProvider<LearnSessionNotifier, LearnSession?>((ref) {
  final db = ref.watch(databaseProvider);
  // DAOs are created with the database instance.
  // Assuming DAOs have been added to AppDatabase as accessors, 
  // we could access them via db.learnDao if using generated mixins properly,
  // but simpler independent instantiation is:
  final learnDao = LearnDao(db);
  final achievementDao = AchievementDao(db);
  final service = LearnSessionService(learnDao, achievementDao);
  
  return LearnSessionNotifier(service);
});

/// Provider for question timing
final questionStartTimeProvider = StateProvider<DateTime?>((ref) => null);
