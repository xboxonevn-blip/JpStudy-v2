import 'package:drift/drift.dart' hide Column;
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/app/navigation/app_navigation_extensions.dart';
import 'package:jpstudy/app/layout/app_responsive_frame.dart';
import 'package:jpstudy/app/theme/app_breakpoints.dart';
import 'package:jpstudy/app/theme/app_spacing.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/db/database_provider.dart';
import 'package:jpstudy/features/common/widgets/compact_ui.dart';
import 'package:jpstudy/features/common/widgets/japanese_background.dart';
import 'package:jpstudy/features/conjugation/models/conjugation_practice_args.dart';
import 'package:jpstudy/features/foundations/providers/foundations_providers.dart';
import 'package:jpstudy/features/foundations/widgets/kana_review_due_card.dart';
import 'package:jpstudy/features/home/home_copy.dart';
import 'package:jpstudy/features/home/models/textbook_roadmap.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_practice_args.dart';
import 'package:jpstudy/features/home/providers/continue_provider.dart';
import 'package:jpstudy/features/home/providers/dashboard_provider.dart';
import 'package:jpstudy/features/home/widgets/daily_plan_card.dart';
import 'package:jpstudy/features/home/widgets/daily_session_card.dart';
import 'package:jpstudy/features/home/widgets/discover_practice_panel.dart';
import 'package:jpstudy/features/home/widgets/goal_selection_banner.dart';
import 'package:jpstudy/features/home/widgets/home_overview_grid.dart';
import 'package:jpstudy/features/home/widgets/mini_dashboard.dart';
import 'package:jpstudy/features/home/widgets/weakness_radar_card.dart';
import 'package:jpstudy/features/home/widgets/weekly_challenge_card.dart';
import 'package:jpstudy/features/vocab/models/vocab_review_args.dart';
import 'package:jpstudy/features/vocab/vocab_copy.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

@visibleForTesting
double homeAdaptiveMaxWidthForTesting(double viewportWidth) =>
    _homeAdaptiveMaxWidth(viewportWidth);

double _homeAdaptiveMaxWidth(double viewportWidth) {
  if (viewportWidth >= 1600) return 1600;
  if (viewportWidth >= 1440) return 1440;
  if (viewportWidth >= 1280) return 1280;
  return 1040;
}

final _recentHomeActivityProvider =
    FutureProvider.autoDispose<List<_RecentActivityItem>>((ref) async {
      final db = ref.watch(databaseProvider);
      final language = ref.watch(appLanguageProvider);
      final since = DateTime.now().subtract(const Duration(days: 7));
      final items = <_RecentActivityItem>[];

      final learnRows =
          await (db.select(db.learnSessions)
                ..where(
                  (table) =>
                      table.completedAt.isNotNull() &
                      table.completedAt.isBiggerOrEqualValue(since),
                )
                ..orderBy([
                  (table) => OrderingTerm(
                    expression: table.completedAt,
                    mode: OrderingMode.desc,
                  ),
                ])
                ..limit(4))
              .get();
      for (final row in learnRows) {
        items.add(
          _RecentActivityItem(
            icon: Icons.school_rounded,
            title: _recentLearnTitle(language, row.lessonId),
            subtitle: _recentScoreLabel(
              language,
              row.correctCount,
              row.totalQuestions,
              row.xpEarned,
            ),
            happenedAt: row.completedAt!,
          ),
        );
      }

      final testRows =
          await (db.select(db.testSessions)
                ..where(
                  (table) =>
                      table.completedAt.isNotNull() &
                      table.completedAt.isBiggerOrEqualValue(since),
                )
                ..orderBy([
                  (table) => OrderingTerm(
                    expression: table.completedAt,
                    mode: OrderingMode.desc,
                  ),
                ])
                ..limit(4))
              .get();
      for (final row in testRows) {
        items.add(
          _RecentActivityItem(
            icon: Icons.fact_check_rounded,
            title: _recentTestTitle(language, row.lessonId),
            subtitle: _recentTestScoreLabel(language, row.score, row.xpEarned),
            happenedAt: row.completedAt!,
          ),
        );
      }

      final achievementRows =
          await (db.select(db.achievements)
                ..where((table) => table.earnedAt.isBiggerOrEqualValue(since))
                ..orderBy([
                  (table) => OrderingTerm(
                    expression: table.earnedAt,
                    mode: OrderingMode.desc,
                  ),
                ])
                ..limit(4))
              .get();
      for (final row in achievementRows) {
        items.add(
          _RecentActivityItem(
            icon: Icons.emoji_events_rounded,
            title: _recentAchievementTitle(language, row.type),
            subtitle: _recentAchievementValue(language, row.value),
            happenedAt: row.earnedAt,
          ),
        );
      }

      items.sort((a, b) => b.happenedAt.compareTo(a.happenedAt));
      return items.take(6).toList(growable: false);
    });

