const assert = require('node:assert/strict');
const test = require('node:test');

const {
  buildExerciseSampleReview,
  formatExerciseSampleReviewMarkdown,
} = require('../../../tool/qa/review_exercise_samples');

test('buildExerciseSampleReview creates a 20-row acceptance sample', () => {
  const review = buildExerciseSampleReview({
    generatedAt: '2026-05-21T09:10:00+07:00',
    readingPassages: {
      passages: Array.from({ length: 5 }, (_, index) => ({
        passage_id: `rc-n5-${index + 1}`,
        level: 'N5',
        questions: [
          {
            type: 'main_idea',
            q_vi: 'Ý chính là gì?',
            options_vi: ['Đúng', 'Sai 1', 'Sai 2', 'Sai 3'],
            correct_index: 0,
          },
        ],
      })),
    },
    phoneticTraps: {
      traps: {
        v1: [{ vocab_id: 'v2', distance: 1 }],
        v2: [{ vocab_id: 'v1', distance: 1 }],
        v3: [{ vocab_id: 'v4', distance: 2 }],
        v4: [{ vocab_id: 'v3', distance: 2 }],
        v5: [{ vocab_id: 'v6', distance: 1 }],
      },
    },
    kanjiLookalikes: {
      lookalikes: {
        日: [{ character: '目', reason: 'visual_neighbor' }],
        未: [{ character: '末', reason: 'visual_neighbor' }],
        鳥: [{ character: '烏', reason: 'visual_neighbor' }],
        因: [{ character: '困', reason: 'visual_neighbor' }],
        休: [{ character: '体', reason: 'component_overlap' }],
      },
    },
    coverageManifest: {
      minimumExerciseCount: 50,
      bloomLevels: ['L1', 'L2', 'L3', 'L4'],
      typeExerciseTypes: {
        grammar: ['recognition', 'production', 'recall', 'readingComp', 'listening', 'conjugationDrill'],
        vocab: ['recognition', 'production', 'recall', 'readingComp', 'listening'],
        kanji: ['recognition', 'production', 'recall', 'readingComp'],
        conjugation: ['conjugationDrill', 'recognition', 'recall', 'production'],
      },
      items: [
        ['grammar', 'N5', 'grammar:n5:1'],
        ['vocab', 'N5', 'vocab:n5:1'],
        ['kanji', 'N5', 'kanji:n5:日'],
        ['conjugation', 'N5', 'conjugation:n5:食べる'],
        ['grammar', 'N4', 'grammar:n4:1'],
      ],
    },
    vocabEntries: [
      { vocabId: 'v1', term: '雨', reading: 'あめ', level: 'N5' },
      { vocabId: 'v2', term: '飴', reading: 'あめ', level: 'N5' },
      { vocabId: 'v3', term: '橋', reading: 'はし', level: 'N5' },
      { vocabId: 'v4', term: '箸', reading: 'はし', level: 'N5' },
      { vocabId: 'v5', term: '花', reading: 'はな', level: 'N5' },
      { vocabId: 'v6', term: '鼻', reading: 'はな', level: 'N5' },
    ],
  });

  assert.equal(review.sampleCount, 20);
  assert.equal(review.failures.length, 0);
  assert.equal(review.samples.every((sample) => sample.verdict === 'pass'), true);
});

test('formatExerciseSampleReviewMarkdown includes verdict and counts', () => {
  const markdown = formatExerciseSampleReviewMarkdown({
    generatedAt: '2026-05-21T09:10:00+07:00',
    sampleCount: 1,
    failures: [],
    samples: [
      {
        category: 'reading',
        target: 'rc-n5-001',
        distractors: '3 options',
        observation: 'correct index valid',
        verdict: 'pass',
      },
    ],
  });

  assert.match(markdown, /Phase 4 Exercise Sample Review/);
  assert.match(markdown, /Sample count: `1`/);
  assert.match(markdown, /PASS/);
});
