import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_navigation_extensions.dart';
import 'package:jpstudy/app/theme/app_spacing.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/accessibility/reduced_motion.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/onboarding_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/core/utils/kana_romaji.dart';
import 'package:jpstudy/data/models/vocab_item.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/common/widgets/compact_ui.dart';
import 'package:jpstudy/features/content_quality/widgets/content_draft_quality_note.dart';
import 'package:jpstudy/features/foundations/widgets/foundations_soft_suggest_gate.dart';
import 'package:jpstudy/features/vocab/models/vocab_review_args.dart';
import 'package:jpstudy/features/vocab/vocab_copy.dart';
import 'package:jpstudy/features/vocab/vocab_content_timeout.dart';
import 'package:jpstudy/features/vocab/providers/vocab_home_provider.dart';

part 'vocab_screen_parts.dart';

class _TextbookIndexEntry {
  const _TextbookIndexEntry({
    required this.id,
    required this.levelCode,
    required this.nameJa,
    required this.nameVi,
    required this.nameEn,
    required this.categories,
    required this.lessonCount,
    required this.itemCount,
  });

  final String id;
  final String levelCode;
  final String nameJa;
  final String nameVi;
  final String nameEn;
  final List<String> categories;
  final int lessonCount;
  final int itemCount;

  bool get isVocab => categories.contains('vocab');

  _VocabProgramType? get programType {
    if (id.startsWith('hajimete_tango_')) return _VocabProgramType.core;
    if (id.startsWith('minna_')) return _VocabProgramType.minna;
    if (id.startsWith('mimikara_')) return _VocabProgramType.mimikara;
    return null;
  }

  String get publisherKey {
    return switch (programType) {
      _VocabProgramType.core => 'hajimete',
      _VocabProgramType.minna => 'minna',
      _VocabProgramType.mimikara => 'mimikara',
      _ => 'other',
    };
  }

  static _TextbookIndexEntry? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final map = raw.map((key, value) => MapEntry(key.toString(), value));
    final id = _manifestText(map['textbook_id']);
    final level = _manifestText(map['level']).toUpperCase();
    if (id.isEmpty || level.isEmpty) return null;
    return _TextbookIndexEntry(
      id: id,
      levelCode: level,
      nameJa: _manifestText(map['name_ja']),
      nameVi: _manifestText(map['name_vi']),
      nameEn: _manifestText(map['name_en']),
      categories: [
        for (final category
            in map['categories'] is List
                ? map['categories'] as List
                : const <Object?>[])
          _manifestText(category),
      ].where((category) => category.isNotEmpty).toList(growable: false),
      lessonCount: _manifestInt(map['lesson_count']),
      itemCount: _manifestInt(map['item_count_total']),
    );
  }
}

final vocabCatalogProvider = FutureProvider<List<_VocabCatalogSection>>((
  ref,
) async {
  final language = ref.watch(appLanguageProvider);
  final raw = await rootBundle.loadString(
    'lib/data/manifests/textbook_index.json',
  );
  final payload = json.decode(raw);
  final textbooks = payload is Map && payload['textbooks'] is List
      ? payload['textbooks'] as List
      : const <Object?>[];
  final entries = textbooks
      .map(_TextbookIndexEntry.fromJson)
      .whereType<_TextbookIndexEntry>()
      .where((entry) => entry.isVocab && entry.programType != null)
      .where((entry) {
        if (entry.programType != _VocabProgramType.mimikara) return true;
        return const {'N3', 'N2', 'N1'}.contains(entry.levelCode);
      })
      .toList(growable: false);

  List<_VocabCatalogProgram> programsFor(String publisherKey) {
    final programs = entries
        .where((entry) => entry.publisherKey == publisherKey)
        .map((entry) => _programFromTextbook(entry, language))
        .toList(growable: false);
    programs.sort(
      (left, right) => _levelSortIndex(
        left.levelCode,
      ).compareTo(_levelSortIndex(right.levelCode)),
    );
    return programs;
  }

  return [
    _VocabCatalogSection(
      key: 'hajimete',
      levelCode: 'Hajimete',
      subtitle: _publisherSubtitle(language, 'hajimete'),
      accent: AppThemePalette.light.warning,
      programs: programsFor('hajimete'),
    ),
    _VocabCatalogSection(
      key: 'minna',
      levelCode: 'Minna',
      subtitle: _publisherSubtitle(language, 'minna'),
      accent: AppThemePalette.light.primary,
      programs: programsFor('minna'),
    ),
    _VocabCatalogSection(
      key: 'mimikara',
      levelCode: 'Mimikara',
      subtitle: _publisherSubtitle(language, 'mimikara'),
      accent: AppThemePalette.light.success,
      programs: programsFor('mimikara'),
    ),
  ].where((section) => section.programs.isNotEmpty).toList(growable: false);
});

