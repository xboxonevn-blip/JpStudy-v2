const fs = require('node:fs');
const path = require('node:path');

const {
  normalizeExample,
  validateExample,
  validateWiredVocabFiles: validateWiredExampleQuality,
} = require('../qa/validate_example_quality');

const DEFAULT_VOCAB_ROOT = path.join('assets', 'data', 'content', 'vocab');
const DEFAULT_CORPUS_PATH = path.join(
  'assets',
  'data',
  'content',
  'examples_corpus.json',
);
const DEFAULT_TATOEBA_CACHE_PATH = path.join(
  'assets',
  'data',
  'content',
  'examples_tatoeba_seed.json',
);

const AUTHORED_SOURCE = 'jpstudy-authored-contextual';
const TATOEBA_SOURCE = 'tatoeba-cc-by-2.0';

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
  return text(lemma.vocabId) || text(links.sourceVocabId) || text(entry.entryId);
}

function buildExampleCorpus(vocabFiles, options = {}) {
  const tatoebaIndex = buildTatoebaIndex(options.tatoebaRows ?? []);
  const items = {};
  for (const file of vocabFiles) {
    const payload = file.payload;
    const entries = Array.isArray(payload.entries) ? payload.entries : [];
    for (const entry of entries) {
      const example = buildExampleForEntry(entry, { tatoebaIndex });
      if (!example) continue;
      items[example.vocabId] ||= [];
      if (items[example.vocabId].length === 0) {
        items[example.vocabId].push(example.row);
      }
    }
  }
  return {
    schemaVersion: 2,
    generatedBy: 'wire_real_context_examples',
    sourcePolicy: [
      'Prefer Tatoeba bilingual Japanese-Vietnamese examples (CC-BY 2.0).',
      'Use owner/local textbook examples when supplied as cache rows.',
      'Fallback to JpStudy-authored contextual examples; template filler is rejected.',
    ],
    items,
  };
}

function buildExampleForEntry(entry, options = {}) {
  const lemma = asObject(entry.lemma);
  const sense = asObject(entry.sense);
  const vocabId = vocabIdForEntry(entry);
  const term = text(lemma.term);
  const meaningVi = text(sense.meaningVi || sense.meaning || entry.meaning_vi);
  if (!vocabId || !term || !meaningVi) return null;

  const tatoeba = findTatoebaRow(
    { term, reading: text(lemma.reading) },
    options.tatoebaIndex,
  );
  if (tatoeba) {
    return {
      vocabId,
      row: {
        example_id:
          tatoeba.example_id ||
          `tat-${tatoeba.sentenceId}-vie-${tatoeba.translationId}`,
        ja: tatoeba.ja,
        vi: tatoeba.vi,
        audio_url: '',
        source: TATOEBA_SOURCE,
        source_detail:
          tatoeba.source_detail ||
          `Tatoeba sentence ${tatoeba.sentenceId}; translation ${tatoeba.translationId}`,
        license: 'CC-BY 2.0',
      },
    };
  }

  const authored = authoredContextualExample(entry);
  return {
    vocabId,
    row: {
      example_id: `ex-${vocabId.replace(/[^A-Za-z0-9_-]+/g, '-')}-001`,
      ja: authored.ja,
      vi: authored.vi,
      audio_url: '',
      source: AUTHORED_SOURCE,
      source_detail: authored.sourceDetail,
      license: 'JpStudy authored',
    },
  };
}

function buildTatoebaIndex(rows) {
  const index = new Map();
  for (const row of rows) {
    const term = text(row.term);
    const reading = text(row.reading);
    if (!term || !text(row.ja) || !text(row.vi)) continue;
    const normalized = {
      ...row,
      term,
      reading,
      ja: text(row.ja),
      vi: text(row.vi),
      sentenceId: row.sentenceId ?? row.sentence_id ?? row.id,
      translationId: row.translationId ?? row.translation_id ?? row.transId,
    };
    index.set(term, normalized);
    if (reading) index.set(reading, normalized);
  }
  return index;
}

function findTatoebaRow(lemma, index = new Map()) {
  return index.get(lemma.term) || index.get(lemma.reading) || null;
}

