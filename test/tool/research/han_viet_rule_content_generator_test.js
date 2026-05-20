const assert = require('node:assert/strict');
const test = require('node:test');

const {
  generateHanVietRulesV2,
  firstConsonant,
} = require('../../../tool/research/generate_han_viet_rule_content');

test('distinguishes Vietnamese D from Đ when matching initial rules', () => {
  assert.equal(firstConsonant('Dụng'), 'd');
  assert.equal(firstConsonant('Đại'), 'đ');
  assert.equal(firstConsonant('Giải'), 'gi');
});

test('generates first thirty rule cards with examples and practice from local kanji assets', () => {
  const payload = generateHanVietRulesV2({ rootDir: process.cwd() });

  assert.equal(payload.schemaVersion, 2);
  assert.equal(payload.dataset, 'han_viet_on_rules_v2');

  const raw = JSON.stringify(payload);
  assert.equal(raw.includes('nhaikanji.com'), false);
  assert.equal(raw.includes('thocodehoctiengnhat.com'), false);

  assert.equal(payload.rules.length, 30);
  assert.deepEqual(payload.rules.map((item) => item.ruleId), [
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
  ]);

  const rule = payload.rules.find(
    (item) => item.ruleId === 'rule_initial_h_k_gi_c_qu_to_k',
  );
  assert.ok(rule, 'rule 1 is generated');
  assert.equal(rule.legacyId, 'initial-c-k-kh-gi-h-qu-to-k');
  assert.deepEqual(rule.consonants, ['H', 'K', 'Gi', 'C', 'Qu']);
  assert.ok(rule.targetKana.includes('か'));
  assert.ok(rule.targetKana.includes('が'));
  assert.ok(rule.examples.length >= 4, 'rule 1 has enough examples');
  assert.equal(rule.practice.count, 5);
  assert.equal(rule.practice.items.length, 5);

  const exampleChars = new Set(rule.examples.map((item) => item.kanji));
  assert.ok(exampleChars.has('学') || exampleChars.has('校'));

  for (const item of rule.practice.items) {
    assert.equal(item.options.length, 4);
    assert.equal(new Set(item.options).size, 4);
    assert.ok(item.options.includes(item.correct));
    assert.ok(item.kanjiId > 0);
    assert.match(item.explanation, /Hán-Việt|hàng/);
  }

  for (const generatedRule of payload.rules) {
    assert.ok(generatedRule.examples.length >= 4, `${generatedRule.ruleId} has examples`);
    assert.equal(generatedRule.practice.count, 5);
    assert.equal(generatedRule.practice.items.length, 5);
    assert.equal(generatedRule.practice.status, 'ready');
    for (const item of generatedRule.practice.items) {
      assert.equal(item.options.length, 4);
      assert.equal(new Set(item.options).size, 4);
      assert.ok(item.options.includes(item.correct));
    }
  }
});
