const fs = require('node:fs');
const path = require('node:path');

const RULE1_LEGACY_ID = 'initial-c-k-kh-gi-h-qu-to-k';
const RULE1_ID = 'rule_initial_h_k_gi_c_qu_to_k';

const TARGET_KANA_K_G = ['か', 'き', 'く', 'け', 'こ', 'が', 'ぎ', 'ぐ', 'げ', 'ご'];
const INITIALS = [
  'ngh',
  'ng',
  'nh',
  'ch',
  'tr',
  'th',
  'ph',
  'kh',
  'gi',
  'qu',
  'đ',
  'd',
  'b',
  'c',
  'g',
  'h',
  'k',
  'l',
  'm',
  'n',
  'p',
  'r',
  's',
  't',
  'v',
  'x',
];

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function walkJsonFiles(dir, out = []) {
  if (!fs.existsSync(dir)) return out;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      walkJsonFiles(full, out);
    } else if (entry.name.endsWith('.json')) {
      out.push(full);
    }
  }
  return out;
}

function normalizeVietnamese(value) {
  return (value || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/đ/g, 'd')
    .replace(/Đ/g, 'D')
    .toLowerCase()
    .trim();
}

function firstSyllable(value) {
  return (value || '').trim().split(/[ ,;/]+/).find(Boolean) || '';
}

function firstConsonant(value) {
  const normalized = normalizeVietnamese(firstSyllable(value));
  for (const initial of INITIALS) {
    const comparable = initial === 'đ' ? 'd' : initial;
    if (normalized.startsWith(comparable)) return initial;
  }
  return normalized[0] || '';
}

const ROMAJI_TABLE = [
  ['kya', 'きゃ'],
  ['kyu', 'きゅ'],
  ['kyo', 'きょ'],
  ['gya', 'ぎゃ'],
  ['gyu', 'ぎゅ'],
  ['gyo', 'ぎょ'],
  ['sha', 'しゃ'],
  ['shu', 'しゅ'],
  ['sho', 'しょ'],
  ['cha', 'ちゃ'],
  ['chu', 'ちゅ'],
  ['cho', 'ちょ'],
  ['nya', 'にゃ'],
  ['nyu', 'にゅ'],
  ['nyo', 'にょ'],
  ['hya', 'ひゃ'],
  ['hyu', 'ひゅ'],
  ['hyo', 'ひょ'],
  ['bya', 'びゃ'],
  ['byu', 'びゅ'],
  ['byo', 'びょ'],
  ['pya', 'ぴゃ'],
  ['pyu', 'ぴゅ'],
  ['pyo', 'ぴょ'],
  ['mya', 'みゃ'],
  ['myu', 'みゅ'],
  ['myo', 'みょ'],
  ['rya', 'りゃ'],
  ['ryu', 'りゅ'],
  ['ryo', 'りょ'],
  ['ja', 'じゃ'],
  ['ju', 'じゅ'],
  ['jo', 'じょ'],
  ['shi', 'し'],
  ['chi', 'ち'],
  ['tsu', 'つ'],
  ['fu', 'ふ'],
  ['ka', 'か'],
  ['ki', 'き'],
  ['ku', 'く'],
  ['ke', 'け'],
  ['ko', 'こ'],
  ['ga', 'が'],
  ['gi', 'ぎ'],
  ['gu', 'ぐ'],
  ['ge', 'げ'],
  ['go', 'ご'],
  ['sa', 'さ'],
  ['su', 'す'],
  ['se', 'せ'],
  ['so', 'そ'],
  ['za', 'ざ'],
  ['ji', 'じ'],
  ['zu', 'ず'],
  ['ze', 'ぜ'],
  ['zo', 'ぞ'],
  ['ta', 'た'],
  ['te', 'て'],
  ['to', 'と'],
  ['da', 'だ'],
  ['de', 'で'],
  ['do', 'ど'],
  ['na', 'な'],
  ['ni', 'に'],
  ['nu', 'ぬ'],
  ['ne', 'ね'],
  ['no', 'の'],
  ['ha', 'は'],
  ['hi', 'ひ'],
  ['he', 'へ'],
  ['ho', 'ほ'],
  ['ba', 'ば'],
  ['bi', 'び'],
  ['bu', 'ぶ'],
  ['be', 'べ'],
  ['bo', 'ぼ'],
  ['pa', 'ぱ'],
  ['pi', 'ぴ'],
  ['pu', 'ぷ'],
  ['pe', 'ぺ'],
  ['po', 'ぽ'],
  ['ma', 'ま'],
  ['mi', 'み'],
  ['mu', 'む'],
  ['me', 'め'],
  ['mo', 'も'],
  ['ya', 'や'],
  ['yu', 'ゆ'],
  ['yo', 'よ'],
  ['ra', 'ら'],
  ['ri', 'り'],
  ['ru', 'る'],
  ['re', 'れ'],
  ['ro', 'ろ'],
  ['wa', 'わ'],
  ['wo', 'を'],
  ['n', 'ん'],
  ['a', 'あ'],
  ['i', 'い'],
  ['u', 'う'],
  ['e', 'え'],
  ['o', 'お'],
];

