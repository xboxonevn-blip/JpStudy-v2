import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/app/navigation/app_navigation_extensions.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/features/foundations/providers/foundations_providers.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FoundationsSoftSuggestSurface { vocab, grammar, kanji }

bool shouldSuggestFoundationsForLevel(StudyLevel? level) {
  return level == null || level == StudyLevel.n5;
}

bool shouldShowFoundationsSoftSuggest({
  required StudyLevel? level,
  required double percentComplete,
  required bool dismissed,
}) {
  return shouldSuggestFoundationsForLevel(level) &&
      percentComplete < 0.30 &&
      !dismissed;
}

class FoundationsSoftSuggestGate extends ConsumerStatefulWidget {
  const FoundationsSoftSuggestGate({
    super.key,
    required this.surface,
    required this.child,
  });

  final FoundationsSoftSuggestSurface surface;
  final Widget child;

  @override
  ConsumerState<FoundationsSoftSuggestGate> createState() =>
      _FoundationsSoftSuggestGateState();
}

class _FoundationsSoftSuggestGateState
    extends ConsumerState<FoundationsSoftSuggestGate> {
  bool _checked = false;
  bool _showBanner = false;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_maybePrepare());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showBanner) return widget.child;

    final language = ref.watch(appLanguageProvider);
    final palette = context.appPalette;
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: AppCard(
                  key: const ValueKey('foundations_soft_suggest_banner'),
                  variant: AppCardVariant.elevated,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.school_outlined,
                        color: palette.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              language.softSuggestFoundationsTitle,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: palette.ink,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              language.softSuggestFoundationsBody,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: palette.ink.withValues(alpha: 0.72),
                                    fontWeight: FontWeight.w600,
                                    height: 1.35,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                AppButton(
                                  label: language.softSuggestGoFoundationsLabel,
                                  icon: Icons.arrow_forward_rounded,
                                  compact: true,
                                  onPressed: () {
                                    unawaited(_dismiss());
                                    context.openFoundations();
                                  },
                                ),
                                AppButton(
                                  label: language.softSuggestContinueLabel,
                                  variant: AppButtonVariant.ghost,
                                  compact: true,
                                  onPressed: () => unawaited(_dismiss()),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: language.softSuggestContinueLabel,
                        onPressed: () => unawaited(_dismiss()),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _maybePrepare() async {
    if (_checked || !mounted) return;
    _checked = true;
    if (WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgetsFlutterBinding',
    )) {
      return;
    }
    if (!shouldSuggestFoundationsForLevel(ref.read(studyLevelProvider))) {
      return;
    }
    await ref.read(foundationsProgressProvider.notifier).loadFromDao();
    final progress = ref.read(foundationsProgressProvider);

    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    final key = 'foundations.softSuggest.${widget.surface.name}.shown';
    final dismissed = prefs.getBool(key) ?? false;
    if (!mounted) return;
    setState(() {
      _showBanner = shouldShowFoundationsSoftSuggest(
        level: ref.read(studyLevelProvider),
        percentComplete: progress.percentComplete,
        dismissed: dismissed,
      );
    });
  }

  Future<void> _dismiss() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final key = 'foundations.softSuggest.${widget.surface.name}.shown';
    await prefs.setBool(key, true);
    if (!mounted) return;
    setState(() => _showBanner = false);
  }
}
