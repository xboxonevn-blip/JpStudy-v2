const fs = require('node:fs');
const path = require('node:path');

const repoRoot = path.resolve(__dirname, '..', '..');
const taeKimReference = {
  sourceCredit: "Tae Kim's Guide to Japanese Grammar (CC-BY-NC-SA 3.0)",
  sourceUrl: 'https://guidetojapanese.org/learn/grammar',
  license: 'CC-BY-NC-SA 3.0',
  usePolicy:
    'Fallback reference only; JpStudy writes original Vietnamese guidance and does not copy source prose.',
};

function enrichGrammarPoint(point) {
  const title = clean(point.title || point.grammarPoint);
  const structure = clean(point.structure || point.grammarPoint || title);
  const explanation = clean(point.explanation || point.explanationVi || '');
  return {
    ...point,
    directiveE: {
      form: formLine(structure),
      meaning: meaningLine(explanation, title),
      usage: usageLine({ title, structure, explanation }),
      humanMoment: humanMomentLine({ title, structure }),
      fallbackReference: {
        ...taeKimReference,
        guideSection: classifyGuideSection({ title, structure }),
      },
    },
  };
}

function auditGrammarPayload(points) {
  const audit = {
    total: 0,
    missingDirectiveE: 0,
    missingExamplesHint: 0,
    taeKimFallbackEligible: 0,
  };
  for (const point of points) {
    audit.total += 1;
    const directive = point.directiveE || {};
    if (
      !clean(directive.form) ||
      !clean(directive.meaning) ||
      !clean(directive.usage) ||
      !clean(directive.humanMoment)
    ) {
      audit.missingDirectiveE += 1;
    }
    if (clean(point.explanation).length < 40) {
      audit.missingExamplesHint += 1;
    }
    if (classifyGuideSection(point) !== 'general-grammar-fallback') {
      audit.taeKimFallbackEligible += 1;
    }
  }
  return audit;
}

function runTaeKimGrammarImport({
  grammarRoot = path.join(repoRoot, 'assets', 'data', 'content', 'grammar'),
  docsRoot = path.join(repoRoot, 'docs', 'research'),
  apply = false,
} = {}) {
  const files = listJsonFiles(grammarRoot);
  const before = emptySummary();
  const after = emptySummary();
  const levelCounts = {};
  const changedFiles = [];

  for (const file of files) {
    const payload = JSON.parse(fs.readFileSync(file, 'utf8'));
    if (!Array.isArray(payload)) continue;
    mergeSummary(before, auditGrammarPayload(payload));
    const enriched = payload.map(enrichGrammarPoint);
    mergeSummary(after, auditGrammarPayload(enriched));
    for (const point of enriched) {
      const level = clean(point.level || levelFromPath(file));
      if (!levelCounts[level]) {
        levelCounts[level] = { total: 0, taeKimFallbackEligible: 0 };
      }
      levelCounts[level].total += 1;
      if (classifyGuideSection(point) !== 'general-grammar-fallback') {
        levelCounts[level].taeKimFallbackEligible += 1;
      }
    }
    if (apply && JSON.stringify(payload) !== JSON.stringify(enriched)) {
      fs.writeFileSync(file, `${JSON.stringify(enriched, null, 2)}\n`, 'utf8');
      changedFiles.push(file);
    }
  }

  const result = {
    total: before.total,
    before,
    after,
    levelCounts,
    changedFiles: changedFiles.length,
  };
  writeAuditDoc(docsRoot, result);
  return result;
}

function formLine(structure) {
  return `Hình thức: ${structure || 'xem tên mẫu.'}`;
}

function meaningLine(explanation, title) {
  if (explanation) return `Ý nghĩa: ${firstSentence(explanation)}`;
  return `Ý nghĩa: dùng mẫu này để diễn đạt ý chính của ${title}.`;
}

function usageLine({ title, structure, explanation }) {
  const haystack = `${title} ${structure} ${explanation}`;
  if (/は/u.test(haystack)) {
    return 'Sử dụng: Đặt chủ đề trước rồi nói điều quan trọng về chủ đề đó; đừng dịch は thành một từ cố định.';
  }
  if (/か/u.test(haystack)) {
    return 'Sử dụng: Đưa か về cuối câu để biến câu đã đủ nghĩa thành câu hỏi lịch sự hoặc trung tính.';
  }
  if (/の/u.test(haystack)) {
    return 'Sử dụng: Nối danh từ theo hướng danh từ trước làm rõ danh từ sau: sở hữu, loại, nguồn hoặc thuộc tính.';
  }
  if (/て|で/u.test(haystack)) {
    return 'Sử dụng: Dùng để nối hành động, yêu cầu, trạng thái hoặc lý do; hãy đọc cả vế sau để chọn nghĩa đúng.';
  }
  if (/ない|ません/u.test(haystack)) {
    return 'Sử dụng: Theo dõi dạng phủ định trước, rồi xem mẫu đang phủ định sự thật, nghĩa vụ hay khả năng.';
  }
  if (/た|だ/u.test(haystack)) {
    return 'Sử dụng: Dạng quá khứ không chỉ nói thời gian; nó còn có thể đánh dấu trải nghiệm, hoàn tất hoặc phát hiện.';
  }
  if (/なら|ば|たら|と/u.test(haystack)) {
    return 'Sử dụng: Xác định điều kiện trước, sau đó kiểm tra vế sau là kết quả tự nhiên, lời khuyên hay giả định.';
  }
  return 'Sử dụng: Nhìn hình thức trước, gắn nghĩa vào ngữ cảnh câu, rồi mới chọn bản dịch tự nhiên.';
}