class LearningPathScreen extends ConsumerWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final palette = context.appPalette;
    final level = ref.watch(studyLevelProvider) ?? StudyLevel.n5;
    final dashboard = ref.watch(dashboardProvider).value;
    final continueAction = ref.watch(continueActionProvider).value;
    final foundationsProgress = ref.watch(foundationsProgressProvider);

    final streak = dashboard?.streak ?? 0;
    final todayXp = dashboard?.todayXp ?? 0;
    final dueCount =
        (dashboard?.vocabDue ?? 0) +
        (dashboard?.grammarDue ?? 0) +
        (dashboard?.kanjiDue ?? 0);
    final weakCount = dashboard?.totalMistakeCount ?? 0;
    final hasStartedToday = todayXp > 0;
    final showFoundationsCard = level == StudyLevel.n5;
    final foundationsCardContent = _FoundationsFeaturedCard(
      language: language,
      progress: foundationsProgress,
    );
    final foundationsCard = showFoundationsCard
        ? Padding(
            key: const ValueKey('home_foundations_pane'),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: foundationsCardContent,
          )
        : const SizedBox.shrink();
    final featuredItems = _featuredHomeItems(
      language: language,
      level: level,
      dashboard: dashboard,
      continueAction: continueAction,
      foundationsProgress: foundationsProgress,
    );
    final recentActivity = ref.watch(_recentHomeActivityProvider);
    final studyPromptCard = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: AppSectionCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(
              title: _studyPromptTitle(language),
              caption: _studyPromptSubtitle(language),
            ),
            const SizedBox(height: 10),
            AppProgressStrip(
              value: hasStartedToday ? (todayXp / 30).clamp(0.18, 1.0) : 0.08,
              label: _studyPromptProgressLabel(
                language,
                hasStartedToday: hasStartedToday,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FocusChip(
                  icon: Icons.menu_book_rounded,
                  label: _focusChipLabel(language, dueCount),
                  color: palette.primary,
                ),
                _FocusChip(
                  icon: Icons.auto_fix_high_rounded,
                  label: _repairChipLabel(language, weakCount),
                  color: palette.accent,
                ),
                _FocusChip(
                  icon: Icons.rocket_launch_rounded,
                  label: _momentumChipLabel(language, level),
                  color: palette.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    final textbookRoadmapPanel = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: _TextbookRoadmapPanel(language: language, level: level),
    );
    final textbookRoadmapContent = _TextbookRoadmapPanel(
      language: language,
      level: level,
    );
    final overviewGrid = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: HomeOverviewGrid(
        language: language,
        level: level,
        dashboard: dashboard,
        continueAction: continueAction,
      ),
    );

    return JapaneseBackground(
      child: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => _refreshHome(ref),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              0,
              100,
              0,
              AppSpacing.pageBottom,
            ),
            children: [
              AppResponsiveFrame(
                maxWidth: _homeAdaptiveMaxWidth(
                  MediaQuery.sizeOf(context).width,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final useDesktopGrid =
                        constraints.maxWidth >= AppBreakpoints.desktop;
                    final useTopSplit =
                        MediaQuery.sizeOf(context).width >= 1280;

                    final hero =
                        Padding(
                              key: const ValueKey('home_dojo_today_pane'),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: _DojoHeroCard(
                                language: language,
                                level: level,
                                streak: streak,
                                todayXp: todayXp,
                                dueCount: dueCount,
                                weakCount: weakCount,
                                hasStartedToday: hasStartedToday,
                                missionLabel: continueAction?.label,
                                onPrimaryTap: () => _openContinueAction(
                                  context,
                                  continueAction,
                                  language: language,
                                  level: level,
                                ),
                                onSecondaryTap: () => context.openJlptCoach(),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 360.ms)
                            .slideY(begin: 0.08, end: 0);
                    final featuredThisWeek = Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _FeaturedThisWeekCard(
                        items: featuredItems,
                        language: language,
                        level: level,
                        continueAction: continueAction,
                      ),
                    );
                    final recentTimeline = Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _RecentActivityTimeline(
                        language: language,
                        activity: recentActivity,
                      ),
                    );
                    final desktopTopSplit = Padding(
                      key: const ValueKey('home_top_split'),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: showFoundationsCard
                                ? AppSection(
                                    key: const ValueKey(
                                      'home_foundations_pane',
                                    ),
                                    title: _foundationsSectionTitle(language),
                                    caption: _foundationsSectionCaption(
                                      language,
                                    ),
                                    child: foundationsCardContent,
                                  )
                                : textbookRoadmapContent,
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AppSection(
                                  key: const ValueKey('home_dojo_today_pane'),
                                  title: _dojoTodaySectionTitle(language),
                                  caption: _dojoTodaySectionCaption(language),
                                  child: _DojoHeroCard(
                                    language: language,
                                    level: level,
                                    streak: streak,
                                    todayXp: todayXp,
                                    dueCount: dueCount,
                                    weakCount: weakCount,
                                    hasStartedToday: hasStartedToday,
                                    missionLabel: continueAction?.label,
                                    onPrimaryTap: () => _openContinueAction(
                                      context,
                                      continueAction,
                                      language: language,
                                      level: level,
                                    ),
                                    onSecondaryTap: () =>
                                        context.openJlptCoach(),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                _HomeSidebar(
                                  language: language,
                                  dashboard: dashboard,
                                  dueCount: dueCount,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );

                    if (!useDesktopGrid) {
                      return Column(
                        children: [
                          featuredThisWeek
                              .animate()
                              .fadeIn(duration: 320.ms)
                              .slideY(begin: 0.04, end: 0),
                          const SizedBox(height: 10),
                          const GoalSelectionBanner(),
                          if (showFoundationsCard) ...[
                            foundationsCard,
                            const SizedBox(height: 10),
                          ],
                          hero,
                          const SizedBox(height: 10),
                          overviewGrid,
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: KanaReviewDueCard(),
                          ),
                          const SizedBox(height: 10),
                          const DailyPlanCard()
                              .animate(delay: 60.ms)
                              .fadeIn(duration: 340.ms)
                              .slideY(begin: 0.06, end: 0),
                          const SizedBox(height: 10),
                          textbookRoadmapPanel
                              .animate(delay: 90.ms)
                              .fadeIn(duration: 320.ms),
                          const SizedBox(height: 10),
                          const DailySessionCard(compact: true)
                              .animate(delay: 120.ms)
                              .fadeIn(duration: 340.ms)
                              .slideY(begin: 0.06, end: 0),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: const MiniDashboard(compact: true),
                          ).animate(delay: 140.ms).fadeIn(duration: 320.ms),
                          const SizedBox(height: 10),
                          const WeeklyChallengeCard(
                            compact: true,
                          ).animate(delay: 180.ms).fadeIn(duration: 320.ms),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: _LearningLanesPanel(
                              language: language,
                              level: level,
                              dueCount: dueCount,
                              weakCount: weakCount,
                            ),
                          ).animate(delay: 220.ms).fadeIn(duration: 340.ms),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: const WeaknessRadarCard(compact: true),
                          ).animate(delay: 280.ms).fadeIn(duration: 320.ms),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: const DiscoverPracticePanel(
                              initiallyExpanded: false,
                              dense: true,
                            ),
                          ).animate(delay: 340.ms).fadeIn(duration: 360.ms),
                          const SizedBox(height: 6),
                          studyPromptCard
                              .animate(delay: 400.ms)
                              .fadeIn(duration: 320.ms),
                          const SizedBox(height: 10),
                          recentTimeline
                              .animate(delay: 240.ms)
                              .fadeIn(duration: 320.ms),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        featuredThisWeek
                            .animate()
                            .fadeIn(duration: 320.ms)
                            .slideY(begin: 0.04, end: 0),
                        const SizedBox(height: 12),
                        const GoalSelectionBanner(),
                        const SizedBox(height: 12),
                        if (useTopSplit) ...[
                          desktopTopSplit,
                        ] else ...[
                          if (showFoundationsCard) ...[
                            foundationsCard,
                            const SizedBox(height: 10),
                          ],
                          hero,
                        ],
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: useTopSplit ? 1 : 8,
                              child: Column(
                                children: [
                                  overviewGrid,
                                  const SizedBox(height: 10),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: KanaReviewDueCard(),
                                  ),
                                  const SizedBox(height: 10),
                                  const DailyPlanCard()
                                      .animate(delay: 60.ms)
                                      .fadeIn(duration: 340.ms),
                                  const SizedBox(height: 12),
                                  if (showFoundationsCard) ...[
                                    textbookRoadmapPanel
                                        .animate(delay: 80.ms)
                                        .fadeIn(duration: 320.ms),
                                    const SizedBox(height: 12),
                                  ],
                                  const DailySessionCard(compact: true),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: _LearningLanesPanel(
                                      language: language,
                                      level: level,
                                      dueCount: dueCount,
                                      weakCount: weakCount,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: const WeaknessRadarCard(
                                      compact: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: const DiscoverPracticePanel(
                                      initiallyExpanded: false,
                                      dense: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  studyPromptCard
                                      .animate(delay: 180.ms)
                                      .fadeIn(duration: 320.ms),
                                  const SizedBox(height: 12),
                                  recentTimeline
                                      .animate(delay: 220.ms)
                                      .fadeIn(duration: 320.ms),
                                ],
                              ),
                            ),
                            if (!useTopSplit) ...[
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                flex: 5,
                                child: _HomeSidebar(
                                  language: language,
                                  dashboard: dashboard,
                                  dueCount: dueCount,
                                ),
                              ),
                            ],
                          ],
                        ).animate(delay: 80.ms).fadeIn(duration: 340.ms),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _refreshHome(WidgetRef ref) async {
    ref.invalidate(dashboardProvider);
    ref.invalidate(continueActionProvider);
    ref.invalidate(foundationsProgressProvider);
    await Future<void>.delayed(Duration.zero);
  }

  static void _openContinueAction(
    BuildContext context,
    ContinueAction? action, {
    required AppLanguage language,
    required StudyLevel level,
  }) {
    if (action == null) {
      context.openStudy();
      return;
    }
    switch (action.type) {
      case ContinueActionType.grammarReview:
        context.openGrammarPractice(extra: action.data);
        return;
      case ContinueActionType.conjugationReview:
        context.openConjugationPractice(
          const ConjugationPracticeArgs(source: 'learning_path_due'),
        );
        return;
      case ContinueActionType.vocabReview:
        context.push(
          '/vocab/review',
          extra: VocabReviewArgs(
            source: 'learning_path',
            levelCode: level.shortLabel,
            title: language.vocabReviewTitle(level.shortLabel),
            subtitle: switch (language) {
              AppLanguage.en => 'Due vocab queue for today',
              AppLanguage.vi => 'Hàng đợi từ vựng đến hạn hôm nay',
              AppLanguage.ja => '今日の語彙レビュー',
            },
          ),
        );
        return;
      case ContinueActionType.kanjiReview:
        context.push(
          '/kanji/practice',
          extra: KanjiPracticeArgs(
            mode: KanjiPracticeMode.both,
            levelCode: level.shortLabel,
            source: 'learning_path',
          ),
        );
        return;
      case ContinueActionType.fixMistakes:
        context.openMistakes();
        return;
      case ContinueActionType.practiceMixed:
        context.openStudy();
        return;
      case ContinueActionType.nextLesson:
        final lessonId = action.data as int?;
        if (lessonId != null) {
          context.openLesson(lessonId, levelCode: level.shortLabel);
        } else {
          context.openLibrary();
        }
        return;
    }
  }

  static String _studyPromptTitle(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Keep the Japanese rhythm',
    AppLanguage.vi => 'Giữ nhịp tiếng Nhật mỗi ngày',
    AppLanguage.ja => '毎日の日本語リズムを保つ',
  };

  static String _studyPromptSubtitle(AppLanguage language) =>
      language.learningPathStudyPromptSubtitle();

  static String _studyPromptProgressLabel(
    AppLanguage language, {
    required bool hasStartedToday,
  }) => language.learningPathProgressLabel(hasStartedToday: hasStartedToday);

  static String _focusChipLabel(AppLanguage language, int dueCount) =>
      language.learningPathFocusChipLabel(dueCount);

  static String _repairChipLabel(AppLanguage language, int weakCount) =>
      language.learningPathRepairChipLabel(weakCount);

  static String _momentumChipLabel(AppLanguage language, StudyLevel level) =>
      language.learningPathMomentumChipLabel(level.shortLabel);
}

enum _FeaturedTarget { continueAction, foundations, study, mistakes, jlpt }

class _FeaturedHomeItem {
  const _FeaturedHomeItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.score,
    required this.target,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final int score;
  final _FeaturedTarget target;
}

class _RecentActivityItem {
  const _RecentActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.happenedAt,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final DateTime happenedAt;
}

List<_FeaturedHomeItem> _featuredHomeItems({
  required AppLanguage language,
  required StudyLevel level,
  required DashboardState? dashboard,
  required ContinueAction? continueAction,
  required FoundationsProgress foundationsProgress,
}) {
  final totalDue = dashboard?.totalDue ?? 0;
  final weakCount = dashboard?.totalMistakeCount ?? 0;
  final items = <_FeaturedHomeItem>[
    if (continueAction != null)
      _FeaturedHomeItem(
        icon: Icons.play_arrow_rounded,
        title: continueAction.label,
        subtitle: _featuredContinueSubtitle(language, continueAction),
        badge: _featuredDueBadge(language, totalDue),
        score: 120 + (continueAction.count ?? 0),
        target: _FeaturedTarget.continueAction,
      ),
    if (level == StudyLevel.n5 && foundationsProgress.percentComplete < 1)
      _FeaturedHomeItem(
        icon: Icons.grass_rounded,
        title: _foundationsSectionTitle(language),
        subtitle: _featuredFoundationsSubtitle(language, foundationsProgress),
        badge: '${(foundationsProgress.percentComplete * 100).round()}%',
        score: 92,
        target: _FeaturedTarget.foundations,
      ),
    if (weakCount > 0)
      _FeaturedHomeItem(
        icon: Icons.auto_fix_high_rounded,
        title: _featuredMistakeTitle(language),
        subtitle: _featuredMistakeSubtitle(language, weakCount),
        badge: _featuredCountBadge(language, weakCount),
        score: 88 + weakCount,
        target: _FeaturedTarget.mistakes,
      ),
    _FeaturedHomeItem(
      icon: Icons.quiz_rounded,
      title: _featuredJlptTitle(language),
      subtitle: _featuredJlptSubtitle(language, level),
      badge: level.shortLabel,
      score: 70,
      target: _FeaturedTarget.jlpt,
    ),
    _FeaturedHomeItem(
      icon: Icons.hub_rounded,
      title: _featuredStudyTitle(language),
      subtitle: _featuredStudySubtitle(language, totalDue),
      badge: _featuredDueBadge(language, totalDue),
      score: 60 + totalDue,
      target: _FeaturedTarget.study,
    ),
  ];
  items.sort((a, b) => b.score.compareTo(a.score));
  return items.take(3).toList(growable: false);
}

class _FeaturedThisWeekCard extends StatelessWidget {
  const _FeaturedThisWeekCard({
    required this.items,
    required this.language,
    required this.level,
    required this.continueAction,
  });

  final List<_FeaturedHomeItem> items;
  final AppLanguage language;
  final StudyLevel level;
  final ContinueAction? continueAction;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      key: const ValueKey('home_featured_this_week'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: AppSection(
        title: _featuredTitle(language),
        caption: _featuredCaption(language),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 860;
            final tiles = items
                .map(
                  (item) => _FeaturedTile(
                    item: item,
                    onTap: () => _openFeaturedTarget(
                      context,
                      item,
                      continueAction: continueAction,
                      language: language,
                      level: level,
                    ),
                  ),
                )
                .toList(growable: false);
            if (!wide) {
              return Column(
                children: [
                  for (final tile in tiles) ...[
                    tile,
                    if (tile != tiles.last)
                      const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final tile in tiles) ...[
                  Expanded(child: tile),
                  if (tile != tiles.last) const SizedBox(width: AppSpacing.sm),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FeaturedTile extends StatelessWidget {
  const _FeaturedTile({required this.item, required this.onTap});

  final _FeaturedHomeItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      variant: AppCardVariant.outlined,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppBadge(label: item.badge, icon: item.icon),
              const Spacer(),
              Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: palette.ink.withValues(alpha: 0.52),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: palette.ink,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.ink.withValues(alpha: 0.68),
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSidebar extends StatefulWidget {
  const _HomeSidebar({
    required this.language,
    required this.dashboard,
    required this.dueCount,
  });

  final AppLanguage language;
  final DashboardState? dashboard;
  final int dueCount;

  @override
  State<_HomeSidebar> createState() => _HomeSidebarState();
}

class _HomeSidebarState extends State<_HomeSidebar> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('home_sidebar'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppSectionHeader(
                      title: _sidebarTitle(widget.language),
                      caption: _sidebarCaption(widget.language),
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('home_sidebar_toggle'),
                    tooltip: _sidebarToggleLabel(widget.language, _collapsed),
                    onPressed: () => setState(() => _collapsed = !_collapsed),
                    icon: Icon(
                      _collapsed
                          ? Icons.keyboard_double_arrow_left_rounded
                          : Icons.keyboard_double_arrow_right_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (_collapsed)
                _SidebarCollapsedSummary(
                  key: const ValueKey('home_sidebar_collapsed'),
                  language: widget.language,
                  dashboard: widget.dashboard,
                  dueCount: widget.dueCount,
                )
              else
                _SidebarExpandedSummary(
                  language: widget.language,
                  dashboard: widget.dashboard,
                  dueCount: widget.dueCount,
                ),
            ],
          ),
        ),
        if (!_collapsed) ...[
          const SizedBox(height: AppSpacing.md),
          const MiniDashboard(compact: true),
          const SizedBox(height: AppSpacing.md),
          const WeeklyChallengeCard(compact: true),
        ],
      ],
    );
  }
}

class _SidebarCollapsedSummary extends StatelessWidget {
  const _SidebarCollapsedSummary({
    super.key,
    required this.language,
    required this.dashboard,
    required this.dueCount,
  });

  final AppLanguage language;
  final DashboardState? dashboard;
  final int dueCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        AppBadge(
          label: '${dashboard?.streak ?? 0}',
          icon: Icons.local_fire_department_rounded,
        ),
        AppChip(
          label: _lessonsDueChip(language, dueCount),
          tone: dueCount > 0 ? AppChipTone.warning : AppChipTone.success,
          icon: Icons.history_edu_rounded,
        ),
      ],
    );
  }
}

class _SidebarExpandedSummary extends StatelessWidget {
  const _SidebarExpandedSummary({
    required this.language,
    required this.dashboard,
    required this.dueCount,
  });

  final AppLanguage language;
  final DashboardState? dashboard;
  final int dueCount;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _SidebarMetric(
                icon: Icons.local_fire_department_rounded,
                label: _weeklyStreakLabel(language),
                value: '${dashboard?.streak ?? 0}',
                color: palette.warning,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _SidebarMetric(
                icon: Icons.history_edu_rounded,
                label: _dueShortLabel(language),
                value: '$dueCount',
                color: dueCount > 0 ? palette.error : palette.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppChip(
          label: _lessonsDueChip(language, dueCount),
          tone: dueCount > 0 ? AppChipTone.warning : AppChipTone.success,
          icon: Icons.event_available_rounded,
        ),
      ],
    );
  }
}

class _SidebarMetric extends StatelessWidget {
  const _SidebarMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: palette.ink,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: palette.ink.withValues(alpha: 0.64),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivityTimeline extends StatelessWidget {
  const _RecentActivityTimeline({
    required this.language,
    required this.activity,
  });

  final AppLanguage language;
  final AsyncValue<List<_RecentActivityItem>> activity;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      key: const ValueKey('home_recent_activity'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: AppSection(
        title: _recentActivityTitle(language),
        caption: _recentActivityCaption(language),
        child: activity.when(
          data: (items) {
            if (items.isEmpty) {
              return AppEmptyState(
                icon: Icons.timeline_rounded,
                title: _recentEmptyTitle(language),
                message: _recentEmptyMessage(language),
              );
            }
            return Column(
              children: [
                for (final item in items) ...[
                  _RecentActivityRow(item: item, language: language),
                  if (item != items.last) const SizedBox(height: AppSpacing.sm),
                ],
              ],
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => AppEmptyState(
            icon: Icons.timeline_rounded,
            title: _recentErrorTitle(language),
            message: _recentErrorMessage(language),
          ),
        ),
      ),
    );
  }
}

class _RecentActivityRow extends StatelessWidget {
  const _RecentActivityRow({required this.item, required this.language});

  final _RecentActivityItem item;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: palette.primary.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: palette.primary.withValues(alpha: 0.18)),
          ),
          child: Icon(item.icon, color: palette.primary, size: 18),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: palette.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.ink.withValues(alpha: 0.66),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppBadge(label: _relativeDayLabel(language, item.happenedAt)),
      ],
    );
  }
}

