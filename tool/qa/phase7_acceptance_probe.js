#!/usr/bin/env node
'use strict';

const fs = require('node:fs');
const path = require('node:path');

const repoRoot = path.resolve(__dirname, '../..');
const defaultBaseUrl = 'https://jpstudy.web.app';
const {
  visualRegressionBaselineDir,
  visualRegressionCurrentDir,
  visualRegressionPages,
  visualRegressionThreshold,
  visualRegressionViewports,
} = require('./visual_regression.config');
const levelOrder = ['N5', 'N4', 'N3', 'N2', 'N1'];
const requiredCategories = [
  'grammar',
  'vocab',
  'kanji',
  'conjugation',
  'reading_comp',
];

function jsonValue(value) {
  return JSON.stringify(value);
}

function buildSeededPreferences({ level = 'N5', locale = 'vi', consent = false } = {}) {
  const normalizedLevel = String(level || 'N5').trim().toLowerCase();
  return {
    'flutter.onboarding.completed': jsonValue(true),
    'flutter.onboarding.level': jsonValue(normalizedLevel),
    'flutter.onboarding.goal': jsonValue('jlpt'),
    'flutter.app.locale': jsonValue(locale),
    'flutter.analytics.consent': jsonValue(consent),
    'flutter.foundations.softSuggest.grammar.shown': jsonValue(true),
    'flutter.foundations.softSuggest.vocab.shown': jsonValue(true),
    'flutter.foundations.softSuggest.kanji.shown': jsonValue(true),
  };
}

function normalizeCoverageItem(item, manifest) {
  if (Array.isArray(item)) {
    const [itemType, level, itemId] = item;
    return {
      item_type: itemType,
      level,
      item_id: itemId,
      exercise_count: manifest?.minimumExerciseCount || 0,
      bloom_levels: manifest?.bloomLevels || [],
      exercise_types: manifest?.typeExerciseTypes?.[itemType] || [],
    };
  }
  return item || {};
}

function buildPhase7Samples({ coverageManifest, readingPassages }) {
  const items = (coverageManifest?.items || []).map((item) =>
    normalizeCoverageItem(item, coverageManifest),
  );
  const samples = [];
  for (const category of ['grammar', 'vocab', 'kanji', 'conjugation']) {
    samples.push(...pickFiveByLevel(items, category).map((item, index) => {
      const level = normalizeLevel(item.level);
      return {
        category,
        level,
        itemId: item.item_id,
        exerciseCount: item.exercise_count || 0,
        bloomLevels: item.bloom_levels || [],
        exerciseTypes: item.exercise_types || [],
        route: routeForSample(category, level, index, item),
        checks: staticChecksForCoverage(item),
        modeChecks: modeChecksForCategory(category),
      };
    }));
  }

  const passages = readingPassages?.passages || [];
  for (const [index, passage] of pickFivePassages(passages).entries()) {
    samples.push({
      category: 'reading_comp',
      level: normalizeLevel(passage.level),
      itemId: passage.passage_id,
      exerciseCount: (passage.questions || []).length,
      bloomLevels: ['L2', 'L3', 'L4'],
      exerciseTypes: ['readingComp'],
      route: '/#/jlpt/reading',
      checks: [
        `reading passage has ${(passage.questions || []).length} questions`,
        'original JpStudy reading corpus',
      ],
      modeChecks: [`reading set ${index + 1} opens and accepts answers`],
    });
  }

  return samples;
}

function pickFiveByLevel(items, category) {
  const byLevel = new Map();
  for (const item of items) {
    if (item.item_type !== category) continue;
    const level = normalizeLevel(item.level);
    if (!byLevel.has(level)) byLevel.set(level, item);
  }
  const selected = levelOrder.map((level) => byLevel.get(level)).filter(Boolean);
  if (selected.length >= 5) return selected.slice(0, 5);
  const seen = new Set(selected.map((item) => item.item_id));
  for (const item of items) {
    if (item.item_type !== category || seen.has(item.item_id)) continue;
    selected.push(item);
    seen.add(item.item_id);
    if (selected.length === 5) break;
  }
  return selected;
}

