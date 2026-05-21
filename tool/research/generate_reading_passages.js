const fs = require('node:fs');
const path = require('node:path');

const DEFAULT_GENERATED_AT = '2026-05-22T00:00:00+07:00';

const LEVEL_LENGTH_RANGES = {
  N5: [50, 150],
  N4: [100, 200],
  N3: [150, 300],
  N2: [200, 400],
  N1: [250, 500],
};

const TARGET_SCOPES = [
  {
    key: 'mina-i',
    textbook: 'Mina I',
    series: 'mina',
    level: 'N5',
    lessonStart: 1,
    lessonEnd: 25,
    lessonLabel: (lesson) => `Lesson ${lesson}`,
    vocabPath: (root, lesson) =>
      path.join(root, 'vocab', 'n5', 'minna', `lesson_${pad2(lesson)}.json`),
  },
  {
    key: 'mina-ii',
    textbook: 'Mina II',
    series: 'mina',
    level: 'N4',
    lessonStart: 26,
    lessonEnd: 50,
    lessonLabel: (lesson) => `Lesson ${lesson}`,
    vocabPath: (root, lesson) =>
      path.join(root, 'vocab', 'n4', 'minna', `lesson_${pad2(lesson)}.json`),
  },
  {
    key: 'hajimete-n5',
    textbook: 'Hajimete Tango N5',
    series: 'hajimete',
    level: 'N5',
    lessonStart: 1,
    lessonEnd: 50,
    lessonLabel: (lesson) => `Chapter ${lesson}`,
    vocabPath: (root, lesson) =>
      path.join(root, 'vocab', 'n5', 'hajimete', `hajimete_ch${pad2(lesson)}.json`),
  },
  {
    key: 'hajimete-n4',
    textbook: 'Hajimete Tango N4',
    series: 'hajimete',
    level: 'N4',
    lessonStart: 1,
    lessonEnd: 50,
    lessonLabel: (lesson) => `Chapter ${lesson}`,
    vocabPath: (root, lesson) =>
      path.join(root, 'vocab', 'n4', 'hajimete', `hajimete_ch${pad2(lesson)}.json`),
  },
  {
    key: 'shinkanzen-n3',
    textbook: 'Shin Kanzen Master N3 Bunpou',
    series: 'shinkanzen',
    level: 'N3',
    lessonStart: 1,
    lessonEnd: 83,
    lessonLabel: (lesson) => `Grammar set ${lesson}`,
    grammarLevel: 'n3',
  },
  {
    key: 'shinkanzen-n2',
    textbook: 'Shin Kanzen Master N2 Bunpou',
    series: 'shinkanzen',
    level: 'N2',
    lessonStart: 1,
    lessonEnd: 163,
    lessonLabel: (lesson) => `Grammar set ${lesson}`,
    grammarLevel: 'n2',
  },
  {
    key: 'shinkanzen-n1',
    textbook: 'Shin Kanzen Master N1 Bunpou',
    series: 'shinkanzen',
    level: 'N1',
    lessonStart: 1,
    lessonEnd: 88,
    lessonLabel: (lesson) => `Grammar set ${lesson}`,
    grammarLevel: 'n1',
  },
];

