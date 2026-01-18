import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

class BentoGrid extends StatelessWidget {
  const BentoGrid({
    super.key,
    required this.level,
    required this.language,
    required this.recentLesson,
    required this.onContinueTap,
    required this.onLessonTap,
  });

  final StudyLevel level;
  final AppLanguage language;
  final LessonMeta? recentLesson;
  final VoidCallback onContinueTap;
  final VoidCallback onLessonTap;

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        // Hero Widget (Main Continue)
        StaggeredGridTile.count(
          crossAxisCellCount: 4,
          mainAxisCellCount: 2,
          child: _HeroWidget(
            language: language,
            lesson: recentLesson,
            onTap: onContinueTap,
          ),
        ),
        // Streak Widget
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: _StreakWidget(language: language),
        ),
        // Stats Widget
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: _StatsWidget(language: language),
        ),
      ],
    );
  }
}

class _HeroWidget extends StatelessWidget {
  const _HeroWidget({
    required this.language,
    required this.lesson,
    required this.onTap,
  });

  final AppLanguage language;
  final LessonMeta? lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Gradient Background
    final gradient = LinearGradient(
      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        language.continueLearningLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.play_circle_fill, color: Colors.white, size: 32),
                  ],
                ),
                const Spacer(),
                Text(
                  lesson?.title ?? language.lessonTitle(1),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (lesson?.completedCount ?? 0) / (lesson?.termCount == 0 ? 1 : (lesson?.termCount ?? 1)),
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Text(
                  language.termsLearnedLabel(lesson?.completedCount ?? 0, lesson?.termCount ?? 0),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StreakWidget extends StatelessWidget {
  const _StreakWidget({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    // Placeholder logic for streak
    const streakDays = 3;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_fire_department_rounded, color: Color(0xFFFF6B6B), size: 40),
          const SizedBox(height: 8),
          Text(
            '$streakDays',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E293B),
            ),
          ),
          Text(
            language.dayStreakLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsWidget extends StatelessWidget {
  const _StatsWidget({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.tertiary.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, color: theme.colorScheme.tertiary, size: 40),
          const SizedBox(height: 8),
          Text(
            '85%', // Placeholder
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.tertiary,
            ),
          ),
          Text(
            language.masteryLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
