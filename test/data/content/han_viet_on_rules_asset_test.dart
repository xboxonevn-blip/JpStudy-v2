import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final rulesAsset = File('assets/data/content/kanji/han_viet_on_rules.json');
  final rulesV2Asset = File(
    'assets/data/content/kanji/han_viet_on_rules_v2.json',
  );

  Map<String, dynamic> loadRulesAsset() {
    return jsonDecode(rulesAsset.readAsStringSync()) as Map<String, dynamic>;
  }

  test('han viet to on-yomi rules asset has sourced heuristic rules', () {
    final asset = loadRulesAsset();

    expect(asset['schemaVersion'], 1);
    expect(asset['dataset'], 'han_viet_on_rules');
    expect(asset['scope'], contains('heuristic'));

    final sources = asset['sources'] as List<dynamic>;
    expect(sources, hasLength(greaterThanOrEqualTo(5)));
    expect(
      sources.map((source) => source['domain']),
      containsAll(<String>[
        'saromalang.com',
        'tiengnhatmoingay.com',
        'tailieuhoctiengnhat.com',
        'kosei.vn',
        'tuhoctiengnhat.vn',
      ]),
    );

    final rules = asset['rules'] as List<dynamic>;
    expect(rules, hasLength(greaterThanOrEqualTo(24)));
    expect(
      rules.map((rule) => rule['category']),
      containsAll(<String>[
        'usage',
        'initial',
        'rime',
        'final',
        'long_vowel',
        'exception',
      ]),
    );

    for (final rule in rules.cast<Map<String, dynamic>>()) {
      expect(rule['id'], isA<String>());
      expect(rule['pattern'], isA<String>());
      expect(rule['patternHv'], isA<String>());
      expect((rule['patternHv'] as String).trim(), isNotEmpty);
      expect(rule['patternJp'], isA<String>());
      expect((rule['patternJp'] as String).trim(), isNotEmpty);
      expect(rule['titleVi'], isA<String>());
      expect((rule['titleVi'] as String).trim(), isNotEmpty);
      expect(rule['titleEn'], isA<String>());
      expect((rule['titleEn'] as String).trim(), isNotEmpty);
      expect(rule['descriptionVi'], isA<String>());
      expect((rule['descriptionVi'] as String).trim(), isNotEmpty);
      expect(rule['descriptionEn'], isA<String>());
      expect((rule['descriptionEn'] as String).trim(), isNotEmpty);
      expect(rule['onHint'], isA<List<dynamic>>());
      expect(rule['confidence'], isA<num>());
      expect(rule['sourceIds'], isA<List<dynamic>>());
      expect(rule['examples'], isA<List<dynamic>>());
      for (final example
          in (rule['examples'] as List<dynamic>).cast<Map<String, dynamic>>()) {
        expect(example['kanji'], isA<String>());
        expect((example['kanji'] as String).trim(), isNotEmpty);
        expect(example['hanViet'], isA<String>());
        expect((example['hanViet'] as String).trim(), isNotEmpty);
        expect(example['on'], isA<String>());
        expect((example['on'] as String).trim(), isNotEmpty);
        expect(example['meaningVi'], isA<String>());
        expect((example['meaningVi'] as String).trim(), isNotEmpty);
      }
    }
  });

  test('han viet to on-yomi rules cover common learner mappings', () {
    final asset = loadRulesAsset();
    final rules = (asset['rules'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    Map<String, dynamic> byId(String id) =>
        rules.singleWhere((rule) => rule['id'] == id);

    expect(byId('initial-l-to-r')['examples'], isNotEmpty);
    expect(byId('initial-c-k-kh-gi-h-qu-to-k')['onHint'], contains('k'));
    expect(byId('initial-b-ph-to-h-f')['onHint'], contains('h'));
    expect(byId('final-n-m-to-n')['onHint'], contains('n'));
    expect(byId('final-t-to-tsu-chi')['onHint'], contains('tsu'));
    expect(byId('final-p-to-long-or-tsu')['examples'], isNotEmpty);
    expect(byId('rime-inh-anh-enh-to-ei')['onHint'], contains('ei'));
    expect(byId('usage-kanji-compounds-often-use-on')['examples'], isNotEmpty);
  });

  test('localized han viet rule examples include learner-facing glosses', () {
    final asset = loadRulesAsset();
    final rules = (asset['rules'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final initialL = rules.singleWhere(
      (rule) => rule['id'] == 'initial-l-to-r',
    );

    expect(initialL['titleVi'], 'Phụ âm đầu L → R');
    expect(initialL['titleEn'], 'Initial L → R');
    expect(initialL['descriptionVi'], contains('hàng R'));
    expect(initialL['patternHv'], 'L');
    expect(initialL['patternJp'], 'r');

    final examples = (initialL['examples'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    expect(
      examples,
      contains(
        allOf(
          containsPair('kanji', '来'),
          containsPair('hanViet', 'lai'),
          containsPair('on', 'ライ (rai)'),
          containsPair('meaningVi', 'đến'),
        ),
      ),
    );
  });

  test(
    'han viet to on-yomi rules are registered and avoid blocked sources',
    () {
      final raw = rulesAsset.readAsStringSync();
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final index =
          jsonDecode(File('assets/data/content/index.json').readAsStringSync())
              as Map<String, dynamic>;

      expect(pubspec, contains('assets/data/content/kanji/'));
      expect(index['datasets'], contains('hanVietOnRules'));
      expect(raw, isNot(contains('thocodehoctiengnhat.com')));
      expect(raw, isNot(contains('nhaikanji.com')));
    },
  );

  test('han viet v2 rules include all thirty-two reference practice cards', () {
    final asset =
        jsonDecode(rulesV2Asset.readAsStringSync()) as Map<String, dynamic>;

    expect(asset['schemaVersion'], 2);
    expect(asset['dataset'], 'han_viet_on_rules_v2');

    final raw = rulesV2Asset.readAsStringSync();
    expect(raw, isNot(contains('thocodehoctiengnhat.com')));
    expect(raw, isNot(contains('nhaikanji.com')));

    final rules = (asset['rules'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    expect(rules, hasLength(32));
    expect(
      rules.map((rule) => rule['ruleId']),
      containsAll(<String>[
        'rule_initial_h_k_gi_c_qu_to_k',
        'rule_initial_t_th_to_t_s_sh',
        'rule_initial_ng_ngh_to_g_gy',
        'rule_initial_l_to_r',
        'rule_initial_n_nh_to_n_j_ny',
        'rule_initial_m_to_m',
        'rule_initial_b_ph_to_h_f_b',
        'rule_initial_d_gi_to_y',
        'rule_initial_ch_tr_to_sh_ch',
        'rule_initial_s_x_to_s_sh',
        'rule_initial_d_with_stroke_to_t_d',
        'rule_initial_v_to_b_m_vowel',
        'rule_final_n_m_to_n',
        'rule_final_c_to_ku',
        'rule_final_t_to_tsu_chi',
        'rule_final_p_to_long_or_tsu',
        'rule_final_ch_to_ku_ki',
        'rule_rime_inh_anh_enh_to_ei',
        'rule_rime_ien_iem_yen_to_en',
        'rule_rime_ong_ung_uong_to_ou_uu',
        'rule_rime_ac_uoc_to_aku_yaku',
        'rule_rime_ich_to_eki_seki',
        'rule_rime_uu_ieu_yeu_to_yuu_you',
        'rule_long_vowel_ou_from_ang_ong',
        'rule_long_vowel_ei_from_inh_anh',
        'rule_exception_onbin_gemination',
        'rule_exception_kun_mixed_readings',
        'rule_exception_word_level_han_viet',
        'rule_exception_check_dictionary_before_drill',
        'rule_usage_kanji_compounds_use_on',
        'rule_usage_han_viet_is_heuristic',
        'rule_usage_multiple_on_readings',
      ]),
    );
    final rule = rules.singleWhere(
      (item) => item['ruleId'] == 'rule_initial_h_k_gi_c_qu_to_k',
    );
    expect(rule['legacyId'], 'initial-c-k-kh-gi-h-qu-to-k');
    expect(rule['consonants'], ['H', 'K', 'Gi', 'C', 'Qu']);
    expect(rule['targetKana'], containsAll(['か', 'が']));
    expect(rule['examples'], hasLength(greaterThanOrEqualTo(4)));

    final practice = rule['practice'] as Map<String, dynamic>;
    expect(practice['status'], 'ready');
    final items = (practice['items'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    expect(items, hasLength(5));
    for (final item in items) {
      final options = (item['options'] as List<dynamic>).cast<String>();
      expect(options, hasLength(4));
      expect(options.toSet(), hasLength(4));
      expect(options, contains(item['correct']));
    }

    for (final generatedRule in rules) {
      expect(generatedRule['examples'], hasLength(greaterThanOrEqualTo(4)));
      final generatedPractice =
          generatedRule['practice'] as Map<String, dynamic>;
      expect(generatedPractice['status'], 'ready');
      final generatedItems = (generatedPractice['items'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      expect(generatedItems, hasLength(5));
      for (final item in generatedItems) {
        final options = (item['options'] as List<dynamic>).cast<String>();
        expect(options, hasLength(4));
        expect(options.toSet(), hasLength(4));
        expect(options, contains(item['correct']));
      }
    }

    final index =
        jsonDecode(File('assets/data/content/index.json').readAsStringSync())
            as Map<String, dynamic>;
    final datasets = index['datasets'] as Map<String, dynamic>;
    expect(datasets, contains('hanVietOnRulesV2'));
    expect(datasets['hanVietOnRulesV2'], containsPair('rules', 32));
  });
}
