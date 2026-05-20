const fs = require('node:fs');
const path = require('node:path');

const DEFAULT_INPUT = path.join('assets', 'data', 'content', 'conjugation', 'lemmas.json');
const DEFAULT_OUTPUT = path.join(
  'assets',
  'data',
  'content',
  'conjugation',
  'conjugation_corpus.json',
);
const DEFAULT_ERROR_LOG = path.join(
  'assets',
  'data',
  'content',
  'conjugation',
  'conjugation_generation_errors.log',
);

const VERB_REQUIRED_FORMS = [
  'dictionary',
  'masu',
  'masu_negative',
  'masu_past',
  'masu_past_negative',
  'te',
  'ta',
  'nai',
  'nakatta',
  'ba',
  'tara',
  'command',
  'volitional',
  'passive',
  'causative',
  'causative_passive',
  'potential',
];

const I_ADJ_REQUIRED_FORMS = [
  'dictionary',
  'negative',
  'past',
  'past_negative',
  'te',
  'ba',
  'tara',
  'adverb',
  'polite',
  'negative_polite',
];

const NA_ADJ_REQUIRED_FORMS = [
  'dictionary',
  'polite',
  'negative',
  'negative_polite',
  'past',
  'past_polite',
  'te',
  'ba',
  'tara',
  'adverb',
  'attributive',
];

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function writeText(file, text) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, text);
}

function dropLast(value) {
  return value.slice(0, -1);
}

const GODAN_ROW = {
  godanU: { a: 'わ', i: 'い', e: 'え', o: 'お', te: 'って', ta: 'った' },
  godanKu: { a: 'か', i: 'き', e: 'け', o: 'こ', te: 'いて', ta: 'いた' },
  godanGu: { a: 'が', i: 'ぎ', e: 'げ', o: 'ご', te: 'いで', ta: 'いだ' },
  godanSu: { a: 'さ', i: 'し', e: 'せ', o: 'そ', te: 'して', ta: 'した' },
  godanTsu: { a: 'た', i: 'ち', e: 'て', o: 'と', te: 'って', ta: 'った' },
  godanNu: { a: 'な', i: 'に', e: 'ね', o: 'の', te: 'んで', ta: 'んだ' },
  godanBu: { a: 'ば', i: 'び', e: 'べ', o: 'ぼ', te: 'んで', ta: 'んだ' },
  godanMu: { a: 'ま', i: 'み', e: 'め', o: 'も', te: 'んで', ta: 'んだ' },
  godanRu: { a: 'ら', i: 'り', e: 'れ', o: 'ろ', te: 'って', ta: 'った' },
  godanIkuException: {
    a: 'か',
    i: 'き',
    e: 'け',
    o: 'こ',
    te: 'って',
    ta: 'った',
  },
};

function verbForms(lemma, klass) {
  if (klass === 'ichidan') return ichidanForms(lemma);
  if (klass === 'suru') return suruForms(lemma);
  if (klass === 'kuru') return kuruForms(lemma);
  if (klass === 'aruException') return aruForms(lemma);
  if (GODAN_ROW[klass]) return godanForms(lemma, klass);
  throw new Error(`unsupported verb class ${klass}`);
}

function withPoliteNegative(forms, masuStem) {
  return {
    ...forms,
    masu_negative: `${masuStem}ません`,
    masu_past: `${masuStem}ました`,
    masu_past_negative: `${masuStem}ませんでした`,
    nakatta: forms.nai.endsWith('ない')
      ? `${forms.nai.slice(0, -'ない'.length)}なかった`
      : `${forms.nai}かった`,
    command: forms.imperative,
  };
}

