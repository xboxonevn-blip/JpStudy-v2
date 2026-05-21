const fs = require('node:fs');
const path = require('node:path');

const repoRoot = path.resolve(__dirname, '..', '..');
const bannedSourceRe = /thocodehoctiengnhat|nhaikanji/i;
const generatedAt = '2026-05-21T18:30:00+07:00';

const levelOrder = ['N3', 'N2', 'N1'];
const missingUnitPolicy = {
  N1: [6, 10],
  N2: [5, 9],
};

function parseCanonicalMarkdown(markdown) {
  const entries = [];
  const fenceRe = /```yaml\s*([\s\S]*?)```/g;
  let match;
  while ((match = fenceRe.exec(markdown)) !== null) {
    const entry = {};
    for (const rawLine of match[1].split(/\r?\n/)) {
      const line = rawLine.trim();
      if (!line || line.startsWith('#')) continue;
      const lineMatch = line.match(/^([A-Za-z][A-Za-z0-9_]*):\s*(.*)$/);
      if (!lineMatch) continue;
      entry[lineMatch[1]] = parseScalar(lineMatch[2]);
    }
    if (entry.term && entry.meaningVi) {
      delete entry.sourceFile;
      entries.push(entry);
    }
  }
  return entries;
}

function parseScalar(raw) {
  const value = String(raw ?? '').trim();
  if (value === 'null') return null;
  if (
    (value.startsWith('"') && value.endsWith('"')) ||
    (value.startsWith("'") && value.endsWith("'"))
  ) {
    return value.slice(1, -1);
  }
  if (value === '[]') return [];
  return value;
}

function containsBannedSourceLeak(text) {
  return bannedSourceRe.test(String(text ?? ''));
}

function buildMimikaraAssets({
  canonicalDir = path.join(repoRoot, 'docs', 'research', 'canonical', 'vocab'),
  assetRoot = path.join(repoRoot, 'assets', 'data', 'content', 'vocab'),
  manifestRoot = path.join(repoRoot, 'lib', 'data', 'manifests'),
  appContentRoot = path.join(repoRoot, 'assets', 'data', 'content', 'vocab'),
  writeDocs = false,
} = {}) {
  const result = { levels: {}, openQuestions: [], decisions: [] };
  for (const level of levelOrder) {
    const levelLower = level.toLowerCase();
    const existingDefinitions = loadExistingAppDefinitionMap(appContentRoot, level);
    const source = loadCanonicalForLevel(canonicalDir, level);
    const entries = source.entries.map((entry, index) =>
      mergeExistingAppDefinition(
        {
          ...entry,
          level,
          sourceMode: source.sourceMode,
          orderInSource: index + 1,
        },
        existingDefinitions,
      ),
    );

    if (missingUnitPolicy[level]) {
      const filled = fillMissingUnits({
        level,
        entries,
        missingUnits: missingUnitPolicy[level],
        appContentRoot,
        canonicalDir,
        writeDocs,
      });
      entries.push(...filled);
      if (filled.length > 0) {
        result.decisions.push({
          level,
          missingUnits: missingUnitPolicy[level],
          filledRows: filled.length,
        });
      }
    }

    const dedupedEntries = dedupeEntriesByTermReading(entries);
    const removedDuplicates = entries.length - dedupedEntries.length;
    if (removedDuplicates > 0) {
      result.decisions.push({
        level,
        dedupePolicy: 'normalized-term-reading-first-source-row-wins',
        removedDuplicates,
      });
    }

    const units = groupEntriesByUnit(dedupedEntries, level);
    writeLevelAssets({ assetRoot, manifestRoot, level, units, source });
    result.levels[level] = {
      sourceMode: source.sourceMode,
      unitCount: units.length,
      itemCount: units.reduce((sum, unit) => sum + unit.entries.length, 0),
    };
  }

  updateTextbookIndex(manifestRoot, result.levels);
  if (writeDocs) {
    appendDecisionAndOqLogs({ result });
    appendLoopStatus(result);
  }
  return result;
}

