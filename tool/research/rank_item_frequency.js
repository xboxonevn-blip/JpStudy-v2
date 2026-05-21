const fs = require('node:fs');
const path = require('node:path');

const LEVEL_SCORE = { N5: 1000, N4: 840, N3: 640, N2: 420, N1: 260 };
const TYPE_SCORE = { grammar: 360, vocab: 260, kanji: 220 };
const TYPE_ORDER = { grammar: 0, vocab: 1, kanji: 2 };
const SELECTION_POLICY =
  'Phase G Option C rank: local usage facts are combined from JLPT level, textbook position, source track, lesson/order, and content type. Early N5/N4 Minna/Hajimete/kanji items and N3 grammar get priority because they carry the highest learner contact.';

function buildFrequencyRank({
  contentRoot = path.join(process.cwd(), 'assets', 'data', 'content'),
  generatedAt = new Date().toISOString(),
  limit = 200,
  usageSignals = {},
  minTypeCounts = defaultMinTypeCounts(limit),
} = {}) {
  const candidates = readCandidateItems(contentRoot);
  const items = rankCandidates(candidates, { limit, usageSignals, minTypeCounts });
  return {
    schemaVersion: 1,
    generatedAt,
    selectionPolicy: SELECTION_POLICY,
    items,
  };
}

function readCandidateItems(contentRoot) {
  return [
    ...readGrammarCandidates(contentRoot),
    ...readVocabCandidates(contentRoot),
    ...readKanjiCandidates(contentRoot),
  ];
}

function rankCandidates(candidates, { limit = 200, usageSignals = {}, minTypeCounts = {} } = {}) {
  const ranked = candidates
    .map((candidate) => scoreCandidate(candidate, usageSignals))
    .sort(compareRankedItems);
  return selectRankedItems(ranked, { limit, minTypeCounts })
    .map((item, index) => ({
      rank: index + 1,
      tier: 'tier1',
      ...item,
    }));
}

function selectRankedItems(ranked, { limit, minTypeCounts }) {
  const selected = [];
  const selectedIds = new Set();
  for (const [type, minCount] of Object.entries(minTypeCounts || {})) {
    const wanted = Math.max(0, Number(minCount || 0));
    if (wanted === 0) continue;
    for (const item of ranked.filter((candidate) => candidate.item_type === type)) {
      if (selected.filter((candidate) => candidate.item_type === type).length >= wanted) break;
      if (selectedIds.has(item.item_id)) continue;
      selected.push(item);
      selectedIds.add(item.item_id);
    }
  }
  for (const item of ranked) {
    if (selected.length >= limit) break;
    if (selectedIds.has(item.item_id)) continue;
    selected.push(item);
    selectedIds.add(item.item_id);
  }
  return selected.sort(compareRankedItems).slice(0, limit);
}

function defaultMinTypeCounts(limit) {
  if (limit < 200) return {};
  return { grammar: 80, vocab: 80, kanji: 40 };
}

function scoreCandidate(candidate, usageSignals) {
  const levelScore = LEVEL_SCORE[normalizeLevel(candidate.level)] || 0;
  const typeScore = TYPE_SCORE[candidate.item_type] || 0;
  const source = sourceTrackScore(candidate);
  const lesson = lessonPositionScore(candidate.lesson_id);
  const order = orderPositionScore(candidate.order);
  const usage = Number(usageSignals[candidate.item_id] || 0);
  const score = levelScore + typeScore + source.score + lesson + order + usage;
  return {
    ...candidate,
    score,
    score_breakdown: {
      level: levelScore,
      type: typeScore,
      source: source.score,
      lesson,
      order,
      usage,
    },
    rationale: [
      `${normalizeLevel(candidate.level)} priority`,
      source.label,
      `lesson ${candidate.lesson_id || '?'}`,
      `order ${candidate.order || '?'}`,
    ],
  };
}

function readGrammarCandidates(contentRoot) {
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
      const item = data[index] || {};
      const lessonId = Number(item.lessonId || lessonFromName(basename) || 999);
      items.push({
        item_id: `grammar:${level.toLowerCase()}:${basename}:${String(index + 1).padStart(3, '0')}`,
        item_type: 'grammar',
        level,
        label: String(item.structure || item.title || item.titleEn || `grammar ${index + 1}`),
        meaning: firstText([item.explanation, item.explanationEn]),
        lesson_id: lessonId,
        order: index + 1,
        series: grammarSeries(level, lessonId),
        source_path: rel,
        directive_e_path: `${rel}#${index}`,
      });
    }
  }
  return items;
}

