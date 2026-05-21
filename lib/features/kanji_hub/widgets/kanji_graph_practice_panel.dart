import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jpstudy/app/theme/app_spacing.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_graph_practice.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_relationship_graph.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

class KanjiGraphPracticePanel extends StatefulWidget {
  const KanjiGraphPracticePanel({
    super.key,
    required this.graphData,
    required this.language,
    required this.onCompleted,
  });

  final KanjiRelationshipGraphData graphData;
  final AppLanguage language;
  final FutureOr<void> Function(KanjiGraphPracticeOutcome) onCompleted;

  @override
  State<KanjiGraphPracticePanel> createState() =>
      _KanjiGraphPracticePanelState();
}

class _KanjiGraphPracticePanelState extends State<KanjiGraphPracticePanel> {
  late final KanjiGraphPracticeSession _session;
  final Set<String> _practiced = <String>{};
  final Set<String> _missed = <String>{};
  int _index = 0;
  int _correct = 0;
  String? _selected;
  bool _completed = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _session = KanjiGraphPracticeSession.generate(
      graphData: widget.graphData,
      language: widget.language,
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = _session.questions;
    if (questions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(_emptyLabel(widget.language)),
      );
    }
    if (_completed) {
      final outcome = _outcome();
      return Padding(
        key: const ValueKey('kanji_graph_practice_complete'),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _completeTitle(widget.language, outcome),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(_completeSubtitle(widget.language, outcome)),
          ],
        ),
      );
    }

    final question = questions[_index];
    final answered = _selected != null;
    final correct = _selected == question.correctCharacter;
    return Padding(
      key: const ValueKey('kanji_graph_practice_panel'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _progressLabel(widget.language, _index + 1, questions.length),
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            question.prompt,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final option in question.options)
                _OptionButton(
                  option: option,
                  enabled: !answered,
                  selected: _selected == option,
                  correct: question.correctCharacter == option,
                  answered: answered,
                  onTap: () => _answer(option),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (answered)
            Text(
              correct
                  ? _correctLabel(widget.language)
                  : _wrongLabel(widget.language, question.correctCharacter),
              key: ValueKey(
                correct
                    ? 'kanji_graph_practice_feedback_correct'
                    : 'kanji_graph_practice_feedback_wrong',
              ),
              style: TextStyle(
                color: correct
                    ? const Color(0xFF15803D)
                    : const Color(0xFFB91C1C),
                fontWeight: FontWeight.w800,
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            key: const ValueKey('kanji_graph_practice_next'),
            label: _index == questions.length - 1
                ? _finishLabel(widget.language)
                : _nextLabel(widget.language),
            icon: _index == questions.length - 1
                ? Icons.check_rounded
                : Icons.arrow_forward_rounded,
            onPressed: answered && !_submitting ? _next : null,
          ),
        ],
      ),
    );
  }

  void _answer(String option) {
    final question = _session.questions[_index];
    final isCorrect = option == question.correctCharacter;
    setState(() {
      _selected = option;
      _practiced.add(question.target.character);
      if (isCorrect) {
        _correct++;
      } else {
        _missed.add(question.target.character);
      }
    });
  }

  Future<void> _next() async {
    if (_index < _session.questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
      });
      return;
    }
    final outcome = _outcome();
    setState(() => _submitting = true);
    await Future.sync(() => widget.onCompleted(outcome));
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _completed = true;
    });
  }

  KanjiGraphPracticeOutcome _outcome() {
    return KanjiGraphPracticeOutcome(
      correctCount: _correct,
      totalCount: _session.questions.length,
      practicedCharacters: Set.unmodifiable(_practiced),
      missedCharacters: Set.unmodifiable(_missed),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.option,
    required this.enabled,
    required this.selected,
    required this.correct,
    required this.answered,
    required this.onTap,
  });

  final String option;
  final bool enabled;
  final bool selected;
  final bool correct;
  final bool answered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      key: ValueKey('kanji_graph_practice_option_$option'),
      label: option,
      variant: selected || (answered && correct)
          ? AppButtonVariant.primary
          : AppButtonVariant.secondary,
      compact: true,
      onPressed: enabled ? onTap : null,
    );
  }
}

String _emptyLabel(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Cụm này chưa đủ dữ liệu để luyện.',
  AppLanguage.en => 'This cluster is not ready for practice yet.',
  AppLanguage.ja => 'このグループはまだ練習できません。',
};

String _progressLabel(AppLanguage language, int index, int total) =>
    switch (language) {
      AppLanguage.vi => 'Câu $index/$total',
      AppLanguage.en => 'Question $index/$total',
      AppLanguage.ja => '問題 $index/$total',
    };

String _correctLabel(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Đúng',
  AppLanguage.en => 'Correct',
  AppLanguage.ja => '正解',
};

String _wrongLabel(AppLanguage language, String answer) => switch (language) {
  AppLanguage.vi => 'Chưa đúng. Đáp án: $answer',
  AppLanguage.en => 'Not quite. Answer: $answer',
  AppLanguage.ja => '違います。答え: $answer',
};

String _nextLabel(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Tiếp',
  AppLanguage.en => 'Next',
  AppLanguage.ja => '次へ',
};

String _finishLabel(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Hoàn tất',
  AppLanguage.en => 'Finish',
  AppLanguage.ja => '完了',
};

String _completeTitle(
  AppLanguage language,
  KanjiGraphPracticeOutcome outcome,
) => switch (language) {
  AppLanguage.vi => outcome.passed ? 'Đã cập nhật SRS' : 'Cần luyện lại',
  AppLanguage.en => outcome.passed ? 'SRS updated' : 'Practice again',
  AppLanguage.ja => outcome.passed ? 'SRSを更新しました' : 'もう一度練習',
};

String _completeSubtitle(
  AppLanguage language,
  KanjiGraphPracticeOutcome outcome,
) => switch (language) {
  AppLanguage.vi =>
    '${outcome.correctCount}/${outcome.totalCount} câu đúng trong cụm này.',
  AppLanguage.en =>
    '${outcome.correctCount}/${outcome.totalCount} correct in this cluster.',
  AppLanguage.ja => '${outcome.totalCount}問中${outcome.correctCount}問正解。',
};
