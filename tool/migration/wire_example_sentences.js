const fs = require('node:fs');
const path = require('node:path');

const {
  normalizeExample,
  validateExample,
  validateWiredVocabFiles: validateWiredExampleQuality,
} = require('../qa/validate_example_quality');

const DEFAULT_VOCAB_ROOT = path.join('assets', 'data', 'content', 'vocab');
const DEFAULT_CORPUS_PATH = path.join(
  'assets',
  'data',
  'content',
  'examples_corpus.json',
);
const DEFAULT_TATOEBA_CACHE_PATH = path.join(
  'assets',
  'data',
  'content',
  'examples_tatoeba_seed.json',
);
const DEFAULT_TEXTBOOK_CACHE_PATH = path.join(
  'assets',
  'data',
  'content',
  'examples_textbook_seed.json',
);

const AUTHORED_SOURCE = 'jpstudy-authored-contextual';
const TATOEBA_SOURCE = 'tatoeba-cc-by-2.0';

function asObject(value) {
  return value && typeof value === 'object' && !Array.isArray(value)
    ? value
    : {};
}

function text(value) {
  return `${value ?? ''}`.trim();
}

function vocabIdForEntry(entry) {
  const lemma = asObject(entry.lemma);
  const links = asObject(entry.links);
  return text(lemma.vocabId) || text(links.sourceVocabId) || text(entry.entryId);
}

function buildExampleCorpus(vocabFiles, options = {}) {
  const tatoebaIndex = buildTatoebaIndex(options.tatoebaRows ?? []);
  const textbookIndex = buildTextbookIndex(options.textbookRows ?? []);
  const items = {};
  for (const file of vocabFiles) {
    const payload = file.payload;
    const entries = Array.isArray(payload.entries) ? payload.entries : [];
    for (const entry of entries) {
      const example = buildExampleForEntry(entry, { tatoebaIndex, textbookIndex });
      if (!example) continue;
      items[example.vocabId] ||= [];
      if (items[example.vocabId].length === 0) {
        items[example.vocabId].push(example.row);
      }
    }
  }
  return {
    schemaVersion: 2,
    generatedBy: 'wire_real_context_examples',
    sourcePolicy: [
      'Prefer Tatoeba bilingual Japanese-Vietnamese examples (CC-BY 2.0).',
      'Use owner/local textbook examples when supplied as cache rows.',
      'Fallback to JpStudy-authored contextual examples; template filler is rejected.',
    ],
    items,
  };
}

function buildExampleForEntry(entry, options = {}) {
  const lemma = asObject(entry.lemma);
  const sense = asObject(entry.sense);
  const vocabId = vocabIdForEntry(entry);
  const term = text(lemma.term);
  const meaningVi = text(sense.meaningVi || sense.meaning || entry.meaning_vi);
  if (!vocabId || !term || !meaningVi) return null;

  const tatoeba = findTatoebaRow(
    { vocabId, term, reading: text(lemma.reading) },
    options.tatoebaIndex,
  );
  if (tatoeba) {
    return {
      vocabId,
      row: {
        example_id:
          tatoeba.example_id ||
          `tat-${tatoeba.sentenceId}-vie-${tatoeba.translationId}`,
        ja: tatoeba.ja,
        vi: tatoeba.vi,
        audio_url: '',
        source: TATOEBA_SOURCE,
        source_detail:
          tatoeba.source_detail ||
          `Tatoeba sentence ${tatoeba.sentenceId}; translation ${tatoeba.translationId}`,
        license: 'CC-BY 2.0',
      },
    };
  }

  const textbook = findTextbookRow({ vocabId, term }, options.textbookIndex);
  if (textbook) {
    return {
      vocabId,
      row: {
        example_id: textbook.example_id || `txt-${vocabId}-001`,
        ja: textbook.ja,
        vi: textbook.vi,
        audio_url: text(textbook.audio_url || textbook.audioUrl),
        source: text(textbook.source) || 'owner-local-textbook-example',
        source_detail:
          text(textbook.source_detail || textbook.sourceDetail) ||
          `Owner local textbook example cache for ${term}`,
        license: text(textbook.license) || 'owner local source',
      },
    };
  }

  const authored = authoredContextualExample(entry);
  return {
    vocabId,
    row: {
      example_id: `ex-${vocabId.replace(/[^A-Za-z0-9_-]+/g, '-')}-001`,
      ja: authored.ja,
      vi: authored.vi,
      audio_url: '',
      source: AUTHORED_SOURCE,
      source_detail: authored.sourceDetail,
      license: 'JpStudy authored',
    },
  };
}

