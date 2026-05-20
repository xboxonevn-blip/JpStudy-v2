# Canonical Kanji Ebook Extraction Plan - 2026-05-20

Ticket: QA-A-027

Status: Phase 0 sample/audit only. No kanji app data has been changed. Do not start full extraction or rewrite `assets/data/content/kanji/**` until owner approves this plan.

## Source Boundary

Use only owner-provided local files:

| Level | Local PDF | Pages | Producer | Text layer | Sample pages rendered |
| --- | --- | ---: | --- | --- | --- |
| N5 | `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Ebook/Ebook_N5_[thocodehoctiengnhat].pdf - Google Drive.pdf` | 40 | jsPDF 2.5.1 | No usable text | 1-3 |
| N4 | `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Ebook/jlpt_n4_[thocodehoctiengnhat].pdf` | 21 | Skia/PDF m144 | Yes | 1-3 |
| N3 | `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Ebook/ebook_kanji_n3_[thocodehoctiengnhat].pdf - Google Drive.pdf` | 126 | jsPDF 2.5.1 | No usable text | 1-3 |
| N2 part 1 | `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Ebook/[1]ebook_kanji_n2_[thocodehoctiengnhat].pdf - Google Drive.pdf` | 78 | jsPDF 2.5.1 | No usable text | 1-3 |
| N2 part 2 | `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Ebook/[2]ebook_kanji_n2_[thocodehoctiengnhat].pdf - Google Drive.pdf` | 92 | jsPDF 2.5.1 | No usable text | 1-3 |
| N1 | `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Ebook/jlpt_n1_[thocodehoctiengnhat].pdf` | 131 | Skia/PDF m144 | Yes | 1-3 |

Crawl ban: do not search, fetch, crawl, scrape, or browse `nhaikanji.com` or `thocodehoctiengnhat.com`. These local PDFs are the only allowed source from those domains.

## Sample Method

Rendered 18 pages with Poppler:

```powershell
pdftoppm -f 1 -l 3 -r 150 -png <pdf> tmp/kanji_ebook_phase0_samples/<id>
```

Ran OCR baseline with Tesseract `vie+jpn+eng` using local traineddata:

```powershell
tesseract <png> tmp/kanji_ebook_phase0_ocr/<id> -l vie+jpn+eng --psm 6
```

Findings:

- N4/N1 text layers are usable for first-pass extraction, but visual page checks are still required because stroke grids and component notes are layout-sensitive.
- N5/N3/N2 are image scans. Tesseract catches many labels but corrupts Japanese/Vietnamese spacing and some kanji. It is useful as a candidate extractor, not as a trusted source by itself.
- Vision/manual rendered-page review confirms the schema and should be the approval checkpoint for every batch. Production extraction should use rendered image segmentation plus model vision, then JSON/Markdown validation.

Temporary sample artifacts:

- Rendered PNGs: `tmp/kanji_ebook_phase0_samples/`
- OCR text: `tmp/kanji_ebook_phase0_ocr/`
- Text-layer probes: `tmp/kanji_ebook_phase0_text/`

## Sample Schema Observed

### N5, N3, N2 Parts

Layout: about 3 large orange-dashed cards per page. Each card has:

- Hán-Việt heading, for example `NHẤT`, `HỒI`, `HUYỆT`.
- Large kanji with stroke order hints and small component/stroke sequence at top right.
- `Nghĩa` in Vietnamese.
- `Onyomi` chips.
- `Kunyomi` chips, sometimes `-`.
- `Từ vựng` examples with Japanese word, reading, Hán-Việt gloss, Vietnamese meaning.
- `Cách nhớ` / writing hint in an orange bar.

Representative sample entries:

| Ebook | Page | Visible entries | Notes |
| --- | ---: | --- | --- |
| N5 | 1 | `一` Nhất, `二` Nhị, `八` Bát | Full readings, vocab, and writing hints. Examples include `一日`, `一月`, `一緒に`, `一番`, `二次会`, `二人`, `八月`. |
| N3 | 1 | `回` Hồi, `向` Hướng, `匹` Thất | Full readings and examples. Some long example lines wrap across columns. |
| N2 part 1 | 1 | `穴` Huyệt, `込` Nhập, `片` Phiến | Full readings, examples, and writing hints. Some entries have no onyomi or no kunyomi. |
| N2 part 2 | 1 | `睡` Thụy, `郵` Bưu, `華` Hoa | Same schema as N2 part 1; merge both parts into one N2 canonical file. |

### N4, N1

Layout: about 10 compact writing-grid rows per page. Each row has:

- Hán-Việt heading.
- Vietnamese meaning.
- Kanji character.
- Component/writing mnemonic sentence.
- Stroke-order grid.

