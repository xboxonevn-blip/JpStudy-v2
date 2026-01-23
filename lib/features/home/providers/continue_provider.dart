import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/level_provider.dart';
import '../../../data/repositories/lesson_repository.dart';
import 'dashboard_provider.dart';

final continueActionProvider = StreamProvider<ContinueAction>((ref) async* {
  final level = ref.watch(studyLevelProvider);
  final lessonRepo = ref.watch(lessonRepositoryProvider);
  final dashboardAsync = ref.watch(dashboardProvider);

  if (!dashboardAsync.hasValue) {
    yield const ContinueAction(
      type: ContinueActionType.practiceMixed,
      label: 'Practice',
      count: null,
    );
    return;
  }

  final dashboard = dashboardAsync.value!;

  // Priority 1: Grammar Due
  if (dashboard.grammarDue > 0) {
    yield ContinueAction(
      type: ContinueActionType.grammarReview,
      label: 'Review Grammar',
      count: dashboard.grammarDue,
    );
    return;
  }

  // Priority 2: Vocab Due
  if (dashboard.vocabDue > 0) {
    yield ContinueAction(
      type: ContinueActionType.vocabReview,
      label: 'Review Vocab',
      count: dashboard.vocabDue,
    );
    return;
  }

  // Priority 3: Fix Mistakes
  if (dashboard.mistakeCount > 0) {
    yield ContinueAction(
      type: ContinueActionType.fixMistakes,
      label: 'Fix Mistakes',
      count: dashboard.mistakeCount,
    );
    return;
  }

  // Priority 4: Next Lesson (Find the first not-fully-completed lesson)
  if (level != null) {
    final nextLessonId = await lessonRepo.findNextToStudyLesson(level.shortLabel);
    if (nextLessonId != null) {
      yield ContinueAction(
        type: ContinueActionType.nextLesson,
        label: 'Next Lesson',
        data: nextLessonId,
      );
      return;
    }
  }

  // Fallback: Practice Mixed if nothing else
  yield const ContinueAction(
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