function readVocabCandidates(contentRoot) {
  const root = path.join(contentRoot, 'vocab');
  const items = [];
  for (const file of walk(root)) {
    if (!file.endsWith('.json') || path.basename(file) === 'index.json') continue;
    const data = readJson(file);
    if (!Array.isArray(data.entries)) continue;
    const rel = toPosix(path.relative(contentRoot, file));
    const level = normalizeLevel(data.level || levelFromPath(file));
    const series = data.series || seriesFromPath(file, root);
    for (let index = 0; index < data.entries.length; index += 1) {
      const entry = data.entries[index] || {};
      const vocabId = entry.lemma?.vocabId || entry.entryId || `${path.basename(file, '.json')}_${index + 1}`;
      const lessonId = Number(entry.lessonId || data.lessonId || data.chapterId || entry.chapterId || 999);
      items.push({
        item_id: `vocab:${level.toLowerCase()}:${vocabId}`,
        item_type: 'vocab',
        level,
        label: String(entry.lemma?.term || entry.term || vocabId),
        reading: String(entry.lemma?.reading || ''),
        meaning: firstText([entry.sense?.meaningVi, entry.sense?.meaningEn]),
        lesson_id: lessonId,
        order: Number(entry.order || index + 1),
        series,
        source_path: rel,
      });
    }
  }
  return items;
}

function readKanjiCandidates(contentRoot) {
  const root = path.join(contentRoot, 'kanji');
  const items = [];
  for (const file of walk(root)) {
    if (!file.endsWith('.json')) continue;
    const data = readJson(file);
    if (!Array.isArray(data.entries)) continue;
    const rel = toPosix(path.relative(contentRoot, file));
    const level = normalizeLevel(data.level || levelFromPath(file));
    for (let index = 0; index < data.entries.length; index += 1) {
      const entry = data.entries[index] || {};
      const kanjiId = entry.kanjiId || entry.character || `${path.basename(file, '.json')}_${index + 1}`;
      const lessonId = Number(entry.lessonId || data.lessonId || lessonFromName(path.basename(file, '.json')) || 999);
      items.push({
        item_id: `kanji:${level.toLowerCase()}:${kanjiId}`,
        item_type: 'kanji',
        level,
        label: String(entry.character || kanjiId),
        reading: [
          ...(entry.readings?.onyomi || []),
          ...(entry.readings?.kunyomi || []),
        ].join(', '),
        meaning: firstText([entry.labels?.meaningViDisplay, entry.labels?.meaningVi, entry.labels?.hanViet]),
        lesson_id: lessonId,
        order: index + 1,
        series: 'joyo-kanji',
        source_path: rel,
      });
    }
  }
  return items;
}

function sourceTrackScore(candidate) {
  const level = normalizeLevel(candidate.level);
  const series = String(candidate.series || '').toLowerCase();
  if (candidate.item_type === 'grammar' && (level === 'N5' || level === 'N4')) {
    return { score: 360, label: 'Minna core grammar' };
  }
  if (candidate.item_type === 'grammar' && level === 'N3') {
    return { score: 300, label: 'Shin Kanzen N3 grammar priority' };
  }
  if (candidate.item_type === 'vocab' && series.includes('hajimete') && (level === 'N5' || level === 'N4')) {
    return { score: 320, label: 'Hajimete N5/N4 high-contact vocab' };
  }
  if (candidate.item_type === 'vocab' && series.includes('minna')) {
    return { score: 280, label: 'Minna lesson vocab' };
  }
  if (candidate.item_type === 'vocab' && series.includes('shinkanzen') && level === 'N3') {
    return { score: 240, label: 'Shin Kanzen N3 vocab' };
  }
  if (candidate.item_type === 'kanji' && (level === 'N5' || level === 'N4')) {
    return { score: 300, label: 'Joyo N5/N4 kanji' };
  }
  return { score: 120, label: `${candidate.series || candidate.item_type} local content` };
}