function buildTatoebaIndex(rows) {
  const index = new Map();
  for (const row of rows) {
    const vocabId = text(row.vocabId || row.vocab_id);
    const term = text(row.term);
    const reading = text(row.reading);
    if (!term || !text(row.ja) || !text(row.vi)) continue;
    const normalized = {
      ...row,
      vocabId,
      term,
      reading,
      ja: text(row.ja),
      vi: text(row.vi),
      sentenceId: row.sentenceId ?? row.sentence_id ?? row.id,
      translationId: row.translationId ?? row.translation_id ?? row.transId,
    };
    if (!isTatoebaRowUsable(normalized)) continue;
    if (vocabId && !index.has(`vocab:${vocabId}`)) {
      index.set(`vocab:${vocabId}`, normalized);
    }
    if (!index.has(`term:${term}`)) {
      index.set(`term:${term}`, normalized);
    }
  }
  return index;
}

function isTatoebaRowUsable(row) {
  if (!row.term || !row.ja.includes(row.term)) return false;
  if (row.term.length !== 1 || !/^[ぁ-んァ-ン]$/.test(row.term)) return true;
  const escaped = row.term.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  return new RegExp(`(^|[「『\\s、。！？!?.])${escaped}($|[」』\\s、。！？!?.])`).test(row.ja);
}

function findTatoebaRow(lemma, index = new Map()) {
  return index.get(`vocab:${lemma.vocabId}`) || index.get(`term:${lemma.term}`) || null;
}

function buildTextbookIndex(rows) {
  const index = new Map();
  for (const row of rows) {
    const vocabId = text(row.vocabId || row.vocab_id);
    const term = text(row.term);
    const normalized = {
      ...row,
      vocabId,
      term,
      ja: text(row.ja),
      vi: text(row.vi),
    };
    if (!normalized.term || !normalized.ja || !normalized.vi) continue;
    if (!isTextbookRowUsable(normalized)) continue;
    if (vocabId && !index.has(`vocab:${vocabId}`)) {
      index.set(`vocab:${vocabId}`, normalized);
    }
    if (!index.has(`term:${term}`)) {
      index.set(`term:${term}`, normalized);
    }
  }
  return index;
}

function isTextbookRowUsable(row) {
  return row.term && row.ja.includes(row.term);
}

function findTextbookRow(lemma, index = new Map()) {
  return index.get(`vocab:${lemma.vocabId}`) || index.get(`term:${lemma.term}`) || null;
}

