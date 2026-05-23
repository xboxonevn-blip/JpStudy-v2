const assert = require('node:assert/strict');
const test = require('node:test');

const {
  validateDirectiveEItem,
  validateDirectiveEItems,
} = require('../../../tool/qa/validate_directive_e_quality');

test('validateDirectiveEItem rejects generic template-injection prose', () => {
  const report = validateDirectiveEItem({
    item_id: 'grammar:n5:sample:001',
    label: 'N も',
    structure: 'N + も',
    directiveE: {
      form: 'Hình thức: N + も',
      meaning: 'Ý nghĩa: cũng.',
      usage: 'Sử dụng: Nhìn hình thức trước, gắn nghĩa vào ngữ cảnh câu.',
      humanMoment:
        'Khoảnh khắc người: Nếu câu khó dịch, hãy tách mẫu ra khỏi từ vựng trước; nghĩa thường hiện rõ sau khi thấy vai trò của mẫu.',
      fallbackReference: { license: 'CC-BY-NC-SA 3.0' },
    },
  });

  assert.equal(report.passed, false);
  assert.match(report.failures.join('\n'), /banned phrase/);
  assert.match(report.failures.join('\n'), /etymology/);
  assert.match(report.failures.join('\n'), /crossLinks/);
  assert.match(report.failures.join('\n'), /pattern-specific reference/);
});

test('validateDirectiveEItem rejects pattern-name-swapped generic redo prose', () => {
  const report = validateDirectiveEItem({
    item_id: 'grammar:n4:sample:002',
    label: '〜そうです',
    structure: 'V普通形 / いA / なAだ / Nだ + そうです',
    directiveE: {
      etymology:
        'Gốc cấu trúc của そうです nằm ở cách tiếng Nhật ghép thành phần ngữ pháp thành một cụm chức năng: trợ từ giữ vai trò đánh dấu quan hệ trong câu. Hãy nhìn cấu trúc trước như một bộ khung, rồi mới gắn nghĩa của câu vào từng vị trí; cách đọc này giúp tránh dịch rời từng từ.',
      hanVietBridge:
        'Cầu Hán-Việt: そうです không nhất thiết có chữ Hán nổi bật, nên hãy mượn cặp ý Hán-Việt hình thức - chức năng.',
      form: 'Hình thức: V普通形 / いA / なAだ / Nだ + そうです.',
      meaning: 'Ý nghĩa: truyền đạt thông tin nghe hoặc đọc được.',
      usage:
        'Sử dụng: kiểm tra dạng từ ngay trước mẫu, sau đó đọc tiếp vế sau để xác định kết luận, lý do hoặc thái độ của người nói.',
      humanMoment:
        'Dr. Linh lưu ý: V普通形 / いA / なAだ / Nだ + そうです khác V普通形 / いA / なAな / Nの + ようです ở điểm cần nhìn vào vai trò của cụm đứng trước. Với V普通形 / いA / なAだ / Nだ + そうです, đừng dịch vội từng chữ; hãy hỏi mẫu này đang chốt quyết định, nối lý do, hay làm mềm câu.',
      crossLinks: [
        {
          pattern: 'V普通形 / いA / なAな / Nの + ようです',
          contrast:
            'Khác V普通形 / いA / なAだ / Nだ + そうです: V普通形 / いA / なAな / Nの + ようです có hình thức hoặc sắc thái gần, nhưng không thay thế máy móc; hãy so phần nối trước mẫu và lực nghĩa ở vế sau.',
        },
      ],
      fallbackReference: { license: 'CC-BY-NC-SA 3.0' },
    },
  });

  assert.equal(report.passed, false);
  assert.match(report.failures.join('\n'), /banned phrase/);
});

