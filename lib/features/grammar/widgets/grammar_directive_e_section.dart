import 'package:flutter/material.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

class GrammarDirectiveESection extends StatefulWidget {
  const GrammarDirectiveESection({
    super.key,
    required this.language,
    required this.form,
    required this.meaning,
    required this.usage,
    required this.etymology,
    required this.humanMoment,
    required this.crossLinks,
    required this.fallbackReference,
  });

  final AppLanguage language;
  final String form;
  final String meaning;
  final String usage;
  final String etymology;
  final String humanMoment;
  final List<GrammarCrossLink> crossLinks;
  final GrammarFallbackReference fallbackReference;

  @override
  State<GrammarDirectiveESection> createState() =>
      _GrammarDirectiveESectionState();
}

class GrammarCrossLink {
  const GrammarCrossLink({required this.pattern, required this.contrast});

  final String pattern;
  final String contrast;
}

class GrammarFallbackReference {
  const GrammarFallbackReference({
    required this.sourceCredit,
    required this.license,
    required this.sourceUrl,
  });

  final String sourceCredit;
  final String license;
  final String sourceUrl;
}

class _GrammarDirectiveESectionState extends State<GrammarDirectiveESection>
    with SingleTickerProviderStateMixin {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final language = widget.language;
    return AppSection(
      title: _overviewTitle(language),
      caption: _overviewCaption(language),
      child: AppCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _InfoBlock(
              label: _formLabel(language),
              value: widget.form,
              monospace: true,
            ),
            const SizedBox(height: 14),
            _InfoBlock(label: _meaningLabel(language), value: widget.meaning),
            const SizedBox(height: 14),
            _InfoBlock(label: _usageLabel(language), value: widget.usage),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Semantics(
                button: true,
                expanded: _expanded,
                child: AppButton(
                  label: _expanded
                      ? _collapseLabel(language)
                      : _expandLabel(language),
                  icon: _expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  variant: AppButtonVariant.ghost,
                  compact: false,
                  onPressed: () => setState(() => _expanded = !_expanded),
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _DeepDiveContent(widget: widget),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  String _overviewTitle(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Core pattern',
    AppLanguage.vi => 'Cốt lõi mẫu câu',
    AppLanguage.ja => '文型の核',
  };

  String _overviewCaption(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Form, meaning, and one practical usage pass.',
    AppLanguage.vi => 'Cấu trúc, ý nghĩa, rồi cách dùng ngay.',
    AppLanguage.ja => '形・意味・使い方を先に確認します。',
  };

  String _formLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Structure',
    AppLanguage.vi => 'Cấu trúc',
    AppLanguage.ja => '構造',
  };

  String _meaningLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Meaning',
    AppLanguage.vi => 'Ý nghĩa',
    AppLanguage.ja => '意味',
  };

  String _usageLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Usage',
    AppLanguage.vi => 'Cách dùng',
    AppLanguage.ja => '使い方',
  };

  String _expandLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Learn deeper',
    AppLanguage.vi => 'Tìm hiểu sâu hơn',
    AppLanguage.ja => '詳しく見る',
  };

  String _collapseLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Show less',
    AppLanguage.vi => 'Thu gọn',
    AppLanguage.ja => '閉じる',
  };
}

class _DeepDiveContent extends StatelessWidget {
  const _DeepDiveContent({required this.widget});

  final GrammarDirectiveESection widget;

  @override
  Widget build(BuildContext context) {
    final language = widget.language;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppDivider(),
        _InfoBlock(label: _etymologyLabel(language), value: widget.etymology),
        const SizedBox(height: 14),
        _InfoBlock(
          label: _humanMomentLabel(language),
          value: widget.humanMoment,
        ),
        if (widget.crossLinks.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            _crossLinksLabel(language),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: context.appPalette.accent,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          for (final link in widget.crossLinks) ...[
            AppChip(label: link.pattern, tone: AppChipTone.info),
            const SizedBox(height: 6),
            Text(link.contrast),
            const SizedBox(height: 8),
          ],
        ],
        _InfoBlock(
          label: _referenceLabel(language),
          value:
              '${widget.fallbackReference.sourceCredit} · '
              '${widget.fallbackReference.license} · '
              '${widget.fallbackReference.sourceUrl}',
        ),
      ],
    );
  }

  String _etymologyLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Root + Han-Viet bridge',
    AppLanguage.vi => 'Gốc rễ + cầu Hán-Việt',
    AppLanguage.ja => '語源と漢越の橋',
  };

  String _humanMomentLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Note from Dr. Linh',
    AppLanguage.vi => 'Lưu ý từ Dr. Linh',
    AppLanguage.ja => 'Dr. Linh のメモ',
  };

  String _crossLinksLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Related patterns',
    AppLanguage.vi => 'Mẫu liên quan',
    AppLanguage.ja => '関連文型',
  };

  String _referenceLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Fallback reference',
    AppLanguage.vi => 'Nguồn tham khảo dự phòng',
    AppLanguage.ja => '参考',
  };
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.label,
    required this.value,
    this.monospace = false,
  });

  final String label;
  final String value;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: palette.accent,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: palette.ink,
            fontFamily: monospace ? 'RobotoMono' : null,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