const THEMES = [
  {
    key: 'station-plan',
    title: '駅前の予定確認',
    topicJa: '駅前で予定を確認すること',
    topicVi: 'kiểm tra kế hoạch trước ga',
    place: '駅前のベンチ',
    actor: 'リン',
    detailJa: '集合時間を先に確認した',
    detailVi: 'kiểm tra giờ hẹn trước',
    inferenceJa: '次の予定に遅れないように動く',
    inferenceVi: 'sẽ di chuyển để không trễ lịch tiếp theo',
    distractorsJa: ['切符の値段だけを比べる', '店の飾りを調べる', '旅行写真を整理する'],
    distractorsVi: ['chỉ so sánh giá vé', 'tìm hiểu đồ trang trí của cửa hàng', 'sắp xếp ảnh du lịch'],
    humanMomentVi:
      'Người Việt hay đọc lướt mốc thời gian; đoạn này bắt người học giữ trục "trước-sau" trước khi chọn đáp án.',
  },
  {
    key: 'library-note',
    title: '図書館のメモ',
    topicJa: '図書館で学習メモを整理すること',
    topicVi: 'sắp xếp ghi chú học ở thư viện',
    place: '図書館の静かな席',
    actor: 'ミン',
    detailJa: '分からない語を別の紙に分けた',
    detailVi: 'tách từ chưa hiểu ra giấy riêng',
    inferenceJa: 'あとで短い復習をする',
    inferenceVi: 'sẽ ôn lại ngắn sau đó',
    distractorsJa: ['料理の材料を買う', '電車の席を予約する', '友人の住所を書く'],
    distractorsVi: ['mua nguyên liệu nấu ăn', 'đặt ghế tàu', 'ghi địa chỉ bạn bè'],
    humanMomentVi:
      'Ghi chú tốt không phải chép dài; với tiếng Nhật, tách từ khóa ra trước giúp mắt không bị chìm trong câu.',
  },
  {
    key: 'class-feedback',
    title: '授業後の確認',
    topicJa: '授業後に先生の助言を使うこと',
    topicVi: 'dùng lời góp ý sau giờ học',
    place: '教室の後ろ',
    actor: 'アイン',
    detailJa: '先生の直した文を声に出した',
    detailVi: 'đọc lại câu giáo viên đã sửa',
    inferenceJa: '同じ間違いを減らせる',
    inferenceVi: 'có thể giảm lỗi lặp lại',
    distractorsJa: ['机の数を数える', '昼食の店を決める', '天気だけを見る'],
    distractorsVi: ['đếm số bàn', 'chọn quán ăn trưa', 'chỉ xem thời tiết'],
    humanMomentVi:
      'Một câu được sửa đáng giá hơn mười câu chép máy; hãy nhìn phần giáo viên chạm bút.',
  },
  {
    key: 'community-board',
    title: '掲示板のお知らせ',
    topicJa: '地域の掲示板から必要な情報を選ぶこと',
    topicVi: 'chọn thông tin cần thiết từ bảng thông báo khu phố',
    place: '地域センターの掲示板',
    actor: 'ナム',
    detailJa: '開始時間と持ち物をメモした',
    detailVi: 'ghi giờ bắt đầu và đồ cần mang',
    inferenceJa: '準備してから参加する',
    inferenceVi: 'sẽ chuẩn bị rồi mới tham gia',
    distractorsJa: ['古い写真を集める', '店員の名前を覚える', '音楽だけを聞く'],
    distractorsVi: ['sưu tầm ảnh cũ', 'nhớ tên nhân viên cửa hàng', 'chỉ nghe nhạc'],
    humanMomentVi:
      'Thông báo Nhật thường giấu đáp án trong giờ, địa điểm, điều kiện; đừng chỉ nhìn tiêu đề.',
  },
  {
    key: 'workplace-mail',
    title: '職場の短いメール',
    topicJa: '職場で短いメールの意図を読むこと',
    topicVi: 'đọc ý định trong email ngắn ở nơi làm việc',
    place: '会社の休憩室',
    actor: 'ハー',
    detailJa: '返事が必要な日を確認した',
    detailVi: 'xác nhận ngày cần trả lời',
    inferenceJa: '期限の前に返事を書く',
    inferenceVi: 'sẽ trả lời trước hạn',
    distractorsJa: ['机を新しく買う', '映画の感想を書く', '駅名を暗記する'],
    distractorsVi: ['mua bàn mới', 'viết cảm tưởng phim', 'học thuộc tên ga'],
    humanMomentVi:
      'Trong mail Nhật, câu nhẹ không có nghĩa là không quan trọng; hạn trả lời vẫn là xương sống của đoạn.',
  },
  {
    key: 'neighborhood-event',
    title: '週末の地域活動',
    topicJa: '週末の地域活動で役割を確認すること',
    topicVi: 'xác nhận vai trò trong hoạt động cuối tuần',
    place: '公民館の入口',
    actor: 'クオン',
    detailJa: '自分の担当を受付で聞いた',
    detailVi: 'hỏi phần mình phụ trách ở quầy tiếp nhận',
    inferenceJa: '担当に合わせて行動する',
    inferenceVi: 'sẽ hành động theo phần được giao',
    distractorsJa: ['新しい靴を選ぶ', '試験番号を忘れる', '昼寝の時間を延ばす'],
    distractorsVi: ['chọn giày mới', 'quên số báo danh', 'kéo dài giờ ngủ trưa'],
    humanMomentVi:
      'Người Việt quen linh hoạt theo tình huống; trong hoạt động Nhật, vai trò ghi sẵn thường quyết định thứ tự hành động.',
  },
];

