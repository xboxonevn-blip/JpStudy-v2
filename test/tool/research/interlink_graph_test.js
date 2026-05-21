const assert = require('node:assert/strict');
const test = require('node:test');

const {
  buildInterlinkGraph,
  validateInterlinkGraph,
} = require('../../../tool/research/build_interlink_graph');

test('buildInterlinkGraph emits routeable nodes and bidirectional edges', () => {
  const graph = buildInterlinkGraph({
    generatedAt: '2026-05-21T09:30:00+07:00',
    vocabEntries: [
      { vocabId: 'v1', level: 'N5', term: '私', reading: 'わたし' },
      { vocabId: 'v2', level: 'N5', term: '食べる', reading: 'たべる' },
    ],
    kanjiEntries: [
      { kanjiId: 'k1', level: 'N5', character: '私', components: [] },
      { kanjiId: 'k2', level: 'N5', character: '食', components: ['人'] },
      { kanjiId: 'k3', level: 'N5', character: '人', components: [] },
    ],
    grammarPoints: [{ id: 'g1', level: 'N5', title: 'N1 は N2 です' }],
    conjugationEntries: [{ id: 'c1', level: 'N5', term: '食べる', kind: 'verbs' }],
  });

  const report = validateInterlinkGraph(graph, { minEdges: 6 });

  assert.equal(report.passed, true);
  assert.equal(graph.nodeFields.join(','), 'id,type,level,label,route');
  assert.equal(graph.edgeFields.join(','), 'from,to,relIndex,weight,evidenceIndex');
  assert.ok(graph.nodes.some((node) => node[0] === 'vocab:n5:v1'));
  const rels = graph.edges.map((edge) => graph.edgeRelTypes[edge[2]]);
  assert.ok(rels.includes('contains_kanji'));
  assert.ok(rels.includes('contained_in_vocab'));
  assert.ok(rels.includes('has_conjugation'));
  assert.ok(rels.includes('conjugates_vocab'));
});

test('validateInterlinkGraph rejects missing reverse edges', () => {
  const graph = {
    schemaVersion: 1,
    nodeFields: ['id', 'type', 'level', 'label', 'route'],
    edgeFields: ['from', 'to', 'relIndex', 'weight', 'evidenceIndex'],
    edgeRelTypes: ['contains_kanji'],
    edgeEvidenceTypes: ['test'],
    nodes: [
      ['a', 'vocab', 'N5', 'a', '/vocab'],
      ['b', 'kanji', 'N5', 'b', '/kanji'],
    ],
    edges: [[0, 1, 0, 1, 0]],
  };

  const report = validateInterlinkGraph(graph, { minEdges: 1 });

  assert.equal(report.passed, false);
  assert.match(report.failures.join('\n'), /missing reverse edge/);
});
