const fs = require('node:fs');
const path = require('node:path');

const BANNED_HUMAN_MOMENT_PHRASES = [
  'Nếu câu khó dịch',
  'tách mẫu ra khỏi từ vựng',
  'nghĩa thường hiện rõ',
  'theo dõi dạng phủ định trước',
  'Khoảnh khắc người: Nếu',
];

const REQUIRED_FIELDS = [
  'etymology',
  'hanVietBridge',
  'form',
  'meaning',
  'usage',
  'humanMoment',
  'crossLinks',
];

const SPECIFICITY_RE =
  /gốc|Hán|cấu trúc|thành phần|trợ từ|particle|copula|lịch sử|origin|component|decompos|chữ|事|物|する|なる/i;
const CONTRAST_RE = /khác|phân biệt|trong khi|còn |so với|contrast|vs\.?|≠|nhưng/i;
const DR_LINH_RE = /Dr\.?\s*Linh|Lưu ý nhỏ từ Dr\.?\s*Linh/i;

function validateDirectiveEItem(item, { candidatePatterns = [] } = {}) {
  const directiveE = item.directiveE || item.directive_e || {};
  const itemId = item.item_id || item.itemId || item.id || '(unknown)';
  const label = String(item.label || item.title || item.structure || item.grammarPoint || '');
  const structure = String(item.structure || item.form || label);
  const failures = [];

  for (const field of REQUIRED_FIELDS) {
    if (field === 'crossLinks') {
      if (!Array.isArray(directiveE.crossLinks) || directiveE.crossLinks.length === 0) {
        failures.push(`${itemId}: crossLinks must be non-empty`);
      }
    } else if (!String(directiveE[field] || '').trim()) {
      failures.push(`${itemId}: missing directiveE.${field}`);
    }
  }

  const humanMoment = String(directiveE.humanMoment || '');
  for (const phrase of BANNED_HUMAN_MOMENT_PHRASES) {
    if (humanMoment.includes(phrase)) {
      failures.push(`${itemId}: banned phrase in humanMoment: ${phrase}`);
    }
  }

  const patternRefs = patternReferences({ label, structure, crossLinks: directiveE.crossLinks });
  if (!containsAnyNormalized(humanMoment, patternRefs)) {
    failures.push(`${itemId}: humanMoment lacks pattern-specific reference`);
  }
  if (!DR_LINH_RE.test(humanMoment)) {
    failures.push(`${itemId}: humanMoment must use Dr. Linh voice marker`);
  }
  if (looksSubstitutable({ humanMoment, patternRefs, candidatePatterns })) {
    failures.push(`${itemId}: humanMoment fails substitution test`);
  }

  const etymology = String(directiveE.etymology || '');
  if (Array.from(etymology).length < 80) {
    failures.push(`${itemId}: etymology must be at least 80 chars`);
  }
  if (etymology && !SPECIFICITY_RE.test(etymology)) {
    failures.push(`${itemId}: etymology lacks pattern-specific origin/component/structure`);
  }

  if (Array.isArray(directiveE.crossLinks) && directiveE.crossLinks.length > 0) {
    const hasContrast = directiveE.crossLinks.some((link) => CONTRAST_RE.test(crossLinkText(link)));
    if (!hasContrast) {
      failures.push(`${itemId}: crossLinks need a brief contrast`);
    }
  }

  return {
    item_id: itemId,
    passed: failures.length === 0,
    failures,
  };
}

function validateDirectiveEItems(items, options = {}) {
  const failures = [];
  const itemReports = [];
  const seen = new Set();
  for (const item of items || []) {
    const itemId = item.item_id || item.itemId || item.id || '(unknown)';
    if (seen.has(itemId)) failures.push(`duplicate directiveE item: ${itemId}`);
    seen.add(itemId);
    const report = validateDirectiveEItem(item, options);
    itemReports.push(report);
    failures.push(...report.failures);
  }
  return {
    passed: failures.length === 0,
    failures,
    counts: {
      totalItems: (items || []).length,
      passedItems: itemReports.filter((report) => report.passed).length,
      failedItems: itemReports.filter((report) => !report.passed).length,
    },
    itemReports,
  };
}

function readGrammarDirectiveEItems({
  contentRoot = path.join(process.cwd(), 'assets', 'data', 'content'),
  rankJsonPath = '',
  itemId = '',
} = {}) {
  const wanted = readWantedRankIds(rankJsonPath);
  const root = path.join(contentRoot, 'grammar');
  const items = [];
  for (const file of walk(root)) {
    if (!file.endsWith('.json')) continue;
    const data = readJson(file);
    if (!Array.isArray(data)) continue;
    const rel = toPosix(path.relative(contentRoot, file));
    const basename = path.basename(file, '.json');
    const level = normalizeLevel(levelFromPath(file) || data[0]?.level);
    for (let index = 0; index < data.length; index += 1) {
      const raw = data[index] || {};
      const id = `grammar:${level.toLowerCase()}:${basename}:${String(index + 1).padStart(3, '0')}`;
      if (itemId && id !== itemId) continue;
      if (wanted.size > 0 && !wanted.has(id)) continue;
      items.push({
        item_id: id,
        label: String(raw.structure || raw.title || ''),
        structure: String(raw.structure || raw.title || ''),
        source_path: rel,
        directiveE: raw.directiveE,
      });
    }
  }
  return items;
}

