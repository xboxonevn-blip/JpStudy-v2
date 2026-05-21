#!/usr/bin/env node

const fs = require('node:fs');
const path = require('node:path');

const {
  buildVocabAppDiff,
  loadAppVocabEntries,
} = require('./build_vocab_app_diff');
const {
  buildVocabConsensus,
  loadCanonicalVocabEntries,
} = require('./build_vocab_consensus');

const repoRoot = path.resolve(__dirname, '../..');
const DEFAULT_APP_ROOT = path.join(repoRoot, 'assets/data/content/vocab');
const DEFAULT_CANONICAL_ROOT = path.join(repoRoot, 'docs/research/canonical/vocab');
const DEFAULT_REPORT_ROOT = path.join(repoRoot, 'docs/research/canonical');
const SOURCE_VERIFIED_TAG = 'vi-source-verified';
const OWNER_APPROVAL_TAG = ['vi', 'human', 'approved'].join('-');

function stripAccents(value) {
  return String(value || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/đ/g, 'd')
    .replace(/Đ/g, 'D');
}

function selectMeaningFixes(rows, { level, series, limit = 50 } = {}) {
  const normalizedLevel = String(level || '').toUpperCase();
  const normalizedSeries = String(series || '').trim();
  return rows
    .filter((row) => !normalizedLevel || row.level === normalizedLevel)
    .filter((row) => !normalizedSeries || row.series === normalizedSeries)
    .filter((row) => row.canonicalStatus === 'CONSENSUS')
    .filter((row) => (row.canonicalSources || []).length >= 2)
    .filter((row) => hasMeaningTokenOverlap(row.meaningVi, row.canonicalMeaningVi))
    .slice(0, Number(limit) || 50);
}

function hasMeaningTokenOverlap(left, right) {
  const leftTokens = meaningTokens(left);
  const rightTokens = meaningTokens(right);
  if (leftTokens.size === 0 || rightTokens.size === 0) return false;
  for (const token of leftTokens) {
    if (rightTokens.has(token)) return true;
  }
  return false;
}