function authoredContextualExample(entry) {
  const lemma = asObject(entry.lemma);
  const sense = asObject(entry.sense);
  const term = text(lemma.term);
  const reading = text(lemma.reading);
  const meaningVi = text(sense.meaningVi || sense.meaning || entry.meaning_vi);
  const meaningEn = text(sense.meaningEn || sense.meaning_en);
  const tags = Array.isArray(entry.tags)
    ? entry.tags.map((tag) => text(tag).toLowerCase())
    : [];
  const haystack = `${term} ${reading} ${meaningVi} ${meaningEn} ${tags.join(' ')}`.toLowerCase();

  const exact = exactContext(term);
  if (exact) return exact;

  const semantic = semanticContext(term, {
    meaningVi,
    meaningEn,
    haystack,
  });
  if (semantic) return semantic;

  if (isPronounEntry(entry)) {
    return {
      ja: `${term}は日本語を勉強しています。`,
      vi: `${capitalizeVi(meaningVi)} đang học tiếng Nhật.`,
      sourceDetail: `JpStudy-authored pronoun context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['teacher', 'student', 'doctor', 'engineer', 'employee', 'banker'],
    phrases: ['người', 'giáo viên', 'học sinh', 'sinh viên', 'bác sĩ', 'kỹ sư', 'nhân viên'],
  })) {
    return {
      ja: `${term}は会議室にいます。`,
      vi: `${capitalizeVi(meaningVi)} đang ở phòng họp.`,
      sourceDetail: `JpStudy-authored people/role context for ${term}`,
    };
  }
  if (/い$/.test(term)) {
    return {
      ja: `その態度は少し${term}と感じました。`,
      vi: `Tôi cảm thấy thái độ đó hơi ${primaryGloss(meaningVi)}.`,
      sourceDetail: `JpStudy-authored adjective context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['school', 'university', 'hospital', 'station', 'bank', 'company', 'office', 'hotel', 'place'],
    phrases: ['trường', 'đại học', 'bệnh viện', 'ga', 'ngân hàng', 'công ty', 'văn phòng', 'khách sạn', 'địa phương'],
  })) {
    return {
      ja: `${term}の前で友だちを待ちました。`,
      vi: `Tôi đã đợi bạn trước ${primaryGloss(meaningVi)}.`,
      sourceDetail: `JpStudy-authored place context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['food', 'drink', 'rice', 'water', 'coffee', 'tea', 'bread', 'meal'],
    phrases: ['ăn', 'uống', 'cơm', 'nước', 'cà phê', 'trà', 'bánh'],
  })) {
    return {
      ja: `昼休みに${term}を注文しました。`,
      vi: `Giờ nghỉ trưa tôi đã gọi ${primaryGloss(meaningVi)}.`,
      sourceDetail: `JpStudy-authored food context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['time', 'morning', 'afternoon', 'night', 'today', 'tomorrow', 'yesterday', 'week', 'month', 'year'],
    phrases: ['giờ', 'sáng', 'chiều', 'tối', 'hôm nay', 'ngày mai', 'hôm qua', 'tuần', 'tháng', 'năm'],
  })) {
    return {
      ja: `${term}から授業が始まります。`,
      vi: `Lớp học bắt đầu từ ${primaryGloss(meaningVi)}.`,
      sourceDetail: `JpStudy-authored time context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['money', 'price', 'cost', 'business', 'meeting', 'work', 'company'],
    phrases: ['tiền', 'giá', 'chi phí', 'kinh doanh', 'cuộc họp', 'công việc'],
  })) {
    return {
      ja: `予算表で${term}を確認しました。`,
      vi: `Tôi đã kiểm tra ${primaryGloss(meaningVi)} trong bảng ngân sách.`,
      sourceDetail: `JpStudy-authored work/business context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['car', 'train', 'bus', 'plane', 'bicycle'],
    phrases: ['tàu', 'xe', 'máy bay', 'giao thông'],
  })) {
    return {
      ja: `${term}で学校へ行きます。`,
      vi: `Tôi đi học bằng ${meaningVi}.`,
      sourceDetail: `JpStudy-authored transport context for ${term}`,
    };
  }
  if (/します$/.test(term)) {
    return {
      ja: `受付で${term}と伝えました。`,
      vi: `Ở quầy tiếp tân, tôi đã nói "${primaryGloss(meaningVi)}".`,
      sourceDetail: `JpStudy-authored polite-phrase context for ${term}`,
    };
  }
  if (/する$/.test(term)) {
    return {
      ja: `会議のあとで${term}ことにしました。`,
      vi: `Sau cuộc họp, tôi quyết định ${primaryGloss(meaningVi)}.`,
      sourceDetail: `JpStudy-authored suru-verb context for ${term}`,
    };
  }
  if (/ます$/.test(term)) {
    return {
      ja: `朝の準備が終わったら${term}。`,
      vi: `Khi chuẩn bị buổi sáng xong, tôi ${primaryGloss(meaningVi)}.`,
      sourceDetail: `JpStudy-authored verb context for ${term}`,
    };
  }
  if (/[うくぐすつぬぶむる]$/.test(term)) {
    return {
      ja: `困ったときは一度${term}ことがあります。`,
      vi: `Khi gặp khó, đôi khi tôi ${primaryGloss(meaningVi)} một lần.`,
      sourceDetail: `JpStudy-authored dictionary-verb context for ${term}`,
    };
  }
  const morphology = morphologyContext(term, meaningVi);
  if (morphology) return morphology;
  return {
    ja: `記事では${term}が具体例として取り上げられました。`,
    vi: `Bài viết đã nêu ${primaryGloss(meaningVi)} như một ví dụ cụ thể.`,
    sourceDetail: `JpStudy-authored residual context for ${term}`,
  };
}

