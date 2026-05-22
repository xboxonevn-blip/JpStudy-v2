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

test('accepts real Tatoeba quoted dialogue that contains the term', () => {
  const result = validateExample(
    {
      example_id: 'tat-5278-vie-5899',
      ja: '「ありがとう」「どういたしまして」',
      vi: '"Cám ơn." "Không có chi."',
      audio_url: '',
      source: 'tatoeba-cc-by-2.0',
      source_detail: 'Tatoeba sentence 5278; translation 5899',
      license: 'CC-BY 2.0',
    },
    {
      entry: {
        entryId: 'n5_l05_s053',
        lemma: { vocabId: 'n5_l05_v053', term: 'どういたしまして', reading: 'どういたしまして' },
        sense: { meaningVi: 'không có chi', meaningEn: "You're welcome" },
        tags: ['phrase'],
      },
    },
  );

  assert.equal(result.ok, true, result.errors.join('\n'));
});

test('rejects authored pronoun-study frame for non-pronoun entries', () => {
  const result = validateExample(
    {
      example_id: 'ex-haj_n1_ch01_v001-001',
      ja: '藻掻くは日本語を勉強しています。',
      vi: 'Vùng vẫy; quằn quại; thiếu kiên nhẫn đang học tiếng Nhật.',
      audio_url: '',
      source: 'jpstudy-authored-contextual',
      source_detail: 'JpStudy-authored pronoun context for 藻掻く',
      license: 'JpStudy authored',
    },
    {
      entry: {
        entryId: 'haj_n1_ch01_001',
        lemma: { vocabId: 'haj_n1_ch01_v001', term: '藻掻く', reading: 'もがく' },
        sense: {
          meaningVi: 'vùng vẫy; quằn quại; thiếu kiên nhẫn',
          meaningEn: 'to struggle;to wriggle;to be impatient',
        },
        tags: ['public-source', 'tanos', 'anki-import'],
      },
    },
  );

  assert.equal(result.ok, false);
  assert.match(result.errors.join('\n'), /pronoun|study frame|substitution/i);
});

test('does not treat words like restroom or thank you as pronouns', () => {
  const result = validateExample(
    {
      example_id: 'ex-haj_n1_ch03_v036-001',
      ja: '御手洗いは日本語を勉強しています。',
      vi: 'Nhà vệ sinh đang học tiếng Nhật.',
      audio_url: '',
      source: 'jpstudy-authored-contextual',
      source_detail: 'JpStudy-authored pronoun context for 御手洗い',
      license: 'JpStudy authored',
    },
    {
      entry: {
        entryId: 'haj_n1_ch03_036',
        lemma: { vocabId: 'haj_n1_ch03_v036', term: '御手洗い', reading: 'おてあらい' },
        sense: {
          meaningVi: 'nhà vệ sinh; phòng tắm (Mỹ)',
          meaningEn: 'toilet;restroom;lavatory;bathroom (US)',
        },
      },
    },
  );

  assert.equal(result.ok, false);
  assert.match(result.errors.join('\n'), /non-pronoun|pronoun/i);
});

test('rejects broad authored fallback frames that survive word swaps', () => {
  const entry = {
    entryId: 'haj_n1_ch01_006',
    lemma: { vocabId: 'haj_n1_ch01_v006', term: '結成', reading: 'けっせい' },
    sense: { meaningVi: 'sự hình thành', meaningEn: 'formation' },
  };
  const failures = [
    {
      ja: 'ニュースで結成について読みました。',
      vi: 'Tôi đọc tin tức về sự hình thành.',
      source_detail: 'JpStudy-authored noun/context sentence for 結成',
    },
    {
      ja: '資料には結成の説明が載っています。',
      vi: 'Trong tài liệu có phần giải thích về sự hình thành.',
      source_detail: 'JpStudy-authored noun/context sentence for 結成',
    },
    {
      ja: '結成の入口で友だちに会いました。',
      vi: 'Tôi đã gặp bạn ở lối vào sự hình thành.',
      source_detail: 'JpStudy-authored place context for 結成',
    },
    {
      ja: '彼は最後まで結成姿勢を見せました。',
      vi: 'Anh ấy cho thấy thái độ sự hình thành đến cùng.',
      source_detail: 'JpStudy-authored dictionary-verb context for 結成',
    },
  ];

  const results = failures.map((example, index) => validateExample(
    {
      example_id: `ex-haj_n1_ch01_v006-00${index + 1}`,
      audio_url: '',
      source: 'jpstudy-authored-contextual',
      license: 'JpStudy authored',
      ...example,
    },
    { entry },
  ));

  assert.equal(results.every((result) => !result.ok), true);
  assert.match(results.flatMap((result) => result.errors).join('\n'), /template|fallback/i);
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
