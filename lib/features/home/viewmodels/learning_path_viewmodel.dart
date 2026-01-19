import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../../data/db/app_database.dart';
import '../models/unit.dart';
import '../models/lesson_node.dart';

final learningPathViewModelProvider = StateNotifierProvider<LearningPathViewModel, AsyncValue<List<Unit>>>((ref) {
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
      
      // 2. Process each group
      grouped.forEach((level, levelLessons) {
        // Sort by id or order (assuming id is creation order for now)
        levelLessons.sort((a, b) => a.id.compareTo(b.id));

        final nodes = <LessonNode>[];
        bool previousCompleted = true; // First lesson is always unlocked

        for (final lesson in levelLessons) {
          // TODO: Check actual completion status from DB (UserProgress or LessonTerm stats)
          // For MVP Zero-Cost: completion is just mocked or simple boolean
          // We need a way to check if a lesson is "completed".
          // Let's assume for now if it has any learned terms it's "Available", 
          // if >80% learned it's "Completed".
          
          // Since we don't have this data readily available in UserLessonData, 
          // we might need to fetch stats. For now, strict linear unlocking:
          // If previous is completed, this one is available.
          
          final isCompleted = false; // Mock for now, need repo method to check stats
          
          LessonStatus status = LessonStatus.locked;
          if (previousCompleted) {
            status = isCompleted ? LessonStatus.completed : LessonStatus.available;
          }
          
          nodes.add(LessonNode(
            lesson: lesson,
            status: status,
            stars: isCompleted ? 3 : 0,
            progress: 0.0,
          ));
          
          previousCompleted = isCompleted;
          
          // Temporary override for dev: Unlock all
          // status = LessonStatus.available; 
        }

        // Color based on level
        Color color = Colors.blue;
        if (level == 'N5') {
          color = Colors.pink;
        } else if (level == 'N4') color = Colors.orange;
        else if (level == 'N3') color = Colors.teal;

        units.add(Unit(
          id: level,
          title: 'Level $level',
          description: 'Basic Japanese',
          nodes: nodes,
          color: color,
        ));
      });

      state = AsyncValue.data(units);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
