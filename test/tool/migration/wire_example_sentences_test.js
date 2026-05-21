const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const {
  buildExampleCorpus,
  wireExamplesIntoVocabPayload,
} = require('../../../tool/migration/wire_example_sentences');

test('buildExampleCorpus creates one original example per vocab id', () => {
  const corpus = buildExampleCorpus([
    {
      filePath: 'assets/data/content/vocab/n5/minna/lesson_01.json',
      payload: {
        series: 'minna',
        level: 'N5',
        entries: [
          {
            entryId: 'n5_l01_s001',
            lemma: { vocabId: 'n5_l01_v001', term: '私', reading: 'わたし' },
            sense: { meaningVi: 'tôi', meaningEn: 'I' },
          },
        ],
      },
    },
  ]);

  assert.equal(corpus.schemaVersion, 1);
  assert.equal(corpus.items.n5_l01_v001.length, 1);
  assert.equal(corpus.items.n5_l01_v001[0].source, 'original-jpstudy');
  assert.match(corpus.items.n5_l01_v001[0].ja, /私/);
  assert.match(corpus.items.n5_l01_v001[0].vi, /tôi/);
});

test('wireExamplesIntoVocabPayload populates entries from corpus by vocab id', () => {
  const payload = {
    schemaVersion: 2,
    dataset: 'vocab',
    series: 'minna',
    level: 'N5',
    entries: [
      {
        entryId: 'n5_l01_s001',
        lemma: { vocabId: 'n5_l01_v001', term: '私' },
        sense: { meaningVi: 'tôi' },
      },
    ],
  };
  const result = wireExamplesIntoVocabPayload(payload, {
    items: {
      n5_l01_v001: [
        {
          example_id: 'ex-n5-l01-v001-1',
          ja: '私は学生です。',
          vi: 'Tôi là học sinh.',
          audio_url: '',
          source: 'original-jpstudy',
        },
      ],
    },
  });

  assert.equal(result.changed, true);
  assert.equal(result.missing.length, 0);
  assert.deepEqual(result.payload.entries[0].example_sentences, [
    {
      example_id: 'ex-n5-l01-v001-1',
      ja: '私は学生です。',
      vi: 'Tôi là học sinh.',
      audio_url: '',
      source: 'original-jpstudy',
    },
  ]);
});

test('wireExamplesIntoVocabPayload reports missing corpus rows', () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'jpstudy-examples-'));
  try {
    const payload = {
      entries: [
        {
          entryId: 'missing_entry',
          lemma: { vocabId: 'missing_vocab', term: '未登録' },
          sense: { meaningVi: 'chưa đăng ký' },
        },
      ],
    };
    const result = wireExamplesIntoVocabPayload(payload, { items: {} });
    assert.equal(result.changed, false);
    assert.deepEqual(result.missing, ['missing_vocab']);
  } finally {
    fs.rmSync(tmp, { recursive: true, force: true });
  }
});