void _openFeaturedTarget(
  BuildContext context,
  _FeaturedHomeItem item, {
  required ContinueAction? continueAction,
  required AppLanguage language,
  required StudyLevel level,
}) {
  switch (item.target) {
    case _FeaturedTarget.continueAction:
      LearningPathScreen._openContinueAction(
        context,
        continueAction,
        language: language,
        level: level,
      );
      return;
    case _FeaturedTarget.foundations:
      context.openFoundations();
      return;
    case _FeaturedTarget.study:
      context.openStudy();
      return;
    case _FeaturedTarget.mistakes:
      context.openMistakes();
      return;
    case _FeaturedTarget.jlpt:
      context.openJlptCoach();
      return;
  }
}

String _foundationsSectionTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Foundations',
  AppLanguage.vi => 'Nền tảng',
  AppLanguage.ja => '基礎',
};

String _foundationsSectionCaption(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Kana, Hán-Việt cues, and review debt before new content.',
  AppLanguage.vi => 'Kana, cầu Hán-Việt và phần ôn nền trước khi học tiếp.',
  AppLanguage.ja => 'かな・漢越の手がかり・復習を先に整えます。',
};

String _dojoTodaySectionTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Today dojo',
  AppLanguage.vi => 'Dojo hôm nay',
  AppLanguage.ja => '今日の道場',
};

