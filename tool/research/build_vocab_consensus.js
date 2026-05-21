#!/usr/bin/env node

const fs = require('node:fs');
const path = require('node:path');

const repoRoot = path.resolve(__dirname, '../..');
const DEFAULT_VOCAB_DIR = path.join(repoRoot, 'docs/research/canonical/vocab');
const DEFAULT_OUT = path.join(
  repoRoot,
  'docs/research/canonical/vocab-cross-source-consensus.md',
);
const LEVEL_ORDER = ['N5', 'N4', 'N3', 'N2', 'N1'];
const LEVEL_RANK = new Map(LEVEL_ORDER.map((level, index) => [level, index]));

function parseScalar(value) {
  const raw = String(value || '').trim();
  if (raw === 'null') return null;
  if (raw === '[]') return [];
  if (
    (raw.startsWith('"') && raw.endsWith('"')) ||
    (raw.startsWith("'") && raw.endsWith("'"))
  ) {
    try {
      return JSON.parse(raw);
    } catch (_) {
      return raw.slice(1, -1);
    }
  }
  return raw;
}

function parseYamlBlock(block) {
  const result = {};
  for (const line of String(block || '').split(/\r?\n/)) {
    const match = line.match(/^([A-Za-z][A-Za-z0-9]*):\s*(.*)$/);
    if (!match) continue;
    result[match[1]] = parseScalar(match[2]);
  }
  return result;
}