const FALLBACK_FACTS = {
  N5: [
    { id: 'fallback:n5:watashi', term: '私', reading: 'わたし', meaningVi: 'tôi' },
    { id: 'fallback:n5:gakkou', term: '学校', reading: 'がっこう', meaningVi: 'trường học' },
    { id: 'fallback:n5:sensei', term: '先生', reading: 'せんせい', meaningVi: 'giáo viên' },
  ],
  N4: [
    { id: 'fallback:n4:yotei', term: '予定', reading: 'よてい', meaningVi: 'dự định' },
    { id: 'fallback:n4:renraku', term: '連絡', reading: 'れんらく', meaningVi: 'liên lạc' },
    { id: 'fallback:n4:setsumei', term: '説明', reading: 'せつめい', meaningVi: 'giải thích' },
  ],
  N3: [
    { id: 'fallback:n3:kotonisuru', term: '〜ことにする', meaningVi: 'quyết định làm' },
    { id: 'fallback:n3:younisuru', term: '〜ようにする', meaningVi: 'cố gắng duy trì' },
    { id: 'fallback:n3:tsumori', term: '〜つもりだ', meaningVi: 'dự định' },
  ],
  N2: [
    { id: 'fallback:n2:nikanshite', term: '〜に関して', meaningVi: 'liên quan đến' },
    { id: 'fallback:n2:nikurabete', term: '〜に比べて', meaningVi: 'so với' },
    { id: 'fallback:n2:nioujite', term: '〜に応じて', meaningVi: 'tùy theo' },
  ],
  N1: [
    { id: 'fallback:n1:iwazumogana', term: '〜までもない', meaningVi: 'không cần đến mức' },
    { id: 'fallback:n1:nikataku', term: '〜にかたくない', meaningVi: 'không khó để' },
    { id: 'fallback:n1:bekarazaru', term: '〜べからざる', meaningVi: 'không nên' },
  ],
};

function buildReadingPassages({
  contentRoot = path.join(process.cwd(), 'assets', 'data', 'content'),
  generatedAt = DEFAULT_GENERATED_AT,
} = {}) {
  const grammarPools = new Map();
  const passages = [];

  for (const [scopeIndex, scope] of TARGET_SCOPES.entries()) {
    if (scope.grammarLevel && !grammarPools.has(scope.grammarLevel)) {
      grammarPools.set(scope.grammarLevel, readGrammarFacts(contentRoot, scope.grammarLevel));
    }

    for (let lesson = scope.lessonStart; lesson <= scope.lessonEnd; lesson += 1) {
      const facts = lessonFacts(contentRoot, scope, lesson, grammarPools);
      for (let passageIndex = 1; passageIndex <= 2; passageIndex += 1) {
        const theme = THEMES[(scopeIndex * 31 + lesson * 7 + passageIndex * 3) % THEMES.length];
        passages.push(buildPassage({ scope, lesson, passageIndex, theme, facts, generatedAt }));
      }
    }
  }

  return {
    schemaVersion: 2,
    generatedAt,
    sourcePolicy:
      'Original JpStudy reading corpus generated from local content facts. Whitelisted sources may guide format only; no official JLPT/book/site sentence is copied.',
    targetPolicy:
      'Two reading-comprehension passages per Mina I/II, Hajimete N5/N4, and Shin Kanzen N3/N2/N1 lesson.',
    passages,
  };
}

