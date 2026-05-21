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
import 'package:jpstudy/data/utils/hajimete_catalog_loader.dart';
import 'package:jpstudy/data/utils/mimikara_catalog_loader.dart';
import 'package:jpstudy/features/common/widgets/compact_ui.dart';
import 'package:jpstudy/features/content_quality/widgets/content_draft_quality_note.dart';
import 'package:jpstudy/features/foundations/widgets/foundations_soft_suggest_gate.dart';
import 'package:jpstudy/features/home/providers/dashboard_provider.dart';
import 'package:jpstudy/features/vocab/models/vocab_review_args.dart';
import 'package:jpstudy/features/vocab/vocab_copy.dart';
import 'package:jpstudy/features/vocab/vocab_content_timeout.dart';
import 'package:jpstudy/features/vocab/providers/vocab_home_provider.dart';

part 'vocab_screen_parts.dart';

class _SeriesManifestSummary {
  const _SeriesManifestSummary({
    required this.routeCount,
    required this.readyRouteCount,
    required this.importedTermCount,
  });

  const _SeriesManifestSummary.empty()
    : routeCount = 0,
      readyRouteCount = 0,
      importedTermCount = 0;

  final int routeCount;
  final int readyRouteCount;
  final int importedTermCount;
}

Future<_SeriesManifestSummary> _loadMimikaraManifestSummary(
  String levelCode,
) async {
  try {
    final catalog = await loadMimikaraUnitCatalog(
      levelCode,
    ).timeout(const Duration(seconds: 1));
    return _SeriesManifestSummary(
      routeCount: catalog.units.length,
      readyRouteCount: catalog.units.where((unit) => unit.termCount > 0).length,
      importedTermCount: catalog.totalTerms,
    );
  } catch (_) {
    return const _SeriesManifestSummary.empty();
  }
}

Future<int> _loadVocabAssetEntryCount(String path) async {
  try {
    final raw = await rootBundle
        .loadString(path)
        .timeout(const Duration(seconds: 1));
    final payload = json.decode(raw);
    if (payload is! Map) return 0;
    final entryCount = payload['entryCount'];
    if (entryCount is int) return entryCount;
    final entries = payload['entries'];
    return entries is List ? entries.length : 0;
  } catch (_) {
    return 0;
  }
}

Future<int> _loadMinnaLessonRangeCount(
  String levelCode, {
  required int startLesson,
  required int endLesson,
}) async {
  final levelLower = levelCode.toLowerCase();
  final counts = await Future.wait([
    for (var lesson = startLesson; lesson <= endLesson; lesson++)
      _loadVocabAssetEntryCount(
        'assets/data/content/vocab/$levelLower/minna/lesson_${lesson.toString().padLeft(2, '0')}.json',
      ),
  ]);
  return counts.fold<int>(0, (sum, count) => sum + count);
}

