import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/level_provider.dart';
import '../../../data/repositories/lesson_repository.dart';
import 'dashboard_provider.dart';

final continueActionProvider = FutureProvider<ContinueAction>((ref) async {
  final dashboard = await ref.watch(dashboardProvider.future);
  final level = ref.watch(studyLevelProvider);
  final lessonRepo = ref.watch(lessonRepositoryProvider);

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

  // Priority 4: Next Lesson (Find the first not-fully-completed lesson)
  if (level != null) {
    final nextLessonId = await lessonRepo.findNextToStudyLesson(level.shortLabel);
    if (nextLessonId != null) {
       return ContinueAction(
        type: ContinueActionType.nextLesson,
        label: 'Next Lesson',
        data: nextLessonId,
      );
    }
  }

  // Fallback: Practice Mixed if nothing else
  return ContinueAction(
    type: ContinueActionType.practiceMixed,
    label: 'Practice',
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
  final dynamic data;

  const ContinueAction({
    required this.type,
    required this.label,
    this.count,
    this.data,
  });
}