function lessonPositionScore(value) {
  const lesson = Number(value || 999);
  if (!Number.isFinite(lesson)) return 0;
  return Math.max(0, 320 - Math.max(0, lesson - 1) * 10);
}

function orderPositionScore(value) {
  const order = Number(value || 999);
  if (!Number.isFinite(order)) return 0;
  return Math.max(0, 160 - Math.max(0, order - 1) * 2);
}

function compareRankedItems(left, right) {
  return (
    right.score - left.score ||
    (LEVEL_SCORE[right.level] || 0) - (LEVEL_SCORE[left.level] || 0) ||
    (TYPE_ORDER[left.item_type] || 9) - (TYPE_ORDER[right.item_type] || 9) ||
    left.source_path.localeCompare(right.source_path) ||
    left.label.localeCompare(right.label)
  );
}

function renderTopFrequencyMarkdown(rank) {
  const rows = (rank.items || [])
    .map((item) =>
      [
        item.rank,
        item.tier,
        item.item_type,
        item.level,
        code(item.item_id),
        escapeCell(item.label),
        item.score,
        code(item.source_path),
        escapeCell((item.rationale || []).join('; ')),
      ].join(' | '),
    )
    .join('\n');
  return [
    '# Top-200 Frequency Rank (Phase G)',
    '',
    `Generated: ${rank.generatedAt}`,
    '',
    `Policy: ${rank.selectionPolicy}`,
    '',
    '| Rank | Tier | Type | Level | Item ID | Label | Score | Source | Rationale |',
    '| ---: | --- | --- | --- | --- | --- | ---: | --- | --- |',
    rows,
    '',
  ].join('\n');
}

function writeRankOutputs({ rank, docPath, jsonPath }) {
  if (docPath) {
    fs.mkdirSync(path.dirname(docPath), { recursive: true });
    fs.writeFileSync(docPath, renderTopFrequencyMarkdown(rank));
  }
  if (jsonPath) {
    fs.mkdirSync(path.dirname(jsonPath), { recursive: true });
    fs.writeFileSync(jsonPath, `${JSON.stringify(rank, null, 2)}\n`);
  }
}

function grammarSeries(level, lessonId) {
  if (level === 'N5') return 'minna-i';
  if (level === 'N4') return 'minna-ii';
  if (level === 'N3') return 'shin-kanzen-grammar';
  return lessonId ? 'jlpt-grammar' : 'grammar';
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

function seriesFromPath(file, root) {
  const rel = path.relative(root, file).split(path.sep);
  return rel.length > 1 ? rel[1] : '';
}

function lessonFromName(value) {
  const match = String(value || '').match(/(?:lesson_|grammar_n\d_|l)(\d+)/i);
  return match ? Number(match[1]) : 0;
}

function firstText(values) {
  return String(values.find((value) => String(value || '').trim()) || '');
}

function toPosix(value) {
  return String(value || '').replace(/\\/g, '/');
}

function escapeCell(value) {
  return String(value || '').replace(/\|/g, '\\|').replace(/\r?\n/g, '<br>');
}

function code(value) {
  return `\`${escapeCell(value)}\``;
}

function parseArgs(argv) {
  const args = {};
  for (let i = 2; i < argv.length; i += 1) {
    const key = argv[i];
    const next = argv[i + 1];
    if (key === '--content-root') args.contentRoot = next, i += 1;
    else if (key === '--limit') args.limit = Number(next), i += 1;
    else if (key === '--write-doc') args.docPath = next, i += 1;
    else if (key === '--write-json') args.jsonPath = next, i += 1;
  }
  return args;
}

if (require.main === module) {
  const args = parseArgs(process.argv);
  const rank = buildFrequencyRank({
    contentRoot: args.contentRoot || path.join(process.cwd(), 'assets', 'data', 'content'),
    limit: args.limit || 200,
  });
  writeRankOutputs({ rank, docPath: args.docPath, jsonPath: args.jsonPath });
  if (!args.docPath && !args.jsonPath) {
    process.stdout.write(`${JSON.stringify(rank, null, 2)}\n`);
  } else {
    process.stdout.write(`ranked ${rank.items.length} items\n`);
  }
}

module.exports = {
  buildFrequencyRank,
  readCandidateItems,
  rankCandidates,
  renderTopFrequencyMarkdown,
  writeRankOutputs,
};
