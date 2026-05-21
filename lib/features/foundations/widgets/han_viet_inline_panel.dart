import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/features/foundations/models/han_viet_rule.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

class HanVietInlinePanel extends StatelessWidget {
  const HanVietInlinePanel({
    super.key,
    required this.rules,
    required this.language,
    this.kanji,
  });

  final List<HanVietRule> rules;
  final AppLanguage language;
  final String? kanji;

  @override
  Widget build(BuildContext context) {
    final matched = kanji == null
        ? const <HanVietRule>[]
        : rules
              .where(
                (rule) =>
                    rule.examples.any((example) => example.kanji == kanji),
              )
              .toList(growable: false);
    final filterActive = kanji != null && matched.isNotEmpty;
    final preview = (filterActive ? matched : rules.take(3))
        .take(3)
        .toList(growable: false);
    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        key: const ValueKey('han_viet_inline_panel'),
        title: Row(
          children: [
            Expanded(child: Text(language.hanVietInlinePanelTitle)),
            if (filterActive)
              AppChip(
                label: language.hanVietPanelMatchedBadge,
                tone: AppChipTone.info,
              ),
          ],
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          for (final rule in preview)
            ListTile(
              dense: true,
              title: Text(rule.localizedTitle(language)),
              subtitle: Text(rule.localizedPattern(language)),
              contentPadding: EdgeInsets.zero,
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(
              label: language.commonMoreAction,
              icon: Icons.open_in_new_rounded,
              variant: AppButtonVariant.ghost,
              compact: true,
              onPressed: () => context.push(AppRoutePath.foundationsHanViet),
            ),
          ),
        ],
      ),
    );
  }
}

class HanVietRuleMiniPanel extends StatelessWidget {
  const HanVietRuleMiniPanel({
    super.key,
    required this.ruleSet,
    required this.language,
    required this.kanji,
    this.hanViet,
    this.onyomi,
  });

  final HanVietRuleSetV2 ruleSet;
  final AppLanguage language;
  final String kanji;
  final String? hanViet;
  final String? onyomi;

  @override
  Widget build(BuildContext context) {
    if (language != AppLanguage.vi) return const SizedBox.shrink();
    final rules = ruleSet.matchingRulesForKanji(
      character: kanji,
      hanViet: hanViet,
      onyomi: onyomi,
      limit: 2,
    );
    if (rules.isEmpty) return const SizedBox.shrink();

    final palette = Theme.of(context).colorScheme;
    final primaryRule = rules.first;
    HanVietRuleExampleV2? example;
    for (final item in primaryRule.examples) {
      if (item.kanji == kanji) {
        example = item;
        break;
      }
    }
    final exampleText = example == null
        ? primaryRule.examples
              .take(2)
              .map((item) => '${item.hanViet} → ${item.kanji} (${item.onyomi})')
              .join(' · ')
        : '${example.hanViet} → ${example.kanji} (${example.onyomi})';

    return Container(
      key: const ValueKey('kanji_detail_han_viet_rule_panel'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.primaryContainer.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.primary.withValues(alpha: 0.36)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quy tắc Hán-Việt áp dụng',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: palette.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${primaryRule.section}. ${primaryRule.title}',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            '${primaryRule.percentage}% → ${primaryRule.targetRow} '
            '(${primaryRule.targetKana.join('・')})',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          if (exampleText.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(exampleText),
          ],
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(
              key: const ValueKey('han_viet_rule_mini_open_full'),
              label: language.commonMoreAction,
              icon: Icons.open_in_new_rounded,
              variant: AppButtonVariant.ghost,
              compact: true,
              onPressed: () {
                final router = GoRouter.of(context);
                Navigator.of(context, rootNavigator: true).pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  router.push(AppRoutePath.kanjiHanViet);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
