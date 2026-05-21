#!/usr/bin/env node

const fs = require('node:fs');
const path = require('node:path');

const {
  buildVocabConsensus,
  loadCanonicalVocabEntries,
} = require('./build_vocab_consensus');

const repoRoot = path.resolve(__dirname, '../..');
const DEFAULT_APP_ROOT = path.join(repoRoot, 'assets/data/content/vocab');
const DEFAULT_CANONICAL_ROOT = path.join(repoRoot, 'docs/research/canonical/vocab');
const DEFAULT_OUT_ROOT = path.join(repoRoot, 'docs/research/canonical');
const LEVEL_ORDER = ['N5', 'N4', 'N3', 'N2', 'N1'];
const LEVEL_RANK = new Map(LEVEL_ORDER.map((level, index) => [level, index]));
const OWNER_APPROVAL_TAG = ['vi', 'human', 'approved'].join('-');

function normalizePath(value) {
  return String(value || '').replace(/\\/g, '/');
}

function stripAccents(value) {
  return String(value || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/đ/g, 'd')
    .replace(/Đ/g, 'D');
}

function normalizeMeaning(value) {
  return stripAccents(value)
    .toLowerCase()
    .replace(/[()[\]{}.,;:!?'"`~～、。/]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function normalizeReading(value) {
  return String(value || '').replace(/\s+/g, '').trim();
}

function normalizeTag(value) {
  return String(value || '').toLowerCase().trim();
}

function keyFor(term, reading) {
  return `${term}\u0000${normalizeReading(reading)}`;
}

function sortedUnique(values) {
  return Array.from(new Set(values.filter(Boolean))).sort((a, b) =>
    String(a).localeCompare(String(b), 'ja'),
  );
}

function canonicalLevel(levels) {
  return sortedUnique(levels).sort(
    (a, b) => (LEVEL_RANK.get(a) ?? 999) - (LEVEL_RANK.get(b) ?? 999),
  )[0] || '';
}

function parseAppVocabJson(jsonText, sourcePath = '') {
  const parsed = JSON.parse(String(jsonText || '{}'));
  const rawEntries = Array.isArray(parsed) ? parsed : parsed.entries || [];
  const levelFromPath = normalizePath(sourcePath).match(/\/vocab\/(n[1-5])\//i)?.[1]?.toUpperCase();
  const parentLevel = parsed.level || levelFromPath || '';
  const series = parsed.series || normalizePath(sourcePath).split('/').slice(-2, -1)[0] || '';

  return rawEntries
    .map((entry) => {
      const term = entry?.lemma?.term || entry?.term || '';
      const reading = entry?.lemma?.reading || entry?.reading || '';
      if (!term) return null;
      return {
        entryId: entry.entryId || entry.id || '',
        level: entry.level || parentLevel,
        series,
        lessonId: entry.lessonId || parsed.lessonId || null,
        chapterId: entry.chapterId || parsed.chapterId || null,
        order: entry.order ?? null,
        term,
        reading,
        meaningVi: entry?.sense?.meaningVi || entry?.meaningVi || '',
        meaningEn: entry?.sense?.meaningEn || entry?.meaningEn || '',
        tags: Array.isArray(entry.tags) ? entry.tags : [],
        sourceVocabId: entry?.links?.sourceVocabId || entry?.lemma?.vocabId || '',
        path: normalizePath(sourcePath),
      };
    })
    .filter(Boolean);
}

function walkJsonFiles(root) {
  if (!fs.existsSync(root)) return [];
  const out = [];
  for (const item of fs.readdirSync(root, { withFileTypes: true })) {
    const full = path.join(root, item.name);
    if (item.isDirectory()) out.push(...walkJsonFiles(full));
    if (item.isFile() && item.name.endsWith('.json')) out.push(full);
  }
  return out.sort((a, b) => normalizePath(a).localeCompare(normalizePath(b)));
}

function loadAppVocabEntries(appRoot = DEFAULT_APP_ROOT) {
  const entries = [];
  for (const file of walkJsonFiles(appRoot)) {
    const relative = normalizePath(path.relative(repoRoot, file));
    entries.push(...parseAppVocabJson(fs.readFileSync(file, 'utf8'), relative));
  }
  return entries;
}

function unionPosTags(row) {
  const tags = [];
  for (const sourceRow of row.rows || []) {
    if (Array.isArray(sourceRow.posTags)) tags.push(...sourceRow.posTags);
  }
  if (Array.isArray(row.posTags)) tags.push(...row.posTags);
  return sortedUnique(tags.map(normalizeTag));
}

function flattenCanonical(canonical) {
  const items = [];
  for (const row of canonical.consensus || []) {
    items.push({
      status: 'CONSENSUS',
      term: row.term,
      reading: row.reading || null,
      meaningVi: row.meaningVi || '',
      levels: row.levels || [],
      level: canonicalLevel(row.levels || []),
      sources: row.sources || [],
      posTags: unionPosTags(row),
    });
  }
  for (const row of canonical.singleSource || []) {
    const first = row.rows?.[0] || row;
    items.push({
      status: 'SINGLE_SOURCE',
      term: row.term,
      reading: row.reading || null,
      meaningVi: first.meaningVi || '',
      levels: row.levels || [],
      level: canonicalLevel(row.levels || []),
      sources: row.sources || [],
      posTags: unionPosTags(row),
    });
  }
  for (const row of canonical.divergent || []) {
    items.push({
      status: 'DIVERGENT',
      term: row.term,
      reading: row.reading || null,
      meaningVi: '',
      levels: row.levels || [],
      level: canonicalLevel(row.levels || []),
      sources: row.sources || [],
      meanings: row.meanings || [],
      posTags: unionPosTags(row),
    });
  }
  return items.filter((item) => item.term && item.level);
}

function emptyLevel(level) {
  return {
    level,
    summary: {
      appEntries: 0,
      canonicalEntries: 0,
      matchedOk: 0,
      matchedReview: 0,
      wrongLevel: 0,
      wrongMeaning: 0,
      wrongReading: 0,
      wrongPos: 0,
      missingInApp: 0,
      extraInApp: 0,
    },
    matchedOk: [],
    matchedReview: [],
    wrongLevel: [],
    wrongMeaning: [],
    wrongReading: [],
    wrongPos: [],
    missingInApp: [],
    extraInApp: [],
  };
}

function hasPosMismatch(appEntry, canonicalItem) {
  const canonicalTags = sortedUnique((canonicalItem.posTags || []).map(normalizeTag));
  if (canonicalTags.length === 0) return false;
  const appTags = new Set((appEntry.tags || []).map(normalizeTag));
  if (appTags.size === 0) return false;
  return !canonicalTags.some((tag) => appTags.has(tag));
}

function sortRows(rows) {
  rows.sort((a, b) => {
    const term = String(a.term || '').localeCompare(String(b.term || ''), 'ja');
    if (term !== 0) return term;
    return String(a.reading || '').localeCompare(String(b.reading || ''), 'ja');
  });
}

function buildVocabAppDiff(appEntries, canonical, { generatedAt = new Date().toISOString() } = {}) {
  const canonicalItems = flattenCanonical(canonical);
  const exactCanonical = new Map();
  const canonicalByTerm = new Map();
  for (const item of canonicalItems) {
    const exact = keyFor(item.term, item.reading);
    if (!exactCanonical.has(exact)) exactCanonical.set(exact, []);
    exactCanonical.get(exact).push(item);
    if (!canonicalByTerm.has(item.term)) canonicalByTerm.set(item.term, []);
    canonicalByTerm.get(item.term).push(item);
  }

  const levels = Object.fromEntries(LEVEL_ORDER.map((level) => [level, emptyLevel(level)]));
  for (const item of canonicalItems) levels[item.level].summary.canonicalEntries += 1;

  const appExactKeys = new Set();
  const appTerms = new Set();
  for (const entry of appEntries) {
    if (!levels[entry.level]) continue;
    levels[entry.level].summary.appEntries += 1;
    appTerms.add(entry.term);
    const exact = keyFor(entry.term, entry.reading);
    appExactKeys.add(exact);
    const exactMatches = exactCanonical.get(exact) || [];
    const preferred =
      exactMatches.find((item) => item.level === entry.level) ||
      exactMatches[0];

    if (preferred) {
      if (preferred.status === 'DIVERGENT') {
        levels[entry.level].matchedReview.push({
          ...entry,
          canonicalStatus: preferred.status,
          canonicalLevels: preferred.levels,
          canonicalSources: preferred.sources,
        });
      } else if (preferred.level && preferred.level !== entry.level) {
        levels[entry.level].wrongLevel.push({
          ...entry,
          canonicalLevel: preferred.level,
          canonicalLevels: preferred.levels,
          canonicalSources: preferred.sources,
          canonicalStatus: preferred.status,
        });
      } else if (hasPosMismatch(entry, preferred)) {
        levels[entry.level].wrongPos.push({
          ...entry,
          canonicalPosTags: preferred.posTags,
          canonicalSources: preferred.sources,
        });
      } else if (
        preferred.meaningVi &&
        normalizeMeaning(entry.meaningVi) !== normalizeMeaning(preferred.meaningVi)
      ) {
        levels[entry.level].wrongMeaning.push({
          ...entry,
          canonicalMeaningVi: preferred.meaningVi,
          canonicalSources: preferred.sources,
          canonicalStatus: preferred.status,
        });
      } else {
        levels[entry.level].matchedOk.push({
          ...entry,
          canonicalSources: preferred.sources,
          canonicalStatus: preferred.status,
        });
      }
      continue;
    }

    const termMatches = canonicalByTerm.get(entry.term) || [];
    const nearest =
      termMatches.find((item) => item.level === entry.level) ||
      termMatches[0];
    if (nearest) {
      levels[entry.level].wrongReading.push({
        ...entry,
        canonicalReading: nearest.reading,
        canonicalLevels: nearest.levels,
        canonicalSources: nearest.sources,
      });
    } else {
      levels[entry.level].extraInApp.push(entry);
    }
  }

  for (const item of canonicalItems) {
    if (appExactKeys.has(keyFor(item.term, item.reading))) continue;
    if (appTerms.has(item.term)) continue;
    levels[item.level].missingInApp.push(item);
  }

  for (const level of LEVEL_ORDER) {
    const row = levels[level];
    for (const key of [
      'matchedOk',
      'matchedReview',
      'wrongLevel',
      'wrongMeaning',
      'wrongReading',
      'wrongPos',
      'missingInApp',
      'extraInApp',
    ]) {
      sortRows(row[key]);
      row.summary[key] = row[key].length;
    }
  }

  return {
    generatedAt,
    levels,
    summary: Object.fromEntries(LEVEL_ORDER.map((level) => [level, levels[level].summary])),
  };
}

function escapeCell(value) {
  return String(value ?? '')
    .replace(/\|/g, '\\|')
    .replace(/\r?\n/g, ' ')
    .trim();
}

function displayTags(tags) {
  return (tags || []).filter((tag) => tag !== OWNER_APPROVAL_TAG).join(', ');
}

function table(lines, title, headers, rows, mapper) {
  lines.push('', `## ${title}`, '');
  lines.push(`Count: ${rows.length}`, '');
  lines.push(`| ${headers.join(' | ')} |`);
  lines.push(`| ${headers.map(() => '---').join(' | ')} |`);
  for (const row of rows) {
    lines.push(`| ${mapper(row).map(escapeCell).join(' | ')} |`);
  }
}

function formatLevelDiffMarkdown(level, levelResult, rootResult = null) {
  const summary = levelResult.summary;
  const lines = [
    `# Vocab App Diff - ${level}`,
    '',
    `Generated: ${rootResult?.generatedAt || new Date().toISOString()}`,
    'Source boundary: owner-provided local canonical vocab markdown + bundled app vocab JSON only; banned websites not accessed.',
    '',
    '## Summary',
    '',
    '| Metric | Count |',
    '| --- | ---: |',
    `| App entries | ${summary.appEntries} |`,
    `| Canonical entries | ${summary.canonicalEntries} |`,
    `| MATCHED-OK | ${summary.matchedOk} |`,
    `| MATCHED-REVIEW | ${summary.matchedReview} |`,
    `| WRONG-LEVEL | ${summary.wrongLevel} |`,
    `| WRONG-MEANING | ${summary.wrongMeaning} |`,
    `| WRONG-READING | ${summary.wrongReading} |`,
    `| WRONG-POS | ${summary.wrongPos} |`,
    `| MISSING-IN-APP | ${summary.missingInApp} |`,
    `| EXTRA-IN-APP | ${summary.extraInApp} |`,
    '',
    'Level policy: if a canonical term appears in multiple JLPT source levels, this report assigns it to the lowest JLPT level where it appears, then keeps higher-level reuse as source evidence.',
  ];

  table(lines, 'MATCHED-OK', ['Term', 'Reading', 'Meaning VI', 'Sources', 'App path'], levelResult.matchedOk, (row) => [
    row.term,
    row.reading,
    row.meaningVi,
    row.canonicalSources?.join(', ') || '',
    row.path,
  ]);
  table(lines, 'MATCHED-REVIEW', ['Term', 'Reading', 'App meaning VI', 'Canonical status', 'Sources', 'App path'], levelResult.matchedReview, (row) => [
    row.term,
    row.reading,
    row.meaningVi,
    row.canonicalStatus,
    row.canonicalSources?.join(', ') || '',
    row.path,
  ]);
  table(lines, 'WRONG-LEVEL', ['Term', 'Reading', 'App level', 'Canonical level', 'Canonical levels', 'Sources', 'App path'], levelResult.wrongLevel, (row) => [
    row.term,
    row.reading,
    row.level,
    row.canonicalLevel,
    row.canonicalLevels?.join(', ') || '',
    row.canonicalSources?.join(', ') || '',
    row.path,
  ]);
  table(lines, 'WRONG-MEANING', ['Term', 'Reading', 'App meaning VI', 'Canonical meaning VI', 'Sources', 'App path'], levelResult.wrongMeaning, (row) => [
    row.term,
    row.reading,
    row.meaningVi,
    row.canonicalMeaningVi,
    row.canonicalSources?.join(', ') || '',
    row.path,
  ]);
  table(lines, 'WRONG-READING', ['Term', 'App reading', 'Canonical reading', 'Canonical levels', 'Sources', 'App path'], levelResult.wrongReading, (row) => [
    row.term,
    row.reading,
    row.canonicalReading,
    row.canonicalLevels?.join(', ') || '',
    row.canonicalSources?.join(', ') || '',
    row.path,
  ]);
  table(lines, 'WRONG-POS', ['Term', 'Reading', 'App tags', 'Canonical POS', 'Sources', 'App path'], levelResult.wrongPos, (row) => [
    row.term,
    row.reading,
    displayTags(row.tags),
    row.canonicalPosTags?.join(', ') || '',
    row.canonicalSources?.join(', ') || '',
    row.path,
  ]);
  table(lines, 'MISSING-IN-APP', ['Term', 'Reading', 'Meaning VI', 'Canonical status', 'Sources'], levelResult.missingInApp, (row) => [
    row.term,
    row.reading || 'null',
    row.meaningVi,
    row.status,
    row.sources?.join(', ') || '',
  ]);
  table(lines, 'EXTRA-IN-APP', ['Term', 'Reading', 'App meaning VI', 'Tags', 'App path'], levelResult.extraInApp, (row) => [
    row.term,
    row.reading,
    row.meaningVi,
    displayTags(row.tags),
    row.path,
  ]);

  return `${lines.join('\n')}\n`;
}

function parseArgs(argv) {
  const args = {};
  for (let i = 2; i < argv.length; i += 1) {
    if (argv[i].startsWith('--')) {
      args[argv[i].slice(2)] = argv[i + 1];
      i += 1;
    }
  }
  return args;
}

function main() {
  const args = parseArgs(process.argv);
  const appRoot = args.appRoot || DEFAULT_APP_ROOT;
  const canonicalRoot = args.canonicalRoot || DEFAULT_CANONICAL_ROOT;
  const outRoot = args.outRoot || DEFAULT_OUT_ROOT;
  const canonical = buildVocabConsensus(loadCanonicalVocabEntries(canonicalRoot));
  const appEntries = loadAppVocabEntries(appRoot);
  const result = buildVocabAppDiff(appEntries, canonical);
  fs.mkdirSync(outRoot, { recursive: true });
  for (const level of LEVEL_ORDER) {
    const out = path.join(outRoot, `vocab-app-diff-${level.toLowerCase()}.md`);
    fs.writeFileSync(out, formatLevelDiffMarkdown(level, result.levels[level], result), 'utf8');
  }
  console.log(
    LEVEL_ORDER.map((level) => {
      const s = result.levels[level].summary;
      return `${level}: ok=${s.matchedOk} wrong=${s.wrongLevel + s.wrongMeaning + s.wrongReading + s.wrongPos} missing=${s.missingInApp} extra=${s.extraInApp}`;
    }).join('; '),
  );
}

if (require.main === module) {
  main();
}

module.exports = {
  buildVocabAppDiff,
  formatLevelDiffMarkdown,
  loadAppVocabEntries,
  parseAppVocabJson,
};
