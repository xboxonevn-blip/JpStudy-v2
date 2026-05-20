const assert = require('node:assert/strict');
const test = require('node:test');

const {
  buildAudit,
  buildKanjiAssetEntry,
  splitIntoLessonBuckets,
} = require('../../../tool/research/apply_kanji_master_mapping');

test('buildAudit classifies moves, duplicates, missing, and extras', () => {
  const audit = buildAudit(
    {
      kanjiToLevel: { 海: 'N5', 親: 'N4', 議: 'N2' },
      entries: {
        海: { level: 'N5' },
        親: { level: 'N4' },
        議: { level: 'N2' },
      },
    },
    [
      { character: '海', level: 'N4', lessonId: 3 },
      { character: '親', level: 'N2', lessonId: 24 },
      { character: '親', level: 'N5', lessonId: 23 },
      { character: '外', level: 'N1', lessonId: 1 },
    ],
  );

  assert.equal(audit.moves.length, 2);
  assert.equal(audit.duplicates.length, 1);
  assert.equal(audit.missing.length, 1);
  assert.equal(audit.extras.length, 1);
  assert.equal(audit.moves.find((row) => row.kanji === '海').toLevel, 'N5');
  assert.equal(audit.missing[0].kanji, '議');
  assert.equal(audit.extras[0].kanji, '外');
});

test('buildKanjiAssetEntry preserves existing metadata while replacing unsafe approval tag', () => {
  const entry = buildKanjiAssetEntry({
    kanji: '親',
    level: 'N4',
    lessonId: 7,
    indexInLesson: 2,
    existing: {
      kanjiId: 'old',
      lessonId: 24,
      level: 'N2',
      character: '親',
      strokeCount: 16,
      labels: { hanViet: 'Thân', meaningVi: 'cha mẹ', meaningEn: 'parent' },
      readings: { onyomi: ['シン'], kunyomi: ['おや'] },
      mnemonic: { vi: 'existing mnemonic' },
      decomposition: { hanViet: 'Thân', structure: 'left-right', components: ['立', '見'], componentNames: [], relatedKanji: ['新'] },
      search: { hanVietNoAccent: 'than' },
      examples: [{ word: '親', reading: 'おや', meaningVi: 'cha mẹ' }],
      legacy: { meaning: 'Thân (cha mẹ)' },
      tags: ['vi-human-approved', 'old-tag'],
    },
    canonical: { hanViet: 'Thân', meaningVi: 'cha mẹ' },
    kanjidic: { vietnam: ['Thân'], meanings: ['parent'], onyomi: ['シン'], kunyomi: ['おや'], strokeCount: 16 },
    unihanVietnamese: 'thân',
  });

  assert.equal(entry.kanjiId, 'n4_canonical_l07_k002');
  assert.equal(entry.level, 'N4');
  assert.equal(entry.lessonId, 7);
  assert.equal(entry.labels.hanViet, 'Thân');
  assert.equal(entry.decomposition.hanViet, 'Thân');
  assert.ok(entry.tags.includes('vi-source-verified'));
  assert.ok(entry.tags.includes('source-kanji-canonical-ebook'));
  assert.ok(!entry.tags.includes('vi-human-approved'));
});

test('buildKanjiAssetEntry prefers KANJIDIC readings and Han-Viet over OCR noise', () => {
  const entry = buildKanjiAssetEntry({
    kanji: '火',
    level: 'N5',
    lessonId: 8,
    indexInLesson: 1,
    existing: {
      labels: { hanViet: 'Ou', meaningVi: 'fire; feu; fuego' },
      readings: { onyomi: ['ハバ'], kunyomi: ['ほ'] },
      tags: ['vi-source-verified'],
    },
    canonical: {
      hanViet: 'Ou',
      meaningVi: 'fire; feu; fuego',
      onyomi: ['ハバ'],
      kunyomi: ['ほ'],
    },
    kanjidic: {
      vietnam: ['Hỏa'],
      meanings: ['fire'],
      onyomi: ['カ'],
      kunyomi: ['ひ', '-び', 'ほ-'],
      strokeCount: 4,
    },
    unihanVietnamese: 'hỏa',
  });

  assert.equal(entry.labels.hanViet, 'Hỏa');
  assert.equal(entry.labels.meaningVi, 'lửa');
  assert.deepEqual(entry.readings.onyomi, ['カ']);
  assert.deepEqual(entry.readings.kunyomi, ['ひ', '-び', 'ほ-']);
});

test('splitIntoLessonBuckets balances 25 authored kanji lessons', () => {
  const entries = Array.from({ length: 103 }, (_, index) => ({ character: String(index) }));
  const buckets = splitIntoLessonBuckets(entries, 25);

  assert.equal(buckets.length, 25);
  assert.equal(buckets.reduce((sum, bucket) => sum + bucket.length, 0), 103);
  assert.equal(Math.max(...buckets.map((bucket) => bucket.length)), 5);
  assert.equal(Math.min(...buckets.map((bucket) => bucket.length)), 4);
});
