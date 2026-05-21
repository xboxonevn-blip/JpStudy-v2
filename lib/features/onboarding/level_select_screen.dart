import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/layout/app_responsive_frame.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/app/theme/app_breakpoints.dart';
import 'package:jpstudy/app/theme/app_spacing.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/onboarding_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/features/common/widgets/japanese_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelSelectScreen extends ConsumerStatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  ConsumerState<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends ConsumerState<LevelSelectScreen> {
  StudyLevel? _selectedLevel;
  bool _isSaving = false;

  Future<void> _start() async {
    final selected = _selectedLevel;
    if (selected == null || _isSaving) {
      return;
    }
    setState(() => _isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    await setPersistedStudyLevel(ref, selected);
    await prefs.setBool(prefOnboardingCompleted, true);
    ref.read(onboardingDoneProvider.notifier).state = true;

    if (!mounted) {
      return;
    }
    context.go(_returnTarget());
  }

  String _returnTarget() {
    final from = GoRouterState.of(context).uri.queryParameters['from'];
    if (from == null ||
        from.isEmpty ||
        from == AppRoutePath.onboardingLanguage ||
        from == AppRoutePath.onboardingLevel) {
      return AppRoutePath.home;
    }
    return from;
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);

    return Scaffold(
      body: JapaneseBackground(
        child: SafeArea(
          child: Center(
            child: AppResponsiveFrame(
              minHorizontalPadding: AppSpacing.lg,
              child: SizedBox(
                key: const ValueKey('level_select_adaptive_frame'),
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= AppBreakpoints.desktop;
                    final intro = _LevelIntro(
                      title: language.chooseLevelTitle,
                      subtitle: language.chooseLevelSubtitle,
                    );
                    final options = _LevelOptions(
                      language: language,
                      selectedLevel: _selectedLevel,
                      isSaving: _isSaving,
                      onSelect: (level) =>
                          setState(() => _selectedLevel = level),
                      onStart: _start,
                    );

                    if (wide) {
                      return Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: intro),
                            const SizedBox(width: AppSpacing.xxxl),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 680,
                                  ),
                                  child: options,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Spacer(),
                          intro,
                          const SizedBox(height: AppSpacing.xl),
                          options,
                          const Spacer(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelIntro extends StatelessWidget {
  const _LevelIntro({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: palette.ink,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: TextStyle(
            color: palette.ink.withValues(alpha: 0.62),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _LevelOptions extends StatelessWidget {
  const _LevelOptions({
    required this.language,
    required this.selectedLevel,
    required this.isSaving,
    required this.onSelect,
    required this.onStart,
  });

  final AppLanguage language;
  final StudyLevel? selectedLevel;
  final bool isSaving;
  final ValueChanged<StudyLevel> onSelect;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final level in StudyLevel.values)
          _LevelOptionTile(
            level: level,
            tagline: _taglineFor(language, level),
            selected: selectedLevel == level,
            onTap: () => onSelect(level),
          ),
        const SizedBox(height: AppSpacing.md),
        ElevatedButton(
          key: const ValueKey('level_start'),
          onPressed: selectedLevel == null || isSaving ? null : onStart,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: palette.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: palette.outline,
            disabledForegroundColor: palette.ink.withValues(alpha: 0.45),
          ),
          child: Text(language.levelStartAction),
        ),
      ],
    );
  }

  String _taglineFor(AppLanguage language, StudyLevel level) => switch (level) {
    StudyLevel.n5 => language.levelN5Tagline,
    StudyLevel.n4 => language.levelN4Tagline,
    StudyLevel.n3 => language.levelN3Tagline,
    StudyLevel.n2 => language.levelN2Tagline,
    StudyLevel.n1 => language.levelN1Tagline,
  };
}

class _LevelOptionTile extends StatelessWidget {
  const _LevelOptionTile({
    required this.level,
    required this.tagline,
    required this.selected,
    required this.onTap,
  });

  final StudyLevel level;
  final String tagline;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: selected
                ? palette.primary.withValues(alpha: 0.08)
                : palette.elevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? palette.primary : palette.outline,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 52,
                child: Text(
                  level.shortLabel,
                  style: TextStyle(
                    color: selected ? palette.primary : palette.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  tagline,
                  style: TextStyle(
                    color: palette.ink.withValues(alpha: 0.68),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded, color: palette.primary),
            ],
          ),
        ),
      ),
    );
  }
}
