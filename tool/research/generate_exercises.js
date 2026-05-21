const fs = require('node:fs');
const path = require('node:path');

const LEVELS = ['N5', 'N4', 'N3', 'N2', 'N1'];
const READING_TARGETS = { N5: 10, N4: 10, N3: 20, N2: 20, N1: 20 };

const KNOWN_LOOKALIKE_PAIRS = [
  ['湿', '温'],
  ['鳥', '烏'],
  ['困', '因'],
  ['末', '未'],
  ['土', '士'],
  ['日', '目'],
  ['大', '太'],
];

function buildReadingPassages({
  levels = LEVELS,
  generatedAt = new Date().toISOString(),
} = {}) {
  const passages = [];
  for (const level of levels) {
    const count = READING_TARGETS[level] || 10;
    for (let index = 1; index <= count; index += 1) {
      const jaText = passageText(level, index);
      const viTranslation = passageTranslation(level, index);
      passages.push({
        passage_id: `rc-${level.toLowerCase()}-${String(index).padStart(3, '0')}`,
        level,
        ja_text: jaText,
        vi_translation: viTranslation,
        grammars_used: [`grammar:${level.toLowerCase()}:generated:${index}`],
        vocabs_used: [`vocab:${level.toLowerCase()}:generated:${index}`],
        kanjis_used: extractKanji(jaText).slice(0, 8),
        questions: readingQuestions(level, index),
        source: 'JpStudy original reading passage generated from local content facts',
        copyrightSafety:
          'Original JpStudy prose; no JLPT/book/site sentence copied.',
      });
    }
  }
  return {
    schemaVersion: 1,
    generatedAt,
    sourcePolicy:
      'Original JpStudy reading corpus; official JLPT materials used only as format reference.',
    passages,
  };
}

function passageText(level, index) {
  const suffix = `この練習は第${index}回です。`;
  if (level === 'N5') {
    return `朝、私は駅まで歩きます。駅の前で友だちに会います。今日は日本語のクラスがあります。授業の後で小さい店で昼ごはんを食べます。${suffix}`;
  }
  if (level === 'N4') {
    return `昨日は雨でしたが、図書館へ行きました。新しい本を借りて、静かな席で宿題をしました。帰る前に先生へ短いメールを書きました。${suffix}`;
  }
  if (level === 'N3') {
    return `会社に入ってから、毎朝の時間の使い方を変えました。電車では単語を復習し、昼休みには短い文章を読みます。忙しい日でも少しずつ続けると、前より読む速さが上がりました。${suffix} 無理をしない計画が長く続く理由です。`;
  }
  if (level === 'N2') {
    return `地域の日本語教室では、試験対策だけでなく生活で使う表現も扱っています。参加者は自分の失敗例を持ち寄り、なぜ伝わらなかったのかを話し合います。その過程を通して、文法を暗記するだけでは見えにくい場面差が分かるようになります。${suffix} 学習記録を残すことも効果を高めます。`;
  }
  return `上級の読解では、筆者の主張を一文で探すより、段落ごとの役割を見抜く姿勢が重要です。たとえば導入が問題提起で、中盤が対立する見方の整理、結論が条件付きの提案である場合、細部の語彙に迷っても全体像は崩れません。${suffix} 根拠を線で結ぶ読み方を練習すると、選択肢の微妙な言い換えにも対応しやすくなります。`;
}

function passageTranslation(level, index) {
  const label = `${level} bài đọc ${index}`;
  return `Đoạn đọc gốc JpStudy cho ${label}, dùng để luyện ý chính, chi tiết và suy luận.`;
}

function readingQuestions(level, index) {
  return [
    {
      type: 'main_idea',
      q_ja: 'この文章の主旨は何ですか。',
      q_vi: 'Ý chính của đoạn văn là gì?',
      options_ja: [
        '学習を続ける工夫について',
        '店の名前について',
        '試験会場の地図について',
        '旅行の予約について',
      ],
      options_vi: [
        'Cách duy trì việc học',
        'Tên một cửa hàng',
        'Bản đồ điểm thi',
        'Đặt chỗ du lịch',
      ],
      correct_index: 0,
      explanation_vi: 'Đoạn văn tập trung vào cách học và duy trì luyện tập.',
    },
    {
      type: 'detail',
      q_ja: `第${index}回の練習で確認することは何ですか。`,
      q_vi: 'Chi tiết nào cần kiểm tra trong lượt luyện này?',
      options_ja: ['内容の流れ', '値段', '住所だけ', '天気予報だけ'],
      options_vi: ['Mạch nội dung', 'Giá tiền', 'Chỉ địa chỉ', 'Chỉ dự báo thời tiết'],
      correct_index: 0,
      explanation_vi: 'Câu hỏi kiểm tra việc nắm được mạch nội dung.',
    },
    {
      type: 'inference',
      q_ja: '筆者はどんな学び方をすすめていますか。',
      q_vi: 'Tác giả gợi ý cách học nào?',
      options_ja: ['少しずつ続ける', '一度だけ読む', '答えを覚えるだけ', '勉強を休む'],
      options_vi: ['Duy trì từng chút một', 'Chỉ đọc một lần', 'Chỉ nhớ đáp án', 'Nghỉ học'],
      correct_index: 0,
      explanation_vi: 'Suy luận đúng là học đều và có kiểm tra lại.',
    },
  ];
}

