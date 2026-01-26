import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../../data/db/app_database.dart';
import '../models/unit.dart';
import '../models/lesson_node.dart';

final learningPathViewModelProvider =
    StateNotifierProvider<LearningPathViewModel, AsyncValue<List<Unit>>>((ref) {
      final repo = ref.watch(lessonRepositoryProvider);
      return LearningPathViewModel(repo)..loadPath();
    });

class LearningPathViewModel extends StateNotifier<AsyncValue<List<Unit>>> {
  final LessonRepository _repo;

  LearningPathViewModel(this._repo) : super(const AsyncValue.loading());

  Future<void> loadPath() async {
    try {
      final lessons = await _repo.getAllLessons();

      // Group lessons into units (logic: by JLPT level or distinct parts)
      // For now, we'll create one big unit per Level found

      // 1. Group by Level
      final grouped = <String, List<UserLessonData>>{};
      for (final lesson in lessons) {
        if (!grouped.containsKey(lesson.level)) {
          grouped[lesson.level] = [];
        }
        grouped[lesson.level]!.add(lesson);
      }

      final units = <Unit>[];

      final statsMap = await _repo.getAllLessonProgress();

      // 2. Process each group
      grouped.forEach((level, levelLessons) {
        // Sort by id or order (assuming id is creation order for now)
        levelLessons.sort((a, b) => a.id.compareTo(b.id));

        final nodes = <LessonNode>[];

        for (final lesson in levelLessons) {
          final stats = statsMap[lesson.id];
          final isCompleted =
              stats != null &&
              stats.termCount > 0 &&
              stats.completedCount == stats.termCount;

          // Unlock all lessons
          LessonStatus status = isCompleted
              ? LessonStatus.completed
              : LessonStatus.available;

          nodes.add(
            LessonNode(
              lesson: lesson,
              status: status,
              stars: isCompleted ? 3 : 0,
              progress: (stats == null || stats.termCount == 0)
                  ? 0.0
                  : stats.completedCount / stats.termCount,
            ),
          );
        }

        // Color based on level
        Color color = Colors.blue;
        if (level == 'N5') {
          color = Colors.pink;
        } else if (level == 'N4') {
          color = Colors.orange;
        } else if (level == 'N3') {
          color = Colors.teal;
        }

        units.add(
          Unit(
            id: level,
            title: 'Level $level',
            description: 'Basic Japanese',
            nodes: nodes,
            color: color,
          ),
        );
      });

      state = AsyncValue.data(units);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Helper removed as logic is inline now
}
