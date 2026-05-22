const fs = require('node:fs');
const path = require('node:path');
const readline = require('node:readline');

const { scanVocabFiles } = require('../migration/wire_example_sentences');

const DEFAULT_SENTENCES_PATH = path.join('tmp', 'tatoeba', 'sentences.csv');
const DEFAULT_LINKS_PATH = path.join('tmp', 'tatoeba', 'links.csv');
const DEFAULT_VOCAB_ROOT = path.join('assets', 'data', 'content', 'vocab');
const DEFAULT_OUT_PATH = path.join(
  'assets',
  'data',
  'content',
  'examples_tatoeba_seed.json',
);

function text(value) {
  return `${value ?? ''}`.trim();
}

function asObject(value) {
  return value && typeof value === 'object' && !Array.isArray(value)
    ? value
    : {};
}

function vocabIdForEntry(entry) {
  const lemma = asObject(entry.lemma);
  const links = asObject(entry.links);
  return text(lemma.vocabId) || text(links.sourceVocabId) || text(entry.entryId);
}

function extractVocabEntries(vocabRoot = DEFAULT_VOCAB_ROOT) {
  const unique = new Map();
  for (const file of scanVocabFiles(vocabRoot)) {
    for (const entry of file.payload.entries ?? []) {
      const lemma = asObject(entry.lemma);
      const vocabId = vocabIdForEntry(entry);
      const term = text(lemma.term);
      if (!vocabId || !term) continue;
      if (!/[\u3040-\u30ff\u3400-\u9fff]/.test(term)) continue;
      unique.set(vocabId, {
        vocabId,
        term,
        reading: text(lemma.reading),
      });
    }
  }
  return [...unique.values()];
}

function buildTermBuckets(entries) {
  const buckets = new Map();
  for (const entry of entries) {
    const first = [...entry.term][0];
    if (!first) continue;
    if (!buckets.has(first)) buckets.set(first, []);
    buckets.get(first).push(entry);
  }
  for (const rows of buckets.values()) {
    rows.sort((a, b) => b.term.length - a.term.length || a.vocabId.localeCompare(b.vocabId));
  }
  return buckets;
}

function findTermMatches(ja, buckets) {
  const matches = new Map();
  for (const char of new Set([...ja])) {
    for (const entry of buckets.get(char) ?? []) {
      if (!ja.includes(entry.term)) continue;
      if (entry.term.length === 1 && !isAllowedSingleCharTerm(entry.term, ja)) continue;
      matches.set(entry.vocabId, entry);
    }
  }
  return [...matches.values()].sort(
    (a, b) => b.term.length - a.term.length || a.vocabId.localeCompare(b.vocabId),
  );
}

function isAllowedSingleCharTerm(term, ja = '') {
  if (['私', '誰', '何'].includes(term)) return true;
  if (!/^[ぁ-んァ-ン]$/.test(term)) return false;
  const escaped = term.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  return new RegExp(`(^|[「『\\s、。！？!?.])${escaped}($|[」』\\s、。！？!?.])`).test(ja);
}

function linkedPair(link, jpnSentences, vieSentences) {
  const [a, b] = link;
  if (jpnSentences.has(a) && vieSentences.has(b)) {
    return { sentenceId: a, translationId: b, ja: jpnSentences.get(a), vi: vieSentences.get(b) };
  }
  if (jpnSentences.has(b) && vieSentences.has(a)) {
    return { sentenceId: b, translationId: a, ja: jpnSentences.get(b), vi: vieSentences.get(a) };
  }
  return null;
}

function matchLinkedExamples({
  jpnSentences,
  vieSentences,
  links,
  entries,
  maxPerTerm = 2,
}) {
  const buckets = buildTermBuckets(entries);
  const rows = [];
  const counts = new Map();
  const seen = new Set();
  for (const link of links) {
    const pair = linkedPair(link, jpnSentences, vieSentences);
    if (!pair || !isGoodSentencePair(pair)) continue;
    for (const entry of findTermMatches(pair.ja, buckets)) {
      const count = counts.get(entry.vocabId) ?? 0;
      if (count >= maxPerTerm) continue;
      const key = `${entry.vocabId}:${pair.sentenceId}:${pair.translationId}`;
      if (seen.has(key)) continue;
      seen.add(key);
      counts.set(entry.vocabId, count + 1);
      rows.push({
        vocabId: entry.vocabId,
        term: entry.term,
        reading: entry.reading,
        ja: pair.ja,
        vi: pair.vi,
        sentenceId: pair.sentenceId,
        translationId: pair.translationId,
        source_detail: `Tatoeba sentence ${pair.sentenceId}; translation ${pair.translationId}`,
        license: 'CC-BY 2.0',
      });
    }
  }
  return rows;
}

function isGoodSentencePair(pair) {
  return (
    pair.ja.length >= 4 &&
    pair.ja.length <= 80 &&
    pair.vi.length >= 4 &&
    pair.vi.length <= 180 &&
    /[\u3040-\u30ff\u3400-\u9fff]/.test(pair.ja)
  );
}

