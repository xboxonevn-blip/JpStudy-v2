import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/features/common/widgets/japanese_background.dart';
import 'package:jpstudy/features/home/models/lesson_node.dart';
import 'package:jpstudy/features/home/models/unit.dart';
import 'package:jpstudy/features/home/viewmodels/learning_path_viewmodel.dart';
import 'package:jpstudy/features/home/widgets/continue_button.dart';
import 'package:jpstudy/features/home/widgets/ghost_review_banner.dart';
import 'package:jpstudy/features/home/widgets/mini_dashboard.dart';
import 'package:jpstudy/features/home/widgets/practice_hub.dart';
import 'package:jpstudy/features/home/widgets/unit_map_widget.dart';
import 'package:jpstudy/features/grammar/screens/grammar_practice_screen.dart';
import 'package:jpstudy/features/test/widgets/practice_test_dashboard.dart';

class LearningPathScreen extends ConsumerWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pathState = ref.watch(learningPathViewModelProvider);
    final selectedLevel = ref.watch(studyLevelProvider);
    final language = ref.watch(appLanguageProvider);

    return pathState.when(
      data: (allUnits) {
        final units = selectedLevel == null
            ? allUnits
            : allUnits.where((u) => u.id == selectedLevel.shortLabel).toList();

        if (units.isEmpty) {
          return Center(child: Text(language.noLessonsForLevelLabel));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1100;
            return JapaneseBackground(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 68),
                  child: isDesktop
                      ? _buildDesktopLayout(context, units, language)
                      : _buildMobileLayout(context, units, language),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(language.loadErrorLabel)),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    List<Unit> units,
    AppLanguage language,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildFocusCard(context, language)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 10),
            child: MiniDashboard(),
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
            padding: EdgeInsets.only(top: 4),
            child: Column(
              children: [
                ContinueButton(),
                GhostReviewBanner(),
                SizedBox(height: 10),
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

  Widget _buildDesktopLayout(
    BuildContext context,
    List<Unit> units,
    AppLanguage language,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1520),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            children: [
              _buildFocusCard(context, language, compact: true),
              const SizedBox(height: 8),
              const MiniDashboard(),
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: _panelDecoration(),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(8, 12, 8, 90),
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
                    const SizedBox(width: 14),
                    SizedBox(
                      width: 420,
                      child: DecoratedBox(
                        decoration: _panelDecoration(),
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(6, 10, 6, 90),
                          children: [
                            ContinueButton(),
                            GhostReviewBanner(),
                            SizedBox(height: 10),
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

  Widget _buildFocusCard(
    BuildContext context,
    AppLanguage language, {
    bool compact = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, compact ? 0 : 6, 16, 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openQuickPracticeSheet(context, language),
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              16,
              compact ? 14 : 16,
              16,
              compact ? 14 : 16,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF134E4A),
                  Color(0xFF1D4ED8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26203B53),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.continueJourneyLabel.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFFCFFAFE),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        language.practiceHubSubtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: compact ? 90 : 108,
                  height: compact ? 90 : 108,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.26),
                    ),
                  ),
                  child: IconButton(
                    tooltip: language.practiceHubTitle,
                    onPressed: () => _openQuickPracticeSheet(context, language),
                    icon: const Icon(
                      Icons.tune_rounded,
                      color: Color(0xFFBAE6FD),
                      size: 34,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openQuickPracticeSheet(
    BuildContext context,
    AppLanguage language,
  ) async {
    final items = <_QuickPracticeItem>[
      _QuickPracticeItem(
        label: language.practiceMatchLabel,
        subtitle: language.practiceMatchSubtitle,
        icon: Icons.extension_rounded,
        route: '/match',
      ),
      _QuickPracticeItem(
        label: language.practiceGhostLabel,
        subtitle: language.practiceGhostSubtitle,
        icon: Icons.auto_fix_high_rounded,
        route: '/grammar-practice',
        extra: GrammarPracticeMode.ghost,
      ),
      _QuickPracticeItem(
        label: language.practiceKanjiDashLabel,
        subtitle: language.practiceKanjiDashSubtitle,
        icon: Icons.flash_on_rounded,
        route: '/kanji-dash',
      ),
      _QuickPracticeItem(
        label: language.practiceExamLabel,
        subtitle: language.practiceExamSubtitle,
        icon: Icons.quiz_rounded,
        route: '/exam',
      ),
      _QuickPracticeItem(
        label: language.practiceImmersionLabel,
        subtitle: language.practiceImmersionSubtitle,
        icon: Icons.newspaper_rounded,
        route: '/immersion',
      ),
      _QuickPracticeItem(
        label: language.practiceMistakesLabel,
        subtitle: language.practiceMistakesSubtitle,
        icon: Icons.warning_amber_rounded,
        route: '/mistakes',
      ),
    ];

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 6),
                child: Text(
                  language.practiceHubTitle,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              ...items.map(
                (item) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFE6F0FF),
                    child: Icon(item.icon, color: const Color(0xFF2563EB)),
                  ),
                  title: Text(item.label),
                  subtitle: Text(item.subtitle),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    if (item.extra != null) {
                      context.push(item.route, extra: item.extra);
                    } else {
                      context.push(item.route);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleNodeTap(BuildContext context, LessonNode node) {
    context.push('/lesson/${node.lesson.id}');
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xF8FFFFFF), Color(0xECF7FCFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: const Color(0xFFDCE8F8)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x12263D57),
          blurRadius: 22,
          offset: Offset(0, 10),
        ),
      ],
    );
  }
}

class _QuickPracticeItem {
  const _QuickPracticeItem({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.extra,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final String route;
  final Object? extra;
}
