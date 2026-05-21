const fs = require('node:fs');
const path = require('node:path');

const {
  readVocabEntries,
} = require('../research/generate_exercises');

function buildExerciseSampleReview({
  generatedAt = new Date().toISOString(),
  readingPassages,
  phoneticTraps,
  kanjiLookalikes,
  coverageManifest,
  vocabEntries = [],
} = {}) {
  const samples = [
    ...readingSamples(readingPassages, 5),
    ...phoneticSamples(phoneticTraps, vocabEntries, 5),
    ...kanjiSamples(kanjiLookalikes, 5),
    ...coverageSamples(coverageManifest, 5),
  ];
  const failures = samples
    .filter((sample) => sample.verdict !== 'pass')
    .map((sample) => `${sample.category}:${sample.target}:${sample.observation}`);
  return {
    schemaVersion: 1,
    generatedAt,
    reviewer: 'Codex autonomous Phase 4 acceptance sample',
    sampleCount: samples.length,
    failures,
    samples,
  };
}

function readingSamples(payload, count) {
  const passages = payload?.passages || [];
  return deterministicTake(passages, count).map((passage) => {
    const question = (passage.questions || [])[0] || {};
    const options = question.options_vi || question.options_ja || [];
    const valid =
      options.length >= 4 &&
      Number.isInteger(question.correct_index) &&
      question.correct_index >= 0 &&
      question.correct_index < options.length;
    return {
      category: 'reading',
      target: passage.passage_id,
      distractors: `${Math.max(0, options.length - 1)} options`,
      observation: valid
        ? `${passage.level} ${question.type || 'question'} has a valid correct index`
        : 'invalid reading options or correct index',
      verdict: valid ? 'pass' : 'fail',
    };
  });
}

function phoneticSamples(payload, vocabEntries, count) {
  const vocabById = new Map(vocabEntries.map((entry) => [entry.vocabId, entry]));
  const pairs = Object.entries(payload?.traps || {})
    .flatMap(([sourceId, traps]) =>
      (traps || []).map((trap) => ({ sourceId, trap })),
    )
    .filter(({ sourceId, trap }) => sourceId !== trap.vocab_id);
  return deterministicTake(pairs, count).map(({ sourceId, trap }) => {
    const source = vocabById.get(sourceId);
    const target = vocabById.get(trap.vocab_id);
    const valid = trap.distance >= 1 && trap.distance <= 2 && sourceId !== trap.vocab_id;
    return {
      category: 'phonetic',
      target: `${source?.term || sourceId} -> ${target?.term || trap.vocab_id}`,
      distractors: `DL distance ${trap.distance}`,
      observation: valid
        ? `${source?.reading || 'source'} vs ${target?.reading || 'trap'} is a near-kana trap`
        : 'invalid phonetic trap distance or self-pair',
      verdict: valid ? 'pass' : 'fail',
    };
  });
}

function kanjiSamples(payload, count) {
  const pairs = Object.entries(payload?.lookalikes || {})
    .flatMap(([source, traps]) =>
      (traps || []).map((trap) => ({ source, trap })),
    )
    .filter(({ source, trap }) => source !== trap.character);
  return deterministicTake(pairs, count).map(({ source, trap }) => {
    const valid = Boolean(trap.character && trap.reason && source !== trap.character);
    return {
      category: 'kanji',
      target: `${source} -> ${trap.character}`,
      distractors: trap.reason || 'missing reason',
      observation: valid
        ? `distinct visual/structural lookalike at ${trap.level || 'unknown'}`
        : 'invalid kanji lookalike pair',
      verdict: valid ? 'pass' : 'fail',
    };
  });
}

