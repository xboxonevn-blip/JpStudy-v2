const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const {
  buildExampleCorpus,
  wireExamplesIntoVocabPayload,
} = require('../../../tool/migration/wire_example_sentences');

test('buildExampleCorpus prefers Tatoeba bilingual rows over authored fallback', () => {
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
  ], {
    tatoebaRows: [
      {
        term: '私',
        ja: '私の番？',
        vi: 'Đến lượt tôi chưa?',
        sentenceId: 8755524,
        translationId: 8942182,
      },
    ],
  });

  assert.equal(corpus.schemaVersion, 2);
  assert.equal(corpus.items.n5_l01_v001.length, 1);
  assert.equal(corpus.items.n5_l01_v001[0].source, 'tatoeba-cc-by-2.0');
  assert.equal(corpus.items.n5_l01_v001[0].ja, '私の番？');
  assert.equal(corpus.items.n5_l01_v001[0].license, 'CC-BY 2.0');
});

test('buildExampleCorpus does not wire Tatoeba homophones by reading only', () => {
  const corpus = buildExampleCorpus([
    {
      filePath: 'assets/data/content/vocab/n1/hajimete/hajimete_ch01.json',
      payload: {
        entries: [
          {
            entryId: 'haj_n1_ch01_012',
            lemma: { vocabId: 'haj_n1_ch01_v012', term: '専修', reading: 'せんしゅう' },
            sense: { meaningVi: 'chuyên môn hóa', meaningEn: 'specialization' },
          },
        ],
      },
    },
  ], {
    tatoebaRows: [
      {
        vocabId: 'n5_l04_v010',
        term: '先週',
        reading: 'せんしゅう',
        ja: '彼らは先週富士山に登った。',
        vi: 'Tuần trước họ đã leo núi Phú Sĩ.',
        sentenceId: 96703,
        translationId: 8839414,
      },
    ],
  });

  assert.notEqual(corpus.items.haj_n1_ch01_v012[0].source, 'tatoeba-cc-by-2.0');
  assert.match(corpus.items.haj_n1_ch01_v012[0].ja, /専修/);
});

test('buildExampleCorpus uses owner textbook rows before authored fallback', () => {
  const corpus = buildExampleCorpus([
    {
      filePath: 'assets/data/content/vocab/n5/minna/lesson_01.json',
      payload: {
        entries: [
          {
            entryId: 'n5_l01_s010',
            lemma: { vocabId: 'n5_l01_v010', term: '会社員', reading: 'かいしゃいん' },
            sense: { meaningVi: 'nhân viên công ty', meaningEn: 'company employee' },
          },
        ],
      },
    },
  ], {
    textbookRows: [
      {
        vocabId: 'n5_l01_v010',
        term: '会社員',
        ja: '父は会社員です。',
        vi: 'Bố tôi là nhân viên công ty.',
        source: 'owner-local-textbook-example',
        source_detail: 'Owner local Minna N5 lesson 1 example cache',
        license: 'owner local source',
      },
    ],
  });

  assert.equal(corpus.items.n5_l01_v010[0].source, 'owner-local-textbook-example');
  assert.equal(corpus.items.n5_l01_v010[0].ja, '父は会社員です。');
});

test('buildExampleCorpus keeps Tatoeba ahead of owner textbook rows', () => {
  const corpus = buildExampleCorpus([
    {
      filePath: 'assets/data/content/vocab/n5/minna/lesson_01.json',
      payload: {
        entries: [
          {
            entryId: 'n5_l01_s001',
            lemma: { vocabId: 'n5_l01_v001', term: '私', reading: 'わたし' },
            sense: { meaningVi: 'tôi', meaningEn: 'I' },
          },
        ],
      },
    },
  ], {
    tatoebaRows: [
      {
        vocabId: 'n5_l01_v001',
        term: '私',
        ja: '私の番？',
        vi: 'Đến lượt tôi chưa?',
        sentenceId: 8755524,
        translationId: 8942182,
      },
    ],
    textbookRows: [
      {
        vocabId: 'n5_l01_v001',
        term: '私',
        ja: '私は学生です。',
        vi: 'Tôi là học sinh.',
        source: 'owner-local-textbook-example',
        source_detail: 'Owner local Minna N5 lesson 1 example cache',
        license: 'owner local source',
      },
    ],
  });

  assert.equal(corpus.items.n5_l01_v001[0].source, 'tatoeba-cc-by-2.0');
  assert.equal(corpus.items.n5_l01_v001[0].ja, '私の番？');
});

test('buildExampleCorpus fallback authors contextual examples, not templates', () => {
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

  const row = corpus.items.n5_l01_v001[0];
  assert.equal(row.source, 'jpstudy-authored-contextual');
  assert.equal(row.ja, '私は学生です。');
  assert.equal(row.vi, 'Tôi là học sinh.');
  assert.doesNotMatch(row.ja, /を使う文を|文を一つ作り|を使った文/);
  assert.doesNotMatch(row.vi, /Trong giờ học, tôi dùng|với nghĩa/);
});