function buildPassage({ scope, lesson, passageIndex, theme, facts, generatedAt }) {
  const seed = stableSeed(`${scope.key}:${lesson}:${passageIndex}`);
  const concepts = pickFacts(facts, seed, scope.level);
  const conceptJa = quoteList(concepts.map((fact) => fact.term));
  const conceptVi = concepts
    .map((fact) => `${fact.term}${fact.meaningVi ? ` (${fact.meaningVi})` : ''}`)
    .join(', ');
  const lessonKey = `${scope.key}:lesson-${String(lesson).padStart(3, '0')}`;
  const title = `${scope.textbook} ${scope.lessonLabel(lesson)} - ${theme.title} ${passageIndex}`;
  const paragraphs = passageParagraphs({
    level: scope.level,
    scope,
    lesson,
    passageIndex,
    theme,
    conceptJa,
  });
  const jaText = fitLength(scope.level, paragraphs).join('\n');
  const length = Array.from(jaText).length;
  const [min, max] = LEVEL_LENGTH_RANGES[scope.level];
  if (length < min || length > max) {
    throw new Error(`${title} length ${length} outside ${min}-${max}`);
  }

  return {
    passage_id: `rc-${scope.key}-l${String(lesson).padStart(3, '0')}-p${passageIndex}`,
    level: scope.level,
    textbook: scope.textbook,
    series: scope.series,
    lesson_id: lesson,
    lesson_key: lessonKey,
    lesson_label: scope.lessonLabel(lesson),
    passage_index: passageIndex,
    title,
    ja_text: jaText,
    vi_translation: viTranslation({ scope, lesson, passageIndex, theme, conceptVi }),
    grammars_used: concepts
      .filter((fact) => fact.kind === 'grammar')
      .map((fact) => fact.id),
    vocabs_used: concepts
      .filter((fact) => fact.kind !== 'grammar')
      .map((fact) => fact.id),
    kanjis_used: extractKanji(jaText).slice(0, 12),
    questions: buildQuestions({ scope, theme, seed, passageIndex }),
    source_type: 'original',
    source_credit: 'JpStudy original prose generated from local lesson facts',
    source_refs: facts.sourceRefs,
    copyright_safety:
      'Original JpStudy prose; no official JLPT question, textbook passage, or website sentence copied.',
    human_moment_vi: passageIndex === 2 ? theme.humanMomentVi : '',
    generated_at: generatedAt,
  };
}