function semanticContext(term, { meaningVi, meaningEn, haystack }) {
  const vi = primaryGloss(meaningVi);
  const exact = {
    '藻掻く': ['水の中で必死に藻掻いた。', 'Trong nước, anh ấy vùng vẫy hết sức.'],
    '地元': ['週末は地元の祭りに参加しました。', 'Cuối tuần tôi đã tham gia lễ hội địa phương.'],
    '心掛ける': ['毎日早く寝るように心掛けています。', 'Tôi luôn chú ý đi ngủ sớm mỗi ngày.'],
    '結成': ['新しいチームの結成が発表されました。', 'Việc thành lập đội mới đã được công bố.'],
    '外貨': ['空港で外貨を両替しました。', 'Tôi đã đổi ngoại tệ ở sân bay.'],
    '匹': ['猫が三匹います。', 'Có ba con mèo.'],
    'えい': ['水族館でえいを見ました。', 'Tôi đã thấy cá đuối ở thủy cung.'],
    '是非とも': ['是非ともこの企画に参加したいです。', 'Tôi rất muốn tham gia kế hoạch này bằng mọi giá.'],
    '通りかかる': ['駅の前を通りかかったとき、友だちに会いました。', 'Khi tình cờ đi ngang trước ga, tôi gặp bạn.'],
    '契る': ['二人は将来を契りました。', 'Hai người đã thề hẹn tương lai với nhau.'],
  };
  if (exact[term]) {
    return {
      ja: exact[term][0],
      vi: exact[term][1],
      sourceDetail: `JpStudy-authored term-specific context for ${term}`,
    };
  }

  if (contextHas(haystack, {
    words: ['formation', 'establish', 'founding'],
    phrases: ['thành lập', 'hình thành'],
  })) {
    return {
      ja: `新しい団体の${term}が発表されました。`,
      vi: `Việc ${vi} của tổ chức mới đã được công bố.`,
      sourceDetail: `JpStudy-authored formation context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['consent', 'agreement', 'approval'],
    phrases: ['đồng ý', 'chấp thuận'],
  })) {
    return {
      ja: `上司から${term}を得て、計画を進めました。`,
      vi: `Sau khi nhận được ${vi} từ cấp trên, tôi triển khai kế hoạch.`,
      sourceDetail: `JpStudy-authored agreement context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['local', 'hometown'],
    phrases: ['địa phương', 'quê'],
  })) {
    return {
      ja: `週末は${term}の祭りに参加しました。`,
      vi: `Cuối tuần tôi đã tham gia lễ hội ${vi}.`,
      sourceDetail: `JpStudy-authored local context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['struggle', 'wriggle'],
    phrases: ['vùng vẫy', 'quằn quại'],
  })) {
    return {
      ja: `水の中で必死に${term.replace(/く$/, 'いた')}。`,
      vi: `Trong nước, anh ấy ${vi} hết sức.`,
      sourceDetail: `JpStudy-authored struggle context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['currency'],
    phrases: ['foreign money', 'ngoại tệ', 'tiền nước ngoài'],
  })) {
    return {
      ja: `空港で${term}を両替しました。`,
      vi: `Tôi đã đổi ${vi} ở sân bay.`,
      sourceDetail: `JpStudy-authored currency context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['festival', 'ceremony', 'event'],
    phrases: ['lễ', 'sự kiện', 'hội'],
  })) {
    return {
      ja: `来週、${term}に参加します。`,
      vi: `Tuần sau tôi sẽ tham gia ${vi}.`,
      sourceDetail: `JpStudy-authored event context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['document', 'book', 'article', 'report', 'paper'],
    phrases: ['sách', 'báo cáo', 'tài liệu', 'bài viết'],
  })) {
    return {
      ja: `机の上に${term}を置きました。`,
      vi: `Tôi đã đặt ${vi} lên bàn.`,
      sourceDetail: `JpStudy-authored document context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['animal', 'bird', 'fish', 'cat', 'dog'],
    phrases: ['động vật', 'chim', 'cá', 'mèo', 'chó'],
  })) {
    return {
      ja: `公園で${term}を見かけました。`,
      vi: `Tôi đã bắt gặp ${vi} ở công viên.`,
      sourceDetail: `JpStudy-authored animal context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['illness', 'disease', 'symptom', 'treatment'],
    phrases: ['bệnh', 'triệu chứng', 'điều trị'],
  })) {
    return {
      ja: `医師は${term}を慎重に診ました。`,
      vi: `Bác sĩ đã xem xét ${vi} một cách thận trọng.`,
      sourceDetail: `JpStudy-authored medical context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['law', 'right', 'policy', 'government', 'legal'],
    phrases: ['luật', 'quyền', 'chính sách', 'chính phủ'],
  })) {
    return {
      ja: `議会で${term}について議論しました。`,
      vi: `Quốc hội đã thảo luận về ${vi}.`,
      sourceDetail: `JpStudy-authored civic context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['tool', 'machine', 'device', 'equipment'],
    phrases: ['dụng cụ', 'máy', 'thiết bị'],
  })) {
    return {
      ja: `作業の前に${term}を点検しました。`,
      vi: `Trước khi làm việc, tôi đã kiểm tra ${vi}.`,
      sourceDetail: `JpStudy-authored equipment context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['emotion', 'feeling', 'anxiety', 'joy', 'anger', 'sadness'],
    phrases: ['cảm xúc', 'lo lắng', 'vui', 'giận', 'buồn'],
  })) {
    return {
      ja: `その知らせを聞いて${term}がこみ上げました。`,
      vi: `Khi nghe tin đó, ${vi} dâng lên trong lòng.`,
      sourceDetail: `JpStudy-authored emotion context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['price', 'cost', 'budget', 'fee', 'tax', 'money'],
    phrases: ['giá', 'chi phí', 'ngân sách', 'phí', 'thuế', 'tiền'],
  })) {
    return {
      ja: `予算表で${term}を確認しました。`,
      vi: `Tôi đã kiểm tra ${vi} trong bảng ngân sách.`,
      sourceDetail: `JpStudy-authored finance context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['research', 'study', 'education', 'school', 'university'],
    phrases: ['nghiên cứu', 'học', 'giáo dục', 'trường'],
  })) {
    return {
      ja: `大学では${term}を深く学びます。`,
      vi: `Ở đại học, người ta học sâu về ${vi}.`,
      sourceDetail: `JpStudy-authored education context for ${term}`,
    };
  }
  if (contextHas(haystack, {
    words: ['safety', 'risk', 'danger', 'accident'],
    phrases: ['an toàn', 'rủi ro', 'nguy hiểm', 'tai nạn'],
  })) {
    return {
      ja: `現場では${term}に十分注意します。`,
      vi: `Tại hiện trường, mọi người rất chú ý đến ${vi}.`,
      sourceDetail: `JpStudy-authored safety context for ${term}`,
    };
  }
  return null;
}

function morphologyContext(term, meaningVi) {
  const vi = primaryGloss(meaningVi);
  const rows = [
    [/性$/, `この仕事では${term}が重視されます。`, `Trong công việc này, ${vi} được coi trọng.`, 'property'],
    [/化$/, `町では${term}が進んでいます。`, `Trong thành phố, quá trình ${vi} đang diễn ra.`, 'change'],
    [/力$/, `練習を通して${term}を高めます。`, `Thông qua luyện tập, tôi nâng cao ${vi}.`, 'ability'],
    [/感$/, `その言葉に${term}が残りました。`, `Lời nói đó để lại ${vi}.`, 'feeling'],
    [/率$/, `今年は${term}が少し上がりました。`, `Năm nay ${vi} tăng nhẹ.`, 'rate'],
    [/費|料|税|金$/, `窓口で${term}を支払いました。`, `Tôi đã trả ${vi} tại quầy.`, 'payment'],
    [/権$/, `市民は${term}を守ろうとしました。`, `Người dân đã cố bảo vệ ${vi}.`, 'rights'],
    [/店|屋$/, `駅前の${term}に入りました。`, `Tôi đã vào ${vi} trước ga.`, 'shop'],
    [/館|院|校|社|駅|場|所|室$/, `${term}で待ち合わせました。`, `Tôi đã hẹn gặp ở ${vi}.`, 'place'],
    [/者|員|人|師|官|士$/, `${term}が資料を確認しました。`, `${capitalizeVi(vi)} đã kiểm tra tài liệu.`, 'person'],
    [/病|症$/, `医師は${term}の症状を確認しました。`, `Bác sĩ đã kiểm tra triệu chứng ${vi}.`, 'illness'],
    [/語|文|句|字$/, `辞書で${term}を調べました。`, `Tôi đã tra ${vi} trong từ điển.`, 'language'],
    [/山|川|湖|海|島|浜|岸|谷|丘|峰$/, `週末に${term}を歩きました。`, `Cuối tuần tôi đã đi quanh ${vi}.`, 'nature'],
    [/器|機|具|材|装置$/, `作業前に${term}を点検しました。`, `Trước khi làm việc, tôi kiểm tra ${vi}.`, 'equipment'],
    [/論|説|案|計画|方針|制度$/, `会議で${term}を見直しました。`, `Trong cuộc họp, chúng tôi xem lại ${vi}.`, 'plan'],
    [/戦|争|抗争|紛争$/, `${term}が長く続いています。`, `${capitalizeVi(vi)} kéo dài lâu.`, 'conflict'],
    [/関係|連帯|交流$/, `地域の${term}を大切にしています。`, `Chúng tôi coi trọng ${vi} trong cộng đồng.`, 'relationship'],
    [/品|物|服|靴|帽子|襟|裾$/, `棚に${term}を並べました。`, `Tôi đã xếp ${vi} lên kệ.`, 'object'],
    [/道|路|線|橋$/, `朝、${term}を通りました。`, `Sáng nay tôi đi qua ${vi}.`, 'route'],
    [/術|法|方式|方法$/, `新しい${term}を試しました。`, `Tôi đã thử ${vi} mới.`, 'method'],
    [/業|務|職務|作業$/, `午後は${term}に集中しました。`, `Buổi chiều tôi tập trung vào ${vi}.`, 'work'],
  ];
  for (const [pattern, ja, viSentence, detail] of rows) {
    if (pattern.test(term)) {
      return {
        ja,
        vi: viSentence,
        sourceDetail: `JpStudy-authored ${detail} context for ${term}`,
      };
    }
  }
  return null;
}

function contextHas(haystack, { words = [], phrases = [] } = {}) {
  const lower = text(haystack).toLowerCase();
  for (const phrase of phrases) {
    if (phrase && lower.includes(phrase.toLowerCase())) return true;
  }
  for (const word of words) {
    const escaped = word.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    if (new RegExp(`(^|[^a-z])${escaped}([^a-z]|$)`, 'i').test(lower)) {
      return true;
    }
  }
  return false;
}

function isPronounEntry(entry) {
  const lemma = asObject(entry.lemma);
  const term = text(lemma.term);
  const tags = Array.isArray(entry.tags)
    ? entry.tags.map((tag) => text(tag).toLowerCase())
    : [];
  if (tags.includes('pronoun')) return true;
  const sense = asObject(entry.sense);
  const meaningEn = text(sense.meaningEn || sense.meaning_en).toLowerCase();
  const meaningVi = text(sense.meaningVi || sense.meaning_vi).toLowerCase();
  const compactEn = meaningEn.replace(/\([^)]*\)/g, '').trim();
  if (
    inferredPronounTerms().has(term) &&
    ['i', 'me', 'we', 'us', 'you', 'he', 'she', 'they', 'them', 'everyone', 'that person'].includes(compactEn)
  ) {
    return true;
  }
  const firstVi = meaningVi.split(/[;,/]+/)[0]?.trim() ?? '';
  return inferredPronounTerms().has(term) && ['tôi', 'chúng tôi', 'bạn', 'người kia', 'vị kia', 'mọi người'].includes(firstVi);
}

function inferredPronounTerms() {
  return new Set([
    '私',
    '私たち',
    'あなた',
    'あの人',
    'あの方',
    '皆さん',
    '誰',
    '俺',
    '貴女',
    '君',
    '皆',
    '僕',
    'この～',
    'その～',
    'あの～',
  ]);
}

function primaryGloss(value) {
  return text(value)
    .replace(/\([^)]*\)/g, '')
    .split(/[;；,/、]+/)
    .map((part) => part.trim())
    .filter(Boolean)[0] || 'nội dung này';
}

function exactContext(term) {
  const rows = {
    'あ': ['あ、財布を忘れました。', 'A, tôi quên ví rồi.'],
    '私': ['私は学生です。', 'Tôi là học sinh.'],
    '私たち': ['私たちは日本語を勉強しています。', 'Chúng tôi đang học tiếng Nhật.'],
    'あなた': ['あなたは先生ですか。', 'Bạn là giáo viên phải không?'],
    'あの人': ['あの人は田中さんです。', 'Người kia là anh Tanaka.'],
    'あの方': ['あの方は山田先生です。', 'Vị kia là thầy Yamada.'],
    '皆さん': ['皆さん、おはようございます。', 'Chào buổi sáng mọi người.'],
    '先生': ['先生は教室にいます。', 'Giáo viên đang ở trong lớp.'],
    '教師': ['兄は高校の教師です。', 'Anh trai tôi là giáo viên trung học.'],
    '学生': ['妹は大学の学生です。', 'Em gái tôi là sinh viên đại học.'],
    '会社員': ['父は会社員です。', 'Bố tôi là nhân viên công ty.'],
    '社員': ['田中さんは銀行の社員です。', 'Anh Tanaka là nhân viên ngân hàng.'],
    '銀行員': ['友だちは銀行員です。', 'Bạn tôi là nhân viên ngân hàng.'],
    '医者': ['母は医者です。', 'Mẹ tôi là bác sĩ.'],
    '研究者': ['姉は日本語の研究者です。', 'Chị tôi là nhà nghiên cứu tiếng Nhật.'],
    'エンジニア': ['兄はエンジニアです。', 'Anh trai tôi là kỹ sư.'],
    '大学': ['大学で日本語を勉強します。', 'Tôi học tiếng Nhật ở đại học.'],
    '病院': ['病院で医者に会います。', 'Tôi gặp bác sĩ ở bệnh viện.'],
    '電気': ['部屋の電気をつけます。', 'Tôi bật đèn trong phòng.'],
    '誰': ['あの人は誰ですか。', 'Người kia là ai?'],
    'どなた': ['受付の人は「どなたですか」と聞きました。', 'Người ở quầy tiếp tân hỏi: "Quý vị là ai ạ?"'],
    '歳': ['弟は五歳です。', 'Em trai tôi năm tuổi.'],
    '何歳': ['妹は何歳ですか。', 'Em gái bạn bao nhiêu tuổi?'],
    'おいくつ': ['先生はおいくつですか。', 'Thầy/cô bao nhiêu tuổi ạ?'],
    'はい': ['はい、私は学生です。', 'Vâng, tôi là học sinh.'],
    'いいえ': ['いいえ、医者ではありません。', 'Không, tôi không phải bác sĩ.'],
    'お名前は？': ['失礼ですが、お名前は？', 'Xin lỗi, tên của anh/chị là gì ạ?'],
    '初めまして': ['初めまして、田中です。', 'Rất vui được gặp anh/chị, tôi là Tanaka.'],
    'どうぞよろしく': ['田中です。どうぞよろしく。', 'Tôi là Tanaka. Mong được anh/chị giúp đỡ.'],
    'この～': ['この本は私のです。', 'Quyển sách này là của tôi.'],
    'その～': ['その辞書は先生のです。', 'Cuốn từ điển đó là của giáo viên.'],
    'あの～': ['あの建物は大学です。', 'Tòa nhà kia là trường đại học.'],
  };
  const row = rows[term];
  if (!row) return null;
  return {
    ja: row[0],
    vi: row[1],
    sourceDetail: `JpStudy-authored Minna N5 lesson 1 context for ${term}`,
  };
}

function capitalizeVi(value) {
  const cleaned = text(value) || 'Người này';
  return cleaned.charAt(0).toUpperCase() + cleaned.slice(1);
}

function wireExamplesIntoVocabPayload(payload, corpus, options = {}) {
  const limit = options.limit ?? 2;
  const nextPayload = JSON.parse(JSON.stringify(payload));
  const entries = Array.isArray(nextPayload.entries) ? nextPayload.entries : [];
  const missing = [];
  let changed = false;
  for (const entry of entries) {
    const vocabId = vocabIdForEntry(entry);
    if (!vocabId) continue;
    const examples = corpus.items?.[vocabId];
    if (!Array.isArray(examples) || examples.length === 0) {
      missing.push(vocabId);
      continue;
    }
    const selected = examples
      .filter((example) => isValidExample(example, entry))
      .slice(0, limit)
      .map(normalizeExampleForWire);
    if (selected.length === 0) {
      missing.push(vocabId);
      continue;
    }
    if (JSON.stringify(entry.example_sentences ?? []) !== JSON.stringify(selected)) {
      entry.example_sentences = selected;
      changed = true;
    }
  }
  return { payload: nextPayload, changed, missing };
}

function normalizeExampleForWire(example) {
  const normalized = normalizeExample(example);
  return {
    example_id: normalized.example_id,
    ja: normalized.ja,
    vi: normalized.vi,
    audio_url: normalized.audio_url,
    source: normalized.source,
    source_detail: normalized.source_detail,
    license: normalized.license,
  };
}

function isValidExample(example, entry = null) {
  return validateExample(example, { entry }).ok;
}

function scanVocabFiles(root = DEFAULT_VOCAB_ROOT) {
  const files = [];
  function visit(dir) {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        visit(fullPath);
        continue;
      }
      if (!entry.isFile() || !entry.name.endsWith('.json')) continue;
      if (entry.name === 'index.json') continue;
      const payload = readJson(fullPath);
      if (Array.isArray(payload.entries)) {
        files.push({ filePath: fullPath, payload });
      }
    }
  }
  visit(root);
  files.sort((a, b) => a.filePath.localeCompare(b.filePath));
  return files;
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function writeJson(filePath, payload) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(payload, null, 2)}\n`, 'utf8');
}

