import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_language.dart';
import '../../../core/language_provider.dart';
import '../../../data/models/vocab_item.dart';
import '../../learn/models/question.dart';
import '../../learn/models/question_type.dart';
import '../../learn/services/question_generator.dart';
import '../../learn/widgets/fill_blank_widget.dart';
import '../../learn/widgets/multiple_choice_widget.dart';
import '../../learn/widgets/true_false_widget.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../mistakes/repositories/mistake_repository.dart';
import '../models/test_config.dart';
import '../models/test_session.dart';
import '../providers/test_providers.dart';
import 'test_results_screen.dart';

class TestScreen extends ConsumerStatefulWidget {
  final List<VocabItem> items;
  final int lessonId;
  final String lessonTitle;
  final TestConfig config;

  const TestScreen({
    super.key,
    required this.items,
    required this.lessonId,
    required this.lessonTitle,
    required this.config,
  });

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  final QuestionGenerator _questionGenerator = QuestionGenerator();
  final Random _random = Random();
  late TestSession _session;
  String? _selectedAnswer;
  bool? _selectedTrueFalse;
  bool _showResult = false;
  bool _isCorrect = false;
  Timer? _timer;
  int _secondsRemaining = 0;
  int _adaptiveAdded = 0;
  int _adaptiveMaxExtra = 0;
  final Map<int, Set<QuestionType>> _usedTypesByItem = {};
  final Map<int, int> _adaptiveRepeatCount = {};
  final Map<int, int> _adaptiveCorrectStreak = {};
  final Set<int> _adaptiveCompleted = {};