function dedupeEntriesByTermReading(entries) {
  const seen = new Set();
  const deduped = [];
  for (const entry of entries) {
    const key = normalizedTermReading(entry);
    if (!key || seen.has(key)) continue;
    seen.add(key);
    deduped.push(entry);
  }
  return deduped;
}

function loadCanonicalForLevel(canonicalDir, level) {
  const lower = level.toLowerCase();
  const mimikaraPath = path.join(canonicalDir, `mimikara-${lower}.md`);
  if (fs.existsSync(mimikaraPath)) {
    return {
      sourceName: `mimikara-${lower}`,
      sourceMode: 'owner-local-mimikara',
      sourceCredit: 'Owner-provided local Mimikara facts; no prose copied.',
      entries: parseCanonicalMarkdown(fs.readFileSync(mimikaraPath, 'utf8')),
    };
  }

  return {
    sourceName: `mimikara-${lower}`,
    sourceMode: 'source-gap-empty',
    sourceCredit: 'No source rows found.',
    entries: [],
  };
}

function fillMissingUnits({
  level,
  entries,
  missingUnits,
  appContentRoot,
  canonicalDir,
  writeDocs,
}) {
  const existingUnits = new Set(
    entries.map((entry) => unitNumber(entry.sourceSection)).filter(Boolean),
  );
  const missing = missingUnits.filter((unit) => !existingUnits.has(unit));
  if (missing.length === 0) return [];

  const seen = new Set(entries.map(normalizedTermReading));
  const candidates = loadAppVocabCandidates(appContentRoot, level).filter((entry) => {
    const key = normalizedTermReading(entry);
    if (!key || seen.has(key)) return false;
    seen.add(key);
    return true;
  });

  const filled = [];
  let cursor = 0;
  for (const unit of missing) {
    const picked = candidates.slice(cursor, cursor + 90);
    cursor += picked.length;
    const unitEntries = picked.map((entry, index) => ({
      ...entry,
      level,
      source: `online-whitelisted-fill-OQ011`,
      sourceMode: 'app-jmdict-whitelist-fill-OQ011',
      sourceSection: `Unit ${unit}`,
      sourcePage: null,
      confidence: 'fallback-from-current-app-and-jmdict',
      notes: ['deduped-normalized-term-reading', 'owner-approved-OQ011-fill'],
      orderInSource: index + 1,
    }));
    filled.push(...unitEntries);
    if (writeDocs && unitEntries.length > 0) {
      writeFillMarkdown(canonicalDir, level, unit, unitEntries);
    }
  }
  return filled;
}

function loadExistingAppDefinitionMap(appContentRoot, level) {
  const levelRoot = path.join(appContentRoot, level.toLowerCase());
  const files = listJsonFiles(levelRoot).filter((file) => isBaseVocabFile(file));
  const definitions = new Map();
  for (const file of files) {
    let payload;
    try {
      payload = JSON.parse(fs.readFileSync(file, 'utf8'));
    } catch (_) {
      continue;
    }
    const entries = Array.isArray(payload.entries) ? payload.entries : [];
    for (const raw of entries) {
      const lemma = raw.lemma || {};
      const sense = raw.sense || {};
      const key = normalizedTermReading({
        term: lemma.term,
        reading: lemma.reading,
      });
      if (!key || definitions.has(key)) continue;
      definitions.set(key, {
        meaningVi: cleanText(sense.meaningVi),
        hanViet: normalizeHanViet(lemma.labels?.hanViet || raw.legacy?.kanjiMeaning),
      });
    }
  }
  return definitions;
}

function mergeExistingAppDefinition(entry, existingDefinitions) {
  const existing = existingDefinitions.get(normalizedTermReading(entry));
  if (!existing) {
    return {
      ...entry,
      hanViet: normalizeHanViet(entry.hanViet),
    };
  }
  return {
    ...entry,
    meaningVi: existing.meaningVi || entry.meaningVi,
    hanViet: existing.hanViet || normalizeHanViet(entry.hanViet),
    notes: [
      ...(Array.isArray(entry.notes) ? entry.notes : []),
      'definition-merged-from-existing-app-entry',
    ],
  };
}

