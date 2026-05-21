import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/app/theme/app_spacing.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/goal_provider.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/onboarding_provider.dart';
import 'package:jpstudy/core/shared_preferences_provider.dart';
import 'package:jpstudy/core/study_goal.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

class GoalSelectionBanner extends ConsumerStatefulWidget {
  const GoalSelectionBanner({super.key});

  @override
  ConsumerState<GoalSelectionBanner> createState() =>
      _GoalSelectionBannerState();
}

class _GoalSelectionBannerState extends ConsumerState<GoalSelectionBanner> {
  static const _skipDuration = Duration(days: 7);
  bool _dismissed = false;
  late bool _skipActive;

  @override
  void initState() {
    super.initState();
    final preferences = ref.read(sharedPreferencesProvider);
    final skipUntilMillis = preferences.getInt(prefOnboardingGoalSkipUntil);
    _skipActive =
        skipUntilMillis != null &&
        DateTime.fromMillisecondsSinceEpoch(
          skipUntilMillis,
        ).isAfter(DateTime.now());
  }

  Future<void> _selectGoal(StudyGoal goal) async {
    final preferences = ref.read(sharedPreferencesProvider);
    await preferences.setString(prefOnboardingGoal, goal.name);
    ref.read(studyGoalProvider.notifier).state = goal;
    if (mounted) {
      setState(() => _dismissed = true);
    }
  }

  Future<void> _skipForNow() async {
    final preferences = ref.read(sharedPreferencesProvider);
    final skipUntil = DateTime.now().add(_skipDuration);
    await preferences.setInt(
      prefOnboardingGoalSkipUntil,
      skipUntil.millisecondsSinceEpoch,
    );
    if (mounted) {
      setState(() {
        _skipActive = true;
        _dismissed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider);
    final goal = ref.watch(studyGoalProvider);
    final show = level != null && goal == null && !_skipActive && !_dismissed;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: show
          ? _GoalBannerContent(
              key: const ValueKey('goal_selection_banner'),
              language: language,
              onSelected: _selectGoal,
              onLater: _skipForNow,
            )
          : const SizedBox.shrink(key: ValueKey('goal_selection_hidden')),
    );
  }
}

class _GoalBannerContent extends StatelessWidget {
  const _GoalBannerContent({
    super.key,
    required this.language,
    required this.onSelected,
    required this.onLater,
  });

  final AppLanguage language;
  final ValueChanged<StudyGoal> onSelected;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return AppCard(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      padding: const EdgeInsets.all(AppSpacing.md),
      borderRadius: 18,
      variant: AppCardVariant.accent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 620;
          final chips = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _GoalChip(
                icon: Icons.assignment_turned_in_rounded,
                label: language.goalJlptOption,
                onTap: () => onSelected(StudyGoal.jlpt),
              ),
              _GoalChip(
                icon: Icons.auto_stories_rounded,
                label: language.goalReadOption,
                onTap: () => onSelected(StudyGoal.reading),
              ),
              _GoalChip(
                icon: Icons.edit_note_rounded,
                label: language.goalWriteOption,
                onTap: () => onSelected(StudyGoal.writing),
              ),
            ],
          );

          final title = Text(
            language.goalBannerTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: palette.ink,
              fontWeight: FontWeight.w900,
            ),
          );

          final later = AppButton(
            label: language.goalLaterAction,
            variant: AppButtonVariant.ghost,
            compact: true,
            onPressed: onLater,
          );

          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                const SizedBox(height: 10),
                chips,
                const SizedBox(height: 4),
                Align(alignment: Alignment.centerRight, child: later),
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 2, child: title),
              Expanded(flex: 4, child: chips),
              const SizedBox(width: 8),
              later,
            ],
          );
        },
      ),
    );
  }
}

class _GoalChip extends StatelessWidget {
  const _GoalChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppButton(label: label, icon: icon, compact: true, onPressed: onTap);
  }
}
