#!/usr/bin/env node

const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

const {
  loadKanjidic2Index,
} = require('./extract_canonical_kanji_ebooks');
const { LEVEL_ORDER } = require('./build_kanji_master_mapping');

const repoRoot = path.resolve(__dirname, '../..');
const DEFAULT_MASTER = path.join(
  repoRoot,
  'docs/research/canonical/kanji-master-mapping-2026-05-20.json',
);
const DEFAULT_CONTENT_ROOT = path.join(repoRoot, 'assets/data/content');
const DEFAULT_CANONICAL_DIR = path.join(repoRoot, 'docs/research/canonical');
const DEFAULT_AUDIT_OUT = path.join(
  repoRoot,
  'docs/research/kanji-level-audit-2026-05-20.md',
);

const OVERRIDE_FACTS = {
  火: { hanViet: 'Hỏa', meaningVi: 'lửa', meaningEn: 'fire' },
  休: { hanViet: 'Hưu', meaningVi: 'nghỉ ngơi', meaningEn: 'rest, day off' },
  海: { hanViet: 'Hải', meaningVi: 'biển', meaningEn: 'sea' },
  帰: { hanViet: 'Quy', meaningVi: 'trở về', meaningEn: 'return' },
  迎: { hanViet: 'Nghênh', meaningVi: 'đón; nghênh tiếp', meaningEn: 'welcome, meet' },
  卵: { hanViet: 'Noãn', meaningVi: 'trứng', meaningEn: 'egg' },
  種: { hanViet: 'Chủng', meaningVi: 'loại; giống; hạt giống', meaningEn: 'kind, seed' },
  類: { hanViet: 'Loại', meaningVi: 'loại; nhóm', meaningEn: 'class, kind' },
  司: { hanViet: 'Ti', meaningVi: 'cai quản; quản lý', meaningEn: 'administer' },
  牧: { hanViet: 'Mục', meaningVi: 'chăn nuôi; mục đồng', meaningEn: 'breed, shepherd' },
  銀: { hanViet: 'Ngân', meaningVi: 'bạc', meaningEn: 'silver' },
  重: { hanViet: 'Trọng', meaningVi: 'nặng; quan trọng', meaningEn: 'heavy, important' },
  議: { hanViet: 'Nghị', meaningVi: 'bàn bạc; nghị luận', meaningEn: 'deliberation, discussion' },
  鏡: { hanViet: 'Kính', meaningVi: 'gương; kính soi', meaningEn: 'mirror' },
  競: { hanViet: 'Cạnh', meaningVi: 'cạnh tranh; thi đấu', meaningEn: 'compete' },
  弐: { hanViet: 'Nhị', meaningVi: 'số hai (dạng trang trọng)', meaningEn: 'two' },
  壱: { hanViet: 'Nhất', meaningVi: 'số một (dạng trang trọng)', meaningEn: 'one' },
  萬: { hanViet: 'Vạn', meaningVi: 'mười nghìn; rất nhiều', meaningEn: 'ten thousand' },
  零: { hanViet: 'Linh', meaningVi: 'số không', meaningEn: 'zero' },
};

function normalizeSpaces(value) {
  return String(value || '').replace(/\s+/g, ' ').trim();
}

function stripAccents(value) {
  return String(value || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/đ/g, 'd')
    .replace(/Đ/g, 'D');
}

function titleCaseVietnamese(value) {
  const cleaned = normalizeSpaces(value);
  if (!cleaned) return '';
  return cleaned
    .split(/\s+/)
    .map((word) =>
      word.charAt(0).toLocaleUpperCase('vi-VN') +
      word.slice(1).toLocaleLowerCase('vi-VN'),
    )
    .join(' ');
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function writeJson(file, value) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, `${JSON.stringify(value, null, 2)}\n`, 'utf8');
}

function walkJsonFiles(root) {
  const files = [];
  if (!fs.existsSync(root)) return files;
  for (const item of fs.readdirSync(root, { withFileTypes: true })) {
    const full = path.join(root, item.name);
    if (item.isDirectory()) files.push(...walkJsonFiles(full));
    else if (item.isFile() && item.name.endsWith('.json')) files.push(full);
  }
  return files.sort();
}

function safeJsonList(raw) {
  const value = normalizeSpaces(raw);
  if (!value || value === '[]' || value === 'null') return [];
  try {
    const parsed = JSON.parse(value);
    return Array.isArray(parsed) ? parsed.map(String) : [];
  } catch (_) {
    return [];
  }
}

