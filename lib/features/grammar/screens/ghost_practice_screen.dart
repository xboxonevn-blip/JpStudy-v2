import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_language.dart';
import '../../../core/language_provider.dart';
import '../../../data/db/app_database.dart';
import '../../../data/repositories/lesson_repository.dart';

class GhostPracticeScreen extends ConsumerStatefulWidget {
  final List<GrammarPointData> ghosts;

  const GhostPracticeScreen({super.key, required this.ghosts});

  @override
  ConsumerState<GhostPracticeScreen> createState() => _GhostPracticeScreenState();
}

class _GhostPracticeScreenState extends ConsumerState<GhostPracticeScreen> {
  late Future<List<_QuizItem>> _quizFuture;
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedOptionIndex;

  @override
  void initState() {
    super.initState();
    _quizFuture = _generateQuiz();
  }

  Future<List<_QuizItem>> _generateQuiz() async {
    final repo = ref.read(lessonRepositoryProvider);
    final quizItems = <_QuizItem>[];

    for (final ghost in widget.ghosts) {
      // Fetch 3 distractors
      final distractors = await repo.fetchRandomGrammarPoints(
        ghost.point.jlptLevel,
        3,
        excludeIds: [ghost.point.id],
      );

      final options = [ghost.point, ...distractors];
      options.shuffle();

      quizItems.add(_QuizItem(
        target: ghost.point,
        options: options,
      ));
    }
    
    // Shuffle the questions order
    quizItems.shuffle();
    return quizItems;
  }

  void _handleAnswer(int optionIndex, _QuizItem item) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedOptionIndex = optionIndex;
      if (item.options[optionIndex].id == item.target.id) {
        _score++;
      }
    });
  }

  void _nextQuestion(int total) {
    if (_currentIndex < total - 1) {
      setState(() {
        _currentIndex++;
        _answered = false;
        _selectedOptionIndex = null;
      });
    } else {
      _showResults(total);
    }
  }

  void _showResults(int total) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Practice Complete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'You scored $_score / $total',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); // Close dialog
              context.pop(); // Close screen
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  Future<void> _markAsMastered(int grammarId) async {
    await ref.read(lessonRepositoryProvider).markGrammarAsMastered(grammarId);
    ref.invalidate(grammarGhostsProvider); // Refresh the ghost list
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marked as mastered. Removed from ghosts.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final isVietnamese = language == AppLanguage.vi;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghost Practice'),
      ),
      body: FutureBuilder<List<_QuizItem>>(
        future: _quizFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final quizItems = snapshot.data!;
          if (quizItems.isEmpty) {
            return const Center(child: Text('No questions generated.'));
          }

          final item = quizItems[_currentIndex];
          final target = item.target;
          final questionText = isVietnamese
              ? (target.explanationVi ?? target.explanation)
              : (target.explanationEn ?? target.explanation);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / quizItems.length,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 24),
                Text(
                  'Question ${_currentIndex + 1}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Which grammar point matches this explanation?',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    questionText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Spacer(),
                ...List.generate(item.options.length, (index) {
                  final option = item.options[index];
                  final isSelected = _selectedOptionIndex == index;
                  final isCorrect = option.id == target.id;
                  
                  Color? cardColor;
                  if (_answered) {
                    if (isCorrect) {
                      cardColor = Colors.green.shade100;
                    } else if (isSelected) {
                      cardColor = Colors.red.shade100;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => _handleAnswer(index, item),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor ?? Theme.of(context).cardColor,
                          border: Border.all(
                            color: _answered && isCorrect ? Colors.green : Colors.grey.shade300,
                            width: _answered && isCorrect ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          option.grammarPoint,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                if (_answered)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () => _nextQuestion(quizItems.length),
                        child: Text(_currentIndex < quizItems.length - 1 ? 'Next Question' : 'Finish'),
                      ),
                      TextButton.icon(
                        onPressed: () => _markAsMastered(target.id),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Mark as Mastered (Remove Ghost)'),
                        style: TextButton.styleFrom(foregroundColor: Colors.green),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuizItem {
  final GrammarPoint target;
  final List<GrammarPoint> options;

  _QuizItem({required this.target, required this.options});
}