_VocabCatalogProgram _programFromTextbook(
  _TextbookIndexEntry entry,
  AppLanguage language,
) {
  final type = entry.programType!;
  final titleTop = switch (type) {
    _VocabProgramType.core => _textbookName(entry, language),
    _VocabProgramType.minna => _minnaTextbookName(entry.levelCode),
    _VocabProgramType.mimikara => 'Mimikara',
    _ => _textbookName(entry, language),
  };
  return _VocabCatalogProgram(
    key: entry.id,
    levelCode: entry.levelCode,
    titleTop: titleTop,
    titleMain: entry.levelCode,
    termCount: entry.itemCount,
    chapterCount: entry.lessonCount,
    subtitle: _courseSubtitle(language, type, entry.levelCode),
    type: type,
    isInteractive: entry.itemCount > 0,
    isComingSoon: entry.itemCount == 0,
    badgeText: type == _VocabProgramType.mimikara
        ? _programBadge(type, language)
        : null,
  );
}

String _textbookName(_TextbookIndexEntry entry, AppLanguage language) {
  return switch (language) {
    AppLanguage.vi => entry.nameVi.isNotEmpty ? entry.nameVi : entry.nameEn,
    AppLanguage.ja => entry.nameJa.isNotEmpty ? entry.nameJa : entry.nameEn,
    AppLanguage.en => entry.nameEn.isNotEmpty ? entry.nameEn : entry.nameVi,
  };
}

String _minnaTextbookName(String levelCode) {
  return switch (levelCode) {
    'N5' => 'Minna no Nihongo I',
    'N4' => 'Minna no Nihongo II',
    _ => 'Minna no Nihongo',
  };
}

String _publisherSubtitle(AppLanguage language, String publisherKey) {
  return switch ((language, publisherKey)) {
    (AppLanguage.vi, 'hajimete') =>
      '5 hướng Hajimete Tango từ N5 đến N1, ưu tiên nhớ nghĩa và cách dùng.',
    (AppLanguage.ja, 'hajimete') => 'N5〜N1のはじめて単語トラックをまとめて選べます。',
    (AppLanguage.en, 'hajimete') =>
      'Five Hajimete Tango paths from N5 through N1.',
    (AppLanguage.vi, 'minna') =>
      'Hai giáo trình sơ cấp: quyển I cho N5, quyển II cho N4.',
    (AppLanguage.ja, 'minna') => '初級IはN5、初級IIはN4に対応します。',
    (AppLanguage.en, 'minna') =>
      'Two elementary textbook companions: I for N5, II for N4.',
    (AppLanguage.vi, 'mimikara') =>
      'Mimikara chỉ mở cho N3, N2, N1; không hiển thị sai ở N5/N4.',
    (AppLanguage.ja, 'mimikara') => '耳から覚えるはN3・N2・N1のみ表示します。',
    (AppLanguage.en, 'mimikara') => 'Mimikara appears only for N3, N2, and N1.',
    _ => '',
  };
}

int _levelSortIndex(String levelCode) {
  const order = ['N5', 'N4', 'N3', 'N2', 'N1'];
  final index = order.indexOf(levelCode);
  return index == -1 ? order.length : index;
}

