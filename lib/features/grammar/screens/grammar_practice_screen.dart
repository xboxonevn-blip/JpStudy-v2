import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/grammar_repository.dart';
import '../../../data/db/app_database.dart';
import '../widgets/sentence_builder_widget.dart';
import '../widgets/cloze_test_widget.dart';
import '../widgets/multiple_choice_widget.dart';
import '../services/grammar_question_generator.dart';
import '../../../theme/app_theme_v2.dart';
import '../../common/widgets/clay_button.dart';

enum GrammarPracticeMode { normal, ghost }

class GrammarPracticeScreen extends ConsumerStatefulWidget {
  final List<int>? initialIds; // Optional: practice specific points
  final GrammarPracticeMode mode; // Practice Mode

  const GrammarPracticeScreen({
    super.key, 
    this.initialIds,
    this.mode = GrammarPracticeMode.normal,
  });

  @override
  ConsumerState<GrammarPracticeScreen> createState() => _GrammarPracticeScreenState();
}

class _GrammarPracticeScreenState extends ConsumerState<GrammarPracticeScreen> {
  int _currentIndex = 0;
  final List<GeneratedQuestion> _questions = [];
  bool _isLoading = true;
  int _score = 0;
  bool _isAnswered = false; // To prevent multiple submissions per card

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final repo = ref.read(grammarRepositoryProvider);
    List<GrammarPoint> points;
    
    if (widget.initialIds != null && widget.initialIds!.isNotEmpty) {
       // Fetch specific points
       points = await (repo.db.select(repo.db.grammarPoints)..where((t) => t.id.isIn(widget.initialIds!))).get();
    } else if (widget.mode == GrammarPracticeMode.ghost) {
       // Fetch Ghost Points
       points = await repo.fetchGhostPoints();
    } else {
       // Fetch due points
       points = await repo.fetchDuePoints();
       if (points.isEmpty) {
         // Fallback: fetch random 5 learned or any points for practice if nothing due
         // For now, just show empty
       }
    }

    // If ghost mode and no ghosts, maybe fallback? 
    // Usually invalid state if we checked before nav, but handle gracefully.
    
    final details = <({GrammarPoint point, List<GrammarExample> examples})>[];
    for (final point in points) {
      final detail = await repo.getGrammarDetail(point.id);
      if (detail != null && detail.examples.isNotEmpty) {
        details.add(detail);
      }
    }

    // Fetch potential distractors (e.g. 20 random points from same level if possible, or just all)
    // For simplicity, fetch all points from the same levels as the target points
    final levels = points.map((p) => p.jlptLevel).toSet().toList();
    List<GrammarPoint> distractorPool = [];
    if (levels.isNotEmpty) {
       // Since we have N5/N4, just fetch all for now or optimize later
       // repo.getGrammarPointsByLevel(level) - we need to iterate
       for (final level in levels) {
          final levelPoints = await repo.fetchPointsByLevel(level);
          distractorPool.addAll(levelPoints);
       }
    }

    // Generate questions using the service
    final generated = GrammarQuestionGenerator.generateQuestions(
      details, 
      allPoints: distractorPool,
    );
    
    // Customize for Ghost Mode if needed (e.g. force specific types)
    // The generator produces multiple types per point sometimes. 
    // We might want to limit to 1 question per point for SRS.
    // For now, just take all generated. It adds variety.
    
    _questions.addAll(generated);
    _questions.shuffle(); // Shuffle order

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onAnswer(bool isCorrect) {
    if (_isAnswered) return;
    setState(() {
      _isAnswered = true;
    });

    if (isCorrect) _score++;
    
    // Update SRS in background
    final q = _questions[_currentIndex];
    ref.read(grammarRepositoryProvider).recordReview(
      grammarId: q.point.id,
      quality: isCorrect ? 5 : 0,
    );

    // Provide immediate feedback before moving on
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_currentIndex < _questions.length - 1) {
          setState(() {
            _currentIndex++;
            _isAnswered = false;
          });
        } else {
          _showSummary();
        }
      }
    });
  }

  void _showSummary() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Session Complete!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            Text('You got $_score out of ${_questions.length} correct.', textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Center(
            child: SizedBox(
               width: 150,
               child: ClayButton(
                label: 'Finish',
                onPressed: () {
                  context.pop(); // close dialog
                  context.pop(); // back to grammar list
                },
                style: ClayButtonStyle.primary,
                isExpanded: true,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_questions.isEmpty) {
       return Scaffold(
         appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
         body: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(Icons.sentiment_satisfied_alt, size: 80, color: AppThemeV2.primary),
               const SizedBox(height: 16),
               Text(
                 widget.mode == GrammarPracticeMode.ghost 
                   ? 'No mistakes to review!' 
                   : 'Zero items due for review!', 
                 style: TextStyle(fontSize: 18, color: AppThemeV2.textSub, fontWeight: FontWeight.bold)
               ),
               const SizedBox(height: 32),
               SizedBox(
                 width: 200,
                 child: ClayButton(
                   label: 'GO BACK',
                   onPressed: () => context.pop(),
                   style: ClayButtonStyle.secondary,
                   isExpanded: true,
                 ),
               ),
             ],
           ),
         ),
       );
    }

    final q = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.mode == GrammarPracticeMode.ghost ? 'FIX MISTAKES' : 'PRACTICE',
          style: TextStyle(
            color: AppThemeV2.textSub,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: AppThemeV2.textSub), 
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              _buildProgressBar(progress),
              const SizedBox(height: 32),
              Expanded(
                child: _buildQuestionContent(q),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 16,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppThemeV2.neutral.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: AppThemeV2.primary,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionContent(GeneratedQuestion q) {
    switch (q.type) {
      case GrammarQuestionType.sentenceBuilder:
        return SentenceBuilderWidget(
          prompt: q.explanation ?? 'Arrange the sentence',
          correctWords: q.options, // In generator, options are the chars
          shuffledWords: List.of(q.options)..shuffle(), 
          onCheck: _onAnswer,
          onReset: () {},
        );
      case GrammarQuestionType.cloze:
        return ClozeTestWidget(
          sentenceTemplate: q.question,
          options: q.options,
          correctOption: q.correctAnswer,
          onCheck: (isCorrect, _) => _onAnswer(isCorrect),
        );
      case GrammarQuestionType.multipleChoice:
        return MultipleChoiceWidget(
          question: q.question,
          options: q.options,
          correctAnswer: q.correctAnswer, 
          onAnswer: _onAnswer,
        );
    }
  }
}
