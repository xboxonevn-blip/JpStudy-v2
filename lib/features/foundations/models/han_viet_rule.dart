import 'package:jpstudy/core/app_language.dart';

class HanVietRule {
  const HanVietRule({
    required this.id,
    required this.category,
    required this.titleVi,
    required this.titleEn,
    required this.pattern,
    required this.patternHv,
    required this.patternJp,
    required this.descriptionVi,
    required this.descriptionEn,
    required this.confidence,
    required this.examples,
    this.sourceIds,
  });

  final String id;
  final String category;
  final String titleVi;
  final String titleEn;
  final String pattern;
  final String patternHv;
  final String patternJp;
  final String descriptionVi;
  final String descriptionEn;
  final double confidence;
  final List<HanVietExample> examples;
  final List<String>? sourceIds;

  String get title => titleEn;
  String? get explanation =>
      descriptionEn.trim().isEmpty ? null : descriptionEn;

  String localizedTitle(AppLanguage language) {
    final primary = switch (language) {
      AppLanguage.vi => titleVi,
      AppLanguage.en || AppLanguage.ja => titleEn,
    };
    if (primary.trim().isNotEmpty) return primary;
    return titleEn.trim().isNotEmpty ? titleEn : _titleFromJson({'id': id});
  }

  String localizedDescription(AppLanguage language) {
    final primary = switch (language) {
      AppLanguage.vi => descriptionVi,
      AppLanguage.en || AppLanguage.ja => descriptionEn,
    };
    if (primary.trim().isNotEmpty) return primary;
    if (descriptionVi.trim().isNotEmpty) return descriptionVi;
    return pattern;
  }

  String localizedPattern(AppLanguage language) {
    if (patternHv.trim().isNotEmpty && patternJp.trim().isNotEmpty) {
      return '$patternHv \u2192 $patternJp';
    }
    return pattern;
  }

  String searchableText(AppLanguage language) {
    return [
      id,
      category,
      titleVi,
      titleEn,
      pattern,
      patternHv,
      patternJp,
      descriptionVi,
      descriptionEn,
      for (final example in examples) example.searchableText(language),
    ].join(' ').toLowerCase();
  }

  factory HanVietRule.fromJson(Map<String, dynamic> json) {
    final examples = json['examples'] as List<dynamic>? ?? const [];
    final sourceIds = json['sourceIds'] as List<dynamic>?;
    final titleEn = _readString(json, const ['titleEn', 'title_en', 'title']);
    final titleVi = _readString(json, const ['titleVi', 'title_vi']);
    final descriptionVi = _readString(json, const [
      'descriptionVi',
      'description_vi',
      'noteVi',
    ]);
    final descriptionEn = _readString(json, const [
      'descriptionEn',
      'description_en',
      'explanation',
      'pattern',
    ]);
    final confidence = json['confidence'];
    return HanVietRule(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? '',
      titleVi: titleVi.isEmpty ? _titleFromJson(json) : titleVi,
      titleEn: titleEn.isEmpty ? _titleFromJson(json) : titleEn,
      pattern: json['pattern'] as String? ?? '',
      patternHv: _readString(json, const ['patternHv', 'pattern_hv']),
      patternJp: _readString(json, const ['patternJp', 'pattern_jp']),
      descriptionVi: descriptionVi,
      descriptionEn: descriptionEn,
      confidence: confidence is num ? confidence.toDouble() : 0,
      examples: examples
          .cast<Map<String, dynamic>>()
          .map(HanVietExample.fromJson)
          .toList(growable: false),
      sourceIds: sourceIds?.map((value) => value.toString()).toList(),
    );
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }

  static String _titleFromJson(Map<String, dynamic> json) {
    final id = (json['id'] as String? ?? '').trim();
    final onHints = json['onHint'] as List<dynamic>? ?? const [];
    final hint = onHints.map((value) => value.toString()).join('/');
    if (id.isEmpty) {
      return hint.isEmpty ? 'Han-Viet rule' : 'Han-Viet -> $hint';
    }
    final compact = id
        .replaceAll('initial-', 'Initial ')
        .replaceAll('final-', 'Final ')
        .replaceAll('rime-', 'Rime ')
        .replaceAll('long-vowel-', 'Long vowel ')
        .replaceAll('usage-', 'Usage ')
        .replaceAll('exception-', 'Exception ')
        .replaceAll('-', ' -> ');
    return hint.isEmpty ? compact : '$compact ($hint)';
  }
}

