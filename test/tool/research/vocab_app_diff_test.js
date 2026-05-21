const assert = require('node:assert/strict');
const test = require('node:test');

const {
  buildVocabAppDiff,
  formatLevelDiffMarkdown,
  parseAppVocabJson,
} = require('../../../tool/research/build_vocab_app_diff');

test('parseAppVocabJson reads app vocab entries from content JSON', () => {
  const entries = parseAppVocabJson(
    JSON.stringify({
      level: 'N5',
      series: 'minna',
      lessonId: 5,
      entries: [
        {
          entryId: 'n5_l05_s004',
          tags: ['place'],
          lemma: {
            term: '学校',
            reading: 'がっこう',
          },
          sense: {
            meaningVi: 'trường học',
          },
          links: {
            sourceVocabId: 'n5_l05_v004',
          },
        },
      ],
    }),
    'assets/data/content/vocab/n5/minna/lesson_05.json',
  );

  assert.equal(entries.length, 1);
  assert.equal(entries[0].term, '学校');
  assert.equal(entries[0].reading, 'がっこう');
  assert.equal(entries[0].level, 'N5');
  assert.equal(entries[0].meaningVi, 'trường học');
  assert.equal(entries[0].sourceVocabId, 'n5_l05_v004');
});

test('buildVocabAppDiff classifies matched, wrong, missing, and extra rows by level', () => {
  const appEntries = [
    app('学校', 'がっこう', 'Trường học', 'N5', ['noun']),
    app('映画', 'えいが', 'phim', 'N1', ['noun']),
    app('水', 'みず', 'Water', 'N5', ['noun']),
    app('帰ります', 'かえます', 'về', 'N5', ['verb']),
    app('犬', 'いぬ', 'chó', 'N5', ['noun']),
    app('食べる', 'たべる', 'ăn', 'N5', ['noun']),
  ];
  const canonical = {
    consensus: [
      canon('学校', 'がっこう', 'Trường học', ['minna-1', 'kanji-vocab-n5'], ['N5'], ['noun']),
      canon('水', 'みず', 'Nước', ['minna-1', 'kanji-vocab-n5'], ['N5'], ['noun']),
      canon('帰ります', 'かえります', 'về', ['minna-1', 'kanji-vocab-n5'], ['N5'], ['verb']),
      canon('猫', 'ねこ', 'mèo', ['minna-1', 'kanji-vocab-n5'], ['N5'], ['noun']),
      canon('食べる', 'たべる', 'ăn', ['minna-1', 'kanji-vocab-n5'], ['N5'], ['verb']),
      canon('映画', 'えいが', 'phim', ['minna-1', 'kanji-vocab-n4'], ['N5', 'N4'], ['noun']),
    ],
    divergent: [],
    singleSource: [],
  };

  const result = buildVocabAppDiff(appEntries, canonical, { generatedAt: '2026-05-21T00:00:00.000Z' });
  const n5 = result.levels.N5;

  assert.equal(n5.summary.matchedOk, 1);
  assert.equal(n5.summary.wrongMeaning, 1);
  assert.equal(n5.summary.wrongReading, 1);
  assert.equal(n5.summary.wrongPos, 1);
  assert.equal(result.levels.N1.summary.wrongLevel, 1);
  assert.equal(n5.summary.missingInApp, 1);
  assert.equal(n5.summary.extraInApp, 1);
  assert.equal(n5.wrongMeaning[0].term, '水');
  assert.equal(n5.wrongReading[0].canonicalReading, 'かえります');
  assert.equal(n5.wrongPos[0].term, '食べる');
  assert.equal(result.levels.N1.wrongLevel[0].canonicalLevel, 'N5');
  assert.equal(n5.missingInApp[0].term, '猫');
  assert.equal(n5.extraInApp[0].term, '犬');
});

test('formatLevelDiffMarkdown writes reviewable level report without banned domains', () => {
  const result = buildVocabAppDiff(
    [app('学校', 'がっこう', 'Trường học', 'N5', ['noun'])],
    {
      consensus: [canon('学校', 'がっこう', 'Trường học', ['minna-1', 'kanji-vocab-n5'], ['N5'], ['noun'])],
      divergent: [],
      singleSource: [],
    },
    { generatedAt: '2026-05-21T00:00:00.000Z' },
  );

  const markdown = formatLevelDiffMarkdown('N5', result.levels.N5, result);
  assert.match(markdown, /# Vocab App Diff - N5/);
  assert.match(markdown, /MATCHED-OK/);
  assert.match(markdown, /Source boundary: owner-provided local canonical vocab/);
  assert.match(markdown, /banned websites not accessed/);
});

function app(term, reading, meaningVi, level, tags = []) {
  return {
    entryId: `${level}:${term}`,
    term,
    reading,
    meaningVi,
    level,
    tags,
    path: `assets/data/content/vocab/${level.toLowerCase()}/sample.json`,
  };
}

function canon(term, reading, meaningVi, sources, levels, posTags = []) {
  return {
    term,
    reading,
    meaningVi,
    sources,
    levels,
    posTags,
  };
}