function passageParagraphs({ level, scope, lesson, passageIndex, theme, conceptJa }) {
  const label = `この課の第${passageIndex}読解`;
  if (level === 'N5') {
    return [
      `${theme.actor}さんは${theme.place}で日本語を読みました。`,
      `ノートには${conceptJa}がありました。`,
      `${theme.actor}さんは${theme.detailJa}あとで、短い文を一つ書きました。`,
      `先生は「順番を見ましょう」と言いました。`,
      `この読解は${label}の練習です。`,
    ];
  }
  if (level === 'N4') {
    return [
      `${theme.actor}さんは${theme.place}で、今日の予定と日本語のメモを見直しました。`,
      `メモには${conceptJa}があり、似ている言葉は線で分けてありました。`,
      `${theme.detailJa}ので、あとで迷わずに動けます。`,
      `先生は、答えを急がず、時間と理由を本文から探すように言いました。`,
      `この読解は${label}の練習です。`,
    ];
  }
  if (level === 'N3') {
    return [
      `${theme.actor}さんは${theme.place}で、${theme.topicJa}について短い記録を読みました。記録には${conceptJa}が出てきます。`,
      `最初は言葉の意味だけを追っていましたが、途中で「だれが、いつ、何を決めたか」を表にしました。${theme.detailJa}ことが分かると、文章全体の流れも見えました。`,
      `先生は、難しい語を全部訳す前に、理由と結果を一本の線で結ぶように助言しました。この読解は${label}の練習です。`,
    ];
  }
  if (level === 'N2') {
    return [
      `${theme.place}で配られた案内文は、${theme.topicJa}を説明するものでした。${theme.actor}さんは${conceptJa}に印を付け、条件と例外を分けて読みました。`,
      `案内文では、参加者が自由に動ける部分と、事前に確認すべき部分が分けて書かれていました。${theme.detailJa}ため、判断の根拠は一つの文ではなく、前後のつながりにあります。`,
      `Dr. Linh-Phan-Tranの授業メモでは、日本語の丁寧な表現ほど結論が後ろに寄ることがある、と説明されていました。急いで選ぶより、条件、理由、結論の順に印を付ける読み方が役に立ちます。この読解は${label}の練習です。`,
    ];
  }
  return [
    `${theme.topicJa}をめぐる文章を、${theme.actor}さんは${theme.place}で読みました。本文は単なる案内ではなく、読み手がどの情報を優先すべきかを考えさせる構成になっています。${conceptJa}のような表現も、語義だけでなく段落内の役割を見なければなりません。`,
    `前半では背景が示され、中盤では別の見方が紹介されます。そのうえで、${theme.detailJa}という点が判断の軸になります。ここを落とすと、選択肢の一つ一つは正しそうに見えても、本文の主張とはずれてしまいます。`,
    `Dr. Linh-Phan-Tranの読解メモは、上級文では「正しい文」より「本文が求める答え」を選ぶことが大切だとまとめています。結論だけを探すのではなく、対比、条件、譲歩を順に追えば、${theme.inferenceJa}と自然に読めます。この読解は${label}の練習です。`,
  ];
}

function fitLength(level, paragraphs) {
  const [min] = LEVEL_LENGTH_RANGES[level];
  const additions = {
    N5: ['最後に、もう一度ゆっくり読みました。'],
    N4: ['最後に、大事なところだけをもう一度読みました。'],
    N3: ['この一手間で、細かい語彙に迷っても主旨を失いにくくなります。'],
    N2: ['読み終えた後、本文にない思い込みを選択肢へ持ち込まないことも確認しました。'],
    N1: ['つまり、読解の難しさは語彙量だけでなく、筆者がどの順番で根拠を置いたかを見抜く力にもあります。'],
  };
  const fitted = [...paragraphs];
  while (Array.from(fitted.join('\n')).length < min) {
    fitted[fitted.length - 1] = `${fitted[fitted.length - 1]}${additions[level][0]}`;
  }
  return fitted;
}

function viTranslation({ scope, lesson, passageIndex, theme, conceptVi }) {
  return [
    `Bài đọc gốc JpStudy cho ${scope.textbook} ${scope.lessonLabel(lesson)}, đoạn ${passageIndex}.`,
    `Trọng tâm: ${theme.topicVi}.`,
    `Từ/mẫu neo: ${conceptVi}.`,
    'Mục tiêu đọc: nắm ý chính, chi tiết then chốt và suy luận bước tiếp theo.',
  ].join(' ');
}

