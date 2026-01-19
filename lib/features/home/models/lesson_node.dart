import '../../../data/db/app_database.dart';

enum LessonStatus {
  locked,
  available,
  completed,
}

class LessonNode {
  final UserLessonData lesson;
  final LessonStatus status;
  final int stars; // 0-3
  final double progress; // 0.0 - 1.0 (percentage of terms learned)

  const LessonNode({
    required this.lesson,
    required this.status,
    this.stars = 0,
    this.progress = 0.0,
  });

  bool get isLocked => status == LessonStatus.locked;
  bool get isCompleted => status == LessonStatus.completed;
  bool get isAvailable => status == LessonStatus.available;
}