async function loadSentences(filePath) {
  const jpnSentences = new Map();
  const vieSentences = new Map();
  const rl = readline.createInterface({
    input: fs.createReadStream(filePath, 'utf8'),
    crlfDelay: Infinity,
  });
  for await (const line of rl) {
    const parts = line.split('\t');
    if (parts.length < 3) continue;
    const id = Number(parts[0]);
    const lang = parts[1];
    const sentence = parts.slice(2).join('\t').trim();
    if (!Number.isFinite(id) || !sentence) continue;
    if (lang === 'jpn') jpnSentences.set(id, sentence);
    else if (lang === 'vie') vieSentences.set(id, sentence);
  }
  return { jpnSentences, vieSentences };
}

async function matchLinksFromFile({ linksPath, jpnSentences, vieSentences, entries, maxPerTerm }) {
  const buckets = buildTermBuckets(entries);
  const rows = [];
  const counts = new Map();
  const seen = new Set();
  const rl = readline.createInterface({
    input: fs.createReadStream(linksPath, 'utf8'),
    crlfDelay: Infinity,
  });
  for await (const line of rl) {
    const parts = line.split('\t');
    if (parts.length < 2) continue;
    const pair = linkedPair([Number(parts[0]), Number(parts[1])], jpnSentences, vieSentences);
    if (!pair || !isGoodSentencePair(pair)) continue;
    for (const entry of findTermMatches(pair.ja, buckets)) {
      const count = counts.get(entry.vocabId) ?? 0;
      if (count >= maxPerTerm) continue;
      const key = `${entry.vocabId}:${pair.sentenceId}:${pair.translationId}`;
      if (seen.has(key)) continue;
      seen.add(key);
      counts.set(entry.vocabId, count + 1);
      rows.push({
        vocabId: entry.vocabId,
        term: entry.term,
        reading: entry.reading,
        ja: pair.ja,
        vi: pair.vi,
        sentenceId: pair.sentenceId,
        translationId: pair.translationId,
        source_detail: `Tatoeba sentence ${pair.sentenceId}; translation ${pair.translationId}`,
        license: 'CC-BY 2.0',
      });
    }
  }
  return rows;
}

function buildSeedPayload(rows) {
  const mergedRows = mergeCuratedRows(rows);
  return {
    schemaVersion: 1,
    source: 'Tatoeba',
    license: 'CC-BY 2.0',
    generatedBy: 'build_tatoeba_example_seed',
    rows: mergedRows.sort((a, b) => (
      (b.priority ?? 0) - (a.priority ?? 0) ||
      a.term.localeCompare(b.term, 'ja') ||
      a.sentenceId - b.sentenceId
    )),
  };
}

function mergeCuratedRows(rows) {
  const seen = new Set();
  const merged = [];
  for (const row of [...curatedRows(), ...rows]) {
    const key = `${row.vocabId || ''}:${row.term}:${row.sentenceId}:${row.translationId}`;
    if (seen.has(key)) continue;
    seen.add(key);
    merged.push(row);
  }
  return merged;
}

function curatedRows() {
  return [
    {
      vocabId: 'n5_l01_v001',
      term: '私',
      reading: 'わたし',
      ja: '私の番？',
      vi: 'Đến lượt tôi chưa?',
      sentenceId: 8755524,
      translationId: 8942182,
      source_detail: 'Tatoeba sentence 8755524; translation 8942182',
      license: 'CC-BY 2.0',
      priority: 100,
    },
  ];
}

function parseArgs(argv) {
  const args = {
    sentencesPath: DEFAULT_SENTENCES_PATH,
    linksPath: DEFAULT_LINKS_PATH,
    vocabRoot: DEFAULT_VOCAB_ROOT,
    outPath: DEFAULT_OUT_PATH,
    maxPerTerm: 2,
  };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '--sentences') args.sentencesPath = argv[++i];
    else if (arg === '--links') args.linksPath = argv[++i];
    else if (arg === '--vocab-root') args.vocabRoot = argv[++i];
    else if (arg === '--out') args.outPath = argv[++i];
    else if (arg === '--max-per-term') args.maxPerTerm = Number(argv[++i]);
  }
  return args;
}

async function main(argv = process.argv.slice(2)) {
  const args = parseArgs(argv);
  const entries = extractVocabEntries(args.vocabRoot);
  const { jpnSentences, vieSentences } = await loadSentences(args.sentencesPath);
  const rows = await matchLinksFromFile({
    linksPath: args.linksPath,
    jpnSentences,
    vieSentences,
    entries,
    maxPerTerm: args.maxPerTerm,
  });
  fs.mkdirSync(path.dirname(args.outPath), { recursive: true });
  fs.writeFileSync(args.outPath, `${JSON.stringify(buildSeedPayload(rows), null, 2)}\n`, 'utf8');
  console.log(`Built Tatoeba seed: ${rows.length} rows for ${new Set(rows.map((r) => r.term)).size} terms.`);
  return 0;
}

if (require.main === module) {
  main().then((code) => {
    process.exitCode = code;
  }).catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
}

module.exports = {
  buildSeedPayload,
  buildTermBuckets,
  findTermMatches,
  matchLinkedExamples,
};