Representative sample entries:

| Ebook | Page | Visible entries | Notes |
| --- | ---: | --- | --- |
| N4 | 1 | `毛` Mao, `刀` Đao, `力` Lực, `丸` Hoàn, `究` Cứu, `酒` Tửu, `光` Quang, `当` Đương, `社` Xã, `降` Giáng | Text layer extracts headings/meanings/mnemonics; no full vocab-example block in observed pages. |
| N1 | 1 | `仁` Nhân, `曰` Viết, `峠` Đèo, `洒` Sái, `酉` Dậu, `叱` Sất, `幌` Hoảng, `汽` Khí, `佐` Tá, `拓` Thác | Text layer extracts headings/meanings/mnemonics; no full vocab-example block in observed pages. |

## Unified Canonical Schema

Use one Markdown/YAML-style schema for all levels, with source flags per field:

```yaml
校 (Hiệu)
level: N5
meaningVi: Trường học
hanViet: Hiệu
onyomi:
  - こう
kunyomi: []
strokeCount: 10
writingHint: ...
examples:
  - word: 校長
    reading: こうちょう
    meaning: Hiệu trưởng
    hanViet: Hiệu trưởng
    minnaLesson: null
sources:
  level: ebook
  hanViet: ebook
  meaningVi: ebook
  readings: ebook|kanjidic2|existing_source_verified
  writingHint: ebook
  examples: ebook|existing_vocab|canonical_later
```

Rules:

- `level`, `hanViet`, `meaningVi`, and `writingHint` prefer the ebook.
- `onyomi`/`kunyomi` prefer the ebook where visible. If a PDF level does not include readings in the observed schema, fill from existing source-verified app data or KANJIDIC2 later, and mark the field source explicitly.
- Examples prefer ebook examples where present. If absent in N4/N1 rows, fill later from app vocab/canonical vocab, not guessed word glosses.
- Never add `vi-human-approved`.

## Estimated Entry Counts

These are Phase 0 estimates from page counts and observed page density:

| Output | Source pages | Observed density | Estimated kanji |
| --- | ---: | --- | ---: |
| `kanji-n5.md` | 40 | 3/page | ~120 |
| `kanji-n4.md` | 21 | 10/page | ~210 |
| `kanji-n3.md` | 126 | 3/page | ~378 |
| `kanji-n2.md` | 170 | 3/page | ~510 |
| `kanji-n1.md` | 131 | 10/page | ~1310 |
| Total | 488 | mixed | ~2528 |

The final extraction must count actual entries after parsing; page headers/footers or blank trailing rows may reduce counts.

## Per-Ebook Quirks

- N5: Large card layout, strong color labels, full vocab examples. OCR loses accents and joins Japanese spacing; visual extraction is required.
- N4: Compact writing worksheet layout with usable text layer. Good for Hán-Việt/meaning/writing mnemonic, not enough for complete examples/readings in observed pages.
- N3: Same large card layout as N5. Long vocab rows wrap; parser must support two-column examples and wrapped Vietnamese meanings.
- N2 part 1/2: Same large card layout as N3. Both parts must be merged in page order into `kanji-n2.md`.
- N1: Compact writing worksheet layout with usable text layer, same extraction risk as N4.

## Batch Plan After Approval

1. Build extractor scaffold:
   - PDF inventory and render cache.
   - Card/row segmentation per layout family.
   - Model-vision OCR prompt for card/row fields.
   - Validation pass for duplicate kanji, missing required ebook fields, and impossible level tags.
2. Extract in controlled batches:
   - Large-card PDFs: 10 pages/batch, about 30 entries.
   - Writing-grid PDFs: 5 pages/batch, about 50 entries.
   - Commit one canonical Markdown output per level when that level is complete, as requested.
3. Create outputs:
   - `docs/research/canonical/kanji-n5.md`
   - `docs/research/canonical/kanji-n4.md`
   - `docs/research/canonical/kanji-n3.md`
   - `docs/research/canonical/kanji-n2.md`
   - `docs/research/canonical/kanji-n1.md`
4. Run canonical validation:
   - Count entries per level.
   - Guard duplicate characters within a level.
   - Guard cross-level duplicates, unless owner explicitly marks a duplicate as intentional.
   - Compare with current app kanji assets to prepare QA-A-026 MOVE/DEDUP/MISSING/EXTRA.

## Approval Questions For Owner

1. Approve using ebook fields as source of truth for `level`, `hanViet`, `meaningVi`, and `writingHint`.
2. Approve supplementing missing readings/examples from existing source-verified app data, KANJIDIC2, and app vocab when a local ebook layout does not contain those fields.
3. Approve the batch sizes above before full extraction.
