# JLPT Exam Source Reference

Last verified: 2026-05-19.

Purpose: keep a durable reference for future Codex sessions when changing JLPT
mock exam, listening, score, answer-sheet, or exam-source behavior in JpStudy.

## Core Rule

Do not import, rehost, translate, adapt, or bundle real JLPT exam questions,
official workbook questions, answer keys, scripts, or listening audio unless
explicit permission has been confirmed.

Use official JLPT materials as:

- format reference,
- timing reference,
- scoring reference,
- manual QA reference,
- outbound links to the official site.

Build in-app mock exams from original JpStudy questions, redistribution-safe
sources, or content with explicit permission.

## Official Sources

### Official Practice Workbook

Source: https://www.jlpt.jp/e/samples/sampleindex.html

Use for:

- official N1-N5 workbook PDFs,
- answer sheets,
- answer keys,
- listening scripts,
- downloadable listening audio files,
- confirming real section shapes and listening item flow.

Important copyright note:

- The official page states that workbook reproduction, copy, adaptation, and
  translation must comply with the JLPT site policy.
- It also states that all N1-N5 listening audio files contain third-party
  works, and reprint/reproduction is prohibited without permission except where
  the site policy allows.
- Therefore JpStudy may link to the official page, but must not mirror or bundle
  those files in app assets.

### Sample Questions / Question Patterns

Source: https://www.jlpt.jp/e/samples/forlearners.html

Use for:

- confirming item types,
- calibrating app UI patterns,
- checking listening flow,
- directing learners to official examples.

### Test Sections and Item Composition

Source: https://jlpt.jp/sp/e/guideline/testsections.html

Use these timings for real-mode mocks unless the official page changes:

| Level | Section 1 | Time | Section 2 | Time | Section 3 | Time |
| --- | --- | ---: | --- | ---: | --- | ---: |
| N1 | Language Knowledge (Vocabulary/Grammar) + Reading | 110m | Listening | 55m | - | - |
| N2 | Language Knowledge (Vocabulary/Grammar) + Reading | 105m | Listening | 50m | - | - |
| N3 | Language Knowledge (Vocabulary) | 30m | Grammar + Reading | 70m | Listening | 40m |
| N4 | Language Knowledge (Vocabulary) | 25m | Grammar + Reading | 55m | Listening | 35m |
| N5 | Language Knowledge (Vocabulary) | 20m | Grammar + Reading | 40m | Listening | 30m |

Implementation notes:

- N1 and N2 have two test sections.
- N3, N4, and N5 have three test sections.
- Listening length can vary slightly with the recorded materials.
- N1 Listening changed to 55 minutes starting with the December 2022 test.
- N4/N5 Language Knowledge and Listening times changed starting with the
  December 2020 test.

### Scoring and Pass/Fail

Source: https://www.jlpt.jp/e/guideline/results.html

Use this shape for mock result screens:

| Level | Scoring sections | Total range | Overall pass | Sectional pass |
| --- | --- | ---: | ---: | --- |
| N1 | Language Knowledge, Reading, Listening | 0-180 | 100 | 19 each |
| N2 | Language Knowledge, Reading, Listening | 0-180 | 90 | 19 each |
| N3 | Language Knowledge, Reading, Listening | 0-180 | 95 | 19 each |
| N4 | Language Knowledge + Reading, Listening | 0-180 | 90 | 38 / 19 |
| N5 | Language Knowledge + Reading, Listening | 0-180 | 80 | 38 / 19 |

Implementation notes:

- Passing requires both the overall pass mark and every sectional pass mark.
- If one scoring section is below the sectional pass mark, the total score does
  not matter.
- Missing a required test section means fail.
- JpStudy raw percentage scores are not equivalent to official scaled JLPT
  scores. Label app results as "mock estimate" unless a validated scaling model
  exists.

### FAQ / Copyright / Past Tests

Source: https://www.jlpt.jp/e/faq/

Use for:

- copyright guidance,
- explaining why exact past tests are not official public prep material,
- explaining why no official modern vocabulary/kanji/grammar list should be
  claimed.

Important official points:

- Test paper cannot be kept after the exam.
- Copyrights are held by the Japan Foundation and Japan Educational Exchanges
  and Services.
- Unauthorized copying, duplication, and reproduction are prohibited.
- Exact same questions from every exam are not published.
- Official Practice Workbooks are the sanctioned post-2010 public release.
- Listening examples can be downloaded from the official sample pages.

## Third-Party Sites Observed

Use these only for UX/reference research unless licensing is confirmed. Do not
copy questions, answer keys, scripts, or audio into JpStudy from these sources.

| Site | URL | Useful for | Import status |
| --- | --- | --- | --- |
| Tanos JLPT past papers | https://www.tanos.co.uk/jlpt/skills/pastpapers/ | Locator for old sample/past-paper links and audio/script patterns | Reference only |
| JLPT Bootcamp workbook posts | https://jlptbootcamp.com/ | Commentary around official workbook use and audio practice | Reference only |
| TryJLPT | https://tryjlpt.com/ | Exam UI, level filters, practice flow | Reference only |
| TryNihongo | https://trynihongo.com/ | Vietnamese-facing JLPT practice UX | Reference only |
| Nihonez real exams | https://nihonez.com/ | Real-mode UX, one-play listening behavior | Reference only; source provenance unclear |
| JLPTPracticeTest | https://www.jlptpracticetest.com/ | Online practice UX and score feedback | Reference only |
| NihonShiken | https://www.nihonshiken.com/ | Practice-test navigation and sectioning | Reference only |
| PassJapanese | https://passjapanese.com/en/jlpt-full-exam | Real/study/quick mode UX ideas | Reference only |

Red flags for import:

- Claims to host many real past papers.
- Audio copied from past exams or user recordings.
- No explicit redistribution license.
- Questions sourced from social media, memory, leaks, or scanned books.
- "Official" wording without a clear license from JLPT organizers.

## Recommended JpStudy Implementation Policy

### Real Mode

Mirror exam constraints:

- section timer,
- section lock after submit/time-up,
- no instant feedback,
- one-way navigation where appropriate,
- listening audio starts when the item begins,
- no pause/seek/replay for final real-mode listening,
- final result grouped by official scoring sections.

### Study Mode

Allow learning affordances:

- replay original JpStudy audio,
- pause/seek for review,
- instant explanations,
- retry by item type,
- weak-area drills.

### Official Material Links

Add external links rather than copied content:

- "Official JLPT Practice Workbook and audio"
- "Official JLPT sample questions"
- "Official test sections and timing"
- "Official scoring and pass/fail"

When linking out, label clearly that the learner is leaving JpStudy and that
official content remains under JLPT site policy.

### Audio Content

Use one of:

- original JpStudy recorded audio,
- text-to-speech generated under a license suitable for app redistribution,
- explicitly licensed third-party audio.

Do not bundle:

- official workbook audio,
- leaked real exam audio,
- YouTube audio rips,
- third-party site MP3s without permission.

## App Areas To Check Before Changes

Search these areas before implementing JLPT exam/audio changes:

- `lib/features/jlpt/`
- `lib/features/test/`
- `lib/features/exam/`
- `assets/data/content/`
- `docs/credits/upper-jlpt-sources.md`
- `docs/research/D2-content/kanji-expansion-source-policy-2026-05-18.md`
