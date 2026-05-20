import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/theme/app_spacing.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/db/database_provider.dart';
import 'package:jpstudy/features/foundations/models/han_viet_rule.dart';
import 'package:jpstudy/features/foundations/providers/foundations_providers.dart';

class HanVietReferenceGate extends ConsumerStatefulWidget {
  const HanVietReferenceGate({super.key, required this.fallbackPath});

  final String fallbackPath;

  @override
  ConsumerState<HanVietReferenceGate> createState() =>
      _HanVietReferenceGateState();
}

class _HanVietReferenceGateState extends ConsumerState<HanVietReferenceGate> {
  bool _scheduled = false;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    if (language == AppLanguage.vi) {
      return const HanVietReferenceScreen();
    }
    if (!_scheduled) {
      _scheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(widget.fallbackPath);
      });
    }
    return const SizedBox.shrink();
  }
}

class HanVietReferenceScreen extends ConsumerStatefulWidget {
  const HanVietReferenceScreen({super.key});

  @override
  ConsumerState<HanVietReferenceScreen> createState() =>
      _HanVietReferenceScreenState();
}

class _HanVietReferenceScreenState
    extends ConsumerState<HanVietReferenceScreen> {
  final SearchController _searchController = SearchController();
  String _query = '';
  _HanVietCategoryFilter _categoryFilter = _HanVietCategoryFilter.all;
  String? _practicePriorityKey;
  Future<_HanVietPracticePriority>? _practicePriorityFuture;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final rulesAsync = ref.watch(hanVietRulesProvider);
    final rulesV2Async = ref.watch(hanVietRulesV2Provider);

    return Scaffold(
      appBar: AppBar(title: Text(language.hanVietRulesTitle)),
      body: rulesAsync.when(
        data: (ruleSet) {
          return rulesV2Async.maybeWhen(
            data: (ruleSetV2) => ruleSetV2.rules.isEmpty
                ? _buildLegacyList(ruleSet, language)
                : _buildV2List(ruleSetV2, language),
            orElse: () => _buildLegacyList(ruleSet, language),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(error.toString())),
      ),
    );
  }

  Widget _buildLegacyList(HanVietRuleSet ruleSet, AppLanguage language) {
    final filtered = _filterRules(ruleSet.rules, _query, language);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _HanVietSearchField(
          controller: _searchController,
          hintText: language.hanVietRulesHint,
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: AppSpacing.md),
        _HanVietCategoryChips(
          selected: _categoryFilter,
          language: language,
          onSelected: (filter) => setState(() => _categoryFilter = filter),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox.shrink(
          key: ValueKey('han_viet_rule_list_count_${filtered.length}'),
        ),
        for (final rule in filtered)
          _HanVietRuleTile(
            rule: rule,
            language: language,
            sourceIds: _sourceLabels(rule, ruleSet),
            sourceLabel: language.foundationsSourceLabel,
          ),
      ],
    );
  }

  Widget _buildV2List(HanVietRuleSetV2 ruleSet, AppLanguage language) {
    final filtered = _filterRulesV2(ruleSet.rules, _query);
    final practiceKanjiIds = {
      for (final rule in filtered)
        for (final item in rule.practice.items) item.kanjiId,
    }.toList(growable: false);
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xFFF4FAFF)),
      child: FutureBuilder<_HanVietPracticePriority>(
        future: _priorityFutureFor(practiceKanjiIds),
        builder: (context, snapshot) {
          final priority = snapshot.data ?? _HanVietPracticePriority.empty;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _HanVietSearchField(
                controller: _searchController,
                hintText: language.hanVietRulesHint,
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox.shrink(
                key: ValueKey('han_viet_rule_list_count_${filtered.length}'),
              ),
              for (final rule in filtered)
                _HanVietRulePracticeCard(
                  rule: rule,
                  language: language,
                  answers: _practiceAnswers,
                  items: _prioritizePracticeItems(
                    rule.practice.items,
                    priority,
                  ),
                  onAnswered: (item, answer) {
                    _answerPracticeItem(item, answer);
                    unawaited(_markRuleIfPassed(rule));
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  List<HanVietRule> _filterRules(
    List<HanVietRule> rules,
    String query,
    AppLanguage language,
  ) {
    final normalized = query.trim().toLowerCase();
    return rules
        .where((rule) => _categoryFilter.matches(rule.category))
        .where(
          (rule) =>
              normalized.isEmpty ||
              rule.searchableText(language).contains(normalized),
        )
        .toList(growable: false);
  }

  List<HanVietRuleV2> _filterRulesV2(List<HanVietRuleV2> rules, String query) {
    final normalized = query.trim().toLowerCase();
    return rules
        .where((rule) => _categoryFilter.matches(rule.category))
        .where(
          (rule) =>
              normalized.isEmpty || rule.searchableText().contains(normalized),
        )
        .toList(growable: false);
  }

  final Map<String, String> _practiceAnswers = {};

  void _answerPracticeItem(HanVietRulePracticeItem item, String answer) {
    setState(() => _practiceAnswers[item.itemId] = answer);
  }

  Future<_HanVietPracticePriority> _priorityFutureFor(List<int> kanjiIds) {
    final key = kanjiIds.join(',');
    if (_practicePriorityKey == key && _practicePriorityFuture != null) {
      return _practicePriorityFuture!;
    }
    _practicePriorityKey = key;
    _practicePriorityFuture = _loadPracticePriority(kanjiIds);
    return _practicePriorityFuture!;
  }

  Future<_HanVietPracticePriority> _loadPracticePriority(
    List<int> kanjiIds,
  ) async {
    if (kanjiIds.isEmpty) return _HanVietPracticePriority.empty;
    final states = await ref
        .read(databaseProvider)
        .kanjiSrsDao
        .getStatesForIds(kanjiIds);
    final now = DateTime.now();
    return _HanVietPracticePriority(
      activeKanjiIds: {for (final state in states) state.kanjiId},
      dueKanjiIds: {
        for (final state in states)
          if (!state.nextReviewAt.isAfter(now)) state.kanjiId,
      },
    );
  }

  List<HanVietRulePracticeItem> _prioritizePracticeItems(
    List<HanVietRulePracticeItem> items,
    _HanVietPracticePriority priority,
  ) {
    final indexed = items.indexed.toList(growable: false);
    indexed.sort((a, b) {
      final rankA = priority.rank(a.$2.kanjiId);
      final rankB = priority.rank(b.$2.kanjiId);
      if (rankA != rankB) return rankA.compareTo(rankB);
      return a.$1.compareTo(b.$1);
    });
    return indexed.map((entry) => entry.$2).toList(growable: false);
  }

  Future<void> _markRuleIfPassed(HanVietRuleV2 rule) async {
    final items = rule.practice.items;
    if (items.isEmpty) return;
    final answeredCount = items
        .where((item) => _practiceAnswers.containsKey(item.itemId))
        .length;
    if (answeredCount < items.length) return;
    final correctCount = items
        .where((item) => _practiceAnswers[item.itemId] == item.correct)
        .length;
    final threshold = (items.length * 0.8).ceil().clamp(1, 5);
    if (correctCount < threshold) return;

    final db = ref.read(databaseProvider);
    await db.hanVietRuleSrsDao.recordReview(ruleId: rule.ruleId, grade: 3);
    for (final item in items) {
      await db.kanjiSrsDao.recordReview(kanjiId: item.kanjiId, grade: 3);
    }
  }

  List<String> _sourceLabels(HanVietRule rule, HanVietRuleSet ruleSet) {
    final sources = ruleSet.sourcesById;
    return (rule.sourceIds ?? const [])
        .map((id) => sources[id]?.domain ?? id)
        .toList(growable: false);
  }
}

class _HanVietPracticePriority {
  const _HanVietPracticePriority({
    required this.activeKanjiIds,
    required this.dueKanjiIds,
  });

  static const empty = _HanVietPracticePriority(
    activeKanjiIds: {},
    dueKanjiIds: {},
  );

  final Set<int> activeKanjiIds;
  final Set<int> dueKanjiIds;

  int rank(int kanjiId) {
    if (dueKanjiIds.contains(kanjiId)) return 0;
    if (activeKanjiIds.contains(kanjiId)) return 1;
    return 2;
  }
}

class _HanVietSearchField extends StatelessWidget {
  const _HanVietSearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final SearchController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const ValueKey('han_viet_search'),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded),
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}

class _HanVietRulePracticeCard extends StatelessWidget {
  const _HanVietRulePracticeCard({
    required this.rule,
    required this.language,
    required this.answers,
    required this.items,
    required this.onAnswered,
  });

  final HanVietRuleV2 rule;
  final AppLanguage language;
  final Map<String, String> answers;
  final List<HanVietRulePracticeItem> items;
  final void Function(HanVietRulePracticeItem item, String answer) onAnswered;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final correctCount = items
        .where((item) => answers[item.itemId] == item.correct)
        .length;
    final threshold = (items.length * 0.8).ceil().clamp(1, 5);
    final understood = correctCount >= threshold;
    return Card(
      key: ValueKey('han_viet_rule_card_${rule.ruleId}'),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${rule.section}. ${rule.title}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: const Color(0xFFE25C5C),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${rule.percentage}% được chuyển sang hàng ${rule.targetRow} (${rule.targetKana.join('・')})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF168F87),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(rule.explanation),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Ví dụ:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacing.xs),
            for (final example in rule.examples)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '${example.hanViet} -> ${example.kanji} (${example.onyomi}) ${example.romaji} -> ${example.compound} (${example.compoundKana})',
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Bài tập áp dụng',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (understood)
                  Chip(
                    key: ValueKey('han_viet_rule_understood_${rule.ruleId}'),
                    label: Text(language.hanVietRuleUnderstoodLabel),
                    backgroundColor: colorScheme.primaryContainer,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final item in items)
              _HanVietPracticeQuestion(
                item: item,
                template: rule.practice.questionTemplate,
                selected: answers[item.itemId],
                onAnswered: (answer) => onAnswered(item, answer),
              ),
          ],
        ),
      ),
    );
  }
}