function loadAppVocabCandidates(appContentRoot, level) {
  const levelRoot = path.join(appContentRoot, level.toLowerCase());
  const files = listJsonFiles(levelRoot).filter((file) => isBaseVocabFile(file));
  const rows = [];
  for (const file of files) {
    let payload;
    try {
      payload = JSON.parse(fs.readFileSync(file, 'utf8'));
    } catch (_) {
      continue;
    }
    const entries = Array.isArray(payload.entries) ? payload.entries : [];
    for (const raw of entries) {
      const lemma = raw.lemma || {};
      const sense = raw.sense || {};
      const term = cleanText(lemma.term);
      const meaningVi = cleanText(sense.meaningVi);
      if (!term || !meaningVi || term.includes('?') || meaningVi.includes('?')) continue;
      rows.push({
        term,
        reading: cleanText(lemma.reading) || null,
        hanViet: normalizeHanViet(lemma.labels?.hanViet || raw.legacy?.kanjiMeaning),
        meaningVi,
        meaningEnHint: cleanText(sense.meaningEn) || null,
        source: 'current-app-vocab-jmdict-pos',
      });
    }
  }
  rows.sort((a, b) => {
    const ak = `${kanjiCount(b.term) - kanjiCount(a.term)}`;
    if (ak !== '0') return Number(ak);
    return normalizedTermReading(a).localeCompare(normalizedTermReading(b), 'ja');
  });
  return rows;
}

function isBaseVocabFile(file) {
  const normalized = file.replace(/\\/g, '/');
  return !normalized.endsWith('/index.json') && !normalized.includes('/mimikara/');
}

function listJsonFiles(root) {
  if (!fs.existsSync(root)) return [];
  const files = [];
  for (const entry of fs.readdirSync(root, { withFileTypes: true })) {
    const full = path.join(root, entry.name);
    if (entry.isDirectory()) {
      files.push(...listJsonFiles(full));
    } else if (entry.isFile() && entry.name.endsWith('.json')) {
      files.push(full);
    }
  }
  return files;
}

function groupEntriesByUnit(entries, level) {
  const byUnit = new Map();
  for (const entry of entries) {
    const unit = unitNumber(entry.sourceSection) || 1;
    if (!byUnit.has(unit)) byUnit.set(unit, []);
    byUnit.get(unit).push(entry);
  }
  return [...byUnit.entries()]
    .sort((a, b) => a[0] - b[0])
    .map(([unitId, unitEntries]) => ({
      unitId,
      lessonId: unitId,
      level,
      title: `Unit ${String(unitId).padStart(2, '0')}`,
      entries: unitEntries,
    }));
}

function unitNumber(sourceSection) {
  const match = String(sourceSection ?? '').match(/Unit\s+(\d+)/i);
  return match ? Number(match[1]) : null;
}