function katakanaToHiragana(value) {
  return value.replace(/[\u30a1-\u30f6]/g, (char) =>
    String.fromCharCode(char.charCodeAt(0) - 0x60),
  );
}

function romajiToHiragana(value) {
  const raw = (value || '').trim();
  if (!raw) return '';
  if (/[\u3040-\u309f\u30a0-\u30ff]/.test(raw)) {
    return katakanaToHiragana(raw);
  }
  let input = raw
    .toLowerCase()
    .replace(/[^a-z]/g, '')
    .replace(/ō/g, 'ou')
    .replace(/ū/g, 'uu');
  let output = '';
  while (input.length > 0) {
    if (
      input.length >= 2 &&
      input[0] === input[1] &&
      !['a', 'i', 'u', 'e', 'o', 'n'].includes(input[0])
    ) {
      output += 'っ';
      input = input.slice(1);
      continue;
    }
    const match = ROMAJI_TABLE.find(([romaji]) => input.startsWith(romaji));
    if (!match) {
      input = input.slice(1);
      continue;
    }
    output += match[1];
    input = input.slice(match[0].length);
  }
  return output;
}

function kanaMoraCount(value) {
  return (value || '').replace(/[ゃゅょぁぃぅぇぉっー]/g, '').length;
}

function titleCaseVietnamese(value) {
  return (value || '')
    .trim()
    .split(/\s+/)
    .map((part) => (part ? part[0].toUpperCase() + part.slice(1) : part))
    .join(' ');
}

function levelRank(level) {
  return { N5: 0, N4: 1, N3: 2, N2: 3, N1: 4 }[level] ?? 9;
}

function rule1Priority(kanji) {
  const order = ['校', '学', '行', '会', '何', '国', '海', '工'];
  const index = order.indexOf(kanji);
  return index === -1 ? order.length : index;
}

function loadVocabIndex(rootDir) {
  const files = walkJsonFiles(path.join(rootDir, 'assets/data/content/vocab'));
  const byVocabId = new Map();
  const bySenseId = new Map();
  const all = [];
  for (const file of files) {
    const payload = readJson(file);
    const entries = Array.isArray(payload.entries) ? payload.entries : [];
    for (const entry of entries) {
      const term = entry.lemma?.term || entry.term || '';
      const reading = entry.lemma?.reading || entry.reading || '';
      const meaningVi = entry.sense?.meaningVi || entry.meaningVi || '';
      const record = {
        term,
        reading,
        meaningVi,
        level: entry.level || payload.level || '',
        sourceVocabId: entry.links?.sourceVocabId || entry.lemma?.vocabId || '',
        sourceSenseId: entry.links?.sourceSenseId || entry.entryId || '',
      };
      all.push(record);
      if (record.sourceVocabId) byVocabId.set(record.sourceVocabId, record);
      if (record.sourceSenseId) bySenseId.set(record.sourceSenseId, record);
    }
  }
  return { all, byVocabId, bySenseId };
}