String _dojoTodaySectionCaption(AppLanguage language) => switch (language) {
  AppLanguage.en =>
    'One focused lane for due reviews, weak spots, and momentum.',
  AppLanguage.vi =>
    'Một luồng tập trung cho phần đến hạn, điểm yếu và nhịp học.',
  AppLanguage.ja => '期限・弱点・学習リズムを一つにまとめます。',
};

String _featuredTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Featured this week',
  AppLanguage.vi => 'Nổi bật tuần này',
  AppLanguage.ja => '今週のおすすめ',
};

String _featuredCaption(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Ranked from SRS pressure and high-frequency study lanes.',
  AppLanguage.vi =>
    'Xếp theo áp lực SRS và các tuyến học xuất hiện thường xuyên.',
  AppLanguage.ja => 'SRSの期限とよく使う学習ルートから並べます。',
};

String _featuredContinueSubtitle(AppLanguage language, ContinueAction action) {
  final count = action.count;
  if (count == null || count == 0) {
    return switch (language) {
      AppLanguage.en => 'Best next action from your current learning state.',
      AppLanguage.vi => 'Bước tiếp theo hợp nhất với trạng thái học hiện tại.',
      AppLanguage.ja => '現在の学習状態から見た次の一手です。',
    };
  }
  return switch (language) {
    AppLanguage.en =>
      '${language.itemsCountLabel(count)} are asking for attention now.',
    AppLanguage.vi => '$count mục đang cần bạn xử lý ngay.',
    AppLanguage.ja => '$count件が今の優先項目です。',
  };
}