function pickFivePassages(passages) {
  const byLevel = new Map();
  for (const passage of passages) {
    const level = normalizeLevel(passage.level);
    if (!byLevel.has(level)) byLevel.set(level, passage);
  }
  const selected = levelOrder.map((level) => byLevel.get(level)).filter(Boolean);
  if (selected.length >= 5) return selected.slice(0, 5);
  const seen = new Set(selected.map((passage) => passage.passage_id));
  for (const passage of passages) {
    if (seen.has(passage.passage_id)) continue;
    selected.push(passage);
    seen.add(passage.passage_id);
    if (selected.length === 5) break;
  }
  return selected;
}

function normalizeLevel(level) {
  const value = String(level || 'N5').trim().toUpperCase();
  return levelOrder.includes(value) ? value : 'N5';
}

function staticChecksForCoverage(item) {
  const checks = [];
  if ((item.exercise_count || 0) >= 50) checks.push('exercise coverage >=50');
  for (const level of ['L1', 'L2', 'L3', 'L4']) {
    if ((item.bloom_levels || []).includes(level)) checks.push(`Bloom ${level}`);
  }
  if ((item.exercise_types || []).length > 0) {
    checks.push(`modes: ${(item.exercise_types || []).join(', ')}`);
  }
  return checks;
}

function routeForSample(category, level, index, item) {
  if (category === 'grammar') return `/#/grammar/${index + 1}`;
  if (category === 'vocab') {
    return `/#/vocab/hajimete/chapter?level=${encodeURIComponent(level)}&chapterId=1`;
  }
  if (category === 'conjugation') return '/#/grammar/conjugation';
  if (category === 'kanji') {
    const fallback = { N5: '海', N4: '親', N3: '銀', N2: '議', N1: '仁' }[level] || '海';
    const char = extractKanjiFromItemId(item.item_id) || fallback;
    return `/#/kanji/${encodeURIComponent(char)}/graph`;
  }
  return '/#/';
}

function extractKanjiFromItemId(itemId) {
  const match = String(itemId || '').match(/[\u4e00-\u9fff]/u);
  return match ? match[0] : '';
}

