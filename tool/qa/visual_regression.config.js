#!/usr/bin/env node
'use strict';

const path = require('node:path');

const repoRoot = path.resolve(__dirname, '../..');

const visualRegressionThreshold = 0.01;

const visualRegressionBaselineDir = path.join(
  repoRoot,
  'docs/qa/visual-baselines/phase7',
);

const visualRegressionCurrentDir = path.join(
  repoRoot,
  'output/playwright/phase7/current',
);

const visualRegressionViewports = [
  { width: 360, height: 640, name: 'mobile' },
  { width: 768, height: 1024, name: 'tablet_portrait' },
  { width: 1024, height: 768, name: 'tablet_landscape' },
  { width: 1280, height: 800, name: 'desktop' },
  { width: 1600, height: 900, name: 'wide_desktop' },
  { width: 1920, height: 1080, name: 'ultra_wide' },
];

const visualRegressionPages = [
  { name: 'home', route: '/#/', ready: /Kế hoạch|Học tiếp|Ôn tập|Nổi bật/ },
  { name: 'level-home', route: '/#/', ready: /Kế hoạch|Học tiếp|Ôn tập|Nổi bật/ },
  { name: 'textbook-vocab', route: '/#/vocab', ready: /Hajimete|Minna|Từ vựng/ },
  { name: 'lesson', route: '/#/lesson/1?level=N5', ready: /Bài 1|Flashcard|Từ vựng/ },
  { name: 'grammar-detail', route: '/#/grammar/1', ready: /KẾT NỐI|Luyện tập|Liên quan/ },
  { name: 'vocab-detail', route: '/#/vocab/1', ready: /Nghĩa|Gói học nhanh|Liên quan/ },
  { name: 'kanji-graph', route: '/#/kanji/%E6%B5%B7/graph', ready: /Mạng|Luyện cụm|liên quan/i },
  { name: 'conjugation', route: '/#/grammar/conjugation', ready: /Chia thể|động từ|tính từ/i },
  { name: 'flashcard-mode', route: '/#/lesson/1/flashcards-enhanced?level=N5', ready: /Flashcard|Lật|Từ vựng/ },
  { name: 'mcq-mode', route: '/#/lesson/1/practice/mcq?level=N5', ready: /Câu|Kiểm tra|Trả lời/ },
  { name: 'matching-mode', route: '/#/lesson/1/match-mode?level=N5', ready: /Ghép|Matching|Từ vựng/ },
  { name: 'typing-mode', route: '/#/lesson/1/write-mode?level=N5', ready: /Viết|Gõ|Từ vựng/ },
  { name: 'writing-mode', route: '/#/practice/handwriting', ready: /Viết|Handwriting|Hán tự/ },
  { name: 'dokkai-mode', route: '/#/jlpt/reading', ready: /Đọc hiểu|JLPT|Câu hỏi/ },
  { name: 'conjugation-drill', route: '/#/grammar/conjugation/practice', ready: /Câu|Chia thể|Trả lời/i },
];

module.exports = {
  visualRegressionBaselineDir,
  visualRegressionCurrentDir,
  visualRegressionPages,
  visualRegressionThreshold,
  visualRegressionViewports,
};
