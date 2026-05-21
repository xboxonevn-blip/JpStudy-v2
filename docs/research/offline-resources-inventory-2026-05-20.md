# Offline Resources Inventory - Vocab/Grammar Canonical

Generated: 2026-05-21  
Ticket: QA-A-030  
Root: `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Tu Vung`

## Scope

This is Phase 0 for the offline vocab/grammar canonical extraction pipeline.
The local owner-provided files are the primary reference. Online fallback is
allowed only for licensed/open references already approved by project policy:
JMdict, KANJIDIC2, Unihan, Wiktionary when offline sources do not provide a
fact.

Blocked domains remain blocked: do not search, fetch, crawl, or open
`nhaikanji.com` or `thocodehoctiengnhat.com`. Their names appear in local file
names/text because the owner already has those files locally; the extraction
pipeline must not access the sites.

Copyright rule: extract factual fields only (`term`, `reading`, Hán-Việt,
meaning, part of speech, source section/page). Do not copy long examples,
mnemonics, explanations, or book layout prose into the app.

## Inventory Summary

Poppler path used:
`C:/Users/xboxo/AppData/Local/Microsoft/WinGet/Packages/oschwartz10612.Poppler_Microsoft.Winget.Source_8wekyb3d8bbwe/poppler-25.07.0/Library/bin`

Total files: `153`

| Extension | Count |
| --- | ---: |
| `.pdf` | 152 |
| `.docx` | 1 |

Total PDF pages scanned by `pdfinfo`: `1005`.

| Source folder | Intended source | Level/scope | Files | PDF pages | Text layer |
| --- | --- | --- | ---: | ---: | --- |
| `Tu Vung Mimikara N1` | Mimikara vocabulary | N1 | 12 PDF | 91 | usable, 12/12 |
| `Tu Vung Mimikara N2` | Mimikara vocabulary + supplement | N2 | 11 PDF + 1 DOCX | 106 | usable, 11/11 |
| `Tu Vung Mimikara N3` | Mimikara vocabulary | N3 | 12 PDF | 87 | usable, 12/12 |
| `Tu Vung Mina 1` | Minna no Nihongo I vocabulary | N5, lessons 1-25 | 25 PDF | 85 | usable, 25/25 |
| `Tu Vung Mina 2` | Minna no Nihongo II vocabulary | N4, lessons 26-50 | 25 PDF | 119 | usable, 25/25 |
| `Tu Vung Theo Kanji/N5` | Vocabulary by kanji | N5 | 12 PDF | 70 | usable, 12/12 |
| `Tu Vung Theo Kanji/N4` | Vocabulary by kanji | N4 | 11 PDF | 86 | usable, 11/11 |
| `Tu Vung Theo Kanji/N3` | Vocabulary by kanji | N3 | 19 PDF | 145 | usable, 19/19 |
| `Tu Vung Theo Kanji/N2` | Vocabulary by kanji | N2 | 25 PDF | 216 | usable, 25/25 |

No N1 `Tu Vung Theo Kanji` folder was found in this root.

## File Tree Shape

- `Tu Vung Mimikara N1`: unit PDFs present for units `1-5`, `7-9`, `11-14`.
- `Tu Vung Mimikara N2`: unit PDFs present for units `1-4`, `6-8`, `10-13`, plus `222 Quizlet ôn tập 1160 N2.docx`.
- `Tu Vung Mimikara N3`: unit PDFs present for units `1-12`.
- `Tu Vung Mina 1`: lesson PDFs present for `bai1` through `bai25`.
- `Tu Vung Mina 2`: lesson PDFs present for `bai26` through `bai50`.
- `Tu Vung Theo Kanji/N5`: unit PDFs present for units `1-12`.
- `Tu Vung Theo Kanji/N4`: unit PDFs present for units `1-11`.
- `Tu Vung Theo Kanji/N3`: unit PDFs present for units `1-19`.
- `Tu Vung Theo Kanji/N2`: unit PDFs present for units `1-25`.

## Representative Text Samples

All samples below are short factual extraction samples used only to identify the
parse pattern.

