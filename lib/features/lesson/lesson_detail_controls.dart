part of 'lesson_detail_screen.dart';

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.language,
    required this.total,
    required this.learned,
    required this.due,
  });

  final AppLanguage language;
  final int total;
  final int learned;
  final int due;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _StatChip(label: language.statsTotalLabel, value: total.toString()),
        _StatChip(label: language.statsLearnedLabel, value: learned.toString()),
        _StatChip(label: language.statsDueLabel, value: due.toString()),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.elevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: palette.ink.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ReviewActions extends StatelessWidget {
  const _ReviewActions({
    required this.language,
    required this.enabled,
    required this.onRate,
  });

  final AppLanguage language;
  final bool enabled;
  final ValueChanged<ConfidenceLevel>? onRate;

  @override
  Widget build(BuildContext context) {
    return enabled
        ? ConfidenceRatingWidget(
            language: language,
            onSelect: (level) => onRate?.call(level),
          )
        : const SizedBox.shrink();
  }
}

class _ReviewSummary extends StatelessWidget {
  const _ReviewSummary({
    required this.language,
    required this.reviewed,
    required this.again,
    required this.hard,
    required this.good,
    required this.easy,
  });

  final AppLanguage language;
  final int reviewed;
  final int again;
  final int hard;
  final int good;
  final int easy;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _SummaryChip(label: language.reviewedLabel, value: reviewed.toString()),
        _SummaryChip(label: language.reviewAgainLabel, value: again.toString()),
        _SummaryChip(label: language.reviewHardLabel, value: hard.toString()),
        _SummaryChip(label: language.reviewGoodLabel, value: good.toString()),
        _SummaryChip(label: language.reviewEasyLabel, value: easy.toString()),
      ],
    );
  }
}

class _LessonBreadcrumbBar extends StatelessWidget {
  const _LessonBreadcrumbBar({
    required this.levelCode,
    required this.lessonTitle,
  });

  final String levelCode;
  final String lessonTitle;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '$levelCode / $lessonTitle',
        key: const ValueKey('lesson_breadcrumb_bar'),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: palette.ink.withValues(alpha: 0.64),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({
    required this.language,
    required this.title,
    required this.canGoPrevious,
    required this.onPrevious,
    required this.onNext,
    required this.onReport,
    required this.onWrite,
  });

  final AppLanguage language;
  final String title;
  final bool canGoPrevious;
  final VoidCallback? onPrevious;
  final VoidCallback onNext;
  final VoidCallback onReport;
  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('lesson_header'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              key: const ValueKey('lesson_prev_button'),
              onPressed: canGoPrevious ? onPrevious : null,
              icon: const Icon(Icons.chevron_left_rounded),
              label: Text(_previousLabel(language)),
            ),
            OutlinedButton.icon(
              key: const ValueKey('lesson_next_button'),
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right_rounded),
              label: Text(_nextLabel(language)),
            ),
            OutlinedButton.icon(
              key: const ValueKey('lesson_report_button'),
              onPressed: onReport,
              icon: const Icon(Icons.flag_outlined),
              label: Text(_reportLabel(language)),
            ),
            FilledButton.icon(
              key: const ValueKey('lesson_write_button'),
              onPressed: onWrite,
              icon: const Icon(Icons.edit_note_rounded),
              label: Text(_writeLabel(language)),
            ),
          ],
        ),
      ],
    );
  }

  String _previousLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Previous',
    AppLanguage.vi => 'Bài trước',
    AppLanguage.ja => '前へ',
  };

  String _nextLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Next',
    AppLanguage.vi => 'Bài tiếp',
    AppLanguage.ja => '次へ',
  };

  String _reportLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Report',
    AppLanguage.vi => 'Góp ý',
    AppLanguage.ja => '報告',
  };

  String _writeLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Writing',
    AppLanguage.vi => 'Luyện viết',
    AppLanguage.ja => '書く',
  };
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.elevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: palette.ink.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _SavedPill extends StatelessWidget {
  const _SavedPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? palette.primary.withValues(alpha: 0.1)
              : palette.elevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? palette.primary.withValues(alpha: 0.22)
                : palette.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? Icons.star : Icons.star_border,
              size: 16,
              color: active ? palette.primary : null,
            ),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({required this.language, required this.onSelected});

  final AppLanguage language;
  final ValueChanged<_MenuAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuAction>(
      onSelected: onSelected,
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _MenuAction.reset,
          child: Text(language.resetProgressLabel),
        ),
        PopupMenuItem(
          value: _MenuAction.report,
          child: Text(language.reportLabel),
        ),
      ],
    );
  }
}

