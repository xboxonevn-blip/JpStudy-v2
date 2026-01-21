import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/grammar_repository.dart';
import '../../../data/db/app_database.dart';
import '../widgets/sentence_builder_widget.dart';
import '../widgets/cloze_test_widget.dart';
import '../services/grammar_question_generator.dart';

class GrammarPracticeScreen extends ConsumerStatefulWidget {
  final List<int>? initialIds; // Optional: practice specific points

  const GrammarPracticeScreen({super.key, this.initialIds});

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
    } else {
       // Fetch due points
       points = await repo.fetchDuePoints();
       if (points.isEmpty) {
         // Fallback: fetch random 5 learned or any points for practice if nothing due
         // For now, just show empty
       }
    }

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
    _questions.addAll(generated);

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
        title: const Text('Practice Complete!'),
        content: Text('You got $_score out of ${_questions.length} correct.'),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); // close dialog
              context.pop(); // back to grammar list
            },
            child: const Text('Finish'),
          ),
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
         appBar: AppBar(),
         body: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Icon(Icons.sentiment_satisfied_alt, size: 64, color: Colors.blue),
               const SizedBox(height: 16),
               const Text('Zero items due for review!', style: TextStyle(fontSize: 18)),
               const SizedBox(height: 24),
               ElevatedButton(onPressed: () => context.pop(), child: const Text('Go Back')),
             ],
           ),
         ),
       );
    }

    final q = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Practice ${(_currentIndex + 1)}/${_questions.length}'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(
              height: 8,
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / _questions.length,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: _buildQuestionContent(q),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionContent(GeneratedQuestion q) {
    switch (q.type) {
      case GrammarQuestionType.sentenceBuilder:
        return SentenceBuilderWidget(
          correctWords: q.options, // In generator, options are the chars
          shuffledWords: List.of(q.options)..shuffle(), 
          onCheck: _onAnswer,
          onReset: () {},
        );
      case GrammarQuestionType.cloze:
        // Use regex or string manipulation to create the template
        // The generator already provides: 
        // q.question -> "Example with ___"
        // q.options -> ["Correct", "Wrong1", ...]
        return ClozeTestWidget(
          sentenceTemplate: q.question,
          options: q.options,
          correctOption: q.correctAnswer,
          onCheck: (isCorrect, _) => _onAnswer(isCorrect),
        );
      default:
        return const Center(child: Text('Unsupported question type'));
    }
  }
}
