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
import '../models/unit.dart';

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

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1100;
              return Container(
                decoration: _backgroundDecoration(),
                child: isDesktop
                    ? _buildDesktopLayout(context, units)
                    : _buildMobileLayout(context, units),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(language.loadErrorLabel)),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, List<Unit> units) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 10),
            child: Column(children: [MiniDashboard()]),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final unit = units[index];
            return UnitMapWidget(
              unit: unit,
              onNodeTap: (node) => _handleNodeTap(context, node),
            );
          }, childCount: units.length),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 2),
            child: Column(
              children: [
                ContinueButton(),
                GhostReviewBanner(),
                SizedBox(height: 16),
                PracticeTestDashboard(),
                SizedBox(height: 12),
                PracticeHub(),
              ],
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List<Unit> units) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1480),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
          child: Column(
            children: [
              const MiniDashboard(),
              const SizedBox(height: 6),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.56),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFE3EAF8)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x10243A5A),
                              blurRadius: 22,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(8, 10, 8, 80),
                          itemCount: units.length,
                          itemBuilder: (context, index) {
                            final unit = units[index];
                            return UnitMapWidget(
                              unit: unit,
                              onNodeTap: (node) =>
                                  _handleNodeTap(context, node),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 410,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.62),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFE2E8F6)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0E1E293B),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(6, 8, 6, 80),
                          children: const [
                            ContinueButton(),
                            GhostReviewBanner(),
                            SizedBox(height: 16),
                            PracticeTestDashboard(),
                            SizedBox(height: 12),
                            PracticeHub(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNodeTap(BuildContext context, LessonNode node) {
    context.push('/lesson/${node.lesson.id}');
  }

  BoxDecoration _backgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF4F8FF), Color(0xFFF7FAFF), Color(0xFFF1F5FB)],
        stops: [0.0, 0.52, 1.0],
      ),
    );
  }
}