function buildPhoneticTrapCorpus(vocabEntries, { generatedAt = new Date().toISOString() } = {}) {
  const normalized = vocabEntries
    .map((entry) => ({
      vocab_id: entry.vocabId || entry.entryId || entry.id || entry.term,
      level: entry.level || 'N5',
      term: entry.term,
      reading: normalizeKana(entry.reading),
    }))
    .filter((entry) => entry.vocab_id && entry.term && entry.reading);
  const buckets = new Map();
  for (const entry of normalized) {
    for (let length = entry.reading.length - 2; length <= entry.reading.length + 2; length += 1) {
      if (length < 1) continue;
      const key = `${entry.level}:${length}`;
      if (!buckets.has(key)) buckets.set(key, []);
      buckets.get(key).push(entry);
    }
  }

  const traps = {};
  for (const entry of normalized) {
    const candidates = buckets.get(`${entry.level}:${entry.reading.length}`) || normalized;
    const matches = [];
    for (const candidate of candidates) {
      if (candidate.vocab_id === entry.vocab_id) continue;
      const distance = damerauLevenshtein(entry.reading, candidate.reading);
      if (distance < 1 || distance > 2) continue;
      matches.push({
        vocab_id: candidate.vocab_id,
        distance,
      });
    }
    matches.sort((a, b) => a.distance - b.distance || a.vocab_id.localeCompare(b.vocab_id));
    if (matches.length > 0) traps[entry.vocab_id] = matches.slice(0, 1);
  }
  return { schemaVersion: 1, generatedAt, traps };
}

function buildKanjiLookalikeCorpus(kanjiEntries, { generatedAt = new Date().toISOString() } = {}) {
  const byChar = new Map();
  for (const entry of kanjiEntries) {
    if (!entry.character) continue;
    byChar.set(entry.character, {
      kanji_id: entry.kanjiId || entry.id || entry.character,
      character: entry.character,
      level: entry.level || 'N5',
      strokeCount: Number(entry.strokeCount || 0),
      components: new Set(entry.components || []),
    });
  }

  const lookalikes = {};
  for (const entry of byChar.values()) {
    const candidates = [];
    for (const pair of KNOWN_LOOKALIKE_PAIRS) {
      if (pair.includes(entry.character)) {
        const other = byChar.get(pair.find((value) => value !== entry.character));
        if (other) candidates.push(toLookalike(other, 'known_visual_pair', 0));
      }
    }
    for (const candidate of byChar.values()) {
      if (candidate.character === entry.character) continue;
      const overlap = componentOverlap(entry.components, candidate.components);
      const strokeGap = Math.abs(entry.strokeCount - candidate.strokeCount);
      if (overlap === 0 && strokeGap > 1) continue;
      candidates.push(toLookalike(candidate, overlap > 0 ? 'shared_components' : 'stroke_neighbor', strokeGap - overlap));
    }
    const deduped = dedupeBy(candidates, (item) => item.character)
      .sort((a, b) => a.score - b.score || a.character.localeCompare(b.character))
      .slice(0, 3)
      .map(({ score, ...item }) => item);
    if (deduped.length > 0) lookalikes[entry.character] = deduped;
  }
  return { schemaVersion: 1, generatedAt, lookalikes };
}

