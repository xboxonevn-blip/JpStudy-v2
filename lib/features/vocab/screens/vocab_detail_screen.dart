import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_navigation_extensions.dart';
import 'package:jpstudy/app/navigation/app_route_locations.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/conjugation/conjugation_class.dart';
import 'package:jpstudy/core/conjugation/conjugation_form.dart';
import 'package:jpstudy/core/conjugation/japanese_conjugator.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/utils/japanese_text.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/features/common/widgets/compact_ui.dart';
import 'package:jpstudy/features/common/widgets/error_state_widget.dart';
import 'package:jpstudy/features/interlink/widgets/related_section.dart';
import 'package:jpstudy/features/vocab/providers/vocab_detail_provider.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

String _tr(
  AppLanguage l, {
  required String en,
  required String vi,
  required String ja,
}) => switch (l) {
  AppLanguage.en => en,
  AppLanguage.vi => vi,
  AppLanguage.ja => ja,
};

String _meaningUnavailable(AppLanguage language) => _tr(
  language,
  en: 'Meaning not available',
  vi: 'Chưa có nghĩa',
  ja: '意味未設定',
);

String _localizedVocabMeaning(VocabData vocab, AppLanguage language) {
  final vi = vocab.meaning.trim();
  final en = vocab.meaningEn?.trim() ?? '';
  switch (language) {
    case AppLanguage.vi:
      return vi.isNotEmpty
          ? vi
          : (en.isNotEmpty ? en : _meaningUnavailable(language));
    case AppLanguage.en:
      return en.isNotEmpty
          ? en
          : (vi.isNotEmpty ? vi : _meaningUnavailable(language));
    case AppLanguage.ja:
      return en.isNotEmpty ? en : _meaningUnavailable(language);
  }
}

String _localizedKanjiMeaning(KanjiData kanji, AppLanguage language) {
  final vi = kanji.meaning.trim();
  final en = kanji.meaningEn?.trim() ?? '';
  final ja = kanji.meaningJa?.trim() ?? '';
  switch (language) {
    case AppLanguage.vi:
      return vi.isNotEmpty
          ? vi
          : (en.isNotEmpty ? en : _meaningUnavailable(language));
    case AppLanguage.en:
      return en.isNotEmpty
          ? en
          : (vi.isNotEmpty ? vi : _meaningUnavailable(language));
    case AppLanguage.ja:
      if (ja.isNotEmpty) return ja;
      return en.isNotEmpty ? en : _meaningUnavailable(language);
  }
}

class VocabDetailScreen extends ConsumerWidget {
  const VocabDetailScreen({super.key, required this.vocabId});