  @override
  void initState() {
    super.initState();
    _startTest();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTest() {
    final language = ref.read(appLanguageProvider);
    final questions = _questionGenerator.generateQuestions(
      items: widget.items,
      enabledTypes: widget.config.enabledTypes,
      count: widget.config.questionCount,
      language: language,
    );

    if (widget.config.shuffleQuestions) {
      questions.shuffle();
    }

    _adaptiveAdded = 0;
    _adaptiveRepeatCount.clear();
    _adaptiveCorrectStreak.clear();
    _adaptiveCompleted.clear();
    _usedTypesByItem.clear();
    for (final q in questions) {
      _usedTypesByItem.putIfAbsent(q.targetItem.id, () => <QuestionType>{})
          .add(q.type);
    }
    _adaptiveMaxExtra = (widget.config.questionCount * 0.3).floor().clamp(0, 20);

    _session = TestSession(
      sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
      lessonId: widget.lessonId,
      startedAt: DateTime.now(),
      questions: questions,
      timeLimitMinutes: widget.config.timeLimitMinutes,
    );

    // Start timer if time limit exists
    if (widget.config.timeLimitMinutes != null) {
      _secondsRemaining = widget.config.timeLimitMinutes! * 60;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
      });

      if (_secondsRemaining <= 0) {
        timer.cancel();
        _submitTest();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final question = _session.currentQuestion;

    if (question == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${language.testModeLabel}: ${widget.lessonTitle}'),
        actions: [
          // Timer display
          if (widget.config.timeLimitMinutes != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: _buildTimerDisplay(),
              ),
            ),
          // Flag button
          IconButton(
            icon: Icon(
              _session.isFlagged(_session.currentQuestionIndex)
                  ? Icons.flag
                  : Icons.flag_outlined,
              color: _session.isFlagged(_session.currentQuestionIndex)
                  ? Colors.orange
                  : null,
            ),
            onPressed: () {
              setState(() {
                _session.toggleFlag(_session.currentQuestionIndex);
              });
            },
            tooltip: language.flagForReviewLabel,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: _session.progress,
              backgroundColor: Colors.grey[200],
            ),
          ),

          // Question navigator
          _buildQuestionNavigator(),

          // Question content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(question.id),
                  child: _buildQuestionWidget(question, language),
                ),
              ),
            ),
          ),

          // Navigation buttons
          _buildNavigationButtons(language),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay() {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    final isLow = _secondsRemaining < 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLow ? Colors.red.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 18,
            color: isLow ? Colors.red : null,
          ),
          const SizedBox(width: 4),
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isLow ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionNavigator() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _session.totalQuestions,
        itemBuilder: (context, index) {
          final isAnswered = index < _session.answers.length &&
              _session.answers[index].userAnswer != null;
          final isCurrent = index == _session.currentQuestionIndex;
          final isFlagged = _session.isFlagged(index);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _goToQuestion(index),
              child: Container(
                width: 36,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? Theme.of(context).primaryColor
                      : isAnswered
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: isFlagged
                      ? Border.all(color: Colors.orange, width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? Colors.white : null,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionWidget(Question question, AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question number
        Text(
          language.testProgressLabel(
            _session.currentQuestionIndex + 1,
            _session.totalQuestions,
          ),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),

        // Question content
        _buildQuestionContent(question, language),
      ],
    );
  }

  Widget _buildQuestionContent(Question question, AppLanguage language) {
    switch (question.type) {
      case QuestionType.multipleChoice:
        return MultipleChoiceWidget(
          question: question,
          selectedAnswer: _selectedAnswer,
          showResult: _showResult && widget.config.showCorrectAfterWrong,
          language: language,
          onSelect: _handleMultipleChoiceSelect,
        );

      case QuestionType.trueFalse:
        return TrueFalseWidget(
          question: question,
          selectedAnswer: _selectedTrueFalse,
          showResult: _showResult && widget.config.showCorrectAfterWrong,
          language: language,
          onSelect: _handleTrueFalseSelect,
        );

      case QuestionType.fillBlank:
        return FillBlankWidget(
          question: question,
          showResult: _showResult && widget.config.showCorrectAfterWrong,
          isCorrect: _isCorrect,
          language: language,
          onSubmit: _handleFillBlankSubmit,
        );
    }
  }

  Widget _buildNavigationButtons(AppLanguage language) {
    final isFirst = _session.currentQuestionIndex == 0;
    final isLast = _session.currentQuestionIndex == _session.totalQuestions - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (!isFirst)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousQuestion,
                icon: const Icon(Icons.arrow_back),
                label: Text(language.previousLabel),
              ),
            ),
          if (!isFirst) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isLast ? _showSubmitDialog : _nextQuestion,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isLast ? language.submitTestLabel : language.nextLabel,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMultipleChoiceSelect(String answer) {
    _session.submitAnswer(answer);
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _isCorrect = _session.currentQuestion!.checkAnswer(answer);
    });

    _maybeQueueAdaptiveQuestion(_session.currentQuestion!, _isCorrect);
    if (widget.config.showCorrectAfterWrong) {
      // Audio removed
    }
  }

  void _handleTrueFalseSelect(bool answer) {
    _session.submitAnswer(answer ? 'true' : 'false');
    setState(() {
      _selectedTrueFalse = answer;
      _showResult = true;
      _isCorrect = _session.currentQuestion!.checkAnswer(answer ? 'true' : 'false');
    });

    _maybeQueueAdaptiveQuestion(_session.currentQuestion!, _isCorrect);
    if (widget.config.showCorrectAfterWrong) {
      // Audio removed
    }
  }

  void _handleFillBlankSubmit(String answer) {
    _session.submitAnswer(answer);
    setState(() {
      _showResult = true;
      _isCorrect = _session.currentQuestion!.checkAnswer(answer);
    });

    _maybeQueueAdaptiveQuestion(_session.currentQuestion!, _isCorrect);
    if (widget.config.showCorrectAfterWrong) {
      // Audio removed
    }
  }

  void _maybeQueueAdaptiveQuestion(Question question, bool isCorrect) {
    if (!widget.config.adaptiveTesting) return;

    final item = question.targetItem;
    final currentStreak = _adaptiveCorrectStreak[item.id] ?? 0;
    if (isCorrect) {
      final nextStreak = currentStreak + 1;
      _adaptiveCorrectStreak[item.id] = nextStreak;
      if (nextStreak >= 2) {
        _adaptiveCompleted.add(item.id);
      }
      return;
    }

    _adaptiveCorrectStreak[item.id] = 0;
    if (_adaptiveCompleted.contains(item.id)) return;
    if (_adaptiveAdded >= _adaptiveMaxExtra) return;
    if (widget.config.enabledTypes.length < 2) return;
    final currentRepeats = _adaptiveRepeatCount[item.id] ?? 0;
    if (currentRepeats >= 2) return;
    final repeatChance = currentRepeats == 0 ? 1.0 : 0.6;
    if (_random.nextDouble() > repeatChance) return;

    final usedTypes = _usedTypesByItem.putIfAbsent(item.id, () => <QuestionType>{})
      ..add(question.type);

    final availableTypes = widget.config.enabledTypes
        .where((type) => !usedTypes.contains(type))
        .toList();
    if (availableTypes.isEmpty) return;

    final nextType = availableTypes[_random.nextInt(availableTypes.length)];
    final newQuestion = _questionGenerator.generateQuestionForItem(
      item: item,
      type: nextType,
      allItems: widget.items,
      language: ref.read(appLanguageProvider),
    );
    if (newQuestion == null) return;

    _session.questions.add(newQuestion);
    usedTypes.add(nextType);
    _adaptiveAdded++;
    _adaptiveRepeatCount.update(item.id, (v) => v + 1, ifAbsent: () => 1);
  }

  void _goToQuestion(int index) {
    setState(() {
      _session.currentQuestionIndex = index;
      _resetQuestionState(index);
    });
  }

  void _previousQuestion() {
    if (_session.currentQuestionIndex > 0) {
      setState(() {
        _session.currentQuestionIndex--;
        _resetQuestionState(_session.currentQuestionIndex);
      });
    }
  }

  void _nextQuestion() {
    if (_session.currentQuestionIndex < _session.totalQuestions - 1) {
      setState(() {
        _session.currentQuestionIndex++;
        _resetQuestionState(_session.currentQuestionIndex);
      });
    }
  }

  void _resetQuestionState(int index) {
    final answer = _session.getAnswer(index);
    _selectedAnswer = answer?.userAnswer;
    _selectedTrueFalse = answer?.userAnswer == 'true'
        ? true
        : answer?.userAnswer == 'false'
            ? false
            : null;
    _showResult = answer?.userAnswer != null;
    _isCorrect = answer?.isCorrect ?? false;
  }

  void _showSubmitDialog() {
    final unanswered = _session.totalQuestions - _session.answeredCount;
    final language = ref.read(appLanguageProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(language.submitTestTitle),
        content: unanswered > 0
            ? Text(language.unansweredSubmitLabel(unanswered))
            : Text(language.submitTestTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitTest();
            },
            child: Text(language.submitTestConfirmLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _submitTest() async {
    _timer?.cancel();
    _session.completedAt = DateTime.now();

    final mistakeRepo = ref.read(mistakeRepositoryProvider);
    for (int i = 0; i < _session.questions.length; i++) {
      final question = _session.questions[i];
      final answer = _session.getAnswer(i);
      if (answer == null || !answer.isCorrect) {
        await mistakeRepo.addMistake(
          type: 'vocab',
          itemId: question.targetItem.id,
        );
      } else {
        await mistakeRepo.markCorrect(
          type: 'vocab',
          itemId: question.targetItem.id,
        );
      }
    }

    // Save to database
    await ref.read(testHistoryServiceProvider).saveTest(_session);
    await ref.read(lessonRepositoryProvider).recordStudyActivity(
      xpDelta: _session.xpEarned,
    );

    // Audio removed

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TestResultsScreen(
          session: _session,
          lessonTitle: widget.lessonTitle,
        ),
      ),
    );
  }
}