String _featuredDueBadge(AppLanguage language, int dueCount) =>
    switch (language) {
      AppLanguage.en => '$dueCount due',
      AppLanguage.vi => '$dueCount đến hạn',
      AppLanguage.ja => '$dueCount件期限',
    };

String _featuredFoundationsSubtitle(
  AppLanguage language,
  FoundationsProgress progress,
) {
  final remaining = foundationsKanaTotal - progress.studiedCount;
  return switch (language) {
    AppLanguage.en => '$remaining kana still need a first clean pass.',
    AppLanguage.vi => 'Còn $remaining kana cần một lượt nền cho chắc.',
    AppLanguage.ja => '残り$remaining字をまず安定させます。',
  };
}

String _featuredMistakeTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Repair weak spots',
  AppLanguage.vi => 'Sửa điểm yếu',
  AppLanguage.ja => '弱点を補強',
};

String _featuredMistakeSubtitle(AppLanguage language, int count) =>
    switch (language) {
      AppLanguage.en => '$count saved mistakes are ready for a short repair.',
      AppLanguage.vi => '$count lỗi đã lưu đang chờ một lượt sửa ngắn.',
      AppLanguage.ja => '$count件のミスを短く補強できます。',
    };

String _featuredCountBadge(AppLanguage language, int count) =>
    language.itemsCountLabel(count);

String _featuredJlptTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'JLPT readiness',
  AppLanguage.vi => 'Sẵn sàng JLPT',
  AppLanguage.ja => 'JLPT準備',
};

String _featuredJlptSubtitle(AppLanguage language, StudyLevel level) =>
    switch (language) {
      AppLanguage.en => '${level.shortLabel} drills and mock pacing.',
      AppLanguage.vi => 'Bài luyện ${level.shortLabel} và nhịp làm đề.',
      AppLanguage.ja => '${level.shortLabel}の演習と模試ペース。',
    };

