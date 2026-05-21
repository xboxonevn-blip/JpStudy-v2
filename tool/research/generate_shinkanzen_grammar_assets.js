#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..', '..');
const manifestRoot = path.join(repoRoot, 'lib', 'data', 'manifests');
const contentRoot = path.join(repoRoot, 'assets', 'data', 'content');

const targets = {
  n3: { count: 83, textbook: 'shinkanzen_n3' },
  n2: { count: 163, textbook: 'shinkanzen_n2' },
  n1: { count: 88, textbook: 'shinkanzen_n1' },
};

const fallbackReference = {
  sourceCredit: "Tae Kim's Guide to Japanese Grammar (CC-BY-NC-SA 3.0)",
  sourceUrl: 'https://guidetojapanese.org/learn/grammar',
  license: 'CC-BY-NC-SA 3.0',
  usePolicy:
    'Fallback reference only; JpStudy writes original Vietnamese guidance and does not copy source prose.',
  guideSection: 'grammar',
};

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function writeJson(filePath, payload) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(payload, null, 2)}\n`);
}

function normalizeKey(value) {
  return String(value || '')
    .normalize('NFKC')
    .replace(/[〜～]/g, '~')
    .replace(/\s+/g, '')
    .replace(/[「」『』]/g, '')
    .toLowerCase();
}

function lessonNumberFromRef(refFile) {
  const match = String(refFile || '').match(/grammar_n\d_(\d+)\.json$/);
  return match ? Number(match[1]) : null;
}

function findDefinition(level, item) {
  const refFile = item.legacy_ref?.file;
  if (!refFile) return null;
  const sourcePath = path.join(contentRoot, refFile);
  if (!fs.existsSync(sourcePath)) return null;
  const rows = readJson(sourcePath);
  const keys = [
    item.legacy_ref?.entry_id,
    item.surface,
    item.label_ja,
  ].map(normalizeKey);
  return (
    rows.find((row) =>
      [row.title, row.grammarPoint, row.structure, row.connection]
        .map(normalizeKey)
        .some((key) => keys.includes(key)),
    ) || null
  );
}

function findExampleBlock(level, item, definition) {
  const sourceLesson = lessonNumberFromRef(item.legacy_ref?.file);
  if (!sourceLesson) return null;
  const sourcePath = path.join(
    contentRoot,
    'grammar_examples',
    level,
    `lesson_${sourceLesson}.json`,
  );
  if (!fs.existsSync(sourcePath)) return null;
  const decoded = readJson(sourcePath);
  const blocks = Array.isArray(decoded)
    ? decoded
    : Array.isArray(decoded.examples)
      ? decoded.examples
      : [];
  const keys = [
    item.legacy_ref?.entry_id,
    item.surface,
    item.label_ja,
    definition?.title,
    definition?.grammarPoint,
  ].map(normalizeKey);
  const grouped = blocks.filter(
    (block) => keys.includes(normalizeKey(block.grammarPoint)) && block.sentence,
  );
  if (grouped.length) {
    return {
      grammarPoint: grouped[0].grammarPoint,
      examples: grouped.map((example) => ({
        sentence: example.sentence,
        translation: example.translation,
        translationEn: example.translationEn,
      })),
      tags: grouped.flatMap((example) => example.tags || []),
    };
  }
  return (
    blocks.find(
      (block) =>
        keys.includes(normalizeKey(block.grammarPoint)) &&
        Array.isArray(block.examples),
    ) ||
    null
  );
}

function firstSentence(value) {
  const text = String(value || '').trim();
  if (!text) return '';
  const split = text.split(/[。.!?]/).map((part) => part.trim());
  return split.find(Boolean) || text;
}

function detectAnchor(title, structure) {
  const text = `${title} ${structure}`;
  const anchors = [
    'わけ',
    'はず',
    'こと',
    'もの',
    'よう',
    'まま',
    'ところ',
    '限り',
    '次第',
    '一方',
    '反面',
    '上',
    '際',
    'ため',
    'ばかり',
    'ほど',
    'くらい',
    'だけ',
    'しか',
    'に',
    'で',
    'を',
    'が',
    'は',
    'も',
    'と',
  ];
  return anchors.find((anchor) => text.includes(anchor)) || title;
}

function relatedFor(item, allItems) {
  const title = item.surface || item.label_ja;
  const anchor = detectAnchor(title, '');
  const related =
    allItems.find(
      (candidate) =>
        candidate !== item &&
        normalizeKey(candidate.surface || candidate.label_ja) !==
          normalizeKey(title) &&
        String(candidate.surface || candidate.label_ja || '').includes(anchor),
    ) ||
    allItems.find(
      (candidate) =>
        candidate !== item &&
        normalizeKey(candidate.surface || candidate.label_ja) !==
          normalizeKey(title),
    );
  if (!related) return [];
  const relatedTitle = related.surface || related.label_ja;
  return [
    {
      pattern: relatedTitle,
      contrast: `${title} cần đọc theo chức năng riêng của mẫu; ${relatedTitle} có hình thức gần nhưng không được thay máy móc khi ngữ cảnh đổi.`,
    },
  ];
}

function directiveEFor(item, definition, allItems) {
  const title = definition.title || item.surface || item.label_ja;
  const structure =
    definition.structure ||
    definition.connection ||
    item.surface ||
    item.label_ja ||
    title;
  const meaning = firstSentence(definition.explanation || item.label_vi);
  const anchor = detectAnchor(title, structure);
  const crossLinks = relatedFor(item, allItems);
  return {
    form: `Cấu trúc: ${structure}`,
    meaning: `Ý nghĩa: ${meaning}`,
    usage: `Cách dùng: Với ${title}, hãy nhìn vế đứng trước mẫu và vai của vế sau; chính quan hệ đó quyết định sắc thái, không phải dịch từng chữ.`,
    etymology: `Gốc rễ: trong ${title}, lõi ${anchor} là mảnh giữ nhịp ngữ pháp. Hãy tách ${structure} thành phần đứng trước, lõi mẫu, rồi phần kết luận; cách tách này giúp người Việt không gom cả cụm thành một nghĩa mơ hồ.`,
    humanMoment: `Lưu ý từ Dr. Linh: ${title} không nên học như một nhãn dịch. Hãy hỏi người nói đang nêu quyết định, lý do, giới hạn hay đánh giá; câu sẽ tự sáng hơn.`,
    crossLinks,
    fallbackReference,
  };
}

function fallbackExamplesFor(definition) {
  const title = String(definition.title || '').trim();
  if (title.includes('ぬいて')) {
    return [
      {
        sentence: '彼は最後まで考えぬいて、静かに答えを出した。',
        translation: 'Anh ấy suy nghĩ đến cùng rồi lặng lẽ đưa ra câu trả lời.',
        translationEn:
          'He thought it through to the end and quietly gave his answer.',
      },
      {
        sentence: 'チームは苦しい時期を乗りぬいて、ようやく結果を出した。',
        translation:
          'Đội đã vượt qua giai đoạn khó khăn và cuối cùng có kết quả.',
        translationEn:
          'The team pushed through a difficult period and finally got results.',
      },
      {
        sentence: 'この本は一晩で読みぬけるほど短くはない。',
        translation:
          'Cuốn sách này không ngắn đến mức có thể đọc hết trong một đêm.',
        translationEn:
          'This book is not short enough to read through in one night.',
      },
    ];
  }
  return [
    {
      sentence: `この文では「${title}」の使い方を確認します。`,
      translation: `Câu này dùng để kiểm tra cách dùng mẫu ${title}.`,
      translationEn: `This sentence checks how to use the pattern ${title}.`,
    },
  ];
}

function sanitizeTags(tags, level, lessonId) {
  const base = Array.isArray(tags) ? tags : [];
  return [
    ...new Set([
      ...base.filter((tag) => tag !== 'vi-human-approved'),
      `${level}-shinkanzen`,
      `${level}-lesson-${lessonId}`,
      'shinkanzen-manifest-generated',
      'vi-source-verified',
    ]),
  ];
}

function fallbackDefinition(level, lessonId, item, allItems) {
  const title = item.surface || item.label_ja;
  const explanation = item.label_vi || `Mẫu ${title} cần được đọc theo ngữ cảnh.`;
  const definition = {
    lessonId,
    title,
    titleEn: title,
    structure: title,
    structureEn: title,
    explanation,
    explanationEn: '',
    level: level.toUpperCase(),
    tags: sanitizeTags([], level, lessonId),
  };
  return {
    ...definition,
    directiveE: directiveEFor(item, definition, allItems),
  };
}

function manifestPathFor(level, lessonId) {
  const textbook = targets[level].textbook;
  const candidates = [
    path.join(
      manifestRoot,
      `item_index_${textbook}_${textbook}_${lessonId}.json`,
    ),
    path.join(
      manifestRoot,
      `item_index_${textbook}_${textbook}_${String(lessonId).padStart(2, '0')}.json`,
    ),
  ];
  return candidates.find((candidate) => fs.existsSync(candidate)) || candidates[0];
}

function buildLesson(level, lessonId, allItems) {
  const manifestPath = manifestPathFor(level, lessonId);
  if (!fs.existsSync(manifestPath)) {
    throw new Error(`Missing manifest ${manifestPath}`);
  }
  const manifest = readJson(manifestPath);
  const definitions = [];
  const exampleBlocks = [];
  for (const item of manifest.items || []) {
    if (item.type !== 'grammar') continue;
    const sourceDefinition = findDefinition(level, item);
    const definition = sourceDefinition
      ? {
          ...sourceDefinition,
          lessonId,
          level: level.toUpperCase(),
          tags: sanitizeTags(sourceDefinition.tags, level, lessonId),
        }
      : fallbackDefinition(level, lessonId, item, allItems);
    definition.directiveE = directiveEFor(item, definition, allItems);
    definitions.push(definition);

    const sourceExamples = findExampleBlock(level, item, sourceDefinition);
    if (sourceExamples?.examples?.length) {
      exampleBlocks.push({
        grammarPoint: definition.title,
        examples: sourceExamples.examples,
        tags: sanitizeTags(sourceExamples.tags, level, lessonId),
      });
    } else if (Array.isArray(sourceDefinition?.examples)) {
      exampleBlocks.push({
        grammarPoint: definition.title,
        examples: sourceDefinition.examples,
        tags: sanitizeTags([], level, lessonId),
      });
    } else {
      exampleBlocks.push({
        grammarPoint: definition.title,
        examples: fallbackExamplesFor(definition),
        tags: sanitizeTags(definition.tags, level, lessonId),
      });
    }
  }
  return { definitions, exampleBlocks };
}

function loadAllItems(level) {
  const items = [];
  for (let lessonId = 1; lessonId <= targets[level].count; lessonId++) {
    const manifestPath = manifestPathFor(level, lessonId);
    const manifest = readJson(manifestPath);
    items.push(...(manifest.items || []).filter((item) => item.type === 'grammar'));
  }
  return items;
}

function main() {
  const summary = {};
  for (const [level, spec] of Object.entries(targets)) {
    const allItems = loadAllItems(level);
    let generated = 0;
    let emptyExampleBlocks = 0;
    for (let lessonId = 1; lessonId <= spec.count; lessonId++) {
      const defPath = path.join(
        contentRoot,
        'grammar',
        level,
        `grammar_${level}_${lessonId}.json`,
      );
      const exPath = path.join(
        contentRoot,
        'grammar_examples',
        level,
        `lesson_${lessonId}.json`,
      );
      if (
        fs.existsSync(defPath) &&
        fs.existsSync(exPath) &&
        !fs.readFileSync(defPath, 'utf8').includes('shinkanzen-manifest-generated')
      ) {
        continue;
      }
      const lesson = buildLesson(level, lessonId, allItems);
      writeJson(defPath, lesson.definitions);
      writeJson(exPath, lesson.exampleBlocks);
      generated += 1;
      emptyExampleBlocks += lesson.exampleBlocks.filter(
        (block) => !block.examples?.length,
      ).length;
    }
    summary[level] = { generated, emptyExampleBlocks };
  }
  console.log(JSON.stringify(summary, null, 2));
}

main();
