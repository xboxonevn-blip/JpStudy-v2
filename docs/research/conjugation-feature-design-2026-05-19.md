# Japanese Conjugation Learning Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a real Japanese verb/adjective conjugation learning loop that connects Grammar, Vocab, Kanji, mistakes, and SRS instead of showing guessed forms.

**Architecture:** Keep conjugation rules in a pure Dart engine, keep source-derived lemma metadata in the read-only content database, and keep learner state in `AppDatabase` with FSRS fields matching vocab/grammar/kanji/kana. UI entry points are scoped: Vocab detail for a word, Grammar detail for a form requirement, Kanji detail for conjugatable example words, and Practice/Daily Plan for due reviews.

**Tech Stack:** Flutter, Riverpod, Drift, local JSON assets, `FsrsService`, `MistakeRepository`, GoRouter, Firebase Hosting live proof.

---

## Phase 0 Result

This is a design-only batch for `QA-C-001`. No implementation code is changed in this phase.

Audit finding to fix during implementation: [lib/features/vocab/screens/vocab_detail_screen.dart](../../lib/features/vocab/screens/vocab_detail_screen.dart) currently builds `_conjugationLines` by suffix guessing. This is learner-facing and unsafe: godan `帰る` and ichidan `起きる` cannot be separated by `る`, godan `待つ` would be guessed as `待つて`, and adjectives are not supported. The `ます grammar` chip opens generic Grammar, not the relevant conjugation drill.

## Sources And Licensing

Use these source boundaries:

- JMdict official project page: https://www.edrdg.org/jmdict/j_jmdict.html
- JMdict DTD/POS entity reference: https://www.edrdg.org/jmdict/jmdict_dtd_h.html
- EDRDG license: https://www.edrdg.org/edrdg/licence.html
- Existing repo source policy: [docs/free-web-stack-reference.md](../free-web-stack-reference.md)
- Existing JLPT policy: [docs/jlpt-exam-source-reference.md](../jlpt-exam-source-reference.md)

Rules:

- Use JMdict POS tags for conjugation class. Do not infer class from word ending when a JMdict match exists.
- Use bundled curriculum vocab as the learner inventory. Do not import unclear-license JLPT word lists to expand scope.
- Store attribution/source IDs in generated metadata. Current content vocab already carries `sourceVocabId` and `sourceSenseId`.
- Do not add `vi-human-approved`. Conjugation labels can be `source-derived` or `vi-source-verified` only when source/copy was checked.

## App Audit

Current connected surfaces:

- Grammar routes: `/#/grammar`, `/#/grammar/:id`, `/#/grammar-practice`.
- Vocab routes: `/#/vocab`, catalogs, `/#/vocab/:id`, `/#/vocab/review`.
- Kanji routes: `/#/kanji`, `/#/kanji/practice`, `/#/kanji/han-viet`.
- Review surfaces: Daily Plan, Practice Board, Mistakes, Weakness Radar, Progress.

Current data shape:

- `ContentDatabase.vocab`: `id`, `term`, `reading`, `meaning`, `meaningEn`, `sourceVocabId`, `sourceSenseId`, `series`, `level`, `tags`.
- `AppDatabase.userLessonTerm`: user-facing vocab/SRS term copy.
- `SrsState`, `GrammarSrsState`, `KanjiSrsState`, `KanaSrsState`: FSRS-like state with stability/difficulty/state/step/due date.
- `UserMistakes`: supports arbitrary `type`, but dashboard copy/providers currently assume vocab/grammar/kanji counts.

Inventory checked:

- `assets/data/content/index.json`: `16,712` vocab entries, `754` grammar entries, `929` kanji entries.
- Static vocab JSON tag audit found only `661` entries tagged `verb`; i/na adjective tags are not consistently present. Source POS enrichment is required.

## Learner Model

Conjugation is not a static table. It must teach recognition and production:

- Recognition: choose the lemma/class/form from a seen surface.
- Production: produce or select the correct form from a prompt.
- Context: choose the form needed by a grammar pattern.
- Repair: fix an incorrect form in a sentence.
- SRS: schedule the exact weak skill, not a generic "word learned" toggle.

Skill atom:

```text
conjugationSkillKey =
  contentVocabId + ":" + formKey + ":" + direction

direction = recognize | produce | context | repair
```

Use `contentVocabId` because the conjugatable item is a content lemma. When a vocab SRS update is needed, resolve to `userLessonTerm.id` through `LessonRepository.resolveUserTermIdForContentVocabId`.

