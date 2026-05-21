const assert = require('node:assert/strict');
const test = require('node:test');

const {
  validateTier1Templates,
} = require('../../../tool/qa/validate_phase_g_templates');

test('validateTier1Templates accepts 10 templates with five angles and L1-L4', () => {
  const report = validateTier1Templates([
    tpl('form', 'L1', 1),
    tpl('form', 'L2', 2),
    tpl('meaning', 'L2', 3),
    tpl('meaning', 'L3', 4),
    tpl('usage', 'L3', 5),
    tpl('usage', 'L1', 6),
    tpl('context', 'L3', 7),
    tpl('context', 'L2', 8),
    tpl('contrast', 'L4', 9),
    tpl('contrast', 'L4', 10),
  ], { itemId: 'grammar:n5:grammar_n5_1:001' });

  assert.equal(report.passed, true);
  assert.deepEqual(report.failures, []);
});

test('validateTier1Templates rejects shallow template sets', () => {
  const report = validateTier1Templates([
    tpl('form', 'L1', 1),
    tpl('meaning', 'L2', 2),
    tpl('usage', 'L3', 3),
  ], { itemId: 'grammar:n5:grammar_n5_1:001' });

  assert.equal(report.passed, false);
  assert.match(report.failures.join('\n'), /templates below 10/);
  assert.match(report.failures.join('\n'), /missing angle context/);
  assert.match(report.failures.join('\n'), /missing angle contrast/);
  assert.match(report.failures.join('\n'), /missing bloom L4/);
});

function tpl(angle, bloomLevel, index) {
  return {
    template_id: `tpl-${index}`,
    item_id: 'grammar:n5:grammar_n5_1:001',
    tier: 'tier1',
    angle,
    bloom_level: bloomLevel,
    prompt_template: `prompt ${index}`,
    answer_template: `answer ${index}`,
    distractor_strategy: 'wrong-particle',
    consumerRoutes: ['/grammar-practice'],
  };
}
