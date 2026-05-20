import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/features/foundations/services/foundations_content_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads kana chart with expected imported counts', () async {
    final service = FoundationsContentService();

    final chart = await service.loadKanaChart();

    expect(chart.hiragana.entries, hasLength(71));
    expect(chart.hiragana.compounds, hasLength(33));
    expect(chart.katakana.entries, hasLength(71));
    expect(chart.katakana.compounds, hasLength(33));
  });

  test('loads han viet rules with citations', () async {
    final service = FoundationsContentService();

    final ruleSet = await service.loadHanVietRules();

    expect(ruleSet.rules, hasLength(32));
    expect(ruleSet.sources, hasLength(5));
    expect(ruleSet.rules.first.examples, isNotEmpty);
  });

  test('loads han viet v2 rules with practice items', () async {
    final service = FoundationsContentService();

    final ruleSet = await service.loadHanVietRulesV2();

    expect(ruleSet.rules, hasLength(32));
    final rule = ruleSet.rules.first;
    expect(rule.ruleId, 'rule_initial_h_k_gi_c_qu_to_k');
    expect(rule.legacyId, 'initial-c-k-kh-gi-h-qu-to-k');
    expect(rule.consonants, ['H', 'K', 'Gi', 'C', 'Qu']);
    expect(rule.targetKana, containsAll(['か', 'が']));
    expect(rule.examples, hasLength(greaterThanOrEqualTo(4)));
    expect(rule.practice.items, hasLength(5));
    expect(rule.practice.items.first.options, hasLength(4));
  });
}