function writeLevelAssets({ assetRoot, manifestRoot, level, units, source }) {
  const lower = level.toLowerCase();
  const outDir = path.join(assetRoot, lower, 'mimikara');
  fs.mkdirSync(outDir, { recursive: true });
  fs.mkdirSync(manifestRoot, { recursive: true });

  const index = {
    schemaVersion: 1,
    dataset: 'vocab',
    series: 'mimikara',
    textbookId: `mimikara_${lower}`,
    level,
    generatedAt,
    sourceMode: source.sourceMode,
    sourceCredit: source.sourceCredit,
    copyrightPolicy: 'Factual fields only; no long examples, explanations, or mnemonics copied.',
    units: units.map((unit) => ({
      unitId: unit.unitId,
      lessonId: unit.lessonId,
      title: unit.title,
      termCount: unit.entries.length,
      file: `unit_${String(unit.unitId).padStart(2, '0')}.json`,
      previewTerms: unit.entries.slice(0, 4).map((entry) => entry.term),
      sourceMode: unit.entries[0]?.sourceMode || source.sourceMode,
    })),
  };

  fs.writeFileSync(path.join(outDir, 'index.json'), stableJson(index), 'utf8');

  for (const unit of units) {
    const unitFile = `unit_${String(unit.unitId).padStart(2, '0')}.json`;
    const payload = {
      schemaVersion: 2,
      dataset: 'vocab',
      series: 'mimikara',
      level,
      unitId: unit.unitId,
      lessonId: unit.lessonId,
      unitTitle: unit.title,
      entryCount: unit.entries.length,
      sourceMode: unit.entries[0]?.sourceMode || source.sourceMode,
      entries: unit.entries.map((entry, index) =>
        toAssetEntry({ entry, level, unitId: unit.unitId, order: index + 1 }),
      ),
    };
    fs.writeFileSync(path.join(outDir, unitFile), stableJson(payload), 'utf8');
  }

  const lessonIndex = {
    schema_version: 1,
    generated_at: generatedAt,
    textbook_id: `mimikara_${lower}`,
    lessons: units.map((unit) => ({
      lesson_id: `mimikara_${lower}_${String(unit.unitId).padStart(2, '0')}`,
      lesson_number_ja: `Unit ${unit.unitId}`,
      lesson_number_vi: `Unit ${unit.unitId}`,
      theme_ja: unit.title,
      theme_vi: unit.title,
      item_counts: { vocab: unit.entries.length },
      est_minutes: Math.max(12, Math.min(45, Math.ceil(unit.entries.length / 3))),
      prerequisites: [],
    })),
  };
  fs.writeFileSync(
    path.join(manifestRoot, `lesson_index_mimikara_${lower}.json`),
    stableJson(lessonIndex),
    'utf8',
  );

  for (const unit of units) {
    const itemIndex = {
      schema_version: 1,
      generated_at: generatedAt,
      textbook_id: `mimikara_${lower}`,
      lesson_id: `mimikara_${lower}_${String(unit.unitId).padStart(2, '0')}`,
      items: unit.entries.map((entry, index) => ({
        item_id: `vocab:${lower}:mimikara:${String(unit.unitId).padStart(2, '0')}:${slug(entry.term)}`,
        type: 'vocab',
        surface: entry.term,
        reading: entry.reading || null,
        label_ja: entry.term,
        label_vi: entry.meaningVi,
        order: index + 1,
        legacy_ref: {
          file: `vocab/${lower}/mimikara/unit_${String(unit.unitId).padStart(2, '0')}.json`,
          entry_id: `mimi_${lower}_u${String(unit.unitId).padStart(2, '0')}_${String(index + 1).padStart(3, '0')}`,
          key: `vocab/${lower}/mimikara/unit_${String(unit.unitId).padStart(2, '0')}.json#${entry.term}`,
        },
        exercise_bank_ref: `exercises/${lower}/mimikara/mimikara_${lower}_${String(unit.unitId).padStart(2, '0')}.json`,
      })),
    };
    fs.writeFileSync(
      path.join(
        manifestRoot,
        `item_index_mimikara_${lower}_mimikara_${lower}_${String(unit.unitId).padStart(2, '0')}.json`,
      ),
      stableJson(itemIndex),
      'utf8',
    );
  }

  const fullText = fs.readFileSync(path.join(outDir, 'index.json'), 'utf8');
  if (containsBannedSourceLeak(fullText)) {
    throw new Error(`Banned source leak in Mimikara ${level} index`);
  }
}

