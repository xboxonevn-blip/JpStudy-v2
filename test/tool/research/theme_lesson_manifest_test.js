const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const {
  buildManifests,
  requiredTextbookCatalog,
  writeManifests,
} = require('../../../tool/migration/restructure_to_theme_lesson');
const {
  validateMigration,
} = require('../../../tool/migration/validate_migration');

function writeJson(file, payload) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, `${JSON.stringify(payload, null, 2)}\n`);
}

function makeFixture() {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'jpstudy-manifest-'));
  const contentRoot = path.join(dir, 'assets', 'data', 'content');

  writeJson(path.join(contentRoot, 'vocab', 'n5', 'minna', 'lesson_01.json'), {
    schemaVersion: 2,
    dataset: 'vocab',
    series: 'minna',
    level: 'N5',
    lessonId: 1,
    entries: [
      {
        entryId: 'n5_l01_s001',
        lemma: { term: '私', reading: 'わたし' },
        sense: { meaningVi: 'tôi' },
      },
    ],
  });
  writeJson(path.join(contentRoot, 'grammar', 'n5', 'grammar_n5_1.json'), [
    {
      lessonId: 1,
      title: 'N1 は N2 です',
      structure: 'N1 は N2 です',
      level: 'N5',
    },
  ]);
  writeJson(path.join(contentRoot, 'kanji', 'n5', 'lesson_01.json'), {
    schemaVersion: 2,
    dataset: 'kanji',
    level: 'N5',
    lessonId: 1,
    entries: [
      {
        kanjiId: 'n5_l01_k001',
        character: '一',
        labels: { meaningVi: 'một' },
      },
    ],
  });
  writeJson(
    path.join(contentRoot, 'vocab', 'n5', 'hajimete', 'hajimete_ch01.json'),
    {
      schemaVersion: 2,
      dataset: 'vocab',
      series: 'hajimete',
      level: 'N5',
      chapterId: 1,
      chapterTitle: '公開コア語彙 01',
      entries: [
        {
          entryId: 'haj_n5_ch01_001',
          lemma: { term: '開ける', reading: 'あける' },
          sense: { meaningVi: 'mở' },
        },
      ],
    },
  );
  writeJson(
    path.join(contentRoot, 'vocab', 'n3', 'ShinKanzen', 'index.json'),
    {
      schemaVersion: 1,
      series: 'ShinKanzen',
      level: 'N3',
      lessons: [
        {
          lessonId: 1,
          file: 'shinkanzen_n3_01_nouns_general_1_0001_0015.json',
          categoryTitle: 'Nouns - General 1',
        },
      ],
    },
  );
  writeJson(
    path.join(
      contentRoot,
      'vocab',
      'n3',
      'ShinKanzen',
      'shinkanzen_n3_01_nouns_general_1_0001_0015.json',
    ),
    {
      schemaVersion: 2,
      dataset: 'vocab',
      series: 'ShinKanzen',
      level: 'N3',
      lessonId: 1,
      entries: [
        {
          entryId: 'n3_l01_s001',
          lemma: { term: '愛', reading: 'あい' },
          sense: { meaningVi: 'yêu' },
        },
      ],
    },
  );

  return { dir, contentRoot };
}

test('requiredTextbookCatalog covers the phase-one required tracks', () => {
  const ids = requiredTextbookCatalog().map((track) => track.textbook_id);

  assert.deepEqual(
    [
      'minna_n5',
      'minna_n4',
      'hajimete_tango_n5',
      'hajimete_tango_n4',
      'hajimete_tango_n3',
      'hajimete_tango_n2',
      'hajimete_tango_n1',
      'mimikara_n5',
      'mimikara_n4',
      'mimikara_n3',
      'mimikara_n2',
      'mimikara_n1',
      'shinkanzen_n3',
      'shinkanzen_n2',
      'shinkanzen_n1',
    ].every((id) => ids.includes(id)),
    true,
  );
});

test('buildManifests groups flat content without losing legacy items', () => {
  const fixture = makeFixture();
  const manifests = buildManifests({
    contentRoot: fixture.contentRoot,
    generatedAt: '2026-05-21T00:00:00+07:00',
  });

  const minna = manifests.textbookIndex.textbooks.find(
    (book) => book.textbook_id === 'minna_n5',
  );
  assert.equal(minna.item_count_total, 2);

  const minnaLessons = manifests.lessonIndexes['lesson_index_minna_n5.json'];
  assert.equal(minnaLessons.lessons.length, 1);
  assert.deepEqual(minnaLessons.lessons[0].item_counts, {
    grammar: 1,
    vocab: 1,
  });

  const itemIndex =
    manifests.itemIndexes['item_index_minna_n5_minna_n5_01.json'];
  assert.equal(itemIndex.items.length, 2);
  const kanjiTrack = manifests.textbookIndex.textbooks.find(
    (book) => book.textbook_id === 'canonical_kanji_n5',
  );
  assert.equal(kanjiTrack.item_count_total, 1);
  assert.equal(
    itemIndex.items.every((item) =>
      fs.existsSync(path.join(fixture.contentRoot, item.legacy_ref.file)),
    ),
    true,
  );
  assert.equal(manifests.summary.legacyItemCount, 5);
  assert.equal(manifests.summary.migratedItemCount, 5);
});

test('writeManifests and validateMigration report zero lost items', () => {
  const fixture = makeFixture();
  const manifestRoot = path.join(fixture.dir, 'lib', 'data', 'manifests');
  const manifests = buildManifests({
    contentRoot: fixture.contentRoot,
    generatedAt: '2026-05-21T00:00:00+07:00',
  });

  writeManifests(manifests, manifestRoot);
  const report = validateMigration({
    contentRoot: fixture.contentRoot,
    manifestRoot,
  });

  assert.equal(report.lostItemCount, 0);
  assert.equal(report.orphanReferenceCount, 0);
  assert.equal(report.emptyGeneratedLessonCount, 0);
  assert.equal(report.oldReaderItemCount, 5);
  assert.equal(report.newReaderItemCount, 5);
});