function patternReferences({ label, structure, crossLinks }) {
  const refs = new Set();
  for (const value of [label, structure]) {
    for (const ref of literalRefs(value)) refs.add(ref);
  }
  for (const link of crossLinks || []) {
    const text = crossLinkText(link);
    for (const ref of literalRefs(text)) refs.add(ref);
  }
  return [...refs].filter((ref) => normalized(ref).length > 0);
}

function literalRefs(value) {
  const text = String(value || '');
  const refs = [];
  const compact = text
    .replace(/\([^)]*\)/g, '')
    .replace(/[A-Z]\d*/g, '')
    .replace(/[普通辞書形名詞動詞形容詞疑問詞]/g, '')
    .replace(/[+\s/／・]+/g, '');
  if (/[\u3040-\u30ff\u3400-\u9fff]/.test(compact)) refs.push(compact);
  for (const match of text.match(/[\u3040-\u30ff\u3400-\u9fffー々〆〤]+/g) || []) {
    const cleaned = match.replace(/[普通辞書形名詞動詞形容詞疑問詞]/g, '');
    if (cleaned) refs.push(cleaned);
  }
  return [...new Set(refs)].filter((ref) => !['する', 'なる'].includes(ref));
}

function containsAnyNormalized(text, refs) {
  const haystack = normalized(text);
  return refs.some((ref) => haystack.includes(normalized(ref)));
}

function looksSubstitutable({ humanMoment, patternRefs, candidatePatterns }) {
  if (!humanMoment.trim()) return true;
  if (!containsAnyNormalized(humanMoment, patternRefs)) return true;
  const candidates = candidatePatterns.length > 0
    ? candidatePatterns
    : ['〜ことになる', 'N1 は N2 です', 'Vてください'];
  const replaced = candidates.map((candidate) =>
    replacePatternRefs(humanMoment, patternRefs, candidate),
  );
  const stillGeneric = replaced.filter((text) => !CONTRAST_RE.test(text) && !/Dr\.?\s*Linh/.test(text));
  return stillGeneric.length >= 2;
}

function replacePatternRefs(text, refs, replacement) {
  let next = String(text || '');
  for (const ref of refs) {
    if (!ref) continue;
    next = next.split(ref).join(replacement);
  }
  return next;
}

function crossLinkText(link) {
  if (typeof link === 'string') return link;
  return [link?.pattern, link?.contrast, link?.note, link?.label].filter(Boolean).join(' ');
}

function readWantedRankIds(rankJsonPath) {
  if (!rankJsonPath) return new Set();
  const rank = readJson(rankJsonPath);
  return new Set((rank.items || []).filter((item) => item.item_type === 'grammar').map((item) => item.item_id));
}

function walk(root) {
  if (!fs.existsSync(root)) return [];
  const files = [];
  for (const entry of fs.readdirSync(root, { withFileTypes: true })) {
    const full = path.join(root, entry.name);
    if (entry.isDirectory()) files.push(...walk(full));
    if (entry.isFile()) files.push(full);
  }
  return files;
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function normalizeLevel(value) {
  const raw = String(value || '').trim().toUpperCase();
  if (/^N[1-5]$/.test(raw)) return raw;
  if (/^[1-5]$/.test(raw)) return `N${raw}`;
  return 'N5';
}

function levelFromPath(file) {
  const match = toPosix(file).match(/\/n([1-5])\//i);
  return match ? `N${match[1]}` : '';
}

function normalized(value) {
  return String(value || '')
    .normalize('NFKC')
    .toLowerCase()
    .replace(/\s+/g, '')
    .replace(/[+`"'“”‘’()（）]/g, '');
}

function toPosix(value) {
  return String(value || '').replace(/\\/g, '/');
}

function parseArgs(argv) {
  const args = {};
  for (let i = 2; i < argv.length; i += 1) {
    const key = argv[i];
    const next = argv[i + 1];
    if (key === '--content-root') args.contentRoot = next, i += 1;
    else if (key === '--rank-json') args.rankJsonPath = next, i += 1;
    else if (key === '--item-id') args.itemId = next, i += 1;
    else if (key === '--json') args.json = true;
  }
  return args;
}

if (require.main === module) {
  const args = parseArgs(process.argv);
  const items = readGrammarDirectiveEItems(args);
  const candidatePatterns = items.map((item) => item.structure).filter(Boolean).slice(0, 25);
  const report = validateDirectiveEItems(items, { candidatePatterns });
  if (args.json) {
    process.stdout.write(`${JSON.stringify(report, null, 2)}\n`);
  } else {
    process.stdout.write(
      `Directive E quality: ${report.counts.passedItems}/${report.counts.totalItems} passed\n`,
    );
    for (const failure of report.failures.slice(0, 80)) {
      process.stdout.write(`- ${failure}\n`);
    }
    if (report.failures.length > 80) {
      process.stdout.write(`... ${report.failures.length - 80} more failures\n`);
    }
  }
  if (!report.passed) process.exitCode = 1;
}

module.exports = {
  BANNED_HUMAN_MOMENT_PHRASES,
  validateDirectiveEItem,
  validateDirectiveEItems,
  readGrammarDirectiveEItems,
};
