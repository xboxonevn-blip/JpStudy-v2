import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/data/models/kanji_item.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/data/utils/han_viet_lookup.dart';
import 'package:jpstudy/features/foundations/providers/foundations_providers.dart';
import 'package:jpstudy/features/foundations/widgets/han_viet_inline_panel.dart';
import 'package:jpstudy/features/write/services/kanji_stroke_template_service.dart';
import 'package:jpstudy/features/write/services/kanji_stroke_vector_service.dart';
import 'package:jpstudy/features/write/widgets/kanji_stroke_animator.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

class KanjiInlinePopover extends ConsumerWidget {
  const KanjiInlinePopover({
    super.key,
    required this.character,
    required this.language,
  });

  final String character;
  final AppLanguage language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppButton(
      label: character,
      variant: AppButtonVariant.secondary,
      compact: true,
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (_) =>
              _KanjiInlineDialog(character: character, language: language),
        );
      },
    );
  }
}

final _kanjiInlineDataProvider =
    FutureProvider.family<_KanjiInlineData, String>((ref, character) async {
      final repo = ref.watch(lessonRepositoryProvider);
      KanjiItem? item;
      for (final level in const ['N5', 'N4', 'N3', 'N2', 'N1']) {
        final rows = await repo.fetchKanjiByLevel(level);
        for (final row in rows) {
          if (row.character == character) {
            item = row;
            break;
          }
        }
        if (item != null) break;
      }

      final lookup = await HanVietLookup.resolve(
        term: character,
        explicitHanViet: item?.decomposition?.hanViet,
        explicitMeaningVi: item?.meaning,
      );
      final template = await KanjiStrokeTemplateService.instance.getTemplate(
        character,
      );
      final vector = await KanjiStrokeVectorService.instance.getVector(
        character,
      );
      return _KanjiInlineData(
        item: item,
        hanViet: lookup.hanViet,
        meaningVi: lookup.meaningVi,
        template: template,
        vector: vector,
      );
    });

class _KanjiInlineData {
  const _KanjiInlineData({
    required this.item,
    required this.hanViet,
    required this.meaningVi,
    required this.template,
    required this.vector,
  });

  final KanjiItem? item;
  final String? hanViet;
  final String? meaningVi;
  final KanjiStrokeTemplate? template;
  final KanjiStrokeVector? vector;
}

class _KanjiInlineDialog extends ConsumerWidget {
  const _KanjiInlineDialog({required this.character, required this.language});

  final String character;
  final AppLanguage language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_kanjiInlineDataProvider(character));
    final palette = context.appPalette;
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 560),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: async.when(
            loading: () => const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => _KanjiInlineLoaded(
              character: character,
              language: language,
              data: const _KanjiInlineData(
                item: null,
                hanViet: null,
                meaningVi: null,
                template: null,
                vector: null,
              ),
            ),
            data: (data) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: palette.primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        character,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        _dialogTitle(language),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: _KanjiInlineLoaded(
                    character: character,
                    language: language,
                    data: data,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KanjiInlineLoaded extends ConsumerWidget {
  const _KanjiInlineLoaded({
    required this.character,
    required this.language,
    required this.data,
  });

  final String character;
  final AppLanguage language;
  final _KanjiInlineData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = data.item;
    final meaning = _meaningForLanguage(data, language);
    final strokeWidget = data.vector != null || data.template != null
        ? KanjiStrokeAnimator(
            language: language,
            vectorTemplate: data.vector,
            linearTemplate: data.template,
            canvasSize: 140,
          )
        : null;
    final rulesAsync = ref.watch(hanVietRulesV2Provider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (meaning.isNotEmpty) ...[
            _InlineSectionTitle(_meaningTitle(language)),
            const SizedBox(height: 6),
            Text(meaning),
            const SizedBox(height: 14),
          ],
          if ((data.hanViet ?? '').trim().isNotEmpty) ...[
            _InlineSectionTitle(_hanVietTitle(language)),
            const SizedBox(height: 6),
            Text(_hanVietBridgeText(language, data.hanViet!.trim())),
            const SizedBox(height: 12),
          ],
          rulesAsync.maybeWhen(
            data: (ruleSet) => HanVietRuleMiniPanel(
              ruleSet: ruleSet,
              language: language,
              kanji: character,
              hanViet: data.hanViet,
              onyomi: item?.onyomi,
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          if (strokeWidget != null) ...[
            const SizedBox(height: 14),
            _InlineSectionTitle(_strokeTitle(language)),
            const SizedBox(height: 8),
            Center(child: strokeWidget),
          ],
        ],
      ),
    );
  }
}

class _InlineSectionTitle extends StatelessWidget {
  const _InlineSectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w900,
        color: context.appPalette.primary,
      ),
    );
  }
}

String _meaningForLanguage(_KanjiInlineData data, AppLanguage language) {
  final item = data.item;
  final vi = (data.meaningVi ?? item?.meaning ?? '').trim();
  final en = (item?.meaningEn ?? '').trim();
  final ja = (item?.meaningJa ?? '').trim();
  return switch (language) {
    AppLanguage.vi => vi,
    AppLanguage.en => en.isNotEmpty ? en : vi,
    AppLanguage.ja => ja.isNotEmpty ? ja : en,
  };
}

String _dialogTitle(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Mở nhanh kanji',
  AppLanguage.ja => '漢字クイック確認',
  AppLanguage.en => 'Kanji quick view',
};

String _meaningTitle(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Ý nghĩa',
  AppLanguage.ja => '意味',
  AppLanguage.en => 'Meaning',
};

String _hanVietTitle(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Cầu Hán-Việt',
  AppLanguage.ja => '漢越音の手がかり',
  AppLanguage.en => 'Sino-Vietnamese bridge',
};

String _hanVietBridgeText(
  AppLanguage language,
  String hanViet,
) => switch (language) {
  AppLanguage.vi =>
    'Âm Hán-Việt: $hanViet. Đọc âm này trước để nối chữ mới với vốn từ tiếng Việt bạn đã biết.',
  AppLanguage.ja => '漢越音: $hanViet。既知のベトナム語語彙から形と意味を結びます。',
  AppLanguage.en =>
    'Sino-Vietnamese: $hanViet. Use it as a familiar anchor before memorizing the Japanese word.',
};

String _strokeTitle(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Thứ tự nét',
  AppLanguage.ja => '筆順',
  AppLanguage.en => 'Stroke order',
};
