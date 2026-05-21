const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const {
  parseCanonicalMarkdown,
  buildMimikaraAssets,
  containsBannedSourceLeak,
} = require('../../../tool/research/build_mimikara_assets');

test('parses canonical markdown without propagating banned source filenames', () => {
  const entries = parseCanonicalMarkdown(`# Canonical

\`\`\`yaml
term: 学校
reading: がっこう
hanViet: HỌC HIỆU
meaningVi: Trường học
meaningEnHint: school
level: N5
source: mimikara-n5
sourceFile: Tu Vung Mimikara N5/unit1_[thocodehoctiengnhat].pdf
sourceSection: Unit 1
sourcePage: 1
\`\`\`
`);

  assert.equal(entries.length, 1);
  assert.equal(entries[0].term, '学校');
  assert.equal(entries[0].sourceSection, 'Unit 1');
  assert.equal(containsBannedSourceLeak(JSON.stringify(entries)), false);
});

test('builds live Mimikara assets and manifests only for N1-N3', () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'jpstudy-mimikara-'));
  const canonicalDir = path.join(tmp, 'canonical');
  const assetRoot = path.join(tmp, 'assets');
  const manifestRoot = path.join(tmp, 'manifests');
  fs.mkdirSync(canonicalDir, { recursive: true });
  fs.mkdirSync(assetRoot, { recursive: true });
  fs.mkdirSync(manifestRoot, { recursive: true });

  for (const level of ['n1', 'n2', 'n3']) {
    fs.writeFileSync(
      path.join(canonicalDir, `mimikara-${level}.md`),
      `# Canonical

\`\`\`yaml
term: ${level.toUpperCase()}語
reading: ${level}
hanViet: NGỮ
meaningVi: Từ ${level.toUpperCase()}
meaningEnHint: ${level} word
level: ${level.toUpperCase()}
source: mimikara-${level}
sourceSection: Unit 1
sourcePage: 1
\`\`\`
`,
      'utf8',
    );
  }

  const result = buildMimikaraAssets({ canonicalDir, assetRoot, manifestRoot });

  assert.deepEqual(Object.keys(result.levels).sort(), ['N1', 'N2', 'N3']);
  for (const level of ['n1', 'n2', 'n3']) {
    const indexPath = path.join(assetRoot, level, 'mimikara', 'index.json');
    const manifestPath = path.join(manifestRoot, `lesson_index_mimikara_${level}.json`);
    assert.equal(fs.existsSync(indexPath), true, indexPath);
    assert.equal(fs.existsSync(manifestPath), true, manifestPath);
    assert.equal(containsBannedSourceLeak(fs.readFileSync(indexPath, 'utf8')), false);
  }
  for (const level of ['n4', 'n5']) {
    assert.equal(
      fs.existsSync(path.join(assetRoot, level, 'mimikara')),
      false,
      `${level} must not get a Mimikara asset directory`,
    );
    assert.equal(
      fs.existsSync(path.join(manifestRoot, `lesson_index_mimikara_${level}.json`)),
      false,
      `${level} must not get a Mimikara lesson manifest`,
    );
  }
  assert.deepEqual(result.openQuestions, []);
});

test('dedupes normalized term and reading inside generated level assets', () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'jpstudy-mimikara-dedupe-'));
  const canonicalDir = path.join(tmp, 'canonical');
  const assetRoot = path.join(tmp, 'assets');
  const manifestRoot = path.join(tmp, 'manifests');
  fs.mkdirSync(canonicalDir, { recursive: true });
  fs.mkdirSync(assetRoot, { recursive: true });
  fs.mkdirSync(manifestRoot, { recursive: true });

  for (const level of ['n1', 'n2', 'n3']) {
    fs.writeFileSync(
      path.join(canonicalDir, `mimikara-${level}.md`),
      `# Canonical

\`\`\`yaml
term: 重複
reading: ちょうふく
meaningVi: Trùng lặp
level: ${level.toUpperCase()}
source: mimikara-${level}
sourceSection: Unit 1
\`\`\`

\`\`\`yaml
term: 重複
reading: ちょうふく
meaningVi: Trùng lặp bản hai
level: ${level.toUpperCase()}
source: mimikara-${level}
sourceSection: Unit 2
\`\`\`
`,
      'utf8',
    );
  }

  buildMimikaraAssets({ canonicalDir, assetRoot, manifestRoot });
  const unitOne = JSON.parse(
    fs.readFileSync(path.join(assetRoot, 'n3', 'mimikara', 'unit_01.json'), 'utf8'),
  );

  assert.equal(unitOne.entries.length, 1);
  assert.equal(fs.existsSync(path.join(assetRoot, 'n3', 'mimikara', 'unit_02.json')), false);
});
