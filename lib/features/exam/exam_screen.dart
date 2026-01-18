import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/models/vocab_item.dart';
import 'package:jpstudy/data/repositories/content_repository.dart';
import 'package:jpstudy/features/exam/logic/quiz_engine.dart';

class ExamScreen extends ConsumerStatefulWidget {
  const ExamScreen({super.key});

  @override
  ConsumerState<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends ConsumerState<ExamScreen> {
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _quizStarted = false;
  bool _quizCompleted = false;
  int? _selectedOptionIndex;
  bool _isChecked = false;

  void _startQuiz(List<VocabItem> allVocab) {
    // Convert VocabData to VocabItem is needed if repository returns VocabData
    // But we are doing it inside the build or here.
    // The repository returns VocabData, so we will map it here.
    final engine = QuizEngine(allVocab);
    setState(() {
      _questions = engine.generateQuiz(10); // Generate 10 questions
      _currentIndex = 0;
      _score = 0;
      _quizStarted = true;
      _quizCompleted = false;
      _resetQuestionState();
    });
  }

  void _resetQuestionState() {
    _selectedOptionIndex = null;
    _isChecked = false;
    _typingController.clear();
    _isTypingCorrect = false;
  }

  void _checkAnswer() {
    if (_selectedOptionIndex == null) return;
    
    final currentQuestion = _questions[_currentIndex];
    final isCorrect = _selectedOptionIndex == currentQuestion.correctOptionIndex;
    
    setState(() {
      _isChecked = true;
      if (isCorrect) {
        _score++;
      }
      // Save progress
      ref.read(contentRepositoryProvider).updateProgress(
            currentQuestion.correctItem.id,
            isCorrect,
          );
    });

    // Auto advance after short delay
    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _resetQuestionState();
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider);
    final levelSuffix = level == null ? '' : ' (${level.shortLabel})';

    return Scaffold(
      appBar: AppBar(title: Text('${language.examTitle}$levelSuffix')),
      body: level == null
          ? Center(child: Text(language.selectLevelToViewVocab))
          : _buildBody(level),
    );
  }

  Widget _buildBody(StudyLevel level) {
    final vocabAsync = ref.watch(vocabPreviewProvider(level.shortLabel));

    return vocabAsync.when(
      data: (dataItems) {
        if (dataItems.isEmpty) {
          return const Center(child: Text("No vocabulary available for this level."));
        }
        
        // Map VocabData to VocabItem
        final items = dataItems.map((e) => VocabItem(
          id: e.id,
          term: e.term,
          reading: e.reading,
          meaning: e.meaning,
          level: e.level,
        )).toList();

        if (!_quizStarted) {
          return Center(
            child: ElevatedButton.icon(
              onPressed: () => _startQuiz(items),
              icon: const Icon(Icons.play_arrow),
              label: const Text("Start Quiz"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          );
        }

        if (_quizCompleted) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
                const SizedBox(height: 16),
                Text(
                  "Quiz Completed!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  "Score: $_score / ${_questions.length}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _startQuiz(items),
                  child: const Text("Restart Quiz"),
                ),
              ],
            ),
          );
        }

        return _buildQuestionView();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("Error: $error")),
    );
  }

  Widget _buildQuestionView() {
    final question = _questions[_currentIndex];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            "Question ${_currentIndex + 1} of ${_questions.length}",
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 32),
          Text(
            question.correctItem.term,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          // For MCQ, we might show reading as hint, but for Typing, we want to test Reading.
          // Let's decide: 
          // If Typing: Show Term -> Type Reading.
          // If MCQ: Show Term -> Select Meaning.
          if (question.type == QuestionType.multipleChoice && question.correctItem.reading != null) ...[
             const SizedBox(height: 8),
             Text(
              question.correctItem.reading!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
          ],
           
          const SizedBox(height: 48),

          if (question.type == QuestionType.multipleChoice)
            ...List.generate(question.options.length, (index) {
              final option = question.options[index];
              final isSelected = _selectedOptionIndex == index;
              final isCorrect = index == question.correctOptionIndex;
              
              Color? backgroundColor;
              if (_isChecked) {
                if (isCorrect) {
                  backgroundColor = Colors.green.shade100;
                } else if (isSelected) {
                  backgroundColor = Colors.red.shade100;
                }
              } else if (isSelected) {
                 backgroundColor = Theme.of(context).colorScheme.primaryContainer;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: _isChecked ? null : () {
                    setState(() {
                      _selectedOptionIndex = index;
                      _checkAnswer(); 
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(
                        color: _isChecked && isCorrect ? Colors.green : (_isChecked && isSelected ? Colors.red : Colors.grey.shade300),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.transparent,
                          child: Text("${String.fromCharCode(65 + index)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), // A, B, C, D
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        if (_isChecked && isCorrect)
                          const Icon(Icons.check_circle, color: Colors.green),
                        if (_isChecked && isSelected && !isCorrect)
                          const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            })
          else 
            _buildTypingInput(question),
        ],
      ),
    );
  }

  Widget _buildTypingInput(QuizQuestion question) {
     return Column(
       children: [
         const Text("Type the reading (Hiragana/Katakana):", style: TextStyle(fontWeight: FontWeight.bold)),
         const SizedBox(height: 16),
         TextField(
           controller: _typingController,
           enabled: !_isChecked,
           decoration: InputDecoration(
             border: const OutlineInputBorder(),
             hintText: "e.g. わたし",
             suffixIcon: _isChecked
                 ? Icon(
                     _isTypingCorrect ? Icons.check_circle : Icons.cancel,
                     color: _isTypingCorrect ? Colors.green : Colors.red,
                   )
                 : null,
           ),
           onSubmitted: (_) => _checkTypingAnswer(),
         ),
         const SizedBox(height: 16),
         if (!_isChecked)
           ElevatedButton(
             onPressed: _checkTypingAnswer,
             child: const Text("Submit Answer"),
           ),
         if (_isChecked && !_isTypingCorrect)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text("Correct Answer:", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  Text(question.correctItem.reading ?? question.correctItem.meaning, style: const TextStyle(fontSize: 18)),
                ],
              ),
            )
       ],
     );
  }

  final TextEditingController _typingController = TextEditingController();
  bool _isTypingCorrect = false;

  void _checkTypingAnswer() {
    if (_isChecked) return;
    
    final question = _questions[_currentIndex];
    final input = _typingController.text.trim();
    final correct = question.correctItem.reading ?? "";
    
    // Strict match for now
    final isCorrect = input == correct;

    setState(() {
      _isChecked = true;
      _isTypingCorrect = isCorrect;
      if (isCorrect) {
        _score++;
      }
      
      // Save progress
      ref.read(contentRepositoryProvider).updateProgress(
        question.correctItem.id,
        isCorrect,
      );
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

}

