const fs = require('node:fs');
const path = require('node:path');

const REQUIRED_READING_COUNTS = { N5: 150, N4: 150, N3: 166, N2: 326, N1: 176 };
const REQUIRED_READING_SCOPES = [
  { key: 'mina-i', start: 1, end: 25 },
  { key: 'mina-ii', start: 26, end: 50 },
  { key: 'hajimete-n5', start: 1, end: 50 },
  { key: 'hajimete-n4', start: 1, end: 50 },
  { key: 'shinkanzen-n3', start: 1, end: 83 },
  { key: 'shinkanzen-n2', start: 1, end: 163 },
  { key: 'shinkanzen-n1', start: 1, end: 88 },
];
const READING_LENGTH_RANGES = {
  N5: [50, 150],
  N4: [100, 200],
  N3: [150, 300],
  N2: [200, 400],
  N1: [250, 500],
};
const REQUIRED_READING_QUESTION_TYPES = ['main_idea', 'detail', 'inference'];

function validatePhase4Assets({ readingPassages, phoneticTraps, kanjiLookalikes }) {
  const failures = [];
  validateReadingPassages(readingPassages, failures);
  validatePhoneticTraps(phoneticTraps, failures);
  validateKanjiLookalikes(kanjiLookalikes, failures);
  return {
    passed: failures.length === 0,
    failures,
    counts: {
      readingPassages: readingPassages?.passages?.length || 0,
      phoneticTrapItems: Object.keys(phoneticTraps?.traps || {}).length,
      kanjiLookalikeItems: Object.keys(kanjiLookalikes?.lookalikes || {}).length,
    },
  };
}

function validateExerciseCoverageManifest(manifest) {
  const failures = [];
  const rawItems = manifest?.items || [];
  const items = rawItems.map((item) => normalizeCoverageItem(item, manifest));
  if (items.length === 0) failures.push('exercise coverage manifest is empty');
  const seen = new Set();
  const globalExerciseTypes = new Set();
  for (const item of items) {
    if (!item.item_id) failures.push('coverage item missing id');
    if (seen.has(item.item_id)) failures.push(`duplicate coverage item: ${item.item_id}`);
    seen.add(item.item_id);
    if ((item.exercise_count || 0) < 50) {
      failures.push(`exercise count below 50: ${item.item_id}`);
    }
    const bloom = new Set(item.bloom_levels || []);
    for (const level of ['L1', 'L2', 'L3', 'L4']) {
      if (!bloom.has(level)) failures.push(`missing ${level}: ${item.item_id}`);
    }
    if ((item.exercise_types || []).length === 0) {
      failures.push(`missing exercise types: ${item.item_id}`);
    }
    for (const exerciseType of item.exercise_types || []) {
      globalExerciseTypes.add(exerciseType);
    }
  }
  for (const exerciseType of [
    'recognition',
    'production',
    'recall',
    'readingComp',
    'listening',
    'conjugationDrill',
  ]) {
    if (!globalExerciseTypes.has(exerciseType)) {
      failures.push(`missing exercise type ${exerciseType}`);
    }
  }
  return {
    passed: failures.length === 0,
    failures,
    counts: {
      totalItems: items.length,
      grammar: items.filter((item) => item.item_type === 'grammar').length,
      vocab: items.filter((item) => item.item_type === 'vocab').length,
      kanji: items.filter((item) => item.item_type === 'kanji').length,
      conjugation: items.filter((item) => item.item_type === 'conjugation').length,
    },
  };
}

function normalizeCoverageItem(item, manifest) {
  if (Array.isArray(item)) {
    const [itemType, level, itemId] = item;
    return {
      item_id: itemId,
      item_type: itemType,
      level,
      exercise_count: manifest?.minimumExerciseCount || 0,
      bloom_levels: manifest?.bloomLevels || [],
      exercise_types: manifest?.typeExerciseTypes?.[itemType] || [],
    };
  }
  return item || {};
}

