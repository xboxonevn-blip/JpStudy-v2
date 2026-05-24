part of 'lesson_detail_screen.dart';

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.language,
    required this.termsAsync,
    required this.term,
    required this.showHints,
    required this.compactHint,
    required this.showExampleMode,
    required this.frontShowsJapanese,
    required this.isFlipped,
    required this.trackProgress,
    required this.isStarred,
    required this.onShowHintsChanged,
    required this.onFlip,
    required this.onStar,
    this.onEdit,
    this.onStartLearning,
    this.emptyLabel,
  });

  final AppLanguage language;
  final AsyncValue<List<UserLessonTermData>> termsAsync;
  final UserLessonTermData? term;
  final bool showHints;
  final bool compactHint;
  final bool showExampleMode;
  final bool frontShowsJapanese;
  final bool isFlipped;
  final bool trackProgress;
  final bool isStarred;
  final ValueChanged<bool> onShowHintsChanged;
  final VoidCallback? onFlip;
  final VoidCallback? onEdit;
  final VoidCallback? onStar;
  final VoidCallback? onStartLearning;
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      decoration: BoxDecoration(
        color: palette.elevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.outline),
        boxShadow: [
          BoxShadow(
            color: palette.ink.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 18),
                    const SizedBox(width: 6),
                    Text(language.showHintsLabel),
                    const SizedBox(width: 8),
                    Switch(value: showHints, onChanged: onShowHintsChanged),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onStar,
                      icon: Icon(
                        isStarred
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: isStarred
                            ? palette.warning
                            : palette.ink.withValues(alpha: 0.4),
                        size: 26,
                      ),
                      tooltip: language.starLabel,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: AppTouchTargets.min,
                        minHeight: AppTouchTargets.min,
                      ),
                    ),
                    if (onEdit != null) ...[
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: onEdit,
                        icon: Icon(
                          Icons.edit_outlined,
                          color: palette.ink.withValues(alpha: 0.64),
                          size: 22,
                        ),
                        tooltip: language.editLabel,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: AppTouchTargets.min,
                          minHeight: AppTouchTargets.min,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: onFlip,
                child: _CardContent(
                  language: language,
                  termsAsync: termsAsync,
                  term: term,
                  showHints: showHints,
                  compactHint: compactHint,
                  showExampleMode: showExampleMode,
                  frontShowsJapanese: frontShowsJapanese,
                  isFlipped: isFlipped,
                  emptyLabel: emptyLabel,
                  onStartLearning: onStartLearning,
                ),
              ),
            ),
          ),
          if (trackProgress) _ShortcutBar(language: language),
        ],
      ),
    );
  }
}

class _CardContent extends ConsumerWidget {
  static final _whitespaceRe = RegExp(r'\s+');

  const _CardContent({
    required this.language,
    required this.termsAsync,
    required this.term,
    required this.showHints,
    required this.compactHint,
    required this.showExampleMode,
    required this.frontShowsJapanese,
    required this.isFlipped,
    required this.emptyLabel,
    this.onStartLearning,
  });

