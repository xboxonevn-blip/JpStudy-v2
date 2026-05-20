const fs = require('node:fs');
const path = require('node:path');

const {
  collectLegacyItems,
} = require('./restructure_to_theme_lesson');

const DEFAULT_CONTENT_ROOT = path.join('assets', 'data', 'content');
const DEFAULT_MANIFEST_ROOT = path.join('lib', 'data', 'manifests');

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function jsonFiles(dir) {
  if (!fs.existsSync(dir)) return [];
  const out = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      out.push(...jsonFiles(full));
    } else if (entry.name.endsWith('.json')) {
      out.push(full);
    }
  }
  return out.sort();
}

function validateMigration({
  contentRoot = DEFAULT_CONTENT_ROOT,
  manifestRoot = DEFAULT_MANIFEST_ROOT,
} = {}) {
  const legacyItems = collectLegacyItems(contentRoot);
  const legacyKeys = new Set(legacyItems.map((item) => item.key));
  const itemIndexFiles = jsonFiles(manifestRoot).filter((file) =>
    path.basename(file).startsWith('item_index_'),
  );
  const lessonIndexFiles = jsonFiles(manifestRoot).filter((file) =>
    path.basename(file).startsWith('lesson_index_'),
  );
  const newKeys = new Set();
  const orphanReferences = [];
  let newReaderItemCount = 0;
  let emptyGeneratedLessonCount = 0;

  for (const file of itemIndexFiles) {
    const payload = readJson(file);
    for (const item of payload.items || []) {
      newReaderItemCount += 1;
      const key = item.legacy_ref?.key;
      if (key) newKeys.add(key);
      const legacyFile = item.legacy_ref?.file;
      if (!legacyFile || !fs.existsSync(path.join(contentRoot, legacyFile))) {
        orphanReferences.push({
          item_id: item.item_id,
          item_index: path.basename(file),
          file: legacyFile || null,
        });
      }
    }
  }

  for (const file of lessonIndexFiles) {
    const payload = readJson(file);
    for (const lesson of payload.lessons || []) {
      const total = Object.values(lesson.item_counts || {}).reduce(
        (sum, value) => sum + Number(value || 0),
        0,
      );
      if (total === 0) emptyGeneratedLessonCount += 1;
    }
  }

  const lostKeys = [...legacyKeys].filter((key) => !newKeys.has(key));
  const extraKeys = [...newKeys].filter((key) => !legacyKeys.has(key));

  return {
    oldReaderItemCount: legacyItems.length,
    newReaderItemCount,
    lostItemCount: lostKeys.length,
    orphanReferenceCount: orphanReferences.length,
    emptyGeneratedLessonCount,
    extraReferenceCount: extraKeys.length,
    lostKeys,
    extraKeys,
    orphanReferences,
    passed:
      lostKeys.length === 0 &&
      extraKeys.length === 0 &&
      orphanReferences.length === 0 &&
      emptyGeneratedLessonCount === 0 &&
      legacyItems.length === newReaderItemCount,
  };
}

function parseArgs(argv) {
  const args = {};
  for (let index = 2; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === '--content-root') args.contentRoot = argv[++index];
    if (arg === '--manifest-root') args.manifestRoot = argv[++index];
  }
  return args;
}

if (require.main === module) {
  const args = parseArgs(process.argv);
  const report = validateMigration({
    contentRoot: args.contentRoot || DEFAULT_CONTENT_ROOT,
    manifestRoot: args.manifestRoot || DEFAULT_MANIFEST_ROOT,
  });
  console.log(JSON.stringify(report, null, 2));
  if (!report.passed) process.exitCode = 1;
}

module.exports = {
  validateMigration,
};
