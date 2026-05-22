const fs = require('node:fs');
const path = require('node:path');

const DEFAULT_CORPUS_PATH = path.join(
  'assets',
  'data',
  'content',
  'examples_corpus.json',
);
const DEFAULT_VOCAB_ROOT = path.join('assets', 'data', 'content', 'vocab');
const DEFAULT_CONTENT_ROOT = path.join('assets', 'data', 'content');

const BANNED_JA_PATTERNS = [
  /を使う文を/,
  /文を一つ作り/,
  /を使った文/,
  /記事では[^。"\n]+が具体例として取り上げられました。?/,
  /今日の練習に入れます/,
  /この場面では「[^」]+」と言えます/,
  /授業で「[^」]+」/,
  /^資料には.+の説明が載っています。?$/,
  /^.+の入口で友だちに会いました。?$/,
  /^彼は最後まで.+姿勢を見せました。?$/,
  /^会議では.+が重要な論点になりました。?$/,
  /^朝ご飯に.+を食べます。?$/,
  /^.+に駅で待ち合わせます。?$/,
  /^毎朝、家を出る前に.+。?$/,
  /^週末に.+予定です。?$/,
  /^受付で「.+」と丁寧に言いました。?$/,
  /^ニュースで.+について読みました。?$/,
  /^午後、.+で友だちに会います。?$/,
  /^会議で.+について話しました。?$/,
  /^困ったときは、すぐにあきらめず.+こともあります。?$/,
];

const BANNED_VI_PATTERNS = [
  /Trong giờ học,\s*tôi dùng/i,
  /với nghĩa/i,
  /trong một câu ngắn/i,
  /Bài viết đã nêu .+ như một ví dụ cụ thể\.?/i,
];

const CONTENT_SCAN_PATTERNS = [
  ...BANNED_JA_PATTERNS,
  /Trong giờ học,\s*tôi dùng/i,
  /trong một câu ngắn/i,
];

function text(value) {
  return `${value ?? ''}`.trim();
}

function asObject(value) {
  return value && typeof value === 'object' && !Array.isArray(value)
    ? value
    : {};
}

function vocabIdForEntry(entry) {
  const lemma = asObject(entry?.lemma);
  const links = asObject(entry?.links);
  return text(lemma.vocabId) || text(links.sourceVocabId) || text(entry?.entryId);
}

function normalizeExample(example) {
  return {
    example_id: text(example?.example_id || example?.exampleId),
    ja: text(example?.ja),
    vi: text(example?.vi),
    audio_url: text(example?.audio_url || example?.audioUrl),
    source: text(example?.source),
    source_detail: text(example?.source_detail || example?.sourceDetail),
    license: text(example?.license),
  };
}

function validateExample(example, options = {}) {
  const normalized = normalizeExample(example);
  const entry = options.entry ?? null;
  const errors = [];
  const term = text(entry?.lemma?.term);
  const reading = text(entry?.lemma?.reading);

  if (!normalized.example_id) errors.push('missing example_id');
  if (!normalized.ja) errors.push('missing ja');
  if (!normalized.vi) errors.push('missing vi');
  if (!normalized.source) errors.push('missing source');

  for (const pattern of BANNED_JA_PATTERNS) {
    if (pattern.test(normalized.ja)) {
      errors.push(`banned Japanese template: ${pattern}`);
    }
  }
  for (const pattern of BANNED_VI_PATTERNS) {
    if (pattern.test(normalized.vi)) {
      errors.push(`banned Vietnamese template: ${pattern}`);
    }
  }

  if (term && !containsTerm(normalized.ja, term, reading)) {
    errors.push(`Japanese example does not contain term: ${term}`);
  }

  if (/^tatoeba/i.test(normalized.source)) {
    if (!/CC-BY 2\.0/i.test(normalized.license)) {
      errors.push('Tatoeba example missing CC-BY 2.0 license');
    }
    if (!/Tatoeba sentence \d+/i.test(normalized.source_detail)) {
      errors.push('Tatoeba example missing sentence attribution');
    }
  }

  if (/jpstudy-authored-contextual/.test(normalized.source)) {
    if (!/JpStudy authored/i.test(normalized.license)) {
      errors.push('authored example missing JpStudy authored license');
    }
    if (!normalized.source_detail) {
      errors.push('authored example missing source_detail');
    }
    if (/pronoun context/i.test(normalized.source_detail) && !isPronounEntry(entry)) {
      errors.push('authored pronoun context used for non-pronoun entry');
    }
    if (
      term &&
      !isPronounEntry(entry) &&
      normalized.ja.includes(`${term}は日本語を勉強しています`)
    ) {
      errors.push('non-pronoun authored study frame');
    }
    if (/residual context/i.test(normalized.source_detail)) {
      errors.push('residual authored context');
    }
  }

  if (isSubstitutionTemplate(normalized, term)) {
    errors.push('substitution test failed: sentence is term-swap template');
  }

  return { ok: errors.length === 0, errors, example: normalized };
}

function isPronounEntry(entry) {
  if (!entry) return false;
  const lemma = asObject(entry.lemma);
  const term = text(lemma.term);
  const tags = Array.isArray(entry.tags)
    ? entry.tags.map((tag) => text(tag).toLowerCase())
    : [];
  if (tags.includes('pronoun')) return true;
  const sense = asObject(entry.sense);
  const meaningEn = text(sense.meaningEn || sense.meaning_en).toLowerCase();
  const meaningVi = text(sense.meaningVi || sense.meaning_vi).toLowerCase();
  const compactEn = meaningEn.replace(/\([^)]*\)/g, '').trim();
  if (
    inferredPronounTerms().has(term) &&
    ['i', 'me', 'we', 'us', 'you', 'he', 'she', 'they', 'them', 'everyone', 'that person'].includes(compactEn)
  ) {
    return true;
  }
  const firstVi = meaningVi.split(/[;,/]+/)[0]?.trim() ?? '';
  return inferredPronounTerms().has(term) && ['tôi', 'chúng tôi', 'bạn', 'người kia', 'vị kia', 'mọi người'].includes(firstVi);
}

