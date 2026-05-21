import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_navigation_extensions.dart';
import 'package:jpstudy/app/theme/app_spacing.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/utils/mimikara_catalog_loader.dart';
import 'package:jpstudy/features/common/widgets/compact_ui.dart';
import 'package:jpstudy/features/vocab/vocab_content_timeout.dart';
import 'package:jpstudy/features/vocab/vocab_copy.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

class MimikaraUnitCatalogArgs {
  const MimikaraUnitCatalogArgs({
    required this.levelCode,
    required this.title,
    this.subtitle,
  });

  final String levelCode;
  final String title;
  final String? subtitle;

  @override
  bool operator ==(Object other) {
    return other is MimikaraUnitCatalogArgs &&
        other.levelCode == levelCode &&
        other.title == title &&
        other.subtitle == subtitle;
  }

  @override
  int get hashCode => Object.hash(levelCode, title, subtitle);
}

final mimikaraUnitCatalogProvider =
    FutureProvider.family<MimikaraUnitCatalog, MimikaraUnitCatalogArgs>((
      ref,
      args,
    ) {
      return withVocabContentTimeout(
        loadMimikaraUnitCatalog(args.levelCode),
        ref: ref,
      );
    });

class MimikaraUnitCatalogScreen extends ConsumerWidget {
  const MimikaraUnitCatalogScreen({
    super.key,
    required this.levelCode,
    required this.title,
    this.subtitle,
  });

  final String levelCode;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final args = MimikaraUnitCatalogArgs(
      levelCode: levelCode,
      title: title,
      subtitle: subtitle,
    );
    final catalogAsync = ref.watch(mimikaraUnitCatalogProvider(args));

    return Scaffold(
      body: AppPageShell(
        topPadding: AppSpacing.md,
        child: catalogAsync.when(
          data: (catalog) =>
              _CatalogBody(args: args, catalog: catalog, language: language),
          loading: () => const Padding(
            padding: EdgeInsets.only(top: 120),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => AppFeatureCard(
            icon: Icons.error_outline_rounded,
            title: _errorTitle(language),
            subtitle: error.toString(),
            secondaryLabel: _retryLabel(language),
            onSecondaryTap: () =>
                ref.invalidate(mimikaraUnitCatalogProvider(args)),
          ),
        ),
      ),
    );
  }
}

class _CatalogBody extends StatelessWidget {
  const _CatalogBody({
    required this.args,
    required this.catalog,
    required this.language,
  });

  final MimikaraUnitCatalogArgs args;
  final MimikaraUnitCatalog catalog;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: AppButton(
            label: _backLabel(language),
            icon: Icons.arrow_back_rounded,
            variant: AppButtonVariant.ghost,
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                context.pop();
                return;
              }
              context.openVocab();
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _Hero(args: args, catalog: catalog, language: language),
        const SizedBox(height: AppSpacing.xl),
        AppSectionHeader(
          title: _unitListTitle(language),
          caption: _unitListCaption(language, catalog.units.length),
        ),
        const SizedBox(height: AppSpacing.md),
        _UnitList(args: args, catalog: catalog, language: language),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.args,
    required this.catalog,
    required this.language,
  });

  final MimikaraUnitCatalogArgs args;
  final MimikaraUnitCatalog catalog;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppStatusChip(label: args.levelCode, tone: AppStatusTone.primary),
              AppStatusChip(
                label: language.vocabProgramTypeLabel('mimikara'),
                tone: AppStatusTone.neutral,
              ),
              AppStatusChip(
                label: _readyLabel(language),
                tone: AppStatusTone.success,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            args.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: palette.ink,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            args.subtitle ?? _heroSubtitle(language, args.levelCode),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: palette.ink.withValues(alpha: 0.74),
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppStatusChip(
                label: _unitCountLabel(language, catalog.units.length),
                tone: AppStatusTone.primary,
              ),
              AppStatusChip(
                label: _termCountLabel(language, catalog.totalTerms),
                tone: AppStatusTone.success,
              ),
              if (catalog.sourceMode.contains('fallback'))
                AppStatusChip(
                  label: _fallbackLabel(language),
                  tone: AppStatusTone.warning,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: _reviewAllLabel(language),
            icon: Icons.play_circle_fill_rounded,
            onPressed: catalog.totalTerms == 0
                ? null
                : () => context.openVocabReview(
                    source: 'mimikara_catalog',
                    levelCode: catalog.levelCode,
                    series: 'mimikara',
                    title: args.title,
                    subtitle: args.subtitle ?? catalog.title,
                  ),
          ),
        ],
      ),
    );
  }
}