function buildQuestions({ scope, theme, seed, passageIndex }) {
  return [
    question({
      passageSeed: seed + 1,
      type: 'main_idea',
      qJa: 'この文章の中心にある内容は何ですか。',
      qVi: 'Nội dung trung tâm của đoạn văn là gì?',
      correct: { ja: theme.topicJa, vi: theme.topicVi },
      distractorsJa: theme.distractorsJa,
      distractorsVi: theme.distractorsVi,
      explanationVi: `Đọc theo cách của Dr. Linh: nhan đề chỉ là cửa vào; mạch chính của đoạn là ${theme.topicVi}.`,
    }),
    question({
      passageSeed: seed + 2,
      type: 'detail',
      qJa: '本文で確認された具体的なことは何ですか。',
      qVi: 'Chi tiết cụ thể được xác nhận trong đoạn là gì?',
      correct: { ja: theme.detailJa, vi: theme.detailVi },
      distractorsJa: rotate(theme.distractorsJa, 1),
      distractorsVi: rotate(theme.distractorsVi, 1),
      explanationVi: `Chi tiết đúng nằm ở hành động cụ thể: ${theme.detailVi}. Đừng chọn thông tin nghe hợp lý nhưng không xuất hiện trong đoạn.`,
    }),
    question({
      passageSeed: seed + 3,
      type: 'inference',
      qJa: `${scope.level}の読解として、この後に最も自然な行動はどれですか。`,
      qVi: 'Suy luận tự nhiên nhất sau đoạn này là gì?',
      correct: { ja: theme.inferenceJa, vi: theme.inferenceVi },
      distractorsJa: rotate(theme.distractorsJa, passageIndex + 1),
      distractorsVi: rotate(theme.distractorsVi, passageIndex + 1),
      explanationVi: `Suy luận phải nối từ chi tiết sang hành động kế tiếp: ${theme.inferenceVi}.`,
    }),
  ];
}

function question({
  passageSeed,
  type,
  qJa,
  qVi,
  correct,
  distractorsJa,
  distractorsVi,
  explanationVi,
}) {
  const distractors = distractorsJa.map((ja, index) => ({
    ja,
    vi: distractorsVi[index],
  }));
  const arranged = arrangeOptions([correct, ...distractors.slice(0, 3)], passageSeed);
  return {
    type,
    q_ja: qJa,
    q_vi: qVi,
    options_ja: arranged.options.map((item) => item.ja),
    options_vi: arranged.options.map((item) => item.vi),
    correct_index: arranged.correctIndex,
    explanation_vi: explanationVi,
  };
}

function arrangeOptions(options, seed) {
  const shift = seed % options.length;
  const arranged = rotate(options, shift);
  const correctIndex = arranged.findIndex((item) => item === options[0]);
  return { options: arranged, correctIndex };
}

function lessonFacts(contentRoot, scope, lesson, grammarPools) {
  if (scope.vocabPath) {
    const file = scope.vocabPath(contentRoot, lesson);
    const facts = readVocabFacts(file);
    return {
      facts: facts.length > 0 ? facts : FALLBACK_FACTS[scope.level],
      sourceRefs: fs.existsSync(file) ? [`local:${repoRelative(file)}`] : ['local:fallback-vocab'],
    };
  }
  const pool = grammarPools.get(scope.grammarLevel) || [];
  const facts = selectWindow(pool, lesson, 5);
  return {
    facts: facts.length > 0 ? facts : FALLBACK_FACTS[scope.level],
    sourceRefs: [`local:assets/data/content/grammar/${scope.grammarLevel}/`],
  };
}

function readVocabFacts(file) {
  if (!fs.existsSync(file)) return [];
  const payload = readJson(file);
  return (payload.entries || [])
    .map((entry) => {
      const term = cleanTerm(entry.lemma?.term);
      if (!term) return null;
      return {
        id: entry.lemma?.vocabId || entry.entryId || term,
        kind: 'vocab',
        term,
        reading: cleanText(entry.lemma?.reading),
        meaningVi: cleanText(entry.sense?.meaningVi),
      };
    })
    .filter(Boolean)
    .filter((entry) => Array.from(entry.term).length <= 8)
    .slice(0, 16);
}

