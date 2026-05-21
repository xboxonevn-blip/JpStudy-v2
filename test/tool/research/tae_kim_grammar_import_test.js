const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const {
  auditGrammarPayload,
  enrichGrammarPoint,
  runTaeKimGrammarImport,
} = require('../../../tool/research/import_tae_kim_grammar');

test('enriches grammar point with Directive E sections and Tae Kim attribution', () => {
  const point = enrichGrammarPoint({
    title: 'N1 は N2 です',
    structure: 'N1 は N2 です',
    explanation: 'Mẫu câu danh từ cơ bản, dùng để nói A là B.',
    level: 'N5',
    tags: ['vi-editorial-codex-pass'],
  });

  assert.equal(point.directiveE.form.includes('N1 は N2 です'), true);
  assert.equal(point.directiveE.form.startsWith('Hình thức:'), true);
  assert.equal(point.directiveE.meaning.startsWith('Ý nghĩa:'), true);
  assert.equal(point.directiveE.usage.startsWith('Sử dụng:'), true);
  assert.equal(point.directiveE.humanMoment.startsWith('Khoảnh khắc người:'), true);
  assert.equal(point.directiveE.meaning.length > 0, true);
  assert.equal(point.directiveE.usage.length > 0, true);
  assert.equal(point.directiveE.humanMoment.length > 0, true);
  assert.equal(
    point.directiveE.fallbackReference.sourceCredit,
    "Tae Kim's Guide to Japanese Grammar (CC-BY-NC-SA 3.0)",
  );
  assert.deepEqual(point.tags, ['vi-editorial-codex-pass']);
});

test('audits missing Directive E fields before enrichment', () => {
  const audit = auditGrammarPayload([
    { title: 'A', structure: 'A', explanation: 'B', level: 'N5' },
    {
      title: 'C',
      structure: 'C',
      explanation: 'D',
      level: 'N5',
      directiveE: { form: 'f', meaning: 'm', usage: 'u', humanMoment: 'h' },
    },
  ]);

  assert.equal(audit.total, 2);
  assert.equal(audit.missingDirectiveE, 1);
});

test('imports a grammar tree and writes gap audit', () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'jpstudy-tae-kim-'));
  const grammarRoot = path.join(tmp, 'grammar');
  const docsRoot = path.join(tmp, 'docs');
  fs.mkdirSync(path.join(grammarRoot, 'n5'), { recursive: true });
  fs.writeFileSync(
    path.join(grammarRoot, 'n5', 'grammar_n5_1.json'),
    JSON.stringify([
      {
        lessonId: 1,
        title: 'S か',
        structure: 'S + か',
        explanation: 'Thêm か vào cuối câu để hỏi.',
        level: 'N5',
        tags: ['vi-editorial-codex-pass'],
      },
    ]),
    'utf8',
  );

  const result = runTaeKimGrammarImport({
    grammarRoot,
    docsRoot,
    apply: true,
  });
  const rewritten = JSON.parse(
    fs.readFileSync(path.join(grammarRoot, 'n5', 'grammar_n5_1.json'), 'utf8'),
  );

  assert.equal(result.total, 1);
  assert.equal(rewritten[0].directiveE.form.includes('S + か'), true);
  assert.equal(
    fs.existsSync(path.join(docsRoot, 'grammar-gap-audit-2026-05-21.md')),
    true,
  );
});