String _featuredStudyTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Study lanes',
  AppLanguage.vi => 'Tuyến học',
  AppLanguage.ja => '学習レーン',
};

String _featuredStudySubtitle(AppLanguage language, int dueCount) =>
    switch (language) {
      AppLanguage.en => 'Browse vocab, grammar, kanji, and connected practice.',
      AppLanguage.vi => 'Vào từ vựng, ngữ pháp, kanji và luyện tập liên kết.',
      AppLanguage.ja => '語彙・文法・漢字・連動練習へ進みます。',
    };

String _sidebarTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Week signal',
  AppLanguage.vi => 'Tín hiệu tuần',
  AppLanguage.ja => '週間シグナル',
};

String _sidebarCaption(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Streak and due load stay visible while you scan the page.',
  AppLanguage.vi => 'Chuỗi học và phần đến hạn luôn hiện khi bạn quét trang.',
  AppLanguage.ja => '連続記録と期限数を見失わないための欄です。',
};

String _sidebarToggleLabel(AppLanguage language, bool collapsed) =>
    switch (language) {
      AppLanguage.en => collapsed ? 'Expand sidebar' : 'Collapse sidebar',
      AppLanguage.vi => collapsed ? 'Mở thanh bên' : 'Thu thanh bên',
      AppLanguage.ja => collapsed ? 'サイドバーを開く' : 'サイドバーを閉じる',
    };

String _lessonsDueChip(AppLanguage language, int dueCount) =>
    switch (language) {
      AppLanguage.en => '${language.lessonCountLabel(dueCount)} due',
      AppLanguage.vi => '$dueCount bài đến hạn',
      AppLanguage.ja => '$dueCount件期限',
    };

String _weeklyStreakLabel(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Weekly streak',
  AppLanguage.vi => 'Chuỗi tuần',
  AppLanguage.ja => '週間連続',
};

String _dueShortLabel(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Due',
  AppLanguage.vi => 'Đến hạn',
  AppLanguage.ja => '期限',
};

String _recentActivityTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Recent activity',
  AppLanguage.vi => 'Hoạt động gần đây',
  AppLanguage.ja => '最近の活動',
};

String _recentActivityCaption(AppLanguage language) => switch (language) {
  AppLanguage.en =>
    'Completed sessions, tests, and milestones from the last 7 days.',
  AppLanguage.vi => 'Buổi học, bài kiểm tra và mốc đạt được trong 7 ngày qua.',
  AppLanguage.ja => '直近7日間の学習・テスト・達成記録です。',
};

String _recentEmptyTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'No recent sessions yet',
  AppLanguage.vi => 'Chưa có hoạt động gần đây',
  AppLanguage.ja => '最近の記録はまだありません',
};

String _recentEmptyMessage(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Finish a lesson or review round and it will appear here.',
  AppLanguage.vi => 'Hoàn tất một lượt học hoặc ôn tập, mục đó sẽ hiện ở đây.',
  AppLanguage.ja => '学習や復習を終えるとここに表示されます。',
};

String _recentErrorTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Activity could not load',
  AppLanguage.vi => 'Chưa tải được hoạt động',
  AppLanguage.ja => '活動を読み込めません',
};

String _recentErrorMessage(AppLanguage language) => switch (language) {
  AppLanguage.en => 'The timeline is local-only; try refreshing the home page.',
  AppLanguage.vi =>
    'Timeline chỉ đọc dữ liệu máy này; hãy thử làm mới trang chủ.',
  AppLanguage.ja => 'この端末の記録だけを読むため、ホームを更新してください。',
};

String _recentLearnTitle(AppLanguage language, int lessonId) =>
    switch (language) {
      AppLanguage.en => 'Learn session $lessonId',
      AppLanguage.vi => 'Buổi học $lessonId',
      AppLanguage.ja => '学習セッション $lessonId',
    };

String _recentTestTitle(AppLanguage language, int lessonId) =>
    switch (language) {
      AppLanguage.en => 'Test session $lessonId',
      AppLanguage.vi => 'Bài kiểm tra $lessonId',
      AppLanguage.ja => 'テスト $lessonId',
    };

String _recentAchievementTitle(AppLanguage language, String type) =>
    switch (language) {
      AppLanguage.en => 'Milestone: $type',
      AppLanguage.vi => 'Mốc đạt được: $type',
      AppLanguage.ja => '達成: $type',
    };

String _recentScoreLabel(
  AppLanguage language,
  int correct,
  int total,
  int xp,
) => switch (language) {
  AppLanguage.en => '$correct/$total correct · +$xp XP',
  AppLanguage.vi => '$correct/$total đúng · +$xp XP',
  AppLanguage.ja => '$correct/$total 正解 · +$xp XP',
};

String _recentTestScoreLabel(AppLanguage language, int score, int xp) =>
    switch (language) {
      AppLanguage.en => '$score% score · +$xp XP',
      AppLanguage.vi => 'Điểm $score% · +$xp XP',
      AppLanguage.ja => '$score% · +$xp XP',
    };

String _recentAchievementValue(AppLanguage language, int value) =>
    switch (language) {
      AppLanguage.en => 'Value $value',
      AppLanguage.vi => 'Giá trị $value',
      AppLanguage.ja => '値 $value',
    };

String _relativeDayLabel(AppLanguage language, DateTime happenedAt) {
  final now = DateTime.now();
  final happenedDay = DateTime(
    happenedAt.year,
    happenedAt.month,
    happenedAt.day,
  );
  final today = DateTime(now.year, now.month, now.day);
  final days = today.difference(happenedDay).inDays;
  if (days <= 0) {
    return switch (language) {
      AppLanguage.en => 'Today',
      AppLanguage.vi => 'Hôm nay',
      AppLanguage.ja => '今日',
    };
  }
  if (days == 1) {
    return switch (language) {
      AppLanguage.en => 'Yesterday',
      AppLanguage.vi => 'Hôm qua',
      AppLanguage.ja => '昨日',
    };
  }
  return switch (language) {
    AppLanguage.en => '$days days ago',
    AppLanguage.vi => '$days ngày trước',
    AppLanguage.ja => '$days日前',
  };
}