function containsTerm(ja, term, reading) {
  if (!term) return true;
  if (ja.includes(term)) return true;
  if (term.includes('～')) {
    const stem = term.replace(/～/g, '');
    if (stem && ja.includes(stem)) return true;
  }
  if (/[うくぐすつぬぶむる]$/.test(term)) {
    const stem = term.slice(0, -1);
    if ((stem.length >= 2 || /[\u3400-\u9fff]/.test(stem)) && ja.includes(stem)) {
      return true;
    }
  }
  if (reading && reading !== term && ja.includes(reading)) return true;
  return false;
}

function inferredPronounTerms() {
  return new Set([
    '私',
    '私たち',
    'あなた',
    'あの人',
    'あの方',
    '皆さん',
    '誰',
    '俺',
    '貴女',
    '君',
    '皆',
    '僕',
    'この～',
    'その～',
    'あの～',
  ]);
}

function isSubstitutionTemplate(example, term) {
  const ja = example.ja;
  if (!term) return false;
  if (ja.includes(`「${term}」`) && /(使う|文|意味|言えます|練習に入れます)/.test(ja)) {
    return true;
  }
  const escaped = escapeRegExp(term);
  const genericFrames = [
    new RegExp(`^.*${escaped}.*練習に入れます.*$`),
    new RegExp(`^.*${escaped}.*言えます。?$`),
    new RegExp(`^.*${escaped}.*文を(一つ)?(作|書).*$`),
    new RegExp(`^.*${escaped}.*使う文.*$`),
  ];
  return genericFrames.some((pattern) => pattern.test(ja));
}

function validateCorpus(corpus, options = {}) {
  const entriesByVocabId = options.entriesByVocabId ?? new Map();
  const failures = [];
  for (const [vocabId, rows] of Object.entries(corpus?.items ?? {})) {
    if (!Array.isArray(rows) || rows.length === 0) {
      failures.push({ vocabId, errors: ['missing rows'] });
      continue;
    }
    const entry = entriesByVocabId.get(vocabId);
    for (const row of rows) {
      const result = validateExample(row, { entry });
      if (!result.ok) {
        failures.push({ vocabId, exampleId: row?.example_id, errors: result.errors });
      }
    }
  }
  return { ok: failures.length === 0, failures };
}

function scanVocabFiles(root = DEFAULT_VOCAB_ROOT) {
  const files = [];
  if (!fs.existsSync(root)) return files;
  function visit(dir) {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        visit(fullPath);
      } else if (entry.isFile() && entry.name.endsWith('.json') && entry.name !== 'index.json') {
        const payload = readJson(fullPath);
        if (Array.isArray(payload.entries)) files.push({ filePath: fullPath, payload });
      }
    }
  }
  visit(root);
  return files.sort((a, b) => a.filePath.localeCompare(b.filePath));
}

