const assert = require('node:assert/strict');
const test = require('node:test');

const {
  buildDirectiveE,
} = require('../../../tool/research/apply_directive_e_redo');
const {
  validateDirectiveEItem,
} = require('../../../tool/qa/validate_directive_e_quality');

test('buildDirectiveE creates pattern-specific N4 teaching blocks', () => {
  const directiveE = buildDirectiveE({
    item: {
      title: 'Vた らいいですか (Xin loi khuyen)',
      structure: '疑問詞 + Vた + らいいですか',
      explanation: 'Dùng khi xin lời khuyên: nên làm gì, làm ở đâu, làm như thế nào thì tốt.',
    },
    level: 'N4',
    neighborStructures: ['Vて + いただけませんか', '普通形 + んですが'],
  });

  const report = validateDirectiveEItem({
    item_id: 'grammar:n4:sample:001',
    label: 'Vた らいいですか',
    structure: '疑問詞 + Vた + らいいですか',
    directiveE,
  });

  assert.equal(report.passed, true, report.failures.join('\n'));
  assert.match(directiveE.humanMoment, /Dr\. Linh/);
  assert.match(directiveE.humanMoment, /らいいですか/);
  assert.doesNotMatch(
    directiveE.humanMoment,
    /cần nhìn vào vai trò của cụm đứng trước|đừng dịch vội từng chữ|chốt quyết định, nối lý do, hay làm mềm câu/,
  );
  assert.equal(directiveE.crossLinks.length >= 1, true);
});