test('validateDirectiveEItem accepts pattern-specific Dr Linh content', () => {
  const report = validateDirectiveEItem({
    item_id: 'grammar:n4:sample:001',
    label: '〜ことにする',
    structure: 'Vる + ことにする',
    directiveE: {
      etymology:
        'こと là danh từ trừu tượng, gốc chữ 事 = sự. Khi gắn Vる + こと rồi thêm にする, cấu trúc này biến một hành động thành một sự việc được người nói chủ động chọn.',
      hanVietBridge:
        '事 đọc Hán-Việt là sự: sự việc, sự tình, sự nghiệp. Người Việt đã quen coi sự là chuyện trừu tượng, đúng vai trò của こと ở đây.',
      form: 'Hình thức: Vる + ことにする. Vế trước là hành động được danh từ hóa bằng こと, rồi にする chốt thành quyết định.',
      meaning:
        'Ý nghĩa: người nói hoặc chủ thể tự quyết sẽ làm việc đó, thường sau khi cân nhắc.',
      usage:
        'Sử dụng: hợp với quyết định cá nhân như 留学することにした; không dùng khi hoàn cảnh khách quan ép kết quả xảy ra.',
      humanMoment:
        'Dr. Linh lưu ý: 〜ことにする và 〜ことになる nhìn giống nhau nhưng khác ý chí. 〜ことにする là quyết định của tôi; 〜ことになる là việc được sắp bởi hoàn cảnh.',
      crossLinks: [
        {
          pattern: '〜ことになる',
          contrast: 'khác ở ý chí: にする là tự quyết, になる là thành kết quả khách quan.',
        },
      ],
      fallbackReference: { license: 'CC-BY-NC-SA 3.0' },
    },
  });

  assert.deepEqual(report.failures, []);
  assert.equal(report.passed, true);
});

test('validateDirectiveEItems reports item counts and duplicate ids', () => {
  const report = validateDirectiveEItems([
    {
      item_id: 'grammar:n5:x:001',
      label: 'S か',
      structure: 'S + か',
      directiveE: { humanMoment: 'Khoảnh khắc người: generic.' },
    },
    {
      item_id: 'grammar:n5:x:001',
      label: 'S か',
      structure: 'S + か',
      directiveE: { humanMoment: 'Khoảnh khắc người: generic.' },
    },
  ]);

  assert.equal(report.passed, false);
  assert.equal(report.counts.totalItems, 2);
  assert.match(report.failures.join('\n'), /duplicate directiveE item/);
});

test('validateDirectiveEItem keeps real kanji inside pattern references', () => {
  const report = validateDirectiveEItem({
    item_id: 'grammar:n2:sample:002',
    label: '〜を問わず',
    structure: 'Noun + を問わず',
    directiveE: {
      etymology:
        'Gốc cấu trúc của を問わず nằm ở 問う, động từ hỏi/xét, cộng phủ định ず. Cả cụm chuyển thành ý không xét đến điều kiện được nêu trước.',
      hanVietBridge:
        '問 là vấn trong vấn đề, chất vấn. Nhớ を問わず như không đặt câu hỏi về giới tính, tuổi tác, quốc tịch hay điều kiện đó.',
      form: 'Hình thức: danh từ + を問わず, đặt trước kết luận áp dụng rộng.',
      meaning:
        'Ý nghĩa: không xét đến N, bất kể N là gì thì kết luận vẫn giữ nguyên.',
      usage:
        'Sử dụng: hợp văn thông báo/quy định như 年齢を問わず参加できます.',
      humanMoment:
        'Dr. Linh lưu ý: を問わず khác にかかわらず ở hình ảnh gốc. を問わず là không đem điều kiện ra hỏi/xét; にかかわらず là không bị điều kiện đó liên quan chi phối.',
      crossLinks: [
        {
          pattern: '〜にかかわらず',
          contrast: 'Khác を問わず: にかかわらず nhấn mạnh không bị điều kiện chi phối.',
        },
      ],
      fallbackReference: { license: 'CC-BY-NC-SA 3.0' },
    },
  });

  assert.equal(report.passed, true, report.failures.join('\n'));
});
