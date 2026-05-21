const assert = require('node:assert/strict');
const test = require('node:test');

const {
  buildPhase7Samples,
  buildSeededPreferences,
  evaluateLighthouseThresholds,
  formatRandomSampleMarkdown,
  formatVisualRegressionMarkdown,
  isVisualReadyText,
  knownConsoleNoise,
  pixelDiffRatioFromRgba,
  visualRegressionViewports,
} = require('../../../tool/qa/phase7_acceptance_probe');

test('buildSeededPreferences prepares an onboarded VI learner', () => {
  const prefs = buildSeededPreferences({ level: 'N3', locale: 'vi' });

  assert.equal(prefs['flutter.onboarding.completed'], 'true');
  assert.equal(prefs['flutter.onboarding.level'], '"n3"');
  assert.equal(prefs['flutter.app.locale'], '"vi"');
  assert.equal(prefs['flutter.analytics.consent'], 'false');
});

test('visual regression config covers six H.7 viewports', () => {
  assert.deepEqual(
    visualRegressionViewports.map((viewport) => viewport.width),
    [360, 768, 1024, 1280, 1600, 1920],
  );
});

test('buildPhase7Samples selects five rows per required category', () => {
  const samples = buildPhase7Samples({
    coverageManifest: {
      minimumExerciseCount: 50,
      bloomLevels: ['L1', 'L2', 'L3', 'L4'],
      typeExerciseTypes: {
        grammar: ['recognition'],
        vocab: ['recognition'],
        kanji: ['recognition'],
        conjugation: ['conjugationDrill'],
      },
      items: [
        ...Array.from({ length: 5 }, (_, i) => ['grammar', 'N5', `grammar:n5:${i + 1}`]),
        ...Array.from({ length: 5 }, (_, i) => ['vocab', 'N5', `vocab:n5:${i + 1}`]),
        ...Array.from({ length: 5 }, (_, i) => ['kanji', 'N5', `kanji:n5:${i + 1}:海`]),
        ...Array.from({ length: 5 }, (_, i) => ['conjugation', 'N5', `conjugation:n5:${i + 1}`]),
      ],
    },
    readingPassages: {
      passages: Array.from({ length: 5 }, (_, i) => ({
        passage_id: `rc-n5-${i + 1}`,
        level: 'N5',
        questions: [{}, {}, {}],
      })),
    },
  });

  assert.equal(samples.length, 25);
  assert.deepEqual(
    Object.fromEntries(
      ['grammar', 'vocab', 'kanji', 'conjugation', 'reading_comp'].map((category) => [
        category,
        samples.filter((sample) => sample.category === category).length,
      ]),
    ),
    {
      grammar: 5,
      vocab: 5,
      kanji: 5,
      conjugation: 5,
      reading_comp: 5,
    },
  );
  const vocabRoutes = samples
    .filter((sample) => sample.category === 'vocab')
    .map((sample) => sample.route);
  assert.ok(
    vocabRoutes.every((route) =>
      /^\/#\/vocab\/hajimete\/chapter\?level=N5&chapterId=1$/.test(route),
    ),
  );
});

test('formatRandomSampleMarkdown reports pass counts and failures', () => {
  const markdown = formatRandomSampleMarkdown({
    generatedAt: '2026-05-21T12:00:00+07:00',
    baseUrl: 'https://jpstudy.web.app',
    pass: true,
    passed: 25,
    total: 25,
    samples: [
      {
        category: 'grammar',
        itemId: 'grammar:n5:1',
        level: 'N5',
        route: '/#/grammar/1',
        pass: true,
        checks: ['content rendered', 'related links present'],
        modeChecks: ['grammar practice opened'],
      },
    ],
  });

  assert.match(markdown, /Phase 7 Random Sample E2E/);
  assert.match(markdown, /Result: `PASS`/);
  assert.match(markdown, /Passed: `25\/25`/);
  assert.match(markdown, /grammar practice opened/);
});

test('formatVisualRegressionMarkdown records first-run baselines', () => {
  const markdown = formatVisualRegressionMarkdown({
    generatedAt: '2026-05-21T12:00:00+07:00',
    pass: true,
    threshold: 0.01,
    screenshots: [
      {
        name: 'home',
        viewport: 'mobile',
        route: '/#/',
        baselineCreated: true,
        diffRatio: 0,
        pass: true,
      },
    ],
  });

  assert.match(markdown, /Phase 7 Visual Regression/);
  assert.match(markdown, /baseline-created/);
  assert.match(markdown, /0\.00%/);
});

test('pixelDiffRatioFromRgba compares decoded pixels instead of PNG bytes', () => {
  const left = {
    width: 2,
    height: 1,
    data: Uint8ClampedArray.from([255, 255, 255, 255, 0, 0, 0, 255]),
  };
  const samePixels = {
    width: 2,
    height: 1,
    data: Uint8ClampedArray.from([255, 255, 255, 255, 1, 1, 1, 255]),
  };
  const changedOnePixel = {
    width: 2,
    height: 1,
    data: Uint8ClampedArray.from([255, 255, 255, 255, 255, 0, 0, 255]),
  };

  assert.equal(pixelDiffRatioFromRgba(left, samePixels), 0);
  assert.equal(pixelDiffRatioFromRgba(left, changedOnePixel), 0.5);
});

test('isVisualReadyText rejects loading and accepts route-specific content', () => {
  assert.equal(isVisualReadyText('Chi tiết từ Đang tải dữ liệu', /Nghĩa/), false);
  assert.equal(
    isVisualReadyText('Chi tiết từ Nghĩa tôi Gói học nhanh Liên quan', /Nghĩa/),
    true,
  );
  assert.equal(isVisualReadyText('Không tìm thấy từ', /Nghĩa/), false);
});

test('evaluateLighthouseThresholds applies Phase 7 budgets', () => {
  const report = evaluateLighthouseThresholds({
    mobile: {
      categories: {
        performance: { score: 0.7 },
        accessibility: { score: 0.9 },
        seo: { score: 0.9 },
        'best-practices': { score: 0.9 },
      },
    },
    desktop: {
      categories: {
        performance: { score: 0.85 },
        accessibility: { score: 0.95 },
        seo: { score: 0.95 },
        'best-practices': { score: 0.95 },
      },
    },
  });

  assert.equal(report.pass, true);
  assert.equal(report.results.length, 8);
});

test('knownConsoleNoise filters headless telemetry noise only', () => {
  assert.equal(
    knownConsoleNoise(
      "Access to fetch at 'https://o0.ingest.us.sentry.io/api/envelope/' from origin has been blocked by CORS policy",
    ),
    true,
  );
  assert.equal(knownConsoleNoise('Failed to load resource: net::ERR_FAILED'), true);
  assert.equal(knownConsoleNoise('TypeError: Cannot read properties of null'), false);
});