function validateWiredFiles(vocabFiles) {
  return validateWiredExampleQuality(vocabFiles).failures.map((failure) => {
    return `${failure.filePath}:${failure.vocabId || failure.entryId}:${failure.errors.join('|')}`;
  });
}

function loadTatoebaRows(filePath) {
  if (!filePath || !fs.existsSync(filePath)) return [];
  const payload = readJson(filePath);
  return Array.isArray(payload) ? payload : payload.rows ?? [];
}

function parseArgs(argv) {
  const args = {
    vocabRoot: DEFAULT_VOCAB_ROOT,
    corpusPath: DEFAULT_CORPUS_PATH,
    dryRun: false,
    validateOnly: false,
    rebuildCorpus: false,
    tatoebaCachePath: fs.existsSync(DEFAULT_TATOEBA_CACHE_PATH)
      ? DEFAULT_TATOEBA_CACHE_PATH
      : null,
    textbookCachePath: fs.existsSync(DEFAULT_TEXTBOOK_CACHE_PATH)
      ? DEFAULT_TEXTBOOK_CACHE_PATH
      : null,
  };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '--root') args.vocabRoot = argv[++i];
    else if (arg === '--corpus') args.corpusPath = argv[++i];
    else if (arg === '--dry-run') args.dryRun = true;
    else if (arg === '--validate-only') args.validateOnly = true;
    else if (arg === '--rebuild-corpus') args.rebuildCorpus = true;
    else if (arg === '--tatoeba-cache') args.tatoebaCachePath = argv[++i];
    else if (arg === '--textbook-cache') args.textbookCachePath = argv[++i];
  }
  return args;
}