| Source | Sample shape |
| --- | --- |
| Mimikara N1 unit 1 | `青春 (せいしゅん) - THANH XUAN - Thanh xuân` |
| Mimikara N2 unit 1 | `人生 (じんせい) - NHAN SINH - Cuộc sống` |
| Mimikara N3 unit 1 | `男性 (だんせい) - NAM TINH - Đàn ông` |
| Minna I bài 1 | `私 (わたし) - TU - Tôi` |
| Minna II bài 26 | `見る (みる) - KIEN - Xem` |
| Kanji-vocab N5 unit 1 | `一 (いち) - NHAT - Số 1` |
| Kanji-vocab N4 unit 1 | `毛 (け) - MAO - Lông` |
| Kanji-vocab N3 unit 1 | `回す (まわす) - HOI - Vặn, xoay` |
| Kanji-vocab N2 unit 1 | `穴 (あな) - HUYET - Lỗ` |

The console sample normalizes accents poorly in some uppercase Hán-Việt output,
but `pdftotext -enc UTF-8` returns usable structured text. The extractor should
preserve UTF-8 bytes and avoid console-codepage round-tripping.

## Candidate Entry Estimate

A first-pass line-pattern scan counted these candidate vocab fact rows:

| Source | Candidate rows | Notes |
| --- | ---: | --- |
| Mimikara N1 | 864 | lower than book title count because some units are absent from folder |
| Mimikara N2 | 990 | DOCX not counted; some units absent from folder |
| Mimikara N3 | 771 | loanword-heavy units may omit Hán-Việt field |
| Minna I | 715 | lesson-aligned N5 vocab |
| Minna II | 901 | lesson-aligned N4 vocab |
| Kanji-vocab N5 | 645 | kanji-themed vocab rows |
| Kanji-vocab N4 | 827 | kanji-themed vocab rows |
| Kanji-vocab N3 | 1357 | kanji-themed vocab rows |
| Kanji-vocab N2 | 2068 | kanji-themed vocab rows |

These counts are estimates, not canonical totals. Phase 1 parser validation
must report accepted rows, skipped rows, and manual-review rows.

## Format Findings

- Most PDFs use one factual row per vocab item:
  `term (reading) - HAN_VIET - meaningVi`.
- Katakana loanword rows can use:
  `term (reading) - meaningVi`, with no Hán-Việt. Example: Mimikara N3 unit
  11. These rows should keep `hanViet: null`.
- Minna I/II lesson files are strong for lesson alignment and should drive N5/N4
  `sourceSection` values.
- Kanji-vocab files are strong for kanji-based clusters, but they should not
  override QA-A-027/QA-A-026 kanji level canonical mapping.
- The N2 DOCX contains a Quizlet link/contact note in the sampled content, not
  usable vocab facts. It should stay supplemental unless a deeper DOCX pass
  finds actual terms.
- No spreadsheet/CSV/TXT files were found in this root.

## Canonical Schema

Use YAML-style entries in markdown for Phase 1 canonical outputs:

```yaml
term: 行く
reading: いく
hanViet: Hành
posTags: []
meaningVi: đi
meaningEnHint: null
level: N5
source: minna-1
sourceFile: Tu Vung Mina 1/bai5_mina_[...].pdf
sourceSection: Lesson 5
sourcePage: 1
confidence: text-layer
notes: []
```

For loanwords or purely kana terms:

```yaml
term: コミュニケーション
reading: コミュニケーション
hanViet: null
posTags: []
meaningVi: giao tiếp
level: N3
source: mimikara-n3
confidence: text-layer
notes:
  - no-han-viet-in-source
```

## Extraction Plan

1. Create `tool/research/extract_offline_vocab_canonical.js`.
2. Use `pdftotext -layout -enc UTF-8` first for every PDF.
3. Parse factual rows with source-specific profiles:
   - `mimikara-n1/n2/n3`: unit number from filename, row pattern with optional
     Hán-Việt.
   - `minna-1`: lesson from `bai1` through `bai25`, canonical level `N5`.
   - `minna-2`: lesson from `bai26` through `bai50`, canonical level `N4`.
   - `kanji-vocab-n*`: unit number from filename, canonical level from folder.
