const fs = require('node:fs');
const path = require('node:path');

const DEFAULT_CONTENT_ROOT = path.join('assets', 'data', 'content');
const DEFAULT_MANIFEST_ROOT = path.join('lib', 'data', 'manifests');

const LEVELS = ['N5', 'N4', 'N3', 'N2', 'N1'];

function requiredTextbookCatalog() {
  const books = [
    {
      textbook_id: 'minna_n5',
      level: 'N5',
      name_ja: 'みんなの日本語 初級I',
      name_vi: 'Minna no Nihongo Sơ cấp I',
      name_en: 'Minna no Nihongo Elementary I',
      categories: ['grammar', 'vocab'],
      source_credit: '3A Corporation reference only; no verbatim reproduction',
    },
    {
      textbook_id: 'minna_n4',
      level: 'N4',
      name_ja: 'みんなの日本語 初級II',
      name_vi: 'Minna no Nihongo Sơ cấp II',
      name_en: 'Minna no Nihongo Elementary II',
      categories: ['grammar', 'vocab'],
      source_credit: '3A Corporation reference only; no verbatim reproduction',
    },
  ];

  for (const level of LEVELS) {
    books.push({
      textbook_id: `hajimete_tango_${level.toLowerCase()}`,
      level,
      name_ja: `はじめての日本語能力試験単語 ${level}`,
      name_vi: `Hajimete Tango ${level}`,
      name_en: `Hajimete Tango ${level}`,
      categories: ['vocab'],
      source_credit: 'ASK Publishing reference only; app data remains local-first',
    });
    if (['N3', 'N2', 'N1'].includes(level)) {
      books.push({
        textbook_id: `mimikara_${level.toLowerCase()}`,
        level,
        name_ja: `耳から覚える ${level}`,
        name_vi: `Mimikara ${level}`,
        name_en: `Mimikara ${level}`,
        categories: ['vocab'],
        source_credit: 'Owner-provided local Mimikara facts; no prose copied',
        migration_status: 'live',
      });
    }
  }

  for (const level of ['N3', 'N2', 'N1']) {
    books.push({
      textbook_id: `shinkanzen_${level.toLowerCase()}`,
      level,
      name_ja: `新完全マスター 文法 ${level}`,
      name_vi: `Shin Kanzen Master 文法 ${level}`,
      name_en: `Shin Kanzen Master Grammar ${level}`,
      categories: ['grammar'],
      source_credit:
        'Shin Kanzen Master Bunpou publisher metadata plus existing JpStudy grammar/Tae Kim fallback; no verbatim reproduction',
    });
  }

  for (const level of LEVELS) {
    books.push({
      textbook_id: `canonical_kanji_${level.toLowerCase()}`,
      level,
      name_ja: `漢字 ${level}`,
      name_vi: `Kanji chuẩn ${level}`,
      name_en: `Canonical Kanji ${level}`,
      categories: ['kanji'],
      source_credit:
        'Owner-provided canonical kanji ebooks plus KANJIDIC2/Unihan facts',
      migration_status: 'supporting_track',
    });
  }

  return books;
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

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function relPath(root, file) {
  return path.relative(root, file).split(path.sep).join('/');
}

function writeJson(file, payload) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, `${JSON.stringify(payload, null, 2)}\n`);
}

function entriesOf(payload) {
  if (Array.isArray(payload)) return payload;
  if (payload && Array.isArray(payload.entries)) return payload.entries;
  return [];
}

function levelFromParts(parts) {
  const match = parts.find((part) => /^n[1-5]$/i.test(part));
  return match ? match.toUpperCase() : null;
}

function numberFromFile(file) {
  const name = path.basename(file);
  const matches = [...name.matchAll(/(?:lesson_|grammar_n\d_|ch|_)(\d{1,3})/gi)];
  if (matches.length === 0) return null;
  return Number(matches[0][1]);
}

function pad2(value) {
  return String(value).padStart(2, '0');
}

