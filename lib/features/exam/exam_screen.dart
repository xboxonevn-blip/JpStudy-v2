import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_palette.dart';
import '../../core/app_language.dart';
import '../../core/language_provider.dart';
import '../../core/level_provider.dart';
import '../../core/services/session_storage_provider.dart';
import '../../core/services/session_storage.dart';
import '../../core/study_level.dart';
import '../../data/models/vocab_item.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../features/common/widgets/compact_ui.dart';
import '../test/models/test_config.dart';
import '../test/screens/test_config_screen.dart';
import '../test/screens/test_screen.dart';

typedef _PreparedMockExam = ({
  String level,
  List<VocabItem> items,
  TestSessionSnapshot? resume,
});

class ExamScreen extends ConsumerStatefulWidget {
  const ExamScreen({super.key});

  @override
  ConsumerState<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends ConsumerState<ExamScreen> {
  String? _activeLevel;
  String? _loadingLevel;
  Object? _loadError;
  _PreparedMockExam? _preparedExam;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final selectedLevel = ref.watch(studyLevelProvider) ?? StudyLevel.n5;
    final levels = [
      selectedLevel,
      ...StudyLevel.values.where((level) => level != selectedLevel),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(language.examTitle)),
      body: AppPageShell(
        topPadding: AppSpacing.sm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppFeatureCard(
              icon: Icons.timer_outlined,
              title: language.examTitle,
              subtitle: language.mockExamSubtitle,
              status: AppStatusChip(
                label: selectedLevel.shortLabel,
                tone: AppStatusTone.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppSectionHeader(title: _chooseLevelLabel(language)),
            const SizedBox(height: AppSpacing.sm),
            for (final level in levels) ...[
              _ExamLevelCard(
                level: level.shortLabel,
                subtitle: _examMeta(level.shortLabel).subtitle(language),
                isSelected: _activeLevel == level.shortLabel,
                isLoading: _loadingLevel == level.shortLabel,
                onTap: () => _prepareMockExam(language, level.shortLabel),
              ),
              if (_activeLevel == level.shortLabel) ...[
                const SizedBox(height: AppSpacing.md),
                if (_loadingLevel != null)
                  _ExamLoadingCard(language: language, level: _loadingLevel!)
                else if (_loadError != null)
                  _ExamErrorCard(
                    language: language,
                    level: _activeLevel!,
                    onRetry: () => _prepareMockExam(language, _activeLevel!),
                  )
                else if (_preparedExam != null)
                  _ExamStartCard(
                    language: language,
                    preparedExam: _preparedExam!,
                    onStart: () => _openConfig(language, _preparedExam!),
                    onResume: _preparedExam!.resume == null
                        ? null
                        : () => _resumeExam(language, _preparedExam!),
                    onDiscardResume: _preparedExam!.resume == null
                        ? null
                        : () => _discardResume(_preparedExam!),
                  ),
              ],
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }

  String _chooseLevelLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'Choose level';
      case AppLanguage.vi:
        return 'Chọn cấp độ';
      case AppLanguage.ja:
        return 'レベルを選ぶ';
    }
  }

  Future<void> _prepareMockExam(AppLanguage language, String level) async {
    setState(() {
      _activeLevel = level;
      _loadingLevel = level;
      _loadError = null;
      _preparedExam = null;
    });

    try {
      final repo = ref.read(lessonRepositoryProvider);
      final sessionKey = 'mock_$level';
      final storage = ref.read(sessionStorageProvider);
      final vocabFuture = repo.getVocabByLevel(level);
      final resumeFuture = storage.loadTestSession(sessionKey);
      final allVocab = await vocabFuture;
      final resumeSnapshot = await resumeFuture;

      if (!mounted || _activeLevel != level) {
        return;
      }
      setState(() {
        _loadingLevel = null;
        _preparedExam = (level: level, items: allVocab, resume: resumeSnapshot);
      });
    } catch (error) {
      if (!mounted || _activeLevel != level) return;
      setState(() {
        _loadingLevel = null;
        _loadError = error;
      });
    }
  }

  void _openConfig(AppLanguage language, _PreparedMockExam prepared) {
    if (prepared.items.isEmpty) return;
    final level = prepared.level;
    final sessionKey = 'mock_$level';
    final storage = ref.read(sessionStorageProvider);
    final initialConfig = TestConfig.mockExam(
      questionCount: prepared.items.length,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TestConfigScreen(
          lessonId: -1,
          lessonTitle: language.mockExamTitle(level),
          maxQuestions: prepared.items.length,
          initialConfig: initialConfig,
          resumeSnapshot: prepared.resume,
          onResume: prepared.resume == null
              ? null
              : () => _pushTestReplacement(
                  language,
                  prepared,
                  prepared.resume!.config,
                  resumeSnapshot: prepared.resume,
                ),
          onDiscardResume: prepared.resume == null
              ? null
              : () => storage.clearTestSession(sessionKey),
          onStart: (config) => _pushTestReplacement(language, prepared, config),
        ),
      ),
    );
  }

  void _resumeExam(AppLanguage language, _PreparedMockExam prepared) {
    final resume = prepared.resume;
    if (resume == null || prepared.items.isEmpty) return;
    _pushTestReplacement(
      language,
      prepared,
      resume.config,
      resumeSnapshot: resume,
    );
  }

  Future<void> _discardResume(_PreparedMockExam prepared) async {
    final storage = ref.read(sessionStorageProvider);
    await storage.clearTestSession('mock_${prepared.level}');
    if (!mounted || _preparedExam?.level != prepared.level) return;
    setState(() {
      _preparedExam = (
        level: prepared.level,
        items: prepared.items,
        resume: null,
      );
    });
  }

  void _pushTestReplacement(
    AppLanguage language,
    _PreparedMockExam prepared,
    TestConfig config, {
    TestSessionSnapshot? resumeSnapshot,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TestScreen(
          items: prepared.items,
          lessonId: -1,
          lessonTitle: language.mockExamTitle(prepared.level),
          config: config,
          resumeSnapshot: resumeSnapshot,
          sessionKey: 'mock_${prepared.level}',
        ),
      ),
    );
  }
}

