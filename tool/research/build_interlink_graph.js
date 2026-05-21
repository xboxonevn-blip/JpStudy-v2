const fs = require('node:fs');
const path = require('node:path');

const {
  readConjugationEntries,
  readGrammarPoints,
  readKanjiEntries,
  readVocabEntries,
} = require('./generate_exercises');

const KANJI_RE = /[\u4e00-\u9fff]/g;
const REVERSE_REL = {
  contains_kanji: 'contained_in_vocab',
  contained_in_vocab: 'contains_kanji',
  has_component: 'component_of',
  component_of: 'has_component',
  has_conjugation: 'conjugates_vocab',
  conjugates_vocab: 'has_conjugation',
  reading_uses_kanji: 'kanji_used_in_reading',
  kanji_used_in_reading: 'reading_uses_kanji',
};

function buildInterlinkGraph({
  generatedAt = new Date().toISOString(),
  vocabEntries = [],
  kanjiEntries = [],
  grammarPoints = [],
  conjugationEntries = [],
  readingPassages = [],
} = {}) {
  const nodes = [];
  const nodeIndex = new Map();
  const edges = [];
  const edgeKeys = new Set();
  const relIndex = new Map();
  const relTypes = [];
  const evidenceIndex = new Map();
  const evidenceTypes = [];

  function addNode(id, type, level, label, route) {
    if (nodeIndex.has(id)) return nodeIndex.get(id);
    const index = nodes.length;
    nodes.push([id, type, normalizeLevel(level), label || id, route || routeFor(type, label, id)]);
    nodeIndex.set(id, index);
    return index;
  }

  function addEdge(fromId, toId, rel, weight, evidence) {
    const from = nodeIndex.get(fromId);
    const to = nodeIndex.get(toId);
    if (from == null || to == null || from === to) return;
    const key = `${from}|${to}|${rel}`;
    if (edgeKeys.has(key)) return;
    edgeKeys.add(key);
    edges.push([
      from,
      to,
      indexValue(rel, relIndex, relTypes),
      weight,
      indexValue(evidence, evidenceIndex, evidenceTypes),
    ]);
  }

  const kanjiByChar = new Map();
  for (const entry of kanjiEntries) {
    if (!entry.character) continue;
    const id = kanjiNodeId(entry);
    kanjiByChar.set(entry.character, { ...entry, nodeId: id });
    addNode(id, 'kanji', entry.level, entry.character, `/kanji/${encodeURIComponent(entry.character)}/graph`);
  }

  const vocabByTerm = new Map();
  for (const entry of vocabEntries) {
    const id = vocabNodeId(entry);
    vocabByTerm.set(entry.term, { ...entry, nodeId: id });
    addNode(id, 'vocab', entry.level, entry.term, '/vocab');
  }

  for (const entry of grammarPoints) {
    addNode(grammarNodeId(entry), 'grammar', entry.level, entry.title, '/grammar');
  }

  for (const entry of conjugationEntries) {
    addNode(conjugationNodeId(entry), 'conjugation', entry.level, entry.term, '/grammar/conjugation');
  }

  for (const passage of readingPassages) {
    addNode(
      readingNodeId(passage),
      'reading',
      passage.level,
      passage.passage_id,
      '/jlpt/reading',
    );
  }

  for (const entry of vocabEntries) {
    const vocabId = vocabNodeId(entry);
    for (const char of extractKanji(entry.term)) {
      const kanji = kanjiByChar.get(char);
      if (!kanji) continue;
      addEdge(vocabId, kanji.nodeId, 'contains_kanji', 1, 'vocab-term-scan');
      addEdge(kanji.nodeId, vocabId, 'contained_in_vocab', 1, 'vocab-term-scan');
    }
  }

  for (const entry of kanjiEntries) {
    const from = kanjiNodeId(entry);
    for (const char of new Set(entry.components || [])) {
      const target = kanjiByChar.get(char);
      if (!target) continue;
      addEdge(from, target.nodeId, 'has_component', 0.7, 'kanji-decomposition');
      addEdge(target.nodeId, from, 'component_of', 0.7, 'kanji-decomposition');
    }
  }

  for (const entry of conjugationEntries) {
    const vocab = vocabByTerm.get(entry.term);
    if (!vocab) continue;
    const conjId = conjugationNodeId(entry);
    addEdge(vocab.nodeId, conjId, 'has_conjugation', 0.9, 'conjugation-lemma');
    addEdge(conjId, vocab.nodeId, 'conjugates_vocab', 0.9, 'conjugation-lemma');
  }

  for (const passage of readingPassages) {
    const readingId = readingNodeId(passage);
    for (const char of passage.kanjis_used || extractKanji(passage.ja_text || '')) {
      const kanji = kanjiByChar.get(char);
      if (!kanji) continue;
      addEdge(readingId, kanji.nodeId, 'reading_uses_kanji', 0.6, 'reading-tags');
      addEdge(kanji.nodeId, readingId, 'kanji_used_in_reading', 0.6, 'reading-tags');
    }
  }

  return {
    schemaVersion: 1,
    generatedAt,
    nodeFields: ['id', 'type', 'level', 'label', 'route'],
    edgeFields: ['from', 'to', 'relIndex', 'weight', 'evidenceIndex'],
    edgeRelTypes: relTypes,
    edgeEvidenceTypes: evidenceTypes,
    nodes,
    edges,
  };
}

