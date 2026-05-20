const assert = require('node:assert/strict');
const test = require('node:test');

const {
  buildMasterMapping,
  parseCanonicalMarkdown,
} = require('../../../tool/research/build_kanji_master_mapping');

test('parseCanonicalMarkdown reads entry headings and open gaps', () => {
  const entries = parseCanonicalMarkdown(
    `
# Canonical Kanji N4

### 海 (Hải)

level: N4
meaningVi: Biển
hanViet: Hải
openGaps:
  - target uncertain
examples:
  - none
`,
    'N4',
    'kanji-n4.md',
  );

  assert.equal(entries.length, 1);
  assert.equal(entries[0].kanji, '海');
  assert.equal(entries[0].hanViet, 'Hải');
  assert.equal(entries[0].meaningVi, 'Biển');
  assert.deepEqual(entries[0].openGaps, ['target uncertain']);
});

test('buildMasterMapping keeps lowest JLPT level for duplicates', () => {
  const result = buildMasterMapping([
    { kanji: '親', level: 'N4', hanViet: 'Thân', meaningVi: 'cha mẹ', openGaps: [] },
    { kanji: '親', level: 'N2', hanViet: 'Thân', meaningVi: 'thân', openGaps: [] },
  ], { hardOverrides: {} });

  assert.equal(result.kanjiToLevel['親'], 'N4');
  assert.equal(result.entries['親'].selectedReason, 'lowest_level_wins');
  assert.equal(result.openQuestions[0].issue, 'cross_level_duplicate');
});

test('buildMasterMapping applies owner hard overrides and adds missing override kanji', () => {
  const result = buildMasterMapping([
    { kanji: '海', level: 'N4', hanViet: 'Hải', meaningVi: 'biển', openGaps: [] },
    { kanji: '海', level: 'N3', hanViet: 'Hải', meaningVi: 'biển', openGaps: [] },
    { kanji: '銀', level: 'N4', hanViet: 'Ngân', meaningVi: 'bạc', openGaps: [] },
  ], {
    hardOverrides: {
      海: { level: 'N5', reason: 'owner spot-check' },
      銀: { level: 'N3', reason: 'owner spot-check' },
      議: { level: 'N2', reason: 'owner spot-check' },
    },
  });

  assert.equal(result.kanjiToLevel['海'], 'N5');
  assert.equal(result.kanjiToLevel['銀'], 'N3');
  assert.equal(result.kanjiToLevel['議'], 'N2');
  assert.equal(result.entries['議'].selectedReason, 'owner_hard_override_missing_from_extraction');
  assert.ok(result.openQuestions.some((item) => item.kanji === '海' && item.issue === 'cross_level_duplicate' && item.selectedLevel === 'N5'));
  assert.ok(result.openQuestions.some((item) => item.kanji === '海' && item.issue === 'owner_hard_override_conflict'));
  assert.ok(result.openQuestions.some((item) => item.kanji === '議' && item.issue === 'owner_hard_override_missing'));
});
