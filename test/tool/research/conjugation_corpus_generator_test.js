const assert = require('node:assert/strict');
const test = require('node:test');

const {
  buildConjugationDrillQuestions,
  generateConjugationCorpus,
  validateConjugationCorpus,
} = require('../../../tool/research/generate_conjugation_corpus');

const fixtureLemmas = {
  schemaVersion: 1,
  entries: [
    lemma({ term: '食べる', reading: 'たべる', kind: 'verb', klass: 'ichidan' }),
    lemma({ term: '書く', reading: 'かく', kind: 'verb', klass: 'godanKu' }),
    lemma({ term: '行く', reading: 'いく', kind: 'verb', klass: 'godanIkuException' }),
    lemma({ term: '勉強する', reading: 'べんきょうする', kind: 'verb', klass: 'suru' }),
    lemma({ term: '来る', reading: 'くる', kind: 'verb', klass: 'kuru' }),
    lemma({ term: '高い', reading: 'たかい', kind: 'i_adjective', klass: 'iAdjective' }),
    lemma({ term: 'いい', reading: 'いい', kind: 'i_adjective', klass: 'iiException' }),
    lemma({ term: '静か', reading: 'しずか', kind: 'na_adjective', klass: 'naAdjective' }),
  ],
};

function lemma({ term, reading, kind, klass }) {
  const index = lemma.nextIndex = (lemma.nextIndex || 0) + 1;
  return {
    id: index,
    contentEntryId: `entry_${index}`,
    contentVocabId: `vocab_${index}`,
    term,
    reading,
    dictionaryForm: term,
    dictionaryReading: reading,
    kind,
    conjugationClass: klass,
    posTags: [],
    level: 'N5',
    series: 'test',
    lessonId: 1,
  };
}

test('generateConjugationCorpus emits full verb and adjective forms', () => {
  const corpus = generateConjugationCorpus({
    lemmas: fixtureLemmas,
    generatedAt: '2026-05-21T00:00:00+07:00',
  });

  assert.equal(corpus.verbs['食べる'].forms.masu_negative, '食べません');
  assert.equal(corpus.verbs['食べる'].forms.causative_passive, '食べさせられる');
  assert.equal(corpus.verbs['書く'].forms.te, '書いて');
  assert.equal(corpus.verbs['行く'].forms.te, '行って');
  assert.equal(corpus.verbs['勉強する'].forms.potential, '勉強できる');
  assert.equal(corpus.verbs['来る'].forms.imperative, '来い');

  assert.equal(corpus.i_adjectives['高い'].forms.past_negative, '高くなかった');
  assert.equal(corpus.i_adjectives['いい'].forms.negative, 'よくない');
  assert.equal(corpus.na_adjectives['静か'].forms.past_polite, '静かでした');
});

test('validateConjugationCorpus counts generated forms and irregulars', () => {
  const corpus = generateConjugationCorpus({
    lemmas: fixtureLemmas,
    generatedAt: '2026-05-21T00:00:00+07:00',
  });
  const report = validateConjugationCorpus(corpus, {
    minVerbs: 5,
    minAdjectives: 3,
    minIrregular: 3,
  });

  assert.equal(report.passed, true);
  assert.equal(report.verbCount >= 5, true);
  assert.equal(report.adjectiveCount, 3);
  assert.equal(report.irregularCount >= 3, true);
  assert.deepEqual(report.missingRequiredForms, []);
});

test('buildConjugationDrillQuestions creates at least 50 non-duplicate prompts', () => {
  const corpus = generateConjugationCorpus({
    lemmas: fixtureLemmas,
    generatedAt: '2026-05-21T00:00:00+07:00',
  });
  const questions = buildConjugationDrillQuestions({
    entry: corpus.verbs['食べる'],
    count: 50,
  });

  assert.equal(questions.length, 50);
  assert.equal(new Set(questions.map((question) => question.question_id)).size, 50);
  assert.equal(
    questions.every((question) => question.options.includes(question.correct_answer)),
    true,
  );
  assert.equal(
    questions.every((question) => new Set(question.options).size === question.options.length),
    true,
  );
});