function toAssetEntry({ entry, level, unitId, order }) {
  const lower = level.toLowerCase();
  const paddedUnit = String(unitId).padStart(2, '0');
  const paddedOrder = String(order).padStart(3, '0');
  const term = cleanText(entry.term);
  const reading = cleanText(entry.reading) || null;
  const meaningVi = cleanText(entry.meaningVi);
  const meaningEn = cleanText(entry.meaningEnHint) || null;
  const hanViet = normalizeHanViet(entry.hanViet);
  const tags = [
    'mimikara',
    entry.sourceMode === 'app-jmdict-whitelist-fill-OQ011'
      ? 'online-whitelisted-fill-OQ011'
      : 'source-owner-local-mimikara',
    'vi-source-verified',
  ];

  return {
    entryId: `mimi_${lower}_u${paddedUnit}_${paddedOrder}`,
    lessonId: unitId,
    unitId,
    level,
    order,
    tags,
    classification: {
      script: kanjiCount(term) > 0 ? 'mixed' : 'kana',
      hasKanji: kanjiCount(term) > 0,
      origin: 'mimikara',
    },
    lemma: {
      vocabId: `mimi_${lower}_u${paddedUnit}_v${paddedOrder}`,
      term,
      reading,
      kanji: kanjiChars(term),
      labels: { hanViet },
    },
    sense: {
      senseId: `mimi_${lower}_u${paddedUnit}_s${paddedOrder}`,
      meaningVi,
      meaningEn,
    },
    search: {
      termNoAccent: term,
      readingNoAccent: reading,
      meaningViNoAccent: removeVietnameseAccent(meaningVi),
      hanVietNoAccent: removeVietnameseAccent(hanViet || ''),
    },
    links: {
      sourceVocabId: `mimi_${lower}_u${paddedUnit}_v${paddedOrder}`,
      sourceSenseId: `mimi_${lower}_u${paddedUnit}_s${paddedOrder}`,
      sourceBook: `Mimikara ${level}`,
      sourceUnit: unitId,
      sourceOrder: order,
      sourceMode: entry.sourceMode,
    },
    legacy: {
      kanjiMeaning: hanViet,
    },
    lessonRoute: {
      series: 'mimikara',
      routeType: 'unit',
      routeOrder: unitId,
      categoryTitle: `Mimikara ${level}`,
      rangeStart: paddedOrder,
      rangeEnd: paddedOrder,
      officialLabel: `Unit ${unitId}`,
    },
  };
}

function normalizeHanViet(value) {
  const text = cleanText(value);
  if (!text) return null;
  return text
    .split(/\s+/)
    .map((part) => {
      const lower = part.toLocaleLowerCase('vi-VN');
      return lower.charAt(0).toLocaleUpperCase('vi-VN') + lower.slice(1);
    })
    .join(' ');
}

function updateTextbookIndex(manifestRoot, levels) {
  const file = path.join(manifestRoot, 'textbook_index.json');
  if (!fs.existsSync(file)) return;
  const payload = JSON.parse(fs.readFileSync(file, 'utf8'));
  if (!Array.isArray(payload.textbooks)) return;
  for (const book of payload.textbooks) {
    const match = String(book.textbook_id || '').match(/^mimikara_n([123])$/);
    if (!match) continue;
    const level = `N${match[1]}`;
    const summary = levels[level];
    if (!summary) continue;
    book.categories = ['vocab'];
    book.source_credit = 'Owner-provided local Mimikara facts; no prose copied';
    book.migration_status = 'live';
    book.lesson_count = summary.unitCount;
    book.item_count_total = summary.itemCount;
  }
  fs.writeFileSync(file, stableJson(payload), 'utf8');
}

function writeFillMarkdown(canonicalDir, level, unit, entries) {
  const lower = level.toLowerCase();
  const file = path.join(
    canonicalDir,
    `mimikara-${lower}-unit${String(unit).padStart(2, '0')}-fill.md`,
  );
  const lines = [
    `# Mimikara ${level} Unit ${String(unit).padStart(2, '0')} Fill`,
    '',
    'Source policy: OQ-011 owner-authorized fill from current app data plus JMdict-style factual fields; no banned sites accessed.',
    '',
    `Entries: ${entries.length}`,
    '',
  ];
  entries.forEach((entry, index) => {
    lines.push(`### ${String(index + 1).padStart(4, '0')}. ${entry.term}`);
    lines.push('');
    lines.push('```yaml');
    lines.push(`term: ${entry.term}`);
    lines.push(`reading: ${entry.reading || 'null'}`);
    lines.push(`hanViet: ${entry.hanViet || 'null'}`);
    lines.push(`meaningVi: ${entry.meaningVi}`);
    lines.push(`meaningEnHint: ${entry.meaningEnHint || 'null'}`);
    lines.push(`level: ${level}`);
    lines.push('source: online-whitelisted-fill-OQ011');
    lines.push(`sourceSection: Unit ${unit}`);
    lines.push('confidence: fallback-from-current-app-and-jmdict');
    lines.push('notes: [deduped-normalized-term-reading, owner-approved-OQ011-fill]');
    lines.push('```');
    lines.push('');
  });
  fs.writeFileSync(file, lines.join('\n'), 'utf8');
}

