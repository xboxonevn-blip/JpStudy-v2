const fs = require('node:fs');
const path = require('node:path');

const DEFAULT_VOCAB_ROOT = path.join(
  'assets',
  'data',
  'content',
  'vocab',
);
const DEFAULT_CORPUS_PATH = path.join(
  'assets',
  'data',
  'content',
  'examples_corpus.json',
);
const SOURCE = 'original-jpstudy';

function asObject(value) {
  return value && typeof value === 'object' && !Array.isArray(value)
    ? value
    : {};
}

function text(value) {
  return `${value ?? ''}`.trim();
}

function vocabIdForEntry(entry) {
  const lemma = asObject(entry.lemma);
  const links = asObject(entry.links);
  return (
    text(lemma.vocabId) ||
    text(links.sourceVocabId) ||
    text(entry.entryId)
  );
}

function buildExampleCorpus(vocabFiles) {
  const items = {};
  for (const file of vocabFiles) {
    const payload = file.payload;
    const entries = Array.isArray(payload.entries) ? payload.entries : [];
    for (const entry of entries) {
      const example = buildExampleForEntry(entry);
      if (!example) continue;
      items[example.vocabId] ||= [];
      if (items[example.vocabId].length === 0) {
        items[example.vocabId].push(example.row);
      }
    }
  }
  return { schemaVersion: 1, generatedBy: 'wire_example_sentences', items };
}

function buildExampleForEntry(entry) {
  const lemma = asObject(entry.lemma);
  const sense = asObject(entry.sense);
  const vocabId = vocabIdForEntry(entry);
  const term = text(lemma.term);
  const meaningVi = text(sense.meaningVi || sense.meaning || entry.meaning_vi);
  if (!vocabId || !term || !meaningVi) return null;
  const safeId = vocabId.replace(/[^A-Za-z0-9_-]+/g, '-');
  return {
    vocabId,
    row: {
      example_id: `ex-${safeId}-001`,
      ja: japaneseExample(term),
      vi: vietnameseExample(term, meaningVi),
      audio_url: '',
      source: SOURCE,
    },
  };
}

function japaneseExample(term) {
  if (/する$/.test(term)) {
    return `${term}前に、目的を確認します。`;
  }
  if (/[うくぐすつぬぶむる]$/.test(term)) {
    return `${term}ことを、今日の練習に入れます。`;
  }
  if (/い$/.test(term)) {
    return `この場面では「${term}」と言えます。`;
  }
  return `授業で「${term}」を使う文を一つ作りました。`;
}

function vietnameseExample(term, meaningVi) {
  return `Trong giờ học, tôi dùng 「${term}」 với nghĩa "${meaningVi}" trong một câu ngắn.`;
}

function wireExamplesIntoVocabPayload(payload, corpus, options = {}) {
  const limit = options.limit ?? 2;
  const nextPayload = JSON.parse(JSON.stringify(payload));
  const entries = Array.isArray(nextPayload.entries) ? nextPayload.entries : [];
  const missing = [];
  let changed = false;
  for (const entry of entries) {
    const vocabId = vocabIdForEntry(entry);
    if (!vocabId) continue;
    const examples = corpus.items?.[vocabId];
    if (!Array.isArray(examples) || examples.length === 0) {
      missing.push(vocabId);
      continue;
    }
    const selected = examples
      .filter(isValidExample)
      .slice(0, limit)
      .map(normalizeExample);
    if (selected.length === 0) {
      missing.push(vocabId);
      continue;
    }
    if (JSON.stringify(entry.example_sentences ?? []) !== JSON.stringify(selected)) {
      entry.example_sentences = selected;
      changed = true;
    }
  }
  return { payload: nextPayload, changed, missing };
}

function normalizeExample(example) {
  return {
    example_id: text(example.example_id || example.exampleId),
    ja: text(example.ja),
    vi: text(example.vi),
    audio_url: text(example.audio_url || example.audioUrl),
    source: text(example.source || SOURCE),
  };
}