final vocabCatalogProvider = FutureProvider<List<_VocabCatalogSection>>((
  ref,
) async {
  final language = ref.watch(appLanguageProvider);

  // Subscribe only to vocabDue — streak/XP ticks won't re-fire all 13 queries.
  final dueCount = ref.watch(
    dashboardProvider.select((v) => v.value?.vocabDue ?? 0),
  );
  // Use current stream value; null while stream hasn't emitted yet (fine since
  // nextReview is nullable). Provider re-runs when stream emits a new value.
  final nextReview = ref.watch(nextVocabReviewProvider).value;

  // Catalog cards need availability/counts, not full vocab row hydration.
  // Use bundled manifests instead of opening the content DB. A fresh web DB can
  // spend a long time seeding; the hub must still render immediately.
  Future<int> hajimeteCount(String levelCode) async {
    try {
      final catalog = await loadHajimeteChapterCatalog(
        levelCode,
      ).timeout(const Duration(seconds: 1));
      return catalog.totalTerms;
    } catch (_) {
      return 0;
    }
  }

  Future<_SeriesManifestSummary> mimikaraSummary(String levelCode) =>
      _loadMimikaraManifestSummary(levelCode);

  final n5CountFuture = hajimeteCount('N5');
  final n4CountFuture = hajimeteCount('N4');
  final n3CountFuture = hajimeteCount('N3');
  final n2CountFuture = hajimeteCount('N2');
  final n1CountFuture = hajimeteCount('N1');
  final mimikaraN3SummaryFuture = mimikaraSummary('N3');
  final mimikaraN2SummaryFuture = mimikaraSummary('N2');
  final mimikaraN1SummaryFuture = mimikaraSummary('N1');
  final minnaN5CountFuture = _loadMinnaLessonRangeCount(
    'N5',
    startLesson: 1,
    endLesson: 25,
  );
  final minnaN4CountFuture = _loadMinnaLessonRangeCount(
    'N4',
    startLesson: 26,
    endLesson: 50,
  );

  final counts = await Future.wait<int>([
    n5CountFuture,
    n4CountFuture,
    n3CountFuture,
    n2CountFuture,
    n1CountFuture,
    minnaN5CountFuture,
    minnaN4CountFuture,
  ]);
  final summaries = await Future.wait<_SeriesManifestSummary>([
    mimikaraN3SummaryFuture,
    mimikaraN2SummaryFuture,
    mimikaraN1SummaryFuture,
  ]);
  final n5Count = counts[0];
  final n4Count = counts[1];
  final n3Count = counts[2];
  final n2Count = counts[3];
  final n1Count = counts[4];
  final minnaN5Count = counts[5];
  final minnaN4Count = counts[6];
  final mimikaraN3Summary = summaries[0];
  final mimikaraN2Summary = summaries[1];
  final mimikaraN1Summary = summaries[2];
  int mimikaraRouteCount(_SeriesManifestSummary summary) => summary.routeCount;

  return [
    _buildJlptSection(
      language: language,
      levelCode: 'N5',
      liveCount: n5Count,
      dueCount: dueCount,
      nextReview: nextReview,
      accent: AppThemePalette.light.warning,
      companionTitle: 'Minna no Nihongo I',
      companionSubtitle: _courseSubtitle(
        language,
        _VocabProgramType.minna,
        'N5',
      ),
      companionType: _VocabProgramType.minna,
      companionCountOverride: minnaN5Count,
      isInteractive: true,
    ),
    _buildJlptSection(
      language: language,
      levelCode: 'N4',
      liveCount: n4Count,
      dueCount: dueCount,
      nextReview: nextReview,
      accent: AppThemePalette.light.primary,
      companionTitle: 'Minna no Nihongo II',
      companionSubtitle: _courseSubtitle(
        language,
        _VocabProgramType.minna,
        'N4',
      ),
      companionType: _VocabProgramType.minna,
      companionCountOverride: minnaN4Count,
      isInteractive: true,
    ),
    _buildJlptSection(
      language: language,
      levelCode: 'N3',
      liveCount: n3Count,
      dueCount: dueCount,
      nextReview: nextReview,
      accent: AppThemePalette.light.success,
      companionTitle: 'Mimikara',
      companionSubtitle: _courseSubtitle(
        language,
        _VocabProgramType.mimikara,
        'N3',
      ),
      companionType: _VocabProgramType.mimikara,
      companionCountOverride: mimikaraN3Summary.importedTermCount,
      companionStructureCount: mimikaraRouteCount(mimikaraN3Summary),
      isInteractive: true,
    ),
    _buildJlptSection(
      language: language,
      levelCode: 'N2',
      liveCount: n2Count,
      dueCount: dueCount,
      nextReview: nextReview,
      accent: AppThemePalette.light.error,
      companionTitle: 'Mimikara',
      companionSubtitle: _courseSubtitle(
        language,
        _VocabProgramType.mimikara,
        'N2',
      ),
      companionType: _VocabProgramType.mimikara,
      companionCountOverride: mimikaraN2Summary.importedTermCount,
      companionStructureCount: mimikaraRouteCount(mimikaraN2Summary),
      isInteractive: true,
    ),
    _buildJlptSection(
      language: language,
      levelCode: 'N1',
      liveCount: n1Count,
      dueCount: dueCount,
      nextReview: nextReview,
      accent: AppThemePalette.light.info,
      companionTitle: 'Mimikara',
      companionSubtitle: _courseSubtitle(
        language,
        _VocabProgramType.mimikara,
        'N1',
      ),
      companionType: _VocabProgramType.mimikara,
      companionCountOverride: mimikaraN1Summary.importedTermCount,
      companionStructureCount: mimikaraRouteCount(mimikaraN1Summary),
      extraPrograms: [
        const _VocabCatalogProgram(
          key: 'advanced_n1',
          titleTop: 'Advanced Vocabulary Lab',
          titleMain: 'N1+',
          termCount: 0,
          subtitle:
              'Extended nuance, formal usage, and dense reading support are planned next.',
          type: _VocabProgramType.advanced,
          isInteractive: false,
          isComingSoon: true,
          badgeText: 'Advanced',
        ),
      ],
      isInteractive: true,
    ),
    _VocabCatalogSection(
      key: 'se',
      levelCode: 'SE',
      subtitle: 'Workplace Japanese for software teams',
      accent: AppThemePalette.light.ink,
      programs: const [
        _VocabCatalogProgram(
          key: 'se_track',
          titleTop: 'Technical Japanese',
          titleMain: 'SE',
          termCount: 0,
          subtitle:
              'Product, engineering, meetings, specs, and workplace Japanese.',
          type: _VocabProgramType.specialized,
          isInteractive: false,
          isComingSoon: true,
          badgeText: 'Specialized',
        ),
      ],
    ),
  ];
});

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
        levelCode: section.levelCode,
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

int? _chapterCountForLevel(String levelCode) => switch (levelCode) {
  'N5' => 14,
  'N4' => 20,
  'N3' => 28,
  'N2' => 38,
  'N1' => 50,
  _ => null,
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

String _formatDueBadge(
  AppLanguage language,
  int dueCount,
  DateTime? nextReview,
) {
  final timing = _formatReviewTiming(language, nextReview);
  return switch (language) {
    AppLanguage.en => '$dueCount due - $timing',
    AppLanguage.vi => '$dueCount mục đến hạn - $timing',
    AppLanguage.ja => '$dueCount件期限 - $timing',
  };
}

String _localizedSectionSubtitle(
  _VocabCatalogSection section,
  AppLanguage language,
) =>
    language.vocabLocalizedSectionSubtitle(section.levelCode, section.subtitle);

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

String _previewDialogBody(AppLanguage language, _VocabCatalogProgram program) {
  if (program.previewBody != null && program.previewBody!.trim().isNotEmpty) {
    return program.previewBody!;
  }
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
