import 'package:flutter/material.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/features/home/providers/continue_provider.dart';
import 'package:jpstudy/features/home/providers/dashboard_provider.dart';
import 'package:jpstudy/responsive/breakpoints.dart';

class HomeOverviewGrid extends StatelessWidget {
  const HomeOverviewGrid({
    super.key,
    required this.language,
    required this.level,
    required this.dashboard,
    required this.continueAction,
  });

  final AppLanguage language;
  final StudyLevel level;
  final DashboardState? dashboard;
  final ContinueAction? continueAction;

  @override
  Widget build(BuildContext context) {
    return BreakpointBuilder(
      builder: (context, breakpoint) {
        final columns = switch (breakpoint) {
          Breakpoint.mobile => 1,
          Breakpoint.tabletPortrait => 2,
          Breakpoint.tabletLandscape => 2,
          Breakpoint.desktop => 4,
        };
        return GridView(
          key: const ValueKey('home_overview_grid'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: columns == 1 ? 3.0 : 1.35,
            mainAxisExtent: columns == 1 ? 118 : 154,
          ),
          children: [
            _OverviewCard(
              key: const ValueKey('home_today_plan_widget'),
              icon: Icons.today_rounded,
              color: context.appPalette.primary,
              title: _todayPlanTitle(language),
              value: '${dashboard?.totalDue ?? 0}',
              subtitle: _todayPlanSubtitle(language, dashboard?.totalDue ?? 0),
            ),
            _OverviewCard(
              key: const ValueKey('home_level_progress_widget'),
              icon: Icons.stacked_bar_chart_rounded,
              color: context.appPalette.secondary,
              title: _levelProgressTitle(language),
              value: level.shortLabel,
              subtitle: _levelProgressSubtitle(language, level),
            ),
            _OverviewCard(
              key: const ValueKey('home_streak_widget'),
              icon: Icons.local_fire_department_rounded,
              color: context.appPalette.accent,
              title: _streakTitle(language),
              value: '${dashboard?.streak ?? 0}',
              subtitle: _streakSubtitle(language, dashboard?.todayXp ?? 0),
            ),
            _OverviewCard(
              key: const ValueKey('home_last_context_widget'),
              icon: Icons.history_edu_rounded,
              color: context.appPalette.success,
              title: _lastContextTitle(language),
              value: _lastContextValue(language),
              subtitle: continueAction?.label ?? _lastContextFallback(language),
            ),
          ],
        );
      },
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: palette.ink.withValues(alpha: 0.62),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: palette.ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.ink.withValues(alpha: 0.68),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _todayPlanTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Today plan',
  AppLanguage.vi => 'Kế hoạch hôm nay',
  AppLanguage.ja => '今日の計画',
};

String _todayPlanSubtitle(AppLanguage language, int dueCount) =>
    switch (language) {
      AppLanguage.en => '$dueCount due across vocab, grammar, kanji',
      AppLanguage.vi => '$dueCount mục đến hạn trong từ, ngữ pháp, kanji',
      AppLanguage.ja => '語彙・文法・漢字で$dueCount件',
    };

String _levelProgressTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Level progress',
  AppLanguage.vi => 'Tiến độ cấp học',
  AppLanguage.ja => 'レベル進捗',
};

String _levelProgressSubtitle(AppLanguage language, StudyLevel level) =>
    switch (language) {
      AppLanguage.en => '${level.shortLabel} is the active path',
      AppLanguage.vi => '${level.shortLabel} là lộ trình đang học',
      AppLanguage.ja => '${level.shortLabel}を学習中',
    };

String _streakTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Streak',
  AppLanguage.vi => 'Chuỗi học',
  AppLanguage.ja => '連続学習',
};

String _streakSubtitle(AppLanguage language, int todayXp) => switch (language) {
  AppLanguage.en => '$todayXp XP today',
  AppLanguage.vi => '$todayXp XP hôm nay',
  AppLanguage.ja => '今日$todayXp XP',
};

String _lastContextTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Last context',
  AppLanguage.vi => 'Đang dở',
  AppLanguage.ja => '前回の続き',
};

String _lastContextValue(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Continue',
  AppLanguage.vi => 'Học tiếp',
  AppLanguage.ja => '続ける',
};

String _lastContextFallback(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Open the next useful action',
  AppLanguage.vi => 'Mở bước học phù hợp tiếp theo',
  AppLanguage.ja => '次に役立つ学習へ',
};
