const assert = require('node:assert/strict');
const test = require('node:test');

const {
  formatCanonicalMarkdown,
  buildKanjidicVietnamIndex,
  loadKanjidic2Index,
  parseLargeCardOcr,
  parseWritingGridText,
  supplementEntry,
} = require('../../../tool/research/extract_canonical_kanji_ebooks');

test('parseLargeCardOcr extracts kanji from repeated example compounds', () => {
  const text = `
— NHẤT
Nghĩa: Một
Onyomi:
イチ イツ
Kunyomi:
ひと ひと.つ
Từ vựng:
一 (いち) - NHẤT - Số 1
一日 (ついたち) - NHẤT NHẬT - Ngày mùng 1
一月 (いちがつ) - NHẤT NGUYỆT - Tháng 1
Cách nhớ:
1 (一) bước sang ngang
Nghĩa: Hai
Onyomi:
ニ ジ
Kunyomi:
ふた ふた.つ
Từ vựng:
二 (に) - NHI - Số 2
二月 (にがつ) - NHI NGUYỆT - Tháng 2
Cách nhớ:
2 (二) bước sang ngang
`;

  const entries = parseLargeCardOcr(text, { level: 'N5', page: 1 });

  assert.equal(entries.length, 2);
  assert.deepEqual(
    entries.map((entry) => entry.kanji),
    ['一', '二'],
  );
  assert.equal(entries[0].hanViet, 'Nhất');
  assert.equal(entries[0].meaningVi, 'Một');
  assert.deepEqual(entries[0].onyomi, ['イチ', 'イツ']);
  assert.equal(entries[0].examples[0].word, '一');
});

test('parseWritingGridText extracts compact rows with visible kanji', () => {
  const text = `
MAO
Lông                                                           毛
                                                         Lông ( ) ngược với tay ( ) 手

ĐAO
Kiếm                                                          力                刀
                                                         Lực ( ) thừa, đao ( ) thụt
`;

  const entries = parseWritingGridText(text, { level: 'N4', page: 1 });

  assert.equal(entries.length, 2);
  assert.deepEqual(
    entries.map((entry) => entry.kanji),
    ['毛', '刀'],
  );
  assert.equal(entries[0].hanViet, 'Mao');
  assert.equal(entries[1].meaningVi, 'Kiếm');
  assert.match(entries[1].writingHint, /đao/);
});

test('parseWritingGridText prefers target kanji from hint line over mnemonic components', () => {
  const text = `
DẬU
Giờ dậu                                                                          西           一
                                                              Cảnh phía tây ( ) đẹp nhất ( ) vào giờ Dậu ( )     酉

QUANG
Ánh sáng                                                               小                    一          儿
                                                                Tiểu ( ) cô nương có 1 ( ) cặp chân ( ) trắng sáng ( ) 光
`;

  const entries = parseWritingGridText(text, { level: 'N1', page: 1 });

  assert.deepEqual(
    entries.map((entry) => entry.kanji),
    ['酉', '光'],
  );
  assert.equal(entries[0].hanViet, 'Dậu');
  assert.equal(entries[1].meaningVi, 'Ánh sáng');
});

test('parseWritingGridText chooses first kanji from trailing compound hint', () => {
  const text = `
SÁI
Vẩy nước                                                                     氵           西
                                                                Em THUỶ ( ) đi TÂY ( ) về ăn mặc rất SÁI LẠC         お洒落 (おしゃれ) - Sành điệu
`;

  const entries = parseWritingGridText(text, { level: 'N1', page: 1 });

  assert.equal(entries.length, 1);
  assert.equal(entries[0].kanji, '洒');
  assert.equal(entries[0].hanViet, 'Sái');
});

test('formatCanonicalMarkdown includes sources and open gaps', () => {
  const markdown = formatCanonicalMarkdown('N5', [
    {
      kanji: '一',
      hanViet: 'Nhất',
      meaningVi: 'Một',
      onyomi: ['イチ'],
      kunyomi: ['ひと.つ'],
      strokeCount: 1,
      writingHint: '1 (一) bước sang ngang',
      examples: [{ word: '一月', reading: 'いちがつ', meaning: 'Tháng 1' }],
      sourcePages: [1],
      fieldSources: {
        level: 'ebook',
        hanViet: 'ebook',
        meaningVi: 'ebook',
        readings: 'ebook_ocr',
        writingHint: 'ebook_ocr',
        examples: 'ebook_ocr',
      },
      openGaps: [],
    },
  ]);

  assert.match(markdown, /# Canonical Kanji N5/);
  assert.match(markdown, /一 \(Nhất\)/);
  assert.match(markdown, /meaningVi: Một/);
  assert.match(markdown, /sources:/);
  assert.match(markdown, /examples:/);
});

test('supplementEntry fills Hán-Việt from KANJIDIC2 for OCR-only rows', () => {
  const kanjidic2 = loadKanjidic2Index();
  const entry = supplementEntry(
    {
      kanji: '土',
      hanViet: '',
      meaningVi: 'Đất',
      onyomi: ['ド'],
      kunyomi: [],
      examples: [],
      fieldSources: { hanViet: 'supplement', meaningVi: 'ebook_ocr' },
      openGaps: [],
    },
    { appKanji: new Map(), vocab: new Map(), kanjidic2 },
  );

  assert.equal(entry.hanViet, 'Thổ');
  assert.equal(entry.fieldSources.hanViet, 'kanjidic2_supplement');
});

test('supplementEntry refuses ambiguous writing-grid target repair', () => {
  const kanjidic2 = loadKanjidic2Index();
  const kanjidicByVietnam = buildKanjidicVietnamIndex(kanjidic2);
  const entry = supplementEntry(
    {
      kanji: '一',
      hanViet: 'Dậu',
      meaningVi: 'Giờ dậu',
      onyomi: [],
      kunyomi: [],
      examples: [],
      fieldSources: { hanViet: 'ebook_text', meaningVi: 'ebook_text' },
      openGaps: [],
    },
    { appKanji: new Map(), vocab: new Map(), kanjidic2, kanjidicByVietnam },
  );

  assert.equal(entry.kanji, '一');
  assert.match(entry.openGaps.join('\n'), /target kanji ambiguous/);
});