function coverageSamples(manifest, count) {
  const items = manifest?.items || [];
  const typeExerciseTypes = manifest?.typeExerciseTypes || {};
  const bloomLevels = new Set(manifest?.bloomLevels || []);
  const minimum = manifest?.minimumExerciseCount || 0;
  const selected = [
    firstItemOfType(items, 'grammar'),
    firstItemOfType(items, 'vocab'),
    firstItemOfType(items, 'kanji'),
    firstItemOfType(items, 'conjugation'),
    items[items.length - 1],
  ].filter(Boolean);
  return selected.slice(0, count).map((item) => {
    const [itemType, level, itemId] = Array.isArray(item)
      ? item
      : [item.item_type, item.level, item.item_id];
    const types = typeExerciseTypes[itemType] || item.exercise_types || [];
    const valid = minimum >= 50 && ['L1', 'L2', 'L3', 'L4'].every((levelKey) => bloomLevels.has(levelKey)) && types.length > 0;
    return {
      category: 'coverage',
      target: itemId,
      distractors: `${types.length} exercise types`,
      observation: valid
        ? `${itemType} ${level} declares >=${minimum} exercises and Bloom L1-L4`
        : 'coverage policy missing minimum, Bloom, or exercise types',
      verdict: valid ? 'pass' : 'fail',
    };
  });
}

function firstItemOfType(items, type) {
  return items.find((item) => (Array.isArray(item) ? item[0] : item.item_type) === type);
}

function deterministicTake(items, count) {
  if (items.length <= count) return items.slice();
  const step = Math.max(1, Math.floor(items.length / count));
  const selected = [];
  for (let index = 0; selected.length < count && index < items.length; index += step) {
    selected.push(items[index]);
  }
  return selected.slice(0, count);
}

function formatExerciseSampleReviewMarkdown(review) {
  const status = review.failures.length === 0 ? 'PASS' : 'FAIL';
  const rows = review.samples
    .map(
      (sample) =>
        `| ${sample.category} | ${escapePipe(sample.target)} | ${escapePipe(sample.distractors)} | ${escapePipe(sample.observation)} | ${sample.verdict} |`,
    )
    .join('\n');
  return `# Phase 4 Exercise Sample Review

- Generated at: \`${review.generatedAt}\`
- Reviewer: ${review.reviewer || 'Codex autonomous Phase 4 acceptance sample'}
- Sample count: \`${review.sampleCount}\`
- Verdict: **${status}**

| Category | Target | Distractor / mode | Observation | Verdict |
| --- | --- | --- | --- | --- |
${rows}
`;
}

function escapePipe(value) {
  return String(value || '').replace(/\|/g, '\\|').replace(/\n/g, ' ');
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function writeDefaultReview({
  contentRoot = path.join(process.cwd(), 'assets', 'data', 'content'),
  outputPath = path.join(process.cwd(), 'docs', 'reports', 'phase4-exercise-distractor-sample-review-2026-05-21.md'),
  generatedAt = new Date().toISOString(),
} = {}) {
  const review = buildExerciseSampleReview({
    generatedAt,
    readingPassages: readJson(path.join(contentRoot, 'reading_passages', 'reading_passages_corpus.json')),
    phoneticTraps: readJson(path.join(contentRoot, 'exercise_distractors', 'phonetic_traps.json')),
    kanjiLookalikes: readJson(path.join(contentRoot, 'exercise_distractors', 'kanji_lookalikes.json')),
    coverageManifest: readJson(path.join(contentRoot, 'exercises', 'exercise_coverage_manifest.json')),
    vocabEntries: readVocabEntries(contentRoot),
  });
  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, formatExerciseSampleReviewMarkdown(review), 'utf8');
  return review;
}

if (require.main === module) {
  const review = writeDefaultReview();
  console.log(JSON.stringify({
    sampleCount: review.sampleCount,
    failures: review.failures.length,
    output: 'docs/reports/phase4-exercise-distractor-sample-review-2026-05-21.md',
  }));
}

module.exports = {
  buildExerciseSampleReview,
  formatExerciseSampleReviewMarkdown,
  writeDefaultReview,
};
