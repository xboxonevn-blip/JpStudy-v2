const assert = require('node:assert/strict');
const test = require('node:test');

const {
  buildSeedPayload,
  matchLinkedExamples,
} = require('../../../tool/research/build_tatoeba_example_seed');

test('matchLinkedExamples keeps bilingual rows that contain vocab terms', () => {
  const rows = matchLinkedExamples({
    jpnSentences: new Map([
      [1, '私は学生です。'],
      [2, '明日は雨です。'],
    ]),
    vieSentences: new Map([
      [10, 'Tôi là học sinh.'],
      [20, 'Ngày mai trời mưa.'],
    ]),
    links: [
      [1, 10],
      [2, 20],
    ],
    entries: [
      {
        vocabId: 'n5_l01_v001',
        term: '私',
        reading: 'わたし',
      },
      {
        vocabId: 'n5_l01_v023',
        term: '学生',
        reading: 'がくせい',
      },
    ],
  });

  assert.deepEqual(rows.map((row) => row.term), ['学生', '私']);
  assert.equal(rows[0].source_detail, 'Tatoeba sentence 1; translation 10');
  assert.equal(rows[0].license, 'CC-BY 2.0');
});

test('buildSeedPayload keeps curated beginner row ahead of generic matches', () => {
  const payload = buildSeedPayload([
    {
      vocabId: 'n5_l01_v001',
      term: '私',
      reading: 'わたし',
      ja: '私は山にいました。',
      vi: 'Tôi từ trên núi xuống.',
      sentenceId: 4715,
      translationId: 5675,
      source_detail: 'Tatoeba sentence 4715; translation 5675',
      license: 'CC-BY 2.0',
    },
  ]);

  assert.equal(payload.rows[0].ja, '私の番？');
  assert.equal(payload.rows[0].priority, 100);
});

test('matchLinkedExamples does not match single kana inside unrelated words', () => {
  const rows = matchLinkedExamples({
    jpnSentences: new Map([
      [1, 'あなたの勉強を邪魔しないようにします。'],
      [2, 'あ！蝶々がいる！'],
    ]),
    vieSentences: new Map([
      [10, 'Tôi sẽ cố không quấy rầy bạn học hành.'],
      [20, 'Ô kìa, con bươm bướm!'],
    ]),
    links: [
      [1, 10],
      [2, 20],
    ],
    entries: [
      {
        vocabId: 'haj_n4_ch04_v005',
        term: 'あ',
        reading: 'あ',
      },
    ],
  });

  assert.deepEqual(rows.map((row) => row.ja), ['あ！蝶々がいる！']);
});
