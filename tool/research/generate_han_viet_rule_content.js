const fs = require('node:fs');
const path = require('node:path');

const RULE1_LEGACY_ID = 'initial-c-k-kh-gi-h-qu-to-k';
const RULE1_ID = 'rule_initial_h_k_gi_c_qu_to_k';

const TARGET_KANA_K_G = ['か', 'き', 'く', 'け', 'こ', 'が', 'ぎ', 'ぐ', 'げ', 'ご'];
const TARGET_KANA_T_S_SH = [
  'た',
  'ち',
  'つ',
  'て',
  'と',
  'だ',
  'で',
  'ど',
  'さ',
  'し',
  'す',
  'せ',
  'そ',
  'しゃ',
  'しゅ',
  'しょ',
];
const TARGET_KANA_G_GY = ['が', 'ぎ', 'ぐ', 'げ', 'ご', 'ぎゃ', 'ぎゅ', 'ぎょ'];
const TARGET_KANA_R = ['ら', 'り', 'る', 'れ', 'ろ', 'りゃ', 'りゅ', 'りょ'];
const TARGET_KANA_N_J_NY = [
  'な',
  'に',
  'ぬ',
  'ね',
  'の',
  'じ',
  'じゃ',
  'じゅ',
  'じょ',
  'にゃ',
  'にゅ',
  'にょ',
];
const TARGET_KANA_M = ['ま', 'み', 'む', 'め', 'も', 'みゃ', 'みゅ', 'みょ'];
const TARGET_KANA_H_F_B = [
  'は',
  'ひ',
  'ふ',
  'へ',
  'ほ',
  'ば',
  'び',
  'ぶ',
  'べ',
  'ぼ',
  'ひゃ',
  'ひゅ',
  'ひょ',
  'びゃ',
  'びゅ',
  'びょ',
];
const TARGET_KANA_Y_VOWEL = ['や', 'ゆ', 'よ', 'い', 'え'];
const TARGET_KANA_SH_CH = ['し', 'しゃ', 'しゅ', 'しょ', 'ち', 'ちゃ', 'ちゅ', 'ちょ'];
const TARGET_KANA_S_SH = ['さ', 'し', 'す', 'せ', 'そ', 'しゃ', 'しゅ', 'しょ'];
const TARGET_KANA_T_D = ['た', 'ち', 'つ', 'て', 'と', 'だ', 'ぢ', 'づ', 'で', 'ど'];
const TARGET_KANA_B_M_VOWEL = [
  'ば',
  'び',
  'ぶ',
  'べ',
  'ぼ',
  'ま',
  'み',
  'む',
  'め',
  'も',
  'あ',
  'い',
  'う',
  'え',
  'お',
];
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

