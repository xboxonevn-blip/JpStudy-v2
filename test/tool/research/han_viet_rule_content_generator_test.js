const assert = require('node:assert/strict');
const test = require('node:test');

const {
  generateHanVietRulesV2,
} = require('../../../tool/research/generate_han_viet_rule_content');

test('generates rule 1 examples and practice from local kanji assets', () => {
  const payload = generateHanVietRulesV2({ rootDir: process.cwd() });

  assert.equal(payload.schemaVersion, 2);
  assert.equal(payload.dataset, 'han_viet_on_rules_v2');

  const raw = JSON.stringify(payload);
  assert.equal(raw.includes('nhaikanji.com'), false);
  assert.equal(raw.includes('thocodehoctiengnhat.com'), false);

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
});