function slug(value, fallback) {
  const raw = String(value || fallback || 'item').trim();
  return raw
    .replace(/[\\/#?%*:|"<>]/g, '_')
    .replace(/\s+/g, '_')
    .slice(0, 48);
}

function normalizeTextbookForFile({ dataset, level, payload, file }) {
  if (dataset === 'grammar') {
    return level === 'N5' || level === 'N4'
      ? `minna_${level.toLowerCase()}`
      : `shinkanzen_${level.toLowerCase()}`;
  }

  if (dataset === 'kanji') return `canonical_kanji_${level.toLowerCase()}`;

  const series = String(payload.series || path.basename(path.dirname(file)));
  if (/minna/i.test(series)) return `minna_${level.toLowerCase()}`;
  if (/hajimete/i.test(series)) return `hajimete_tango_${level.toLowerCase()}`;
  if (/shinkanzen/i.test(series)) return `jpstudy_curated_vocab_${level.toLowerCase()}`;
  if (/mimikara/i.test(series)) return `mimikara_${level.toLowerCase()}`;
  return `jpstudy_${dataset}_${level.toLowerCase()}`;
}

function lessonNumberForFile(payload, file) {
  return (
    payload.lessonId ||
    payload.chapterId ||
    (Array.isArray(payload) ? payload[0]?.lessonId : null) ||
    numberFromFile(file) ||
    1
  );
}

function lessonTitles({ textbookId, level, lessonNumber, payload, file }) {
  const number = Number(lessonNumber);
  const base = {
    lesson_number_ja: `第${number}課`,
    lesson_number_vi: `Bài ${number}`,
    theme_ja: '',
    theme_vi: '',
  };

  if (textbookId.startsWith('hajimete_tango_')) {
    const chapterTitle = payload.chapterTitle || `Core vocabulary ${pad2(number)}`;
    return {
      ...base,
      lesson_number_ja: `Chapter ${number}`,
      lesson_number_vi: `Chủ đề ${number}`,
      theme_ja: chapterTitle,
      theme_vi: chapterTitle,
    };
  }

  if (textbookId.startsWith('shinkanzen_')) {
    const route = payload.entries?.[0]?.lessonRoute || {};
    const indexTitle =
      route.categoryTitle ||
      payload.categoryTitle ||
      path.basename(file, '.json').replace(/^shinkanzen_[nN]\d+_\d+_/, '');
    return {
      ...base,
      lesson_number_ja: `${level} ${pad2(number)}`,
      lesson_number_vi: `Mục ${number}`,
      theme_ja: indexTitle,
      theme_vi: indexTitle,
    };
  }

  if (textbookId.startsWith('canonical_kanji_')) {
    return {
      ...base,
      lesson_number_ja: `${level} Kanji ${pad2(number)}`,
      lesson_number_vi: `Kanji ${level} - cụm ${number}`,
      theme_ja: `Kanji ${level}`,
      theme_vi: `Kanji ${level}`,
    };
  }

  return base;
}

function labelForEntry(dataset, entry) {
  if (dataset === 'grammar') {
    return {
      label_ja: entry.title || entry.structure || entry.structureEn || '',
      label_vi: entry.titleVi || entry.explanation?.split('\n')[0] || '',
      surface: entry.title || entry.structure || '',
      reading: '',
    };
  }
  if (dataset === 'kanji') {
    return {
      label_ja: entry.character || '',
      label_vi:
        entry.labels?.meaningViDisplay ||
        entry.labels?.meaningVi ||
        entry.labels?.hanViet ||
        '',
      surface: entry.character || '',
      reading: entry.readings?.onyomi?.[0] || '',
    };
  }
  return {
    label_ja: entry.lemma?.term || entry.term || '',
    label_vi: entry.sense?.meaningVi || entry.meaningVi || '',
    surface: entry.lemma?.term || entry.term || '',
    reading: entry.lemma?.reading || entry.reading || '',
  };
}

function legacyKey(contentRoot, file, entry, dataset, index) {
  const id =
    entry.entryId ||
    entry.kanjiId ||
    entry.id ||
    entry.title ||
    entry.structure ||
    entry.character ||
    entry.lemma?.vocabId ||
    index + 1;
  return `${relPath(contentRoot, file)}#${dataset}:${id}`;
}

function collectLegacyItems(contentRoot) {
  const items = [];
  const files = jsonFiles(contentRoot);
  for (const file of files) {
    const relative = relPath(contentRoot, file);
    const parts = relative.split('/');
    const dataset = parts[0];
    if (!['vocab', 'grammar', 'kanji'].includes(dataset)) continue;
    if (path.basename(file) === 'index.json') continue;
    if (dataset === 'kanji' && !/^lesson_\d+\.json$/i.test(path.basename(file))) {
      continue;
    }
    if (dataset === 'grammar' && !/^grammar_n\d+_\d+\.json$/i.test(path.basename(file))) {
      continue;
    }

    const payload = readJson(file);
    const entries = entriesOf(payload);
    if (entries.length === 0) continue;
    const level = levelFromParts(parts);
    if (!level) continue;
    const textbookId = normalizeTextbookForFile({ dataset, level, payload, file });
    const lessonNumber = lessonNumberForFile(payload, file);
    const lessonId = `${textbookId}_${pad2(lessonNumber)}`;
    const titles = lessonTitles({
      textbookId,
      level,
      lessonNumber,
      payload,
      file,
    });

    entries.forEach((entry, index) => {
      const labels = labelForEntry(dataset, entry);
      const entryId =
        entry.entryId ||
        entry.kanjiId ||
        entry.id ||
        entry.lemma?.vocabId ||
        entry.character ||
        entry.title ||
        index + 1;
      items.push({
        key: legacyKey(contentRoot, file, entry, dataset, index),
        dataset,
        level,
        textbookId,
        lessonId,
        lessonNumber,
        lessonTitles: titles,
        item: {
          item_id: `${dataset}:${level.toLowerCase()}:${textbookId}:${pad2(
            lessonNumber,
          )}:${slug(labels.surface, entryId)}`,
          type: dataset,
          surface: labels.surface,
          reading: labels.reading,
          label_ja: labels.label_ja,
          label_vi: labels.label_vi,
          order: entry.order || index + 1,
          legacy_ref: {
            file: relative,
            entry_id: String(entryId),
            key: legacyKey(contentRoot, file, entry, dataset, index),
          },
          exercise_bank_ref: `exercises/${level.toLowerCase()}/${textbookId}/${lessonId}.json`,
        },
      });
    });
  }
  return items;
}

function buildManifests({
  contentRoot = DEFAULT_CONTENT_ROOT,
  generatedAt = new Date().toISOString(),
} = {}) {
  const catalog = requiredTextbookCatalog();
  const catalogById = new Map(catalog.map((book) => [book.textbook_id, book]));
  const legacyItems = collectLegacyItems(contentRoot);
  const byBook = new Map();

  for (const record of legacyItems) {
    if (!byBook.has(record.textbookId)) byBook.set(record.textbookId, []);
    byBook.get(record.textbookId).push(record);
    if (!catalogById.has(record.textbookId)) {
      catalogById.set(record.textbookId, {
        textbook_id: record.textbookId,
        level: record.level,
        name_ja: record.textbookId,
        name_vi: record.textbookId,
        name_en: record.textbookId,
        categories: [record.dataset],
        source_credit: 'Derived from existing JpStudy local content assets',
        migration_status: 'supporting_track',
      });
    }
  }

  const textbookIndex = {
    schema_version: 1,
    generated_at: generatedAt,
    source_policy:
      'Generated from local JpStudy assets and owner-provided source references; banned websites not accessed.',
    textbooks: [],
  };
  const lessonIndexes = {};
  const itemIndexes = {};

  for (const book of [...catalogById.values()].sort((a, b) =>
    a.textbook_id.localeCompare(b.textbook_id),
  )) {
    const records = (byBook.get(book.textbook_id) || []).sort((a, b) => {
      if (a.lessonNumber !== b.lessonNumber) return a.lessonNumber - b.lessonNumber;
      if (a.dataset !== b.dataset) return a.dataset.localeCompare(b.dataset);
      return a.item.order - b.item.order;
    });
    const lessons = new Map();
    for (const record of records) {
      if (!lessons.has(record.lessonId)) {
        lessons.set(record.lessonId, {
          lesson_id: record.lessonId,
          lesson_number_ja: record.lessonTitles.lesson_number_ja,
          lesson_number_vi: record.lessonTitles.lesson_number_vi,
          theme_ja: record.lessonTitles.theme_ja,
          theme_vi: record.lessonTitles.theme_vi,
          item_counts: {},
          est_minutes: 30,
          prerequisites: [],
        });
      }
      const lesson = lessons.get(record.lessonId);
      lesson.item_counts[record.dataset] =
        (lesson.item_counts[record.dataset] || 0) + 1;
    }

    const lessonList = [...lessons.values()].sort((a, b) =>
      a.lesson_id.localeCompare(b.lesson_id),
    );
    if (lessonList.length > 0) {
      lessonIndexes[`lesson_index_${book.textbook_id}.json`] = {
        schema_version: 1,
        generated_at: generatedAt,
        textbook_id: book.textbook_id,
        lessons: lessonList,
      };
      for (const lesson of lessonList) {
        itemIndexes[`item_index_${book.textbook_id}_${lesson.lesson_id}.json`] = {
          schema_version: 1,
          generated_at: generatedAt,
          textbook_id: book.textbook_id,
          lesson_id: lesson.lesson_id,
          items: records
            .filter((record) => record.lessonId === lesson.lesson_id)
            .map((record) => record.item),
        };
      }
    }

    textbookIndex.textbooks.push({
      ...book,
      lesson_count: lessonList.length,
      item_count_total: records.length,
      migration_status:
        records.length > 0 ? 'generated_from_local_assets' : book.migration_status || 'planned_source_pending',
    });
  }

  return {
    textbookIndex,
    lessonIndexes,
    itemIndexes,
    summary: {
      legacyItemCount: legacyItems.length,
      migratedItemCount: Object.values(itemIndexes).reduce(
        (sum, index) => sum + index.items.length,
        0,
      ),
      generatedLessonCount: Object.values(lessonIndexes).reduce(
        (sum, index) => sum + index.lessons.length,
        0,
      ),
    },
  };
}

function writeManifests(manifests, manifestRoot = DEFAULT_MANIFEST_ROOT) {
  fs.mkdirSync(manifestRoot, { recursive: true });
  writeJson(path.join(manifestRoot, 'textbook_index.json'), manifests.textbookIndex);
  for (const [name, payload] of Object.entries(manifests.lessonIndexes)) {
    writeJson(path.join(manifestRoot, name), payload);
  }
  for (const [name, payload] of Object.entries(manifests.itemIndexes)) {
    writeJson(path.join(manifestRoot, name), payload);
  }
  writeJson(path.join(manifestRoot, 'migration_summary.json'), {
    schema_version: 1,
    generated_at: manifests.textbookIndex.generated_at,
    ...manifests.summary,
  });
}

function parseArgs(argv) {
  const args = {};
  for (let index = 2; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === '--content-root') args.contentRoot = argv[++index];
    if (arg === '--out-root') args.outRoot = argv[++index];
    if (arg === '--generated-at') args.generatedAt = argv[++index];
  }
  return args;
}

if (require.main === module) {
  const args = parseArgs(process.argv);
  const manifests = buildManifests({
    contentRoot: args.contentRoot || DEFAULT_CONTENT_ROOT,
    generatedAt: args.generatedAt || '2026-05-21T00:00:00+07:00',
  });
  writeManifests(manifests, args.outRoot || DEFAULT_MANIFEST_ROOT);
  console.log(
    JSON.stringify(
      {
        manifestRoot: args.outRoot || DEFAULT_MANIFEST_ROOT,
        ...manifests.summary,
      },
      null,
      2,
    ),
  );
}

module.exports = {
  buildManifests,
  collectLegacyItems,
  requiredTextbookCatalog,
  writeManifests,
};