const RULE_SPECS = [
  {
    ruleId: RULE1_ID,
    legacyId: RULE1_LEGACY_ID,
    section: '1',
    category: 'initial',
    title: 'Âm đầu là H/K/Gi/C/Qu',
    consonants: ['H', 'K', 'Gi', 'C', 'Qu'],
    targetRow: 'K/G',
    targetKana: TARGET_KANA_K_G,
    percentage: 90,
    explanation:
      "Phụ âm đầu Hán-Việt H/K/Gi/C/Qu thường chuyển sang hàng K/G trong On'yomi.",
    priorityKanji: ['校', '学', '行', '会', '何', '国', '海', '工'],
  },
  {
    ruleId: 'rule_initial_t_th_to_t_s_sh',
    legacyId: 'initial-t-th-to-t-s',
    section: '2',
    category: 'initial',
    title: 'Âm đầu là T/Th',
    consonants: ['T', 'Th'],
    targetRow: 'T/S/SH',
    targetKana: TARGET_KANA_T_S_SH,
    percentage: 70,
    explanation:
      "Phụ âm đầu Hán-Việt T/Th thường chuyển sang hàng T, S hoặc SH trong On'yomi.",
    priorityKanji: ['天', '心', '通', '体', '手', '田', '正', '社'],
  },
  {
    ruleId: 'rule_initial_ng_ngh_to_g_gy',
    legacyId: 'initial-ng-ngh-to-g-gy',
    section: '3',
    category: 'initial',
    title: 'Âm đầu là Ng/Ngh',
    consonants: ['Ng', 'Ngh'],
    targetRow: 'G/GY',
    targetKana: TARGET_KANA_G_GY,
    percentage: 84,
    explanation:
      "Phụ âm đầu Hán-Việt Ng/Ngh thường chuyển sang hàng G hoặc GY trong On'yomi.",
    priorityKanji: ['玉', '牛', '業', '語', '楽', '銀', '疑', '義'],
  },
  {
    ruleId: 'rule_initial_l_to_r',
    legacyId: 'initial-l-to-r',
    section: '4',
    category: 'initial',
    title: 'Âm đầu là L',
    consonants: ['L'],
    targetRow: 'R',
    targetKana: TARGET_KANA_R,
    percentage: 86,
    explanation:
      "Phụ âm đầu Hán-Việt L thường chuyển sang hàng R trong On'yomi.",
    priorityKanji: ['来', '力', '理', '料', '良', '林', '立', '流'],
  },
  {
    ruleId: 'rule_initial_n_nh_to_n_j_ny',
    legacyId: 'initial-n-nh-to-n-j',
    section: '5',
    category: 'initial',
    title: 'Âm đầu là N/Nh',
    consonants: ['N', 'Nh'],
    targetRow: 'N/J/NY',
    targetKana: TARGET_KANA_N_J_NY,
    percentage: 76,
    explanation:
      "Phụ âm đầu Hán-Việt N/Nh thường chuyển sang hàng N, J hoặc NY trong On'yomi.",
    priorityKanji: ['年', '日', '人', '入', '女', '肉', '熱', '任'],
  },
  {
    ruleId: 'rule_initial_m_to_m',
    legacyId: 'initial-m-to-m',
    section: '6',
    category: 'initial',
    title: 'Âm đầu là M',
    consonants: ['M'],
    targetRow: 'M',
    targetKana: TARGET_KANA_M,
    percentage: 84,
    explanation:
      "Phụ âm đầu Hán-Việt M thường chuyển sang hàng M trong On'yomi.",
    priorityKanji: ['木', '目', '門', '明', '命', '毛', '面', '務'],
  },
  {
    ruleId: 'rule_initial_b_ph_to_h_f_b',
    legacyId: 'initial-b-ph-to-h-f',
    section: '7',
    category: 'initial',
    title: 'Âm đầu là B/Ph',
    consonants: ['B', 'Ph'],
    targetRow: 'H/F/B',
    targetKana: TARGET_KANA_H_F_B,
    percentage: 72,
    explanation:
      "Phụ âm đầu Hán-Việt B/Ph thường chuyển sang hàng H/F hoặc B trong On'yomi.",
    priorityKanji: ['不', '分', '父', '風', '白', '百', '半', '反'],
  },
  {
    ruleId: 'rule_initial_d_gi_to_y',
    legacyId: 'initial-d-to-y',
    section: '8',
    category: 'initial',
    title: 'Âm đầu là D/Gi',
    consonants: ['D', 'Gi'],
    targetRow: 'Y/nguyên âm',
    targetKana: TARGET_KANA_Y_VOWEL,
    percentage: 63,
    explanation:
      "Một nhóm âm đầu Hán-Việt D/Gi chuyển sang hàng Y hoặc mở bằng nguyên âm trong On'yomi.",
    priorityKanji: ['用', '夜', '由', '友', '油', '曜', '様', '要'],
  },
  {
    ruleId: 'rule_initial_ch_tr_to_sh_ch',
    legacyId: 'initial-ch-tr-to-sh-ch',
    section: '9',
    category: 'initial',
    title: 'Âm đầu là Ch/Tr',
    consonants: ['Ch', 'Tr'],
    targetRow: 'SH/CH',
    targetKana: TARGET_KANA_SH_CH,
    percentage: 68,
    explanation:
      "Phụ âm đầu Hán-Việt Ch/Tr thường chuyển sang hàng SH hoặc CH trong On'yomi.",
    priorityKanji: ['中', '長', '直', '主', '正', '者', '茶', '注'],
  },
  {
    ruleId: 'rule_initial_s_x_to_s_sh',
    legacyId: 'initial-s-x-to-s-sh',
    section: '10',
    category: 'initial',
    title: 'Âm đầu là S/X',
    consonants: ['S', 'X'],
    targetRow: 'S/SH',
    targetKana: TARGET_KANA_S_SH,
    percentage: 70,
    explanation:
      "Phụ âm đầu Hán-Việt S/X thường chuyển sang hàng S hoặc SH trong On'yomi.",
    priorityKanji: ['山', '産', '色', '察', '散', '殺', '算', '想'],
  },
  {
    ruleId: 'rule_initial_d_with_stroke_to_t_d',
    legacyId: 'initial-d-with-stroke-to-t-d',
    section: '11',
    category: 'initial',
    title: 'Âm đầu là Đ',
    consonants: ['Đ'],
    targetRow: 'T/D',
    targetKana: TARGET_KANA_T_D,
    percentage: 78,
    explanation:
      "Phụ âm đầu Hán-Việt Đ thường chuyển sang hàng T hoặc D trong On'yomi.",
    priorityKanji: ['大', '同', '道', '電', '動', '東', '特', '弟'],
  },
  {
    ruleId: 'rule_initial_v_to_b_m_vowel',
    legacyId: 'initial-v-to-b-m',
    section: '12',
    category: 'initial',
    title: 'Âm đầu là V',
    consonants: ['V'],
    targetRow: 'B/M/nguyên âm',
    targetKana: TARGET_KANA_B_M_VOWEL,
    percentage: 62,
    explanation:
      "Âm đầu Hán-Việt V thường chuyển sang hàng B, M hoặc mở bằng nguyên âm trong On'yomi.",
    priorityKanji: ['文', '物', '万', '無', '味', '未', '院', '員'],
  },
  {
    ruleId: 'rule_final_n_m_to_n',
    legacyId: 'final-n-m-to-n',
    section: '13',
    category: 'final',
    title: 'Âm cuối là -n/-m',
    consonants: [],
    targetRow: 'N',
    targetKana: ['ん'],
    hanVietEndings: ['n', 'm'],
    onyomiEndings: ['ん'],
    percentage: 88,
    explanation:
      "Âm cuối Hán-Việt -n/-m thường khép bằng âm ん trong On'yomi.",
    priorityKanji: ['山', '三', '今', '金', '本', '南', '林', '心'],
  },
  {
    ruleId: 'rule_final_c_to_ku',
    legacyId: 'final-c-to-ku',
    section: '14',
    category: 'final',
    title: 'Âm cuối là -c',
    consonants: [],
    targetRow: 'KU/KI',
    targetKana: ['く', 'き'],
    hanVietEndings: ['c'],
    onyomiEndings: ['く', 'き'],
    percentage: 76,
    explanation:
      "Âm cuối Hán-Việt -c thường chuyển thành -ku hoặc -ki trong On'yomi.",
    priorityKanji: ['学', '国', '北', '白', '力', '直', '特', '職'],
  },
  {
    ruleId: 'rule_final_t_to_tsu_chi',
    legacyId: 'final-t-to-tsu-chi',
    section: '15',
    category: 'final',
    title: 'Âm cuối là -t',
    consonants: [],
    targetRow: 'TSU/CHI',
    targetKana: ['つ', 'ち'],
    hanVietEndings: ['t'],
    onyomiEndings: ['つ', 'ち'],
    percentage: 74,
    explanation:
      "Âm cuối Hán-Việt -t thường chuyển thành -tsu hoặc -chi trong On'yomi.",
    priorityKanji: ['日', '一', '七', '八', '月', '立', '出', '室'],
  },
  {
    ruleId: 'rule_final_p_to_long_or_tsu',
    legacyId: 'final-p-to-long-or-tsu',
    section: '16',
    category: 'final',
    title: 'Âm cuối là -p',
    consonants: [],
    targetRow: 'OU/UU/TSU',
    targetKana: ['う', 'つ'],
    hanVietEndings: ['p'],
    onyomiEndings: ['う', 'つ'],
    percentage: 62,
    explanation:
      "Âm cuối Hán-Việt -p thường rơi vào trường âm hoặc -tsu trong On'yomi.",
    priorityKanji: ['十', '入', '立', '急', '集', '接', '答', '雑'],
  },
  {
    ruleId: 'rule_final_ch_to_ku_ki',
    legacyId: 'final-ch-to-ku-ki',
    section: '17',
    category: 'final',
    title: 'Âm cuối là -ch',
    consonants: [],
    targetRow: 'KU/KI',
    targetKana: ['く', 'き'],
    hanVietEndings: ['ch'],
    onyomiEndings: ['く', 'き'],
    percentage: 66,
    explanation:
      "Âm cuối Hán-Việt -ch thường chuyển thành -ku hoặc -ki trong On'yomi.",
    priorityKanji: ['百', '石', '赤', '昔', '責', '席', '尺', '逆'],
  },
  {
    ruleId: 'rule_rime_inh_anh_enh_to_ei',
    legacyId: 'rime-inh-anh-enh-to-ei',
    section: '18',
    category: 'rime',
    title: 'Vần -inh/-anh/-ênh',
    consonants: [],
    targetRow: 'EI',
    targetKana: ['い'],
    hanVietEndings: ['inh', 'anh', 'enh'],
    onyomiEndings: ['い'],
    percentage: 70,
    explanation:
      "Các vần Hán-Việt -inh/-anh/-ênh thường đi với nhịp -ei trong On'yomi.",
    priorityKanji: ['生', '成', '名', '明', '平', '正', '声', '英'],
  },
  {
    ruleId: 'rule_rime_ien_iem_yen_to_en',
    legacyId: 'rime-ien-iem-yen-to-en',
    section: '19',
    category: 'rime',
    title: 'Vần -iên/-iêm/-yên',
    consonants: [],
    targetRow: 'EN',
    targetKana: ['ん'],
    hanVietEndings: ['ien', 'iem', 'yen'],
    onyomiEndings: ['ん'],
    percentage: 68,
    explanation:
      "Các vần Hán-Việt -iên/-iêm/-yên thường chuyển về âm -en trong On'yomi.",
    priorityKanji: ['先', '天', '店', '電', '線', '点', '面', '変'],
  },
  {
    ruleId: 'rule_rime_ong_ung_uong_to_ou_uu',
    legacyId: 'rime-ong-ung-uong-to-ou-uu',
    section: '20',
    category: 'rime',
    title: 'Vần -ông/-ung/-ương',
    consonants: [],
    targetRow: 'OU/UU/YOU',
    targetKana: ['う'],
    hanVietEndings: ['ong', 'ung', 'uong'],
    onyomiEndings: ['う'],
    percentage: 72,
    explanation:
      "Các vần Hán-Việt -ông/-ung/-ương thường chuyển sang âm dài ou/uu/you trong On'yomi.",
    priorityKanji: ['校', '公', '工', '通', '同', '動', '強', '用'],
  },
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
  const rawSyllable = firstSyllable(value).toLowerCase().trim();
  if (rawSyllable.startsWith('đ')) return 'đ';
  const normalized = normalizeVietnamese(rawSyllable);
  for (const initial of INITIALS) {
    if (initial === 'đ') continue;
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

function kanjiPriority(spec, kanji) {
  const order = spec.priorityKanji || [];
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

function buildPracticeItems(ruleId, spec, candidates, allEntries) {
  return candidates.slice(6, 11).map((entry, index) => {
    const options = rotateOptions(entry.onyomi, optionPoolFor(entry, allEntries), index);
    const initial = firstConsonant(entry.hanViet).toUpperCase();
    const explanation = spec.hanVietEndings?.length
      ? `${entry.hanViet} có âm cuối ${spec.hanVietEndings.join(
          '/',
        )}; mẫu Hán-Việt này thường về ${spec.targetRow} trong On'yomi.`
      : `${entry.hanViet} bắt đầu bằng ${initial}; nhóm Hán-Việt này thường về hàng ${spec.targetRow} trong On'yomi.`;
    return {
      itemId: `${ruleId}_${entry.kanji}`,
      kanji: entry.kanji,
      kanjiId: entry.orderId,
      assetKanjiId: entry.assetKanjiId,
      hanViet: entry.hanViet,
      correct: entry.onyomi,
      options,
      explanation,
    };
  });
}

function normalizeRuleConsonant(value) {
  const raw = String(value || '').trim();
  return normalizeVietnamese(raw).replace(
    /^d$/,
    raw.toLowerCase() === 'đ' ? 'đ' : 'd',
  );
}

function matchesRuleSpec(entry, spec) {
  if (spec.hanVietEndings?.length && spec.onyomiEndings?.length) {
    const syllable = normalizeVietnamese(firstSyllable(entry.hanViet));
    return (
      spec.hanVietEndings.some((ending) => syllable.endsWith(ending)) &&
      spec.onyomiEndings.some((ending) => entry.onyomi.endsWith(ending))
    );
  }
  const allowedConsonants = spec.consonants.map(normalizeRuleConsonant);
  return (
    allowedConsonants.includes(normalizeRuleConsonant(entry.consonant)) &&
    spec.targetKana.some((kana) => entry.onyomi.startsWith(kana))
  );
}

function distinctSortedCandidates(spec, entries) {
  const seen = new Set();
  return entries
    .filter((entry) => matchesRuleSpec(entry, spec))
    .filter((entry) => {
      if (seen.has(entry.kanji)) return false;
      seen.add(entry.kanji);
      return true;
    })
    .sort((a, b) => {
      const byPriority = kanjiPriority(spec, a.kanji) - kanjiPriority(spec, b.kanji);
      if (byPriority !== 0) return byPriority;
      const byLevel = levelRank(a.level) - levelRank(b.level);
      if (byLevel !== 0) return byLevel;
      const byCompound = Number(Boolean(b.compoundKana)) - Number(Boolean(a.compoundKana));
      if (byCompound !== 0) return byCompound;
      const byStroke = a.strokeCount - b.strokeCount;
      if (byStroke !== 0) return byStroke;
      return a.kanji.localeCompare(b.kanji);
    });
}

function buildRuleV2(spec, legacyRule, entries) {
  const candidates = distinctSortedCandidates(spec, entries);
  const examples = candidates.slice(0, 6).map(toExample);
  return {
    ruleId: spec.ruleId,
    legacyId: spec.legacyId,
    section: spec.section,
    parentSection: spec.parentSection || null,
    category: spec.category,
    title: spec.title,
    consonants: spec.consonants,
    targetRow: spec.targetRow,
    targetKana: spec.targetKana,
    percentage: spec.percentage,
    explanation: spec.explanation,
    legacyConfidence: legacyRule?.confidence || null,
    examples,
    subRuleIds: spec.subRuleIds || [],
    practice: {
      count: 5,
      questionTemplate:
        "Âm Hán-Việt {hanViet} ({kanji}) -> On'yomi nào?",
      status: candidates.length >= 11 ? 'ready' : 'reference_only',
      items: buildPracticeItems(spec.ruleId, spec, candidates, entries),
    },
  };
}

function generateHanVietRulesV2({ rootDir = process.cwd() } = {}) {
  const legacy = readJson(
    path.join(rootDir, 'assets/data/content/kanji/han_viet_on_rules.json'),
  );
  const entries = loadKanjiEntries(rootDir);
  const legacyById = new Map(legacy.rules.map((rule) => [rule.id, rule]));
  return {
    schemaVersion: 2,
    dataset: 'han_viet_on_rules_v2',
    generatedAt: '2026-05-20',
    sourcePolicy: {
      blockedDomainsExcludedCount: 2,
      note:
        'Generated from local app kanji/vocab assets and owner-provided local files only; owner-blocked crawl sources are excluded.',
    },
    rules: RULE_SPECS.map((spec) =>
      buildRuleV2(spec, legacyById.get(spec.legacyId), entries),
    ),
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
