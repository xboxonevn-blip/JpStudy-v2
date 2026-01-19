import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/learning_path_viewmodel.dart';
import '../widgets/unit_map_widget.dart';
import '../models/lesson_node.dart';

import 'package:jpstudy/core/level_provider.dart';

class LearningPathScreen extends ConsumerWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pathState = ref.watch(learningPathViewModelProvider);
    final selectedLevel = ref.watch(studyLevelProvider);
    
    return Scaffold(
      body: pathState.when(
        data: (allUnits) {
          // Filter by selected level if applicable
          final units = selectedLevel == null 
              ? allUnits 
              : allUnits.where((u) => u.id == selectedLevel.shortLabel).toList();

          if (units.isEmpty) {
            return const Center(child: Text('No lessons found for this level.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
            itemCount: units.length,
            itemBuilder: (context, index) {
              final unit = units[index];
              return UnitMapWidget(
                unit: unit,
                onNodeTap: (node) => _handleNodeTap(context, node),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Quick access to last lesson or practice
          // TODO: Implement "Jump to current"
        },
        child: const Icon(Icons.play_arrow_rounded),
      ),
    );
  }

  void _handleNodeTap(BuildContext context, LessonNode node) {
    context.push('/lesson/${node.lesson.id}');
  }
}
