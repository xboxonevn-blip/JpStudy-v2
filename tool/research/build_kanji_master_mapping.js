#!/usr/bin/env node

const fs = require('node:fs');
const path = require('node:path');

const repoRoot = path.resolve(__dirname, '../..');
const LEVEL_ORDER = ['N5', 'N4', 'N3', 'N2', 'N1'];
const LEVEL_RANK = new Map(LEVEL_ORDER.map((level, index) => [level, index]));

const DEFAULT_HARD_OVERRIDES = {
  海: { level: 'N5', reason: 'owner hard override: sea is N5' },
  帰: { level: 'N5', reason: 'owner hard override: return is N5' },
  銀: { level: 'N3', reason: 'owner hard override: silver is N3' },
  重: { level: 'N3', reason: 'owner hard override: heavy is N3' },
  議: { level: 'N2', reason: 'owner hard override: discuss is N2' },
};

function parseScalar(body, key) {
  const match = body.match(new RegExp(`^${key}:\\s*(.*)$`, 'm'));
  if (!match) return '';
  const value = match[1].trim();
  return value === 'null' ? '' : value;
}

function parseOpenGaps(body) {
  const match = body.match(/^openGaps:\s*\n([\s\S]*?)(?:^examples:|^### |\z)/m);
  if (!match) return [];
  return match[1]
    .split(/\r?\n/)
    .map((line) => line.trim().replace(/^-\s*/, '').trim())
    .filter((line) => line && line !== 'none');
}

function parseCanonicalMarkdown(markdown, defaultLevel, sourceFile = '') {
  const text = String(markdown || '');
  const headingPattern = /^###\s+(\S+)\s+\(([^)]*)\)\s*$/gm;
  const matches = Array.from(text.matchAll(headingPattern));
  return matches.map((match, index) => {
    const start = match.index + match[0].length;
    const end = index + 1 < matches.length ? matches[index + 1].index : text.length;
    const body = text.slice(start, end);
    return {
      kanji: match[1],
      hanViet: match[2] === 'null' ? '' : match[2],
      level: parseScalar(body, 'level') || defaultLevel,
      meaningVi: parseScalar(body, 'meaningVi'),
      openGaps: parseOpenGaps(body),
      sourceFile,
    };
  });
}

function sourceDescriptor(entry) {
  return {
    level: entry.level,
    hanViet: entry.hanViet || '',
    meaningVi: entry.meaningVi || '',
    sourceFile: entry.sourceFile || '',
    openGaps: entry.openGaps || [],
  };
}

function sortedLevels(levels) {
  return Array.from(new Set(levels)).sort(
    (a, b) => (LEVEL_RANK.get(a) ?? 999) - (LEVEL_RANK.get(b) ?? 999),
  );
}

function sortedKanji(chars, entries) {
  return Array.from(chars).sort((a, b) => {
    const ar = LEVEL_RANK.get(entries[a].level) ?? 999;
    const br = LEVEL_RANK.get(entries[b].level) ?? 999;
    if (ar !== br) return ar - br;
    return a.localeCompare(b, 'ja');
  });
}

function buildMasterMapping(canonicalEntries, options = {}) {
  const hardOverrides = options.hardOverrides || DEFAULT_HARD_OVERRIDES;
  const grouped = new Map();
  for (const entry of canonicalEntries) {
    if (!entry.kanji || !entry.level) continue;
    if (!grouped.has(entry.kanji)) grouped.set(entry.kanji, []);
    grouped.get(entry.kanji).push(entry);
  }

  const entries = {};
  const openQuestions = [];

  for (const [kanji, sources] of grouped.entries()) {
    const levels = sortedLevels(sources.map((entry) => entry.level));
    const selectedLevel = levels[0];
    const selectedSource = sources.find((entry) => entry.level === selectedLevel) || sources[0];
    const selectedReason = levels.length > 1 ? 'lowest_level_wins' : 'single_source';

    entries[kanji] = {
      kanji,
      level: selectedLevel,
      hanViet: selectedSource.hanViet || '',
      meaningVi: selectedSource.meaningVi || '',
      selectedReason,
      sourceLevels: levels,
      sources: sources.map(sourceDescriptor),
    };

    if (levels.length > 1) {
      openQuestions.push({
        kanji,
        issue: 'cross_level_duplicate',
        sourceLevels: levels,
        selectedLevel,
        reason: 'Lowest JLPT level selected by QA-A-027 policy.',
      });
    }

    for (const source of sources) {
      for (const gap of source.openGaps || []) {
        openQuestions.push({
          kanji,
          issue: 'extraction_open_gap',
          sourceLevels: [source.level],
          selectedLevel,
          reason: gap,
        });
      }
    }
  }

  for (const [kanji, override] of Object.entries(hardOverrides)) {
    const current = entries[kanji];
    if (!current) {
      entries[kanji] = {
        kanji,
        level: override.level,
        hanViet: '',
        meaningVi: '',
        selectedReason: 'owner_hard_override_missing_from_extraction',
        sourceLevels: [],
        sources: [],
      };
      openQuestions.push({
        kanji,
        issue: 'owner_hard_override_missing',
        sourceLevels: [],
        selectedLevel: override.level,
        reason: override.reason,
      });
      continue;
    }

    if (current.level !== override.level) {
      openQuestions.push({
        kanji,
        issue: 'owner_hard_override_conflict',
        sourceLevels: current.sourceLevels,
        selectedLevel: override.level,
        reason: `${override.reason}; canonical policy would choose ${current.level}.`,
      });
    }
    current.level = override.level;
    current.selectedReason = 'owner_hard_override';
  }

  for (const row of openQuestions) {
    if (entries[row.kanji]) row.selectedLevel = entries[row.kanji].level;
  }

  const orderedEntries = {};
  const orderedKanji = sortedKanji(Object.keys(entries), entries);
  for (const kanji of orderedKanji) orderedEntries[kanji] = entries[kanji];

  const kanjiToLevel = {};
  for (const kanji of orderedKanji) kanjiToLevel[kanji] = orderedEntries[kanji].level;

  const countsByLevel = Object.fromEntries(LEVEL_ORDER.map((level) => [level, 0]));
  for (const level of Object.values(kanjiToLevel)) {
    countsByLevel[level] = (countsByLevel[level] || 0) + 1;
  }

  openQuestions.sort((a, b) => {
    const ak = a.kanji.localeCompare(b.kanji, 'ja');
    if (ak !== 0) return ak;
    return a.issue.localeCompare(b.issue);
  });

  return {
    generatedAt: options.generatedAt || new Date().toISOString(),
    policy: {
      duplicateResolution: 'lowest JLPT level wins: N5 < N4 < N3 < N2 < N1',
      hardOverrides,
      sourceBoundary: 'owner-provided local canonical ebook markdown; banned websites not accessed',
    },
    countsByLevel,
    total: orderedKanji.length,
    kanjiToLevel,
    entries: orderedEntries,
    openQuestions,
  };
}

function escapeCell(value) {
  return String(value ?? '').replace(/\|/g, '\\|').replace(/\r?\n/g, ' ');
}

function formatOpenQuestionsMarkdown(result) {
  const lines = [
    '# Kanji Canonical Open Questions',
    '',
    `Generated: ${result.generatedAt}`,
    'Source: owner-provided local canonical markdown only; banned websites not accessed.',
    '',
    '## Policy',
    '',
    '- Cross-level duplicates are resolved by lowest JLPT level unless an owner hard override exists.',
    '- Owner hard overrides: `海 -> N5`, `帰 -> N5`, `銀 -> N3`, `重 -> N3`, `議 -> N2`.',
    '- Rows below do not block the autonomous loop; owner can review later.',
    '',
    '## Summary',
    '',
    `- Total selected kanji: ${result.total}`,
    ...LEVEL_ORDER.map((level) => `- ${level}: ${result.countsByLevel[level] || 0}`),
    `- Open question rows: ${result.openQuestions.length}`,
    '',
    '## Rows',
    '',
    '| Kanji | Issue | Source levels | Selected level | Reason |',
    '| --- | --- | --- | --- | --- |',
  ];
  for (const row of result.openQuestions) {
    lines.push(
      `| ${escapeCell(row.kanji)} | ${escapeCell(row.issue)} | ${escapeCell((row.sourceLevels || []).join(', ') || 'none')} | ${escapeCell(row.selectedLevel)} | ${escapeCell(row.reason)} |`,
    );
  }
  return `${lines.join('\n')}\n`;
}

function readCanonicalEntries(inputDir) {
  const entries = [];
  for (const level of LEVEL_ORDER) {
    const file = path.join(inputDir, `kanji-${level.toLowerCase()}.md`);
    if (!fs.existsSync(file)) continue;
    entries.push(
      ...parseCanonicalMarkdown(
        fs.readFileSync(file, 'utf8'),
        level,
        path.relative(repoRoot, file).replace(/\\/g, '/'),
      ),
    );
  }
  return entries;
}

function parseArgs(argv) {
  const args = {
    inputDir: path.join(repoRoot, 'docs/research/canonical'),
    outFile: path.join(repoRoot, 'docs/research/canonical/kanji-master-mapping-2026-05-20.json'),
    openQuestionsFile: path.join(repoRoot, 'docs/research/canonical/kanji-canonical-open-questions-2026-05-20.md'),
  };
  for (let i = 0; i < argv.length; i++) {
    const item = argv[i];
    const next = () => argv[++i];
    if (item === '--input-dir') args.inputDir = path.resolve(next());
    else if (item === '--out') args.outFile = path.resolve(next());
    else if (item === '--open-questions') args.openQuestionsFile = path.resolve(next());
    else if (item === '--help' || item === '-h') args.help = true;
    else throw new Error(`Unknown argument ${item}`);
  }
  return args;
}

function printHelp() {
  console.log(`Usage:
  node tool/research/build_kanji_master_mapping.js
  node tool/research/build_kanji_master_mapping.js --input-dir docs/research/canonical
`);
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    printHelp();
    return;
  }
  const entries = readCanonicalEntries(args.inputDir);
  const result = buildMasterMapping(entries);
  fs.writeFileSync(args.outFile, `${JSON.stringify(result, null, 2)}\n`);
  fs.writeFileSync(args.openQuestionsFile, formatOpenQuestionsMarkdown(result));
  console.log(`wrote ${result.total} kanji to ${args.outFile}`);
  console.log(`wrote ${result.openQuestions.length} open questions to ${args.openQuestionsFile}`);
}

if (require.main === module) {
  try {
    main();
  } catch (error) {
    console.error(error.stack || error.message || String(error));
    process.exitCode = 1;
  }
}

module.exports = {
  DEFAULT_HARD_OVERRIDES,
  LEVEL_ORDER,
  buildMasterMapping,
  formatOpenQuestionsMarkdown,
  parseCanonicalMarkdown,
};