function parseVocabCanonicalMarkdown(markdown, sourceFile = '') {
  const entries = [];
  const pattern = /```yaml\s*\n([\s\S]*?)\n```/g;
  for (const match of String(markdown || '').matchAll(pattern)) {
    const row = parseYamlBlock(match[1]);
    if (!row.term) continue;
    entries.push({
      term: row.term,
      reading: row.reading === 'null' ? null : row.reading ?? null,
      hanViet: row.hanViet === 'null' ? null : row.hanViet ?? null,
      meaningVi: row.meaningVi || '',
      level: row.level || '',
      source: row.source || '',
      sourceSection: row.sourceSection || '',
      sourcePage: row.sourcePage || null,
      notes: Array.isArray(row.notes) ? row.notes : [],
      sourceFile,
    });
  }
  return entries;
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
    .replace(/[()[\]{}.,;:!?'"`~～、。]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function groupKey(entry) {
  return `${entry.term}\u0000${entry.reading || ''}`;
}

function sortedUnique(values) {
  return Array.from(new Set(values.filter(Boolean))).sort((a, b) =>
    String(a).localeCompare(String(b)),
  );
}

function sortLevels(levels) {
  return sortedUnique(levels).sort(
    (a, b) => (LEVEL_RANK.get(a) ?? 999) - (LEVEL_RANK.get(b) ?? 999),
  );
}

function sourceSummary(rows) {
  return sortedUnique(rows.map((row) => row.source));
}

function buildVocabConsensus(entries, { generatedAt = new Date().toISOString() } = {}) {
  const groups = new Map();
  for (const entry of entries) {
    if (!entry.term) continue;
    const key = groupKey(entry);
    if (!groups.has(key)) groups.set(key, []);
    groups.get(key).push(entry);
  }

  const consensus = [];
  const divergent = [];
  const singleSource = [];

  for (const [key, rows] of groups.entries()) {
    const [term, reading] = key.split('\u0000');
    const byMeaning = new Map();
    for (const row of rows) {
      const normalized = normalizeMeaning(row.meaningVi);
      if (!byMeaning.has(normalized)) byMeaning.set(normalized, []);
      byMeaning.get(normalized).push(row);
    }

    const sourceCount = sourceSummary(rows).length;
    const levels = sortLevels(rows.map((row) => row.level));
    if (sourceCount < 2) {
      singleSource.push({
        term,
        reading: reading || null,
        levels,
        sources: sourceSummary(rows),
        rows,
      });
      continue;
    }

    const consensusMeanings = Array.from(byMeaning.entries())
      .map(([normalized, meaningRows]) => ({
        normalized,
        rows: meaningRows,
        sources: sourceSummary(meaningRows),
      }))
      .filter((item) => item.sources.length >= 2);

    if (consensusMeanings.length > 0) {
      consensusMeanings.sort(
        (a, b) => b.sources.length - a.sources.length || a.normalized.localeCompare(b.normalized),
      );
      const chosen = consensusMeanings[0];
      consensus.push({
        term,
        reading: reading || null,
        levels,
        meaningVi: chosen.rows[0].meaningVi,
        sources: chosen.sources,
        rows: chosen.rows,
      });
    } else {
      divergent.push({
        term,
        reading: reading || null,
        levels,
        sources: sourceSummary(rows),
        meanings: Array.from(byMeaning.values()).map((meaningRows) => ({
          meaningVi: meaningRows[0].meaningVi,
          sources: sourceSummary(meaningRows),
        })),
        rows,
      });
    }
  }

  const sorter = (a, b) => {
    const al = LEVEL_RANK.get(a.levels[0]) ?? 999;
    const bl = LEVEL_RANK.get(b.levels[0]) ?? 999;
    if (al !== bl) return al - bl;
    const term = a.term.localeCompare(b.term, 'ja');
    if (term !== 0) return term;
    return String(a.reading || '').localeCompare(String(b.reading || ''), 'ja');
  };
  consensus.sort(sorter);
  divergent.sort(sorter);
  singleSource.sort(sorter);

  const bySource = {};
  for (const entry of entries) {
    bySource[entry.source] = (bySource[entry.source] || 0) + 1;
  }

  return {
    generatedAt,
    summary: {
      totalEntries: entries.length,
      totalGroups: groups.size,
      consensusGroups: consensus.length,
      divergentGroups: divergent.length,
      singleSourceGroups: singleSource.length,
      bySource,
    },
    consensus,
    divergent,
    singleSource,
  };
}

function escapeCell(value) {
  return String(value ?? '')
    .replace(/\|/g, '\\|')
    .replace(/\r?\n/g, ' ')
    .trim();
}

function formatConsensusMarkdown(result) {
  const lines = [
    '# Vocab Cross-source Consensus',
    '',
    `Generated: ${result.generatedAt}`,
    'Source boundary: owner-provided local canonical vocab markdown only; banned websites not accessed.',
    '',
    '## Summary',
    '',
    `- Total parsed entries: ${result.summary.totalEntries}`,
    `- Total term+reading groups: ${result.summary.totalGroups}`,
    `- Consensus groups: ${result.summary.consensusGroups}`,
    `- Divergent groups: ${result.summary.divergentGroups}`,
    `- Single-source groups: ${result.summary.singleSourceGroups}`,
    '',
    '## Source Counts',
    '',
    '| Source | Entries |',
    '| --- | ---: |',
  ];
  for (const source of Object.keys(result.summary.bySource).sort()) {
    lines.push(`| ${escapeCell(source)} | ${result.summary.bySource[source]} |`);
  }

  lines.push(
    '',
    '## CONSENSUS',
    '',
    '| Term | Reading | Levels | Meaning VI | Sources |',
    '| --- | --- | --- | --- | --- |',
  );
  for (const row of result.consensus) {
    lines.push(
      `| ${escapeCell(row.term)} | ${escapeCell(row.reading || 'null')} | ${escapeCell(
        row.levels.join(', '),
      )} | ${escapeCell(row.meaningVi)} | ${escapeCell(row.sources.join(', '))} |`,
    );
  }

  lines.push(
    '',
    '## DIVERGENT',
    '',
    '| Term | Reading | Levels | Meanings by source |',
    '| --- | --- | --- | --- |',
  );
  for (const row of result.divergent) {
    const meanings = row.meanings
      .map((item) => `${item.sources.join(', ')}: ${item.meaningVi}`)
      .join(' / ');
    lines.push(
      `| ${escapeCell(row.term)} | ${escapeCell(row.reading || 'null')} | ${escapeCell(
        row.levels.join(', '),
      )} | ${escapeCell(meanings)} |`,
    );
  }

  lines.push(
    '',
    '## SINGLE_SOURCE_SUMMARY',
    '',
    `Single-source groups are not listed individually in this report to keep the consensus file reviewable. Count: ${result.summary.singleSourceGroups}.`,
    '',
  );

  return `${lines.join('\n')}\n`;
}

function loadCanonicalVocabEntries(vocabDir = DEFAULT_VOCAB_DIR) {
  const files = fs
    .readdirSync(vocabDir)
    .filter((file) => file.endsWith('.md'))
    .filter((file) => !file.includes('consensus'))
    .sort();
  const entries = [];
  for (const file of files) {
    entries.push(
      ...parseVocabCanonicalMarkdown(
        fs.readFileSync(path.join(vocabDir, file), 'utf8'),
        file,
      ),
    );
  }
  return entries;
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
  const vocabDir = args.vocabDir || DEFAULT_VOCAB_DIR;
  const out = args.out || DEFAULT_OUT;
  const entries = loadCanonicalVocabEntries(vocabDir);
  const result = buildVocabConsensus(entries);
  fs.mkdirSync(path.dirname(out), { recursive: true });
  fs.writeFileSync(out, formatConsensusMarkdown(result), 'utf8');
  console.log(
    `consensus groups=${result.summary.consensusGroups}; divergent=${result.summary.divergentGroups}; single=${result.summary.singleSourceGroups}`,
  );
}

if (require.main === module) {
  main();
}

module.exports = {
  buildVocabConsensus,
  formatConsensusMarkdown,
  loadCanonicalVocabEntries,
  parseVocabCanonicalMarkdown,
};