## POS Mapping

Store JMdict POS tags, then normalize to an internal class.

Internal classes:

```dart
enum ConjugationKind { verb, iAdjective, naAdjective }

enum VerbClass {
  ichidan,
  godanU,
  godanKu,
  godanGu,
  godanSu,
  godanTsu,
  godanNu,
  godanBu,
  godanMu,
  godanRu,
  godanIkuException,
  suru,
  kuru,
  aruException,
}

enum AdjectiveClass { iAdjective, iiException, naAdjective }
```

JMdict normalization:

- `v1`, `v1-s` -> `ichidan`.
- `v5u`, `v5k`, `v5g`, `v5s`, `v5t`, `v5n`, `v5b`, `v5m`, `v5r` -> matching godan class.
- `v5k-s` -> `godanIkuException`.
- `vs`, `vs-i`, `vs-s` -> `suru`.
- `vk` -> `kuru`.
- `v5r-i` with lemma `ある` -> `aruException`.
- `adj-i` -> `iAdjective`.
- `adj-ix` or lemma `いい` -> `iiException`.
- `adj-na` -> `naAdjective`.

Excluded from conjugation drill unless a later source-backed rule is added: adverbs, nouns, `adj-no`, `adj-pn`, counters, suffix-only items, particles, expressions without a single conjugatable head.

## Form Coverage

Phase 1 forms:

| Form key | Verbs | i-adjectives | na-adjectives | Primary JLPT use |
| --- | --- | --- | --- | --- |
| dictionary | yes | yes | stem + だ | N5 base |
| masu | yes | no | no | N5 polite |
| nai | yes | yes | stem + ではない | N5/N4 negative |
| ta | yes | yes | stem + だった | N5/N4 past |
| te | yes | くて | stem + で | N5/N4 linking |
| ba | yes | ければ | stem + なら | N4 conditional |
| tara | yes | かったら | stem + だったら | N4 conditional |
| volitional | yes | かろう | だろう | N4/N3 |
| potential | yes | no | no | N4 |
| passive | yes | no | no | N4/N3 |
| causative | yes | no | no | N4/N3 |
| causativePassive | yes | no | no | N3+ |
| imperative | yes | no | no | N4/N3 |
| adverbial | no | く | stem + に | N5/N4 |

Phase 1 does not include dialectal variants, literary forms beyond common JLPT grammar, or honorific/humble lexical replacements as engine-generated forms. Honorific/humble remains grammar content unless a source-backed special-verb table is added.

## Engine Rules

Create a pure Dart engine under `lib/core/conjugation/`.

Key files:

- `conjugation_class.dart`: enums and source POS normalization.
- `conjugation_form.dart`: form keys and display labels.
- `conjugation_result.dart`: generated surface, reading, notes, accepted alternatives.
- `japanese_conjugator.dart`: deterministic generation.
- `conjugation_exceptions.dart`: `行く`, `来る`, `する`, `ある`, `いい`, and suru-compound handling.

Fixture minimum:

- Ichidan: `食べる`, `起きる`.
- Godan: `書く`, `泳ぐ`, `話す`, `待つ`, `死ぬ`, `遊ぶ`, `読む`, `帰る`, `買う`.
- Exceptions: `行く`, `する`, `勉強する`, `来る`, `ある`.
- Adjectives: `高い`, `いい`, `静か`.

Acceptance rule:

- Recognition questions can accept the generated surface.
- Production questions can accept generated surface plus explicitly listed common alternatives.
- Reading variants are displayed when known, but primary grading is by Japanese surface in Phase 1.

## Content Data Model

Add read-only content tables:

```dart
class ConjugationLemma extends Table {
  IntColumn get id => integer()();
  IntColumn get contentVocabId => integer().references(Vocab, #id)();
  TextColumn get term => text()();
  TextColumn get reading => text().nullable()();
  TextColumn get dictionaryForm => text()();
  TextColumn get dictionaryReading => text().nullable()();
  TextColumn get kind => text()(); // verb | i_adjective | na_adjective
  TextColumn get conjugationClass => text()();
  TextColumn get posTagsJson => text()();
  TextColumn get sourceVocabId => text().nullable()();
  TextColumn get sourceSenseId => text().nullable()();
  TextColumn get level => text()();
  TextColumn get series => text()();
}
```

Do not store every generated form in content DB. Generate forms from the engine at runtime and verify them by tests. This avoids duplicated content and makes rule fixes global.

Bundled source asset:

```text
assets/data/content/conjugation/lemmas.json
```

`lemmas.json` contains only curriculum vocab entries that map cleanly to a JMdict POS class. It must include `source: "JMdict_e"` and a generation timestamp.

## User State Model

Add `ConjugationSrsState` to `AppDatabase`:

```dart
class ConjugationSrsState extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get contentVocabId => integer()();
  TextColumn get formKey => text()();
  TextColumn get direction => text()();
  RealColumn get stability => real().withDefault(const Constant(1.0))();
  RealColumn get difficulty => real().withDefault(const Constant(5.0))();
  IntColumn get fsrsState => integer().withDefault(const Constant(1))();
  IntColumn get fsrsStep => integer().nullable()();
  IntColumn get lastConfidence => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  DateTimeColumn get nextReviewAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {contentVocabId, formKey, direction},
  ];
}
```

Add indexes:

- `idx_conjugation_srs_due ON conjugation_srs_state(next_review_at)`.
- `idx_conjugation_srs_skill ON conjugation_srs_state(content_vocab_id, form_key, direction)`.

Mistakes:

- Add mistake type `conjugation`.
- Store `extraJson`: `contentVocabId`, `formKey`, `direction`, `conjugationClass`, `expectedSurface`, `grammarId` when launched from Grammar.

Unified SRS update:

- Correct conjugation answer updates `conjugation_srs_state`.
- If launched from Vocab detail, also initialize/update vocab SRS for that word with a light grade (`3` correct, `1` wrong).
- If launched from Grammar detail, also record grammar review for the grammar point when the question is grammar-scoped.
- If the word contains kanji and the prompt requires recognizing written form, do not auto-advance kanji SRS; kanji SRS remains tied to kanji reading/handwriting tasks.

## Information Architecture

Routes:

- `/#/grammar/conjugation`: hub for form families and due conjugation reviews.
- `/#/grammar/conjugation/:contentVocabId`: scoped word forms and practice.
- `/#/grammar/conjugation/practice`: session route with query/extra args.

Entry points:

- Grammar hub: card `Chia thể` under Grammar.
- Grammar detail: if `connection` contains a form need (`Vて`, `Vない`, `Vた`, `辞書形`, `可能形`, `受身`, `使役`), show one compact CTA to the relevant form drill.
- Vocab detail: replace `_conjugationLines` with sourced form panel only when a `ConjugationLemma` exists; otherwise hide the section.
- Kanji detail: for examples whose `sourceVocabId`/`sourceSenseId` maps to a `ConjugationLemma`, show `Luyện chia thể từ này`.
- Daily Plan / Practice Board: add due conjugation count after the SRS table exists.
- Mistakes: include `conjugation` as a first-class type, not folded into grammar.

UI copy:

- VI: `Chia thể`, `Luyện chia thể`, `Thể て`, `Thể ない`, `Thể quá khứ`, `Nhận biết`, `Tự tạo`.
- EN: `Conjugation`, `Practice forms`, `te-form`, `nai-form`, `past form`, `Recognize`, `Produce`.
- JA: `活用`, `活用練習`, `て形`, `ない形`, `過去形`, `認識`, `産出`.

## Drill Model

Question families:

- `recognizeForm`: "帰った là thể nào của 帰る?"
- `produceForm`: "Chia 食べる sang thể て."
- `chooseContext`: "Mẫu `てもいい` cần thể nào?"
- `repairForm`: "Sửa: 待つてください."
- `minimalPair`: distinguish godan `帰る` vs ichidan `起きる`.

Session inputs:

```dart
class ConjugationPracticeArgs {
  final List<int>? contentVocabIds;
  final List<String>? formKeys;
  final List<String>? directions;
  final int targetCount;
  final String source; // vocab_detail | grammar_detail | daily_plan | mistakes
  final int? grammarId;
}
```

Grading:

- Correct fast answer -> FSRS grade `4`.
- Correct slow answer -> grade `3`.
- Wrong answer -> grade `1`, add mistake, queue a different follow-up question for the same skill in non-quiz sessions.
- A scoped gate passes at `4/5`; passing can mark the scoped `ConjugationLemma` as "introduced" but must not mark all forms mastered.

## Cross-Link Rules

Grammar -> conjugation:

- Parse grammar `connection` and `grammarPoint` for form tokens.
- Map tokens to form keys:
  - `Vて`, `て形`, `te-form` -> `te`.
  - `Vない`, `ない形`, `nai-form` -> `nai`.
  - `Vた`, `た形`, `past` -> `ta`.
  - `辞書形`, `dictionary form` -> `dictionary`.
  - `可能形`, `potential` -> `potential`.
  - `受身`, `passive` -> `passive`.
  - `使役` -> `causative`.

