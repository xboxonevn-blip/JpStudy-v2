const assert = require('node:assert/strict');
const test = require('node:test');

const {
  buildVocabConsensus,
  formatConsensusMarkdown,
  parseVocabCanonicalMarkdown,
} = require('../../../tool/research/build_vocab_consensus');

test('parseVocabCanonicalMarkdown reads yaml-style vocab entries', () => {
  const entries = parseVocabCanonicalMarkdown(
    `
# Canonical Vocab - minna-1

### 0001. 学校

\`\`\`yaml
term: 学校
reading: がっこう
hanViet: HỌC HIỆU
meaningVi: Trường học
level: N5
source: minna-1
sourceSection: Lesson 3
sourcePage: 1
notes: []
\`\`\`
`,
    'minna-1.md',
  );

  assert.equal(entries.length, 1);
  assert.equal(entries[0].term, '学校');
  assert.equal(entries[0].reading, 'がっこう');
  assert.equal(entries[0].meaningVi, 'Trường học');
  assert.equal(entries[0].sourceFile, 'minna-1.md');
});

test('buildVocabConsensus separates consensus, divergent, and singleton groups', () => {
  const result = buildVocabConsensus([
    entry('学校', 'がっこう', 'Trường học', 'minna-1', 'N5'),
    entry('学校', 'がっこう', 'Trường học', 'kanji-vocab-n5', 'N5'),
    entry('先生', 'せんせい', 'Giáo viên', 'minna-1', 'N5'),
    entry('先生', 'せんせい', 'Thầy cô', 'kanji-vocab-n5', 'N5'),
    entry('猫', 'ねこ', 'Mèo', 'minna-1', 'N5'),
  ]);

  assert.equal(result.consensus.length, 1);
  assert.equal(result.consensus[0].term, '学校');
  assert.deepEqual(result.consensus[0].sources, ['kanji-vocab-n5', 'minna-1']);

  assert.equal(result.divergent.length, 1);
  assert.equal(result.divergent[0].term, '先生');
  assert.equal(result.singleSource.length, 1);
  assert.equal(result.summary.totalGroups, 3);
});

test('formatConsensusMarkdown includes summary and source tables', () => {
  const result = buildVocabConsensus([
    entry('学校', 'がっこう', 'Trường học', 'minna-1', 'N5'),
    entry('学校', 'がっこう', 'Trường học', 'kanji-vocab-n5', 'N5'),
  ], { generatedAt: '2026-05-21T00:00:00.000Z' });
  const markdown = formatConsensusMarkdown(result);

  assert.match(markdown, /# Vocab Cross-source Consensus/);
  assert.match(markdown, /Consensus groups: 1/);
  assert.match(markdown, /学校/);
  assert.doesNotMatch(markdown, /nhaikanji\.com/);
  assert.doesNotMatch(markdown, /thocodehoctiengnhat\.com/);
});

function entry(term, reading, meaningVi, source, level) {
  return {
    term,
    reading,
    meaningVi,
    source,
    level,
    sourceSection: 'Lesson 1',
    sourceFile: `${source}.md`,
  };
}
