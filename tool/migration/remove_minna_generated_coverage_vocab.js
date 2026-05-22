#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..', '..');
const roots = [
  path.join(repoRoot, 'assets', 'data', 'content', 'vocab', 'n5', 'minna'),
  path.join(repoRoot, 'assets', 'data', 'content', 'vocab', 'n4', 'minna'),
];

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function writeJson(filePath, payload) {
  fs.writeFileSync(filePath, `${JSON.stringify(payload, null, 2)}\n`, 'utf8');
}

function jsonFiles(dir) {
  return fs
    .readdirSync(dir, { withFileTypes: true })
    .filter((entry) => entry.isFile() && entry.name.endsWith('.json'))
    .map((entry) => path.join(dir, entry.name))
    .sort();
}

function isGeneratedCoverage(entry) {
  const tags = Array.isArray(entry?.tags) ? entry.tags : [];
  return (
    entry?.classification?.origin === 'generated_coverage' ||
    tags.includes('kanji-coverage') ||
    tags.includes('kanji-example')
  );
}

function normalizeEntries(entries) {
  return entries.map((entry, index) => ({
    ...entry,
    order: index + 1,
  }));
}

function main() {
  const summary = [];

  for (const root of roots) {
    for (const filePath of jsonFiles(root)) {
      const payload = readJson(filePath);
      const entries = Array.isArray(payload.entries) ? payload.entries : [];
      const kept = normalizeEntries(entries.filter((entry) => !isGeneratedCoverage(entry)));
      const removed = entries.length - kept.length;
      if (!removed) continue;

      writeJson(filePath, {
        ...payload,
        entryCount: kept.length,
        entries: kept,
      });
      summary.push({
        file: path.relative(repoRoot, filePath).replaceAll(path.sep, '/'),
        removed,
        entryCount: kept.length,
      });
    }
  }

  const removedTotal = summary.reduce((sum, item) => sum + item.removed, 0);
  console.log(JSON.stringify({ files: summary.length, removedTotal, summary }, null, 2));
}

main();