function validateReadingPassages(payload, failures) {
  const passages = payload?.passages || [];
  const byLevel = {};
  const byLesson = {};
  const seenIds = new Set();
  for (const passage of passages) {
    if (!passage.passage_id) {
      failures.push('reading passage missing id');
      continue;
    }
    if (seenIds.has(passage.passage_id)) {
      failures.push(`duplicate reading passage: ${passage.passage_id}`);
    }
    seenIds.add(passage.passage_id);
    byLevel[passage.level] = (byLevel[passage.level] || 0) + 1;
    if (passage.lesson_key) {
      byLesson[passage.lesson_key] = (byLesson[passage.lesson_key] || 0) + 1;
    }
    const textLength = Array.from(passage.ja_text || '').length;
    const range = READING_LENGTH_RANGES[passage.level];
    if (!range) {
      failures.push(`reading level invalid: ${passage.passage_id}`);
    } else if (textLength < range[0] || textLength > range[1]) {
      failures.push(`reading length out of ${passage.level} range: ${passage.passage_id}`);
    }
    const questions = passage.questions || [];
    if (questions.length < 3 || questions.length > 5) {
      failures.push(`reading question count invalid: ${passage.passage_id}`);
    }
    const questionTypes = new Set(questions.map((question) => question.type));
    for (const type of REQUIRED_READING_QUESTION_TYPES) {
      if (!questionTypes.has(type)) {
        failures.push(`reading missing ${type}: ${passage.passage_id}`);
      }
    }
    for (const question of questions) {
      if ((question.options_vi || []).length !== 4 || (question.options_ja || []).length !== 4) {
        failures.push(`reading option count invalid: ${passage.passage_id}`);
      }
      if (!Number.isInteger(question.correct_index) || question.correct_index < 0 || question.correct_index > 3) {
        failures.push(`reading correct index invalid: ${passage.passage_id}`);
      }
    }
    if (passage.source_type !== 'original' || !passage.source_credit) {
      failures.push(`reading source attribution invalid: ${passage.passage_id}`);
    }
    if (!String(passage.copyright_safety || '').includes('no official JLPT')) {
      failures.push(`reading copyright safety missing: ${passage.passage_id}`);
    }
    if (passage.passage_index === 2 && !String(passage.human_moment_vi || '').trim()) {
      failures.push(`reading human moment missing: ${passage.passage_id}`);
    }
  }
  for (const [level, count] of Object.entries(REQUIRED_READING_COUNTS)) {
    if ((byLevel[level] || 0) < count) {
      failures.push(`reading count ${level} below ${count}`);
    }
  }
  for (const scope of REQUIRED_READING_SCOPES) {
    for (let lesson = scope.start; lesson <= scope.end; lesson += 1) {
      const lessonKey = `${scope.key}:lesson-${String(lesson).padStart(3, '0')}`;
      if ((byLesson[lessonKey] || 0) < 2) {
        failures.push(`reading lesson count below 2: ${lessonKey}`);
      }
    }
  }
}

function validatePhoneticTraps(payload, failures) {
  const traps = payload?.traps || {};
  if (Object.keys(traps).length === 0) {
    failures.push('phonetic trap corpus is empty');
    return;
  }
  for (const [id, items] of Object.entries(traps)) {
    const seen = new Set();
    for (const item of items || []) {
      if (item.vocab_id === id) failures.push(`phonetic trap self-link: ${id}`);
      if (seen.has(item.vocab_id)) failures.push(`phonetic trap duplicate: ${id}`);
      seen.add(item.vocab_id);
      if (item.distance < 1 || item.distance > 2) {
        failures.push(`phonetic trap distance invalid: ${id}`);
      }
    }
  }
}

function validateKanjiLookalikes(payload, failures) {
  const lookalikes = payload?.lookalikes || {};
  if (Object.keys(lookalikes).length === 0) {
    failures.push('kanji lookalike corpus is empty');
    return;
  }
  for (const [character, items] of Object.entries(lookalikes)) {
    const seen = new Set();
    for (const item of items || []) {
      if (item.character === character) failures.push(`kanji lookalike self-link: ${character}`);
      if (seen.has(item.character)) failures.push(`kanji lookalike duplicate: ${character}`);
      seen.add(item.character);
    }
  }
}

function validateDefaultAssets({
  contentRoot = path.join(process.cwd(), 'assets', 'data', 'content'),
} = {}) {
  const assetReport = validatePhase4Assets({
    readingPassages: readJson(path.join(contentRoot, 'reading_passages', 'reading_passages_corpus.json')),
    phoneticTraps: readJson(path.join(contentRoot, 'exercise_distractors', 'phonetic_traps.json')),
    kanjiLookalikes: readJson(path.join(contentRoot, 'exercise_distractors', 'kanji_lookalikes.json')),
  });
  const coverageReport = validateExerciseCoverageManifest(
    readJson(path.join(contentRoot, 'exercises', 'exercise_coverage_manifest.json')),
  );
  return {
    passed: assetReport.passed && coverageReport.passed,
    failures: [...assetReport.failures, ...coverageReport.failures],
    counts: { ...assetReport.counts, ...coverageReport.counts },
  };
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

if (require.main === module) {
  const report = validateDefaultAssets();
  console.log(JSON.stringify(report, null, 2));
  process.exitCode = report.passed ? 0 : 1;
}

module.exports = {
  validateExerciseCoverageManifest,
  validateDefaultAssets,
  validatePhase4Assets,
};