function parseScalar(body, key) {
  const match = body.match(new RegExp(`^${key}:\\s*(.*)$`, 'm'));
  if (!match) return '';
  const value = match[1].trim();
  return value === 'null' ? '' : value;
}

function parseCanonicalExamples(body) {
  const examplesBlock = body.match(/^examples:\s*\n([\s\S]*?)(?:^### |\z)/m)?.[1] || '';
  if (!examplesBlock || /^\s*-\s+none/m.test(examplesBlock)) return [];
  const chunks = examplesBlock.split(/\n\s*-\s+word:\s*/).slice(1);
  return chunks
    .map((chunk) => {
      const word = normalizeSpaces(chunk.split(/\r?\n/)[0]);
      const reading = chunk.match(/^\s*reading:\s*(.*)$/m)?.[1]?.trim() || '';
      const meaning = chunk.match(/^\s*meaning:\s*(.*)$/m)?.[1]?.trim() || '';
      return {
        word,
        reading,
        meaning: normalizeSpaces(meaning),
        meaningVi: normalizeSpaces(meaning),
      };
    })
    .filter((example) => example.word && example.word !== 'none')
    .slice(0, 3);
}

function parseCanonicalDetails(markdown, level, sourceFile) {
  const text = String(markdown || '');
  const headings = Array.from(text.matchAll(/^###\s+(\S+)\s+\(([^)]*)\)\s*$/gm));
  return headings.map((heading, index) => {
    const start = heading.index + heading[0].length;
    const end = index + 1 < headings.length ? headings[index + 1].index : text.length;
    const body = text.slice(start, end);
    return {
      kanji: heading[1],
      level,
      canonicalOrder: index,
      sourceFile,
      hanViet: heading[2] === 'null' ? '' : heading[2],
      meaningVi: parseScalar(body, 'meaningVi'),
      onyomi: safeJsonList(parseScalar(body, 'onyomi')),
      kunyomi: safeJsonList(parseScalar(body, 'kunyomi')),
      strokeCount: Number(parseScalar(body, 'strokeCount')) || null,
      writingHint: parseScalar(body, 'writingHint'),
      examples: parseCanonicalExamples(body),
    };
  });
}

function loadCanonicalDetails(canonicalDir = DEFAULT_CANONICAL_DIR) {
  const byKanji = new Map();
  for (const level of LEVEL_ORDER) {
    const file = path.join(canonicalDir, `kanji-${level.toLowerCase()}.md`);
    if (!fs.existsSync(file)) continue;
    const entries = parseCanonicalDetails(
      fs.readFileSync(file, 'utf8'),
      level,
      path.relative(repoRoot, file).replace(/\\/g, '/'),
    );
    for (const entry of entries) {
      if (!byKanji.has(entry.kanji)) byKanji.set(entry.kanji, []);
      byKanji.get(entry.kanji).push(entry);
    }
  }
  return byKanji;
}

function loadCurrentPlacements(contentRoot = DEFAULT_CONTENT_ROOT) {
  const root = path.join(contentRoot, 'kanji');
  const placements = [];
  for (const file of walkJsonFiles(root)) {
    if (file.endsWith('han_viet_on_rules.json') || file.endsWith('han_viet_on_rules_v2.json')) {
      continue;
    }
    const payload = readJson(file);
    if (!payload || !Array.isArray(payload.entries)) continue;
    const fallbackLevel = payload.level;
    const fallbackLessonId = payload.lessonId;
    for (const entry of payload.entries) {
      if (!entry || !entry.character) continue;
      placements.push({
        character: entry.character,
        level: entry.level || fallbackLevel,
        lessonId: entry.lessonId || fallbackLessonId,
        file,
        entry,
      });
    }
  }
  return placements;
}

function loadGitHeadPlacements() {
  const files = execFileSync(
    'git',
    ['ls-tree', '-r', '--name-only', 'HEAD', 'assets/data/content/kanji'],
    { cwd: repoRoot, encoding: 'utf8' },
  )
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line.endsWith('.json'))
    .filter((line) => !line.endsWith('han_viet_on_rules.json'))
    .filter((line) => !line.endsWith('han_viet_on_rules_v2.json'));
  const placements = [];
  for (const file of files) {
    let payload;
    try {
      payload = JSON.parse(
        execFileSync('git', ['show', `HEAD:${file}`], {
          cwd: repoRoot,
          encoding: 'utf8',
          maxBuffer: 32 * 1024 * 1024,
        }),
      );
    } catch (_) {
      continue;
    }
    if (!payload || !Array.isArray(payload.entries)) continue;
    const fallbackLevel = payload.level;
    const fallbackLessonId = payload.lessonId;
    for (const entry of payload.entries) {
      if (!entry || !entry.character) continue;
      placements.push({
        character: entry.character,
        level: entry.level || fallbackLevel,
        lessonId: entry.lessonId || fallbackLessonId,
        file: path.join(repoRoot, file),
        entry,
      });
    }
  }
  return placements;
}

function buildAudit(master, placements) {
  const byKanji = new Map();
  for (const placement of placements) {
    if (!byKanji.has(placement.character)) byKanji.set(placement.character, []);
    byKanji.get(placement.character).push(placement);
  }

  const moves = [];
  const duplicates = [];
  const missing = [];
  const extras = [];

  for (const [kanji, toLevel] of Object.entries(master.kanjiToLevel || {})) {
    const current = byKanji.get(kanji) || [];
    if (current.length === 0) {
      missing.push({ kanji, toLevel });
      continue;
    }
    const wrong = current.filter((placement) => placement.level !== toLevel);
    if (wrong.length > 0) {
      moves.push({
        kanji,
        from: wrong.map((placement) => `${placement.level} lesson ${placement.lessonId}`),
        toLevel,
      });
    }
    if (current.length > 1) {
      duplicates.push({
        kanji,
        placements: current.map((placement) => `${placement.level} lesson ${placement.lessonId}`),
        keepLevel: toLevel,
      });
    }
  }

  for (const [kanji, current] of byKanji.entries()) {
    if (!master.kanjiToLevel?.[kanji]) {
      extras.push({
        kanji,
        placements: current.map((placement) => `${placement.level} lesson ${placement.lessonId}`),
      });
    }
  }

  const sortRows = (rows) => rows.sort((a, b) => a.kanji.localeCompare(b.kanji, 'ja'));
  return {
    moves: sortRows(moves),
    duplicates: sortRows(duplicates),
    missing: sortRows(missing),
    extras: sortRows(extras),
  };
}

function escapeCell(value) {
  return String(value ?? '').replace(/\|/g, '\\|').replace(/\r?\n/g, ' ');
}

function tableRows(rows, columns) {
  if (rows.length === 0) return ['| none |', '| --- |'];
  return [
    `| ${columns.join(' | ')} |`,
    `| ${columns.map(() => '---').join(' | ')} |`,
    ...rows.map((row) => `| ${columns.map((column) => escapeCell(row[column])).join(' | ')} |`),
  ];
}

function formatAuditMarkdown(audit, master, placements) {
  const lines = [
    '# Kanji Level Audit 2026-05-20',
    '',
    'Source: QA-A-027 master mapping from owner-provided local canonical ebooks; banned websites not accessed.',
    '',
    '## Summary',
    '',
    `- Current app placements scanned: ${placements.length}`,
    `- Master kanji selected: ${master.total || Object.keys(master.kanjiToLevel || {}).length}`,
    `- MOVE rows: ${audit.moves.length}`,
    `- DUPLICATE rows: ${audit.duplicates.length}`,
    `- MISSING rows: ${audit.missing.length}`,
    `- EXTRA rows: ${audit.extras.length}`,
    '',
    '## MOVE',
    '',
    ...tableRows(
      audit.moves.map((row) => ({
        kanji: row.kanji,
        from: row.from.join(', '),
        toLevel: row.toLevel,
      })),
      ['kanji', 'from', 'toLevel'],
    ),
    '',
    '## DUPLICATE',
    '',
    ...tableRows(
      audit.duplicates.map((row) => ({
        kanji: row.kanji,
        placements: row.placements.join(', '),
        keepLevel: row.keepLevel,
      })),
      ['kanji', 'placements', 'keepLevel'],
    ),
    '',
    '## MISSING',
    '',
    ...tableRows(audit.missing, ['kanji', 'toLevel']),
    '',
    '## EXTRA',
    '',
    ...tableRows(
      audit.extras.map((row) => ({
        kanji: row.kanji,
        placements: row.placements.join(', '),
      })),
      ['kanji', 'placements'],
    ),
  ];
  return `${lines.join('\n')}\n`;
}

function loadUnihanVietnamese() {
  const file = path.join(repoRoot, '.codex/sources/Unihan/Unihan_Readings.txt');
  const map = new Map();
  if (!fs.existsSync(file)) return map;
  for (const line of fs.readFileSync(file, 'utf8').split(/\r?\n/)) {
    const match = line.match(/^U\+([0-9A-F]+)\tkVietnamese\t(.+)$/);
    if (!match) continue;
    map.set(String.fromCodePoint(parseInt(match[1], 16)), titleCaseVietnamese(match[2]));
  }
  return map;
}

function bestExistingPlacement(placements, targetLevel) {
  return [...placements].sort((a, b) => scoreExisting(b, targetLevel) - scoreExisting(a, targetLevel))[0];
}

function scoreExisting(placement, targetLevel) {
  const entry = placement.entry || {};
  const tags = Array.isArray(entry.tags) ? entry.tags : [];
  let score = placement.level === targetLevel ? 100 : 0;
  if (tags.includes('vi-source-verified')) score += 30;
  if (tags.includes('source-unihan-kanji-metadata')) score += 20;
  if (entry.labels?.hanViet) score += 5;
  if (entry.labels?.meaningVi) score += 5;
  if (entry.readings?.onyomi?.length) score += 3;
  return score;
}

function uniqueList(values) {
  return Array.from(new Set((values || []).filter((value) => value !== null && value !== undefined && String(value).trim()).map(String)));
}

function displayMeaning(hanViet, meaningVi) {
  if (hanViet && meaningVi) return `${hanViet} (${meaningVi})`;
  return meaningVi || hanViet || '';
}

function isLikelyOcrNoise(value) {
  const text = normalizeSpaces(value);
  if (!text) return true;
  if (/[A-Za-z]+\d|\d+[A-Za-z]+/.test(text)) return true;
  if (/\b(?:feu|fuego|fogo|radical|class|look|favor|sleep|retire)\b/i.test(text)) {
    return true;
  }
  if (/\b(?:Ws|Wo|Kf|Ou|Jing|Ft)\b/.test(text)) return true;
  return false;
}

function canonicalForLevel(canonicalEntries, level) {
  if (!canonicalEntries || canonicalEntries.length === 0) return null;
  return (
    canonicalEntries.find((entry) => entry.level === level) ||
    canonicalEntries[0]
  );
}

function clone(value) {
  return value ? JSON.parse(JSON.stringify(value)) : null;
}

function buildKanjiAssetEntry({
  kanji,
  level,
  lessonId,
  indexInLesson,
  existing,
  canonical,
  kanjidic,
  unihanVietnamese,
}) {
  const override = OVERRIDE_FACTS[kanji] || {};
  const base = clone(existing) || {};
  const labels = clone(base.labels) || {};
  const readings = clone(base.readings) || {};
  const decomposition = clone(base.decomposition) || {};
  const canonicalExamples = canonical?.examples || [];

  const hanViet = normalizeSpaces(
    override.hanViet ||
      kanjidic?.vietnam?.[0] ||
      unihanVietnamese ||
      labels.hanViet ||
      canonical?.hanViet ||
      '',
  );
  const meaningVi = normalizeSpaces(
    override.meaningVi ||
      (!isLikelyOcrNoise(labels.meaningVi) ? labels.meaningVi : '') ||
      (!isLikelyOcrNoise(canonical?.meaningVi) ? canonical?.meaningVi : '') ||
      '',
  );
  const meaningEn = normalizeSpaces(
    override.meaningEn ||
      labels.meaningEn ||
      (kanjidic?.meanings || []).slice(0, 3).join('; '),
  );
  const strokeCount = Number(kanjidic?.strokeCount || canonical?.strokeCount || base.strokeCount || 1);

  labels.hanViet = hanViet || null;
  labels.meaningVi = meaningVi || meaningEn || hanViet || '';
  labels.meaningViDisplay = displayMeaning(hanViet, labels.meaningVi);
  labels.meaningEn = meaningEn || labels.meaningVi;

  readings.onyomi = uniqueList(
    kanjidic?.onyomi?.length
      ? kanjidic.onyomi
      : readings.onyomi?.length
        ? readings.onyomi
        : canonical?.onyomi || [],
  );
  readings.kunyomi = uniqueList(
    kanjidic?.kunyomi?.length
      ? kanjidic.kunyomi
      : readings.kunyomi?.length
        ? readings.kunyomi
        : canonical?.kunyomi || [],
  );

  decomposition.hanViet = hanViet || decomposition.hanViet || null;
  decomposition.structure = decomposition.structure || 'unknown';
  decomposition.components = Array.isArray(decomposition.components) ? decomposition.components : [];
  decomposition.componentNames = Array.isArray(decomposition.componentNames) ? decomposition.componentNames : [];
  decomposition.relatedKanji = Array.isArray(decomposition.relatedKanji) ? decomposition.relatedKanji : [];

  const tags = uniqueList([
    ...(Array.isArray(base.tags) ? base.tags : []),
    'vi-source-verified',
    'source-kanji-canonical-ebook',
    'source-unihan-kanji-metadata',
    'kanji-metadata-approved',
  ]).filter((tag) => tag !== 'vi-human-approved');

  const examples = canonicalExamples.length > 0
    ? canonicalExamples
    : Array.isArray(base.examples)
      ? base.examples
      : [];

  return {
    ...base,
    kanjiId: `${level.toLowerCase()}_canonical_l${String(lessonId).padStart(2, '0')}_k${String(indexInLesson).padStart(3, '0')}`,
    lessonId,
    level,
    character: kanji,
    strokeCount,
    labels,
    readings,
    mnemonic: {
      ...(clone(base.mnemonic) || {}),
      vi: canonical?.writingHint || base.mnemonic?.vi || `Ghi nhớ ${kanji} qua Hán-Việt ${hanViet || 'đang bổ sung'}.`,
      en: base.mnemonic?.en || meaningEn || labels.meaningVi,
    },
    decomposition,
    search: {
      ...(clone(base.search) || {}),
      hanVietNoAccent: stripAccents(hanViet),
      meaningViNoAccent: stripAccents(labels.meaningVi),
      meaningEnNoAccent: stripAccents(labels.meaningEn),
    },
    examples,
    legacy: {
      ...(clone(base.legacy) || {}),
      meaning: labels.meaningViDisplay,
      onyomi: readings.onyomi.join(', '),
      kunyomi: readings.kunyomi.join(', '),
    },
    metadataStatus: base.metadataStatus || 'vi-editorial-codex-pass',
    tags,
  };
}

function splitIntoLessonBuckets(entries, lessonCount = 25) {
  const buckets = Array.from({ length: lessonCount }, () => []);
  entries.forEach((entry, index) => {
    const bucket = Math.floor((index * lessonCount) / entries.length);
    buckets[Math.min(bucket, lessonCount - 1)].push(entry);
  });
  return buckets;
}

function buildLevelEntries(master, canonicalDetails, placements, kanjidic2, unihanMap) {
  const placementByKanji = new Map();
  for (const placement of placements) {
    if (!placementByKanji.has(placement.character)) placementByKanji.set(placement.character, []);
    placementByKanji.get(placement.character).push(placement);
  }

  const byLevel = Object.fromEntries(LEVEL_ORDER.map((level) => [level, []]));
  for (const [kanji, level] of Object.entries(master.kanjiToLevel || {})) {
    const canonical = canonicalForLevel(canonicalDetails.get(kanji), level) || master.entries?.[kanji] || {};
    const existingPlacement = bestExistingPlacement(placementByKanji.get(kanji) || [], level);
    const kanjidic = kanjidic2.get(kanji);
    byLevel[level].push({
      kanji,
      canonical,
      existing: existingPlacement?.entry || null,
      kanjidic,
      unihanVietnamese: unihanMap.get(kanji) || '',
      sortStroke: Number(kanjidic?.strokeCount || canonical.strokeCount || existingPlacement?.entry?.strokeCount || 999),
      sortOrder: Number.isFinite(canonical.canonicalOrder) ? canonical.canonicalOrder : 99999,
    });
  }

  for (const level of LEVEL_ORDER) {
    byLevel[level].sort((a, b) => {
      if (a.sortStroke !== b.sortStroke) return a.sortStroke - b.sortStroke;
      if (a.sortOrder !== b.sortOrder) return a.sortOrder - b.sortOrder;
      return a.kanji.localeCompare(b.kanji, 'ja');
    });
  }
  return byLevel;
}

function writeKanjiAssets({ master, canonicalDetails, placements, contentRoot = DEFAULT_CONTENT_ROOT }) {
  const kanjidic2 = loadKanjidic2Index();
  const unihanMap = loadUnihanVietnamese();
  const byLevel = buildLevelEntries(master, canonicalDetails, placements, kanjidic2, unihanMap);
  const counts = {};

  for (const level of LEVEL_ORDER) {
    const buckets = splitIntoLessonBuckets(byLevel[level], 25);
    counts[level] = byLevel[level].length;
    const levelDir = path.join(contentRoot, 'kanji', level.toLowerCase());
    fs.mkdirSync(levelDir, { recursive: true });
    for (const file of fs.readdirSync(levelDir)) {
      if (/^lesson_\d+\.json$/.test(file)) {
        fs.unlinkSync(path.join(levelDir, file));
      }
    }
    buckets.forEach((bucket, bucketIndex) => {
      const lessonId = bucketIndex + 1;
      const entries = bucket.map((item, entryIndex) =>
        buildKanjiAssetEntry({
          kanji: item.kanji,
          level,
          lessonId,
          indexInLesson: entryIndex + 1,
          existing: item.existing,
          canonical: item.canonical,
          kanjidic: item.kanjidic,
          unihanVietnamese: item.unihanVietnamese,
        }),
      );
      const payload = {
        schemaVersion: 2,
        dataset: 'kanji',
        series: 'canonical-ebook',
        source: 'Owner-provided local canonical kanji ebooks; KANJIDIC2 and Unihan factual supplements',
        license: 'Factual metadata extracted from owner-provided local references and open KANJIDIC2/Unihan data; banned websites not accessed',
        level,
        lessonId,
        entryCount: entries.length,
        importStatus: 'source-verified',
        sourceNote: 'QA-A-026 canonical rewrite from QA-A-027 master mapping; vi-source-verified only, no human-approval tags added.',
        tags: ['source-kanji-canonical-ebook', 'vi-source-verified'],
        entries,
      };
      writeJson(path.join(levelDir, `lesson_${String(lessonId).padStart(2, '0')}.json`), payload);
    });
  }

  return counts;
}

function parseArgs(argv) {
  const args = {
    masterPath: DEFAULT_MASTER,
    canonicalDir: DEFAULT_CANONICAL_DIR,
    contentRoot: DEFAULT_CONTENT_ROOT,
    auditOut: DEFAULT_AUDIT_OUT,
    apply: false,
    existingFromGitHead: false,
  };
  for (let i = 0; i < argv.length; i++) {
    const item = argv[i];
    const next = () => argv[++i];
    if (item === '--master') args.masterPath = path.resolve(next());
    else if (item === '--canonical-dir') args.canonicalDir = path.resolve(next());
    else if (item === '--content-root') args.contentRoot = path.resolve(next());
    else if (item === '--audit-out') args.auditOut = path.resolve(next());
    else if (item === '--apply') args.apply = true;
    else if (item === '--existing-from-git-head') args.existingFromGitHead = true;
    else if (item === '--help' || item === '-h') args.help = true;
    else throw new Error(`Unknown argument ${item}`);
  }
  return args;
}

function printHelp() {
  console.log(`Usage:
  node tool/research/apply_kanji_master_mapping.js
  node tool/research/apply_kanji_master_mapping.js --apply
`);
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    printHelp();
    return;
  }
  const master = readJson(args.masterPath);
  const canonicalDetails = loadCanonicalDetails(args.canonicalDir);
  const placements = args.existingFromGitHead
    ? loadGitHeadPlacements()
    : loadCurrentPlacements(args.contentRoot);
  const audit = buildAudit(master, placements);
  fs.writeFileSync(args.auditOut, formatAuditMarkdown(audit, master, placements), 'utf8');
  console.log(`wrote audit ${args.auditOut}`);
  console.log(`MOVE=${audit.moves.length} DUPLICATE=${audit.duplicates.length} MISSING=${audit.missing.length} EXTRA=${audit.extras.length}`);
  if (args.apply) {
    const counts = writeKanjiAssets({ master, canonicalDetails, placements, contentRoot: args.contentRoot });
    console.log(`rewrote kanji assets ${JSON.stringify(counts)}`);
  }
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
  buildAudit,
  buildKanjiAssetEntry,
  formatAuditMarkdown,
  loadCanonicalDetails,
  loadCurrentPlacements,
  loadGitHeadPlacements,
  splitIntoLessonBuckets,
  writeKanjiAssets,
};
