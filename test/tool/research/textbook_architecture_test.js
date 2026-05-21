const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

const repoRoot = path.resolve(__dirname, '..', '..', '..');
const manifestRoot = path.join(repoRoot, 'lib', 'data', 'manifests');
const contentRoot = path.join(repoRoot, 'assets', 'data', 'content');

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

test('textbook catalog reflects corrected Mimikara and Shin Kanzen scopes', () => {
  const payload = readJson(path.join(manifestRoot, 'textbook_index.json'));
  const books = new Map(payload.textbooks.map((book) => [book.textbook_id, book]));

  assert.equal(books.has('mimikara_n5'), false);
  assert.equal(books.has('mimikara_n4'), false);
  for (const id of ['mimikara_n3', 'mimikara_n2', 'mimikara_n1']) {
    assert.equal(books.has(id), true, id);
    assert.deepEqual(books.get(id).categories, ['vocab']);
  }

  const expectedShinKanzen = {
    shinkanzen_n3: 83,
    shinkanzen_n2: 163,
    shinkanzen_n1: 88,
  };
  for (const [id, lessonCount] of Object.entries(expectedShinKanzen)) {
    const book = books.get(id);
    assert.ok(book, id);
    assert.deepEqual(book.categories, ['grammar']);
    assert.equal(book.lesson_count, lessonCount);
    assert.match(book.name_ja, /文法/);
    assert.match(book.name_vi, /文法/);
  }
});

test('corrected architecture has no Mimikara N4/N5 assets or source-gap fallback tags', () => {
  for (const level of ['n4', 'n5']) {
    assert.equal(
      fs.existsSync(path.join(contentRoot, 'vocab', level, 'mimikara')),
      false,
      `${level} Mimikara directory must be deleted`,
    );
    assert.equal(
      fs.existsSync(path.join(manifestRoot, `lesson_index_mimikara_${level}.json`)),
      false,
      `${level} Mimikara lesson manifest must be deleted`,
    );
  }

  const haystackRoots = ['lib', 'assets', 'tool'].map((dir) => path.join(repoRoot, dir));
  const banned = /mimikara_n4|mimikara_n5|source-gap-fallback-OQ014/;
  const offenders = [];
  for (const root of haystackRoots) {
    scan(root, offenders, banned);
  }
  assert.deepEqual(offenders, []);
});

test('Shin Kanzen grammar lesson indexes exist at corrected lesson counts', () => {
  const expected = { n3: 83, n2: 163, n1: 88 };
  for (const [level, count] of Object.entries(expected)) {
    const file = path.join(manifestRoot, `lesson_index_shinkanzen_${level}.json`);
    const payload = readJson(file);
    assert.equal(payload.textbook_id, `shinkanzen_${level}`);
    assert.equal(payload.lessons.length, count, file);
    for (const lesson of payload.lessons) {
      assert.deepEqual(Object.keys(lesson.item_counts), ['grammar']);
      assert.equal(lesson.item_counts.grammar >= 0, true);
    }
  }
});

function scan(root, offenders, banned) {
  if (!fs.existsSync(root)) return;
  for (const entry of fs.readdirSync(root, { withFileTypes: true })) {
    const full = path.join(root, entry.name);
    if (entry.isDirectory()) {
      scan(full, offenders, banned);
      continue;
    }
    if (!entry.isFile()) continue;
    const text = fs.readFileSync(full, 'utf8');
    if (banned.test(text)) {
      offenders.push(path.relative(repoRoot, full).replace(/\\/g, '/'));
    }
  }
}