  final AppLanguage language;
  final AsyncValue<List<UserLessonTermData>> termsAsync;
  final UserLessonTermData? term;
  final bool showHints;
  final bool compactHint;
  final bool showExampleMode;
  final bool frontShowsJapanese;
  final bool isFlipped;
  final String? emptyLabel;
  final VoidCallback? onStartLearning;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.appPalette;
    if (termsAsync.isLoading) {
      return const CircularProgressIndicator();
    }
    if (termsAsync.hasError) {
      return Text(language.loadErrorLabel);
    }
    final resolvedTerm = term;
    if (resolvedTerm == null) {
      if (onStartLearning != null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emptyLabel ?? '',
              style: TextStyle(color: palette.ink.withValues(alpha: 0.64)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onStartLearning,
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(language.startLearningLabel),
            ),
          ],
        );
      }
      final label = emptyLabel;
      if (label == null || label.isEmpty) {
        return const SizedBox.shrink();
      }
      return Text(
        label,
        style: TextStyle(color: palette.ink.withValues(alpha: 0.64)),
        textAlign: TextAlign.center,
      );
    }

    final hintMeaning = resolvedTerm.displayDefinition(language);
    final contextExamples = showExampleMode
        ? _contextExamples(resolvedTerm)
        : const <VocabExampleSentence>[];
    final contextHint = _contextHint(
      resolvedTerm,
      language,
      hintMeaning,
      contextExamples,
    );
    final showBack = isFlipped && hintMeaning.trim().isNotEmpty;
    final hintSource = showExampleMode ? contextHint : hintMeaning;
    final frontHint = compactHint
        ? _compactHint(hintSource, resolvedTerm.id)
        : hintSource;
    final showReading = shouldShowReading(
      term: resolvedTerm.term,
      reading: resolvedTerm.reading,
    );

    final backMeaning = hintMeaning;

    final front = frontShowsJapanese
        ? _japaneseFace(
            key: ValueKey('front_japanese_$showExampleMode'),
            language: language,
            palette: palette,
            term: resolvedTerm,
            showReading: showReading,
            showHints: showHints,
            hint: frontHint,
            onSpeak: () => _speakJapaneseAudio(
              context,
              ref,
              japaneseTtsText(
                term: resolvedTerm.term,
                reading: resolvedTerm.reading,
              ),
            ),
          )
        : _meaningFace(
            key: ValueKey('front_meaning_$showExampleMode'),
            language: language,
            palette: palette,
            meaning: frontHint,
            kanjiMeaning: resolvedTerm.kanjiMeaning,
            examples: contextExamples,
            onSpeakExample: (text) => _speakJapaneseAudio(context, ref, text),
          );

    final back = frontShowsJapanese
        ? _meaningFace(
            key: ValueKey('back_meaning_$showExampleMode'),
            language: language,
            palette: palette,
            meaning: backMeaning,
            kanjiMeaning: resolvedTerm.kanjiMeaning,
            examples: contextExamples,
            onSpeakExample: (text) => _speakJapaneseAudio(context, ref, text),
          )
        : _japaneseFace(
            key: ValueKey('back_japanese_$showExampleMode'),
            language: language,
            palette: palette,
            term: resolvedTerm,
            showReading: showReading,
            showHints: false,
            hint: '',
            onSpeak: () => _speakJapaneseAudio(
              context,
              ref,
              japaneseTtsText(
                term: resolvedTerm.term,
                reading: resolvedTerm.reading,
              ),
            ),
          );

    return AnimatedSwitcher(
      duration: reducedMotionDuration(
        context,
        const Duration(milliseconds: 320),
      ),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        final rotate = Tween(begin: pi, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotate,
          child: child,
          builder: (context, child) {
            final isUnder = child?.key != ValueKey(showBack);
            var value = rotate.value;
            if (isUnder) {
              value = min(rotate.value, pi / 2);
            }
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value);
            return Transform(
              transform: transform,
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      },
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: [...previousChildren, ?currentChild],
        );
      },
      child: showBack ? back : front,
    );
  }

  Widget _japaneseFace({
    required Key key,
    required AppLanguage language,
    required AppThemePalette palette,
    required UserLessonTermData term,
    required bool showReading,
    required bool showHints,
    required String hint,
    required VoidCallback onSpeak,
  }) {
    return _CardFace(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton.filledTonal(
              key: const ValueKey('lesson_flashcard_audio'),
              tooltip: 'Play Japanese audio',
              onPressed: onSpeak,
              icon: const Icon(Icons.volume_up_rounded),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            language.termLabel,
            style: TextStyle(
              fontSize: 12,
              color: palette.ink.withValues(alpha: 0.64),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            term.term,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: palette.ink,
            ),
            textAlign: TextAlign.center,
          ),
          if (showReading) ...[
            const SizedBox(height: 20),
            Text(
              language.readingLabel,
              style: TextStyle(
                fontSize: 12,
                color: palette.ink.withValues(alpha: 0.64),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              term.reading.trim(),
              style: TextStyle(
                fontSize: 18,
                color: palette.ink.withValues(alpha: 0.64),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (showHints && hint.trim().isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              language.meaningLabel,
              style: TextStyle(
                fontSize: 12,
                color: palette.ink.withValues(alpha: 0.64),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hint,
              style: TextStyle(
                fontSize: 16,
                color: palette.ink.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _meaningFace({
    required Key key,
    required AppLanguage language,
    required AppThemePalette palette,
    required String meaning,
    required String kanjiMeaning,
    required List<VocabExampleSentence> examples,
    required ValueChanged<String> onSpeakExample,
  }) {
    return _CardFace(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            language == AppLanguage.en
                ? language.meaningEnLabel
                : language.meaningLabel,
            style: TextStyle(
              fontSize: 12,
              color: palette.ink.withValues(alpha: 0.64),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            meaning.trim().isEmpty ? '-' : meaning,
            style: TextStyle(fontSize: 18, color: palette.ink),
            textAlign: TextAlign.center,
          ),
          if (examples.isNotEmpty) ...[
            const SizedBox(height: 18),
            for (var index = 0; index < examples.length; index++) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      examples[index].ja,
                      style: TextStyle(
                        fontSize: 17,
                        color: palette.ink,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (examples[index].ja.trim().isNotEmpty) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      key: ValueKey('lesson_flashcard_example_audio_$index'),
                      tooltip: 'Play Japanese audio',
                      onPressed: () => onSpeakExample(examples[index].ja),
                      icon: const Icon(Icons.volume_up_rounded),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Text(
                examples[index].vi,
                style: TextStyle(
                  fontSize: 15,
                  color: palette.ink.withValues(alpha: 0.72),
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
              ),
              if (index < examples.length - 1) const SizedBox(height: 12),
            ],
          ],
          if (language == AppLanguage.vi && kanjiMeaning.trim().isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              language.kanjiMeaningLabel,
              style: TextStyle(
                fontSize: 12,
                color: palette.ink.withValues(alpha: 0.64),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              kanjiMeaning,
              style: TextStyle(
                fontSize: 16,
                color: palette.ink.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  String _contextHint(
    UserLessonTermData term,
    AppLanguage language,
    String fallback,
    List<VocabExampleSentence> examples,
  ) {
    if (examples.isNotEmpty) {
      final example = examples.first;
      return switch (language) {
        AppLanguage.ja => example.ja,
        AppLanguage.en || AppLanguage.vi => '${example.ja}\n${example.vi}',
      };
    }
    final mnemonic = switch (language) {
      AppLanguage.vi => term.mnemonicVi,
      AppLanguage.en || AppLanguage.ja => term.mnemonicEn,
    };
    final clean = mnemonic.trim();
    return clean.isEmpty ? fallback : clean;
  }

  List<VocabExampleSentence> _contextExamples(UserLessonTermData term) {
    return parseVocabExampleSentences(
      term.exampleSentencesJson,
    ).take(1).toList(growable: false);
  }

  String _compactHint(String meaning, int seed) {
    final clean = meaning.replaceAll('\n', ' ').trim();
    if (clean.isEmpty) return '';
    final compact = clean.replaceAll(_whitespaceRe, '');
    if (compact.isEmpty) return '';

    var take = compact.length <= 2 ? compact.length : (seed.abs() % 2) + 2;
    if (take > compact.length) take = compact.length;
    final maxStart = compact.length - take;
    final start = maxStart <= 0 ? 0 : ((seed.abs() ~/ 11) % (maxStart + 1));
    return compact.substring(start, start + take);
  }
}

Future<void> _speakJapaneseAudio(
  BuildContext context,
  WidgetRef ref,
  String text,
) async {
  final result = await ref.read(ttsServiceProvider).speak(text);
  if (!context.mounted) return;
  final language = ref.read(appLanguageProvider);
  final message = switch (result.status) {
    TtsSpeakStatus.queued => switch (language) {
      AppLanguage.en => 'Audio queued.',
      AppLanguage.vi => 'Đã phát âm.',
      AppLanguage.ja => '音声を再生しました。',
    },
    TtsSpeakStatus.empty => switch (language) {
      AppLanguage.en => 'No Japanese text to read.',
      AppLanguage.vi => 'Chưa có tiếng Nhật để phát âm.',
      AppLanguage.ja => '読み上げる日本語がありません。',
    },
    TtsSpeakStatus.unavailable => 'Trình duyệt không có giọng tiếng Nhật.',
    TtsSpeakStatus.error => switch (language) {
      AppLanguage.en => 'Could not play Japanese audio.',
      AppLanguage.vi => 'Chưa phát được âm thanh tiếng Nhật.',
      AppLanguage.ja => '日本語音声を再生できませんでした。',
    },
  };
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(result.message ?? message)));
}

class _CardFace extends StatelessWidget {
  const _CardFace({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class _ShortcutBar extends StatelessWidget {
  const _ShortcutBar({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: palette.primary.withValues(alpha: 0.08),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: palette.elevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.keyboard, size: 16),
          ),
          const SizedBox(width: 10),
          Text(
            language.shortcutLabel,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              language.shortcutInstruction,
              style: TextStyle(color: palette.ink.withValues(alpha: 0.7)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