function ichidanForms(lemma) {
  const stem = dropLast(lemma);
  return withPoliteNegative(
    {
      dictionary: lemma,
      masu: `${stem}ます`,
      nai: `${stem}ない`,
      ta: `${stem}た`,
      te: `${stem}て`,
      ba: `${stem}れば`,
      tara: `${stem}たら`,
      volitional: `${stem}よう`,
      potential: `${stem}られる`,
      passive: `${stem}られる`,
      causative: `${stem}させる`,
      causative_passive: `${stem}させられる`,
      imperative: `${stem}ろ`,
    },
    stem,
  );
}

function godanForms(lemma, klass) {
  const stem = dropLast(lemma);
  const row = GODAN_ROW[klass];
  return withPoliteNegative(
    {
      dictionary: lemma,
      masu: `${stem}${row.i}ます`,
      nai: `${stem}${row.a}ない`,
      ta: `${stem}${row.ta}`,
      te: `${stem}${row.te}`,
      ba: `${stem}${row.e}ば`,
      tara: `${stem}${row.ta}ら`,
      volitional: `${stem}${row.o}う`,
      potential: `${stem}${row.e}る`,
      passive: `${stem}${row.a}れる`,
      causative: `${stem}${row.a}せる`,
      causative_passive: `${stem}${row.a}せられる`,
      imperative: `${stem}${row.e}`,
    },
    `${stem}${row.i}`,
  );
}

function suruForms(lemma) {
  const stem = lemma.endsWith('する') ? lemma.slice(0, -'する'.length) : lemma;
  return withPoliteNegative(
    {
      dictionary: lemma,
      masu: `${stem}します`,
      nai: `${stem}しない`,
      ta: `${stem}した`,
      te: `${stem}して`,
      ba: `${stem}すれば`,
      tara: `${stem}したら`,
      volitional: `${stem}しよう`,
      potential: `${stem}できる`,
      passive: `${stem}される`,
      causative: `${stem}させる`,
      causative_passive: `${stem}させられる`,
      imperative: `${stem}しろ`,
    },
    `${stem}し`,
  );
}

function kuruForms(lemma) {
  const prefix = lemma.endsWith('来る')
    ? lemma.slice(0, -'来る'.length)
    : lemma.endsWith('くる')
      ? lemma.slice(0, -'くる'.length)
      : '';
  return withPoliteNegative(
    {
      dictionary: lemma,
      masu: `${prefix}来ます`,
      nai: `${prefix}来ない`,
      ta: `${prefix}来た`,
      te: `${prefix}来て`,
      ba: `${prefix}来れば`,
      tara: `${prefix}来たら`,
      volitional: `${prefix}来よう`,
      potential: `${prefix}来られる`,
      passive: `${prefix}来られる`,
      causative: `${prefix}来させる`,
      causative_passive: `${prefix}来させられる`,
      imperative: `${prefix}来い`,
    },
    `${prefix}来`,
  );
}

function aruForms(lemma) {
  return withPoliteNegative(
    {
      dictionary: lemma,
      masu: 'あります',
      nai: 'ない',
      ta: 'あった',
      te: 'あって',
      ba: 'あれば',
      tara: 'あったら',
      volitional: 'あろう',
      potential: '',
      passive: '',
      causative: '',
      causative_passive: '',
      imperative: 'あれ',
    },
    'あり',
  );
}

function iAdjectiveForms(lemma, klass) {
  const base = klass === 'iiException' ? 'よい' : lemma;
  const dictionary = klass === 'iiException' ? 'いい' : lemma;
  const stem = base.endsWith('い') ? dropLast(base) : base;
  return {
    dictionary,
    negative: `${stem}くない`,
    past: `${stem}かった`,
    past_negative: `${stem}くなかった`,
    te: `${stem}くて`,
    ba: `${stem}ければ`,
    tara: `${stem}かったら`,
    volitional: `${stem}かろう`,
    adverb: `${stem}く`,
    polite: `${dictionary}です`,
    negative_polite: `${stem}くありません`,
  };
}