class _FoundationsFeaturedCard extends StatelessWidget {
  const _FoundationsFeaturedCard({
    required this.language,
    required this.progress,
  });

  final AppLanguage language;
  final FoundationsProgress progress;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return AppSectionCard(
      padding: const EdgeInsets.all(18),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: context.openFoundations,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: palette.success.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.grass_rounded,
                      color: palette.success,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${language.foundationsTitle} - Bảng chữ Hiragana / Katakana / Hán Việt',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: palette.ink,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
              const SizedBox(height: 12),
              AppProgressStrip(
                value: progress.percentComplete,
                label:
                    '${progress.studiedCount}/$foundationsKanaTotal kana (${(progress.percentComplete * 100).round()}%)',
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: AppButton(
                  label: _foundationsCtaLabel(language),
                  icon: Icons.play_arrow_rounded,
                  onPressed: context.openFoundations,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _foundationsCtaLabel(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Start with kana',
  AppLanguage.vi => 'Bắt đầu với bảng chữ',
  AppLanguage.ja => 'かなから始める',
};

class _TextbookRoadmapPanel extends StatelessWidget {
  const _TextbookRoadmapPanel({required this.language, required this.level});

  final AppLanguage language;
  final StudyLevel level;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final roadmap = textbookRoadmapForLevel(level);

    return AppSectionCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: language.textbookRoadmapTitle(),
            caption: language.textbookRoadmapSubtitle(level.shortLabel),
          ),
          const SizedBox(height: 12),
          for (final entry in roadmap.phases.indexed) ...[
            if (entry.$1 > 0) const Divider(height: 20),
            _TextbookPhaseRow(
              language: language,
              level: level,
              phase: entry.$2,
              phaseNumber: entry.$1 + 1,
              color: _phaseColor(palette, entry.$1),
            ),
          ],
        ],
      ),
    );
  }

  Color _phaseColor(AppThemePalette palette, int index) {
    return switch (index % 4) {
      0 => palette.primary,
      1 => palette.accent,
      2 => palette.secondary,
      _ => palette.success,
    };
  }
}

class _TextbookPhaseRow extends StatelessWidget {
  const _TextbookPhaseRow({
    required this.language,
    required this.level,
    required this.phase,
    required this.phaseNumber,
    required this.color,
  });