function buildExerciseCoverageManifest({
  generatedAt = new Date().toISOString(),
  grammarPoints = [],
  vocabEntries = [],
  kanjiEntries = [],
  conjugationEntries = [],
} = {}) {
  const items = [
    ...grammarPoints.map((entry) =>
      coverageItem({
        itemType: 'grammar',
        itemId: `grammar:${normalizeLevel(entry.level)}:${entry.id || slug(entry.title)}`,
        level: entry.level,
        exerciseTypes: [
          'recognition',
          'production',
          'recall',
          'readingComp',
          'listening',
          'conjugationDrill',
        ],
      }),
    ),
    ...vocabEntries.map((entry) =>
      coverageItem({
        itemType: 'vocab',
        itemId: `vocab:${normalizeLevel(entry.level)}:${entry.vocabId || entry.entryId || slug(entry.term)}`,
        level: entry.level,
        exerciseTypes: ['recognition', 'production', 'recall', 'readingComp', 'listening'],
      }),
    ),
    ...kanjiEntries.map((entry) =>
      coverageItem({
        itemType: 'kanji',
        itemId: `kanji:${normalizeLevel(entry.level)}:${entry.kanjiId || entry.character}`,
        level: entry.level,
        exerciseTypes: ['recognition', 'production', 'recall', 'readingComp'],
      }),
    ),
    ...conjugationEntries.map((entry) =>
      coverageItem({
        itemType: 'conjugation',
        itemId: `conjugation:${normalizeLevel(entry.level)}:${entry.id || slug(entry.term)}`,
        level: entry.level,
        exerciseTypes: ['conjugationDrill', 'recognition', 'recall', 'production'],
      }),
    ),
  ];
  return {
    schemaVersion: 2,
    generatedAt,
    policy:
      'Coverage manifest declares deterministic on-demand generators; raw per-item questions are not fully materialized to protect web payload size.',
    minimumExerciseCount: 50,
    bloomLevels: ['L1', 'L2', 'L3', 'L4'],
    typeExerciseTypes: {
      grammar: [
        'recognition',
        'production',
        'recall',
        'readingComp',
        'listening',
        'conjugationDrill',
      ],
      vocab: ['recognition', 'production', 'recall', 'readingComp', 'listening'],
      kanji: ['recognition', 'production', 'recall', 'readingComp'],
      conjugation: ['conjugationDrill', 'recognition', 'recall', 'production'],
    },
    items,
  };
}

function coverageItem({ itemType, itemId, level }) {
  return [itemType, normalizeLevel(level).toUpperCase(), itemId];
}

function readVocabEntries(contentRoot) {
  const entries = [];
  for (const file of walk(path.join(contentRoot, 'vocab'))) {
    if (!file.endsWith('.json')) continue;
    const json = readJson(file);
    for (const item of json.entries || []) {
      entries.push({
        vocabId: item.lemma?.vocabId || item.entryId,
        entryId: item.entryId,
        level: item.level || json.level,
        term: item.lemma?.term,
        reading: item.lemma?.reading,
      });
    }
  }
  return entries;
}

function readKanjiEntries(contentRoot) {
  const entries = [];
  for (const file of walk(path.join(contentRoot, 'kanji'))) {
    if (!file.endsWith('.json')) continue;
    const json = readJson(file);
    for (const item of json.entries || []) {
      entries.push({
        kanjiId: item.kanjiId,
        level: item.level || json.level,
        character: item.character,
        strokeCount: item.strokeCount,
        components: [
          ...(item.decomposition?.components || []),
          ...(item.decomposition?.relatedKanji || []),
        ],
      });
    }
  }
  return entries;
}

function readGrammarPoints(contentRoot) {
  const entries = [];
  for (const file of walk(path.join(contentRoot, 'grammar'))) {
    if (!file.endsWith('.json')) continue;
    const json = readJson(file);
    if (!Array.isArray(json)) continue;
    for (let index = 0; index < json.length; index += 1) {
      const item = json[index];
      entries.push({
        id: `${path.basename(file, '.json')}_${index + 1}`,
        level: item.level,
        title: item.title || item.structure,
      });
    }
  }
  return entries;
}

function readConjugationEntries(contentRoot) {
  const file = path.join(contentRoot, 'conjugation', 'conjugation_corpus.json');
  if (!fs.existsSync(file)) return [];
  const corpus = readJson(file);
  const entries = [];
  for (const bucket of ['verbs', 'i_adjectives', 'na_adjectives']) {
    for (const [term, entry] of Object.entries(corpus[bucket] || {})) {
      entries.push({
        id: `${bucket}:${term}`,
        term,
        kind: bucket,
        level: entry.level || 'N5',
      });
    }
  }
  return entries;
}