function naAdjectiveForms(lemma) {
  return {
    dictionary: `${lemma}だ`,
    polite: `${lemma}です`,
    negative: `${lemma}ではない`,
    negative_polite: `${lemma}ではありません`,
    past: `${lemma}だった`,
    past_polite: `${lemma}でした`,
    te: `${lemma}で`,
    ba: `${lemma}なら`,
    tara: `${lemma}だったら`,
    adverb: `${lemma}に`,
    attributive: `${lemma}な`,
  };
}

function baseEntry(lemma, kind, forms, extra = {}) {
  return {
    item_id: `conj:${kind}:${lemma.dictionaryForm || lemma.term}`,
    lemma: lemma.dictionaryForm || lemma.term,
    reading: lemma.dictionaryReading || lemma.reading || null,
    meaning_vi: lemma.meaningVi || lemma.sense?.meaningVi || '',
    level: lemma.level || 'N5',
    frequency_rank: lemma.id || null,
    source_content_vocab_id: lemma.contentVocabId || null,
    source_entry_id: lemma.contentEntryId || null,
    source_path: lemma.sourcePath || null,
    source: extra.source || 'current-app-vocab-jmdict-pos',
    forms,
    examples_per_form: {},
    ...extra,
  };
}

function manualSeedEntries() {
  const terms = [
    ['する', 'する', 'suru', 'N5'],
    ['勉強する', 'べんきょうする', 'suru', 'N5'],
    ['運動する', 'うんどうする', 'suru', 'N5'],
    ['電話する', 'でんわする', 'suru', 'N5'],
    ['来る', 'くる', 'kuru', 'N5'],
    ['持って来る', 'もってくる', 'kuru', 'N4'],
    ['行く', 'いく', 'godanIkuException', 'N5'],
    ['持って行く', 'もっていく', 'godanIkuException', 'N4'],
    ['ある', 'ある', 'aruException', 'N5'],
    ['いらっしゃる', 'いらっしゃる', 'godanRu', 'N4'],
    ['おっしゃる', 'おっしゃる', 'godanRu', 'N4'],
    ['くださる', 'くださる', 'godanRu', 'N4'],
    ['なさる', 'なさる', 'godanRu', 'N4'],
    ['ござる', 'ござる', 'godanRu', 'N4'],
    ['召し上がる', 'めしあがる', 'godanRu', 'N4'],
    ['いただく', 'いただく', 'godanKu', 'N4'],
    ['参る', 'まいる', 'godanRu', 'N4'],
    ['伺う', 'うかがう', 'godanU', 'N3'],
    ['拝見する', 'はいけんする', 'suru', 'N3'],
    ['拝借する', 'はいしゃくする', 'suru', 'N2'],
    ['存じる', 'ぞんじる', 'ichidan', 'N2'],
    ['致す', 'いたす', 'godanSu', 'N3'],
    ['申す', 'もうす', 'godanSu', 'N4'],
    ['亡くなる', 'なくなる', 'godanRu', 'N4'],
    ['見える', 'みえる', 'ichidan', 'N4'],
    ['聞こえる', 'きこえる', 'ichidan', 'N4'],
    ['寝坊する', 'ねぼうする', 'suru', 'N4'],
    ['案内する', 'あんないする', 'suru', 'N4'],
    ['説明する', 'せつめいする', 'suru', 'N4'],
    ['確認する', 'かくにんする', 'suru', 'N3'],
  ];
  return terms.map(([term, reading, klass, level], index) => ({
    id: 900000 + index,
    contentEntryId: `manual_irregular_${index + 1}`,
    contentVocabId: `manual_irregular_${index + 1}`,
    term,
    reading,
    dictionaryForm: term,
    dictionaryReading: reading,
    kind: 'verb',
    conjugationClass: klass,
    level,
    manual_seeded: true,
  }));
}

function normalizeKind(kind) {
  if (kind === 'verb') return 'verb';
  if (kind === 'i_adjective' || kind === 'iAdjective') return 'i_adjective';
  if (kind === 'na_adjective' || kind === 'naAdjective') return 'na_adjective';
  return kind;
}