function isValidExample(example) {
  const normalized = normalizeExample(example);
  return (
    normalized.example_id.length > 0 &&
    normalized.ja.length > 0 &&
    normalized.vi.length > 0 &&
    normalized.source.length > 0
  );
}

function scanVocabFiles(root = DEFAULT_VOCAB_ROOT) {
  const files = [];
  function visit(dir) {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        visit(fullPath);
        continue;
      }
      if (!entry.isFile() || !entry.name.endsWith('.json')) continue;
      if (entry.name === 'index.json') continue;
      const payload = readJson(fullPath);
      if (Array.isArray(payload.entries)) {
        files.push({ filePath: fullPath, payload });
      }
    }
  }
  visit(root);
  files.sort((a, b) => a.filePath.localeCompare(b.filePath));
  return files;
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function writeJson(filePath, payload) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(payload, null, 2)}\n`, 'utf8');
}

function validateWiredFiles(vocabFiles) {
  const missing = [];
  for (const file of vocabFiles) {
    const entries = Array.isArray(file.payload.entries) ? file.payload.entries : [];
    for (const entry of entries) {
      const examples = Array.isArray(entry.example_sentences)
        ? entry.example_sentences
        : [];
      if (examples.length === 0 || !examples.every(isValidExample)) {
        missing.push(`${file.filePath}:${vocabIdForEntry(entry) || entry.entryId}`);
      }
    }
  }
  return missing;
}

function parseArgs(argv) {
  const args = {
    vocabRoot: DEFAULT_VOCAB_ROOT,
    corpusPath: DEFAULT_CORPUS_PATH,
    dryRun: false,
    validateOnly: false,
    rebuildCorpus: false,
  };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '--root') args.vocabRoot = argv[++i];
    else if (arg === '--corpus') args.corpusPath = argv[++i];
    else if (arg === '--dry-run') args.dryRun = true;
    else if (arg === '--validate-only') args.validateOnly = true;
    else if (arg === '--rebuild-corpus') args.rebuildCorpus = true;
  }
  return args;
}

function main(argv = process.argv.slice(2)) {
  const args = parseArgs(argv);
  const vocabFiles = scanVocabFiles(args.vocabRoot);
  if (args.validateOnly) {
    const missing = validateWiredFiles(vocabFiles);
    if (missing.length > 0) {
      console.error(`Missing/invalid example_sentences: ${missing.length}`);
      console.error(missing.slice(0, 20).join('\n'));
      return 1;
    }
    console.log(`Validated ${vocabFiles.length} vocab files.`);
    return 0;
  }

  const corpus =
    args.rebuildCorpus || !fs.existsSync(args.corpusPath)
      ? buildExampleCorpus(vocabFiles)
      : readJson(args.corpusPath);

  if (!args.dryRun) {
    writeJson(args.corpusPath, corpus);
  }

  const allMissing = [];
  let changedFiles = 0;
  for (const file of vocabFiles) {
    const result = wireExamplesIntoVocabPayload(file.payload, corpus);
    allMissing.push(...result.missing.map((id) => `${file.filePath}:${id}`));
    if (result.changed) {
      changedFiles += 1;
      if (!args.dryRun) writeJson(file.filePath, result.payload);
      file.payload = result.payload;
    }
  }

  const invalid = validateWiredFiles(vocabFiles);
  if (allMissing.length > 0 || invalid.length > 0) {
    console.error(`Missing corpus rows: ${allMissing.length}`);
    console.error(`Invalid wired rows: ${invalid.length}`);
    console.error([...allMissing, ...invalid].slice(0, 20).join('\n'));
    return 1;
  }

  console.log(
    `Wired examples: ${changedFiles} files, ${Object.keys(corpus.items).length} vocab ids.`,
  );
  return 0;
}

if (require.main === module) {
  process.exitCode = main();
}

module.exports = {
  buildExampleCorpus,
  wireExamplesIntoVocabPayload,
  scanVocabFiles,
  validateWiredFiles,
};