Vocab -> conjugation:

- Use `contentVocabId` from Vocab detail.
- Resolve lemma from `ConjugationLemma`.
- Show forms grouped by learner level; do not show unsupported guessed rows.

Kanji -> conjugation:

- Use kanji example `sourceVocabId`/`sourceSenseId` where available.
- Link to the matching Vocab detail or directly to scoped conjugation practice.

Mistakes/Weakness:

- Weakness Radar can surface the top conjugation mistakes as `Chia thể yếu`.
- Mistake Bank opens a scoped conjugation repair session with stored `extraJson`.

## Implementation Slices

### Task 1: Engine And Fixtures

**Files:**

- Create: `lib/core/conjugation/conjugation_class.dart`
- Create: `lib/core/conjugation/conjugation_form.dart`
- Create: `lib/core/conjugation/conjugation_result.dart`
- Create: `lib/core/conjugation/japanese_conjugator.dart`
- Create: `lib/core/conjugation/conjugation_exceptions.dart`
- Test: `test/core/conjugation/japanese_conjugator_test.dart`

- [x] Add RED fixtures for the minimum list in "Engine Rules".
- [x] Implement POS normalization and generation.
- [x] Run: `flutter test test/core/conjugation/japanese_conjugator_test.dart`
- [x] Expected: all fixture cases pass, including `待つ -> 待って`, `行く -> 行って`, `帰る -> 帰って`, `起きる -> 起きて`, `いい -> よかった`.

### Task 2: Source Metadata Generator

**Files:**

- Create: `tool/research/build_conjugation_lemmas.dart` or `tooling/build_conjugation_lemmas.py`
- Create: `assets/data/content/conjugation/lemmas.json`
- Modify: `pubspec.yaml`
- Test: `test/tool/research/conjugation_lemma_builder_test.dart`

- [x] Read curriculum vocab assets and JMdict cache.
- [x] Match by `sourceVocabId`/`sourceSenseId` when present, then by `(term, reading)`, plus source-backed generated `ます` forms for polite curriculum verbs.
- [x] Emit only entries with a supported POS class.
- [x] Run: `flutter test test/tool/research/conjugation_lemma_builder_test.dart`
- [x] Expected: builder rejects suffix-only guesses and reports unmatched conjugatable-looking vocab.

Slice output: `assets/data/content/conjugation/lemmas.json` contains `3907`
source-backed lemma rows from JMdict_e. Diagnostics are retained in the asset:
`198` unmatched conjugatable-looking rows, `183` suffix-only skips, and `153`
ambiguous matches for later normalization/content cleanup. No suffix-only row is
used as a conjugation lemma.

### Task 3: Content DB Lemma Table

**Files:**

- Modify: `lib/data/db/content_tables.dart`
- Modify: `lib/data/db/content_database.dart`
- Modify generated: `lib/data/db/content_database.g.dart`
- Create: `lib/data/repositories/conjugation_repository.dart`
- Test: `test/data/content/conjugation_content_seed_test.dart`

- [x] Add `ConjugationLemma` table and indexes.
- [x] Seed active level metadata from `assets/data/content/conjugation/lemmas.json`.
- [x] Add repository lookups by content vocab id, level, due skill ids, and source ids.
- [x] Run: `dart run build_runner build --delete-conflicting-outputs`
- [x] Run: `flutter test test/data/content/conjugation_content_seed_test.dart`
- [x] Expected: `帰る` and `起きる` keep different classes; non-conjugatable nouns do not return lemma rows.

Slice output: ContentDatabase schema v36 seeds active-level
`ConjugationLemma` rows from the JMdict-backed asset after vocab rows exist.
`ConjugationRepository` can resolve by content vocab id, source ids, level, and
due content vocab ids. The N5 regression proves `帰る` remains `godanRu`,
`起きる` remains `ichidan`, `学生` returns no lemma, and N4 stays unseeded
when the active level is N5.

### Task 4: App DB SRS And Mistakes

**Files:**

