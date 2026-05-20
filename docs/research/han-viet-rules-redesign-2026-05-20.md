# QA-A-028 - Han-Viet Rules Learning Loop Design

Status: Autonomous Phase 0 complete. No owner gate. This doc is the committed design baseline for implementation.

## Scope

Redesign `Quy tắc Hán-Việt` from a static reference list into a learner loop:

- rule card -> examples -> 5-question practice -> inline feedback -> rule progress + kanji SRS;
- kanji detail -> matching rule mini-card -> full rule card;
- review queue -> due rule card;
- generator tool derives examples/practice from local app kanji/vocab assets, then later from QA-A-027 canonical ebook files when they are safe.

No banned website is accessed. `nhaikanji.com` and `thocodehoctiengnhat.com` remain excluded. `vi-source-verified` is allowed; `vi-human-approved` is not added.

## Current Audit

Current asset: `assets/data/content/kanji/han_viet_on_rules.json`.

- Schema version: `1`.
- Rules: `32`.
- Categories: usage `3`, initial `12`, final `5`, rime `6`, long_vowel `2`, exception `4`.
- Current UI: `lib/features/foundations/screens/han_viet_reference_screen.dart` renders search, category chips, static `ExpansionTile` cards, examples, and source labels.
- Current model/service: `HanVietRule`, `HanVietExample`, `FoundationsContentService.loadHanVietRules()`.
- Current route: `/kanji/han-viet` via `HanVietReferenceGate`; VI-only, with legacy `/foundations/han-viet` still available.
- Current kanji detail interlink: `HanVietInlinePanel` only matches rules by exact example kanji, so most kanji do not show the rule that actually applies.
- Existing kanji SRS: `KanjiSrsDao` + `LessonRepository.saveKanjiReview()` path used by handwriting/kanji practice. There is no rule-level SRS yet.

Kanji data coverage from `assets/data/content/kanji/n*/lesson_*.json`:

- Files: `125`; entries: `929`; entries with Hán-Việt: `929`; with On reading: `926`.
- Largest first-consonant pools: T `123`, Đ `105`, TH `90`, H `73`, L `51`, B `46`, V `44`, TR `43`, PH `36`, C `34`, KH `26`, CH `25`, NH `24`, GI `23`, M `23`, K `21`, NG `20`, S `19`, N `17`, QU `16`.
- Rule 1 pool (`H/K/GI/C/QU`): `167` entries before target-kana filtering, enough for examples and practice.

## V2 Schema

Keep v1 asset for compatibility and add `assets/data/content/kanji/han_viet_on_rules_v2.json`.

```json
{
  "schemaVersion": 2,
  "dataset": "han_viet_on_rules_v2",
  "generatedAt": "2026-05-20",
  "sourcePolicy": {
    "bannedDomainsExcluded": ["nhaikanji.com", "thocodehoctiengnhat.com"],
    "note": "Generated from local app kanji/vocab assets and later local canonical ebook files only."
  },
  "rules": [
    {
      "ruleId": "rule_initial_h_k_gi_c_qu_to_k",
      "legacyId": "initial-c-k-kh-gi-h-qu-to-k",
      "section": "1",
      "parentSection": null,
      "category": "initial",
      "title": "Âm đầu là H/K/Gi/C/Qu",
      "consonants": ["H", "K", "Gi", "C", "Qu"],
      "targetRow": "K",
      "targetKana": ["か", "き", "く", "け", "こ", "が", "ぎ", "ぐ", "げ", "ご"],
      "percentage": 90,
      "explanation": "Phụ âm đầu Hán-Việt H/K/Gi/C/Qu thường chuyển sang hàng K/G trong On'yomi.",
      "examples": [],
      "practice": {
        "count": 5,
        "questionTemplate": "Âm Hán-Việt {hanViet} ({kanji}) -> On'yomi nào?",
        "items": []
      },
      "subRuleIds": []
    }
  ]
}
```

Example item:

```json
{
  "hanViet": "Hiệu",
  "kanji": "校",
  "kanjiId": 12,
  "level": "N5",
  "onyomi": "こう",
  "romaji": "kou",
  "compound": "学校",
  "compoundKana": "がっこう",
  "compoundMeaning": "trường học",
  "source": "app-kanji-source-verified"
}
```

Practice item:

```json
{
  "itemId": "rule_initial_h_k_gi_c_qu_to_k_校",
  "kanji": "校",
  "kanjiId": 12,
  "hanViet": "Hiệu",
  "correct": "こう",
  "options": ["こう", "そう", "とう", "りょう"],
  "explanation": "Hiệu bắt đầu bằng H, thường về hàng K/G; 校 có âm On こう."
}
```