String _manifestText(Object? raw) => '${raw ?? ''}'.trim();

int _manifestInt(Object? raw) {
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  return int.tryParse(_manifestText(raw)) ?? 0;
}

class VocabScreen extends ConsumerWidget {
  const VocabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final selectedLevel = ref.watch(studyLevelProvider);
    final catalogAsync = ref.watch(vocabCatalogProvider);
    final homeAsync = ref.watch(vocabHomeSectionProvider);

    return FoundationsSoftSuggestGate(
      surface: FoundationsSoftSuggestSurface.vocab,
      child: Scaffold(
        body: AppPageShell(
          topPadding: AppSpacing.md,
          child: catalogAsync.when(
            data: (sections) {
              final fallbackHome = _fallbackHomeSection(
                sections: sections,
                selectedLevel: selectedLevel,
              );
              return homeAsync.when(
                data: (home) => _VocabCatalogBody(
                  language: language,
                  sections: sections,
                  home: home,
                ),
                loading: () => _VocabCatalogBody(
                  language: language,
                  sections: sections,
                  home: fallbackHome,
                ),
                error: (error, stack) => _VocabCatalogBody(
                  language: language,
                  sections: sections,
                  home: fallbackHome,
                ),
              );
            },
            loading: () => const Padding(
              key: ValueKey('vocab_catalog_loading'),
              padding: EdgeInsets.only(top: 120),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => AppFeatureCard(
              key: const ValueKey('vocab_catalog_error'),
              icon: Icons.error_outline_rounded,
              title: _catalogErrorTitle(language),
              subtitle: error.toString(),
              secondaryLabel: _catalogRetryLabel(language),
              onSecondaryTap: () => ref.invalidate(vocabCatalogProvider),
            ),
          ),
        ),
      ),
    );
  }
}

VocabHomeSection _fallbackHomeSection({
  required List<_VocabCatalogSection> sections,
  required StudyLevel? selectedLevel,
}) {
  final selectedLevelCode = selectedLevel?.shortLabel ?? 'N5';
  final liveTracks = <VocabTrackSummary>[];
  final previewTracks = <VocabTrackSummary>[];
  for (final section in sections) {
    for (final program in section.programs) {
      if (!program.hasData) continue;
      final title = program.type == _VocabProgramType.core
          ? '${program.titleTop} ${program.titleMain}'.trim()
          : program.titleTop;
      final track = VocabTrackSummary(
        key: program.key,
        levelCode: program.levelCode,
        title: title,
        subtitle: program.subtitle,
        termCount: program.termCount,
        isInteractive: program.isInteractive,
        isPreview: program.isPreviewOnly,
        isCompanion: program.type == _VocabProgramType.minna,
      );
      if (program.isInteractive) {
        liveTracks.add(track);
      } else {
        previewTracks.add(track);
      }
    }
  }

  return VocabHomeSection(
    selectedLevelCode: selectedLevelCode,
    dueCount: 0,
    nextReview: null,
    liveTracks: liveTracks,
    previewTracks: previewTracks,
  );
}

String _programBadge(_VocabProgramType type, AppLanguage language) =>
    switch (type) {
      _VocabProgramType.minna => language.vocabProgramTypeLabel('minna'),
      _VocabProgramType.shinkanzen => 'Shin Kanzen',
      _VocabProgramType.mimikara => 'Mimikara',
      _VocabProgramType.listening => language.vocabProgramTypeLabel(
        'listening',
      ),
      _VocabProgramType.advanced => language.vocabProgramTypeLabel('advanced'),
      _VocabProgramType.specialized => language.vocabProgramTypeLabel(
        'specialized',
      ),
      _ => language.vocabProgramTypeLabel('core'),
    };

(int, int)? _minnaLessonRange(String levelCode, _VocabProgramType type) {
  if (type != _VocabProgramType.minna) return null;
  return switch (levelCode) {
    'N5' => (1, 25),
    'N4' => (26, 50),
    _ => null,
  };
}