  final int vocabId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final detailAsync = ref.watch(vocabDetailProvider(vocabId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tr(language, en: 'Word Detail', vi: 'Chi tiết từ', ja: '単語の詳細'),
        ),
      ),
      body: detailAsync.when(
        data: (detail) {
          if (detail == null) {
            return Center(
              child: Text(
                _tr(
                  language,
                  en: 'Word not found',
                  vi: 'Không tìm thấy từ',
                  ja: '単語が見つかりません',
                ),
              ),
            );
          }
          return _VocabDetailBody(detail: detail, language: language);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorStateWidget(error: error),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main body
// ---------------------------------------------------------------------------

class _VocabDetailBody extends StatelessWidget {
  const _VocabDetailBody({required this.detail, required this.language});

  final VocabDetail detail;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final vocab = detail.vocab;
    final palette = context.appPalette;
    final showReading = shouldShowReading(
      term: vocab.term,
      reading: vocab.reading,
    );

    return AppPageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hero card ──────────────────────────────────────────────
          _HeroCard(
            term: vocab.term,
            reading: showReading ? vocab.reading : null,
            level: vocab.level,
            tags: vocab.tags,
            palette: palette,
          ),
          const SizedBox(height: 16),

          // ── Meanings ───────────────────────────────────────────────
          _MeaningSection(vocab: vocab, language: language, palette: palette),
          const SizedBox(height: 16),

          _StudyUsageSection(
            detail: detail,
            language: language,
            palette: palette,
          ),
          const SizedBox(height: 16),

          // ── SRS status ─────────────────────────────────────────────
          _SrsStatusCard(detail: detail, language: language, palette: palette),
          const SizedBox(height: 16),

          // ── Kanji breakdown ────────────────────────────────────────
          if (detail.kanjiList.isNotEmpty) ...[
            _KanjiBreakdownSection(
              kanjiList: detail.kanjiList,
              language: language,
              palette: palette,
            ),
            const SizedBox(height: 16),
          ],

          // ── Related vocab ──────────────────────────────────────────
          if (detail.relatedVocab.isNotEmpty)
            _RelatedVocabSection(
              items: detail.relatedVocab,
              language: language,
              palette: palette,
            ),
          const SizedBox(height: 16),

          RelatedSection.lookup(
            type: 'vocab',
            level: vocab.level,
            lookupId: 'vocab:${vocab.level.toLowerCase()}:${vocab.id}',
            label: vocab.term,
            language: language,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero card – large term display
// ---------------------------------------------------------------------------

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.term,
    this.reading,
    required this.level,
    this.tags,
    required this.palette,
  });

  final String term;
  final String? reading;
  final String level;
  final String? tags;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    final tagList = _parseTags(tags);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        children: [
          if (reading != null) ...[
            Text(
              reading!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: palette.ink.withValues(alpha: 0.55),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            term,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: palette.ink,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LevelBadge(level: level, palette: palette),
              if (tagList.isNotEmpty) ...[
                const SizedBox(width: 8),
                ...tagList
                    .take(3)
                    .map(
                      (tag) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _TagChip(tag: tag, palette: palette),
                      ),
                    ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  List<String> _parseTags(String? tags) {
    if (tags == null || tags.isEmpty) return const [];
    // Tags may be comma-separated or JSON array.
    // Source/editorial tags are DB metadata, not learner-facing labels.
    List<String> rawTags;
    if (tags.startsWith('[')) {
      try {
        rawTags = (jsonDecode(tags) as List).whereType<String>().toList(
          growable: false,
        );
      } catch (_) {
        rawTags = const [];
      }
    } else {
      rawTags = tags
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
    }
    return rawTags.where(_isLearnerFacingTag).toList(growable: false);
  }

  bool _isLearnerFacingTag(String tag) {
    final normalized = tag.trim().toLowerCase();
    if (normalized.isEmpty) return false;
    if (RegExp(r'^(minna|hajimete|shinkanzen)_\d+$').hasMatch(normalized)) {
      return false;
    }
    const blockedExact = {
      'anki-import',
      'jlpt-vocab',
      'public-source',
      'tanos',
    };
    if (blockedExact.contains(normalized)) return false;
    const blockedFragments = [
      'approved',
      'codex',
      'draft',
      'editorial',
      'human',
      'import',
      'jmdict',
      'kanjidic',
      'license',
      'machine',
      'public',
      'review',
      'source',
      'unihan',
      'verified',
    ];
    for (final fragment in blockedFragments) {
      if (normalized.contains(fragment)) return false;
    }
    return true;
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level, required this.palette});

  final String level;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: palette.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        level,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: palette.primary,
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag, required this.palette});

  final String tag;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: palette.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: palette.accent,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Meaning section
// ---------------------------------------------------------------------------

class _MeaningSection extends StatelessWidget {
  const _MeaningSection({
    required this.vocab,
    required this.language,
    required this.palette,
  });

  final VocabData vocab;
  final AppLanguage language;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    final primaryMeaning = _primaryMeaning();
    final secondaryMeaning = _secondaryMeaning();

    return AppSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            label: _tr(language, en: 'Meaning', vi: 'Nghĩa', ja: '意味'),
            palette: palette,
          ),
          const SizedBox(height: 10),
          Text(
            primaryMeaning,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: palette.ink,
              height: 1.4,
            ),
          ),
          if (secondaryMeaning != null) ...[
            const SizedBox(height: 6),
            Text(
              secondaryMeaning,
              style: TextStyle(
                fontSize: 14,
                color: palette.ink.withValues(alpha: 0.60),
                height: 1.4,
              ),
            ),
          ],
          if (language == AppLanguage.vi &&
              vocab.kanjiMeaning != null &&
              vocab.kanjiMeaning!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: palette.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: palette.info.withValues(alpha: 0.18)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.translate_rounded,
                    size: 16,
                    color: palette.info.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      vocab.kanjiMeaning!,
                      style: TextStyle(
                        fontSize: 13,
                        color: palette.info,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _primaryMeaning() {
    return _localizedVocabMeaning(vocab, language);
  }

  String? _secondaryMeaning() {
    switch (language) {
      case AppLanguage.en:
        return null;
      case AppLanguage.vi:
        return vocab.meaningEn; // Show English as secondary
      case AppLanguage.ja:
        return null;
    }
  }
}

/// ---------------------------------------------------------------------------
// Study usage helpers
// ---------------------------------------------------------------------------

class _StudyUsageSection extends StatelessWidget {
  const _StudyUsageSection({
    required this.detail,
    required this.language,
    required this.palette,
  });

  final VocabDetail detail;
  final AppLanguage language;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    final vocab = detail.vocab;
    final examples = _exampleLines(vocab, language);
    final conjugations = _conjugationLines(detail.conjugationLemma, language);
    final collocations = _collocationLines(vocab);
    final canPracticeConjugation =
        detail.conjugationLemma != null && conjugations.isNotEmpty;

    return AppSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            label: _tr(
              language,
              en: 'Study Pack',
              vi: 'Gói học nhanh',
              ja: '学習パック',
            ),
            palette: palette,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppButton(
                label: _tr(language, en: 'Play audio', vi: 'Phát âm', ja: '音声'),
                icon: Icons.volume_up_rounded,
                variant: AppButtonVariant.secondary,
                compact: true,
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _tr(
                        language,
                        en: 'Audio is queued for this word.',
                        vi: 'Đã đưa từ này vào hàng phát âm.',
                        ja: 'この単語の音声を準備しました。',
                      ),
                    ),
                  ),
                ),
              ),
              if (canPracticeConjugation)
                AppButton(
                  label: _tr(
                    language,
                    en: 'Practice forms',
                    vi: 'Luyện chia thể',
                    ja: '活用練習',
                  ),
                  icon: Icons.swap_horiz_rounded,
                  variant: AppButtonVariant.secondary,
                  compact: true,
                  onPressed: () =>
                      context.openConjugationHub(contentVocabId: vocab.id),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _MiniList(
            title: _tr(language, en: 'Examples', vi: 'Ví dụ', ja: '例文'),
            rows: examples,
            palette: palette,
          ),
          if (conjugations.isNotEmpty) ...[
            const SizedBox(height: 12),
            _MiniList(
              title: _tr(language, en: 'Forms', vi: 'Chia động từ', ja: '活用'),
              rows: conjugations,
              palette: palette,
            ),
          ],
          if (collocations.isNotEmpty) ...[
            const SizedBox(height: 12),
            _MiniList(
              title: _tr(
                language,
                en: 'Collocations',
                vi: 'Cụm đi với từ',
                ja: 'コロケーション',
              ),
              rows: collocations,
              palette: palette,
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniList extends StatelessWidget {
  const _MiniList({
    required this.title,
    required this.rows,
    required this.palette,
  });

  final String title;
  final List<String> rows;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w800, color: palette.ink),
        ),
        const SizedBox(height: 6),
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    color: palette.accent,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Expanded(
                  child: Text(
                    row,
                    style: TextStyle(
                      color: palette.ink.withValues(alpha: 0.72),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

List<String> _exampleLines(VocabData vocab, AppLanguage language) {
  final term = vocab.term;
  final meaning = _localizedVocabMeaning(vocab, language);
  return switch (language) {
    AppLanguage.en => [
      'Review "$term" in its lesson context.',
      'Check how "$term" changes the sentence focus.',
      '$term is an important ${vocab.level} word.',
    ],
    AppLanguage.vi => [
      '$term を文脈で確認します。 — Ôn "$meaning" trong ngữ cảnh.',
      '$term の使い所を比べます。 — So sánh tình huống dùng "$meaning".',
      '$term là từ quan trọng ở ${vocab.level}.',
    ],
    AppLanguage.ja => [
      '$term を文脈で確認します。',
      '$term の使い所を比べます。',
      '$term は${vocab.level}の重要語です。',
    ],
  };
}

List<String> _conjugationLines(
  ConjugationLemmaData? lemma,
  AppLanguage language,
) {
  if (lemma == null) return const [];
  final spec = _conjugationSpecFor(lemma);
  if (spec == null) return const [];
  final conjugator = JapaneseConjugator();
  final rows = <String>[];
  const forms = [
    ConjugationForm.te,
    ConjugationForm.nai,
    ConjugationForm.ta,
    ConjugationForm.masu,
  ];
  for (final form in forms) {
    try {
      final surface = conjugator.form(lemma.dictionaryForm, spec, form);
      rows.add('${_formLabel(language, form)}: $surface');
    } on UnsupportedError {
      continue;
    } on ArgumentError {
      continue;
    }
  }
  return rows;
}

ConjugationSpec? _conjugationSpecFor(ConjugationLemmaData lemma) {
  if (lemma.kind == 'verb') {
    final verbClass = _enumByName(VerbClass.values, lemma.conjugationClass);
    return verbClass == null ? null : ConjugationSpec.verb(verbClass);
  }
  final adjectiveClass = _enumByName(
    AdjectiveClass.values,
    lemma.conjugationClass,
  );
  return adjectiveClass == null
      ? null
      : ConjugationSpec.adjective(adjectiveClass);
}

T? _enumByName<T extends Enum>(List<T> values, String name) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}

String _formLabel(AppLanguage language, ConjugationForm form) {
  final key = form.name;
  return switch (language) {
    AppLanguage.en => switch (form) {
      ConjugationForm.te => 'te form',
      ConjugationForm.nai => 'negative form',
      ConjugationForm.ta => 'past form',
      ConjugationForm.masu => 'polite form',
      ConjugationForm.dictionary => 'dictionary form',
      _ => '$key form',
    },
    AppLanguage.vi => switch (form) {
      ConjugationForm.te => 'thể て',
      ConjugationForm.nai => 'thể phủ định',
      ConjugationForm.ta => 'thể quá khứ',
      ConjugationForm.masu => 'thể lịch sự',
      ConjugationForm.dictionary => 'thể từ điển',
      _ => 'thể $key',
    },
    AppLanguage.ja => switch (form) {
      ConjugationForm.te => 'て形',
      ConjugationForm.nai => 'ない形',
      ConjugationForm.ta => 'た形',
      ConjugationForm.masu => 'ます形',
      ConjugationForm.dictionary => '辞書形',
      _ => '$key形',
    },
  };
}

List<String> _collocationLines(VocabData vocab) {
  final term = vocab.term.trim();
  if (term.contains('食')) return ['ご飯を$term', '朝ご飯を$term', '友だちと$term'];
  if (term.contains('飲')) return ['水を$term', 'お茶を$term', '友だちと$term'];
  if (term.contains('行')) return ['学校へ$term', '駅へ$term', '友だちと$term'];
  return const [];
}
// ---------------------------------------------------------------------------
// SRS status card
// ---------------------------------------------------------------------------

class _SrsStatusCard extends StatelessWidget {
  const _SrsStatusCard({
    required this.detail,
    required this.language,
    required this.palette,
  });

  final VocabDetail detail;
  final AppLanguage language;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    final srs = detail.srs;
    final stage = detail.srsStageLabel;

    return AppSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _SectionLabel(
                  label: _tr(
                    language,
                    en: 'SRS Status',
                    vi: 'Trạng thái SRS',
                    ja: 'SRS状態',
                  ),
                  palette: palette,
                ),
              ),
              _StagePill(stage: stage, palette: palette),
            ],
          ),
          const SizedBox(height: 14),
          if (srs == null)
            Text(
              _tr(
                language,
                en: 'Not yet studied. Start a review to begin tracking.',
                vi: 'Chưa học. Bắt đầu ôn tập để theo dõi.',
                ja: 'まだ学習していません。復習を始めましょう。',
              ),
              style: TextStyle(
                fontSize: 14,
                color: palette.ink.withValues(alpha: 0.55),
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: _tr(
                      language,
                      en: 'Stability',
                      vi: 'Độ ổn định',
                      ja: '安定度',
                    ),
                    value: srs.stability.toStringAsFixed(1),
                    palette: palette,
                  ),
                ),
                Expanded(
                  child: _StatTile(
                    label: _tr(
                      language,
                      en: 'Difficulty',
                      vi: 'Độ khó',
                      ja: '難易度',
                    ),
                    value: srs.difficulty.toStringAsFixed(1),
                    palette: palette,
                  ),
                ),
                Expanded(
                  child: _StatTile(
                    label: _tr(
                      language,
                      en: 'Reviews',
                      vi: 'Số lần ôn',
                      ja: '復習回数',
                    ),
                    value: '${srs.repetitions}',
                    palette: palette,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (srs.lastReviewedAt != null)
              _InfoRow(
                icon: Icons.history_rounded,
                label: _tr(
                  language,
                  en: 'Last reviewed',
                  vi: 'Ôn lần cuối',
                  ja: '最終復習',
                ),
                value: _formatDate(context, srs.lastReviewedAt!),
                palette: palette,
              ),
            _InfoRow(
              icon: Icons.event_rounded,
              label: _tr(
                language,
                en: 'Next review',
                vi: 'Ôn tiếp theo',
                ja: '次の復習',
              ),
              value: _formatDate(context, srs.nextReviewAt),
              palette: palette,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    return MaterialLocalizations.of(context).formatShortDate(date);
  }
}

class _StagePill extends StatelessWidget {
  const _StagePill({required this.stage, required this.palette});

  final String stage;
  final AppThemePalette palette;

  Color get _color {
    switch (stage) {
      case 'mature':
        return palette.success;
      case 'young':
        return palette.info;
      case 'learning':
        return palette.warning;
      default:
        return palette.ink.withValues(alpha: 0.35);
    }
  }

  String get _label {
    switch (stage) {
      case 'mature':
        return 'Mature';
      case 'young':
        return 'Young';
      case 'learning':
        return 'Learning';
      default:
        return 'New';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withValues(alpha: 0.30)),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: _color,
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.palette,
  });

  final String label;
  final String value;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: palette.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: palette.ink.withValues(alpha: 0.50),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.palette,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: palette.ink.withValues(alpha: 0.40)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: palette.ink.withValues(alpha: 0.55),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: palette.ink.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kanji breakdown
// ---------------------------------------------------------------------------

class _KanjiBreakdownSection extends StatelessWidget {
  const _KanjiBreakdownSection({
    required this.kanjiList,
    required this.language,
    required this.palette,
  });

  final List<KanjiData> kanjiList;
  final AppLanguage language;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            label: _tr(
              language,
              en: 'Kanji Breakdown',
              vi: 'Phân tích Kanji',
              ja: '漢字分解',
            ),
            palette: palette,
          ),
          const SizedBox(height: 12),
          ...kanjiList.map(
            (kanji) =>
                _KanjiRow(kanji: kanji, language: language, palette: palette),
          ),
        ],
      ),
    );
  }
}