- Modify: `lib/data/db/app_database.dart`
- Create: `lib/data/db/conjugation_tables.dart`
- Create: `lib/data/daos/conjugation_srs_dao.dart`
- Modify generated: `lib/data/db/app_database.g.dart`, `lib/data/daos/conjugation_srs_dao.g.dart`
- Modify: `lib/features/mistakes/screens/mistake_screen.dart`
- Modify: `lib/features/home/providers/dashboard_provider.dart`
- Test: `test/data/daos/conjugation_srs_dao_test.dart`
- Test: `test/features/mistakes/conjugation_mistake_screen_test.dart`

- [ ] Add schema migration and due indexes.
- [ ] Implement initialize/update/due-count/stage-count DAO methods.
- [ ] Add mistake type `conjugation` to UI/providers.
- [ ] Run focused DAO and Mistakes tests.
- [ ] Expected: one row per `(contentVocabId, formKey, direction)`; wrong answers appear as conjugation mistakes.

### Task 5: Practice Session

**Files:**

- Create: `lib/features/conjugation/models/conjugation_practice_args.dart`
- Create: `lib/features/conjugation/services/conjugation_question_generator.dart`
- Create: `lib/features/conjugation/screens/conjugation_practice_screen.dart`
- Create: `lib/features/conjugation/screens/conjugation_hub_screen.dart`
- Modify: `lib/app/navigation/app_route_constants.dart`
- Modify: `lib/app/navigation/routes/grammar_routes.dart`
- Test: `test/features/conjugation/conjugation_practice_screen_test.dart`

- [ ] Use shared select -> confirm answer UX.
- [ ] Generate recognition, production, context, repair, and minimal-pair questions.
- [ ] Update conjugation SRS and mistakes on each answer.
- [ ] Run focused practice tests.
- [ ] Expected: selecting an answer does not commit until confirm; wrong `待つて` stores a repair mistake; due count updates.

### Task 6: Connected UI Surfaces

**Files:**

- Modify: `lib/features/vocab/screens/vocab_detail_screen.dart`
- Modify: `lib/features/vocab/providers/vocab_detail_provider.dart`
- Modify: `lib/features/grammar/screens/grammar_detail_screen.dart`
- Modify: `lib/features/kanji_hub/kanji_hub_screen_parts.dart`
- Modify: `lib/features/home/providers/daily_plan_provider.dart`
- Modify: `lib/features/practice/providers/practice_session_board_provider.dart`
- Test: `test/features/vocab/vocab_detail_conjugation_test.dart`
- Test: `test/features/grammar/grammar_detail_conjugation_link_test.dart`
- Test: `test/features/kanji_hub/kanji_detail_conjugation_link_test.dart`
- Test: `test/features/home/daily_plan_conjugation_test.dart`

- [ ] Delete `_conjugationLines`.
- [ ] Show sourced form panel only for lemmas with metadata.
- [ ] Add scoped CTAs from Vocab, Grammar, Kanji, Daily Plan, and Practice Board.
- [ ] Run focused surface tests.
- [ ] Expected: Vocab detail for `待つ` shows `待って`; Vocab detail for a noun hides forms; Grammar `Vて` detail opens te-form drill; Kanji example word links to the same scoped drill.

### Task 7: Gates, Deploy, Live Proof

**Files:**

- Modify: `docs/research/quality-backlog.md`
- Modify: `docs/research/autonomous-loop-status.md`
- Modify: `docs/research/app-experience-audit-2026-05-20.md`

- [ ] Run: `python tooling/audit_ui_string_literals.py --check`
- [ ] Run: `flutter analyze lib test`
- [ ] Run focused conjugation suites.
- [ ] Run full `flutter test` because this changes app logic, DB schema, routes, and shared review state.
- [ ] Run: `node tool/deploy/hosting_deploy.js`
- [ ] Live proof VI/N5: open Vocab detail for one godan and one ichidan, verify forms and CTAs.
- [ ] Live proof VI/N4: open Grammar detail with `Vて`, start scoped conjugation drill.
- [ ] Live proof VI/N3: open Kanji detail with conjugatable example, follow CTA.
- [ ] Bundle scan: no fake forms from `_conjugationLines`; no `vi-human-approved` added.

## Acceptance Checklist

- No learner-facing self-attestation.
- No suffix-only conjugation guessing.
- Every displayed form comes from `ConjugationLemma` + `JapaneseConjugator`.
- Vocab, Grammar, Kanji, Mistakes, Daily Plan, and Practice Board all connect to the same conjugation route/service.
- SRS uses exact skill atoms; clearing one form does not mark all forms mastered.
- Wrong answers create actionable `conjugation` mistakes.
- `vi-source-verified` may be used only for checked copy/source; `vi-human-approved` is not added.
