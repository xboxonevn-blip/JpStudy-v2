import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/learning_path_viewmodel.dart';
import '../widgets/unit_map_widget.dart';
import '../models/lesson_node.dart';

import 'package:jpstudy/core/level_provider.dart';
import '../../test/widgets/practice_test_dashboard.dart';

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

          return CustomScrollView(
            slivers: [
              // Dashboard Header
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: PracticeTestDashboard(),
                ),
              ),
              
              // Lesson List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final unit = units[index];
                    return UnitMapWidget(
                      unit: unit,
                      onNodeTap: (node) => _handleNodeTap(context, node),
                    );
                  },
                  childCount: units.length,
                ),
              ),
              
              // Bottom padding
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Quick access to last lesson or practice
          // Logic: Find first available/completed node
          pathState.whenData((allUnits) {
            final units = selectedLevel == null 
                ? allUnits 
                : allUnits.where((u) => u.id == selectedLevel.shortLabel).toList();
                
            if (units.isNotEmpty && units.first.nodes.isNotEmpty) {
               // For now, jump to the first node of the first unit
               // In future: Find first !isCompleted node
               _handleNodeTap(context, units.first.nodes.first);
            }
          });
        },
        child: const Icon(Icons.play_arrow_rounded),
      ),
    );
  }

  void _handleNodeTap(BuildContext context, LessonNode node) {
    context.push('/lesson/${node.lesson.id}');
  }
}