class HanVietExample {
  const HanVietExample({
    required this.kanji,
    required this.onyomi,
    required this.hanViet,
    required this.meaningVi,
    this.meaningEn,
  });

  final String kanji;
  final String onyomi;
  final String hanViet;
  final String meaningVi;
  final String? meaningEn;

  String get meaning =>
      meaningVi.trim().isNotEmpty ? meaningVi : meaningEn ?? '';

  String localizedMeaning(AppLanguage language) {
    if (language == AppLanguage.vi && meaningVi.trim().isNotEmpty) {
      return meaningVi;
    }
    return meaningEn?.trim().isNotEmpty == true ? meaningEn! : meaning;
  }

  String searchableText(AppLanguage language) {
    return [
      kanji,
      onyomi,
      hanViet,
      meaningVi,
      meaningEn ?? '',
    ].join(' ').toLowerCase();
  }

  factory HanVietExample.fromJson(Map<String, dynamic> json) {
    final kana = json['kana'] as String? ?? '';
    final romaji = json['romaji'] as String? ?? '';
    final on = json['on'] as String?;
    return HanVietExample(
      kanji: json['kanji'] as String? ?? '',
      onyomi: on ?? json['onyomi'] as String? ?? _formatOn(kana, romaji),
      hanViet: json['hanViet'] as String? ?? '',
      meaningVi:
          json['meaningVi'] as String? ??
          json['meaning_vi'] as String? ??
          json['meaning'] as String? ??
          '',
      meaningEn: json['meaningEn'] as String? ?? json['meaning_en'] as String?,
    );
  }

  static String _formatOn(String kana, String romaji) {
    if (kana.isEmpty) return romaji;
    if (romaji.isEmpty) return kana;
    return '$kana ($romaji)';
  }
}

class HanVietSource {
  const HanVietSource({required this.id, required this.title, this.domain});

  final String id;
  final String title;
  final String? domain;

  factory HanVietSource.fromJson(Map<String, dynamic> json) {
    return HanVietSource(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      domain: json['domain'] as String?,
    );
  }
}

class HanVietRuleSet {
  const HanVietRuleSet({required this.rules, required this.sources});

  final List<HanVietRule> rules;
  final List<HanVietSource> sources;

  Map<String, HanVietSource> get sourcesById => {
    for (final source in sources) source.id: source,
  };

  factory HanVietRuleSet.fromJson(Map<String, dynamic> json) {
    final rules = json['rules'] as List<dynamic>? ?? const [];
    final sources = json['sources'] as List<dynamic>? ?? const [];
    return HanVietRuleSet(
      rules: rules
          .cast<Map<String, dynamic>>()
          .map(HanVietRule.fromJson)
          .toList(growable: false),
      sources: sources
          .cast<Map<String, dynamic>>()
          .map(HanVietSource.fromJson)
          .toList(growable: false),
    );
  }
}

class HanVietRuleSetV2 {
  const HanVietRuleSetV2({required this.rules});

  final List<HanVietRuleV2> rules;

  factory HanVietRuleSetV2.fromJson(Map<String, dynamic> json) {
    final rules = json['rules'] as List<dynamic>? ?? const [];
    return HanVietRuleSetV2(
      rules: rules
          .cast<Map<String, dynamic>>()
          .map(HanVietRuleV2.fromJson)
          .toList(growable: false),
    );
  }
}

class HanVietRuleV2 {
  const HanVietRuleV2({
    required this.ruleId,
    required this.legacyId,
    required this.section,
    required this.category,
    required this.title,
    required this.consonants,
    required this.targetRow,
    required this.targetKana,
    required this.percentage,
    required this.explanation,
    required this.examples,
    required this.practice,
  });

  final String ruleId;
  final String legacyId;
  final String section;
  final String category;
  final String title;
  final List<String> consonants;
  final String targetRow;
  final List<String> targetKana;
  final int percentage;
  final String explanation;
  final List<HanVietRuleExampleV2> examples;
  final HanVietRulePractice practice;

  String searchableText() {
    return [
      ruleId,
      legacyId,
      section,
      category,
      title,
      targetRow,
      targetKana.join(' '),
      consonants.join(' '),
      explanation,
      for (final example in examples)
        '${example.hanViet} ${example.kanji} ${example.onyomi} ${example.compound}',
    ].join(' ').toLowerCase();
  }

