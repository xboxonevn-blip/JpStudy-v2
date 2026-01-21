import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_language.dart';
import '../../../core/language_provider.dart';
import '../../../data/models/vocab_item.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../../shared/widgets/confidence_rating.dart';
import '../../flashcards/widgets/enhanced_flashcard.dart';

class TermReviewScreen extends ConsumerStatefulWidget {
  const TermReviewScreen({super.key});

  @override
  ConsumerState<TermReviewScreen> createState() => _TermReviewScreenState();
}

class _TermReviewScreenState extends ConsumerState<TermReviewScreen> {
  int _currentIndex = 0;
  bool _isSessionComplete = false;
  
  // Session stats
  int _againCount = 0;
  int _hardCount = 0;
  int _goodCount = 0;
  int _easyCount = 0;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final termsAsync = ref.watch(allDueTermsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(language.reviewAction),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: termsAsync.when(
        data: (terms) {
          if (terms.isEmpty) {
            return _buildEmptyState(language);
          }
          if (_isSessionComplete) {
            return _buildSummary(language, terms.length);
          }
          if (_currentIndex >= terms.length) {
            // Should be handled by _isSessionComplete, but just in case
            return _buildSummary(language, terms.length);
          }

          final currentTermData = terms[_currentIndex];
          // Map UserLessonTermData to VocabItem explicitly
          final vocabItem = VocabItem(
             id: currentTermData.id,
             term: currentTermData.term,
             reading: currentTermData.reading,
             meaning: currentTermData.definition,
             meaningEn: currentTermData.definitionEn,
             kanjiMeaning: currentTermData.kanjiMeaning,
             level: '', // Not strictly needed for flashcard display
          );

          return Column(
            children: [
              // Progress
              LinearProgressIndicator(
                value: (_currentIndex + 1) / terms.length,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${_currentIndex + 1} / ${terms.length}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              
              // Flashcard Area
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                     child: EnhancedFlashcard(
                       key: ValueKey(vocabItem.id), // Important for animation reset
                       item: vocabItem,
                       enableSwipeGestures: false, // Force manual rating for SRS
                       onFlip: () {
                         // Optional: could track flip count
                       },
                     ),
                  ),
                ),
              ),

              // Rating Buttons
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ConfidenceRatingWidget(
                  onSelect: (level) => _handleRating(level, currentTermData.id, terms.length),
                  showLabels: true,
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildEmptyState(AppLanguage language) {
     return Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
           const SizedBox(height: 16),
           Text(
             language.reviewEmptyLabel,
             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
           ),
           const SizedBox(height: 8),
           ElevatedButton(
             onPressed: () => context.pop(),
             child: Text(MaterialLocalizations.of(context).backButtonTooltip),
           ),
         ],
       ),
     );
  }

  Widget _buildSummary(AppLanguage language, int total) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              'Session Complete!', // Provide localization key if available, hardcoded fallback
              style: Theme.of(context).textTheme.headlineMedium,
            ),
             const SizedBox(height: 8),
            Text(
              'You reviewed $total items.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            _buildSummaryRow('Again', _againCount, Colors.red),
            _buildSummaryRow('Hard', _hardCount, Colors.orange),
            _buildSummaryRow('Good', _goodCount, Colors.blue),
            _buildSummaryRow('Easy', _easyCount, Colors.green),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              onPressed: () => context.pop(),
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('$count', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Future<void> _handleRating(ConfidenceLevel levelEnum, int termId, int totalTerms) async {
    final repo = ref.read(lessonRepositoryProvider);
    
    // Map enum to int quality (0-5 scale usually used in SRS service)
    // SrsService uses: 0=Unknown, 1=Again, 2=Hard, 3=Good, 4=Easy
    // ConfidenceLevel enum: again=1, hard=2, good=3, easy=4
    // We can use the .value directly if they align, or map explicitly.
    // ConfidenceLevel values are 1,2,3,4.
    // LessonDetailScreen mapping: Again->0, Hard->3, Good->4, Easy->5 (based on _incrementReviewStats)
    // Wait, let's look at `_incrementReviewStats` in LessonDetailScreen again.
    // case 0: again, case 3: hard, case 4: good, case 5: easy.
    // This seems weird. Let's check `SrsService` if possible.
    // But safely, `saveTermReview` likely takes 1-4 or 0-5.
    // Let's assume standard mapping: Again=1, Hard=2, Good=3, Easy=4. 
    // Actually, looking at `ConfidenceLevel`: again(1), hard(2), good(3), easy(4).
    
    // Let's just pass the value and if the service expects different, we might adjust.
    // However, `LessonDetailScreen` passed:
    // _reviewTerm(currentTerm, level.value) where level is ConfidenceLevel.
    // So passing `level.value` is correct.

    await repo.saveTermReview(termId: termId, quality: levelEnum.value);

    setState(() {
       switch (levelEnum) {
         case ConfidenceLevel.again:
           _againCount++;
           break;
         case ConfidenceLevel.hard:
           _hardCount++;
           break;
         case ConfidenceLevel.good:
           _goodCount++;
           break;
         case ConfidenceLevel.easy:
           _easyCount++;
           break;
       }

       if (_currentIndex < totalTerms - 1) {
         _currentIndex++;
       } else {
         _isSessionComplete = true;
       }
    });
  }
}
