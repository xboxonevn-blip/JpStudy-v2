import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:jpstudy/features/foundations/models/han_viet_rule.dart';
import 'package:jpstudy/features/foundations/models/kana_entry.dart';

class FoundationsContentService {
  Future<KanaChart>? _kanaChartFuture;
  Future<HanVietRuleSet>? _hanVietRuleSetFuture;
  Future<HanVietRuleSetV2>? _hanVietRuleSetV2Future;

  Future<KanaChart> loadKanaChart() {
    return _kanaChartFuture ??= _loadKanaChart();
  }

  Future<HanVietRuleSet> loadHanVietRules() {
    return _hanVietRuleSetFuture ??= _loadHanVietRules();
  }

  Future<HanVietRuleSetV2> loadHanVietRulesV2() {
    return _hanVietRuleSetV2Future ??= _loadHanVietRulesV2();
  }

  Future<KanaChart> _loadKanaChart() async {
    final raw = await rootBundle.loadString(
      'assets/data/content/kana/kana_chart.json',
    );
    return KanaChart.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<HanVietRuleSet> _loadHanVietRules() async {
    final raw = await rootBundle.loadString(
      'assets/data/content/kanji/han_viet_on_rules.json',
    );
    return HanVietRuleSet.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<HanVietRuleSetV2> _loadHanVietRulesV2() async {
    final raw = await rootBundle.loadString(
      'assets/data/content/kanji/han_viet_on_rules_v2.json',
    );
    return HanVietRuleSetV2.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