function readGrammarFacts(contentRoot, grammarLevel) {
  const dir = path.join(contentRoot, 'grammar', grammarLevel);
  if (!fs.existsSync(dir)) return [];
  const files = fs
    .readdirSync(dir)
    .filter((file) => file.endsWith('.json'))
    .sort((a, b) => numericSuffix(a) - numericSuffix(b) || a.localeCompare(b));
  const facts = [];
  for (const file of files) {
    const items = readJson(path.join(dir, file));
    if (!Array.isArray(items)) continue;
    for (const [index, item] of items.entries()) {
      const term = cleanTerm(item.title || item.structure);
      if (!term) continue;
      facts.push({
        id: `grammar:${grammarLevel}:${path.basename(file, '.json')}:${index + 1}`,
        kind: 'grammar',
        term,
        meaningVi: cleanText(item.explanation),
      });
    }
  }
  return facts;
}

function pickFacts(lessonFactsResult, seed, level) {
  const facts = lessonFactsResult.facts || FALLBACK_FACTS[level];
  const picked = selectWindow(facts, seed, 3);
  return picked.length > 0 ? picked : FALLBACK_FACTS[level];
}

function selectWindow(items, seed, count) {
  if (!Array.isArray(items) || items.length === 0) return [];
  const out = [];
  const start = seed % items.length;
  for (let index = 0; index < Math.min(count, items.length); index += 1) {
    out.push(items[(start + index) % items.length]);
  }
  return out;
}

function writeReadingPassages({
  contentRoot = path.join(process.cwd(), 'assets', 'data', 'content'),
  generatedAt = DEFAULT_GENERATED_AT,
} = {}) {
  const payload = buildReadingPassages({ contentRoot, generatedAt });
  const target = path.join(contentRoot, 'reading_passages', 'reading_passages_corpus.json');
  fs.mkdirSync(path.dirname(target), { recursive: true });
  fs.writeFileSync(target, `${JSON.stringify(payload, null, 2)}\n`, 'utf8');
  return payload;
}

function extractKanji(value) {
  return Array.from(new Set(String(value).match(/[\u4e00-\u9fff]/g) || []));
}

function quoteList(values) {
  const cleaned = values.map(cleanTerm).filter(Boolean).slice(0, 3);
  return cleaned.map((value) => `「${value}」`).join('、');
}

function cleanTerm(value) {
  const text = cleanText(value);
  if (!text) return '';
  return text.replace(/\s+/g, ' ').trim();
}

function cleanText(value) {
  const text = String(value ?? '').trim();
  return text.length === 0 ? '' : text;
}

function rotate(items, count) {
  if (items.length === 0) return [];
  const shift = ((count % items.length) + items.length) % items.length;
  return [...items.slice(shift), ...items.slice(0, shift)];
}

function stableSeed(value) {
  let hash = 0;
  for (const char of String(value)) {
    hash = (hash * 31 + char.codePointAt(0)) >>> 0;
  }
  return hash;
}

function numericSuffix(file) {
  const match = file.match(/_(\d+)\.json$/);
  return match ? Number(match[1]) : Number.MAX_SAFE_INTEGER;
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function pad2(value) {
  return String(value).padStart(2, '0');
}

function slash(value) {
  return value.replace(/\\/g, '/');
}

function repoRelative(file) {
  return slash(path.relative(process.cwd(), file));
}

if (require.main === module) {
  const shouldWrite = process.argv.includes('--write');
  const payload = shouldWrite ? writeReadingPassages() : buildReadingPassages();
  const byLevel = payload.passages.reduce((acc, passage) => {
    acc[passage.level] = (acc[passage.level] || 0) + 1;
    return acc;
  }, {});
  console.log(
    JSON.stringify(
      {
        passages: payload.passages.length,
        byLevel,
        wrote: shouldWrite,
      },
      null,
      2,
    ),
  );
}

module.exports = {
  LEVEL_LENGTH_RANGES,
  TARGET_SCOPES,
  buildReadingPassages,
  writeReadingPassages,
};