class _HanVietPracticeQuestion extends StatelessWidget {
  const _HanVietPracticeQuestion({
    required this.item,
    required this.template,
    required this.selected,
    required this.onAnswered,
  });

  final HanVietRulePracticeItem item;
  final String template;
  final String? selected;
  final ValueChanged<String> onAnswered;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final answered = selected != null;
    final correct = selected == item.correct;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.question(template),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in item.options)
                OutlinedButton(
                  key: ValueKey('han_viet_option_${item.itemId}_$option'),
                  onPressed: () => onAnswered(option),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selected == option
                        ? (option == item.correct
                              ? colorScheme.primaryContainer
                              : colorScheme.errorContainer)
                        : null,
                  ),
                  child: Text(option),
                ),
            ],
          ),
          if (answered) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              correct ? 'Đúng' : 'Chưa đúng',
              style: TextStyle(
                color: correct ? colorScheme.primary : colorScheme.error,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(item.explanation),
          ],
        ],
      ),
    );
  }
}

enum _HanVietCategoryFilter {
  all,
  usage,
  initial,
  finalSound,
  exception;

  bool matches(String category) {
    return switch (this) {
      _HanVietCategoryFilter.all => true,
      _HanVietCategoryFilter.usage => category == 'usage',
      _HanVietCategoryFilter.initial => category == 'initial',
      _HanVietCategoryFilter.finalSound =>
        category == 'final' || category == 'rime' || category == 'long_vowel',
      _HanVietCategoryFilter.exception => category == 'exception',
    };
  }