## Generation Policy

Tool: `tool/research/generate_han_viet_rule_content.js`.

Input:

- `han_viet_on_rules.json` for legacy rule inventory;
- `assets/data/content/kanji/n*/lesson_*.json` for character, Hán-Việt, On/Kun, level, stroke, examples;
- `assets/data/content/vocab/**/*.json` for compound context;
- later `docs/research/canonical/kanji-n*.md` after QA-A-027 blocker is resolved.

Selection:

- Normalize Hán-Việt by first syllable, remove accents for matching, but display original casing.
- Longest-prefix consonant matching order: `ngh`, `ng`, `nh`, `ch`, `tr`, `th`, `ph`, `kh`, `gi`, `qu`, `đ`, then one-letter initials.
- For each rule, candidate = Hán-Việt initial matches rule consonants and first On reading starts in target kana/row.
- Examples: choose 4-6 candidates, prefer lower JLPT level, source-verified metadata, real compound in examples/vocab, then lower stroke count.
- Practice: choose 5 different candidates from the same pool. Avoid reusing example-only items when enough pool exists.
- Distractors: same mora-count when possible; otherwise same target family length. Pull from neighboring rule pools, never duplicate rendered text, never equal `correct`.
- If a rule has fewer than 5 safe candidates, mark `practice.status = "reference_only"` and do not show it as due in review until QA-A-027 adds canonical examples.

Compound lookup:

- Prefer `KanjiItem.examples` with `sourceVocabId`/`sourceSenseId`.
- Else scan vocab entries where `term` contains the kanji and `kana` exists.
- Prefer N5/N4, then the kanji's own level, then any level.

## UI Design

Route `/kanji/han-viet` remains VI-only and becomes the full learning page.

Page:

- subtle light-blue grid background;
- constrained content width around `960px`;
- top search/filter row remains, but rule cards are always expanded enough to be useful;
- no marketing/header explainer block.

Rule card:

- white card, 8px radius, 1.5px border;
- parent rule border: soft violet; sub-rule border: soft orange;
- title uses red/pink `#E25C5C` spans for Vietnamese consonants;
- target row/kana uses teal `#2EC4B6`;
- examples render as compact rows: `Hiệu -> 校 (こう) kou -> 学校 (がっこう)`;
- practice appears in the same card, 5 MC rows, 4 rounded buttons each;
- feedback is inline: correct green, wrong red, explanation below the row;
- after 4/5 correct, card shows learned state and schedules rule + question kanji through SRS.

State:

- per-card local attempt state: unanswered/selected/correct/wrong;
- `Làm lại` re-samples from generated candidates if dynamic sampling is available; MVP can reset the authored 5 items.

## SRS Plan

Add a lightweight rule SRS table in `AppDatabase`:

- key: `ruleId`;
- `stability`, `difficulty`, `lastConfidence`, `lastReviewedAt`, `nextReviewAt`, `fsrsState`, `fsrsStep`.

Review behavior:

- score >= 4/5 -> rule grade `3`, all question kanji receive kanji review grade `3`;
- score 2-3 -> rule grade `2`, wrong kanji receive grade `1`, correct kanji grade `2`;
- score <= 1 -> rule grade `1`, wrong kanji grade `1`;
- rule review due cards appear only for rules with `practice.status != "reference_only"`.

MVP may implement rule SRS as a JSON-free Drift table plus `HanVietRuleSrsDao`, matching `ConjugationSrsDao`/`KanaSrsDao` style.

## Interlinks

Kanji detail:

- replace exact-example-only `HanVietInlinePanel` matching with rule matcher based on Hán-Việt initial + On target row;
- show a mini-card "Quy tắc Hán-Việt áp dụng" with matched rule, target row, one example, and link to full card anchor/route.

Practice personalization:

- v1 implementation uses generated static items;
- later pass should bias items toward seen/due kanji from `KanjiSrsDao.getAllSeenKanjiIds()` and `getDueKanjiIds()`.

Review queue:

- add rule due lane alongside vocab/grammar/conjugation/kanji;
- first implementation can surface a rule due CTA in Practice Board and `/review`;
- later UI can embed full compact rule card directly in the review stream.

## Migration Plan

1. Keep v1 file unchanged until v2 parser/UI is stable.
2. Add v2 model fields to `HanVietRule` without breaking v1.
3. Add `FoundationsContentService.loadHanVietRulesV2()` with fallback to v1 if v2 is missing.
4. Add generator and asset tests for schema, blocked domains, examples, practice, unique options, and rule 1 coverage.
5. Implement rule 1 full loop first.
6. Scale generator to all rules in batches of 5 rules/commit.
7. Add rule SRS integration and review queue after UI/practice behavior is stable.