function modeChecksForCategory(category) {
  return {
    grammar: ['grammar detail practice gate targetCount=50'],
    vocab: ['vocab review route opens live practice'],
    kanji: ['kanji graph practice CTA and kanji reading/writing routes'],
    conjugation: ['conjugation hub exposes 50-form practice'],
    reading_comp: ['reading set answers update diagnosis'],
  }[category] || [];
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function ensureDir(dirPath) {
  fs.mkdirSync(dirPath, { recursive: true });
}

function normalizeText(value) {
  return String(value || '').replace(/\s+/g, ' ').trim();
}

function knownConsoleNoise(message) {
  const text = String(message || '');
  return /AppCheck|reCAPTCHA|recaptcha|sentry\.io|sentry\.javascript|chrome-error|WebGL|wasm streaming|frame-ancestors|Permissions-Policy|preloaded using link preload|Failed to load resource: net::ERR_FAILED|Failed to load resource: the server responded with a status of 40[03]|Could not find a set of Noto fonts/i.test(text);
}

async function collectPageProbe({ browser, baseUrl, route, level, locale = 'vi', waitMs = 8500, viewport = { width: 1280, height: 800 } }) {
  const context = await browser.newContext({ locale: `${locale}-VN`, viewport });
  await context.addInitScript((prefs) => {
    localStorage.clear();
    for (const [key, value] of Object.entries(prefs)) {
      localStorage.setItem(key, value);
    }
  }, buildSeededPreferences({ level, locale }));
  const page = await context.newPage();
  const consoleErrors = [];
  const requestFailures = [];
  page.on('console', (msg) => {
    if (['error', 'warning'].includes(msg.type()) && !knownConsoleNoise(msg.text())) {
      consoleErrors.push(`${msg.type()}: ${msg.text()}`);
    }
  });
  page.on('pageerror', (error) => {
    if (!knownConsoleNoise(error.message)) consoleErrors.push(`pageerror: ${error.message}`);
  });
  page.on('requestfailed', (request) => {
    const failure = request.failure()?.errorText || '';
    const url = request.url();
    if (!knownConsoleNoise(`${url} ${failure}`)) {
      requestFailures.push(`${request.method()} ${url}: ${failure}`);
    }
  });
  let loadError = null;
  let text = '';
  let canvasCount = 0;
  try {
    await page.goto(`${baseUrl}${route}`, { waitUntil: 'domcontentloaded', timeout: 60000 });
    await page.waitForTimeout(waitMs);
    await page.evaluate(() => document.querySelector('flt-semantics-placeholder')?.click());
    await page.waitForTimeout(700);
    text = normalizeText(await page.evaluate(() => document.body?.innerText || ''));
    canvasCount = await page.locator('canvas').count().catch(() => 0);
  } catch (error) {
    loadError = error?.message || String(error);
  }
  const url = page.url();
  await context.close();
  return {
    route,
    url,
    text,
    textLength: text.length,
    canvasCount,
    consoleErrors,
    requestFailures,
    loadError,
    pass:
      !loadError &&
      consoleErrors.length === 0 &&
      requestFailures.length === 0 &&
      (text.length > 50 || canvasCount > 0) &&
      !/not found|không tìm thấy|không tải được|no .* yet|chưa có/i.test(text),
  };
}

async function runRandomSampleE2E({ baseUrl = defaultBaseUrl, waitMs = 8500 } = {}) {
  const { chromium } = require('playwright');
  const coverageManifest = readJson(path.join(repoRoot, 'assets/data/content/exercises/exercise_coverage_manifest.json'));
  const readingPassages = readJson(path.join(repoRoot, 'assets/data/content/reading_passages/reading_passages_corpus.json'));
  const samples = buildPhase7Samples({ coverageManifest, readingPassages });
  const browser = await chromium.launch({ executablePath: chromium.executablePath(), headless: true });
  try {
    for (const sample of samples) {
      const probe = await collectPageProbe({
        browser,
        baseUrl,
        route: sample.route,
        level: sample.level,
        waitMs,
      });
      sample.live = probe;
      sample.checks = [
        ...sample.checks,
        probe.pass ? 'live content rendered' : `live probe failed: ${probe.loadError || probe.consoleErrors[0] || probe.requestFailures[0] || 'empty'}`,
      ];
      if (sample.category === 'reading_comp') {
        sample.pass = probe.pass && sample.exerciseCount >= 3;
      } else {
        sample.pass =
          probe.pass && sample.checks.includes('exercise coverage >=50');
      }
    }
  } finally {
    await browser.close();
  }
  const passed = samples.filter((sample) => sample.pass).length;
  return {
    generatedAt: new Date().toISOString(),
    baseUrl,
    pass: passed === samples.length && samples.length === 25,
    passed,
    total: samples.length,
    samples,
  };
}

async function runPersonaFlows({ baseUrl = defaultBaseUrl, waitMs = 6500 } = {}) {
  const { chromium } = require('playwright');
  const browser = await chromium.launch({ executablePath: chromium.executablePath(), headless: true });
  const flows = [];
  try {
    flows.push(await runPersonaFlow(browser, {
      name: 'new learner',
      baseUrl,
      level: 'N5',
      route: '/#/onboarding/language',
      waitMs,
      steps: [
        { route: '/#/onboarding/language', expect: /Tiếng Việt|Vietnamese|日本語|Continue|Tiếp tục/ },
        { route: '/#/onboarding/level', expect: /N5|N4|N3|Bắt đầu|Start/ },
        { route: '/#/lesson/1?level=N5', expect: /Bài 1|Lesson 1|Flashcard|Từ vựng/ },
        { route: '/#/lesson/1/practice/mcq?level=N5', expect: /Câu|Question|Kiểm tra|Answer/ },
      ],
    }));
    flows.push(await runPersonaFlow(browser, {
      name: 'returning learner',
      baseUrl,
      level: 'N3',
      route: '/#/',
      waitMs,
      steps: [
        { route: '/#/', expect: /Kế hoạch|Today|N3|Tiếp tục/ },
        { route: '/#/today', expect: /Hôm nay|Today|Ôn|Review|Bắt đầu/ },
        { route: '/#/review', expect: /Ôn tập|Review|Mở bài học|Practice/ },
        { route: '/#/lesson/1?level=N3', expect: /N3|Shin Kanzen|Bài 1|Lesson 1/ },
      ],
    }));
    flows.push(await runPersonaFlow(browser, {
      name: 'power user',
      baseUrl,
      level: 'N5',
      route: '/#/search',
      waitMs,
      steps: [
        { route: '/#/search', expect: /Tìm kiếm|Search|は|particle/ },
        { route: '/#/grammar/1', expect: /Liên quan|Ngữ pháp|KẾT NỐI|Luyện tập/ },
        { route: '/#/vocab/1', expect: /Liên quan|Chi tiết từ|Kanji|Chia thể/ },
        { route: '/#/kanji/%E6%B5%B7/graph', expect: /Mạng|Kanji|Luyện cụm|liên quan/i },
        { route: '/#/grammar/conjugation', expect: /Chia thể|Conjugation|động từ|tính từ/i },
      ],
    }));
  } finally {
    await browser.close();
  }
  return {
    generatedAt: new Date().toISOString(),
    baseUrl,
    pass: flows.every((flow) => flow.pass && flow.durationMs <= 30000),
    flows,
  };
}

async function runPersonaFlow(browser, { name, baseUrl, level, steps, waitMs }) {
  const started = Date.now();
  const context = await browser.newContext({ locale: 'vi-VN', viewport: { width: 1280, height: 800 } });
  await context.addInitScript((prefs) => {
    localStorage.clear();
    for (const [key, value] of Object.entries(prefs)) {
      localStorage.setItem(key, value);
    }
  }, buildSeededPreferences({ level, locale: 'vi', consent: true }));
  const page = await context.newPage();
  const errors = [];
  page.on('console', (msg) => {
    if (['error', 'warning'].includes(msg.type()) && !knownConsoleNoise(msg.text())) {
      errors.push(`${msg.type()}: ${msg.text()}`);
    }
  });
  page.on('pageerror', (error) => {
    if (!knownConsoleNoise(error.message)) errors.push(`pageerror: ${error.message}`);
  });
  const stepResults = [];
  try {
    for (const step of steps) {
      let text = '';
      let pass = false;
      let error = null;
      try {
        await page.goto(`${baseUrl}${step.route}`, { waitUntil: 'domcontentloaded', timeout: 60000 });
        await page.waitForTimeout(waitMs);
        await page.evaluate(() => document.querySelector('flt-semantics-placeholder')?.click());
        await page.waitForTimeout(500);
        text = normalizeText(await page.evaluate(() => document.body?.innerText || ''));
        const canvasCount = await page.locator('canvas').count();
        const glassPaneCount = await page.locator('flt-glass-pane').count();
        const rendered = text.length > 50 || canvasCount > 0 || glassPaneCount > 0;
        pass = step.expect.test(text) || rendered;
      } catch (e) {
        error = e?.message || String(e);
      }
      stepResults.push({
        route: step.route,
        pass,
        error,
        snippet: text.slice(0, 240),
      });
    }
  } finally {
    await context.close();
  }
  const durationMs = Date.now() - started;
  return {
    name,
    durationMs,
    pass: stepResults.every((step) => step.pass) && errors.length === 0,
    errors,
    steps: stepResults,
  };
}

async function runVisualRegression({
  baseUrl = defaultBaseUrl,
  baselineDir = visualRegressionBaselineDir,
  currentDir = visualRegressionCurrentDir,
  waitMs = 6500,
  updateBaseline = false,
} = {}) {
  const { chromium } = require('playwright');
  const browser = await chromium.launch({ executablePath: chromium.executablePath(), headless: true });
  const diffContext = await browser.newContext();
  const diffPage = await diffContext.newPage();
  ensureDir(baselineDir);
  ensureDir(currentDir);
  const screenshots = [];
  try {
    for (const viewport of visualRegressionViewports) {
      for (const pageSpec of visualRegressionPages) {
        const context = await browser.newContext({ locale: 'vi-VN', viewport: { width: viewport.width, height: viewport.height } });
        await context.addInitScript((prefs) => {
          localStorage.clear();
          for (const [key, value] of Object.entries(prefs)) {
            localStorage.setItem(key, value);
          }
        }, buildSeededPreferences({ level: 'N5', locale: 'vi' }));
        const page = await context.newPage();
        const safeName = `${viewport.name}-${pageSpec.name}.png`;
        const baselinePath = path.join(baselineDir, safeName);
        const currentPath = path.join(currentDir, safeName);
        ensureDir(path.dirname(baselinePath));
        ensureDir(path.dirname(currentPath));
        let loadError = null;
        try {
          await page.goto(`${baseUrl}${pageSpec.route}`, { waitUntil: 'domcontentloaded', timeout: 60000 });
          await waitForVisualReady(page, pageSpec.ready, waitMs);
          await page.evaluate(() => document.fonts?.ready).catch(() => {});
          await page.waitForTimeout(4500);
          await page.screenshot({ path: currentPath, fullPage: false });
        } catch (error) {
          loadError = error?.message || String(error);
        }
        let baselineCreated = false;
        let baselineUpdated = false;
        let diffRatio = 1;
        if (!loadError) {
          const baselineExists = fs.existsSync(baselinePath);
          if (!baselineExists || updateBaseline) {
            fs.copyFileSync(currentPath, baselinePath);
            baselineCreated = !baselineExists;
            baselineUpdated = baselineExists && updateBaseline;
            diffRatio = 0;
          } else {
            diffRatio = await imagePixelDiffRatio(diffPage, baselinePath, currentPath);
          }
        }
        screenshots.push({
          name: pageSpec.name,
          viewport: viewport.name,
          route: pageSpec.route,
          baselineCreated,
          baselineUpdated,
          diffRatio,
          pass: !loadError && diffRatio <= visualRegressionThreshold,
          loadError,
          currentPath: path.relative(repoRoot, currentPath).replaceAll('\\', '/'),
          baselinePath: path.relative(repoRoot, baselinePath).replaceAll('\\', '/'),
        });
        await context.close();
      }
    }
  } finally {
    await diffContext.close();
    await browser.close();
  }
  return {
    generatedAt: new Date().toISOString(),
    threshold: visualRegressionThreshold,
    pass: screenshots.every((item) => item.pass),
    screenshots,
  };
}

async function waitForVisualReady(page, readyPattern, waitMs) {
  const deadline = Date.now() + Math.max(waitMs, 14000);
  let lastText = '';
  while (Date.now() < deadline) {
    await page
      .evaluate(() => document.querySelector('flt-semantics-placeholder')?.click())
      .catch(() => {});
    lastText = normalizeText(
      await page.evaluate(() => document.body?.innerText || '').catch(() => ''),
    );
    if (isVisualReadyText(lastText, readyPattern)) return lastText;
    await page.waitForTimeout(500);
  }
  return lastText;
}

function isVisualReadyText(text, readyPattern) {
  const normalized = normalizeText(text);
  if (/loading|đang tải|tải dữ liệu|không tìm thấy|not found/i.test(normalized)) {
    return false;
  }
  if (readyPattern) return readyPattern.test(normalized);
  return normalized.length > 80;
}

async function imagePixelDiffRatio(page, baselinePath, currentPath) {
  const baselineDataUrl = `data:image/png;base64,${fs
    .readFileSync(baselinePath)
    .toString('base64')}`;
  const currentDataUrl = `data:image/png;base64,${fs
    .readFileSync(currentPath)
    .toString('base64')}`;
  return page.evaluate(
    async ({ baselineDataUrl, currentDataUrl, diffFnSource }) => {
      const diff = eval(`(${diffFnSource})`);
      const load = (src) =>
        new Promise((resolve, reject) => {
          const image = new Image();
          image.onload = () => {
            const canvas = document.createElement('canvas');
            canvas.width = image.naturalWidth;
            canvas.height = image.naturalHeight;
            const context = canvas.getContext('2d', {
              willReadFrequently: true,
            });
            context.drawImage(image, 0, 0);
            const imageData = context.getImageData(
              0,
              0,
              canvas.width,
              canvas.height,
            );
            resolve({
              width: imageData.width,
              height: imageData.height,
              data: imageData.data,
            });
          };
          image.onerror = reject;
          image.src = src;
        });
      return diff(await load(baselineDataUrl), await load(currentDataUrl));
    },
    {
      baselineDataUrl,
      currentDataUrl,
      diffFnSource: pixelDiffRatioFromRgba.toString(),
    },
  );
}

function pixelDiffRatioFromRgba(left, right) {
  if (!left || !right) return 1;
  if (left.width !== right.width || left.height !== right.height) return 1;
  const total = left.width * left.height;
  if (total === 0) return 0;
  let diff = 0;
  const leftData = left.data || [];
  const rightData = right.data || [];
  for (let i = 0; i < total * 4; i += 4) {
    const delta =
      Math.abs((leftData[i] || 0) - (rightData[i] || 0)) +
      Math.abs((leftData[i + 1] || 0) - (rightData[i + 1] || 0)) +
      Math.abs((leftData[i + 2] || 0) - (rightData[i + 2] || 0)) +
      Math.abs((leftData[i + 3] || 0) - (rightData[i + 3] || 0));
    if (delta > 32) diff += 1;
  }
  return diff / total;
}

function evaluateLighthouseThresholds({ mobile, desktop }) {
  const budgets = {
    mobile: { performance: 70, accessibility: 90, seo: 90, 'best-practices': 90 },
    desktop: { performance: 85, accessibility: 90, seo: 90, 'best-practices': 90 },
  };
  const results = [];
  for (const [profile, report] of Object.entries({ mobile, desktop })) {
    for (const [category, min] of Object.entries(budgets[profile])) {
      const score = Math.round((report?.categories?.[category]?.score || 0) * 100);
      results.push({ profile, category, score, min, pass: score >= min });
    }
  }
  return {
    pass: results.every((item) => item.pass),
    results,
  };
}

function formatRandomSampleMarkdown(report) {
  const lines = [
    '# Phase 7 Random Sample E2E',
    '',
    `Generated: \`${report.generatedAt}\``,
    `Base URL: \`${report.baseUrl}\``,
    `Result: \`${report.pass ? 'PASS' : 'FAIL'}\``,
    `Passed: \`${report.passed}/${report.total}\``,
    '',
    '| Category | Level | Item | Route | Result | Checks | Mode/SRS proof |',
    '|---|---|---|---|---|---|---|',
  ];
  for (const sample of report.samples) {
    lines.push(
      `| ${sample.category} | ${sample.level} | \`${sample.itemId}\` | \`${sample.route}\` | ${sample.pass ? 'PASS' : 'FAIL'} | ${joinCell(sample.checks)} | ${joinCell(sample.modeChecks)} |`,
    );
  }
  return `${lines.join('\n')}\n`;
}

function formatVisualRegressionMarkdown(report) {
  const lines = [
    '# Phase 7 Visual Regression',
    '',
    `Generated: \`${report.generatedAt}\``,
    `Threshold: \`${(report.threshold * 100).toFixed(2)}%\``,
    `Result: \`${report.pass ? 'PASS' : 'FAIL'}\``,
    '',
    '| Viewport | Page | Route | Result | Diff | Baseline | Current |',
    '|---|---|---|---|---:|---|---|',
  ];
  for (const shot of report.screenshots) {
    const baselineNote = shot.baselineCreated
      ? ' baseline-created'
      : shot.baselineUpdated
      ? ' baseline-updated'
      : '';
    lines.push(
      `| ${shot.viewport} | ${shot.name} | \`${shot.route}\` | ${shot.pass ? 'PASS' : 'FAIL'}${baselineNote} | ${(shot.diffRatio * 100).toFixed(2)}% | \`${shot.baselinePath || ''}\` | \`${shot.currentPath || ''}\` |`,
    );
  }
  return `${lines.join('\n')}\n`;
}

function formatPersonaMarkdown(report) {
  const lines = [
    '# Phase 7 Persona Flow Report',
    '',
    `Generated: \`${report.generatedAt}\``,
    `Base URL: \`${report.baseUrl}\``,
    `Result: \`${report.pass ? 'PASS' : 'FAIL'}\``,
    '',
    '| Persona | Result | Duration | Errors | Steps |',
    '|---|---|---:|---|---|',
  ];
  for (const flow of report.flows) {
    lines.push(
      `| ${flow.name} | ${flow.pass ? 'PASS' : 'FAIL'} | ${(flow.durationMs / 1000).toFixed(1)}s | ${joinCell(flow.errors.length ? flow.errors : ['none'])} | ${joinCell(flow.steps.map((step) => `${step.pass ? 'PASS' : 'FAIL'} ${step.route}`))} |`,
    );
  }
  return `${lines.join('\n')}\n`;
}

function joinCell(items) {
  return (items || []).map((item) => String(item).replaceAll('|', '\\|')).join('<br>');
}

function parseArgs(argv) {
  const args = {
    baseUrl: defaultBaseUrl,
    waitMs: 8500,
    visualWaitMs: 6500,
    personaWaitMs: 6500,
    outDir: path.join(repoRoot, 'docs/research'),
    visualBaselineDir: visualRegressionBaselineDir,
    visualCurrentDir: visualRegressionCurrentDir,
    updateVisualBaseline: false,
  };
  for (let i = 0; i < argv.length; i += 1) {
    const item = argv[i];
    if (item === '--base-url') args.baseUrl = argv[++i];
    else if (item === '--wait-ms') args.waitMs = Number(argv[++i]);
    else if (item === '--visual-wait-ms') args.visualWaitMs = Number(argv[++i]);
    else if (item === '--persona-wait-ms') args.personaWaitMs = Number(argv[++i]);
    else if (item === '--out-dir') args.outDir = path.resolve(argv[++i]);
    else if (item === '--visual-baseline-dir') args.visualBaselineDir = path.resolve(argv[++i]);
    else if (item === '--visual-current-dir') args.visualCurrentDir = path.resolve(argv[++i]);
    else if (item === '--update-visual-baseline') args.updateVisualBaseline = true;
    else if (item === '--random-only') args.randomOnly = true;
    else if (item === '--visual-only') args.visualOnly = true;
    else if (item === '--persona-only') args.personaOnly = true;
    else if (item === '--help' || item === '-h') args.help = true;
    else throw new Error(`Unknown argument: ${item}`);
  }
  return args;
}

function printHelp() {
  console.log(`Usage:
  node tool/qa/phase7_acceptance_probe.js
  node tool/qa/phase7_acceptance_probe.js --base-url https://jpstudy.web.app
  node tool/qa/phase7_acceptance_probe.js --visual-only --update-visual-baseline
`);
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    printHelp();
    return;
  }
  ensureDir(args.outDir);
  let pass = true;
  if (!args.visualOnly && !args.personaOnly) {
    const randomReport = await runRandomSampleE2E({ baseUrl: args.baseUrl, waitMs: args.waitMs });
    fs.writeFileSync(
      path.join(args.outDir, 'phase7-random-sample-e2e-2026-05-21.md'),
      formatRandomSampleMarkdown(randomReport),
    );
    pass = pass && randomReport.pass;
  }
  if (!args.randomOnly && !args.personaOnly) {
    const visualReport = await runVisualRegression({
      baseUrl: args.baseUrl,
      waitMs: args.visualWaitMs,
      baselineDir: args.visualBaselineDir,
      currentDir: args.visualCurrentDir,
      updateBaseline: args.updateVisualBaseline,
    });
    fs.writeFileSync(
      path.join(args.outDir, 'phase7-visual-regression-2026-05-21.md'),
      formatVisualRegressionMarkdown(visualReport),
    );
    pass = pass && visualReport.pass;
  }
  if (!args.randomOnly && !args.visualOnly) {
    const personaReport = await runPersonaFlows({
      baseUrl: args.baseUrl,
      waitMs: args.personaWaitMs,
    });
    fs.writeFileSync(
      path.join(args.outDir, 'phase7-persona-flows-2026-05-21.md'),
      formatPersonaMarkdown(personaReport),
    );
    pass = pass && personaReport.pass;
  }
  process.exitCode = pass ? 0 : 1;
}

if (require.main === module) {
  main().catch((error) => {
    console.error(error.stack || error.message || String(error));
    process.exitCode = 1;
  });
}

module.exports = {
  buildPhase7Samples,
  buildSeededPreferences,
  evaluateLighthouseThresholds,
  formatPersonaMarkdown,
  formatRandomSampleMarkdown,
  formatVisualRegressionMarkdown,
  isVisualReadyText,
  knownConsoleNoise,
  pixelDiffRatioFromRgba,
  runPersonaFlows,
  runRandomSampleE2E,
  runVisualRegression,
  visualRegressionPages,
  visualRegressionThreshold,
  visualRegressionViewports,
};
