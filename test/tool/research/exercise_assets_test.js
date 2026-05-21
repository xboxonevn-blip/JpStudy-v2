const assert = require('node:assert/strict');
const test = require('node:test');

const {
  buildKanjiLookalikeCorpus,
  buildExerciseCoverageManifest,
  buildPhoneticTrapCorpus,
  damerauLevenshtein,
} = require('../../../tool/research/generate_exercises');
const {
  buildReadingPassages,
} = require('../../../tool/research/generate_reading_passages');
const {
  validatePhase4Assets,
  validateExerciseCoverageManifest,
} = require('../../../tool/qa/validate_exercises');

test('buildReadingPassages emits required per-level counts and questions', () => {
  const passages = buildReadingPassages({
    levels: ['N5', 'N4', 'N3', 'N2', 'N1'],
    generatedAt: '2026-05-21T08:00:00+07:00',
  });

  const byLevel = passages.passages.reduce((acc, passage) => {
    acc[passage.level] = (acc[passage.level] || 0) + 1;
    assert.equal(passage.questions.length >= 3, true);
    assert.equal(passage.questions.length <= 5, true);
    for (const question of passage.questions) {
      assert.equal(question.options_vi.length, 4);
      assert.equal(question.options_ja.length, 4);
      assert.equal(question.correct_index >= 0, true);
      assert.equal(question.correct_index < 4, true);
    }
    return acc;
  }, {});

  assert.equal(byLevel.N5, 150);
  assert.equal(byLevel.N4, 150);
  assert.equal(byLevel.N3, 166);
  assert.equal(byLevel.N2, 326);
  assert.equal(byLevel.N1, 176);
  assert.equal(passages.passages.length, 968);
});

test('buildPhoneticTrapCorpus keeps same-length near-kana traps', () => {
  const corpus = buildPhoneticTrapCorpus([
    vocab('v1', 'N5', '雨', 'あめ'),
    vocab('v2', 'N5', '飴', 'あめ'),
    vocab('v3', 'N5', '姉', 'あね'),
    vocab('v4', 'N5', '犬', 'いぬ'),
  ]);

  assert.equal(damerauLevenshtein('あめ', 'あね'), 1);
  assert.equal(corpus.traps.v1.some((trap) => trap.vocab_id === 'v3'), true);
  assert.equal(corpus.traps.v1.every((trap) => trap.vocab_id !== 'v1'), true);
});

test('buildKanjiLookalikeCorpus includes known visual pairs', () => {
  const corpus = buildKanjiLookalikeCorpus([
    kanji('k1', 'N2', '湿', 12, ['日', '氵']),
    kanji('k2', 'N2', '温', 12, ['日', '氵']),
    kanji('k3', 'N5', '一', 1, []),
  ]);

  assert.equal(corpus.lookalikes['湿'].some((item) => item.character === '温'), true);
  assert.equal(corpus.lookalikes['温'].some((item) => item.character === '湿'), true);
  assert.equal(corpus.lookalikes['湿'].every((item) => item.character !== '湿'), true);
});

test('buildKanjiLookalikeCorpus rejects stroke-only weak pairs', () => {
  const corpus = buildKanjiLookalikeCorpus([
    kanji('radical', 'N5', '刂', 2, []),
    kanji('plain', 'N5', '丁', 2, []),
  ]);

  assert.equal(corpus.lookalikes['刂'], undefined);
});

test('validatePhase4Assets accepts generated reading and distractor corpora', () => {
  const readingPassages = buildReadingPassages({
    levels: ['N5', 'N4', 'N3', 'N2', 'N1'],
    generatedAt: '2026-05-21T08:00:00+07:00',
  });
  const phoneticTraps = buildPhoneticTrapCorpus([
    vocab('v1', 'N5', '雨', 'あめ'),
    vocab('v2', 'N5', '姉', 'あね'),
    vocab('v3', 'N5', '犬', 'いぬ'),
  ]);
  const kanjiLookalikes = buildKanjiLookalikeCorpus([
    kanji('k1', 'N2', '湿', 12, ['日', '氵']),
    kanji('k2', 'N2', '温', 12, ['日', '氵']),
    kanji('k3', 'N5', '一', 1, []),
  ]);

  const report = validatePhase4Assets({
    readingPassages,
    phoneticTraps,
    kanjiLookalikes,
  });

  assert.equal(report.passed, true);
  assert.deepEqual(report.failures, []);
});

test('buildExerciseCoverageManifest marks every item dense with Bloom coverage', () => {
  const manifest = buildExerciseCoverageManifest({
    generatedAt: '2026-05-21T08:40:00+07:00',
    grammarPoints: [{ id: 1, level: 'N5', title: 'N1 は N2 です' }],
    vocabEntries: [vocab('v1', 'N5', '雨', 'あめ')],
    kanjiEntries: [kanji('k1', 'N5', '雨', 8, ['水'])],
    conjugationEntries: [{ id: 'c1', level: 'N5', term: '食べる', kind: 'verb' }],
  });

  const report = validateExerciseCoverageManifest(manifest);

  assert.equal(report.passed, true);
  assert.equal(report.counts.totalItems, 4);
  assert.equal(
    report.counts.totalItems,
    manifest.items.length,
  );
  assert.equal(
    report.failures.some((failure) => failure.includes('below 50')),
    false,
  );
  assert.equal(
    report.failures.some((failure) => failure.includes('missing L')),
    false,
  );
});

test('buildExerciseCoverageManifest uses compact entries for bundle size', () => {
  const manifest = buildExerciseCoverageManifest({
    grammarPoints: [{ id: 1, level: 'N5', title: 'N1 は N2 です' }],
    vocabEntries: [vocab('v1', 'N5', '雨', 'あめ')],
  });

  assert.equal(Array.isArray(manifest.items[0]), true);
  assert.equal(
    JSON.stringify(manifest).length < 1400,
    true,
  );
});

test('validateExerciseCoverageManifest requires all six exercise types globally', () => {
  const report = validateExerciseCoverageManifest({
    minimumExerciseCount: 50,
    bloomLevels: ['L1', 'L2', 'L3', 'L4'],
    typeExerciseTypes: {
      grammar: ['recognition'],
    },
    items: [['grammar', 'N5', 'grammar:n5:1']],
  });

  assert.equal(report.passed, false);
  assert.match(report.failures.join('\n'), /missing exercise type listening/);
});

function vocab(vocabId, level, term, reading) {
  return { vocabId, level, term, reading };
}

function kanji(kanjiId, level, character, strokeCount, components) {
  return { kanjiId, level, character, strokeCount, components };
}
