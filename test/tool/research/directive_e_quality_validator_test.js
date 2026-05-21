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