test('buildExampleCorpus does not classify every English i as a pronoun', () => {
  const corpus = buildExampleCorpus([
    {
      filePath: 'assets/data/content/vocab/n1/hajimete/hajimete_ch01.json',
      payload: {
        series: 'hajimete',
        level: 'N1',
        entries: [
          {
            entryId: 'haj_n1_ch01_001',
            lemma: { vocabId: 'haj_n1_ch01_v001', term: '藻掻く', reading: 'もがく' },
            sense: {
              meaningVi: 'vùng vẫy; quằn quại; thiếu kiên nhẫn',
              meaningEn: 'to struggle;to wriggle;to be impatient',
            },
            tags: ['public-source', 'tanos', 'anki-import'],
          },
        ],
      },
    },
  ]);

  const row = corpus.items.haj_n1_ch01_v001[0];
  assert.equal(row.source, 'jpstudy-authored-contextual');
  assert.match(row.ja, /藻掻/);
  assert.doesNotMatch(row.ja, /日本語を勉強しています/);
  assert.doesNotMatch(row.source_detail, /pronoun context/);
});

test('buildExampleCorpus authors specific fallback contexts for uncovered N1 items', () => {
  const corpus = buildExampleCorpus([
    {
      filePath: 'assets/data/content/vocab/n1/hajimete/hajimete_ch01.json',
      payload: {
        series: 'hajimete',
        level: 'N1',
        entries: [
          {
            entryId: 'haj_n1_ch01_001',
            lemma: { vocabId: 'haj_n1_ch01_v001', term: '藻掻く', reading: 'もがく' },
            sense: {
              meaningVi: 'vùng vẫy; quằn quại; thiếu kiên nhẫn',
              meaningEn: 'to struggle;to wriggle;to be impatient',
            },
          },
          {
            entryId: 'haj_n1_ch01_002',
            lemma: { vocabId: 'haj_n1_ch01_v002', term: '地元', reading: 'じもと' },
            sense: { meaningVi: 'địa phương', meaningEn: 'local' },
          },
          {
            entryId: 'haj_n1_ch01_006',
            lemma: { vocabId: 'haj_n1_ch01_v006', term: '結成', reading: 'けっせい' },
            sense: { meaningVi: 'sự hình thành', meaningEn: 'formation' },
          },
          {
            entryId: 'haj_n1_ch01_022',
            lemma: { vocabId: 'haj_n1_ch01_v022', term: '外貨', reading: 'がいか' },
            sense: { meaningVi: 'hàng nhập khẩu; tiền nước ngoài', meaningEn: 'imported goods;foreign money' },
          },
        ],
      },
    },
  ]);

  assert.equal(corpus.items.haj_n1_ch01_v001[0].ja, '水の中で必死に藻掻いた。');
  assert.equal(corpus.items.haj_n1_ch01_v002[0].ja, '週末は地元の祭りに参加しました。');
  assert.equal(corpus.items.haj_n1_ch01_v006[0].ja, '新しいチームの結成が発表されました。');
  assert.equal(corpus.items.haj_n1_ch01_v022[0].ja, '空港で外貨を両替しました。');
});

test('buildExampleCorpus does not author residual article placeholder contexts', () => {
  const corpus = buildExampleCorpus([
    {
      filePath: 'assets/data/content/vocab/n1/hajimete/hajimete_ch01.json',
      payload: {
        entries: [
          {
            entryId: 'haj_n1_ch01_010',
            lemma: { vocabId: 'haj_n1_ch01_v010', term: '組み合わせ', reading: 'くみあわせ' },
            sense: { meaningVi: 'sự kết hợp', meaningEn: 'combination' },
          },
        ],
      },
    },
  ]);

  const row = corpus.items.haj_n1_ch01_v010[0];
  assert.match(row.ja, /組み合わせ/);
  assert.doesNotMatch(row.ja, /記事では|具体例/);
  assert.doesNotMatch(row.vi, /như một ví dụ cụ thể/);
  assert.doesNotMatch(row.source_detail, /residual/);
});

test('buildExampleCorpus authors true interjection context for single kana あ', () => {
  const corpus = buildExampleCorpus([
    {
      filePath: 'assets/data/content/vocab/n4/hajimete/hajimete_ch04.json',
      payload: {
        entries: [
          {
            entryId: 'haj_n4_ch04_005',
            lemma: { vocabId: 'haj_n4_ch04_v005', term: 'あ', reading: 'あ' },
            sense: { meaningVi: 'à; ồ', meaningEn: 'ah;oh' },
          },
        ],
      },
    },
  ], {
    tatoebaRows: [
      {
        vocabId: 'haj_n4_ch04_v005',
        term: 'あ',
        reading: 'あ',
        ja: 'あなたの勉強を邪魔しないようにします。',
        vi: 'Tôi sẽ cố không quấy rầy bạn học hành.',
        sentenceId: 4731,
        translationId: 5679,
      },
    ],
  });

  const row = corpus.items.haj_n4_ch04_v005[0];
  assert.equal(row.source, 'jpstudy-authored-contextual');
  assert.equal(row.ja, 'あ、財布を忘れました。');
  assert.doesNotMatch(row.ja, /あなた/);
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
          source: 'jpstudy-authored-contextual',
          source_detail: 'JpStudy-authored Minna N5 lesson 1 context for 私',
          license: 'JpStudy authored',
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
      source: 'jpstudy-authored-contextual',
      source_detail: 'JpStudy-authored Minna N5 lesson 1 context for 私',
      license: 'JpStudy authored',
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