  factory HanVietRuleV2.fromJson(Map<String, dynamic> json) {
    List<String> readStringList(String key) {
      final raw = json[key];
      if (raw is! List) return const [];
      return raw
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false);
    }

    final examples = json['examples'] as List<dynamic>? ?? const [];
    return HanVietRuleV2(
      ruleId: _readText(json, 'ruleId'),
      legacyId: _readText(json, 'legacyId'),
      section: _readText(json, 'section'),
      category: _readText(json, 'category'),
      title: _readText(json, 'title'),
      consonants: readStringList('consonants'),
      targetRow: _readText(json, 'targetRow'),
      targetKana: readStringList('targetKana'),
      percentage: (json['percentage'] as num?)?.toInt() ?? 0,
      explanation: _readText(json, 'explanation'),
      examples: examples
          .cast<Map<String, dynamic>>()
          .map(HanVietRuleExampleV2.fromJson)
          .toList(growable: false),
      practice: HanVietRulePractice.fromJson(
        json['practice'] is Map<String, dynamic>
            ? json['practice'] as Map<String, dynamic>
            : const {},
      ),
    );
  }
}

class HanVietRuleExampleV2 {
  const HanVietRuleExampleV2({
    required this.hanViet,
    required this.kanji,
    required this.kanjiId,
    required this.assetKanjiId,
    required this.level,
    required this.onyomi,
    required this.romaji,
    required this.compound,
    required this.compoundKana,
    required this.compoundMeaning,
  });

  final String hanViet;
  final String kanji;
  final int kanjiId;
  final String assetKanjiId;
  final String level;
  final String onyomi;
  final String romaji;
  final String compound;
  final String compoundKana;
  final String compoundMeaning;

  factory HanVietRuleExampleV2.fromJson(Map<String, dynamic> json) {
    return HanVietRuleExampleV2(
      hanViet: _readText(json, 'hanViet'),
      kanji: _readText(json, 'kanji'),
      kanjiId: (json['kanjiId'] as num?)?.toInt() ?? 0,
      assetKanjiId: _readText(json, 'assetKanjiId'),
      level: _readText(json, 'level'),
      onyomi: _readText(json, 'onyomi'),
      romaji: _readText(json, 'romaji'),
      compound: _readText(json, 'compound'),
      compoundKana: _readText(json, 'compoundKana'),
      compoundMeaning: _readText(json, 'compoundMeaning'),
    );
  }
}

class HanVietRulePractice {
  const HanVietRulePractice({
    required this.count,
    required this.questionTemplate,
    required this.status,
    required this.items,
  });

  final int count;
  final String questionTemplate;
  final String status;
  final List<HanVietRulePracticeItem> items;

  bool get isReady => status == 'ready' && items.isNotEmpty;

  factory HanVietRulePractice.fromJson(Map<String, dynamic> json) {
    final items = json['items'] as List<dynamic>? ?? const [];
    return HanVietRulePractice(
      count: (json['count'] as num?)?.toInt() ?? 0,
      questionTemplate: _readText(json, 'questionTemplate'),
      status: _readText(json, 'status'),
      items: items
          .cast<Map<String, dynamic>>()
          .map(HanVietRulePracticeItem.fromJson)
          .toList(growable: false),
    );
  }
}

class HanVietRulePracticeItem {
  const HanVietRulePracticeItem({
    required this.itemId,
    required this.kanji,
    required this.kanjiId,
    required this.assetKanjiId,
    required this.hanViet,
    required this.correct,
    required this.options,
    required this.explanation,
  });

  final String itemId;
  final String kanji;
  final int kanjiId;
  final String assetKanjiId;
  final String hanViet;
  final String correct;
  final List<String> options;
  final String explanation;

  String question(String template) {
    return template
        .replaceAll('{hanViet}', hanViet)
        .replaceAll('{kanji}', kanji);
  }

  factory HanVietRulePracticeItem.fromJson(Map<String, dynamic> json) {
    final options = json['options'] as List<dynamic>? ?? const [];
    return HanVietRulePracticeItem(
      itemId: _readText(json, 'itemId'),
      kanji: _readText(json, 'kanji'),
      kanjiId: (json['kanjiId'] as num?)?.toInt() ?? 0,
      assetKanjiId: _readText(json, 'assetKanjiId'),
      hanViet: _readText(json, 'hanViet'),
      correct: _readText(json, 'correct'),
      options: options
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
      explanation: _readText(json, 'explanation'),
    );
  }
}

String _readText(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return '';
  return value.toString().trim();
}