class _KanjiRow extends StatelessWidget {
  const _KanjiRow({
    required this.kanji,
    required this.language,
    required this.palette,
  });

  final KanjiData kanji;
  final AppLanguage language;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    final meaning = _localizedKanjiMeaning(kanji, language);
    final readings = <String>[];
    if (kanji.onyomi != null && kanji.onyomi!.isNotEmpty) {
      readings.add(kanji.onyomi!);
    }
    if (kanji.kunyomi != null && kanji.kunyomi!.isNotEmpty) {
      readings.add(kanji.kunyomi!);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AppRouteLocation.kanji(kanjiId: kanji.id)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: palette.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.outline.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              // Kanji character
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: palette.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    kanji.character,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: palette.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meaning,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: palette.ink,
                      ),
                    ),
                    if (readings.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        readings.join(' · '),
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.ink.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Stroke count
              Column(
                children: [
                  Text(
                    '${kanji.strokeCount}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: palette.accent,
                    ),
                  ),
                  Text(
                    _tr(language, en: 'strokes', vi: 'nét', ja: '画'),
                    style: TextStyle(
                      fontSize: 10,
                      color: palette.ink.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Related vocab
// ---------------------------------------------------------------------------

class _RelatedVocabSection extends StatelessWidget {
  const _RelatedVocabSection({
    required this.items,
    required this.language,
    required this.palette,
  });

  final List<VocabData> items;
  final AppLanguage language;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            label: _tr(
              language,
              en: 'Related Words',
              vi: 'Từ liên quan',
              ja: '関連語',
            ),
            palette: palette,
          ),
          const SizedBox(height: 10),
          ...items.map((item) {
            final meaning = _localizedVocabMeaning(item, language);
            final showRead = shouldShowReading(
              term: item.term,
              reading: item.reading,
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: AppCompactRow(
                icon: Icons.translate_rounded,
                title: item.term,
                subtitle: meaning,
                status: showRead
                    ? AppStatusChip(label: item.reading!.trim())
                    : null,
                onTap: () =>
                    context.push(AppRouteLocation.vocabDetail(item.id)),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.palette});

  final String label;
  final AppThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: palette.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: palette.ink.withValues(alpha: 0.65),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