class _ModeSwitcher extends StatelessWidget {
  const _ModeSwitcher({
    required this.language,
    required this.mode,
    required this.onModeChanged,
  });

  final AppLanguage language;
  final _LessonMode mode;
  final ValueChanged<_LessonMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SegmentedButton<_LessonMode>(
          segments: [
            ButtonSegment(
              value: _LessonMode.flashcards,
              label: Text(language.flashcardsAction),
            ),
            ButtonSegment(
              value: _LessonMode.review,
              label: Text(language.reviewAction),
            ),
          ],
          selected: {mode},
          onSelectionChanged: (selection) {
            if (selection.isNotEmpty) {
              onModeChanged(selection.first);
            }
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return palette.primary;
              }
              return palette.elevated;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return palette.ink;
            }),
            side: WidgetStateProperty.all(BorderSide(color: palette.outline)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}

class _LessonModePicker extends StatelessWidget {
  const _LessonModePicker({
    required this.language,
    required this.lessonId,
    required this.lessonTitle,
    required this.hasConjugation,
    this.onConjugationTap,
  });

  final AppLanguage language;
  final int lessonId;
  final String lessonTitle;
  final bool hasConjugation;
  final VoidCallback? onConjugationTap;

  @override
  Widget build(BuildContext context) {
    final breakpoint = Breakpoints.fromWidth(MediaQuery.sizeOf(context).width);
    if (breakpoint == Breakpoint.mobile) {
      return Align(
        alignment: Alignment.centerLeft,
        child: FilledButton.icon(
          key: const ValueKey('lesson_mode_picker_sheet_trigger'),
          onPressed: () => _openModeSheet(context),
          icon: const Icon(Icons.tune_rounded),
          label: Text(_practiceModesLabel(language)),
        ),
      );
    }
    return _buildModeOptions(context);
  }

  void _openModeSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: SingleChildScrollView(
              child: Column(
                key: const ValueKey('lesson_mode_picker_sheet'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _practiceModesLabel(language),
                    style: Theme.of(sheetContext).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 14),
                  _buildModeOptions(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeOptions(BuildContext context) {
    return Wrap(
      key: const ValueKey('lesson_mode_picker'),
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        _PracticeButton(
          key: const ValueKey('lesson_mode_flashcard'),
          label: language.flashcardsAction,
          onTap: () => context.openLessonLearn(lessonId, title: lessonTitle),
        ),
        _PracticeButton(
          key: const ValueKey('lesson_mode_recognition'),
          label: _modeLabel(language, 'MCQ', 'Trắc nghiệm', '選択'),
          onTap: () => context.openLessonTest(lessonId, title: lessonTitle),
        ),
        _PracticeButton(
          key: const ValueKey('lesson_mode_sentence_sort'),
          label: _modeLabel(language, 'Sentence sort', 'Sắp câu', '並べ替え'),
          onTap: () => context.openLessonMatch(lessonId, title: lessonTitle),
        ),
        _PracticeButton(
          key: const ValueKey('lesson_mode_typing'),
          label: language.writeModeTypingLabel,
          onTap: () => context.openLessonWrite(lessonId, title: lessonTitle),
        ),
        _PracticeButton(
          key: const ValueKey('lesson_mode_reading'),
          label: _modeLabel(language, 'Reading', 'Đọc hiểu', '読解'),
          onTap: context.openJlptReading,
        ),
        _PracticeButton(
          key: const ValueKey('lesson_mode_listening'),
          label: _modeLabel(language, 'Listening', 'Nghe', '聴解'),
          onTap: () =>
              context.openLessonListening(lessonId, title: lessonTitle),
        ),
        if (hasConjugation)
          _PracticeButton(
            key: const ValueKey('lesson_mode_conjugation'),
            label: _modeLabel(language, 'Conjugation', 'Chia thể', '活用'),
            onTap: onConjugationTap ?? () {},
          ),
      ],
    );
  }

  String _practiceModesLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Practice modes',
    AppLanguage.vi => 'Chế độ luyện tập',
    AppLanguage.ja => '練習モード',
  };

  String _modeLabel(AppLanguage language, String en, String vi, String ja) =>
      switch (language) {
        AppLanguage.en => en,
        AppLanguage.vi => vi,
        AppLanguage.ja => ja,
      };
}

class _ConjugationAwareModeBlock extends ConsumerWidget {
  const _ConjugationAwareModeBlock({
    required this.language,
    required this.levelCode,
    required this.series,
    required this.lessonId,
    required this.storageLessonId,
    required this.lessonTitle,
    required this.termsLoaded,
  });