class _ExamLevelCard extends StatelessWidget {
  const _ExamLevelCard({
    required this.level,
    required this.subtitle,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  final String level;
  final String subtitle;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return AppSectionCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [palette.primary, palette.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.timer_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'JLPT $level',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: palette.ink,
                          ),
                        ),
                      ),
                      if (isSelected)
                        AppStatusChip(
                          label: isLoading ? 'Loading' : 'Ready',
                          tone: isLoading
                              ? AppStatusTone.warning
                              : AppStatusTone.success,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: palette.ink.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              )
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: palette.ink.withValues(alpha: 0.4),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}

class _ExamStartCard extends StatelessWidget {
  const _ExamStartCard({
    required this.language,
    required this.preparedExam,
    required this.onStart,
    required this.onResume,
    required this.onDiscardResume,
  });

  final AppLanguage language;
  final _PreparedMockExam preparedExam;
  final VoidCallback onStart;
  final VoidCallback? onResume;
  final Future<void> Function()? onDiscardResume;

  @override
  Widget build(BuildContext context) {
    final level = preparedExam.level;
    final items = preparedExam.items;
    if (items.isEmpty) {
      return AppSectionCard(
        child: AppEmptyState(
          icon: Icons.assignment_late_outlined,
          title: _tr(
            language,
            en: 'No $level exam questions yet',
            vi: 'Chưa có câu thi $level',
            ja: '$level の問題がまだありません',
          ),
          message: _tr(
            language,
            en: 'This level has no loaded terms. Pick another JLPT level or return after the content sync finishes.',
            vi: 'Cấp này chưa có dữ liệu câu hỏi. Hãy chọn cấp JLPT khác hoặc quay lại sau khi đồng bộ nội dung hoàn tất.',
            ja: 'このレベルの問題データはまだ読み込まれていません。別の級を選ぶか、同期後に戻ってください。',
          ),
        ),
      );
    }

    final meta = _examMeta(level);
    final actualCount = items.length.clamp(1, 50);
    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppStatusChip(label: 'JLPT $level', tone: AppStatusTone.primary),
              AppStatusChip(
                label: meta.minutesLabel(language),
                tone: AppStatusTone.warning,
              ),
              AppStatusChip(
                label: _questionLabel(language, actualCount),
                tone: AppStatusTone.success,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _tr(
              language,
              en: 'JLPT $level start screen',
              vi: 'Màn bắt đầu đề JLPT $level',
              ja: 'JLPT $level 開始画面',
            ),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _tr(
              language,
              en: 'Read the instructions, check the breakdown, then start when you are ready. The current quick mock uses the loaded vocabulary bank for this level.',
              vi: 'Đọc hướng dẫn, xem cấu trúc đề, rồi bấm bắt đầu khi sẵn sàng. Đề nhanh hiện dùng ngân hàng từ vựng đã nạp cho cấp này.',
              ja: '説明と構成を確認してから開始してください。現在のクイック模試は、この級の語彙バンクを使います。',
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppFluidGrid(
            minItemWidth: 180,
            maxColumns: 3,
            children: [
              _ExamBreakdownTile(
                icon: Icons.translate_rounded,
                title: _tr(language, en: 'Vocabulary', vi: 'Từ vựng', ja: '語彙'),
                value: _questionLabel(language, actualCount),
              ),
              _ExamBreakdownTile(
                icon: Icons.menu_book_rounded,
                title: _tr(language, en: 'Sections', vi: 'Phần thi', ja: '分野'),
                value: meta.sections(language),
              ),
              _ExamBreakdownTile(
                icon: Icons.fact_check_rounded,
                title: _tr(
                  language,
                  en: 'Official target',
                  vi: 'Mốc JLPT',
                  ja: '目安',
                ),
                value: meta.officialCount(language),
              ),
            ],
          ),
          if (preparedExam.resume != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppSectionCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  const Icon(Icons.history_rounded),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      _tr(
                        language,
                        en: 'A saved attempt is available for this level.',
                        vi: 'Cấp này có một lượt làm bài đang lưu.',
                        ja: 'この級には保存済みの受験があります。',
                      ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AppButton(
                    label: _tr(
                      language,
                      en: 'Resume',
                      vi: 'Làm tiếp',
                      ja: '再開',
                    ),
                    variant: AppButtonVariant.secondary,
                    compact: true,
                    onPressed: onResume,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppButton(
                    label: _tr(language, en: 'Discard', vi: 'Bỏ lưu', ja: '破棄'),
                    variant: AppButtonVariant.ghost,
                    compact: true,
                    onPressed: onDiscardResume == null
                        ? null
                        : () => onDiscardResume!.call(),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: _tr(language, en: 'Start exam', vi: 'Bắt đầu thi', ja: '開始'),
            icon: Icons.play_arrow_rounded,
            expanded: true,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

class _ExamLoadingCard extends StatelessWidget {
  const _ExamLoadingCard({required this.language, required this.level});

  final AppLanguage language;
  final String level;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      child: Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              _tr(
                language,
                en: 'Preparing JLPT $level questions...',
                vi: 'Đang chuẩn bị câu hỏi JLPT $level...',
                ja: 'JLPT $level の問題を準備中...',
              ),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamErrorCard extends StatelessWidget {
  const _ExamErrorCard({
    required this.language,
    required this.level,
    required this.onRetry,
  });

  final AppLanguage language;
  final String level;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      child: AppEmptyState(
        icon: Icons.error_outline_rounded,
        title: _tr(
          language,
          en: 'Could not prepare JLPT $level',
          vi: 'Chưa chuẩn bị được đề JLPT $level',
          ja: 'JLPT $level を準備できませんでした',
        ),
        message: language.loadErrorLabel,
        actionLabel: language.retryLabel,
        onActionTap: onRetry,
      ),
    );
  }
}

class _ExamBreakdownTile extends StatelessWidget {
  const _ExamBreakdownTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.outline),
      ),
      child: Row(
        children: [
          Icon(icon, color: palette.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: palette.ink.withValues(alpha: 0.64),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: palette.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JlptExamMeta {
  const _JlptExamMeta({
    required this.minutes,
    required this.officialQuestions,
    required this.approximate,
    required this.viSections,
    required this.enSections,
    required this.jaSections,
  });

  final int minutes;
  final int officialQuestions;
  final bool approximate;
  final String viSections;
  final String enSections;
  final String jaSections;

  String subtitle(AppLanguage language) {
    return '${minutesLabel(language)} · ${officialCount(language)} · ${sections(language)}';
  }

  String minutesLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => '$minutes min',
    AppLanguage.vi => '$minutes phút',
    AppLanguage.ja => '$minutes分',
  };

  String officialCount(AppLanguage language) {
    final prefix = approximate ? '~' : '';
    return switch (language) {
      AppLanguage.en => '$prefix$officialQuestions questions',
      AppLanguage.vi => '$prefix$officialQuestions câu',
      AppLanguage.ja => '$prefix$officialQuestions問',
    };
  }

  String sections(AppLanguage language) => switch (language) {
    AppLanguage.en => enSections,
    AppLanguage.vi => viSections,
    AppLanguage.ja => jaSections,
  };
}

_JlptExamMeta _examMeta(String level) {
  return switch (level.toUpperCase()) {
    'N5' => const _JlptExamMeta(
      minutes: 60,
      officialQuestions: 95,
      approximate: false,
      viSections: 'từ vựng, đọc hiểu, nghe',
      enSections: 'vocabulary, reading, listening',
      jaSections: '語彙・読解・聴解',
    ),
    'N4' => const _JlptExamMeta(
      minutes: 120,
      officialQuestions: 105,
      approximate: false,
      viSections: 'từ vựng, ngữ pháp, đọc hiểu, nghe',
      enSections: 'vocabulary, grammar, reading, listening',
      jaSections: '語彙・文法・読解・聴解',
    ),
    'N3' => const _JlptExamMeta(
      minutes: 140,
      officialQuestions: 95,
      approximate: true,
      viSections: 'ngôn ngữ, đọc hiểu, nghe',
      enSections: 'language knowledge, reading, listening',
      jaSections: '言語知識・読解・聴解',
    ),
    'N2' => const _JlptExamMeta(
      minutes: 155,
      officialQuestions: 105,
      approximate: true,
      viSections: 'ngôn ngữ, đọc hiểu, nghe',
      enSections: 'language knowledge, reading, listening',
      jaSections: '言語知識・読解・聴解',
    ),
    'N1' => const _JlptExamMeta(
      minutes: 170,
      officialQuestions: 110,
      approximate: true,
      viSections: 'ngôn ngữ, đọc hiểu, nghe',
      enSections: 'language knowledge, reading, listening',
      jaSections: '言語知識・読解・聴解',
    ),
    _ => const _JlptExamMeta(
      minutes: 60,
      officialQuestions: 50,
      approximate: true,
      viSections: 'từ vựng, đọc hiểu, nghe',
      enSections: 'vocabulary, reading, listening',
      jaSections: '語彙・読解・聴解',
    ),
  };
}

String _questionLabel(AppLanguage language, int count) {
  return switch (language) {
    AppLanguage.en => '$count questions',
    AppLanguage.vi => '$count câu',
    AppLanguage.ja => '$count問',
  };
}

String _tr(
  AppLanguage language, {
  required String en,
  required String vi,
  required String ja,
}) {
  return switch (language) {
    AppLanguage.en => en,
    AppLanguage.vi => vi,
    AppLanguage.ja => ja,
  };
}
