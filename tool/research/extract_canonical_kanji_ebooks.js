#!/usr/bin/env node

const childProcess = require('node:child_process');
const fs = require('node:fs');
const path = require('node:path');

const repoRoot = path.resolve(__dirname, '../..');
const popplerBin =
  'C:\\Users\\xboxo\\AppData\\Local\\Microsoft\\WinGet\\Packages\\oschwartz10612.Poppler_Microsoft.Winget.Source_8wekyb3d8bbwe\\poppler-25.07.0\\Library\\bin';
const tesseractExe = 'C:\\Program Files\\Tesseract-OCR\\tesseract.exe';
const tessdataDir = path.join(repoRoot, 'tmp', 'tessdata');

const ebookSources = {
  N5: {
    family: 'large-card',
    pdf: 'C:\\Users\\xboxo\\Desktop\\PC\\Tai lieu JPStudy\\Ebook\\Ebook_N5_[thocodehoctiengnhat].pdf - Google Drive.pdf',
  },
  N4: {
    family: 'writing-grid',
    pdf: 'C:\\Users\\xboxo\\Desktop\\PC\\Tai lieu JPStudy\\Ebook\\jlpt_n4_[thocodehoctiengnhat].pdf',
  },
  N3: {
    family: 'large-card',
    pdf: 'C:\\Users\\xboxo\\Desktop\\PC\\Tai lieu JPStudy\\Ebook\\ebook_kanji_n3_[thocodehoctiengnhat].pdf - Google Drive.pdf',
  },
  N2: {
    family: 'large-card',
    parts: [
      {
        id: 'N2-part1',
        pdf: 'C:\\Users\\xboxo\\Desktop\\PC\\Tai lieu JPStudy\\Ebook\\[1]ebook_kanji_n2_[thocodehoctiengnhat].pdf - Google Drive.pdf',
      },
      {
        id: 'N2-part2',
        pdf: 'C:\\Users\\xboxo\\Desktop\\PC\\Tai lieu JPStudy\\Ebook\\[2]ebook_kanji_n2_[thocodehoctiengnhat].pdf - Google Drive.pdf',
      },
    ],
  },
  N1: {
    family: 'writing-grid',
    pdf: 'C:\\Users\\xboxo\\Desktop\\PC\\Tai lieu JPStudy\\Ebook\\jlpt_n1_[thocodehoctiengnhat].pdf',
  },
};

function stripAccents(value) {
  return String(value || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/đ/g, 'd')
    .replace(/Đ/g, 'D');
}

function normalizeSpaces(value) {
  return String(value || '').replace(/\s+/g, ' ').trim();
}

function normalizeForMatch(value) {
  return stripAccents(value).toLowerCase();
}

function titleCaseVietnamese(value) {
  const cleaned = normalizeSpaces(
    String(value || '')
      .replace(/^[^A-Za-zÀ-ỹĐđ]+/, '')
      .replace(/[^A-Za-zÀ-ỹĐđ\s/-]+$/g, ''),
  );
  if (!cleaned) return '';
  return cleaned
    .split(/\s+/)
    .map((word) => {
      if (word.includes('/')) {
        return word
          .split('/')
          .map((part) => titleCaseVietnamese(part))
          .join('/');
      }
      return word.charAt(0).toLocaleUpperCase('vi-VN') +
        word.slice(1).toLocaleLowerCase('vi-VN');
    })
    .join(' ');
}

function cjkChars(value) {
  return Array.from(String(value || '').matchAll(/[\u3400-\u9fff\uf900-\ufaff]/gu))
    .map((match) => match[0]);
}

function kanaTokens(value) {
  return Array.from(
    String(value || '').matchAll(/[ぁ-んァ-ンー][ぁ-んァ-ンー・.]*/gu),
  )
    .map((match) => normalizeSpaces(match[0]).replace(/\s+/g, ''))
    .filter((token) => token.length > 0 && token !== 'ー')
    .filter((token, index, tokens) => tokens.indexOf(token) === index);
}