function resolveCompound(entry, vocabIndex) {
  for (const example of entry.examples) {
    const byVocab = example.sourceVocabId
      ? vocabIndex.byVocabId.get(example.sourceVocabId)
      : null;
    const bySense = example.sourceSenseId
      ? vocabIndex.bySenseId.get(example.sourceSenseId)
      : null;
    const found = byVocab || bySense;
    if (found?.term && found?.reading) return found;
  }
  return (
    vocabIndex.all
      .filter((item) => item.term.includes(entry.kanji))
      .sort((a, b) => levelRank(a.level) - levelRank(b.level))[0] || null
  );
}

function loadKanjiEntries(rootDir) {
  const files = walkJsonFiles(path.join(rootDir, 'assets/data/content/kanji'))
    .filter((file) => /[\\/]n[1-5][\\/]lesson_\d+\.json$/i.test(file))
    .sort((a, b) => a.localeCompare(b));
  const vocabIndex = loadVocabIndex(rootDir);
  const entries = [];
  let ordinal = 1;
  for (const file of files) {
    const payload = readJson(file);
    const rawEntries = Array.isArray(payload.entries) ? payload.entries : [];
    for (const raw of rawEntries) {
      const hanViet = raw.labels?.hanViet || raw.decomposition?.hanViet || '';
      const onyomiRaw = Array.isArray(raw.readings?.onyomi)
        ? raw.readings.onyomi[0] || ''
        : raw.legacy?.onyomi?.split(',')[0] || '';
      const onyomi = romajiToHiragana(onyomiRaw);
      const compound = resolveCompound(
        {
          kanji: raw.character || '',
          examples: Array.isArray(raw.examples) ? raw.examples : [],
        },
        vocabIndex,
      );
      entries.push({
        orderId: ordinal,
        assetKanjiId: raw.kanjiId || '',
        kanji: raw.character || '',
        hanViet: titleCaseVietnamese(hanViet),
        meaningVi: raw.labels?.meaningVi || raw.labels?.meaningViDisplay || '',
        onyomi,
        onyomiRaw,
        level: raw.level || payload.level || '',
        lessonId: raw.lessonId || payload.lessonId || 0,
        strokeCount: raw.strokeCount || 0,
        consonant: firstConsonant(hanViet),
        compound: compound?.term || raw.character || '',
        compoundKana: compound?.reading || '',
        compoundMeaning: compound?.meaningVi || raw.labels?.meaningVi || '',
      });
      ordinal += 1;
    }
  }
  return entries.filter((entry) => entry.kanji && entry.hanViet && entry.onyomi);
}

function toExample(entry) {
  return {
    hanViet: entry.hanViet,
    kanji: entry.kanji,
    kanjiId: entry.orderId,
    assetKanjiId: entry.assetKanjiId,
    level: entry.level,
    onyomi: entry.onyomi,
    romaji: (entry.onyomiRaw || '').toLowerCase(),
    compound: entry.compound,
    compoundKana: entry.compoundKana,
    compoundMeaning: entry.compoundMeaning,
    source: 'app-kanji-source-verified',
  };
}

function optionPoolFor(item, allEntries) {
  const targetCount = kanaMoraCount(item.onyomi);
  const unique = [];
  const seen = new Set([item.onyomi]);
  for (const entry of allEntries) {
    if (!entry.onyomi || seen.has(entry.onyomi)) continue;
    if (kanaMoraCount(entry.onyomi) !== targetCount) continue;
    unique.push(entry.onyomi);
    seen.add(entry.onyomi);
    if (unique.length >= 3) return unique;
  }
  for (const entry of allEntries) {
    if (!entry.onyomi || seen.has(entry.onyomi)) continue;
    unique.push(entry.onyomi);
    seen.add(entry.onyomi);
    if (unique.length >= 3) return unique;
  }
  return unique;
}

function rotateOptions(correct, distractors, offset) {
  const options = [correct, ...distractors.slice(0, 3)];
  while (options.length < 4) options.push(`${correct}${options.length}`);
  const shift = offset % options.length;
  return [...options.slice(shift), ...options.slice(0, shift)];
}