function entriesByVocabId(vocabFiles) {
  const map = new Map();
  for (const file of vocabFiles) {
    for (const entry of file.payload.entries ?? []) {
      const vocabId = vocabIdForEntry(entry);
      if (vocabId) map.set(vocabId, entry);
    }
  }
  return map;
}

function validateWiredVocabFiles(vocabFiles) {
  const failures = [];
  for (const file of vocabFiles) {
    for (const entry of file.payload.entries ?? []) {
      const rows = Array.isArray(entry.example_sentences) ? entry.example_sentences : [];
      if (rows.length === 0) {
        failures.push({
          filePath: file.filePath,
          vocabId: vocabIdForEntry(entry),
          errors: ['missing example_sentences'],
        });
        continue;
      }
      for (const row of rows) {
        const result = validateExample(row, { entry });
        if (!result.ok) {
          failures.push({
            filePath: file.filePath,
            vocabId: vocabIdForEntry(entry),
            exampleId: row?.example_id,
            errors: result.errors,
          });
        }
      }
    }
  }
  return { ok: failures.length === 0, failures };
}

function validateAllContentTemplates(root = DEFAULT_CONTENT_ROOT) {
  const failures = [];
  if (!fs.existsSync(root)) return { ok: true, failures };
  const banned = CONTENT_SCAN_PATTERNS;
  function visit(dir) {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        visit(fullPath);
        continue;
      }
      if (!entry.isFile() || !/\.(json|md)$/i.test(entry.name)) continue;
      const body = fs.readFileSync(fullPath, 'utf8');
      for (const pattern of banned) {
        if (pattern.test(body)) {
          failures.push({ filePath: fullPath, errors: [`banned template: ${pattern}`] });
          break;
        }
      }
    }
  }
  visit(root);
  return { ok: failures.length === 0, failures };
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function escapeRegExp(value) {
  return `${value}`.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function parseArgs(argv) {
  const args = {
    corpusPath: DEFAULT_CORPUS_PATH,
    vocabRoot: DEFAULT_VOCAB_ROOT,
    contentRoot: DEFAULT_CONTENT_ROOT,
    contentScan: true,
  };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '--corpus') args.corpusPath = argv[++i];
    else if (arg === '--root') args.vocabRoot = argv[++i];
    else if (arg === '--content-root') args.contentRoot = argv[++i];
    else if (arg === '--no-content-scan') args.contentScan = false;
  }
  return args;
}

function main(argv = process.argv.slice(2)) {
  const args = parseArgs(argv);
  const vocabFiles = scanVocabFiles(args.vocabRoot);
  const failures = [];

  if (fs.existsSync(args.corpusPath)) {
    const corpusResult = validateCorpus(readJson(args.corpusPath), {
      entriesByVocabId: entriesByVocabId(vocabFiles),
    });
    failures.push(...corpusResult.failures.map((failure) => ({
      scope: 'corpus',
      ...failure,
    })));
  } else {
    failures.push({ scope: 'corpus', vocabId: '', errors: ['missing corpus'] });
  }

  const wiredResult = validateWiredVocabFiles(vocabFiles);
  failures.push(...wiredResult.failures.map((failure) => ({
    scope: 'vocab',
    ...failure,
  })));

  if (args.contentScan) {
    const contentResult = validateAllContentTemplates(args.contentRoot);
    failures.push(...contentResult.failures.map((failure) => ({
      scope: 'content',
      ...failure,
    })));
  }

  if (failures.length > 0) {
    console.error(`Example quality failures: ${failures.length}`);
    for (const failure of failures.slice(0, 40)) {
      console.error(JSON.stringify(failure));
    }
    return 1;
  }

  console.log(`Validated example quality for ${vocabFiles.length} vocab files.`);
  return 0;
}

if (require.main === module) {
  process.exitCode = main();
}

module.exports = {
  BANNED_JA_PATTERNS,
  BANNED_VI_PATTERNS,
  entriesByVocabId,
  normalizeExample,
  isPronounEntry,
  validateAllContentTemplates,
  validateCorpus,
  validateExample,
  validateWiredVocabFiles,
  vocabIdForEntry,
};