function isTitleCandidate(line) {
  const norm = normalizeForMatch(line);
  if (
    !line ||
    norm.includes('onyomi') ||
    norm.includes('kunyomi') ||
    norm.includes('tu vung') ||
    norm.includes('cach nho') ||
    norm.includes('bien tap') ||
    norm.includes('jlpt')
  ) {
    return false;
  }
  if (/[a-z]/.test(stripAccents(line))) return false;
  const letters = String(line).match(/[\p{Lu}Đ]{2,}(?:\s+[\p{Lu}Đ]{2,})*/gu);
  if (!letters) return false;
  return letters.some((token) => token.trim().length >= 2);
}

function extractTitleFromLines(lines) {
  for (const line of lines.slice(0, 4)) {
    if (!isTitleCandidate(line)) continue;
    const matches = Array.from(
      String(line).matchAll(/[\p{Lu}Đ]{2,}(?:\s+[\p{Lu}Đ]{2,})*/gu),
    )
      .map((match) => match[0])
      .filter((token) => !/NGH|ONYOMI|KUNYOMI|JLPT/.test(stripAccents(token)));
    if (matches.length > 0) return titleCaseVietnamese(matches[0]);
  }
  return '';
}

function extractMeaning(segment) {
  const line = segment
    .split(/\r?\n/)
    .find((item) => normalizeForMatch(item).includes('nghia'));
  if (!line) return '';
  const after = line.replace(/^.*?ngh[ĩi]a\s*[:：]?\s*/i, '');
  const cleaned = normalizeSpaces(
    after
      .replace(/[|!'"`]+/g, '')
      .replace(/[\u3400-\u9fff\uf900-\ufaff].*$/u, '')
      .replace(/[ぁ-んァ-ンー].*$/u, ''),
  );
  return cleaned.length > 1 ? titleCaseVietnamese(cleaned) : '';
}

function countCandidates(chars) {
  const counts = new Map();
  for (const char of chars) counts.set(char, (counts.get(char) || 0) + 1);
  return Array.from(counts.entries()).sort((a, b) => {
    if (b[1] !== a[1]) return b[1] - a[1];
    return 0;
  });
}

function chooseDominantKanji(segment) {
  const chars = cjkChars(segment);
  if (chars.length === 0) return '';
  const counts = countCandidates(chars);
  return counts[0][0];
}

function splitLargeCardSegments(text) {
  const lines = String(text || '').split(/\r?\n/);
  const starts = [];
  for (let i = 0; i < lines.length; i++) {
    const norm = normalizeForMatch(lines[i]);
    if (!norm.includes('onyomi')) continue;
    let start = i;
    while (start > 0 && !isTitleCandidate(lines[start - 1])) {
      if (normalizeForMatch(lines[start - 1]).includes('nghia')) break;
      start--;
      if (i - start > 4) break;
    }
    if (start > 0 && normalizeForMatch(lines[start - 1]).includes('nghia')) {
      start -= 1;
    }
    if (start > 0 && normalizeForMatch(lines[start]).includes('nghia') && isTitleCandidate(lines[start - 1])) {
      start -= 1;
    }
    if (start > 0 && isTitleCandidate(lines[start - 1])) start -= 1;
    starts.push(start);
  }
  const uniqueStarts = Array.from(new Set(starts)).sort((a, b) => a - b);
  if (uniqueStarts.length === 0) return [text];
  return uniqueStarts.map((start, index) => {
    const end = index + 1 < uniqueStarts.length ? uniqueStarts[index + 1] : lines.length;
    return lines.slice(start, end).join('\n');
  });
}

function extractExamples(segment) {
  const examples = [];
  const pattern =
    /([\u3400-\u9fff\uf900-\ufaff]{1,8})\s*[（(]\s*([ぁ-んァ-ンー・\s.]+)\s*[）)]\s*[-ー]\s*([^-\n|!]{1,40})(?:-\s*([^\n|!]{1,80}))?/gu;
  for (const match of segment.matchAll(pattern)) {
    examples.push({
      word: normalizeSpaces(match[1]),
      reading: normalizeSpaces(match[2]).replace(/\s+/g, ''),
      hanViet: titleCaseVietnamese(match[3] || ''),
      meaning: normalizeSpaces(match[4] || ''),
    });
  }
  return examples
    .filter((example, index, list) =>
      list.findIndex((item) => item.word === example.word) === index,
    )
    .slice(0, 6);
}

function parseReadings(segment, label, nextLabel) {
  const norm = normalizeForMatch(segment);
  const lowerLabel = normalizeForMatch(label);
  const startIndex = norm.indexOf(lowerLabel);
  if (startIndex < 0) return [];
  const nextIndex = nextLabel
    ? norm.indexOf(normalizeForMatch(nextLabel), startIndex + lowerLabel.length)
    : -1;
  const slice = segment.slice(
    startIndex,
    nextIndex > startIndex ? nextIndex : startIndex + 220,
  );
  return kanaTokens(slice).slice(0, 8);
}

function extractWritingHint(segment) {
  const lines = String(segment || '').split(/\r?\n/);
  for (let i = 0; i < lines.length; i++) {
    if (!normalizeForMatch(lines[i]).includes('cach nho')) continue;
    return normalizeSpaces(lines.slice(i + 1, i + 3).join(' '));
  }
  return '';
}

function parseLargeCardOcr(text, context = {}) {
  const segments = splitLargeCardSegments(text);
  const entries = [];
  for (const segment of segments) {
    const kanji = chooseDominantKanji(segment);
    if (!kanji) continue;
    const hanViet = extractTitleFromLines(segment.split(/\r?\n/));
    const entry = {
      kanji,
      hanViet,
      meaningVi: extractMeaning(segment),
      onyomi: parseReadings(segment, 'onyomi', 'kunyomi'),
      kunyomi: parseReadings(segment, 'kunyomi', 'tu vung'),
      strokeCount: null,
      writingHint: extractWritingHint(segment),
      examples: extractExamples(segment),
      sourcePages: context.page ? [context.page] : [],
      rawSource: context.sourceId || null,
      fieldSources: {
        level: 'ebook',
        hanViet: hanViet ? 'ebook_ocr' : 'supplement',
        meaningVi: 'ebook_ocr',
        readings: 'ebook_ocr',
        writingHint: 'ebook_ocr',
        examples: 'ebook_ocr',
      },
      openGaps: [],
    };
    entries.push(entry);
  }
  return dedupeByKanji(entries);
}

function isWritingGridHeader(line) {
  const trimmed = normalizeSpaces(line);
  if (!trimmed || trimmed.length > 32) return false;
  if (/JLPT|Tiktok|thocodehoctiengnhat|^\d+$/i.test(trimmed)) return false;
  return /^[A-ZÀ-ỸĐ\s'-]+$/.test(trimmed) && /[A-ZÀ-ỸĐ]{2}/.test(trimmed);
}

function parseWritingGridText(text, context = {}) {
  const lines = String(text || '').split(/\r?\n/);
  const headerIndices = [];
  for (let i = 0; i < lines.length; i++) {
    if (isWritingGridHeader(lines[i])) headerIndices.push(i);
  }
  const entries = [];
  for (let i = 0; i < headerIndices.length; i++) {
    const start = headerIndices[i];
    const end = i + 1 < headerIndices.length ? headerIndices[i + 1] : lines.length;
    const header = titleCaseVietnamese(lines[start]);
    const blockLines = lines.slice(start + 1, end).filter((line) => normalizeSpaces(line));
    if (blockLines.length === 0) continue;
    const firstLine = blockLines[0];
    const dominant = countCandidates(cjkChars(blockLines.join('\n')))[0];
    const firstLineChars = cjkChars(firstLine);
    const kanji = dominant && dominant[1] >= 3
      ? dominant[0]
      : firstLineChars[firstLineChars.length - 1];
    if (!kanji) continue;
    const meaningVi = normalizeSpaces(
      firstLine
        .replace(/[\u3400-\u9fff\uf900-\ufaff]/gu, ' ')
        .replace(/[ぁ-んァ-ンー]/gu, ' ')
        .replace(/[()（）]/g, ' '),
    );
    const hint = normalizeSpaces(
      blockLines
        .slice(1, 3)
        .join(' ')
        .replace(/\s{2,}/g, ' '),
    );
    entries.push({
      kanji,
      hanViet: header,
      meaningVi,
      onyomi: [],
      kunyomi: [],
      strokeCount: null,
      writingHint: hint,
      examples: [],
      sourcePages: context.page ? [context.page] : [],
      rawSource: context.sourceId || null,
      fieldSources: {
        level: 'ebook',
        hanViet: 'ebook_text',
        meaningVi: 'ebook_text',
        readings: 'supplement',
        writingHint: hint ? 'ebook_text' : 'missing',
        examples: 'supplement',
      },
      openGaps: [],
    });
  }
  return dedupeByKanji(entries);
}

function dedupeByKanji(entries) {
  const seen = new Map();
  for (const entry of entries) {
    if (!seen.has(entry.kanji)) {
      seen.set(entry.kanji, entry);
      continue;
    }
    const existing = seen.get(entry.kanji);
    existing.sourcePages = Array.from(
      new Set([...(existing.sourcePages || []), ...(entry.sourcePages || [])]),
    ).sort((a, b) => a - b);
    if (!existing.examples?.length && entry.examples?.length) {
      existing.examples = entry.examples;
    }
  }
  return Array.from(seen.values());
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function walkJsonFiles(root) {
  const files = [];
  if (!fs.existsSync(root)) return files;
  for (const item of fs.readdirSync(root, { withFileTypes: true })) {
    const full = path.join(root, item.name);
    if (item.isDirectory()) files.push(...walkJsonFiles(full));
    else if (item.isFile() && item.name.endsWith('.json')) files.push(full);
  }
  return files;
}

function loadAppKanjiIndex() {
  const root = path.join(repoRoot, 'assets/data/content/kanji');
  const index = new Map();
  for (const file of walkJsonFiles(root)) {
    if (file.endsWith('han_viet_on_rules.json')) continue;
    const data = readJson(file);
    for (const entry of data.entries || []) {
      const character = entry.character;
      if (!character || index.has(character)) continue;
      index.set(character, entry);
    }
  }
  return index;
}

function loadVocabIndex() {
  const root = path.join(repoRoot, 'assets/data/content/vocab');
  const byKanji = new Map();
  for (const file of walkJsonFiles(root)) {
    const data = readJson(file);
    for (const entry of data.entries || []) {
      const term = entry.lemma?.term;
      if (!term || !/[\u3400-\u9fff]/u.test(term)) continue;
      for (const kanji of new Set(cjkChars(term))) {
        if (!byKanji.has(kanji)) byKanji.set(kanji, []);
        byKanji.get(kanji).push({
          word: term,
          reading: entry.lemma?.reading || '',
          hanViet: entry.lemma?.labels?.hanViet || '',
          meaning: entry.sense?.meaningVi || entry.sense?.meaningEn || '',
          level: entry.level || data.level || '',
        });
      }
    }
  }
  return byKanji;
}

function loadKanjidic2Index() {
  const file = path.join(repoRoot, '.codex/sources/kanjidic2/kanjidic2.xml');
  const index = new Map();
  if (!fs.existsSync(file)) return index;
  const xml = fs.readFileSync(file, 'utf8');
  const chunks = xml.split(/<character>/).slice(1);
  for (const chunk of chunks) {
    const literal = chunk.match(/<literal>([\s\S]*?)<\/literal>/)?.[1]?.trim().normalize('NFKC');
    if (!literal) continue;
    const readType = (type) =>
      Array.from(
        chunk.matchAll(new RegExp(`<reading r_type="${type}">([\\s\\S]*?)<\\/reading>`, 'g')),
      ).map((match) => decodeXml(match[1]));
    const meanings = Array.from(chunk.matchAll(/<meaning(?:\s[^>]*)?>([\s\S]*?)<\/meaning>/g))
      .map((match) => decodeXml(match[1]))
      .filter((meaning) => !/[{}]/.test(meaning));
    index.set(literal, {
      strokeCount: Number(chunk.match(/<stroke_count>(\d+)<\/stroke_count>/)?.[1] || 0) || null,
      vietnam: readType('vietnam'),
      onyomi: readType('ja_on'),
      kunyomi: readType('ja_kun'),
      meanings,
    });
  }
  return index;
}

function buildKanjidicVietnamIndex(kanjidic2) {
  const byVietnam = new Map();
  for (const [kanji, facts] of kanjidic2.entries()) {
    for (const reading of facts.vietnam || []) {
      const key = normalizeForMatch(reading);
      if (!key) continue;
      if (!byVietnam.has(key)) byVietnam.set(key, []);
      byVietnam.get(key).push(kanji);
    }
  }
  return byVietnam;
}

function decodeXml(value) {
  return String(value || '')
    .replace(/&amp;/g, '&')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"');
}

function supplementEntry(entry, indexes) {
  entry.kanji = String(entry.kanji || '').trim().normalize('NFKC');
  let kd = indexes.kanjidic2.get(entry.kanji);
  if (entry.hanViet && indexes.kanjidicByVietnam) {
    const expected = normalizeForMatch(entry.hanViet);
    const currentMatches = (kd?.vietnam || []).some(
      (reading) => normalizeForMatch(reading) === expected,
    );
    const candidates = indexes.kanjidicByVietnam.get(expected) || [];
    if (!currentMatches && candidates.length === 1) {
      entry.openGaps.push(
        `target kanji repaired from OCR/text component ${entry.kanji} to ${candidates[0]} by Hán-Việt heading`,
      );
      entry.kanji = candidates[0];
      kd = indexes.kanjidic2.get(entry.kanji);
    } else if (!currentMatches && candidates.length > 1) {
      entry.openGaps.push(
        `target kanji ambiguous: Hán-Việt heading ${entry.hanViet} maps to ${candidates.length} KANJIDIC2 candidates; kept extracted ${entry.kanji}`,
      );
    }
  }
  const app = indexes.appKanji.get(entry.kanji);
  const vocabExamples = indexes.vocab.get(entry.kanji) || [];

  if (!entry.hanViet && app?.labels?.hanViet) {
    entry.hanViet = app.labels.hanViet;
    entry.fieldSources.hanViet = 'existing_app_source_verified';
  }
  if (!entry.hanViet && entry.examples?.length) {
    const directExample = entry.examples.find((example) =>
      String(example.word || '').startsWith(entry.kanji) && example.hanViet,
    );
    if (directExample) {
      entry.hanViet = titleCaseVietnamese(String(directExample.hanViet).split(/\s+/)[0]);
      entry.fieldSources.hanViet = 'ebook_example_inferred';
    }
  }
  if (!entry.hanViet && kd?.vietnam?.length) {
    entry.hanViet = kd.vietnam[0];
    entry.fieldSources.hanViet = 'kanjidic2_supplement';
  }
  if (!entry.meaningVi && app?.labels?.meaningVi) {
    entry.meaningVi = app.labels.meaningVi;
    entry.fieldSources.meaningVi = 'existing_app_source_verified';
  }
  if (!entry.meaningVi && kd?.meanings?.length) {
    entry.meaningVi = kd.meanings.slice(0, 3).join('; ');
    entry.fieldSources.meaningVi = 'kanjidic2_english_gap';
    entry.openGaps.push('meaningVi needs Vietnamese review; temporary English gloss from KANJIDIC2');
  }
  if ((!entry.onyomi || entry.onyomi.length === 0) && kd?.onyomi?.length) {
    entry.onyomi = kd.onyomi.slice(0, 8);
    entry.fieldSources.readings = 'kanjidic2_supplement';
  }
  if ((!entry.kunyomi || entry.kunyomi.length === 0) && kd?.kunyomi?.length) {
    entry.kunyomi = kd.kunyomi.slice(0, 8);
    entry.fieldSources.readings = entry.fieldSources.readings === 'kanjidic2_supplement'
      ? 'kanjidic2_supplement'
      : 'mixed_ebook_kanjidic2';
  }
  if (!entry.strokeCount && kd?.strokeCount) entry.strokeCount = kd.strokeCount;
  if ((!entry.examples || entry.examples.length === 0) && vocabExamples.length) {
    entry.examples = vocabExamples.slice(0, 3);
    entry.fieldSources.examples = 'existing_vocab_supplement';
  }
  if (!entry.writingHint) {
    entry.openGaps.push('writingHint missing or OCR unreadable');
    entry.fieldSources.writingHint = 'missing';
  }
  if (!entry.examples || entry.examples.length === 0) {
    entry.openGaps.push('examples missing; fill from ebook/manual pass later');
  }
  if (!entry.hanViet) entry.openGaps.push('hanViet missing');
  if (!entry.meaningVi) entry.openGaps.push('meaningVi missing');
  return entry;
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function runCommand(exe, args, options = {}) {
  const result = childProcess.spawnSync(exe, args, {
    cwd: repoRoot,
    encoding: 'utf8',
    stdio: options.stdio || 'pipe',
    env: { ...process.env, ...(options.env || {}) },
  });
  if (result.status !== 0) {
    throw new Error(
      `${exe} ${args.join(' ')} failed: ${result.stderr || result.stdout}`,
    );
  }
  return result.stdout;
}

function pdfPageCount(pdf) {
  const out = runCommand(path.join(popplerBin, 'pdfinfo.exe'), [pdf]);
  return Number(out.match(/^Pages:\s+(\d+)/m)?.[1] || 0);
}

function textForPdf(pdf, outFile) {
  ensureDir(path.dirname(outFile));
  runCommand(path.join(popplerBin, 'pdftotext.exe'), ['-layout', pdf, outFile]);
  return fs.readFileSync(outFile, 'utf8');
}

function ocrPdf(pdf, cacheDir, sourceId) {
  ensureDir(cacheDir);
  const pageCount = pdfPageCount(pdf);
  const renderedFlag = path.join(cacheDir, `${sourceId}.rendered`);
  if (!fs.existsSync(renderedFlag)) {
    runCommand(path.join(popplerBin, 'pdftoppm.exe'), [
      '-r',
      '150',
      '-png',
      pdf,
      path.join(cacheDir, sourceId),
    ], { stdio: 'pipe' });
    fs.writeFileSync(renderedFlag, new Date().toISOString());
  }
  const texts = [];
  for (let page = 1; page <= pageCount; page++) {
    const suffix = pageCount >= 100
      ? String(page).padStart(3, '0')
      : String(page).padStart(2, '0');
    const image = path.join(cacheDir, `${sourceId}-${suffix}.png`);
    const textBase = path.join(cacheDir, `${sourceId}-${suffix}`);
    const textFile = `${textBase}.txt`;
    if (fs.existsSync(image) && !fs.existsSync(textFile)) {
      runCommand(tesseractExe, [image, textBase, '-l', 'vie+jpn+eng', '--psm', '6'], {
        env: { TESSDATA_PREFIX: tessdataDir },
      });
    }
    if (fs.existsSync(textFile)) {
      texts.push({ page, text: fs.readFileSync(textFile, 'utf8') });
    }
  }
  return texts;
}

const largeCardCrops = [
  { card: 1, x: 0, y: 45, width: 1250, height: 540 },
  { card: 2, x: 0, y: 585, width: 1250, height: 540 },
  { card: 3, x: 0, y: 1125, width: 1250, height: 570 },
];

function ocrLargeCardPdf(pdf, cacheDir, sourceId) {
  ensureDir(cacheDir);
  const pageCount = pdfPageCount(pdf);
  const texts = [];
  for (let page = 1; page <= pageCount; page++) {
    for (const crop of largeCardCrops) {
      const id = `${sourceId}-p${String(page).padStart(3, '0')}-c${crop.card}`;
      const image = path.join(cacheDir, `${id}.png`);
      const textBase = path.join(cacheDir, id);
      const textFile = `${textBase}.txt`;
      if (!fs.existsSync(image)) {
        runCommand(path.join(popplerBin, 'pdftoppm.exe'), [
          '-f',
          String(page),
          '-l',
          String(page),
          '-r',
          '150',
          '-x',
          String(crop.x),
          '-y',
          String(crop.y),
          '-W',
          String(crop.width),
          '-H',
          String(crop.height),
          '-singlefile',
          '-png',
          pdf,
          textBase,
        ]);
      }
      if (!fs.existsSync(textFile)) {
        runCommand(tesseractExe, [image, textBase, '-l', 'vie+jpn+eng', '--psm', '6'], {
          env: { TESSDATA_PREFIX: tessdataDir },
        });
      }
      if (fs.existsSync(textFile)) {
        texts.push({
          page,
          card: crop.card,
          text: fs.readFileSync(textFile, 'utf8'),
        });
      }
    }
  }
  return texts;
}

function parseSourceForLevel(level, options = {}) {
  const source = ebookSources[level];
  if (!source) throw new Error(`Unknown level ${level}`);
  const indexes = {
    appKanji: loadAppKanjiIndex(),
    vocab: loadVocabIndex(),
    kanjidic2: loadKanjidic2Index(),
  };
  indexes.kanjidicByVietnam = buildKanjidicVietnamIndex(indexes.kanjidic2);
  const cacheRoot = options.cacheRoot || path.join(repoRoot, 'tmp/kanji_ebook_full');
  let entries = [];
  if (source.family === 'writing-grid') {
    const textPath = path.join(cacheRoot, `${level}.txt`);
    const text = textForPdf(source.pdf, textPath);
    entries = parseWritingGridText(text, { level, sourceId: level });
  } else if (level === 'N2') {
    for (const part of source.parts) {
      const cards = ocrLargeCardPdf(part.pdf, cacheRoot, part.id.toLowerCase());
      for (const page of cards) {
        entries.push(
          ...parseLargeCardOcr(page.text, {
            level,
            page: page.page,
            sourceId: `${part.id} card ${page.card}`,
          }),
        );
      }
    }
  } else {
    const cards = ocrLargeCardPdf(source.pdf, cacheRoot, level.toLowerCase());
    for (const page of cards) {
      entries.push(
        ...parseLargeCardOcr(page.text, {
          level,
          page: page.page,
          sourceId: `${level} card ${page.card}`,
        }),
      );
    }
  }
  entries = dedupeByKanji(entries).map((entry) => supplementEntry(entry, indexes));
  return entries;
}

function yamlList(values) {
  if (!values || values.length === 0) return '[]';
  return `[${values.map((value) => JSON.stringify(value)).join(', ')}]`;
}

function safeScalar(value) {
  if (value === null || value === undefined || value === '') return 'null';
  return String(value).replace(/\r?\n/g, ' ').trim();
}

function formatCanonicalMarkdown(level, entries, metadata = {}) {
  const lines = [
    `# Canonical Kanji ${level}`,
    '',
    `Generated: ${metadata.generatedAt || new Date().toISOString()}`,
    `Source: owner-provided local ebook PDFs only; banned websites not accessed.`,
    `Entry count: ${entries.length}`,
    '',
    '## Extraction Notes',
    '',
    '- `ebook_*` field sources come from local PDF text/OCR extraction.',
    '- `kanjidic2_supplement` and `existing_*_supplement` fill fields the observed ebook layout/OCR did not expose cleanly.',
    '- `openGaps` mark entries requiring later human/source review before app data rewrite.',
    '- `vi-human-approved` is not used.',
    '',
    '## Entries',
    '',
  ];
  for (const entry of entries) {
    lines.push(`### ${entry.kanji} (${safeScalar(entry.hanViet)})`);
    lines.push('');
    lines.push(`level: ${level}`);
    lines.push(`meaningVi: ${safeScalar(entry.meaningVi)}`);
    lines.push(`hanViet: ${safeScalar(entry.hanViet)}`);
    lines.push(`onyomi: ${yamlList(entry.onyomi)}`);
    lines.push(`kunyomi: ${yamlList(entry.kunyomi)}`);
    lines.push(`strokeCount: ${entry.strokeCount ?? 'null'}`);
    lines.push(`writingHint: ${safeScalar(entry.writingHint)}`);
    lines.push(`sourcePages: ${yamlList(entry.sourcePages || [])}`);
    lines.push('sources:');
    for (const [field, source] of Object.entries(entry.fieldSources || {})) {
      lines.push(`  ${field}: ${source}`);
    }
    lines.push('openGaps:');
    if (entry.openGaps?.length) {
      for (const gap of entry.openGaps) lines.push(`  - ${safeScalar(gap)}`);
    } else {
      lines.push('  - none');
    }
    lines.push('examples:');
    if (entry.examples?.length) {
      for (const example of entry.examples) {
        lines.push(`  - word: ${safeScalar(example.word)}`);
        lines.push(`    reading: ${safeScalar(example.reading)}`);
        if (example.hanViet) lines.push(`    hanViet: ${safeScalar(example.hanViet)}`);
        lines.push(`    meaning: ${safeScalar(example.meaning || example.meaningVi)}`);
      }
    } else {
      lines.push('  - none');
    }
    lines.push('');
  }
  return `${lines.join('\n')}\n`;
}

function parseArgs(argv) {
  const args = {
    levels: ['N5', 'N4', 'N3', 'N2', 'N1'],
    outDir: path.join(repoRoot, 'docs/research/canonical'),
    cacheRoot: path.join(repoRoot, 'tmp/kanji_ebook_full'),
  };
  for (let i = 0; i < argv.length; i++) {
    const item = argv[i];
    const next = () => argv[++i];
    if (item === '--levels') args.levels = next().split(',').map((level) => level.trim().toUpperCase());
    else if (item === '--out-dir') args.outDir = path.resolve(next());
    else if (item === '--cache-root') args.cacheRoot = path.resolve(next());
    else if (item === '--help' || item === '-h') args.help = true;
    else throw new Error(`Unknown argument ${item}`);
  }
  return args;
}

function printHelp() {
  console.log(`Usage:
  node tool/research/extract_canonical_kanji_ebooks.js --levels N5
  node tool/research/extract_canonical_kanji_ebooks.js --levels N5,N4,N3,N2,N1
`);
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    printHelp();
    return;
  }
  ensureDir(args.outDir);
  for (const level of args.levels) {
    const entries = parseSourceForLevel(level, { cacheRoot: args.cacheRoot });
    const markdown = formatCanonicalMarkdown(level, entries);
    const outFile = path.join(args.outDir, `kanji-${level.toLowerCase()}.md`);
    fs.writeFileSync(outFile, markdown);
    console.log(`${level}: wrote ${entries.length} entries to ${outFile}`);
  }
}

if (require.main === module) {
  try {
    main();
  } catch (error) {
    console.error(error.stack || error.message || String(error));
    process.exitCode = 1;
  }
}

module.exports = {
  formatCanonicalMarkdown,
  parseLargeCardOcr,
  parseWritingGridText,
  loadKanjidic2Index,
  buildKanjidicVietnamIndex,
  supplementEntry,
};
