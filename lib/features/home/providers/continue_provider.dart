import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_provider.dart';

final continueActionProvider = FutureProvider<ContinueAction>((ref) async {
  final dashboard = await ref.watch(dashboardProvider.future);

  // Priority 1: Grammar Due
  if (dashboard.grammarDue > 0) {
    return ContinueAction(
      type: ContinueActionType.grammarReview,
      label: 'Review Grammar',
      count: dashboard.grammarDue,
    );
  }

  // Priority 2: Vocab Due
  if (dashboard.vocabDue > 0) {
    return ContinueAction(
      type: ContinueActionType.vocabReview,
      label: 'Review Vocab',
      count: dashboard.vocabDue,
    );
  }

  // Priority 3: Fix Mistakes
  if (dashboard.mistakeCount > 0) {
    return ContinueAction(
      type: ContinueActionType.fixMistakes,
      label: 'Fix Mistakes',
      count: dashboard.mistakeCount,
    );
  }

  // Priority 4: Practice Mixed (Default fallback if existing lessons found) or Next Lesson
  // For now, default to Practice or Next Lesson.
  // We can refine this later to check if there are any learned lessons.
  
  // Checking if there is anything learned to practice would be ideal, 
  // but for "Next Lesson" we need to know the next unlocked lesson.
  // For simplicity v1: Return "Next Lesson" or "Practice" generically.
  
  return ContinueAction(
    type: ContinueActionType.nextLesson,
    label: 'Next Lesson',
    count: null,
  );
});

enum ContinueActionType {
  grammarReview,
  vocabReview,
  fixMistakes,
  practiceMixed,
  nextLesson,
}

class ContinueAction {
  final ContinueActionType type;
  final String label;
  final int? count;

  const ContinueAction({
    required this.type,
    required this.label,
    this.count,
  });
}