function addVerb(corpus, lemma, { manualSeeded = false } = {}) {
  const forms = verbForms(lemma.dictionaryForm || lemma.term, lemma.conjugationClass);
  const entry = baseEntry(lemma, 'verb', forms, {
    conjugation_class: lemma.conjugationClass,
    manual_seeded: manualSeeded || Boolean(lemma.manual_seeded),
    source: manualSeeded || lemma.manual_seeded
      ? 'manual-irregular-seed'
      : 'current-app-vocab-jmdict-pos',
  });
  corpus.verbs[entry.lemma] = entry;
}

function addAdjective(corpus, lemma) {
  const kind = normalizeKind(lemma.kind);
  if (kind === 'i_adjective') {
    const forms = iAdjectiveForms(lemma.dictionaryForm || lemma.term, lemma.conjugationClass);
    corpus.i_adjectives[lemma.dictionaryForm || lemma.term] = baseEntry(
      lemma,
      'i_adjective',
      forms,
      { conjugation_class: lemma.conjugationClass },
    );
  } else if (kind === 'na_adjective') {
    const forms = naAdjectiveForms(lemma.dictionaryForm || lemma.term);
    corpus.na_adjectives[lemma.dictionaryForm || lemma.term] = baseEntry(
      lemma,
      'na_adjective',
      forms,
      { conjugation_class: lemma.conjugationClass },
    );
  }
}

function generateConjugationCorpus({
  lemmas,
  generatedAt = new Date().toISOString(),
} = {}) {
  const corpus = {
    schema_version: 1,
    generated_at: generatedAt,
    source_policy: {
      rules:
        'Generated from JpStudy conjugation engine logic based on Tae Kim and MEXT-style conjugation references; no copyrighted prose copied.',
      lexemes:
        'Current JpStudy vocab lemmas matched to JMdict POS plus manual irregular seed.',
    },
    verbs: {},
    i_adjectives: {},
    na_adjectives: {},
    errors: [],
  };

  for (const lemma of lemmas?.entries || []) {
    try {
      const kind = normalizeKind(lemma.kind);
      if (kind === 'verb') {
        addVerb(corpus, lemma);
      } else {
        addAdjective(corpus, lemma);
      }
    } catch (error) {
      corpus.errors.push({
        lemma: lemma.dictionaryForm || lemma.term || '',
        reason: error.message,
      });
    }
  }

  for (const seed of manualSeedEntries()) {
    if (!corpus.verbs[seed.dictionaryForm]) {
      try {
        addVerb(corpus, seed, { manualSeeded: true });
      } catch (error) {
        corpus.errors.push({ lemma: seed.dictionaryForm, reason: error.message });
      }
    } else {
      corpus.verbs[seed.dictionaryForm].manual_seeded = true;
    }
  }

  corpus.summary = {
    verb_count: Object.keys(corpus.verbs).length,
    i_adjective_count: Object.keys(corpus.i_adjectives).length,
    na_adjective_count: Object.keys(corpus.na_adjectives).length,
    manual_seed_count: Object.values(corpus.verbs).filter(
      (entry) => entry.manual_seeded,
    ).length,
    error_count: corpus.errors.length,
  };

  return corpus;
}

function missingForms(entry, required) {
  return required.filter((key) => {
    const value = entry.forms?.[key];
    return typeof value !== 'string' || value.trim().isEmpty;
  });
}

