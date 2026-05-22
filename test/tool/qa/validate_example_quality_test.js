const assert = require('node:assert/strict');
const test = require('node:test');

const {
  validateExample,
  validateCorpus,
} = require('../../../tool/qa/validate_example_quality');

const watashiEntry = {
  entryId: 'n5_l01_s001',
  lemma: { vocabId: 'n5_l01_v001', term: '私', reading: 'わたし' },
  sense: { meaningVi: 'tôi', meaningEn: 'I' },
};

test('rejects generated template filler in Japanese and Vietnamese', () => {
  const result = validateExample(
    {
      example_id: 'ex-n5_l01_v001-001',
      ja: '授業で「私」を使う文を一つ作りました。',
      vi: 'Trong giờ học, tôi dùng 「私」 với nghĩa "tôi" trong một câu ngắn.',
      source: 'original-jpstudy',
    },
    { entry: watashiEntry },
  );

  assert.equal(result.ok, false);
  assert.match(result.errors.join('\n'), /banned/i);
});

test('accepts real contextual bilingual examples with source license', () => {
  const result = validateExample(
    {
      example_id: 'tat-8755524-vie-8942182',
      ja: '私の番？',
      vi: 'Đến lượt tôi chưa?',
      audio_url: '',
      source: 'tatoeba-cc-by-2.0',
      source_detail: 'Tatoeba sentence 8755524; translation 8942182',
      license: 'CC-BY 2.0',
    },
    { entry: watashiEntry },
  );

  assert.equal(result.ok, true, result.errors.join('\n'));
});

test('validateCorpus reports exact failing vocab ids', () => {
  const result = validateCorpus(
    {
      items: {
        n5_l01_v001: [
          {
            example_id: 'ex-n5_l01_v001-001',
            ja: '授業で「私」を使う文を一つ作りました。',
            vi: 'Trong giờ học, tôi dùng 「私」 với nghĩa "tôi" trong một câu ngắn.',
            source: 'original-jpstudy',
          },
        ],
      },
    },
    { entriesByVocabId: new Map([['n5_l01_v001', watashiEntry]]) },
  );

  assert.equal(result.ok, false);
  assert.deepEqual(result.failures.map((failure) => failure.vocabId), [
    'n5_l01_v001',
  ]);
});
