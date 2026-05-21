#!/usr/bin/env node

const childProcess = require('node:child_process');
const fs = require('node:fs');
const path = require('node:path');

const DEFAULT_ROOT =
  'C:\\Users\\xboxo\\Desktop\\PC\\Tai lieu JPStudy\\Tu Vung';
const DEFAULT_POPPLER_BIN =
  'C:\\Users\\xboxo\\AppData\\Local\\Microsoft\\WinGet\\Packages\\oschwartz10612.Poppler_Microsoft.Winget.Source_8wekyb3d8bbwe\\poppler-25.07.0\\Library\\bin';

function normalizePathForProfile(relativePath) {
  return String(relativePath || '').replace(/\\/g, '/');
}

function detectSourceProfile(relativePath) {
  const rel = normalizePathForProfile(relativePath);
  let match = rel.match(/^Tu Vung Mina 1\/bai(\d+)_/i);
  if (match) {
    const unit = Number(match[1]);
    return {
      source: 'minna-1',
      level: 'N5',
      sourceSection: `Lesson ${unit}`,
      sourceUnit: unit,
      contentType: 'vocab',
    };
  }

  match = rel.match(/^Tu Vung Mina 2\/bai(\d+)_/i);
  if (match) {
    const unit = Number(match[1]);
    return {
      source: 'minna-2',
      level: 'N4',
      sourceSection: `Lesson ${unit}`,
      sourceUnit: unit,
      contentType: 'vocab',
    };
  }

  match = rel.match(/^Tu Vung Mimikara N([123])\/unit(\d+)_/i);
  if (match) {
    const level = `N${match[1]}`;
    const unit = Number(match[2]);
    return {
      source: `mimikara-${level.toLowerCase()}`,
      level,
      sourceSection: `Unit ${unit}`,
      sourceUnit: unit,
      contentType: 'vocab',
    };
  }

  match = rel.match(/^Tu Vung Theo Kanji\/N([2345])\/unit(\d+)_/i);
  if (match) {
    const level = `N${match[1]}`;
    const unit = Number(match[2]);
    return {
      source: `kanji-vocab-${level.toLowerCase()}`,
      level,
      sourceSection: `Unit ${unit}`,
      sourceUnit: unit,
      contentType: 'vocab',
    };
  }

  return null;
}

function normalizeSpaces(value) {
  return String(value || '').replace(/\s+/g, ' ').trim();
}

function parseVocabLine(line) {
  const cleaned = normalizeSpaces(line);
  const split = cleaned.match(/^(.*?)\s+[-–—]\s+(.+)$/u);
  if (!split) return null;

  const head = normalizeSpaces(split[1]);
  const headMatch = head.match(/^(.*?)\s+[（(]\s*(.*)\s*[）)]$/u);
  if (!headMatch) return null;

  const term = normalizeSpaces(headMatch[1]);
  const reading = normalizeSpaces(headMatch[2]).replace(/\s+/g, '') || null;
  let tail = normalizeSpaces(split[2]);
  if (!term || !tail) return null;
  const notes = reading === null ? ['missing-reading-in-source'] : [];

  if (/^[-–—]\s*/.test(tail)) {
    tail = normalizeSpaces(tail.replace(/^[-–—]\s*/, ''));
    return {
      term,
      reading,
      hanViet: null,
      meaningVi: tail,
      notes: [...notes, 'no-han-viet-in-source'],
    };
  }

  const segments = tail
    .split(/\s+-\s+/)
    .map((part) => normalizeSpaces(part))
    .filter(Boolean);

  if (segments.length >= 2) {
    return {
      term,
      reading,
      hanViet: segments[0],
      meaningVi: segments.slice(1).join(' - '),
      notes,
    };
  }

  return {
    term,
    reading,
    hanViet: null,
    meaningVi: segments[0] || tail,
    notes: [...notes, 'no-han-viet-in-source'],
  };
}

function parseOfflineVocabText(text, context) {
  const pages = String(text || '').split('\f');
  const entries = [];
  let reviewRows = 0;
  let nonEmptyRows = 0;

  pages.forEach((pageText, pageIndex) => {
    const sourcePage = pageIndex + 1;
    for (const rawLine of pageText.split(/\r?\n/)) {
      const line = normalizeSpaces(rawLine);
      if (!line) continue;
      nonEmptyRows += 1;
      const parsed = parseVocabLine(line);
      if (!parsed) {
        if (/[ぁ-んァ-ン\u3400-\u9fff]/u.test(line) && /[（(][^）)]+[）)]/.test(line)) {
          reviewRows += 1;
        }
        continue;
      }
      entries.push({
        term: parsed.term,
        reading: parsed.reading,
        hanViet: parsed.hanViet,
        posTags: [],
        meaningVi: parsed.meaningVi,
        meaningEnHint: null,
        level: context.level,
        source: context.source,
        sourceFile: context.sourceFile,
        sourceSection: context.sourceSection,
        sourcePage,
        confidence: 'text-layer',
        notes: parsed.notes,
      });
    }
  });

  return {
    entries,
    report: {
      source: context.source,
      level: context.level,
      sourceFile: context.sourceFile,
      acceptedRows: entries.length,
      reviewRows,
      nonEmptyRows,
      textPages: pages.length,
      confidence: 'text-layer',
    },
  };
}

