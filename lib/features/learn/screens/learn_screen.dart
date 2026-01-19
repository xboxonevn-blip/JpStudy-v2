import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/vocab_item.dart';
import '../models/question.dart';
import '../models/question_type.dart';
import '../providers/learn_session_provider.dart';
import '../widgets/fill_blank_widget.dart';
import '../widgets/multiple_choice_widget.dart';
import '../widgets/true_false_widget.dart';
import 'learn_summary_screen.dart';

class LearnScreen extends ConsumerStatefulWidget {
  final List<VocabItem> items;
  final int lessonId;
  final String lessonTitle;
  final List<QuestionType>? enabledTypes;

  const LearnScreen({
    super.key,
    required this.items,
    required this.lessonId,
    required this.lessonTitle,
    this.enabledTypes,
  });

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  String? _selectedAnswer;
  bool? _selectedTrueFalse;
  bool _showResult = false;
  bool _isCorrect = false;
  // ignore: unused_field
  DateTime? _questionStartTime;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  void _startSession() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.enabledTypes != null) {
        ref.read(learnSessionProvider.notifier).startSession(
              lessonId: widget.lessonId,
              items: widget.items,
              enabledTypes: widget.enabledTypes!,
            );
      } else {
        ref.read(learnSessionProvider.notifier).startSession(
              lessonId: widget.lessonId,
              items: widget.items,
            );
      }
      _questionStartTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(learnSessionProvider);

    if (session == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = session.currentQuestion;

    if (question == null || session.isComplete) {
      // Navigate to summary
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LearnSummaryScreen(session: session),
          ),
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Learn: ${widget.lessonTitle}'),
        actions: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${session.answeredCount + 1}/${session.totalQuestions}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: session.progress,
              backgroundColor: Colors.grey[200],
            ),
          ),

          // Stats row
          _buildStatsRow(session),

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
                  child: _buildQuestionWidget(question),
                ),
              ),
            ),
          ),

          // Continue button (after answering)
          if (_showResult)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isCorrect ? Colors.green : Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isCorrect ? 'Continue' : 'Got it',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(dynamic session) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.check_circle,
            label: 'Correct',
            value: session.correctCount,
            color: Colors.green,
          ),
          _buildStatItem(
            icon: Icons.cancel,
            label: 'Wrong',
            value: session.wrongCount,
            color: Colors.red,
          ),
          _buildStatItem(
            icon: Icons.percent,
            label: 'Accuracy',
            value: '${(session.accuracy * 100).toInt()}%',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required dynamic value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionWidget(Question question) {
    switch (question.type) {
      case QuestionType.multipleChoice:
      case QuestionType.audioMatch:
        return MultipleChoiceWidget(
          question: question,
          selectedAnswer: _selectedAnswer,
          showResult: _showResult,
          onSelect: _handleMultipleChoiceSelect,
        );

      case QuestionType.trueFalse:
        return TrueFalseWidget(
          question: question,
          selectedAnswer: _selectedTrueFalse,
          showResult: _showResult,
          onSelect: _handleTrueFalseSelect,
        );

      case QuestionType.fillBlank:
        return FillBlankWidget(
          question: question,
          showResult: _showResult,
          isCorrect: _isCorrect,
          onSubmit: _handleFillBlankSubmit,
        );
    }
  }

  void _handleMultipleChoiceSelect(String answer) {
    setState(() {
      _selectedAnswer = answer;
    });
    _submitAnswer(answer);
  }

  void _handleTrueFalseSelect(bool answer) {
    setState(() {
      _selectedTrueFalse = answer;
    });
    _submitAnswer(answer ? 'true' : 'false');
  }

  void _handleFillBlankSubmit(String answer) {
    _submitAnswer(answer);
  }

  void _submitAnswer(String answer) {
    final result = ref.read(learnSessionProvider.notifier).submitAnswer(answer);

    if (result != null) {
      setState(() {
        _showResult = true;
        _isCorrect = result.isCorrect;
      });
    }
  }

  void _handleContinue() {
    ref.read(learnSessionProvider.notifier).nextQuestion();

    setState(() {
      _selectedAnswer = null;
      _selectedTrueFalse = null;
      _showResult = false;
      _isCorrect = false;
      _questionStartTime = DateTime.now();
    });
  }
}
