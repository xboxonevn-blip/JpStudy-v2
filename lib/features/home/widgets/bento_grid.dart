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
    required this.progressSummary,
    required this.onContinueTap,
    required this.onLessonTap,
  });

  final StudyLevel level;
  final AppLanguage language;
  final LessonMeta? recentLesson;
  final ProgressSummary? progressSummary;
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
          child: _StreakWidget(
            language: language,
            streak: progressSummary?.streak ?? 0,
          ),
        ),
        // Stats Widget
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: _StatsWidget(
            language: language,
            totalCorrect: progressSummary?.totalCorrect ?? 0,
            totalQuestions: progressSummary?.totalQuestions ?? 0,
          ),
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
            child: lesson == null
                ? _buildEmptyState(theme)
                : _buildLessonContent(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.rocket_launch_rounded,
          color: Colors.white.withValues(alpha: 0.9),
          size: 48,
        ),
        const SizedBox(height: 16),
        Text(
          language.createLessonLabel,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          language.emptyStateMessage,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildLessonContent(ThemeData theme) {
    return Column(
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
    );
  }
}

class _StreakWidget extends StatelessWidget {
  const _StreakWidget({
    required this.language,
    required this.streak,
  });

  final AppLanguage language;
  final int streak;

  @override
  Widget build(BuildContext context) {
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
            '$streak',
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
  const _StatsWidget({
    required this.language,
    required this.totalCorrect,
    required this.totalQuestions,
  });

  final AppLanguage language;
  final int totalCorrect;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final masteryPercent = totalQuestions > 0
        ? ((totalCorrect / totalQuestions) * 100).round()
        : 0;

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
            '$masteryPercent%',
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