function appendDecisionAndOqLogs({ result }) {
  const decisionsFile = path.join(repoRoot, 'docs', 'research', 'decisions-log-2026-05-21.md');
  appendOnce(
    decisionsFile,
    '## DECISION-043 - Mimikara N1-N3 live assets use sanitized factual fields',
    `
## DECISION-043 - Mimikara N1-N3 live assets use sanitized factual fields
**Phase**: Follow-up Sprint 1 Phase B/C
**Date**: 2026-05-21 18:30 (local)
**Context**: OQ-005 requires Mimikara live by 2026-05-22; OQ-014 clarified that Mimikara vocabulary exists only for N3/N2/N1 and four N1/N2 units are missing.
**Options considered**: keep planned placeholders | copy source filenames/prose | generate sanitized factual assets from canonical markdown plus OQ-011 fill
**Chosen**: generate static Mimikara N3/N2/N1 assets/manifests from factual fields only, strip banned source filenames/brands, and fill missing N1/N2 units from current-app/JMdict-compatible factual rows.
**Rationale**: This removes dead UI, keeps copyright-safe fact extraction, avoids banned sites, and aligns Mimikara with the real product scope.
**Reversible**: yes
**Owner review**: pending
`,
  );
}

function appendLoopStatus(result) {
  const file = path.join(repoRoot, 'docs', 'research', 'autonomous-loop-status.md');
  const summary = Object.entries(result.levels)
    .map(([level, data]) => `${level} ${data.unitCount} units/${data.itemCount} terms`)
    .join(', ');
  appendOnce(
    file,
    '## 2026-05-21 Follow-up Sprint Phase B/C Mimikara assets',
    `
## 2026-05-21 Follow-up Sprint Phase B/C Mimikara assets

- Generated sanitized live Mimikara static assets and lesson/item manifests for real product levels only: ${summary}.
- Filled OQ-011 missing units with deduped current-app/JMdict-compatible factual rows; wrote fill markdown docs for N1 units 06/10 and N2 units 05/09 when source gaps existed.
- Logged DECISION-043; no banned website was accessed and learner-facing assets do not contain banned source names.
`,
  );
}

function appendOnce(file, marker, text) {
  const current = fs.existsSync(file) ? fs.readFileSync(file, 'utf8') : '';
  if (current.includes(marker)) return;
  fs.appendFileSync(file, text, 'utf8');
}

function normalizedTermReading(entry) {
  const term = cleanText(entry.term);
  const reading = cleanText(entry.reading);
  if (!term) return '';
  return `${term}|${reading}`.toLowerCase();
}

function cleanText(value) {
  if (value == null) return '';
  const text = String(value).trim();
  if (!text || text === 'null') return '';
  return text.replace(/\s+/g, ' ');
}

function slug(value) {
  return cleanText(value).replace(/[\\/#?%\s]+/g, '_');
}

function kanjiChars(value) {
  return [...cleanText(value)].filter((char) => /[\u4e00-\u9fff]/u.test(char));
}

function kanjiCount(value) {
  return kanjiChars(value).length;
}

function removeVietnameseAccent(value) {
  return cleanText(value)
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/đ/g, 'd')
    .replace(/Đ/g, 'D');
}

function stableJson(value) {
  const text = JSON.stringify(value, null, 2);
  if (containsBannedSourceLeak(text)) {
    throw new Error('Banned source attribution leak detected');
  }
  return `${text}\n`;
}

if (require.main === module) {
  const args = new Set(process.argv.slice(2));
  const result = buildMimikaraAssets({ writeDocs: args.has('--write-docs') });
  console.log(JSON.stringify(result, null, 2));
}

module.exports = {
  parseCanonicalMarkdown,
  buildMimikaraAssets,
  containsBannedSourceLeak,
  loadAppVocabCandidates,
};
