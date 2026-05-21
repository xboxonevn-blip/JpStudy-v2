const fs = require('node:fs');
const path = require('node:path');

const REQUIRED_READING_COUNTS = { N5: 10, N4: 10, N3: 20, N2: 20, N1: 20 };

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

function validateReadingPassages(payload, failures) {
  const passages = payload?.passages || [];
  const byLevel = {};
  for (const passage of passages) {
    byLevel[passage.level] = (byLevel[passage.level] || 0) + 1;
    const textLength = Array.from(passage.ja_text || '').length;
    if ((passage.level === 'N5' || passage.level === 'N4') && (textLength < 50 || textLength > 150)) {
      failures.push(`reading length out of N5/N4 range: ${passage.passage_id}`);
    }
    if (['N3', 'N2', 'N1'].includes(passage.level) && (textLength < 100 || textLength > 300)) {
      failures.push(`reading length out of upper range: ${passage.passage_id}`);
    }
    const questions = passage.questions || [];
    if (questions.length < 3 || questions.length > 5) {
      failures.push(`reading question count invalid: ${passage.passage_id}`);
    }
    for (const question of questions) {
      if ((question.options_vi || []).length !== 4 || (question.options_ja || []).length !== 4) {
        failures.push(`reading option count invalid: ${passage.passage_id}`);
      }
      if (question.correct_index < 0 || question.correct_index > 3) {
        failures.push(`reading correct index invalid: ${passage.passage_id}`);
      }
    }
  }
  for (const [level, count] of Object.entries(REQUIRED_READING_COUNTS)) {
    if ((byLevel[level] || 0) < count) {
      failures.push(`reading count ${level} below ${count}`);
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
  return validatePhase4Assets({
    readingPassages: readJson(path.join(contentRoot, 'reading_passages', 'reading_passages_corpus.json')),
    phoneticTraps: readJson(path.join(contentRoot, 'exercise_distractors', 'phonetic_traps.json')),
    kanjiLookalikes: readJson(path.join(contentRoot, 'exercise_distractors', 'kanji_lookalikes.json')),
  });
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
  validateDefaultAssets,
  validatePhase4Assets,
};