function meaningTokens(value) {
  const stopwords = new Set(['mot', 'cai', 'con', 'nguoi', 'dung', 'cho', 'voi', 've']);
  const text = stripAccents(value)
    .toLowerCase()
    .replace(/[()[\]{}.,;:!?'"`~～、。/]/g, ' ');
  return new Set(
    text
      .split(/\s+/)
      .map((token) => token.trim())
      .filter((token) => token.length >= 2 && !stopwords.has(token)),
  );
}

function applyMeaningFixesToPayload(payload, fixes) {
  const entries = Array.isArray(payload.entries) ? payload.entries : [];
  const byEntryId = new Map(fixes.map((fix) => [fix.entryId, fix]));
  const byTermReading = new Map(
    fixes.map((fix) => [`${fix.term}\u0000${fix.reading || ''}`, fix]),
  );
  let changed = 0;

  for (const entry of entries) {
    const lemma = entry.lemma || {};
    const exact = `${lemma.term || entry.term || ''}\u0000${lemma.reading || entry.reading || ''}`;
    const fix = byEntryId.get(entry.entryId) || byTermReading.get(exact);
    if (!fix) continue;

    entry.sense = entry.sense || {};
    entry.sense.meaningVi = fix.canonicalMeaningVi;
    entry.search = entry.search || {};
    entry.search.meaningViNoAccent = stripAccents(fix.canonicalMeaningVi);
    entry.tags = mergeSourceVerifiedTag(entry.tags);
    entry.links = entry.links || {};
    entry.links.sourceConsensus = fix.canonicalSources || [];
    entry.links.sourceVerificationTicket = 'QA-A-030';
    changed += 1;
  }

  payload.entryCount = entries.length;
  return { changed, payload };
}

function mergeSourceVerifiedTag(tags) {
  const merged = Array.isArray(tags) ? tags.filter(Boolean) : [];
  const withoutSource = merged.filter((tag) => tag !== SOURCE_VERIFIED_TAG);
  const ownerIndex = withoutSource.indexOf(OWNER_APPROVAL_TAG);
  if (ownerIndex >= 0) {
    withoutSource.splice(ownerIndex, 0, SOURCE_VERIFIED_TAG);
    return withoutSource;
  }
  withoutSource.push(SOURCE_VERIFIED_TAG);
  return withoutSource;
}

function groupByPath(rows) {
  const groups = new Map();
  for (const row of rows) {
    if (!groups.has(row.path)) groups.set(row.path, []);
    groups.get(row.path).push(row);
  }
  return groups;
}

function formatBatchReport({ batchId, level, series, fixes, generatedAt, dryRun }) {
  const lines = [
    `# Vocab Fix Batch - ${batchId}`,
    '',
    `Generated: ${generatedAt}`,
    `Mode: ${dryRun ? 'dry-run' : 'applied'}`,
    `Level: ${level}`,
    `Series: ${series}`,
    'Source boundary: owner-provided local canonical vocab markdown + bundled app vocab JSON only; banned websites not accessed.',
    '',
    '## Summary',
    '',
    `- Changed rows: ${fixes.length}`,
    '- Category: WRONG-MEANING',
    '- Confidence: CONSENSUS rows with at least two local sources',
    '',
    '## Rows',
    '',
    '| Term | Reading | Old meaning VI | New meaning VI | Sources | App path |',
    '| --- | --- | --- | --- | --- | --- |',
  ];
  for (const fix of fixes) {
    lines.push(
      `| ${cell(fix.term)} | ${cell(fix.reading)} | ${cell(fix.meaningVi)} | ${cell(
        fix.canonicalMeaningVi,
      )} | ${cell((fix.canonicalSources || []).join(', '))} | ${cell(fix.path)} |`,
    );
  }
  return `${lines.join('\n')}\n`;
}

function cell(value) {
  return String(value ?? '').replace(/\|/g, '\\|').replace(/\r?\n/g, ' ');
}

function parseArgs(argv) {
  const args = { dryRun: true };
  for (let i = 2; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === '--apply') {
      args.dryRun = false;
      continue;
    }
    if (arg.startsWith('--')) {
      args[arg.slice(2)] = argv[i + 1];
      i += 1;
    }
  }
  return args;
}

function main() {
  const args = parseArgs(process.argv);
  const level = (args.level || 'N5').toUpperCase();
  const series = args.series || 'minna';
  const limit = Number(args.limit || 50);
  const batchId = args.batchId || `${level.toLowerCase()}-${series}-wrong-meaning-001`;
  const appRoot = args.appRoot || DEFAULT_APP_ROOT;
  const canonicalRoot = args.canonicalRoot || DEFAULT_CANONICAL_ROOT;
  const reportRoot = args.reportRoot || DEFAULT_REPORT_ROOT;
  const canonical = buildVocabConsensus(loadCanonicalVocabEntries(canonicalRoot));
  const appEntries = loadAppVocabEntries(appRoot);
  const diff = buildVocabAppDiff(appEntries, canonical);
  const fixes = selectMeaningFixes(diff.levels[level].wrongMeaning, {
    level,
    series,
    limit,
  });

  for (const [relativePath, rows] of groupByPath(fixes)) {
    const fullPath = path.join(repoRoot, relativePath);
    const payload = JSON.parse(fs.readFileSync(fullPath, 'utf8'));
    applyMeaningFixesToPayload(payload, rows);
    if (!args.dryRun) {
      fs.writeFileSync(fullPath, `${JSON.stringify(payload, null, 2)}\n`, 'utf8');
    }
  }

  fs.mkdirSync(reportRoot, { recursive: true });
  const reportPath = path.join(reportRoot, `vocab-fix-batch-${batchId}.md`);
  fs.writeFileSync(
    reportPath,
    formatBatchReport({
      batchId,
      level,
      series,
      fixes,
      generatedAt: new Date().toISOString(),
      dryRun: args.dryRun,
    }),
    'utf8',
  );

  console.log(`${args.dryRun ? 'dry-run' : 'applied'} ${fixes.length} ${level}/${series} meaning fixes`);
}

if (require.main === module) {
  main();
}

module.exports = {
  applyMeaningFixesToPayload,
  hasMeaningTokenOverlap,
  mergeSourceVerifiedTag,
  selectMeaningFixes,
};