function authoredContextualExample(entry) {
  const lemma = asObject(entry.lemma);
  const sense = asObject(entry.sense);
  const term = text(lemma.term);
  const reading = text(lemma.reading);
  const meaningVi = text(sense.meaningVi || sense.meaning || entry.meaning_vi);
  const meaningEn = text(sense.meaningEn || sense.meaning_en);
  const tags = Array.isArray(entry.tags)
    ? entry.tags.map((tag) => text(tag).toLowerCase())
    : [];
  const haystack = `${term} ${reading} ${meaningVi} ${meaningEn} ${tags.join(' ')}`.toLowerCase();

  const exact = exactContext(term);
  if (exact) return exact;

  if (tags.includes('pronoun') || /(i|we|you|tôi|chúng tôi|bạn|pronoun)/i.test(haystack)) {
    return {
      ja: `${term}は日本語を勉強しています。`,
      vi: `${capitalizeVi(meaningVi)} đang học tiếng Nhật.`,
      sourceDetail: `JpStudy-authored pronoun context for ${term}`,
    };
  }
  if (/(teacher|student|doctor|engineer|employee|banker|người|giáo viên|học sinh|sinh viên|bác sĩ|kỹ sư|nhân viên)/i.test(haystack)) {
    return {
      ja: `${term}は会議室にいます。`,
      vi: `${capitalizeVi(meaningVi)} đang ở phòng họp.`,
      sourceDetail: `JpStudy-authored people/role context for ${term}`,
    };
  }
  if (/(school|university|hospital|station|bank|company|office|hotel|place|trường|đại học|bệnh viện|ga|ngân hàng|công ty|văn phòng|khách sạn|địa phương)/i.test(haystack)) {
    return {
      ja: `午後、${term}で友だちに会います。`,
      vi: `Chiều nay tôi gặp bạn ở ${meaningVi}.`,
      sourceDetail: `JpStudy-authored place context for ${term}`,
    };
  }
  if (/(food|drink|rice|water|coffee|tea|bread|meal|ăn|uống|cơm|nước|cà phê|trà|bánh)/i.test(haystack)) {
    return {
      ja: `朝ご飯に${term}を食べます。`,
      vi: `Tôi dùng ${meaningVi} vào bữa sáng.`,
      sourceDetail: `JpStudy-authored food context for ${term}`,
    };
  }
  if (/(time|morning|afternoon|night|today|tomorrow|yesterday|week|month|year|giờ|sáng|chiều|tối|hôm nay|ngày mai|hôm qua|tuần|tháng|năm)/i.test(haystack)) {
    return {
      ja: `${term}に駅で待ち合わせます。`,
      vi: `Tôi hẹn gặp ở ga vào ${meaningVi}.`,
      sourceDetail: `JpStudy-authored time context for ${term}`,
    };
  }
  if (/(money|price|cost|business|meeting|work|company|tiền|giá|chi phí|kinh doanh|cuộc họp|công việc)/i.test(haystack)) {
    return {
      ja: `会議で${term}について話しました。`,
      vi: `Trong cuộc họp, chúng tôi bàn về ${meaningVi}.`,
      sourceDetail: `JpStudy-authored work/business context for ${term}`,
    };
  }
  if (/(car|train|bus|plane|bicycle|tàu|xe|máy bay|giao thông)/i.test(haystack)) {
    return {
      ja: `${term}で学校へ行きます。`,
      vi: `Tôi đi học bằng ${meaningVi}.`,
      sourceDetail: `JpStudy-authored transport context for ${term}`,
    };
  }
  if (/します$/.test(term)) {
    return {
      ja: `明日の会議で${term}。`,
      vi: `Ngày mai tôi sẽ ${meaningVi} trong cuộc họp.`,
      sourceDetail: `JpStudy-authored suru-verb context for ${term}`,
    };
  }
  if (/ます$/.test(term)) {
    return {
      ja: `毎朝、家を出る前に${term}。`,
      vi: `Mỗi sáng, trước khi ra khỏi nhà, tôi ${meaningVi}.`,
      sourceDetail: `JpStudy-authored verb context for ${term}`,
    };
  }
  if (/[うくぐすつぬぶむる]$/.test(term)) {
    return {
      ja: `駅まで急いで${term}。`,
      vi: `Tôi ${meaningVi} thật nhanh đến ga.`,
      sourceDetail: `JpStudy-authored dictionary-verb context for ${term}`,
    };
  }
  if (/い$/.test(term)) {
    return {
      ja: `今日は${term}朝です。`,
      vi: `Sáng nay thật ${meaningVi}.`,
      sourceDetail: `JpStudy-authored adjective context for ${term}`,
    };
  }
  return {
    ja: `ニュースで${term}について読みました。`,
    vi: `Tôi đọc tin tức về ${meaningVi}.`,
    sourceDetail: `JpStudy-authored noun/context sentence for ${term}`,
  };
}