class _UnitList extends StatelessWidget {
  const _UnitList({
    required this.args,
    required this.catalog,
    required this.language,
  });

  final MimikaraUnitCatalogArgs args;
  final MimikaraUnitCatalog catalog;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('mimikara_unit_catalog'),
      children: [
        for (final unit in catalog.units) ...[
          AppCompactRow(
            key: ValueKey('mimikara_unit_${unit.unitId}'),
            icon: Icons.library_books_rounded,
            title: unit.title,
            subtitle: _unitSubtitle(language, unit),
            status: AppStatusChip(
              label: _termCountLabel(language, unit.termCount),
              tone: AppStatusTone.success,
            ),
            onTap: unit.termCount == 0
                ? null
                : () => context.openVocabReview(
                    source: 'mimikara_unit',
                    levelCode: catalog.levelCode,
                    series: 'mimikara',
                    lessonStart: unit.unitId,
                    lessonEnd: unit.unitId,
                    title: '${args.title} ${unit.title}',
                    subtitle: _unitSubtitle(language, unit),
                  ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

String _unitSubtitle(AppLanguage language, MimikaraUnitSummary unit) {
  final preview = unit.previewTerms.take(4).join(' ・ ');
  final base = _unitNumberLabel(language, unit.unitId);
  return preview.isEmpty ? base : '$base · $preview';
}

String _backLabel(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Back to vocab',
  AppLanguage.vi => 'Về từ vựng',
  AppLanguage.ja => '語彙へ戻る',
};

String _readyLabel(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Ready',
  AppLanguage.vi => 'Đã có dữ liệu',
  AppLanguage.ja => '利用可能',
};

String _fallbackLabel(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Source gap logged',
  AppLanguage.vi => 'Đã ghi thiếu nguồn',
  AppLanguage.ja => '出典ギャップ記録済み',
};

String _heroSubtitle(
  AppLanguage language,
  String levelCode,
) => switch (language) {
  AppLanguage.en =>
    'A factual Mimikara-style vocabulary lane for $levelCode, split by unit and ready for review.',
  AppLanguage.vi =>
    'Hướng từ vựng Mimikara $levelCode theo từng unit, dùng dữ kiện đã kiểm soát nguồn và sẵn để ôn.',
  AppLanguage.ja => '$levelCode の耳から系語彙をユニットごとに復習できます。',
};

String _unitListTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Units',
  AppLanguage.vi => 'Các unit',
  AppLanguage.ja => 'ユニット',
};

String _unitListCaption(AppLanguage language, int count) => switch (language) {
  AppLanguage.en => '$count units are available in the bundled catalog.',
  AppLanguage.vi => '$count unit đã có trong dữ liệu đóng gói.',
  AppLanguage.ja => '$count ユニットを収録済みデータから読み込みます。',
};

String _unitCountLabel(AppLanguage language, int count) => switch (language) {
  AppLanguage.en => count == 1 ? '1 unit' : '$count units',
  AppLanguage.vi => '$count unit',
  AppLanguage.ja => '$count ユニット',
};

String _termCountLabel(AppLanguage language, int count) => switch (language) {
  AppLanguage.en => count == 1 ? '1 term' : [count, 'terms'].join(' '),
  AppLanguage.vi => '$count mục từ',
  AppLanguage.ja => '$count 語',
};

String _unitNumberLabel(AppLanguage language, int unitId) => switch (language) {
  AppLanguage.en => 'Unit ${unitId.toString().padLeft(2, '0')}',
  AppLanguage.vi => 'Unit ${unitId.toString().padLeft(2, '0')}',
  AppLanguage.ja => 'Unit ${unitId.toString().padLeft(2, '0')}',
};

String _reviewAllLabel(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Review all terms',
  AppLanguage.vi => 'Ôn toàn bộ mục từ',
  AppLanguage.ja => 'すべて復習',
};

String _errorTitle(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Could not load Mimikara catalog',
  AppLanguage.vi => 'Không tải được danh sách Mimikara',
  AppLanguage.ja => 'Mimikara カタログを読み込めません',
};

String _retryLabel(AppLanguage language) => switch (language) {
  AppLanguage.en => 'Retry',
  AppLanguage.vi => 'Thử lại',
  AppLanguage.ja => '再試行',
};