function validateConjugationCorpus(
  corpus,
  { minVerbs = 1000, minAdjectives = 500, minIrregular = 30 } = {},
) {
  const missingRequiredForms = [];
  for (const [lemma, entry] of Object.entries(corpus.verbs || {})) {
    const missing = missingForms(entry, VERB_REQUIRED_FORMS);
    if (missing.length > 0) missingRequiredForms.push({ lemma, missing });
  }
  for (const [lemma, entry] of Object.entries(corpus.i_adjectives || {})) {
    const missing = missingForms(entry, I_ADJ_REQUIRED_FORMS);
    if (missing.length > 0) missingRequiredForms.push({ lemma, missing });
  }
  for (const [lemma, entry] of Object.entries(corpus.na_adjectives || {})) {
    const missing = missingForms(entry, NA_ADJ_REQUIRED_FORMS);
    if (missing.length > 0) missingRequiredForms.push({ lemma, missing });
  }
  const verbCount = Object.keys(corpus.verbs || {}).length;
  const adjectiveCount =
    Object.keys(corpus.i_adjectives || {}).length +
    Object.keys(corpus.na_adjectives || {}).length;
  const irregularCount = Object.values(corpus.verbs || {}).filter(
    (entry) => entry.manual_seeded,
  ).length;
  return {
    verbCount,
    adjectiveCount,
    irregularCount,
    missingRequiredForms,
    passed:
      verbCount >= minVerbs &&
      adjectiveCount >= minAdjectives &&
      irregularCount >= minIrregular &&
      missingRequiredForms.length === 0,
  };
}

function formLabel(key) {
  return key.replace(/_/g, ' ');
}

function unique(values) {
  return [...new Set(values.filter((value) => value && value.trim()))];
}

function buildConjugationDrillQuestions({ entry, count = 50 } = {}) {
  const forms = entry.forms || {};
  const formEntries = Object.entries(forms).filter(([, value]) => value);
  const questions = [];
  let cursor = 0;
  while (questions.length < count && formEntries.length > 0) {
    const [formKey, correct] = formEntries[cursor % formEntries.length];
    const distractors = unique(
      formEntries
        .filter(([key, value]) => key !== formKey && value !== correct)
        .map(([, value]) => value),
    ).slice(0, 3);
    while (distractors.length < 3) {
      distractors.push(`${correct} (${formLabel(formKey)} ${distractors.length + 1})`);
    }
    const options = unique([correct, ...distractors]).slice(0, 4);
    questions.push({
      question_id: `${entry.item_id}:conjugation:${formKey}:${questions.length + 1}`,
      bloom: questions.length % 4 === 3 ? 'analyze' : 'apply',
      type: 'conjugation_drill',
      prompt_vi: `Chia ${entry.lemma} sang ${formLabel(formKey)}.`,
      prompt_ja: `${entry.lemma} -> ${formLabel(formKey)}`,
      correct_answer: correct,
      options,
      correct_index: options.indexOf(correct),
      distractor_policy: 'other-forms-same-lemma',
    });
    cursor += 1;
  }
  return questions;
}

function parseArgs(argv) {
  const args = {};
  for (let index = 2; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === '--input') args.input = argv[++index];
    if (arg === '--output') args.output = argv[++index];
    if (arg === '--error-log') args.errorLog = argv[++index];
    if (arg === '--generated-at') args.generatedAt = argv[++index];
  }
  return args;
}

if (require.main === module) {
  const args = parseArgs(process.argv);
  const input = args.input || DEFAULT_INPUT;
  const output = args.output || DEFAULT_OUTPUT;
  const errorLog = args.errorLog || DEFAULT_ERROR_LOG;
  const corpus = generateConjugationCorpus({
    lemmas: readJson(input),
    generatedAt: args.generatedAt || '2026-05-21T00:00:00+07:00',
  });
  writeText(output, `${JSON.stringify(corpus, null, 2)}\n`);
  writeText(
    errorLog,
    corpus.errors.map((error) => `${error.lemma}\t${error.reason}`).join('\n') +
      (corpus.errors.length > 0 ? '\n' : ''),
  );
  const report = validateConjugationCorpus(corpus);
  console.log(JSON.stringify(report, null, 2));
  if (!report.passed) process.exitCode = 1;
}

module.exports = {
  buildConjugationDrillQuestions,
  generateConjugationCorpus,
  validateConjugationCorpus,
};
