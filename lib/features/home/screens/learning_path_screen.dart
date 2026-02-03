import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/learning_path_viewmodel.dart';
import '../widgets/unit_map_widget.dart';
import '../models/lesson_node.dart';

import 'package:jpstudy/core/level_provider.dart';
import '../../test/widgets/practice_test_dashboard.dart';
import '../widgets/mini_dashboard.dart';
import '../widgets/continue_button.dart';
import '../widgets/practice_hub.dart';
import '../widgets/ghost_review_banner.dart';
import '../../../core/language_provider.dart';
import '../../../core/app_language.dart';

class LearningPathScreen extends ConsumerWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pathState = ref.watch(learningPathViewModelProvider);
    final selectedLevel = ref.watch(studyLevelProvider);
    final language = ref.watch(appLanguageProvider);

    return Scaffold(
      body: pathState.when(
        data: (allUnits) {
          // Filter by selected level if applicable
          final units = selectedLevel == null
              ? allUnits
              : allUnits
                    .where((u) => u.id == selectedLevel.shortLabel)
                    .toList();

          if (units.isEmpty) {
            return Center(child: Text(language.noLessonsForLevelLabel));
          }

          return CustomScrollView(
            slivers: [
              // Dashboard Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                  child: Column(
                    children: [
                      const MiniDashboard(),
                      const ContinueButton(),
                      const SizedBox(height: 12),
                      const GhostReviewBanner(),
                      const SizedBox(height: 16),
                      const PracticeTestDashboard(),
                      const SizedBox(height: 12),
                      const PracticeHub(),
                    ],
                  ),
                ),
              ),

              // Lesson List
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final unit = units[index];
                  return UnitMapWidget(
                    unit: unit,
                    onNodeTap: (node) => _handleNodeTap(context, node),
                  );
                }, childCount: units.length),
              ),

              // Bottom padding
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(language.loadErrorLabel)),
      ),
    );
  }

  void _handleNodeTap(BuildContext context, LessonNode node) {
    context.push('/lesson/${node.lesson.id}');
  }
}