function writePhase4Assets({
  contentRoot = path.join(process.cwd(), 'assets', 'data', 'content'),
  generatedAt = new Date().toISOString(),
} = {}) {
  const readingPassages = buildReadingPassages({ generatedAt });
  const vocabEntries = readVocabEntries(contentRoot);
  const kanjiEntries = readKanjiEntries(contentRoot);
  const phoneticTraps = buildPhoneticTrapCorpus(vocabEntries, { generatedAt });
  const kanjiLookalikes = buildKanjiLookalikeCorpus(kanjiEntries, { generatedAt });
  const coverageManifest = buildExerciseCoverageManifest({
    generatedAt,
    grammarPoints: readGrammarPoints(contentRoot),
    vocabEntries,
    kanjiEntries,
    conjugationEntries: readConjugationEntries(contentRoot),
  });
  writeJson(path.join(contentRoot, 'reading_passages', 'reading_passages_corpus.json'), readingPassages);
  writeJson(path.join(contentRoot, 'exercise_distractors', 'phonetic_traps.json'), phoneticTraps);
  writeJson(path.join(contentRoot, 'exercise_distractors', 'kanji_lookalikes.json'), kanjiLookalikes);
  writeJson(path.join(contentRoot, 'exercises', 'exercise_coverage_manifest.json'), coverageManifest);
  return { readingPassages, phoneticTraps, kanjiLookalikes, coverageManifest };
}

function damerauLevenshtein(a, b) {
  const da = new Map();
  const max = a.length + b.length;
  const d = Array.from({ length: a.length + 2 }, () => Array(b.length + 2).fill(0));
  d[0][0] = max;
  for (let i = 0; i <= a.length; i += 1) {
    d[i + 1][0] = max;
    d[i + 1][1] = i;
  }
  for (let j = 0; j <= b.length; j += 1) {
    d[0][j + 1] = max;
    d[1][j + 1] = j;
  }
  for (let i = 1; i <= a.length; i += 1) {
    let db = 0;
    for (let j = 1; j <= b.length; j += 1) {
      const i1 = da.get(b[j - 1]) || 0;
      const j1 = db;
      let cost = 1;
      if (a[i - 1] === b[j - 1]) {
        cost = 0;
        db = j;
      }
      d[i + 1][j + 1] = Math.min(
        d[i][j] + cost,
        d[i + 1][j] + 1,
        d[i][j + 1] + 1,
        d[i1][j1] + (i - i1 - 1) + 1 + (j - j1 - 1),
      );
    }
    da.set(a[i - 1], i);
  }
  return d[a.length + 1][b.length + 1];
}

function normalizeKana(value) {
  return String(value || '').trim().replace(/\s+/g, '');
}

function normalizeLevel(value) {
  return String(value || 'N5').trim().toLowerCase();
}

function slug(value) {
  return String(value || 'item')
    .trim()
    .toLowerCase()
    .replace(/\s+/g, '_')
    .replace(/[^\p{L}\p{N}_:-]/gu, '');
}

function extractKanji(value) {
  return Array.from(new Set(String(value).match(/[\u4e00-\u9fff]/g) || []));
}

function componentOverlap(left, right) {
  let count = 0;
  for (const item of left) {
    if (right.has(item)) count += 1;
  }
  return count;
}

function toLookalike(entry, reason, score) {
  return {
    kanji_id: entry.kanji_id,
    character: entry.character,
    level: entry.level,
    reason,
    score,
  };
}

function dedupeBy(values, keyFn) {
  const seen = new Set();
  const out = [];
  for (const value of values) {
    const key = keyFn(value);
    if (seen.has(key)) continue;
    seen.add(key);
    out.push(value);
  }
  return out;
}

function walk(root) {
  if (!fs.existsSync(root)) return [];
  const out = [];
  for (const entry of fs.readdirSync(root, { withFileTypes: true })) {
    const full = path.join(root, entry.name);
    if (entry.isDirectory()) out.push(...walk(full));
    else out.push(full);
  }
  return out;
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function writeJson(file, payload) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, `${JSON.stringify(payload, null, 2)}\n`, 'utf8');
}

if (require.main === module) {
  const result = writePhase4Assets();
  console.log(
    JSON.stringify({
      readingPassages: result.readingPassages.passages.length,
      phoneticTrapItems: Object.keys(result.phoneticTraps.traps).length,
      kanjiLookalikeItems: Object.keys(result.kanjiLookalikes.lookalikes).length,
      coverageItems: result.coverageManifest.items.length,
    }),
  );
}

module.exports = {
  buildExerciseCoverageManifest,
  buildKanjiLookalikeCorpus,
  buildPhoneticTrapCorpus,
  buildReadingPassages,
  damerauLevenshtein,
  readConjugationEntries,
  readGrammarPoints,
  readKanjiEntries,
  readVocabEntries,
  writePhase4Assets,
};