## Rule Inventory

Usage rules remain reference-first:

- `usage-kanji-compounds-often-use-on`
- `usage-hv-is-heuristic-not-reading-source`
- `usage-multiple-on-readings`

Initial rules become main practice rules:

- `initial-l-to-r`
- `initial-m-to-m`
- `initial-n-nh-to-n-j`
- `initial-ng-ngh-to-g-gy`
- `initial-b-ph-to-h-f`
- `initial-c-k-kh-gi-h-qu-to-k` -> reference rule 1
- `initial-d-to-y`
- `initial-ch-tr-to-sh-ch`
- `initial-s-x-to-s-sh`
- `initial-t-th-to-t-s`
- `initial-d-with-stroke-to-t-d`
- `initial-v-to-b-m`

Final/rime/long-vowel rules become phase-2 cards after initial rules:

- `final-n-m-to-n`
- `final-t-to-tsu-chi`
- `final-c-to-ku`
- `final-p-to-long-or-tsu`
- `final-ch-to-ku-ki`
- `rime-inh-anh-enh-to-ei`
- `rime-ien-iem-yen-to-en`
- `rime-ong-ung-uong-to-ou-uu`
- `rime-ac-uoc-to-aku-yaku`
- `rime-ich-to-eki-seki`
- `rime-uu-ieu-yeu-to-yuu-you`
- `long-vowel-ou-from-ang-ong`
- `long-vowel-ei-from-inh-anh`

Exceptions stay visible but can be `reference_only` until enough safe generated items exist:

- `exception-onbin-gemination`
- `exception-kun-mixed-readings`
- `exception-word-level-han-viet`
- `exception-check-dictionary-before-drill`

## Verification Plan

Focused:

- Node generator tests for v2 schema, blocked domains, rule 1 examples, option uniqueness, no empty practice.
- Flutter widget tests for `/kanji/han-viet`: rule card renders, answers require selection, feedback appears, 4/5 pass marks rule understood.
- Kanji detail widget test: matching rule mini-card appears for a kanji such as `校`/`学`.
- DAO tests for rule SRS scheduling once table is added.

Gate for logic/data:

- `node --test test/tool/research/*han_viet*`
- `flutter test test/data/content/han_viet_on_rules_asset_test.dart`
- focused foundations/kanji/review tests
- `flutter analyze lib test`
- `python tooling/audit_ui_string_literals.py --check`
- `dart run tool/research/content_vi_status_report.dart`
- full `flutter test --concurrency=1` before release deploy because this touches route UI, SRS, and content.

Live proof:

- VI `/kanji/han-viet`: rule 1 card renders, 5 questions can be answered, pass state appears.
- VI kanji detail `校`: matching mini-card appears and opens the full rule page.
- VI `/review`: due rule card appears after rule schedule is forced/created.
- EN/JA: Hán-Việt entry remains hidden/redirected.

## DECISIONS MADE

- No owner approval gate: user explicitly enabled autonomous overnight mode.
- Keep v1 asset and add v2 asset: reduces blast radius, lets old tests/UI keep working during reference-rule slice.
- Rule 1 maps H/K/Gi/C/Qu to K/G row, not pure K only: current v1 and real app examples include voiced G readings such as `学 -> がく`; hiding G would make the rule misleading.
- Parent/sub-rule colors: red `#E25C5C`, teal `#2EC4B6`, parent border violet, sub-rule border orange. These match owner screenshot description while staying readable on current app theme.
- Route stays `/kanji/han-viet`: existing deep links/tests remain valid; the page content changes from reference to loop.
- Rule SRS gets its own table instead of overloading kanji/grammar SRS: rule IDs are not content DB kanji IDs and need independent due state.
- QA-A-027 canonical ebook candidates are not used as authoritative input yet because blocker says target kanji ambiguity is unresolved.

## OPEN_QUESTIONS

- Exact owner screenshot spacing cannot be pixel-matched because screenshots are described, not attached in repo. Temporary decision: use current app spacing tokens plus 8px card radius.
- Some v1 rules are broad heuristics, not deterministic mappings. Temporary decision: `reference_only` when safe candidate pool is too small or confidence is low.
- Review queue final shape may need iteration. Temporary decision: add rule due CTA first, then compact due card once rule SRS is proven.
- Dynamic personalized sampling depends on available user SRS state. Temporary decision: static generated practice first, personalization after reference-rule flow is stable.
