import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/vocab_item.dart';
import '../../learn/models/question.dart';
import '../../learn/models/question_type.dart';
import '../../learn/services/question_generator.dart';
import '../../learn/widgets/fill_blank_widget.dart';
import '../../learn/widgets/multiple_choice_widget.dart';
import '../../learn/widgets/true_false_widget.dart';
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
  late TestSession _session;
  String? _selectedAnswer;
  bool? _selectedTrueFalse;
  bool _showResult = false;
  bool _isCorrect = false;
  Timer? _timer;
  int _secondsRemaining = 0;

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
    final generator = QuestionGenerator();
    final questions = generator.generateQuestions(
      items: widget.items,
      enabledTypes: widget.config.enabledTypes,
      count: widget.config.questionCount,
    );

    if (widget.config.shuffleQuestions) {
      questions.shuffle();
    }

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
    final question = _session.currentQuestion;

    if (question == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Test: ${widget.lessonTitle}'),
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
            tooltip: 'Flag for review',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: _session.progress,
            backgroundColor: Colors.grey[200],
            minHeight: 6,
          ),

          // Question navigator
          _buildQuestionNavigator(),

          // Question content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildQuestionWidget(question),
            ),
          ),

          // Navigation buttons
          _buildNavigationButtons(),
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

  Widget _buildQuestionWidget(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question number
        Text(
          'Question ${_session.currentQuestionIndex + 1} of ${_session.totalQuestions}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),

        // Question content
        _buildQuestionContent(question),
      ],
    );
  }

  Widget _buildQuestionContent(Question question) {
    switch (question.type) {
      case QuestionType.multipleChoice:
      case QuestionType.audioMatch:
        return MultipleChoiceWidget(
          question: question,
          selectedAnswer: _selectedAnswer,
          showResult: _showResult && widget.config.showCorrectAfterWrong,
          onSelect: _handleMultipleChoiceSelect,
        );

      case QuestionType.trueFalse:
        return TrueFalseWidget(
          question: question,
          selectedAnswer: _selectedTrueFalse,
          showResult: _showResult && widget.config.showCorrectAfterWrong,
          onSelect: _handleTrueFalseSelect,
        );

      case QuestionType.fillBlank:
        return FillBlankWidget(
          question: question,
          showResult: _showResult && widget.config.showCorrectAfterWrong,
          isCorrect: _isCorrect,
          onSubmit: _handleFillBlankSubmit,
        );
    }
  }

  Widget _buildNavigationButtons() {
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
                label: const Text('Previous'),
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
                isLast ? 'Submit Test' : 'Next',
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
  }

  void _handleTrueFalseSelect(bool answer) {
    _session.submitAnswer(answer ? 'true' : 'false');
    setState(() {
      _selectedTrueFalse = answer;
      _showResult = true;
      _isCorrect = _session.currentQuestion!.checkAnswer(answer ? 'true' : 'false');
    });
  }

  void _handleFillBlankSubmit(String answer) {
    _session.submitAnswer(answer);
    setState(() {
      _showResult = true;
      _isCorrect = _session.currentQuestion!.checkAnswer(answer);
    });
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Test?'),
        content: unanswered > 0
            ? Text('You have $unanswered unanswered questions. Submit anyway?')
            : const Text('Are you sure you want to submit your test?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitTest();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitTest() async {
    _timer?.cancel();
    _session.completedAt = DateTime.now();

    // Save to database
    await ref.read(testHistoryServiceProvider).saveTest(_session);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TestResultsScreen(session: _session),
      ),
    );
  }
}
