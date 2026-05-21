const assert = require('node:assert/strict');
const test = require('node:test');

const {
  detectSourceProfile,
  formatCanonicalMarkdown,
  parseOfflineVocabText,
  parseVocabLine,
} = require('../../../tool/research/extract_offline_vocab_canonical');

test('parseVocabLine extracts standard term reading han-viet meaning rows', () => {
  const entry = parseVocabLine(
    '私 (わたし) - TƯ - Tôi (đại từ nhân xưng ngôi thứ nhất)',
  );

  assert.equal(entry.term, '私');
  assert.equal(entry.reading, 'わたし');
  assert.equal(entry.hanViet, 'TƯ');
  assert.equal(entry.meaningVi, 'Tôi (đại từ nhân xưng ngôi thứ nhất)');
  assert.deepEqual(entry.notes, []);
});

test('parseVocabLine accepts loanword rows without han-viet column', () => {
  const entry = parseVocabLine('コミュニケーション (コミュニケーション) - Giao tiếp');

  assert.equal(entry.term, 'コミュニケーション');
  assert.equal(entry.reading, 'コミュニケーション');
  assert.equal(entry.hanViet, null);
  assert.equal(entry.meaningVi, 'Giao tiếp');
  assert.deepEqual(entry.notes, ['no-han-viet-in-source']);
});

test('parseVocabLine handles nested reading parentheses and empty han-viet marker', () => {
  const milk = parseVocabLine('牛乳 (ぎゅうにゅう (ミルク)) - NGƯU NHŨ - Sữa bò');
  assert.equal(milk.term, '牛乳');
  assert.equal(milk.reading, 'ぎゅうにゅう(ミルク)');
  assert.equal(milk.hanViet, 'NGƯU NHŨ');
  assert.equal(milk.meaningVi, 'Sữa bò');

  const adverb = parseVocabLine('あまり～ません(くない) (あまり～ません(くない)) - - Không～lắm');
  assert.equal(adverb.term, 'あまり～ません(くない)');
  assert.equal(adverb.reading, 'あまり～ません(くない)');
  assert.equal(adverb.hanViet, null);
  assert.equal(adverb.meaningVi, 'Không～lắm');
  assert.deepEqual(adverb.notes, ['no-han-viet-in-source']);
});

test('parseVocabLine keeps rows with missing reading for later review', () => {
  const entry = parseVocabLine('自分で () - TỰ PHÂN - Tự (mình)');

  assert.equal(entry.term, '自分で');
  assert.equal(entry.reading, null);
  assert.equal(entry.hanViet, 'TỰ PHÂN');
  assert.equal(entry.meaningVi, 'Tự (mình)');
  assert.deepEqual(entry.notes, ['missing-reading-in-source']);
});

test('detectSourceProfile maps Minna and kanji-vocab paths', () => {
  assert.deepEqual(
    detectSourceProfile('Tu Vung Mina 1/bai7_mina_[local].pdf'),
    {
      source: 'minna-1',
      level: 'N5',
      sourceSection: 'Lesson 7',
      sourceUnit: 7,
      contentType: 'vocab',
    },
  );

  assert.deepEqual(
    detectSourceProfile('Tu Vung Theo Kanji/N3/unit12_kanji_n3_[local].pdf'),
    {
      source: 'kanji-vocab-n3',
      level: 'N3',
      sourceSection: 'Unit 12',
      sourceUnit: 12,
      contentType: 'vocab',
    },
  );
});

test('parseOfflineVocabText tracks source page from form-feed breaks', () => {
  const parsed = parseOfflineVocabText(
    ['私 (わたし) - TƯ - Tôi', '\f', '学校 (がっこう) - HỌC HIỆU - Trường học'].join(
      '\n',
    ),
    {
      source: 'minna-1',
      level: 'N5',
      sourceSection: 'Lesson 1',
      sourceFile: 'Tu Vung Mina 1/bai1_mina_[local].pdf',
    },
  );

  assert.equal(parsed.entries.length, 2);
  assert.equal(parsed.entries[0].sourcePage, 1);
  assert.equal(parsed.entries[1].sourcePage, 2);
  assert.equal(parsed.entries[1].source, 'minna-1');
  assert.equal(parsed.entries[1].level, 'N5');
  assert.equal(parsed.report.acceptedRows, 2);
  assert.equal(parsed.report.reviewRows, 0);
});

test('formatCanonicalMarkdown writes factual yaml-style entries', () => {
  const markdown = formatCanonicalMarkdown('minna-1', [
    {
      term: '私',
      reading: 'わたし',
      hanViet: 'TƯ',
      posTags: [],
      meaningVi: 'Tôi',
      meaningEnHint: null,
      level: 'N5',
      source: 'minna-1',
      sourceFile: 'Tu Vung Mina 1/bai1_mina_[local].pdf',
      sourceSection: 'Lesson 1',
      sourcePage: 1,
      confidence: 'text-layer',
      notes: [],
    },
  ], {
    acceptedRows: 1,
    reviewRows: 0,
    sourceFiles: 1,
  });

  assert.match(markdown, /# Canonical Vocab - minna-1/);
  assert.match(markdown, /term: 私/);
  assert.match(markdown, /reading: わたし/);
  assert.match(markdown, /sourcePage: 1/);
  assert.doesNotMatch(markdown, /nhaikanji\.com/);
  assert.doesNotMatch(markdown, /thocodehoctiengnhat\.com/);
});