String _formatNumber(int value) {
  if (value >= 1000) {
    final compact = (value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1);
    return '${compact}k';
  }
  return '$value';
}

String _formatExactNumber(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    final remaining = digits.length - index;
    buffer.write(digits[index]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

String _programCountLabel(_VocabCatalogProgram program, AppLanguage language) {
  if (program.termCount <= 0) return language.vocabRoadmapLabel();
  final count = _formatExactNumber(program.termCount);
  return language.vocabProgramCountLabel(count);
}

String _todayTitle(AppLanguage language) => language.vocabTodayTitle();

String _todayCaption(AppLanguage language) => language.vocabTodayCaption();

String _dueNowLabel(AppLanguage language) => language.vocabDueNowLabel();

String _activeLaneLabel(AppLanguage language) =>
    language.vocabActiveLaneLabel();

String _nextWindowLabel(AppLanguage language) =>
    language.vocabNextWindowLabel();

String _reviewNowLabel(AppLanguage language) => language.vocabReviewNowLabel();

String _todayReviewTitle(AppLanguage language, String levelCode) =>
    language.vocabReviewTitle(levelCode);

String _todayReviewSubtitle(
  AppLanguage language,
  int dueCount,
  DateTime? nextReview,
) => language.vocabReviewSubtitle(
  dueCount,
  _formatReviewTiming(language, nextReview),
);

String _currentTrackLine(AppLanguage language, VocabTrackSummary track) =>
    language.vocabCurrentTrackLine(track.title, track.termCount);

String _liveCatalogTitle(AppLanguage language) =>
    language.vocabLiveCatalogTitle();

String _liveCatalogCaption(AppLanguage language) =>
    language.vocabLiveCatalogCaption();

String _previewCatalogTitle(AppLanguage language) =>
    language.vocabPreviewCatalogTitle();

String _previewCatalogCaption(AppLanguage language) =>
    language.vocabPreviewCatalogCaption();

String _chapterSummaryLabel(int chapterCount, AppLanguage language) =>
    language.vocabChapterSummaryLabel(chapterCount);

String _programProgressLabel(AppLanguage language, int percent) {
  return switch (language) {
    AppLanguage.en => '$percent% progress',
    AppLanguage.vi => 'Tiến độ $percent%',
    AppLanguage.ja => '進捗 $percent%',
  };
}

String _formatReviewTiming(AppLanguage language, DateTime? nextReview) {
  if (nextReview == null) {
    return switch (language) {
      AppLanguage.en => 'Ready now',
      AppLanguage.vi => 'Sẵn sàng',
      AppLanguage.ja => '準備完了',
    };
  }
  final now = DateTime.now();
  final difference = nextReview.difference(now);
  final hours = difference.inHours;
  if (hours <= 0) {
    return switch (language) {
      AppLanguage.en => 'Today',
      AppLanguage.vi => 'Hôm nay',
      AppLanguage.ja => '今日',
    };
  }
  if (hours < 24) {
    return switch (language) {
      AppLanguage.en => 'in ${hours}h',
      AppLanguage.vi => 'trong $hours giờ',
      AppLanguage.ja => '$hours時間後',
    };
  }
  final days = difference.inDays;
  return switch (language) {
    AppLanguage.en => 'in ${days}d',
    AppLanguage.vi => 'trong $days ngày',
    AppLanguage.ja => '$days日後',
  };
}

String _localizedSectionSubtitle(
  _VocabCatalogSection section,
  AppLanguage language,
) {
  if (!section.levelCode.startsWith('N') && section.levelCode != 'SE') {
    return section.subtitle;
  }
  return language.vocabLocalizedSectionSubtitle(
    section.levelCode,
    section.subtitle,
  );
}

String _localizedProgramSubtitle(
  _VocabCatalogProgram program,
  AppLanguage language,
) => language.vocabLocalizedProgramSubtitle(
  program.type.name,
  program.titleMain,
  program.subtitle,
);

String _courseSubtitle(
  AppLanguage language,
  _VocabProgramType type,
  String levelCode,
) => language.vocabCourseSubtitle(type.name, levelCode);

String _heroHighlight(AppLanguage language) => language.vocabHeroHighlight();

String _heroTitle(AppLanguage language) => language.vocabHeroTitle();

String _heroSubtitle(AppLanguage language) => language.vocabHeroSubtitle();

String _heroDescription(AppLanguage language) =>
    language.vocabHeroDescription();

String _heroScopeAllLabel(AppLanguage language) =>
    language.vocabHeroScopeAllLabel();

String _heroScopeLevelLabel(AppLanguage language, String level) =>
    language.vocabHeroScopeLevelLabel(level);

String _heroMemoryLabel(AppLanguage language) =>
    language.vocabHeroMemoryLabel();

String _heroUsageLabel(AppLanguage language) => language.vocabHeroUsageLabel();

String _heroPanelTitle(AppLanguage language) => language.vocabHeroPanelTitle();

String _heroPanelSubtitle(AppLanguage language) =>
    language.vocabHeroPanelSubtitle();

String _heroMetricPrograms(AppLanguage language) =>
    language.vocabHeroMetricPrograms();

String _heroMetricLive(AppLanguage language) => language.vocabHeroMetricLive();

String _heroMetricTerms(AppLanguage language) =>
    language.vocabHeroMetricTerms();

String _trackLabel(AppLanguage language) => language.vocabTrackLabel();

String _programTypeLabel(_VocabProgramType type, AppLanguage language) =>
    language.vocabProgramTypeLabel(type.name);

String _badgeLabel(_VocabCatalogProgram program, AppLanguage language) {
  if (program.isComingSoon) return _comingSoonLabel(language);
  if (program.isPreviewOnly) return _previewReadyLabel(language);
  return program.badgeText ?? _availableNowLabel(language);
}

String _availableNowLabel(AppLanguage language) =>
    language.vocabAvailableNowLabel();

String _comingSoonLabel(AppLanguage language) =>
    language.vocabComingSoonLabel();

String _previewReadyLabel(AppLanguage language) =>
    language.vocabPreviewReadyLabel();

String _roadmapLabel(AppLanguage language) => language.vocabRoadmapLabel();

String _programAvailabilityPill(
  _VocabCatalogProgram program,
  AppLanguage language,
) {
  if (program.isInteractive) return _reviewReadyLabel(language);
  if (program.isPreviewOnly) return _previewReadyLabel(language);
  return _roadmapLabel(language);
}

String _previewDialogTitle(AppLanguage language) =>
    language.vocabPreviewDialogTitle();

String _previewDialogClose(AppLanguage language) =>
    language.vocabPreviewDialogClose();

String _previewDialogBody(AppLanguage language) {
  return language.vocabDefaultPreviewDialogBody();
}

String _meaningFirstLabel(AppLanguage language) =>
    language.vocabMeaningFirstLabel();

String _usageFlowLabel(AppLanguage language) => language.vocabUsageFlowLabel();

String _reviewReadyLabel(AppLanguage language) =>
    language.vocabReviewReadyLabel();

String _openLaneLabel(AppLanguage language) => language.vocabOpenLaneLabel();

String _joinTrackLabel(AppLanguage language) => language.vocabJoinTrackLabel();

String _previewLabel(AppLanguage language) => language.vocabPreviewLabel();

String _programFooterHint(_VocabProgramType type, AppLanguage language) =>
    language.vocabProgramFooterHint(type.name);

String? _programScopeNote(_VocabProgramType type, AppLanguage language) =>
    switch (type) {
      _VocabProgramType.minna => language.vocabCatalogMinnaNote,
      _VocabProgramType.shinkanzen => language.vocabCatalogShinKanzenNote,
      _VocabProgramType.mimikara => language.vocabCatalogMimikaraNote,
      _ => null,
    };

String _catalogErrorTitle(AppLanguage language) =>
    language.vocabCatalogErrorTitle();

String _catalogRetryLabel(AppLanguage language) =>
    language.vocabCatalogRetryLabel();