  final AppLanguage language;
  final StudyLevel level;
  final TextbookRoadmapPhase phase;
  final int phaseNumber;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Text(
            '$phaseNumber',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    language.textbookRoadmapPhaseLabel(phaseNumber),
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    language.textbookRoadmapDuration(phase.durationKey),
                    style: TextStyle(
                      color: palette.ink.withValues(alpha: 0.56),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                language.textbookRoadmapPhaseTitle(phase.id, level.shortLabel),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: palette.ink,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                language.textbookRoadmapPhaseDescription(
                  phase.id,
                  level.shortLabel,
                ),
                style: TextStyle(
                  color: palette.ink.withValues(alpha: 0.68),
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final resource in phase.resources)
                    _TextbookResourceChip(
                      label: language.textbookRoadmapResourceLabel(
                        resource.key,
                      ),
                      optionalLabel: resource.optional
                          ? language.textbookRoadmapOptionalLabel()
                          : null,
                      destination: resource.destination,
                      color: color,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TextbookResourceChip extends StatelessWidget {
  const _TextbookResourceChip({
    required this.label,
    required this.destination,
    required this.color,
    this.optionalLabel,
  });

  final String label;
  final String destination;
  final Color color;
  final String? optionalLabel;

  @override
  Widget build(BuildContext context) {
    final displayLabel = optionalLabel == null
        ? label
        : '$label · $optionalLabel';
    return AppButton(
      label: displayLabel,
      variant: AppButtonVariant.secondary,
      compact: true,
      onPressed: () => context.go(destination),
    );
  }
}

class _DojoHeroCard extends StatelessWidget {
  const _DojoHeroCard({
    required this.language,
    required this.level,
    required this.streak,
    required this.todayXp,
    required this.dueCount,
    required this.weakCount,
    required this.hasStartedToday,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
    this.missionLabel,
  });

  final AppLanguage language;
  final StudyLevel level;
  final int streak;
  final int todayXp;
  final int dueCount;
  final int weakCount;
  final bool hasStartedToday;
  final String? missionLabel;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            palette.heroGradient.first,
            palette.heroGradient.last,
            palette.accent.withValues(alpha: 0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: palette.primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            Positioned(
              top: -18,
              right: -10,
              child: Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.11),
                ),
              ),
            ),
            Positioned(
              bottom: -22,
              left: -10,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.16),
                          ),
                        ),
                        child: const Icon(
                          Icons.spa_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _eyebrow(language),
                              style: const TextStyle(
                                color: Color(0xFFFFF7ED),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _title(
                                language,
                                dueCount: dueCount,
                                weakCount: weakCount,
                              ),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    height: 1.1,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      AppStatusChip(
                        label: level.shortLabel,
                        tone: AppStatusTone.neutral,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _subtitle(
                      language,
                      dueCount: dueCount,
                      weakCount: weakCount,
                      hasStartedToday: hasStartedToday,
                    ),
                    style: const TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 13,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (missionLabel != null &&
                      missionLabel!.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.flag_circle_rounded,
                            color: Color(0xFFFFE4BF),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              missionLabel!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _DojoStatChip(
                        icon: Icons.local_fire_department_rounded,
                        label: _streakLabel(language),
                        value: '$streak',
                      ),
                      _DojoStatChip(
                        icon: Icons.star_rounded,
                        label: _xpLabel(language),
                        value: '$todayXp XP',
                      ),
                      _DojoStatChip(
                        icon: Icons.history_edu_rounded,
                        label: _reviewLabel(language),
                        value: '$dueCount',
                      ),
                      _DojoStatChip(
                        icon: Icons.auto_fix_high_rounded,
                        label: _repairLabel(language),
                        value: '$weakCount',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppButton(
                        label: _primaryLabel(language),
                        icon: Icons.play_arrow_rounded,
                        compact: true,
                        onPressed: onPrimaryTap,
                      ),
                      AppButton(
                        label: _secondaryLabel(language),
                        icon: Icons.quiz_rounded,
                        variant: AppButtonVariant.secondary,
                        compact: true,
                        onPressed: onSecondaryTap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _eyebrow(AppLanguage language) => switch (language) {
    AppLanguage.en => 'TODAY DOJO • 日本語 TRAINING',
    AppLanguage.vi => 'DOJO HÔM NAY • LUYỆN NHẬT NGỮ',
    AppLanguage.ja => '今日の道場 • 日本語トレーニング',
  };

  static String _title(
    AppLanguage language, {
    required int dueCount,
    required int weakCount,
  }) => language.learningHeroTitle(dueCount: dueCount, weakCount: weakCount);

  static String _subtitle(
    AppLanguage language, {
    required int dueCount,
    required int weakCount,
    required bool hasStartedToday,
  }) => language.learningHeroSubtitle(
    dueCount: dueCount,
    weakCount: weakCount,
    hasStartedToday: hasStartedToday,
  );

  static String _streakLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Streak',
    AppLanguage.vi => 'Chuỗi',
    AppLanguage.ja => '連続',
  };

  static String _xpLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Today XP',
    AppLanguage.vi => 'XP hôm nay',
    AppLanguage.ja => '今日のXP',
  };

  static String _reviewLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => language.learningHeroReviewLabel(),
    AppLanguage.vi => language.learningHeroReviewLabel(),
    AppLanguage.ja => language.learningHeroReviewLabel(),
  };

  static String _repairLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => language.learningHeroRepairLabel(),
    AppLanguage.vi => language.learningHeroRepairLabel(),
    AppLanguage.ja => language.learningHeroRepairLabel(),
  };

  static String _primaryLabel(AppLanguage language) =>
      language.learningHeroPrimaryLabel();

  static String _secondaryLabel(AppLanguage language) =>
      language.learningHeroSecondaryLabel();
}

class _DojoStatChip extends StatelessWidget {
  const _DojoStatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFFFE4BF)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFE2E8F0),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LearningLanesPanel extends StatelessWidget {
  const _LearningLanesPanel({
    required this.language,
    required this.level,
    required this.dueCount,
    required this.weakCount,
  });

  final AppLanguage language;
  final StudyLevel level;
  final int dueCount;
  final int weakCount;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return AppSectionCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: _title(language),
            caption: _subtitle(language),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 760;
              final cards = [
                _LaneCard(
                  icon: Icons.hub_rounded,
                  title: _studyLaneTitle(language),
                  subtitle: _studyLaneSubtitle(language, dueCount),
                  ctaLabel: _openLaneLabel(language),
                  chipLabel: dueCount > 0
                      ? _dueChip(language, dueCount)
                      : _readyChip(language),
                  color: palette.primary,
                  onTap: () => context.openStudy(),
                ),
                _LaneCard(
                  icon: Icons.quiz_rounded,
                  title: _jlptLaneTitle(language),
                  subtitle: _jlptLaneSubtitle(language, level),
                  ctaLabel: _openLaneLabel(language),
                  chipLabel: level.shortLabel,
                  color: palette.accent,
                  onTap: () => context.openJlptCoach(),
                ),
                _LaneCard(
                  icon: Icons.auto_stories_rounded,
                  title: _immersionLaneTitle(language),
                  subtitle: _immersionLaneSubtitle(language, weakCount),
                  ctaLabel: _openLaneLabel(language),
                  chipLabel: _immersionChip(language),
                  color: palette.secondary,
                  onTap: () => context.openImmersion(),
                ),
              ];

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: 10),
                    Expanded(child: cards[1]),
                    const SizedBox(width: 10),
                    Expanded(child: cards[2]),
                  ],
                );
              }

              return Column(
                children: [
                  cards[0],
                  const SizedBox(height: 10),
                  cards[1],
                  const SizedBox(height: 10),
                  cards[2],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  static String _title(AppLanguage language) => switch (language) {
    AppLanguage.en => language.learningLanesTitle(),
    AppLanguage.vi => language.learningLanesTitle(),
    AppLanguage.ja => language.learningLanesTitle(),
  };

  static String _subtitle(AppLanguage language) => switch (language) {
    AppLanguage.en => language.learningLanesSubtitle(),
    AppLanguage.vi => language.learningLanesSubtitle(),
    AppLanguage.ja => language.learningLanesSubtitle(),
  };

  static String _studyLaneTitle(AppLanguage language) =>
      language.learningStudyLaneTitle();

  static String _studyLaneSubtitle(AppLanguage language, int dueCount) =>
      language.learningStudyLaneSubtitle(dueCount);

  static String _jlptLaneTitle(AppLanguage language) =>
      language.learningJlptLaneTitle();

  static String _jlptLaneSubtitle(AppLanguage language, StudyLevel level) =>
      language.learningJlptLaneSubtitle(level.shortLabel);

  static String _immersionLaneTitle(AppLanguage language) =>
      language.learningImmersionLaneTitle();

  static String _immersionLaneSubtitle(AppLanguage language, int weakCount) =>
      language.learningImmersionLaneSubtitle(weakCount);

  static String _dueChip(AppLanguage language, int dueCount) =>
      switch (language) {
        AppLanguage.en => '$dueCount due',
        AppLanguage.vi => '$dueCount đến hạn',
        AppLanguage.ja => '$dueCount件待機',
      };

  static String _readyChip(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Ready now',
    AppLanguage.vi => 'Sẵn sàng',
    AppLanguage.ja => '今すぐ開始',
  };

  static String _immersionChip(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Real Japanese',
    AppLanguage.vi => 'Nhật ngữ thật',
    AppLanguage.ja => '実際の日本語',
  };

  static String _openLaneLabel(AppLanguage language) =>
      language.learningOpenLaneLabel();
}

class _LaneCard extends StatelessWidget {
  const _LaneCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.chipLabel,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final String chipLabel;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.16),
                context.appPalette.surface,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.28)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 19),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      chipLabel,
                      style: TextStyle(
                        color: color,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  color: palette.ink,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: palette.ink.withValues(alpha: 0.7),
                  fontSize: 11.5,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ctaLabel,
                      style: TextStyle(
                        color: color,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_outward_rounded, color: color, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FocusChip extends StatelessWidget {
  const _FocusChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