function main(argv = process.argv.slice(2)) {
  const args = parseArgs(argv);
  const vocabFiles = scanVocabFiles(args.vocabRoot);
  if (args.validateOnly) {
    const missing = validateWiredFiles(vocabFiles);
    if (missing.length > 0) {
      console.error(`Missing/invalid example_sentences: ${missing.length}`);
      console.error(missing.slice(0, 20).join('\n'));
      return 1;
    }
    console.log(`Validated ${vocabFiles.length} vocab files.`);
    return 0;
  }

  const corpus =
    args.rebuildCorpus || !fs.existsSync(args.corpusPath)
      ? buildExampleCorpus(vocabFiles, {
          tatoebaRows: loadTatoebaRows(args.tatoebaCachePath),
          textbookRows: loadTatoebaRows(args.textbookCachePath),
        })
      : readJson(args.corpusPath);

  if (!args.dryRun) {
    writeJson(args.corpusPath, corpus);
  }

  const allMissing = [];
  let changedFiles = 0;
  for (const file of vocabFiles) {
    const result = wireExamplesIntoVocabPayload(file.payload, corpus);
    allMissing.push(...result.missing.map((id) => `${file.filePath}:${id}`));
    if (result.changed) {
      changedFiles += 1;
      if (!args.dryRun) writeJson(file.filePath, result.payload);
      file.payload = result.payload;
    }
  }

  const invalid = validateWiredFiles(vocabFiles);
  if (allMissing.length > 0 || invalid.length > 0) {
    console.error(`Missing corpus rows: ${allMissing.length}`);
    console.error(`Invalid wired rows: ${invalid.length}`);
    console.error([...allMissing, ...invalid].slice(0, 20).join('\n'));
    return 1;
  }

  console.log(
    `Wired examples: ${changedFiles} files, ${Object.keys(corpus.items).length} vocab ids.`,
  );
  return 0;
}

if (require.main === module) {
  process.exitCode = main();
}

module.exports = {
  authoredContextualExample,
  buildExampleCorpus,
  buildTatoebaIndex,
  isValidExample,
  loadTatoebaRows,
  main,
  scanVocabFiles,
  validateWiredFiles,
  wireExamplesIntoVocabPayload,
};
