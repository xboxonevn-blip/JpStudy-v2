const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const {
  buildFrequencyRank,
  renderTopFrequencyMarkdown,
} = require('../../../tool/research/rank_item_frequency');

test('buildFrequencyRank prioritizes early N5/N4 core items across sources', () => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'jpstudy-rank-'));
  writeJson(path.join(root, 'grammar', 'n5', 'grammar_n5_1.json'), [
    grammar('N1 は N2 です', 'N5', 1),
  ]);
  writeJson(path.join(root, 'grammar', 'n3', 'grammar_n3_25.json'), [
    grammar('〜わけではない', 'N3', 25),
  ]);
  writeJson(path.join(root, 'vocab', 'n5', 'hajimete', 'hajimete_ch01.json'), {
    series: 'hajimete',
    level: 'N5',
    chapterId: 1,
    entries: [vocab('haj_n5_ch01_v001', '嫌い', 'きらい', 'N5', 1)],
  });
  writeJson(path.join(root, 'kanji', 'n4', 'lesson_01.json'), {
    level: 'N4',
    lessonId: 1,
    entries: [kanji('n4_l01_k001', '会', 'N4')],
  });

  const rank = buildFrequencyRank({
    contentRoot: root,
    generatedAt: '2026-05-21T00:00:00+07:00',
    limit: 3,
  });

  assert.equal(rank.items.length, 3);
  assert.deepEqual(
    rank.items.map((item) => item.item_id),
    [
      'grammar:n5:grammar_n5_1:001',
      'vocab:n5:haj_n5_ch01_v001',
      'kanji:n4:n4_l01_k001',
    ],
  );
  assert.equal(rank.items[0].tier, 'tier1');
  assert.equal(rank.items[0].score_breakdown.level, 1000);
});

test('renderTopFrequencyMarkdown emits reproducible Phase G audit table', () => {
  const markdown = renderTopFrequencyMarkdown({
    generatedAt: '2026-05-21T00:00:00+07:00',
    selectionPolicy: 'test policy',
    items: [
      {
        rank: 1,
        item_id: 'grammar:n5:grammar_n5_1:001',
        item_type: 'grammar',
        level: 'N5',
        label: 'N1 は N2 です',
        score: 1812,
        source_path: 'grammar/n5/grammar_n5_1.json',
        rationale: ['N5 core', 'early lesson'],
      },
    ],
  });

  assert.match(markdown, /# Top-200 Frequency Rank/);
  assert.match(markdown, /grammar:n5:grammar_n5_1:001/);
  assert.match(markdown, /test policy/);
});

test('buildFrequencyRank can reserve room for Joyo kanji scope', () => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'jpstudy-rank-quota-'));
  writeJson(path.join(root, 'grammar', 'n5', 'grammar_n5_1.json'), [
    grammar('N1 は N2 です', 'N5', 1),
    grammar('N も', 'N5', 1),
  ]);
  writeJson(path.join(root, 'vocab', 'n5', 'hajimete', 'hajimete_ch01.json'), {
    series: 'hajimete',
    level: 'N5',
    chapterId: 1,
    entries: [
      vocab('haj_n5_ch01_v001', '嫌い', 'きらい', 'N5', 1),
      vocab('haj_n5_ch01_v002', '開ける', 'あける', 'N5', 2),
    ],
  });
  writeJson(path.join(root, 'kanji', 'n5', 'lesson_01.json'), {
    level: 'N5',
    lessonId: 1,
    entries: [
      kanji('n5_l01_k001', '一', 'N5'),
      kanji('n5_l01_k002', '二', 'N5'),
    ],
  });

  const rank = buildFrequencyRank({
    contentRoot: root,
    generatedAt: '2026-05-21T00:00:00+07:00',
    limit: 4,
    minTypeCounts: { kanji: 1 },
  });

  assert.equal(rank.items.some((item) => item.item_type === 'kanji'), true);
  assert.equal(rank.items.length, 4);
});

function grammar(structure, level, lessonId) {
  return {
    lessonId,
    title: structure,
    structure,
    explanation: `${structure} explanation`,
    level,
  };
}

function vocab(vocabId, term, reading, level, order) {
  return {
    entryId: vocabId.replace('_v', '_s'),
    level,
    order,
    lemma: { vocabId, term, reading },
    sense: { meaningVi: 'nghĩa' },
  };
}

function kanji(kanjiId, character, level) {
  return {
    kanjiId,
    level,
    character,
    labels: { hanViet: 'Hội', meaningVi: 'gặp' },
  };
}

function writeJson(file, data) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, `${JSON.stringify(data, null, 2)}\n`);
}