4. Normalize row fields:
   - trim whitespace and fullwidth artifacts,
   - preserve Japanese orthography exactly,
   - keep Hán-Việt source text as provided,
   - split meanings conservatively without inventing glosses.
5. OCR fallback only for pages/files whose text-layer row count is `0` or whose
   extracted rows fail validation:
   - render with `pdftoppm -r 200 -png`,
   - run vision OCR or Tesseract `vie+jpn+eng`,
   - mark `confidence: ocr`.
6. Use online fallback only after offline parse:
   - JMdict for POS/reading disambiguation,
   - KANJIDIC2/Unihan for kanji facts,
   - Wiktionary only for short disambiguation with citation.
7. Write Phase 1 files under `docs/research/canonical/vocab/`:
   - `mimikara-n1.md`, `mimikara-n2.md`, `mimikara-n3.md`
   - `minna-1.md`, `minna-2.md`
   - `kanji-vocab-n5.md`, `kanji-vocab-n4.md`, `kanji-vocab-n3.md`,
     `kanji-vocab-n2.md`
8. Emit machine-readable parse reports beside canonical docs:
   - accepted row count,
   - skipped row count,
   - manual-review row count,
   - empty-text/OCR fallback count.
9. Build cross-source consensus after all source files are extracted:
   `docs/research/canonical/vocab-cross-source-consensus.md`.
10. Diff app vocab only after consensus exists, then batch fixes by level and
    source cluster.

## Grammar Cross-Check Plan

This `Tu Vung` root is primarily vocabulary. If grammar sections appear during
full extraction, parse them as supplemental facts only. The main grammar
cross-check should use existing grammar assets plus any owner-provided grammar
folders discovered outside this root in a later inventory pass. Do not infer
grammar formation rules from vocabulary rows.

## Batch Plan

Phase 1 extraction order:

1. Minna I (`N5`) - highest lesson-alignment value for QA-B-001.
2. Minna II (`N4`) - lesson-alignment continuation.
3. Mimikara N3.
4. Mimikara N2.
5. Mimikara N1.
6. Kanji-vocab N5/N4/N3/N2.

Commit policy: one source-level file per commit after parser and report pass.

## Validation Gates

- `node --test` parser fixtures for:
  - standard `term (reading) - HAN_VIET - meaning` rows,
  - no-Hán-Việt loanword rows,
  - Minna lesson filename mapping,
  - kanji-vocab folder level mapping,
  - malformed row logging.
- `node tool/research/extract_offline_vocab_canonical.js --dry-run` must report
  accepted/skipped/review counts before writing canonical docs.
- `git diff --check` before each doc/data commit.

## DECISIONS MADE

1. Text-layer-first extraction is the default because all sampled PDFs returned
   structured text rows and this avoids expensive OCR where not needed.
2. OCR is fallback, not primary, for QA-A-030 because these PDFs differ from the
   image-grid kanji ebooks in QA-A-027.
3. Minna I/II lesson refs become the first canonical lesson-alignment source
   for N5/N4 vocab.
4. Mimikara and kanji-vocab sources are extracted as independent canonical
   source files first; consensus and app mutation happen only after source files
   exist.
5. The N2 Quizlet DOCX is treated as supplemental/non-canonical until a deeper
   pass finds actual vocab facts.

## OPEN_QUESTIONS

1. Missing Mimikara units: N1 lacks units `6` and `10`; N2 lacks units `5` and
   `9` in this local folder. Default: extract what exists and log source gaps.
2. No N1 kanji-vocab folder found. Default: do not fabricate `kanji-vocab-n1.md`.
3. Grammar source coverage in this root is unclear. Default: keep QA-A-030
   Phase 1 vocab-first and run a separate grammar-folder inventory if needed.
4. Legal clearance depth for textbook-derived facts remains owner-reviewable.
   Default: facts only, no long examples/prose/mnemonics copied into app.