function buildPracticeItems(candidates, allEntries) {
  return candidates.slice(6, 11).map((entry, index) => {
    const options = rotateOptions(entry.onyomi, optionPoolFor(entry, allEntries), index);
    return {
      itemId: `${RULE1_ID}_${entry.kanji}`,
      kanji: entry.kanji,
      kanjiId: entry.orderId,
      assetKanjiId: entry.assetKanjiId,
      hanViet: entry.hanViet,
      correct: entry.onyomi,
      options,
      explanation: `${entry.hanViet} bắt đầu bằng ${firstSyllable(
        entry.hanViet,
      )}; nhóm Hán-Việt này thường về hàng K/G trong On'yomi.`,
    };
  });
}

function generateHanVietRulesV2({ rootDir = process.cwd() } = {}) {
  const legacy = readJson(
    path.join(rootDir, 'assets/data/content/kanji/han_viet_on_rules.json'),
  );
  const entries = loadKanjiEntries(rootDir);
  const seenRule1Kanji = new Set();
  const rule1Candidates = entries
    .filter((entry) =>
      ['h', 'k', 'gi', 'c', 'qu'].includes(entry.consonant) &&
      TARGET_KANA_K_G.includes(entry.onyomi[0]),
    )
    .filter((entry) => {
      if (seenRule1Kanji.has(entry.kanji)) return false;
      seenRule1Kanji.add(entry.kanji);
      return true;
    })
    .sort((a, b) => {
      const byPriority = rule1Priority(a.kanji) - rule1Priority(b.kanji);
      if (byPriority !== 0) return byPriority;
      const byLevel = levelRank(a.level) - levelRank(b.level);
      if (byLevel !== 0) return byLevel;
      const byCompound = Number(Boolean(b.compoundKana)) - Number(Boolean(a.compoundKana));
      if (byCompound !== 0) return byCompound;
      const byStroke = a.strokeCount - b.strokeCount;
      if (byStroke !== 0) return byStroke;
      return a.kanji.localeCompare(b.kanji);
    });
  const legacyRule = legacy.rules.find((rule) => rule.id === RULE1_LEGACY_ID);
  const examples = rule1Candidates.slice(0, 6).map(toExample);
  return {
    schemaVersion: 2,
    dataset: 'han_viet_on_rules_v2',
    generatedAt: '2026-05-20',
    sourcePolicy: {
      blockedDomainsExcludedCount: 2,
      note:
        'Generated from local app kanji/vocab assets and owner-provided local files only; owner-blocked crawl sources are excluded.',
    },
    rules: [
      {
        ruleId: RULE1_ID,
        legacyId: RULE1_LEGACY_ID,
        section: '1',
        parentSection: null,
        category: 'initial',
        title: 'Âm đầu là H/K/Gi/C/Qu',
        consonants: ['H', 'K', 'Gi', 'C', 'Qu'],
        targetRow: 'K/G',
        targetKana: TARGET_KANA_K_G,
        percentage: 90,
        explanation:
          "Phụ âm đầu Hán-Việt H/K/Gi/C/Qu thường chuyển sang hàng K/G trong On'yomi.",
        legacyConfidence: legacyRule?.confidence || null,
        examples,
        subRuleIds: [],
        practice: {
          count: 5,
          questionTemplate:
            "Âm Hán-Việt {hanViet} ({kanji}) -> On'yomi nào?",
          status: rule1Candidates.length >= 11 ? 'ready' : 'reference_only',
          items: buildPracticeItems(rule1Candidates, entries),
        },
      },
    ],
  };
}

function main() {
  const rootDir = path.resolve(__dirname, '..', '..');
  const outputArgIndex = process.argv.indexOf('--out');
  const output = outputArgIndex === -1
    ? path.join(rootDir, 'assets/data/content/kanji/han_viet_on_rules_v2.json')
    : path.resolve(process.argv[outputArgIndex + 1]);
  const payload = generateHanVietRulesV2({ rootDir });
  fs.mkdirSync(path.dirname(output), { recursive: true });
  fs.writeFileSync(output, `${JSON.stringify(payload, null, 2)}\n`);
  console.log(`generated ${output} (${payload.rules.length} rules)`);
}

if (require.main === module) {
  main();
}

module.exports = {
  generateHanVietRulesV2,
  romajiToHiragana,
  firstConsonant,
};