  final AppLanguage language;
  final String levelCode;
  final String series;
  final int lessonId;
  final int storageLessonId;
  final String lessonTitle;
  final bool termsLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!termsLoaded) {
      return _LessonModePicker(
        language: language,
        lessonId: storageLessonId,
        lessonTitle: lessonTitle,
        hasConjugation: false,
      );
    }
    final repo = ref.watch(conjugationRepositoryProvider);
    return FutureBuilder<List<ConjugationLemmaData>>(
      future: repo.fetchByLesson(levelCode, lessonId, series: series, limit: 8),
      builder: (context, snapshot) {
        final lemmas = snapshot.data ?? const <ConjugationLemmaData>[];
        final ids = lemmas
            .map((lemma) => lemma.contentVocabId)
            .toList(growable: false);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _LessonModePicker(
              language: language,
              lessonId: storageLessonId,
              lessonTitle: lessonTitle,
              hasConjugation: lemmas.isNotEmpty,
              onConjugationTap: lemmas.isEmpty
                  ? null
                  : () => context.openConjugationPractice(
                      ConjugationPracticeArgs(
                        contentVocabIds: ids,
                        targetCount: 50,
                        source: 'lesson_mode_picker',
                      ),
                    ),
            ),
            if (lemmas.isNotEmpty) ...[
              const SizedBox(height: 12),
              ConjugationLessonWidget(
                levelCode: levelCode,
                lessonId: lessonId,
                series: series,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _PracticeButton extends StatelessWidget {
  const _PracticeButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.ink,
        side: BorderSide(color: palette.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      child: Text(label),
    );
  }
}

class _LessonTermList extends StatelessWidget {
  const _LessonTermList({
    required this.language,
    required this.terms,
    required this.lessonId,
    required this.lessonTitle,
  });

  final AppLanguage language;
  final List<UserLessonTermData> terms;
  final int lessonId;
  final String lessonTitle;

  @override
  Widget build(BuildContext context) {
    if (terms.isEmpty) return const SizedBox.shrink();
    return Column(
      key: const ValueKey('lesson_term_list'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _title(language),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        for (var index = 0; index < terms.length; index++) ...[
          _LessonTermCard(
            language: language,
            term: terms[index],
            index: index,
            lessonId: lessonId,
            lessonTitle: lessonTitle,
          ),
          if (index != terms.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }

  String _title(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Terms in this lesson',
    AppLanguage.vi => 'Từ trong bài',
    AppLanguage.ja => 'この課の語彙',
  };
}

class _LessonTermCard extends ConsumerWidget {
  const _LessonTermCard({
    required this.language,
    required this.term,
    required this.index,
    required this.lessonId,
    required this.lessonTitle,
  });

  final AppLanguage language;
  final UserLessonTermData term;
  final int index;
  final int lessonId;
  final String lessonTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.appPalette;
    final hasKanji = RegExp(r'[\u4E00-\u9FFF]').hasMatch(term.term);
    final audioText = japaneseTtsText(term: term.term, reading: term.reading);
    return Container(
      key: ValueKey('lesson_term_card_${term.id}'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.elevated,
        border: Border.all(color: palette.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: palette.primary.withValues(alpha: 0.12),
            foregroundColor: palette.primary,
            child: Text('${index + 1}'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  term.term,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (term.reading.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    term.reading.trim(),
                    style: TextStyle(
                      color: palette.ink.withValues(alpha: 0.64),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(term.displayDefinition(language)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (audioText.isNotEmpty)
                      ActionChip(
                        label: Text(_audioLabel(language)),
                        avatar: const Icon(Icons.volume_up_rounded, size: 16),
                        onPressed: () =>
                            _speakJapaneseAudio(context, ref, audioText),
                      ),
                    if (hasKanji)
                      ActionChip(
                        label: Text(_kanjiLabel(language)),
                        avatar: const Icon(Icons.hub_outlined, size: 16),
                        onPressed: () => context.openKanji(),
                      ),
                    ActionChip(
                      key: ValueKey('lesson_term_grammar_badge_${term.id}'),
                      label: Text(_grammarLabel(language)),
                      avatar: const Icon(Icons.account_tree_outlined, size: 16),
                      onPressed: () =>
                          DefaultTabController.of(context).animateTo(1),
                    ),
                    ActionChip(
                      label: Text(_practiceLabel(language)),
                      avatar: const Icon(Icons.play_arrow_rounded, size: 16),
                      onPressed: () =>
                          context.openLessonLearn(lessonId, title: lessonTitle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _kanjiLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Kanji',
    AppLanguage.vi => 'Kanji',
    AppLanguage.ja => '漢字',
  };

  String _grammarLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Grammar',
    AppLanguage.vi => 'Ngữ pháp',
    AppLanguage.ja => '文法',
  };

  String _practiceLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Practice',
    AppLanguage.vi => 'Luyện',
    AppLanguage.ja => '練習',
  };

  String _audioLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Audio',
    AppLanguage.vi => 'Phát âm',
    AppLanguage.ja => '音声',
  };
}

class _FlashcardStudyToolbar extends StatelessWidget {
  const _FlashcardStudyToolbar({
    required this.language,
    required this.current,
    required this.total,
    required this.showExampleMode,
    required this.frontShowsJapanese,
    required this.onShowExampleModeChanged,
    required this.onDirectionChanged,
  });

  final AppLanguage language;
  final int current;
  final int total;
  final bool showExampleMode;
  final bool frontShowsJapanese;
  final ValueChanged<bool> onShowExampleModeChanged;
  final ValueChanged<bool> onDirectionChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final progress = total <= 0 ? 0.0 : current / total;
    return Container(
      key: const ValueKey('lesson_flashcard_toolbar'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.elevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  key: const ValueKey('lesson_flashcard_progress'),
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$current / $total',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SegmentedButton<bool>(
                key: const ValueKey('lesson_content_toggle'),
                segments: [
                  ButtonSegment(
                    value: false,
                    label: Text(_termLabel(language)),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text(_contextLabel(language)),
                  ),
                ],
                selected: {showExampleMode},
                onSelectionChanged: (selection) =>
                    onShowExampleModeChanged(selection.first),
              ),
              SegmentedButton<bool>(
                key: const ValueKey('lesson_direction_toggle'),
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(_japaneseFirstLabel(language)),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(_meaningFirstLabel(language)),
                  ),
                ],
                selected: {frontShowsJapanese},
                onSelectionChanged: (selection) =>
                    onDirectionChanged(selection.first),
              ),
              _ShortcutHintPill(language: language),
            ],
          ),
        ],
      ),
    );
  }

  String _termLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Term',
    AppLanguage.vi => 'Từ đơn',
    AppLanguage.ja => '語',
  };

  String _contextLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Context',
    AppLanguage.vi => 'Ngữ cảnh',
    AppLanguage.ja => '文脈',
  };

  String _japaneseFirstLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'JP -> meaning',
    AppLanguage.vi => 'JP -> nghĩa',
    AppLanguage.ja => '日本語 -> 意味',
  };

  String _meaningFirstLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Meaning -> JP',
    AppLanguage.vi => 'Nghĩa -> JP',
    AppLanguage.ja => '意味 -> 日本語',
  };
}

class _ShortcutHintPill extends StatelessWidget {
  const _ShortcutHintPill({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      key: const ValueKey('lesson_shortcut_hints'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: palette.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _label(language),
        style: TextStyle(
          color: palette.ink.withValues(alpha: 0.72),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _label(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Space: flip | Arrows: move',
    AppLanguage.vi => 'Space: lật | Mũi tên: chuyển',
    AppLanguage.ja => 'Space:反転 | 矢印:移動',
  };
}

class _FlashcardControls extends StatelessWidget {
  const _FlashcardControls({
    required this.language,
    required this.isShuffle,
    required this.isAutoPlay,
    required this.onShuffle,
    required this.onAutoPlay,
    required this.onPrev,
    required this.onNext,
  });

  final AppLanguage language;
  final bool isShuffle;
  final bool isAutoPlay;
  final VoidCallback onShuffle;
  final VoidCallback onAutoPlay;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: palette.elevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.outline),
        boxShadow: [
          BoxShadow(
            color: palette.ink.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onShuffle,
            icon: Icon(
              isShuffle ? Icons.shuffle_on_outlined : Icons.shuffle,
              color: isShuffle
                  ? palette.primary
                  : palette.ink.withValues(alpha: 0.55),
            ),
            tooltip: language.shuffleLabel,
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 24, color: palette.outline),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onPrev,
            icon: const Icon(Icons.arrow_back_rounded, size: 28),
            color: palette.ink,
            tooltip: language.previousLabel,
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onAutoPlay,
            icon: Icon(
              isAutoPlay ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: palette.primary,
              size: 52,
            ),
            padding: EdgeInsets.zero,
            tooltip: isAutoPlay ? language.pauseLabel : language.autoPlayLabel,
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward_rounded, size: 28),
            color: palette.ink,
            tooltip: language.nextLabel,
          ),
        ],
      ),
    );
  }
}