function yamlScalar(value) {
  if (value === null || value === undefined) return 'null';
  if (typeof value === 'number') return String(value);
  if (Array.isArray(value)) {
    if (value.length === 0) return '[]';
    return `[${value.map((item) => yamlScalar(item)).join(', ')}]`;
  }
  const text = String(value);
  if (/^[\p{L}\p{N}\p{Script=Hiragana}\p{Script=Katakana}\p{Script=Han}\s._/()[\]-]+$/u.test(text)) {
    return text;
  }
  return JSON.stringify(text);
}

function formatCanonicalMarkdown(sourceId, entries, report = {}) {
  const generatedAt = report.generatedAt || new Date().toISOString();
  const lines = [
    `# Canonical Vocab - ${sourceId}`,
    '',
    `Generated: ${generatedAt}`,
    `Source: ${sourceId}`,
    `Accepted rows: ${report.acceptedRows ?? entries.length}`,
    `Review rows: ${report.reviewRows ?? 0}`,
    `Source files: ${report.sourceFiles ?? 0}`,
    '',
    'Copyright safety: factual fields only; no long examples, explanations, or mnemonics copied.',
    '',
    '## Entries',
    '',
  ];

  entries.forEach((entry, index) => {
    lines.push(`### ${String(index + 1).padStart(4, '0')}. ${entry.term}`);
    lines.push('');
    lines.push('```yaml');
    for (const key of [
      'term',
      'reading',
      'hanViet',
      'posTags',
      'meaningVi',
      'meaningEnHint',
      'level',
      'source',
      'sourceFile',
      'sourceSection',
      'sourcePage',
      'confidence',
      'notes',
    ]) {
      lines.push(`${key}: ${yamlScalar(entry[key])}`);
    }
    lines.push('```');
    lines.push('');
  });

  return `${lines.join('\n')}\n`;
}

function walkFiles(dir, out = []) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      walkFiles(full, out);
    } else {
      out.push(full);
    }
  }
  return out;
}

function readPdfText(file, { popplerBin = DEFAULT_POPPLER_BIN } = {}) {
  const exe = path.join(popplerBin, 'pdftotext.exe');
  return childProcess.execFileSync(
    exe,
    ['-layout', '-enc', 'UTF-8', file, '-'],
    { encoding: 'utf8', maxBuffer: 64 * 1024 * 1024 },
  );
}

function extractSource({
  rootDir = DEFAULT_ROOT,
  source,
  popplerBin = DEFAULT_POPPLER_BIN,
} = {}) {
  const entries = [];
  const fileReports = [];
  const pdfFiles = walkFiles(rootDir)
    .filter((file) => file.toLowerCase().endsWith('.pdf'))
    .map((file) => ({
      file,
      rel: normalizePathForProfile(path.relative(rootDir, file)),
      profile: detectSourceProfile(path.relative(rootDir, file)),
    }))
    .filter((item) => item.profile && (!source || item.profile.source === source))
    .sort((a, b) => {
      if (a.profile.sourceUnit !== b.profile.sourceUnit) {
        return a.profile.sourceUnit - b.profile.sourceUnit;
      }
      return a.rel.localeCompare(b.rel);
    });

  for (const item of pdfFiles) {
    const text = readPdfText(item.file, { popplerBin });
    const parsed = parseOfflineVocabText(text, {
      ...item.profile,
      sourceFile: item.rel,
    });
    entries.push(...parsed.entries);
    fileReports.push(parsed.report);
  }

  return {
    source,
    entries,
    report: {
      source,
      sourceFiles: pdfFiles.length,
      acceptedRows: entries.length,
      reviewRows: fileReports.reduce((sum, item) => sum + item.reviewRows, 0),
      nonEmptyRows: fileReports.reduce((sum, item) => sum + item.nonEmptyRows, 0),
      fileReports,
      generatedAt: new Date().toISOString(),
    },
  };
}

function parseArgs(argv) {
  const options = {};
  for (let i = 2; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === '--dry-run') {
      options.dryRun = true;
    } else if (arg.startsWith('--')) {
      options[arg.slice(2)] = argv[i + 1];
      i += 1;
    }
  }
  return options;
}

function main() {
  const args = parseArgs(process.argv);
  if (!args.source) {
    throw new Error('Usage: extract_offline_vocab_canonical.js --source <source-id> [--out file] [--report file]');
  }

  const result = extractSource({
    rootDir: args.root || DEFAULT_ROOT,
    source: args.source,
    popplerBin: args.popplerBin || DEFAULT_POPPLER_BIN,
  });

  if (args.dryRun) {
    console.log(JSON.stringify(result.report, null, 2));
    return;
  }

  const out =
    args.out ||
    path.join(
      process.cwd(),
      'docs',
      'research',
      'canonical',
      'vocab',
      `${args.source}.md`,
    );
  const reportOut =
    args.report ||
    path.join(
      process.cwd(),
      'docs',
      'research',
      'canonical',
      'vocab',
      'reports',
      `${args.source}.json`,
    );

  fs.mkdirSync(path.dirname(out), { recursive: true });
  fs.mkdirSync(path.dirname(reportOut), { recursive: true });
  fs.writeFileSync(
    out,
    formatCanonicalMarkdown(args.source, result.entries, result.report),
    'utf8',
  );
  fs.writeFileSync(reportOut, `${JSON.stringify(result.report, null, 2)}\n`, 'utf8');
  console.log(
    `extracted ${args.source}: ${result.entries.length} rows from ${result.report.sourceFiles} files`,
  );
}

if (require.main === module) {
  main();
}

module.exports = {
  detectSourceProfile,
  extractSource,
  formatCanonicalMarkdown,
  parseOfflineVocabText,
  parseVocabLine,
};
