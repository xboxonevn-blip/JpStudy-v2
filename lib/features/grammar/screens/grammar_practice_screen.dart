import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/grammar_repository.dart';
import '../../../data/db/app_database.dart';
import '../widgets/sentence_builder_widget.dart';
import '../widgets/cloze_test_widget.dart';

enum GrammarQuestionType { sentenceBuilder, cloze }

class GrammarPracticeScreen extends ConsumerStatefulWidget {
  final List<int>? initialIds; // Optional: practice specific points

  const GrammarPracticeScreen({super.key, this.initialIds});

  @override
  ConsumerState<GrammarPracticeScreen> createState() => _GrammarPracticeScreenState();
}

class _GrammarPracticeScreenState extends ConsumerState<GrammarPracticeScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  int _score = 0;

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
         // Fallback: fetch some points from current level if nothing due
         // For now, just show empty or message
       }
    }

    for (final point in points) {
      final detail = await repo.getGrammarDetail(point.id);
      if (detail != null && detail.examples.isNotEmpty) {
        // Create a question from one example
        final example = detail.examples.first;
        
        // Decide type: if Japanese is short, maybe cloze. If long, sentence builder.
        // Or just rotate.
        final type = _questions.length % 2 == 0 
            ? GrammarQuestionType.sentenceBuilder 
            : GrammarQuestionType.cloze;

        if (type == GrammarQuestionType.sentenceBuilder) {
          // Simple split by space for now, ideally we need tokenized japanese
          // Mock tokenization: [word, word, word]
          // In real app, we'd use a morphological analyzer or pre-tokenized data
          final words = example.japanese.split(''); // Char by char is safer for JP without analyzer
          _questions.add({
            'type': type,
            'point': point,
            'example': example,
            'correctWords': words,
            'shuffledWords': List.from(words)..shuffle(),
          });
        } else {
          // Cloze: remove the grammar point part from the sentence
          // This is tricky: we need to find where the grammar point is in the example
          // For now, let's just use a stubbed approach
          _questions.add({
            'type': type,
            'point': point,
            'example': example,
            'template': example.japanese.replaceFirst(point.grammarPoint, '{blank}'),
            'options': [point.grammarPoint, 'です', 'ます', 'ない'].shuffled().toList(),
            'correct': point.grammarPoint,
          });
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (_questions.isEmpty) {
          // No questions found
        }
      });
    }
  }

  void _onAnswer(bool isCorrect) {
    if (isCorrect) _score++;
    
    // Update SRS in background
    final q = _questions[_currentIndex];
    ref.read(grammarRepositoryProvider).recordReview(
      grammarId: (q['point'] as GrammarPoint).id,
      quality: isCorrect ? 5 : 0,
    );

    if (_currentIndex < _questions.length - 1) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _currentIndex++;
          });
        }
      });
    } else {
      // Show summary
      Future.delayed(const Duration(milliseconds: 1500), () {
        _showSummary();
      });
    }
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
    final type = q['type'] as GrammarQuestionType;

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
              child: type == GrammarQuestionType.sentenceBuilder
                ? SentenceBuilderWidget(
                    correctWords: List<String>.from(q['correctWords']),
                    shuffledWords: List<String>.from(q['shuffledWords']),
                    onCheck: _onAnswer,
                    onReset: () {},
                  )
                : ClozeTestWidget(
                    sentenceTemplate: q['template'],
                    options: List<String>.from(q['options']),
                    correctOption: q['correct'],
                    onCheck: (isCorrect, _) => _onAnswer(isCorrect),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

extension ListX<T> on List<T> {
  List<T> shuffled() {
    final list = List<T>.from(this);
    list.shuffle();
    return list;
  }
}