function validateInterlinkGraph(graph, { minEdges = 50000 } = {}) {
  const failures = [];
  const nodes = graph?.nodes || [];
  const edges = graph?.edges || [];
  if (nodes.length === 0) failures.push('interlink graph has no nodes');
  if (edges.length < minEdges) {
    failures.push(`interlink graph edge count ${edges.length} below ${minEdges}`);
  }
  for (const [index, node] of nodes.entries()) {
    if (!node[0] || !node[1] || !node[4]) failures.push(`invalid node ${index}`);
    if (!String(node[4]).startsWith('/')) failures.push(`node route is not app-local: ${node[0]}`);
  }
  const relTypes = graph?.edgeRelTypes || [];
  const edgeSet = new Set(
    edges.map((edge) => `${edge[0]}|${edge[1]}|${edgeRel(edge, relTypes)}`),
  );
  for (const [index, edge] of edges.entries()) {
    const [from, to] = edge;
    const rel = edgeRel(edge, relTypes);
    if (!nodes[from] || !nodes[to]) failures.push(`edge points to missing node ${index}`);
    const reverseRel = REVERSE_REL[rel];
    if (reverseRel && !edgeSet.has(`${to}|${from}|${reverseRel}`)) {
      failures.push(`missing reverse edge for ${rel}: ${nodes[from]?.[0]} -> ${nodes[to]?.[0]}`);
    }
  }
  return {
    passed: failures.length === 0,
    failures,
    counts: {
      nodes: nodes.length,
      edges: edges.length,
      grammar: nodes.filter((node) => node[1] === 'grammar').length,
      vocab: nodes.filter((node) => node[1] === 'vocab').length,
      kanji: nodes.filter((node) => node[1] === 'kanji').length,
      conjugation: nodes.filter((node) => node[1] === 'conjugation').length,
      reading: nodes.filter((node) => node[1] === 'reading').length,
    },
  };
}

function indexValue(value, index, values) {
  if (index.has(value)) return index.get(value);
  const next = values.length;
  values.push(value);
  index.set(value, next);
  return next;
}

function edgeRel(edge, relTypes) {
  const rel = edge[2];
  return typeof rel === 'number' ? relTypes[rel] : rel;
}

function writeDefaultGraph({
  contentRoot = path.join(process.cwd(), 'assets', 'data', 'content'),
  outputPath = path.join(process.cwd(), 'assets', 'data', 'content', 'interlink_graph', 'interlink_graph.json'),
  generatedAt = new Date().toISOString(),
} = {}) {
  const graph = buildInterlinkGraph({
    generatedAt,
    vocabEntries: readVocabEntries(contentRoot),
    kanjiEntries: readKanjiEntries(contentRoot),
    grammarPoints: readGrammarPoints(contentRoot),
    conjugationEntries: readConjugationEntries(contentRoot),
    readingPassages: readReadingPassages(contentRoot),
  });
  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, `${JSON.stringify(graph)}\n`, 'utf8');
  return { graph, report: validateInterlinkGraph(graph) };
}

function readReadingPassages(contentRoot) {
  const file = path.join(contentRoot, 'reading_passages', 'reading_passages_corpus.json');
  if (!fs.existsSync(file)) return [];
  return readJson(file).passages || [];
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function vocabNodeId(entry) {
  return `vocab:${normalizeLevel(entry.level).toLowerCase()}:${entry.vocabId || slug(entry.term)}`;
}

function kanjiNodeId(entry) {
  return `kanji:${normalizeLevel(entry.level).toLowerCase()}:${entry.kanjiId || entry.character}`;
}

function grammarNodeId(entry) {
  return `grammar:${normalizeLevel(entry.level).toLowerCase()}:${entry.id || slug(entry.title)}`;
}

function conjugationNodeId(entry) {
  return `conjugation:${normalizeLevel(entry.level).toLowerCase()}:${entry.id || slug(entry.term)}`;
}

function readingNodeId(entry) {
  return `reading:${normalizeLevel(entry.level).toLowerCase()}:${entry.passage_id || slug(entry.ja_text)}`;
}

function routeFor(type, label, id) {
  if (type === 'kanji') return `/kanji/${encodeURIComponent(label || id)}/graph`;
  if (type === 'grammar') return '/grammar';
  if (type === 'conjugation') return '/grammar/conjugation';
  if (type === 'reading') return '/jlpt/reading';
  return '/vocab';
}

function extractKanji(value) {
  return Array.from(new Set(String(value || '').match(KANJI_RE) || []));
}

function normalizeLevel(value) {
  return String(value || 'N5').trim().toUpperCase();
}

function slug(value) {
  return String(value || 'item')
    .trim()
    .toLowerCase()
    .replace(/\s+/g, '_')
    .replace(/[^\p{L}\p{N}_:-]/gu, '');
}

if (require.main === module) {
  const { graph, report } = writeDefaultGraph();
  console.log(JSON.stringify({
    ...report.counts,
    passed: report.passed,
    failures: report.failures.slice(0, 5),
    output: 'assets/data/content/interlink_graph/interlink_graph.json',
  }));
  process.exitCode = report.passed ? 0 : 1;
}

module.exports = {
  buildInterlinkGraph,
  validateInterlinkGraph,
  writeDefaultGraph,
};