  String label(AppLanguage language) {
    return switch (this) {
      _HanVietCategoryFilter.all => language.filterAllLabel,
      _HanVietCategoryFilter.usage => language.hanVietCategoryUsage,
      _HanVietCategoryFilter.initial => language.hanVietCategoryInitial,
      _HanVietCategoryFilter.finalSound => language.hanVietCategoryFinal,
      _HanVietCategoryFilter.exception => language.hanVietCategoryException,
    };
  }
}

class _HanVietCategoryChips extends StatelessWidget {
  const _HanVietCategoryChips({
    required this.selected,
    required this.language,
    required this.onSelected,
  });

  final _HanVietCategoryFilter selected;
  final AppLanguage language;
  final ValueChanged<_HanVietCategoryFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final filter in _HanVietCategoryFilter.values)
          FilterChip(
            label: Text(filter.label(language)),
            selected: selected == filter,
            onSelected: (_) => onSelected(filter),
          ),
      ],
    );
  }
}

class _HanVietRuleTile extends StatelessWidget {
  const _HanVietRuleTile({
    required this.rule,
    required this.language,
    required this.sourceIds,
    required this.sourceLabel,
  });

  final HanVietRule rule;
  final AppLanguage language;
  final List<String> sourceIds;
  final String sourceLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text(rule.localizedTitle(language)),
        subtitle: Text(rule.localizedPattern(language)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          if (rule.localizedDescription(language).trim().isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(rule.localizedDescription(language)),
            ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              language.hanVietExamplesLabel,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final example in rule.examples)
                _HanVietExampleCard(example: example, language: language),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 6,
              children: [Text(sourceLabel), Text(sourceIds.join(', '))],
            ),
          ),
        ],
      ),
    );
  }
}

class _HanVietExampleCard extends StatelessWidget {
  const _HanVietExampleCard({required this.example, required this.language});

  final HanVietExample example;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 152, maxWidth: 220),
      child: Material(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showExampleDialog(context),
          key: ValueKey('han_viet_example_${example.kanji}'),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  example.kanji,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(example.hanViet),
                Text(example.onyomi),
                Text(
                  example.localizedMeaning(language),
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showExampleDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(example.kanji),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(example.hanViet),
              Text(example.onyomi),
              Text(example.localizedMeaning(language)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(language.closeLabel),
            ),
          ],
        );
      },
    );
  }
}
