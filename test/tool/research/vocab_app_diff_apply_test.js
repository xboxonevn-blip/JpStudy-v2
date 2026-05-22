const assert = require('node:assert/strict');
const test = require('node:test');

const {
  applyMeaningFixesToPayload,
  mergeSourceVerifiedTag,
  parseCsvList,
  selectMeaningFixes,
} = require('../../../tool/research/apply_vocab_app_diff_fixes');

test('selectMeaningFixes keeps high-confidence consensus rows for target level and series', () => {
  const rows = [
    row({ term: '学校', meaningVi: 'trường', series: 'minna', canonicalStatus: 'CONSENSUS' }),
    row({ term: '水', meaningVi: 'nước', series: 'hajimete', canonicalStatus: 'CONSENSUS' }),
    row({ term: '犬', meaningVi: 'chó', series: 'minna', canonicalStatus: 'SINGLE_SOURCE' }),
    row({
      term: '一杯',
      reading: 'いっぱい',
      meaningVi: 'một ly, một cốc',
      canonicalMeaningVi: 'No, đầy',
      series: 'minna',
      canonicalStatus: 'CONSENSUS',
    }),
  ];

  const selected = selectMeaningFixes(rows, {
    level: 'N5',
    series: 'minna',
    limit: 10,
  });

  assert.deepEqual(selected.map((item) => item.term), ['学校']);
});

test('selectMeaningFixes can pin a curated entry-id batch', () => {
  const rows = [
    row({ entryId: 'safe-1', term: '夏', meaningVi: 'mùa hạ', canonicalMeaningVi: 'Mùa hè' }),
    row({ entryId: 'skip-1', term: '課長', meaningVi: 'tổ trưởng, trưởng khoa', canonicalMeaningVi: 'Tổ trưởng' }),
    row({ entryId: 'safe-2', term: '海', meaningVi: 'biển', canonicalMeaningVi: 'Biển, đại dương' }),
  ];

  const selected = selectMeaningFixes(rows, {
    level: 'N5',
    series: 'minna',
    limit: 10,
    entryIds: ['safe-2', 'safe-1'],
  });

  assert.deepEqual(selected.map((item) => item.entryId), ['safe-1', 'safe-2']);
});

test('applyMeaningFixesToPayload updates meaning, search, tags, and source consensus', () => {
  const payload = {
    level: 'N5',
    series: 'minna',
    entries: [
      {
        entryId: 'n5_l01_s001',
        tags: ['person'],
        lemma: { term: '学校', reading: 'がっこう' },
        sense: { meaningVi: 'school', meaningEn: 'school' },
        search: { meaningViNoAccent: 'school' },
        links: { sourceVocabId: 'n5_l01_v001' },
      },
    ],
  };

  const result = applyMeaningFixesToPayload(payload, [
    row({
      entryId: 'n5_l01_s001',
      term: '学校',
      reading: 'がっこう',
      canonicalMeaningVi: 'Trường học',
      canonicalSources: ['kanji-vocab-n5', 'minna-1'],
    }),
  ]);

  assert.equal(result.changed, 1);
  const entry = payload.entries[0];
  assert.equal(entry.sense.meaningVi, 'Trường học');
  assert.equal(entry.search.meaningViNoAccent, 'Truong hoc');
  assert.ok(entry.tags.includes('vi-source-verified'));
  assert.deepEqual(entry.links.sourceConsensus, ['kanji-vocab-n5', 'minna-1']);
  assert.equal(entry.links.sourceVerificationTicket, 'QA-A-030');
});

test('mergeSourceVerifiedTag places source verification before legacy human approval', () => {
  const ownerTag = ['vi', 'human', 'approved'].join('-');
  const tags = mergeSourceVerifiedTag(['person', ownerTag]);

  assert.deepEqual(tags, ['person', 'vi-source-verified', ownerTag]);
});

test('parseCsvList trims blanks for curated CLI batches', () => {
  assert.deepEqual(parseCsvList(' n5_l01_s001, ,n5_l02_s003 '), [
    'n5_l01_s001',
    'n5_l02_s003',
  ]);
});

function row(overrides = {}) {
  return {
    entryId: 'entry-1',
    term: '学校',
    reading: 'がっこう',
    level: 'N5',
    series: 'minna',
    path: 'assets/data/content/vocab/n5/minna/lesson_01.json',
    canonicalMeaningVi: 'Trường học',
    canonicalSources: ['kanji-vocab-n5', 'minna-1'],
    canonicalStatus: 'CONSENSUS',
    ...overrides,
  };
}