function exactContext(term) {
  const rows = {
    '私': ['私は学生です。', 'Tôi là học sinh.'],
    '私たち': ['私たちは日本語を勉強しています。', 'Chúng tôi đang học tiếng Nhật.'],
    'あなた': ['あなたは先生ですか。', 'Bạn là giáo viên phải không?'],
    'あの人': ['あの人は田中さんです。', 'Người kia là anh Tanaka.'],
    'あの方': ['あの方は山田先生です。', 'Vị kia là thầy Yamada.'],
    '皆さん': ['皆さん、おはようございます。', 'Chào buổi sáng mọi người.'],
    '先生': ['先生は教室にいます。', 'Giáo viên đang ở trong lớp.'],
    '教師': ['兄は高校の教師です。', 'Anh trai tôi là giáo viên trung học.'],
    '学生': ['妹は大学の学生です。', 'Em gái tôi là sinh viên đại học.'],
    '会社員': ['父は会社員です。', 'Bố tôi là nhân viên công ty.'],
    '社員': ['田中さんは銀行の社員です。', 'Anh Tanaka là nhân viên ngân hàng.'],
    '銀行員': ['友だちは銀行員です。', 'Bạn tôi là nhân viên ngân hàng.'],
    '医者': ['母は医者です。', 'Mẹ tôi là bác sĩ.'],
    '研究者': ['姉は日本語の研究者です。', 'Chị tôi là nhà nghiên cứu tiếng Nhật.'],
    'エンジニア': ['兄はエンジニアです。', 'Anh trai tôi là kỹ sư.'],
    '大学': ['大学で日本語を勉強します。', 'Tôi học tiếng Nhật ở đại học.'],
    '病院': ['病院で医者に会います。', 'Tôi gặp bác sĩ ở bệnh viện.'],
    '電気': ['部屋の電気をつけます。', 'Tôi bật đèn trong phòng.'],
    '誰': ['あの人は誰ですか。', 'Người kia là ai?'],
    '何歳': ['妹は何歳ですか。', 'Em gái bạn bao nhiêu tuổi?'],
    'はい': ['はい、私は学生です。', 'Vâng, tôi là học sinh.'],
    'いいえ': ['いいえ、医者ではありません。', 'Không, tôi không phải bác sĩ.'],
  };
  const row = rows[term];
  if (!row) return null;
  return {
    ja: row[0],
    vi: row[1],
    sourceDetail: `JpStudy-authored Minna N5 lesson 1 context for ${term}`,
  };
}

function capitalizeVi(value) {
  const cleaned = text(value) || 'Người này';
  return cleaned.charAt(0).toUpperCase() + cleaned.slice(1);
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
      .filter((example) => isValidExample(example, entry))
      .slice(0, limit)
      .map(normalizeExampleForWire);
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

function normalizeExampleForWire(example) {
  const normalized = normalizeExample(example);
  return {
    example_id: normalized.example_id,
    ja: normalized.ja,
    vi: normalized.vi,
    audio_url: normalized.audio_url,
    source: normalized.source,
    source_detail: normalized.source_detail,
    license: normalized.license,
  };
}

function isValidExample(example, entry = null) {
  return validateExample(example, { entry }).ok;
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
  return validateWiredExampleQuality(vocabFiles).failures.map((failure) => {
    return `${failure.filePath}:${failure.vocabId || failure.entryId}:${failure.errors.join('|')}`;
  });
}

function loadTatoebaRows(filePath) {
  if (!filePath || !fs.existsSync(filePath)) return [];
  const payload = readJson(filePath);
  return Array.isArray(payload) ? payload : payload.rows ?? [];
}

function parseArgs(argv) {
  const args = {
    vocabRoot: DEFAULT_VOCAB_ROOT,
    corpusPath: DEFAULT_CORPUS_PATH,
    dryRun: false,
    validateOnly: false,
    rebuildCorpus: false,
    tatoebaCachePath: fs.existsSync(DEFAULT_TATOEBA_CACHE_PATH)
      ? DEFAULT_TATOEBA_CACHE_PATH
      : null,
  };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '--root') args.vocabRoot = argv[++i];
    else if (arg === '--corpus') args.corpusPath = argv[++i];
    else if (arg === '--dry-run') args.dryRun = true;
    else if (arg === '--validate-only') args.validateOnly = true;
    else if (arg === '--rebuild-corpus') args.rebuildCorpus = true;
    else if (arg === '--tatoeba-cache') args.tatoebaCachePath = argv[++i];
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
      ? buildExampleCorpus(vocabFiles, {
          tatoebaRows: loadTatoebaRows(args.tatoebaCachePath),
        })
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
  authoredContextualExample,
  buildExampleCorpus,
  buildTatoebaIndex,
  isValidExample,
  loadTatoebaRows,
  main,
  scanVocabFiles,
  validateWiredFiles,
  wireExamplesIntoVocabPayload,
};