function humanMomentLine({ title, structure }) {
  const haystack = `${title} ${structure}`;
  if (/は/u.test(haystack)) {
    return 'Khoảnh khắc người: Khi tự giới thiệu, hãy coi は như đèn sân khấu đặt lên chủ đề, không phải chữ "là".';
  }
  if (/か/u.test(haystack)) {
    return 'Khoảnh khắc người: か ở cuối câu giống một cái gật hỏi lịch sự; câu trước nó vẫn cần đủ ý.';
  }
  if (/の/u.test(haystack)) {
    return 'Khoảnh khắc người: Với の, hãy hỏi "cái sau thuộc về hoặc được làm rõ bởi cái trước như thế nào?".';
  }
  if (/て|で/u.test(haystack)) {
    return 'Khoảnh khắc người: Khi nghe thể て, đừng dừng ở "và"; người Nhật thường dùng nó để nối cả mạch hành động.';
  }
  return 'Khoảnh khắc người: Nếu câu khó dịch, hãy tách mẫu ra khỏi từ vựng trước; nghĩa thường hiện rõ sau khi thấy vai trò của mẫu.';
}

function classifyGuideSection({ title = '', structure = '' } = {}) {
  const haystack = `${title} ${structure}`;
  if (/です|だ/u.test(haystack)) return 'state-of-being';
  if (/は|も|が|を|に|で|へ|と|から|まで/u.test(haystack)) return 'particles';
  if (/て|た|ない|ます|辞書|dictionary|Verb/u.test(haystack)) return 'verbs';
  if (/い-Adjective|な-Adjective|形容詞|Adjective/u.test(haystack)) {
    return 'adjectives';
  }
  if (/なら|ば|たら/u.test(haystack)) return 'conditionals';
  return 'general-grammar-fallback';
}

function writeAuditDoc(docsRoot, result) {
  fs.mkdirSync(docsRoot, { recursive: true });
  const file = path.join(docsRoot, 'grammar-gap-audit-2026-05-21.md');
  const levels = Object.entries(result.levelCounts)
    .sort(([a], [b]) => a.localeCompare(b))
    .map(
      ([level, data]) =>
        `| ${level} | ${data.total} | ${data.taeKimFallbackEligible} |`,
    )
    .join('\n');
  const body = `# Grammar Gap Audit - 2026-05-21

Phase: Sprint 1 Phase D - Tae Kim fallback integration.

Source policy:
- Primary data remains the existing JpStudy grammar corpus.
- Tae Kim is used as a licensed fallback reference only: ${taeKimReference.sourceCredit}.
- URL: ${taeKimReference.sourceUrl}
- No Tae Kim prose is copied into app content.

## Summary

| Metric | Before | After |
|---|---:|---:|
| Grammar items | ${result.before.total} | ${result.after.total} |
| Missing Directive E sections | ${result.before.missingDirectiveE} | ${result.after.missingDirectiveE} |
| Short explanation hints | ${result.before.missingExamplesHint} | ${result.after.missingExamplesHint} |
| Tae Kim fallback eligible | ${result.before.taeKimFallbackEligible} | ${result.after.taeKimFallbackEligible} |

## Level Coverage

| Level | Items | Tae Kim fallback eligible |
|---|---:|---:|
${levels}

## DECISIONS_MADE

- Added a \`directiveE\` block to grammar payloads instead of changing DB schema; the current content DB can keep seeding stable rows while UI can opt into richer guidance later.
- Used original JpStudy wording for form/meaning/usage/humanMoment. Tae Kim is recorded as fallback reference and license attribution, not as copied prose.
- Kept existing tags unchanged, including any owner-added approval tags; script never adds \`vi-human-approved\`.

## OPEN_QUESTIONS

- OQ-D-001 (non-blocking): decide later whether grammar detail UI should render \`directiveE\` as separate tabs or as one compact study card.
`;
  fs.writeFileSync(file, body, 'utf8');
}

function emptySummary() {
  return {
    total: 0,
    missingDirectiveE: 0,
    missingExamplesHint: 0,
    taeKimFallbackEligible: 0,
  };
}

function mergeSummary(target, source) {
  for (const key of Object.keys(target)) {
    target[key] += source[key] || 0;
  }
}

function listJsonFiles(root) {
  if (!fs.existsSync(root)) return [];
  const out = [];
  for (const entry of fs.readdirSync(root, { withFileTypes: true })) {
    const full = path.join(root, entry.name);
    if (entry.isDirectory()) out.push(...listJsonFiles(full));
    else if (entry.isFile() && entry.name.endsWith('.json')) out.push(full);
  }
  return out;
}

function levelFromPath(file) {
  const match = file.match(/[\\/]grammar[\\/]n([1-5])[\\/]/i);
  return match ? `N${match[1]}` : 'N5';
}

function clean(value) {
  return String(value || '').trim().replace(/\s+/g, ' ');
}

function firstSentence(value) {
  const text = clean(value).replace(/\* `/g, '`');
  const match = text.match(/^(.{1,180}?[.!?。]|.{1,180})(\s|$)/u);
  return match ? match[1].trim() : text.slice(0, 180).trim();
}

if (require.main === module) {
  const args = new Set(process.argv.slice(2));
  const result = runTaeKimGrammarImport({ apply: args.has('--apply') });
  console.log(JSON.stringify(result, null, 2));
}

module.exports = {
  auditGrammarPayload,
  enrichGrammarPoint,
  runTaeKimGrammarImport,
};
