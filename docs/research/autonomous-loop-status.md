# Autonomous Loop Status

## 2026-05-17

- Track A P0/P1 seed backlog created in `docs/research/quality-backlog.md`.
- Verified locally: Profile shell click routes to `/me`; selected branch is derived from URL path; stale branch index no longer drives selection.
- Verified locally: VI copy guards cover the reported vocab/review leaks and review-page metaphors.
- Verified locally: Vietnamese vocab catalog status badges no longer render `Companion` or duplicate `Bổ trợ`.
- Verified locally: upper-level generated/prefixed Minna lesson titles fall back to Shin Kanzen curriculum titles.
- Verified locally: the Home/Review next-lesson action maps level-scoped storage IDs such as `200001` back to Shin Kanzen source lesson titles.
- Still unverified: live deployed proof on `https://jpstudy.web.app` after deploy/cache-clear.
- Still pending: Track B `vi-source-verified` content verification loop. No `vi-human-approved` tags added.

## 2026-05-17 Continued

- Verified + pushed: `624ac24c fix(vocab): wire Shin Kanzen catalog tracks`.
- Verified locally: `flutter analyze lib test`, `python tooling/audit_ui_string_literals.py --check`, `flutter test test/data/content_review_taxonomy_integrity_test.dart`, and full `flutter test` passed with 2298 tests.
- Deployed: Firebase Hosting `jpstudy` from `624ac24c`.
- Verified live after deploy: `/#/vocab/shinkanzen?level=N3` shows 25 lessons / 404 terms and non-zero rows; N2 shows 25 lessons / 1797 terms; N1 shows 25 lessons / 3476 terms.
- Added pending backlog: roadmap honesty gate (P0), grammar practice gate (P1), quiz answer-selection redesign (P1).
- Still pending: Track A roadmap honesty gate next; Track B `vi-source-verified` loop not started in this continuation.

## 2026-05-17 Roadmap Gate

- Verified locally: QA-A-007 roadmap is no longer a decorative list. Resource chips now carry real destinations; upper levels sequence Shin Kanzen vocab before grammar; Hajimete is optional; listening is not rendered without audio inventory; fixed month promises are replaced by adaptive hour labels.
- Verified locally: `flutter test test/features/home/models/textbook_roadmap_test.dart test/features/home/learning_path_foundations_gate_test.dart`, `flutter analyze lib test`, `python tooling/audit_ui_string_literals.py --check`, `flutter test test/data/content_review_taxonomy_integrity_test.dart`, and full `flutter test` passed with 2299 tests.
- Verified live after deploy with cache disabled: N3 roadmap no longer shows fixed month/listening stages, and visible chips opened non-empty routes for Shin Kanzen vocab, Hajimete optional vocab, grammar, kanji, immersion, and exam.
- Still unverified: full chip-by-chip live sweep at N5/N4/N2/N1. A long N2/N1 batch timed out before returning a complete result, so it is not counted as verified.
- Added pending backlog: Kanji Hán-Việt route/language gating (P0), per-language kanji UX (P1), and JLPT-complete kanji expansion (P2).

## 2026-05-17 Han-Viet Route Gate

- Verified locally: QA-A-010 no longer routes Hán-Việt rules through the N5-only Kana gate. `/foundations/han-viet` renders at N4, and Kanji hub exposes a new `/kanji/han-viet` action only for Vietnamese UI.
- Verified locally: EN UI hides the Kanji Hán-Việt rules action. Focused tests, `flutter analyze lib test`, `python tooling/audit_ui_string_literals.py --check`, taxonomy guard, and full `flutter test` passed with 2301 tests.
- Verified live after deploy with cache disabled: N3 `/kanji/han-viet` renders Hán-Việt rules, legacy `/foundations/han-viet` also renders rules without the Kana lock, and EN Kanji hides the Hán-Việt action.

## 2026-05-17 Quiz Answer Selection Slice

- Verified locally: grammar multiple-choice questions now require select -> confirm; tapping an option no longer commits immediately.
- Verified locally: four-answer grammar multiple-choice uses a 2x2 grid on wide layouts and a compact one-column mobile layout with all options plus the confirm button hit-testable inside a 390x640 viewport.
- Verified locally: grammar practice no longer repeats the full mode/config card on every question; the top row is reduced to question count, progress, and question type.
- Verified live after deploy `4622e4c5`: desktop `/#/grammar-practice` shows one slim top row, four answers in a 2x2 grid, and disabled `Answer` until selection; mobile 390x640 shows question, four compact answer rows, and `Answer` in one viewport.
- Verified live after deploy `4622e4c5`: tapping a mobile answer then `Answer` advances from question 1 to question 2, proving select -> confirm is active.
- Still pending: one shared quiz component across lesson test, grammar gate, and JLPT mock/exam.

## 2026-05-17 Learn Multiple-Choice Confirm Slice

- Verified locally: lesson learn multiple-choice no longer submits on option tap; option tap only selects and the `learn_mc_confirm` button submits.
- Verified locally: `flutter test test/features/learn/learn_screen_test.dart test/features/test/test_screen_submit_test.dart test/features/test/test_screen_feedback_test.dart` passed.
- Verified locally: `flutter test test/features/learn/widgets/learn_widgets_test.dart` passed.
- Still unverified: deployed/live proof for lesson learn multiple-choice after this commit.
- Still pending: one shared quiz component across lesson test, grammar gate, and JLPT mock/exam.

## 2026-05-17 Lesson Test Mobile Layout Slice

- Live check after deploy `12283ccc` found lesson test mobile still broken: the header text wrapped vertically and the answer area did not fit.
- Verified locally with new guard: `flutter test test/features/test/test_screen_mobile_layout_test.dart` passes and catches the former mobile overflow under a 390x540 shell-height viewport.
- Verified locally: focused learn/test/grammar regression suites passed after compacting the shared learn multiple-choice/true-false primitives and TestScreen mobile header.
- Follow-up live check after `bcf3052a` still failed for lesson-test MC: only A/B were visible. Fixed with commits `59b16a2b`, `5d72d991`, and `cd93753f`.
- Verified locally after `cd93753f`: `flutter analyze lib test`, `python tooling/audit_ui_string_literals.py --check`, `flutter test test/data/content_review_taxonomy_integrity_test.dart`, focused learn/test/mock suites, and full `flutter test` passed with 2306 tests.
- Deployed `cd93753f` to Firebase Hosting.
- Verified live after cache clear at `https://jpstudy.web.app/?codexFresh=cd93753f#/lesson/1` with 390x640 viewport: lesson-test true/false choices fit; lesson-test MC shows question, all four choices, and `Kiểm tra` in one viewport; tapping an option only selects and enables `Kiểm tra`.
- Still pending: one shared quiz component across lesson test, grammar gate, and JLPT mock/exam.
- Added/confirmed pending Kanji backlog: per-language kanji UX (Vietnamese Hán-Việt-centric; English hides Hán-Việt; Japanese immersion) and phased KANJIDIC2/Unihan kanji expansion with reachability guards.

## 2026-05-18 Kanji Per-Language Detail Slice

- Verified locally: Vietnamese Kanji detail shows a Hán-Việt row, Vietnamese mnemonic, and the inline Hán-Việt panel.
- Verified locally: English and Japanese Kanji detail hide Hán-Việt rows/panels; English shows the English mnemonic.
- Verified locally: Kanji card semantics now use language-specific labels instead of Vietnamese-only `Học/onyomi/kunyomi` copy.
- Verified locally: `flutter test test/features/kanji_hub/kanji_hub_screen_test.dart`, `flutter test test/features/kanji_hub/kanji_hub_semantics_test.dart`, `flutter analyze lib test`, `python tooling/audit_ui_string_literals.py --check`, `flutter test test/data/content_review_taxonomy_integrity_test.dart`, and full `flutter test` passed with 2309 tests.
- Still pending: live proof after deploy; kanji lesson/practice/search consumers; Japanese definition data completeness; phased KANJIDIC2/Unihan expansion.

## 2026-05-18 Kanji Han-Viet Seed Backfill

- Live check after `9471f273` found the detail labels updated, but the Hán-Việt row was still absent for seeded production kanji because `labels.hanViet` was not copied into `decomposition_json`.
- Verified locally: content DB schema v33 reseeds kanji, and the new DB regression confirms `人` carries `decomposition.hanViet = Nhân`.
- Verified locally: `flutter test test/data/db/content_database_lazy_seed_test.dart`, kanji hub tests, kanji semantics tests, `flutter analyze lib test`, string guard, taxonomy guard, and full `flutter test` passed with 2310 tests.
- Deployed `edcfa4ff` to Firebase Hosting.
- Verified live with cache-disabled/new-page checks: Vietnamese `人` detail shows `Hán-Việt Nhân`; English `人` detail hides Hán-Việt UI and shows English mnemonic; Japanese `作` detail hides Hán-Việt UI. Japanese definition data is still incomplete and falls back to English meaning, so that remains pending.

## 2026-05-18 Kanji Search Language Gate

- Verified locally: English Search no longer matches hidden Hán-Việt keywords; Vietnamese Search still matches Hán-Việt queries.
- Verified locally: `flutter test test/features/search/search_screen_test.dart`, `flutter analyze lib test`, `python tooling/audit_ui_string_literals.py --check`, taxonomy guard, and full `flutter test` passed with 2311 tests.
- Still pending: live proof of Search Hán-Việt keyword gating; kanji lesson/practice consumers.

## 2026-05-18 Kanji Lesson/Practice Language Slice

- Verified locally: lesson kanji list hides Hán-Việt labels and Vietnamese decomposition component names for EN/JA, while VI still shows them.
- Verified locally: Japanese lesson kanji, kanji reading home, kanji reading quiz, and handwriting practice no longer show Vietnamese meanings when an English fallback exists.
- Verified locally: `flutter test test/features/lesson/widgets/kanji_list_widget_test.dart test/features/kanji_reading/kanji_reading_quiz_screen_test.dart test/features/kanji_reading/home_kanji_reading_screen_test.dart test/features/write/handwriting_walkthrough_test.dart` passed.
- Verified locally: `flutter analyze lib test`, UI string guard, taxonomy guard, and full `flutter test` passed with `2317` tests after the lesson/practice consumer slice.
- Deployed `4747b677` to Firebase Hosting.
- Verified live after deploy: Japanese Kanji detail for `作` shows the English fallback `make, create` and no Hán-Việt row/panel; Japanese Search query `nhan` returns no matches, so hidden Vietnamese Hán-Việt keywords do not drive results.
- Verified live after deploy: Japanese lesson Kanji tab for N5 shows English fallback meanings and no Hán-Việt fields. Japanese Kanji Reading practice shows English fallback meaning `exploits, achievements` and no Hán-Việt fields.
- Still broken before follow-up fix: Japanese `書く` from Kanji Practice blanked the content area. Console showed `RangeError: max must be in range 0 < max <= 2^32, was 0`, traced to `Random().nextInt(1 << 32)` in handwriting session seed generation after web compilation.
- Fixed locally: replaced the seed max with a web-safe constant and added a regression guard that failed before the fix. `flutter analyze lib test`, UI string guard, taxonomy guard, focused handwriting tests, and full `flutter test` passed with `2318` tests.
- Deployed `b07d10f6` to Firebase Hosting.
- Verified live after deploy: Japanese `/#/kanji/practice` -> `書く` renders `手書き: N3 — 新しい漢字`, shows `leader, commander` as the fallback meaning, and no longer logs the RangeError. The only new warning was the existing manifest icon warning.
- Still pending: real Japanese definition data.

## 2026-05-17 Kanji Japanese Meaning Plumbing

- Verified inventory gap: `assets/data/content` currently has `0` `meaningJa` fields, so live Japanese Kanji cannot yet show native Japanese definitions without new source-backed data.
- Implemented locally: `KanjiItem.meaningJa`, `KanjiItem.displayMeaning(AppLanguage)`, content DB schema v34, seed/repository mapping for `labels.meaningJa`, and consumer wiring for Kanji detail/grid, Search, lesson Kanji list, Kanji Reading, and Handwriting.
- Added focused regressions using synthetic `meaningJa` values so Japanese UI prefers Japanese definitions when available, then falls back to English/Vietnamese honestly when not.
- Verified locally: focused Kanji/search/write tests passed, `flutter analyze lib test` passed, UI string guard reported `0` candidates, taxonomy guard passed, and full `flutter test` passed with `2321` tests.
- Deployed `a3648697` to Firebase Hosting. Live smoke with Japanese prefs showed the Kanji hub using Japanese chrome and English fallback meanings. This verifies the no-data fallback path only; real Japanese definitions remain unverified because the assets still have `0` `meaningJa` fields.
- Still pending: source-backed Japanese definition content and phased JLPT-complete kanji expansion; do not claim Japanese immersion data completeness yet.

## 2026-05-18 Kanji Content DB Self-Heal

- Verified root cause for the owner-reported Kanji load regression: an existing content DB can have a current schema version while physically missing `kanji.meaning_ja`, causing Drift reads/seeds to fail before Kanji grid or handwriting practice can load.
- Fixed in `ed47e8ae`: content DB now self-heals `meaning_ja` in `beforeOpen` and before upper kanji reseeds during upgrade. Added regression DB fixtures for v34 and pre-v33 databases missing the column.
- Verified locally: `flutter test test/data/db/content_database_lazy_seed_test.dart`, `flutter analyze lib test`, `python tooling/audit_ui_string_literals.py --check`, `flutter test test/data/content_review_taxonomy_integrity_test.dart`, `dart run tool/research/content_vi_status_report.dart`, and full `flutter test` all passed; full suite ended at `2326`.
- Deployed to Firebase Hosting `jpstudy`.
- Verified live after deploy: VI/EN/JA across N5/N4/N3/N2/N1 loaded real Kanji grid rows and `Write/Viết/書く` handwriting practice; the 15-combo Playwright matrix had `failed=0` and `consoleErrors=0`.
- Still pending: old-browser IndexedDB migration cannot be directly proven against a production user DB without owning that browser state; the local regression fixtures cover the missing physical column path that caused the failure class.

## 2026-05-18 Kanji Expansion Audit Baseline

- Added a reproducible KANJIDIC2 old-JLPT coverage audit for QA-B-002. The local KANJIDIC2 XML remains a `.codex` cache and is ignored, not committed.
- Verified locally: `flutter test test/core/research/kanji_coverage_audit_test.dart test/tool/research/kanji_coverage_audit_report_test.dart` passed. The real-cache CLI run completed against `assets/data/content`.
- Baseline: current unique Kanji `638`; KANJIDIC2 old-JLPT unique `2230`; missing source kanji N5 `33`, N4 `157`, N2 `654`, N1 `1168`. KANJIDIC2 has no modern N3 tier, so N3 expansion still needs a separate modern JLPT source.
- Still pending: no generated Kanji were added yet; reachability guards and source-backed modern JLPT level mapping must come before expansion batches.

## 2026-05-18 Kanji Runtime Reachability Guard

- Added `test/data/content/kanji_runtime_reachability_test.dart` so every authored kanji asset entry must seed into `ContentDatabase` and return from `LessonRepository.fetchKanjiByLevel`.
- This protects the shared Kanji UI consumer path: grid, search, SRS, reading practice, and handwriting practice all depend on level fetches.
- Verified locally: `flutter test test/data/content/kanji_runtime_reachability_test.dart` passed. No new Kanji content generated yet.

## 2026-05-18 Kanji Expansion Source Policy

- Verified source boundary: official JLPT does not publish modern vocabulary/kanji/grammar lists; KANJIDIC2 and Unihan are redistribution-safe fact sources, but KANJIDIC2 only has old JLPT tiers.
- Added `docs/research/D2-content/kanji-expansion-source-policy-2026-05-18.md`.
- Decision: do not bulk-copy third-party modern JLPT kanji lists with unclear licenses. N5/N4 can start from KANJIDIC2 old tiers; N3/N2/N1 need a redistribution-safe modern mapping or owner-approved curriculum mapping before generation.

## 2026-05-18 N5 Kanji Completeness Patch

- Source-verified four N5 kanji with missing `meaningVi`: `二`, `三`, `漢`, `雪`.
- Corrected `二` Hán-Việt from native meaning `Hai` to `Nhị`; corrected `三` from `Ba` to `Tam`; added natural Vietnamese meanings/search text for all four.
- Changed these edited entries to `vi-source-verified` and updated taxonomy/content-status tooling to treat that tag as an approval signal. No `vi-human-approved` tag was added.
- Added content DB schema v35 reseed so these asset edits reach existing users, with a regression for stale v34 `二/Hai` content.
- Logged sources in `docs/research/D2-content/verification-log-2026-05-18.md`.
- Verified locally: kanji coverage audit now reports N5 incomplete current entries `0`; content status remains machine/open-review `0`; focused taxonomy/reachability/audit tests passed.

## 2026-05-18 N4 Kanji Related-Kanji Patch

- Filled empty `relatedKanji` lists for 13 N4 kanji: `色`, `予`, `静`, `危`, `以`, `文`, `死`, `飛`, `包`, `乾`, `疑`, `配`, `参`.
- No Hán-Việt, meanings, readings, or examples changed in this batch.
- Verified locally: kanji coverage audit now reports N4 incomplete current entries `0`; focused reachability/audit tests passed.

## 2026-05-18 N3 Kanji Lesson 02 Completeness Patch

- Source-verified all eight N3 lesson-02 kanji (`将`, `来`, `目`, `標`, `計`, `画`, `努`, `力`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `将`, `標`, `計`, `画`, `努`; normalized learner-facing Vietnamese display/search text; filled all lesson-02 `relatedKanji` lists.
- Added entry-level `vi-source-verified` tags for the eight edited entries. No `vi-human-approved` tag was added.
- Verified locally: JSON parses and kanji coverage audit reduced N3 incomplete current entries from `182` to `174`.
- Added content DB metadata revision `2` so post-v35 asset metadata edits reseed for existing browsers, with a regression covering a current-version stale `将` row.
- Verified live after deploying `a8ae956c` against the existing Playwright browser IndexedDB: N3 Kanji grid loaded, `将` detail showed updated Vietnamese display `tướng, tương lai`, `/kanji/practice` -> `Viết` loaded `Viết tay: N3 - Học kanji mới`, and console errors remained `0`.

## 2026-05-18 N3 Kanji Lesson 03 Completeness Patch

- Source-verified all eight N3 lesson-03 kanji (`節`, `約`, `無`, `駄`, `再`, `資`, `源`, `環`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `節`, `無`, `再`, `源`, and `環`; normalized lowercase Hán-Việt on `駄`/`資`; rewrote learner-facing Vietnamese display/search text for all eight entries; filled all lesson-03 `relatedKanji` lists.
- Replaced lesson-03 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `3` so existing browsers with revision `2` receive the new lesson-03 metadata; regression now starts from `content_meta.kanjiSeedRevision=2` and stale `節`.
- Verified locally: lesson JSON parses, focused DB/reachability/taxonomy/coverage tests passed, UI string guard stayed at `0`, and kanji coverage audit reduced N3 incomplete current entries from `174` to `168`.
- Deployed `42769e1b` to Firebase Hosting and verified live with cache-bypass while preserving IndexedDB: N3 Kanji grid loaded lesson-03 row (`節`, `約`, `無`, `駄`, `再`, `資`, `源`, `環`), `節` detail showed `Tiết (tiết; đốt; giai đoạn)` plus Hán-Việt `Tiết`, and console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 04 Completeness Patch

- Source-verified all eight N3 lesson-04 kanji (`留`, `学`, `文`, `化`, `言`, `語`, `交`, `流`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `化`, `言`, `語`, `交`, and `流`; normalized learner-facing Vietnamese display/search text for all eight entries; filled all lesson-04 `relatedKanji` lists.
- Replaced lesson-04 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `4` so existing browsers with revision `3` receive the new lesson-04 metadata; regression now starts from `content_meta.kanjiSeedRevision=3` and stale `化`.
- Verified locally: lesson JSON parses, focused DB/reachability/taxonomy/coverage tests passed, UI string guard stayed at `0`, content status stayed machine/open-review `0`, and kanji coverage audit reduced N3 incomplete current entries from `168` to `164`.
- Deployed `8516dc04` to Firebase Hosting and verified live after CDP cache-disabled reload: searching `化` opened the N3 lesson-04 detail with `Hóa (biến đổi; -hóa)` plus Hán-Việt `Hóa`; console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 05 Completeness Patch

- Source-verified all eight N3 lesson-05 kanji (`就`, `職`, `面`, `接`, `給`, `残`, `責`, `任`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `就`, `職`, `接`, `給`, `責`, and `任`; normalized lowercase Hán-Việt on `面`/`残`; rewrote learner-facing Vietnamese display/search text for all eight entries; filled all lesson-05 `relatedKanji` lists.
- Replaced lesson-05 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `5` so existing browsers with revision `4` receive the new lesson-05 metadata; regression now starts from `content_meta.kanjiSeedRevision=4` and stale `任`.
- Verified locally: lesson JSON parses, focused DB/reachability/taxonomy/coverage tests passed, UI string guard stayed at `0`, content status stayed machine/open-review `0`, and kanji coverage audit reduced N3 incomplete current entries from `164` to `156`.
- Deployed `5dc748ad` to Firebase Hosting and verified live with cache disabled: `任` detail showed `Nhậm (trách nhiệm; giao phó)` plus Hán-Việt `Nhậm`; console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 06 Completeness Patch

- Source-verified all eight N3 lesson-06 kanji (`注`, `文`, `配`, `送`, `返`, `品`, `評`, `価`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `返`, `品`, and `評`; normalized lowercase Hán-Việt on `価`; rewrote learner-facing Vietnamese display/search text for all eight entries; filled all lesson-06 `relatedKanji` lists.
- Replaced lesson-06 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `6` so existing browsers with revision `5` receive the new lesson-06 metadata; regression now starts from `content_meta.kanjiSeedRevision=5` and stale `返`.
- Verified locally: lesson JSON parses, focused DB/reachability/taxonomy/coverage tests passed, and kanji coverage audit reduced N3 incomplete current entries from `156` to `148`.
- Deployed `9a35ca6a` to Firebase Hosting and verified live with cache disabled: search `返` opened detail showing `Phản (trả lại; quay lại)` plus Hán-Việt `Phản`; console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 07 Completeness Patch

- Source-verified all eight N3 lesson-07 kanji (`健`, `康`, `睡`, `眠`, `栄`, `養`, `治`, `療`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `健`, `康`, `睡`, `栄`, `養`, `治`, and `療`; rewrote learner-facing Vietnamese display/search text for all eight entries; filled all lesson-07 `relatedKanji` lists.
- Replaced lesson-07 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `7` so existing browsers with revision `6` receive the new lesson-07 metadata; regression now starts from `content_meta.kanjiSeedRevision=6` and stale `健`.
- Verified locally: lesson JSON parses, focused DB/reachability/taxonomy/coverage tests passed, and kanji coverage audit reduced N3 incomplete current entries from `148` to `141`.
- Deployed `7d036448` to Firebase Hosting and verified live with cache disabled: search `健` opened detail showing `Kiện (khỏe mạnh; sức khỏe)` plus Hán-Việt `Kiện`; console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 08 Completeness Patch

- Source-verified all eight N3 lesson-08 kanji (`伝`, `統`, `祭`, `季`, `節`, `神`, `礼`, `祖`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `統`, `祭`, `季`, `節`, and `神`; normalized lowercase Hán-Việt on `祖`; rewrote learner-facing Vietnamese display/search text for all eight entries; filled all lesson-08 `relatedKanji` lists.
- Replaced lesson-08 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `8` so existing browsers with revision `7` receive the new lesson-08 metadata; regression now starts from `content_meta.kanjiSeedRevision=7` and stale `統`.
- Verified locally: lesson JSON parses, focused DB/reachability/taxonomy/coverage tests passed, and kanji coverage audit reduced N3 incomplete current entries from `141` to `133`.
- Deployed `6019e798` to Firebase Hosting and verified live with cache-bypass while preserving IndexedDB: N3 Kanji grid loaded, searching `統` returned one result, detail opened with `Thống (thống nhất; quản lý; hệ thống)` plus Hán-Việt `Thống`, and console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 09 Completeness Patch

- Source-verified all eight N3 lesson-09 kanji (`新`, `聞`, `雑`, `誌`, `放`, `報`, `記`, `論`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `誌`, `放`, `報`, `記`, and `論`; normalized lowercase Hán-Việt on `雑`; rewrote learner-facing Vietnamese display/search text for all eight entries; filled all lesson-09 `relatedKanji` lists.
- Replaced lesson-09 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `9` so existing browsers with revision `8` receive the new lesson-09 metadata; regression now starts from `content_meta.kanjiSeedRevision=8` and stale `誌`.
- Verified locally: lesson JSON parses, focused DB/reachability/taxonomy/coverage tests passed, UI string guard stayed at `0`, content status stayed machine/open-review `0`, full `flutter test` passed with `2329` tests, and kanji coverage audit reduced N3 incomplete current entries from `133` to `125`.
- Deployed `7b22c3df` to Firebase Hosting and verified live with cache-bypass while preserving IndexedDB: N3 Kanji grid loaded, searching `誌` returned one result, detail opened with `Chí (tạp chí; ghi chép)` plus Hán-Việt `Chí`, and console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 10 Completeness Patch

- Source-verified all eight N3 lesson-10 kanji (`旅`, `観`, `交`, `通`, `予`, `約`, `宿`, `泊`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `観`, `交`, `宿`, and `泊`; kept pedagogic `Dự` for `予` despite source mismatch because Japanese `予` compounds map to `dự` for learners; rewrote learner-facing Vietnamese display/search text for all eight entries; filled all lesson-10 `relatedKanji` lists.
- Replaced lesson-10 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `10` so existing browsers with revision `9` receive the new lesson-10 metadata; regression now starts from `content_meta.kanjiSeedRevision=9` and stale `観`.
- Verified locally: lesson JSON parses, focused DB/reachability/taxonomy/coverage tests passed, UI string guard stayed at `0`, content status stayed machine/open-review `0`, full `flutter test` passed with `2329` tests, and kanji coverage audit reduced N3 incomplete current entries from `125` to `117`.
- Deployed `5db208d6` to Firebase Hosting and verified live with cache-bypass while preserving IndexedDB: N3 Kanji grid loaded, searching `観` returned one result, detail opened with `Quan (xem; quan sát; quan điểm)` plus Hán-Việt `Quan`, and console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 11 Completeness Patch

- Source-verified all eight N3 lesson-11 kanji (`震`, `災`, `害`, `避`, `難`, `洪`, `津`, `警`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `災`, `害`, `避`, `難`, `洪`, and `警`; normalized lowercase Hán-Việt on `震` and `津`; rewrote learner-facing Vietnamese display/search text for all eight entries; filled all lesson-11 `relatedKanji` lists.
- Replaced lesson-11 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `11` so existing browsers with revision `10` receive the new lesson-11 metadata; regression now starts from `content_meta.kanjiSeedRevision=10` and stale `災`.
- Verified locally: lesson JSON parses, focused DB/reachability/taxonomy/coverage tests passed, UI string guard stayed at `0`, content status stayed machine/open-review `0`, full `flutter test` passed with `2329` tests, and kanji coverage audit reduced N3 incomplete current entries from `117` to `110`.
- Deployed `5fb47313` to Firebase Hosting and verified live with cache-bypass while preserving IndexedDB: N3 Kanji grid loaded, searching `災` returned one result, detail opened with `Tai (thiên tai; tai họa)` plus Hán-Việt `Tai`, and console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 12 Completeness Patch

- Source-verified all eight N3 lesson-12 kanji (`芸`, `術`, `演`, `劇`, `鑑`, `賞`, `奏`, `撮`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for all eight entries; kept pedagogic `Nghệ` for Japanese shinjitai `芸術` despite KANJIDIC2 listing `芸` as `Vân`; rewrote learner-facing Vietnamese display/search text; filled all lesson-12 `relatedKanji` lists.
- Replaced lesson-12 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `12` so existing browsers with revision `11` receive the new lesson-12 metadata; regression now starts from `content_meta.kanjiSeedRevision=11` and stale `芸`.
- Verified locally: `flutter analyze lib test`, UI string guard (`0` candidates), content status report (machine/open-review `0`), full `flutter test` (`2329` passed), and kanji coverage audit reduced N3 incomplete current entries from `110` to `102`.
- Deployed `6eb06479` to Firebase Hosting and verified live with cache-bypass while preserving IndexedDB: N3 Kanji grid loaded, searching `芸` returned one result, detail opened with `Nghệ (nghệ thuật; tài nghệ)` plus Hán-Việt `Nghệ`, and console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 13 Completeness Patch

- Source-verified all eight N3 lesson-13 kanji (`教`, `育`, `課`, `題`, `績`, `席`, `卒`, `導`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `課`, `績`, `卒`, and `導`; capitalized/normalized Hán-Việt on `題` and `席`; rewrote learner-facing Vietnamese display/search text; filled all lesson-13 `relatedKanji` lists.
- Replaced lesson-13 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `13` so existing browsers with revision `12` receive the new lesson-13 metadata; regression now starts from `content_meta.kanjiSeedRevision=12` and stale `課`.
- Verified locally: focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, full `flutter test` passed with `2329` tests, and kanji coverage audit reduced N3 incomplete current entries from `102` to `95`.
- Deployed `cf404253` to Firebase Hosting and verified live with cache-bypass while preserving IndexedDB: N3 Kanji grid loaded, searching `課` returned one result, detail opened with `Khóa (bài học; khóa học; phần bài)` plus Hán-Việt `Khóa`, and console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 14 Completeness Patch

- Source-verified all eight N3 lesson-14 kanji (`族`, `戚`, `婦`, `育`, `結`, `離`, `援`, `頼`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `族`, `戚`, `婦`, `結`, `離`, and `援`; normalized `育` and `頼`; rewrote learner-facing Vietnamese display/search text; filled all lesson-14 `relatedKanji` lists.
- Replaced lesson-14 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `14` so existing browsers with revision `13` receive the new lesson-14 metadata; regression now starts from `content_meta.kanjiSeedRevision=13` and stale `族`.
- Verified locally: focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, full `flutter test` passed with `2329` tests, and kanji coverage audit reduced N3 incomplete current entries from `95` to `87`.
- Deployed `59a896fe` to Firebase Hosting and verified live with cache-bypass while preserving IndexedDB: N3 Kanji grid loaded, searching `族` returned one result, detail opened with `Tộc (gia tộc; dân tộc; dòng họ)` plus Hán-Việt `Tộc`, and console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 15 Completeness Patch

- Source-verified all eight N3 lesson-15 kanji (`住`, `宅`, `築`, `賃`, `貸`, `設`, `備`, `民`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `築`, `設`, `備`, and `民`; normalized housing/rent/equipment learner meanings and search text for all eight entries; filled all lesson-15 `relatedKanji` lists.
- Replaced lesson-15 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `15` so existing browsers with revision `14` receive the new lesson-15 metadata; regression now starts from `content_meta.kanjiSeedRevision=14` and stale `住`.
- Verified locally: focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, full `flutter test` passed with `2329` tests, and kanji coverage audit reduced N3 incomplete current entries from `87` to `79`.
- Deployed `38d88d85` to Firebase Hosting and verified live with cache-bypass while preserving IndexedDB: N3 Kanji grid loaded, searching `住` returned one result, detail opened with `Trú (sống ở; cư trú; nơi ở)` plus Hán-Việt `Trú`, VI write practice loaded `Viết tay: N3 - Học kanji mới`, and console errors/warnings remained `0`.

## 2026-05-18 N3 Kanji Lesson 16 Completeness Patch

- Source-verified all eight N3 lesson-16 kanji (`試`, `勝`, `負`, `選`, `練`, `優`, `決`, `審`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `試`, `勝`, `負`, `練`, and `審`; normalized `選`, `優`, and `決`; rewrote learner-facing Vietnamese display/search text; filled all lesson-16 `relatedKanji` lists.
- Replaced lesson-16 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `16` so existing browsers with revision `15` receive the new lesson-16 metadata; regression now starts from `content_meta.kanjiSeedRevision=15` and stale `試`.
- Verified locally: JSON parse passed, focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, full `flutter test` passed with `2329` tests, and kanji coverage audit reduced N3 incomplete current entries from `79` to `71`.
- Deployed with `78febd31`; live proof included cache-disabled N3 Kanji grid and write flow loading with console warnings/errors `0`.

## 2026-05-18 QA-A-014 Kanji Content DB Partial-Coverage Repair

- Owner reported a P0 deployed regression where VI/N3 `/#/kanji` and `/#/kanji/practice` could still fail after the prior `meaning_ja` self-heal.
- Fresh-storage live check loaded N3 Kanji grid with `203` items and `Luyện viết (N3)`, so assets and fresh DB seeding are valid.
- Root cause found locally: startup self-heal only checked whether each JLPT level had any kanji rows. A current-version content DB with one stale N3 row and `content_meta.kanjiSeedRevision=16` skipped reseed and stayed partial.
- Added a RED regression for that current-version partial DB; it failed because `試` was absent. Implemented manifest-count coverage repair by comparing per-level DB counts to `assets/data/content/index.json` and reseeding only incomplete kanji levels.
- Verified locally: the new regression passes; focused native DB/reachability tests pass; `flutter test -d chrome test/data/content/kanji_runtime_reachability_test.dart` passes; UI string guard stays at `0`; content status machine/open-review stays `0`; taxonomy guard passes; `flutter analyze lib test` is clean; full `flutter test` passes with `2330`.
- Built and deployed `78febd31` to Firebase Hosting.
- Live proof with CDP cache disabled: VI Kanji grid loaded non-empty for N5, N4, N3, N2, and N1; VI write practice loaded `Viết tay: N1 — Học kanji mới`; EN grid and handwriting loaded with English copy; JA grid and handwriting loaded with Japanese copy; console warnings/errors remained `0`.

## 2026-05-18 N3 Kanji Lesson 17 Completeness Patch

- Source-verified all eight N3 lesson-17 kanji (`科`, `技`, `明`, `験`, `開`, `発`, `機`, `械`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for `技` and `械`; normalized `験`; rewrote learner-facing Vietnamese display/search text for all eight entries; filled all lesson-17 `relatedKanji` lists.
- Replaced lesson-17 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `17` so existing browsers with revision `16` receive the new lesson-17 metadata; regression now starts from `content_meta.kanjiSeedRevision=16` and stale `技`.
- Verified locally: JSON parse passed, coverage audit reduced N3 incomplete current entries from `71` to `63`, focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, and full `flutter test` passed with `2330`.
- Live proof is pending after commit, push, build, and deploy.

## 2026-05-18 QA-A-015 Kanji Runtime Ensure Deadlock Repair

- Verified issue: `test/data/content/kanji_runtime_reachability_test.dart` hung because `LessonRepository.fetchKanjiByLevel` called public `ContentDatabase.ensureKanjiContentCurrent()` before the first content DB query.
- Root cause: that public ensure opened Drift; `beforeOpen` then awaited the same pending public ensure, causing a startup deadlock for unopened content DBs. Repository-level Kanji caches were also cleared on every Kanji read.
- Fix: `beforeOpen` now runs the private Kanji ensure path; public ensure returns whether it repaired content; `LessonRepository` ensures once per lifecycle and clears Kanji caches only on first use or actual repair.
- Verified locally: `flutter test test\data\db\content_database_lazy_seed_test.dart`, `flutter test test\data\content\kanji_runtime_reachability_test.dart`, focused Kanji/taxonomy subset, `flutter analyze lib test`, UI string guard, and node research tests all passed.
- Deployed `833ed3c8` to Firebase Hosting. Live proof: VI N3 Kanji grid loaded `203` entries, VI `Viết` opened real Kanji data (`将`); EN Kanji grid loaded; JA Kanji grid loaded; JA `214` radicals loaded. Remaining Kanji work: continue QA-B-002 source verification and expansion.

## 2026-05-18 N3 Kanji Lesson 18 Completeness Patch

- Source-verified all eight N3 lesson-18 kanji (`法`, `律`, `規`, `則`, `犯`, `罪`, `裁`, `制`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values for seven entries; rewrote learner-facing Vietnamese display/search text; filled all lesson-18 `relatedKanji` lists.
- Replaced lesson-18 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `19` and added a lesson-18 sentinel for `裁` so existing browsers receive the new metadata even when level counts are already full.
- Verified locally: JSON parse passed, coverage audit reduced N3 incomplete current entries from `63` to `55`, focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, and content status report machine/open-review `0`.
- Deployed `777a5c13` to Firebase Hosting. Live proof: search `裁` opened detail showing `Tài (xét xử; phán quyết; cắt may)` plus Hán-Việt `Tài`.

## 2026-05-18 N3 Kanji Lesson 19 Completeness Patch

- Source-verified all eight N3 lesson-19 kanji (`料`, `理`, `食`, `材`, `味`, `調`, `保`, `鮮`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values, corrected `材` from the wrong Vietnamese gloss `tài liệu` to material/ingredient meaning, rewrote learner-facing Vietnamese display/search text, and filled all lesson-19 `relatedKanji` lists.
- Replaced lesson-19 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `20` and added a lesson-19 sentinel for `材` so existing browsers receive the correction even when level counts are already full.
- Verified locally: JSON parse passed, coverage audit reduced N3 incomplete current entries from `55` to `47`, focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, and content status report machine/open-review `0`.
- Deployed `7be4d16` to Firebase Hosting. Live proof: search `材` opened detail showing `Tài (nguyên liệu; vật liệu; gỗ)` plus Hán-Việt `Tài`.

## 2026-05-18 N3 Kanji Lesson 20 Completeness Patch

- Source-verified all eight N3 lesson-20 kanji (`感`, `情`, `不`, `安`, `緊`, `張`, `怒`, `悲`) against KANJIDIC2, Unihan, and local lesson context.
- Filled missing Hán-Việt values, rewrote learner-facing Vietnamese display/search text, and filled all lesson-20 `relatedKanji` lists.
- Replaced lesson-20 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `21` and added a lesson-20 sentinel for `感` so existing browsers receive the updated metadata even when level counts are already full.
- Verified locally before commit: JSON parse passed, coverage audit reduced N3 incomplete current entries from `47` to `39`, focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, and content status report machine/open-review `0`.
- Deployed `edd1ac06` to Firebase Hosting. Live proof: search `感` opened detail showing `Cảm (cảm xúc; cảm giác; cảm nhận)` plus Hán-Việt `Cảm`. The live session also recorded one existing minified console stack without a message; not treated as proof of zero-console state.

## 2026-05-18 N3 Kanji Lesson 21 Completeness Patch

- Source-verified all eight N3 lesson-21 kanji (`経`, `済`, `利`, `益`, `投`, `収`, `税`, `財`) against KANJIDIC2, Unihan, and the explicit local economy/finance theme.
- Filled missing Hán-Việt values, corrected `済` from wrong learner-facing `tể` to `Tế`, rewrote display/search text, and filled all lesson-21 `relatedKanji` lists.
- Replaced lesson-21 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `22` and added a lesson-21 sentinel for `財`.
- Verified locally: JSON parse passed, coverage audit reduced N3 incomplete current entries from `39` to `31`, focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, and content status report machine/open-review `0`.
- Built and deployed `008767e8` to Firebase Hosting. Live proof after service-worker/cache bypass while preserving IndexedDB: search `財` opened detail showing `Tài (tài sản; của cải; tiền bạc)` plus Hán-Việt `Tài`, with console errors/warnings `0`.

## 2026-05-18 N3 Kanji Lesson 22 Completeness Patch

- Source-verified all eight N3 lesson-22 kanji (`説`, `紹`, `介`, `謝`, `議`, `翻`, `訳`, `連`) against KANJIDIC2, Unihan, and the explicit local communication/expression theme.
- Filled missing Hán-Việt values, normalized lowercase Hán-Việt labels, rewrote display/search text, and filled all lesson-22 `relatedKanji` lists.
- Replaced lesson-22 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `23` and added a lesson-22 sentinel for `説`.
- Verified locally: JSON parse passed, coverage audit reduced N3 incomplete current entries from `31` to `23`, focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, and content status report machine/open-review `0`.
- Built and deployed `c0aea700` to Firebase Hosting. Live proof after service-worker/cache bypass while preserving IndexedDB: search `説` opened detail showing `Thuyết (giải thích; học thuyết; ý kiến)` plus Hán-Việt `Thuyết`, with console errors/warnings `0`.

## 2026-05-18 N3 Kanji Lesson 23 Completeness Patch

- Source-verified all eight N3 lesson-23 kanji (`歴`, `史`, `政`, `治`, `戦`, `争`, `平`, `和`) against KANJIDIC2, Unihan, and the explicit local history/politics theme.
- Filled missing Hán-Việt values, normalized lowercase Hán-Việt labels, rewrote display/search text, and filled all lesson-23 `relatedKanji` lists.
- Replaced lesson-23 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `24` and added a lesson-23 sentinel for `歴`.
- Verified locally: JSON parse passed, coverage audit reduced N3 incomplete current entries from `23` to `16`, focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, and content status report machine/open-review `0`.
- Built and deployed `b32bf246` to Firebase Hosting. Live proof after service-worker/cache bypass while preserving IndexedDB: search `歴` opened detail showing `Lịch (lịch sử; trải qua; quá trình)` plus Hán-Việt `Lịch`, with console errors/warnings `0`.

## 2026-05-18 N3 Kanji Lesson 24 Completeness Patch

- Source-verified all eight N3 lesson-24 kanji (`流`, `行`, `着`, `替`, `化`, `粧`, `装`, `飾`) against KANJIDIC2, Unihan, and the explicit local fashion/personal-style theme.
- Filled missing Hán-Việt values, normalized learner-facing Vietnamese display/search text, replaced generated null source examples with direct examples, and filled all lesson-24 `relatedKanji` lists.
- Replaced lesson-24 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `25` and added a lesson-24 sentinel for `流`.
- Verified locally: JSON parse passed, coverage audit reduced N3 incomplete current entries from `16` to `8`, focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, and content status report machine/open-review `0`.
- Built and deployed `f1f7d692` to Firebase Hosting. Live proof: search `流` opened the lesson-24 detail showing `Lưu (dòng chảy; lưu hành; trôi)` plus Hán-Việt `Lưu`, with console errors/warnings `0`.

## 2026-05-18 N3 Kanji Lesson 25 Completeness Patch

- Source-verified all eight N3 lesson-25 kanji (`際`, `貧`, `困`, `難`, `汚`, `染`, `平`, `等`) against KANJIDIC2, Unihan, and the explicit local global-issues/volunteering theme.
- Filled missing Hán-Việt values, normalized learner-facing Vietnamese display/search text, replaced generated null source examples with direct examples, and filled all lesson-25 `relatedKanji` lists.
- Replaced lesson-25 file-level `vi-human-approved` with truthful `vi-source-verified` and added entry-level `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `26` and added a lesson-25 sentinel for `際`.
- Verified locally: JSON parse passed, coverage audit reduced N3 incomplete current entries from `8` to `0`, focused DB/reachability/taxonomy/coverage tests passed, `flutter analyze lib test` clean, UI string guard `0`, and content status report machine/open-review `0`.
- Built and deployed `ba226c46` to Firebase Hosting. Live proof after service-worker/cache bypass while preserving IndexedDB: search `際` opened the lesson-25 detail showing `Tế (dịp; ranh giới; khi)` plus Hán-Việt `Tế`, with console errors/warnings `0`.

## 2026-05-18 Kanji P0 Recheck + Grammar Practice Gate Slice

- Rechecked the owner-reported Kanji data-load regression before touching new work. Current repo already contains QA-A-013/014/015 repairs; focused migration guards passed for fresh DB, pre-v33 DB, missing `meaning_ja`, stale revision, partial current DB, full-count stale sentinel, duplicate sentinel, and runtime repair.
- Live proof on `https://jpstudy.web.app/#/kanji` with existing Playwright IndexedDB and VI/N3: grid loaded `203` kanji, `/#/kanji/practice` -> `Viết` opened `Viết tay: N3 — Học kanji mới`, and console warnings/errors after navigation were `0`.
- QA-A-008 first implementation slice: grammar detail no longer exposes manual `Mark done` / `Đánh dấu đã học`; it shows `In progress` or `Understood ✓`, opens a shared `/grammar-practice` 5-question gate, and a >=4/5 pass auto-marks the grammar point learned. Existing per-answer SRS and mistake logging remain in the shared practice screen.
- Verified locally: focused grammar tests, `flutter analyze lib test`, `python tooling\audit_ui_string_literals.py --check`, taxonomy guard, and full `flutter test` (`2335`) passed.
- Deployed `57bc7698` to Firebase Hosting. Live proof with fresh EN/N5 browser: `/#/grammar/1` showed `In progress` + `Practice check`, clicking it opened `Practice check` with `Question 1 of 5`, and console warnings/errors were `0`. Still pending: authored/shared bank manifest guard; grammar SRS/exam consumer audit.

## 2026-05-18 Grammar Practice Bank Guard Slice

- Hypothesis: QA-A-008 still had a structural gap because generated grammar questions were produced directly by the screen, `index.json` did not advertise the grammar-practice dataset, and there was no guard preventing zero-question grammar points or future authored-question orphans.
- Verified RED first: the new guard failed because `GrammarPracticeBank` did not exist and `index.json` lacked `grammarPractice`.
- Fixed locally: added `GrammarPracticeBank` as the shared generated-question entry point, routed `GrammarPracticeScreen` through it, added `assets/data/content/grammar_practice/authored_bank.json`, registered `grammarPractice` in the content manifest, and added guard coverage for all seeded N5-N1 grammar points plus authored-bank orphan checks.
- Verified locally: `flutter test test\data\content\grammar_practice_bank_guard_test.dart test\data\content\content_manifest_test.dart test\features\grammar\grammar_practice_screen_test.dart --reporter expanded`, `flutter analyze lib test`, `python tooling\audit_ui_string_literals.py --check`, taxonomy guard, and full `flutter test` passed (`2337`). This is a structural guard slice; no new live UX claim made.
- Still pending: JLPT mock grammar items still use a local builder path and must be consolidated onto the shared bank before QA-A-008 is fully closed.

## 2026-05-18 JLPT Mock Grammar Bank Slice

- Hypothesis: the remaining QA-A-008 consumer gap was real because `jlpt_mock_bank.dart` built grammar mock questions with local `grammar-*-meaning/pattern` IDs and prompts, not `GrammarPracticeBank`.
- Verified RED first: `flutter test test\features\jlpt\jlpt_mock_bank_lazy_seed_test.dart --reporter expanded` failed when asserting shared-bank question-type IDs.
- Fixed locally: adapted content DB grammar rows/examples into runtime grammar records, generated mock grammar questions through `GrammarPracticeBank`, and removed the old local grammar prompt/meaning builders.
- Verified locally: `flutter test test\features\jlpt\jlpt_mock_bank_lazy_seed_test.dart test\features\jlpt\jlpt_mock_bank_test.dart --reporter expanded`, `flutter analyze lib test`, UI string guard, taxonomy guard, focused grammar-bank guard, and full `flutter test` passed (`2338`).

## 2026-05-18 QA-A-009 Shared Answer Selection Slice

- Rechecked the owner-reported Kanji data-load P0 before new work. Current QA-A-013/014/015 repairs still cover fresh, stale, partial, and existing-browser DB paths; live VI/N3 Kanji grid and `Viết` loaded real data with console warnings/errors `0`.
- Hypothesis: QA-A-009 still had one real gap because JLPT Mock Pro answers were committed immediately inside `_MockQuestionCard`, while grammar gate and lesson/test MC had already moved to select -> confirm.
- Verified RED first: `flutter test test\features\jlpt\jlpt_mock_pro_screen_test.dart --reporter expanded` failed because active JLPT Mock Pro had no `Trả lời` confirm button.
- Fixed locally: added `SharedAnswerSelection`, reused it from grammar multiple choice, lesson/test multiple choice, and JLPT Mock Pro, and kept surface-specific option tiles through a shared selection/confirm state machine.
- Verified locally: focused JLPT/grammar/learn/test quiz suites passed, `flutter analyze lib test` was clean, UI string guard reported `0`, taxonomy guard passed, `dart run tool\research\content_vi_status_report.dart` reported machine/open-review `0`, `npm run test:research-tooling` passed `54`, and full `flutter test` passed (`2339`). Live post-deploy proof is still pending for this slice.
- Live desktop check after deploy `33d65e3a` verified JLPT Mock Pro selects an answer without increasing progress (`0/18 answered`), then `Answer` commits to `1/18 answered`.
- Live mobile check at `390x640` found a residual layout miss: the shared answer component existed, but JLPT Mock Pro still used the tall active `ListView`, so only the first two answers were visible above the shell nav.
- Added a compact active layout for JLPT Mock Pro that removes the tall hero/progress chrome on small viewports, keeps navigation controls in a slim header, and gives the shared answer component bounded height.
- Verified locally after the compact fix: focused JLPT/grammar/learn/test quiz suites passed, `flutter analyze lib test` was clean, UI string guard reported `0`, taxonomy guard passed, and full `flutter test` passed (`2340`). Live post-deploy proof for the compact mobile fix is still pending.
- Deployed `ea48dd17` to Firebase Hosting. Live proof after cache bypass: mobile `390x640` JLPT Mock Pro showed all four answer choices and `Answer` in one viewport; selecting did not commit until `Answer`; commit changed progress from `0/18` to `1/18`; console warnings/errors after this check were `0`. Desktop still shows the 2x2 answer grid and `Answer` in the active question view.

## 2026-05-18 Kanji Data Load Regression Recheck

- Re-ran the new owner P0 report before continuing content work. No new code change was needed: QA-A-013/014/015 already cover the reported failure class.
- Local regression proof: `flutter test test\data\db\content_database_lazy_seed_test.dart --reporter expanded` passed all 12 cases, including fresh DB, pre-v33 upgrade, v34 missing `meaning_ja`, stale seed revision, partial current-version DB, full-count stale sentinel, duplicate sentinel, runtime repair, and healthy no-op. `flutter test test\data\content\kanji_runtime_reachability_test.dart --reporter expanded` passed.
- Live fresh-IDB proof: deleted the live `content` IndexedDB while preserving normal Hosting, opened VI/N3 `/#/kanji`, and saw the grid render `203` entries. Direct `/#/practice/handwriting` rendered `Viết tay: N3 — Học kanji mới` with real kanji and stroke guidance. Console errors/warnings after filtering external antivirus noise: `0`.
- Live language/level sanity: isolated-context route loads for VI/EN/JA across N5-N1 reported the seeded locale/level correctly after re-running polluted rows in isolated contexts, with app console errors `0` and request failures `0`.
- Status: verified fixed / not reproduced. Remaining kanji work is QA-B-002 content completeness and QA-A-011 Japanese definition data, not app-wide kanji loading.

## 2026-05-18 N2 Kanji Lesson 1 Completeness Patch

- Source-verified all eight N2 lesson-01 kanji (`遭`, `扇`, `青`, `白`, `明`, `飽`, `方`, `揚`) against local KANJIDIC2, Unihan, and the existing N2 vocabulary examples.
- Rewrote English-like `meaningVi` fields into learner-ready Vietnamese, filled readings/search text, added non-empty `relatedKanji`, replaced old `approved-by-user` metadata with `vi-editorial-codex-pass`, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `27` and added an N2 lesson-01 sentinel for `遭` so existing browsers reseed the changed metadata.
- Verified locally: JSON parse passed, coverage audit reduced N2 incomplete current entries from `200` to `192`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, and full `flutter test` passed (`2340`).

## 2026-05-18 N2 Kanji Lesson 2 Completeness Patch

- Source-verified all eight N2 lesson-02 kanji (`挙`, `憧`, `足`, `跡`, `味`, `預`, `暖`, `厚`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote English-like `meaningVi` fields into learner-ready Vietnamese, filled readings/search text, added non-empty `relatedKanji`, replaced old `approved-by-user` metadata with `vi-editorial-codex-pass`, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `28` and added an N2 lesson-02 sentinel for `挙` so existing browsers reseed the changed metadata.
- Verified locally: JSON parse passed, coverage audit reduced N2 incomplete current entries from `192` to `184`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed after updating the cache-header expectation for the new Hosting policy, and full `flutter test` passed (`2340`).
- Built and deployed `8da8be00` to Firebase Hosting. Live proof after cache/service-worker cleanup: VI/N2 Kanji search for `挙` opened detail showing `Cử (giơ lên; nêu ra; tổ chức; hành động)` plus Hán-Việt `Cử`, on `キョ`, kun `あ.げる, あ.がる, こぞ.る`; console warnings/errors `0`.

## 2026-05-18 N2 Kanji Lesson 3 Completeness Patch

- Source-verified all eight N2 lesson-03 kanji (`圧`, `縮`, `宛`, `名`, `暴`, `脂`, `雨`, `戸`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote English-like `meaningVi` fields into learner-ready Vietnamese, filled readings/search text, added non-empty `relatedKanji`, replaced old `approved-by-user` metadata with `vi-editorial-codex-pass`, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `29` and added an N2 lesson-03 sentinel for `圧` so existing browsers reseed the changed metadata.
- Verified locally: JSON parse passed, coverage audit reduced N2 incomplete current entries from `184` to `176`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed, and full `flutter test` passed (`2340`).
- Live proof first found a Hosting cache regression: `main.dart.js` was cached for one day and kept running the previous bundle without the `圧` sentinel. Commit `dff7a998` changed non-fingerprinted Flutter shell/content assets to revalidate and kept only heavy runtime files on long cache. Verified `npm run test:research-tooling`, built/deployed, confirmed live headers, then normal reload fetched `main.dart.js` from network. VI/N2 search `圧` opened `Áp (áp lực; nén; ép)` with Hán-Việt `Áp`, on `アツ, エン, オウ`, kun `お.す, へ.す, おさ.える`; console warnings/errors `0`.

## 2026-05-18 N2 Kanji Lesson 4 Completeness Patch

- Source-verified all eight N2 lesson-04 kanji (`甘`, `余`, `編`, `物`, `危`, `怪`, `荒`, `粗`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote English-like `meaningVi` fields into learner-ready Vietnamese, corrected `物` from the wrong `knitting, web` source gloss to object/thing meaning, filled readings/search text, added non-empty `relatedKanji`, replaced old `approved-by-user` metadata with `vi-editorial-codex-pass`, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `30` and added an N2 lesson-04 sentinel for `甘` so existing browsers reseed the changed metadata.
- Verified locally: JSON parse passed, coverage audit reduced N2 incomplete current entries from `176` to `168`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed, and full `flutter test` passed (`2340`).
- Built/deployed `2683dea2` to Firebase Hosting. Live proof with normal cache: VI/N2 search `甘` opened `Cam (ngọt; dễ dãi; nuông chiều)` with Hán-Việt `Cam`, on `カン`, kun `あま.い, あま.える, あま.やかす, うま.い`; console warnings/errors `0`.

## 2026-05-18 N2 Kanji Lesson 5 Completeness Patch

- Source-verified all eight N2 lesson-05 kanji (`争`, `改`, `著`, `有`, `難`, `在`, `安`, `易`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote English-like or word-gloss-derived Vietnamese into learner-ready Kanji meanings, including correcting `有`/`難` away from the generated `grateful` gloss, filled readings/search text, added non-empty `relatedKanji`, replaced old `approved-by-user`/`kanji-metadata-approved` metadata with `vi-editorial-codex-pass`, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `31` and added an N2 lesson-05 sentinel for `争` so existing browsers reseed the changed metadata.
- Verified locally: JSON parse passed, coverage audit reduced N2 incomplete current entries from `168` to `160`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed, and full `flutter test` passed (`2340`).
- Built/deployed `c33fb9a1` to Firebase Hosting. Live proof after normal reload: VI/N2 search `争` opened `Tranh (tranh chấp; cạnh tranh; cãi nhau)` with Hán-Việt `Tranh`, on `ソウ`, kun `あらそ.う, いか.でか`; console warnings/errors `0`.

## 2026-05-18 N2 Kanji Lesson 6 Completeness Patch

- Source-verified all eight N2 lesson-06 kanji (`案`, `外`, `言`, `出`, `付`, `意`, `義`, `生`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote English-like or word-gloss-derived Vietnamese into learner-ready Kanji meanings, including correcting `外` away from `unexpectedly`, `出` away from `to start talking`, and `生` away from `vividly/lively`; filled readings/search text, added non-empty `relatedKanji`, replaced old `approved-by-user`/`kanji-metadata-approved` metadata with `vi-editorial-codex-pass`, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `32` and added an N2 lesson-06 sentinel for `案` so existing browsers reseed the changed metadata.
- Verified locally: JSON parse passed, coverage audit reduced N2 incomplete current entries from `160` to `152`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed, and full `flutter test` passed (`2340`).
- Built/deployed `4358efd3` to Firebase Hosting. Live proof after normal reload: VI/N2 search `案` opened `Án (ý tưởng; phương án; vụ việc)` with Hán-Việt `Án`, on `アン`, kun `つくえ`; console warnings/errors `0`.

## 2026-05-18 N2 Kanji Lesson 7 Completeness Patch

- Source-verified all eight N2 lesson-07 kanji (`育`, `児`, `幾`, `分`, `花`, `以`, `後`, `降`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `育`/`分`/`後` away from lesson word glosses; filled readings/search text, added non-empty `relatedKanji`, replaced old approval metadata with `vi-editorial-codex-pass`, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `33` and added an N2 lesson-07 sentinel for `育` so existing browsers reseed the changed metadata.
- Verified locally: JSON parse passed, coverage audit reduced N2 incomplete current entries from `152` to `144`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed, and full `flutter test` passed (`2340`).
- Built/deployed `ec6a8a35` to Firebase Hosting. Live proof after fresh live `content` IndexedDB: VI/N2 search for `育` opened `Dục (nuôi dạy; phát triển; giáo dục)` with Hán-Việt `Dục`, on `イク`, kun `そだ.つ, そだ.ち, そだ.てる, はぐく.む`; console warnings/errors `0`.

## 2026-05-19 N2 Kanji Lesson 8 Completeness Patch

- Source-verified all eight N2 lesson-08 kanji (`勇`, `衣`, `食`, `住`, `地`, `悪`, `一`, `応`) against local KANJIDIC2, Unihan where available, variant Unihan for `応`/`應`, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `地` away from `malicious`, `一`/`応` away from `tentatively`, and `衣`/`食`/`住` away from the whole-word `衣食住` gloss; filled readings/search text, added non-empty `relatedKanji`, removed old approval metadata, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `34` and added an N2 lesson-08 sentinel for `勇` so existing browsers reseed the changed metadata.
- Verified locally: JSON parse passed, coverage audit reduced N2 incomplete current entries from `144` to `136`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), and full `flutter test` passed (`2340`).
- Built/deployed `c297667f` to Firebase Hosting. Live proof in VI/N2 `/#/kanji`: filtering `勇` showed the N2 lesson-08 card, and opening it showed `Dũng (dũng cảm; can đảm; khí phách)`, Hán-Việt `Dũng`, on `ユウ`, and kun `いさ.む`. Console cleanliness is not claimed for this proof because the long-lived MCP browser contained stale header-test noise and a separate fresh headless context surfaced a generic Flutter `pageerror` during first-load seeding.

## 2026-05-19 N2 Kanji Lesson 9 Completeness Patch

- Source-verified all eight N2 lesson-09 kanji (`段`, `流`, `佚`, `昨`, `日`, `年`, `斉`, `旦`) against local KANJIDIC2, Unihan where available, existing N2 vocabulary examples, and a Wiktionary Hán-Việt cross-check for learner-facing `年 -> Niên`.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `段` away from `greater, more`, `昨`/`日` away from `day before yesterday`, `年` away from `year before last`, and `旦` away from `once, temporarily`; filled readings/search text, added non-empty `relatedKanji`, removed old approval metadata, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `35` and added an N2 lesson-09 sentinel for `段` so existing browsers reseed the changed metadata.
- Verified locally: JSON parse passed, no false approval/draft tags remain in lesson 09, coverage audit reduced N2 incomplete current entries from `136` to `128`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), and full `flutter test` passed (`2340`).
- Built/deployed `cfe2184e` to Firebase Hosting. Live proof in VI/N2 `/#/kanji` with CDP cache disabled to bypass the one-day Hosting cache: filtering `段` showed the N2 lesson-09 card with on `ダン, タン`, and opening it showed `Đoạn (bậc; đoạn; cấp độ)`, Hán-Việt `Đoạn`, on `ダン, タン`, stroke count `9`, and the rewritten mnemonic. Console warnings/errors after the interaction: `0`.

## 2026-05-19 N2 Kanji Lesson 10 Completeness Patch

- Source-verified all eight N2 lesson-10 kanji (`定`, `移`, `転`, `井`, `緯`, `度`, `従`, `姉`) against local KANJIDIC2, Unihan where available, existing N2 vocabulary examples, and lower-level existing rows where useful for learner-facing Hán-Việt continuity.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `移` from plain meaning gloss `Dời` to Hán-Việt `Di`, `緯`/`度` away from whole-word `latitude`, `従`/`姉` away from whole-word `female cousin`, and `緯` stroke count `15 -> 16`; filled readings/search text, added non-empty `relatedKanji`, removed old approval metadata, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `36` and added an N2 lesson-10 sentinel for `定` so existing browsers reseed the changed metadata.
- Verified locally: JSON parse passed, no false approval/draft tags remain in lesson 10, coverage audit reduced N2 incomplete current entries from `128` to `120`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), and full `flutter test` passed (`2340`).
- Built/deployed `da2242bc` to Firebase Hosting. Live proof in VI/N2 `/#/kanji` with CDP cache disabled: filtering `定` showed the updated N2 lesson-10 card, and opening it showed `Định (quyết định; cố định; ổn định)`, Hán-Việt `Định`, on `テイ, ジョウ`, kun `さだ.める, さだ.まる, さだ.か`, stroke count `8`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal: `0`.

## 2026-05-19 N2 Kanji Lesson 11 Completeness Patch

- Source-verified all eight N2 lesson-11 kanji (`妹`, `威`, `張`, `嫌`, `煎`, `炒`, `入`, `引`) against local KANJIDIC2, Unihan where available, existing N2 vocabulary examples, and lower-level existing rows where useful for learner-facing continuity.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `妹` away from `female cousin`, `威`/`張` away from `to be proud, to swagger`, `入` away from `container`, `引` away from `gravity`, and filling the empty `炒` row; filled readings/search text, added non-empty `relatedKanji`, removed old approval metadata, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `37` and added an N2 lesson-11 sentinel for `妹` so existing browsers reseed the changed metadata.
- Verified locally: JSON parse passed, no false approval/draft tags remain in lesson 11, coverage audit reduced N2 incomplete current entries from `120` to `112`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), and full `flutter test` passed (`2340`).
- Built/deployed `fadf79fb` to Firebase Hosting. Live proof in VI/N2 `/#/kanji` with CDP cache disabled: filtering `妹` showed the updated card, and opening it showed `Muội (em gái; người em nữ)`, Hán-Việt `Muội`, on `マイ`, kun `いもうと`, stroke count `8`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## 2026-05-19 N2 Kanji Lesson 12 Completeness Patch

- Source-verified all eight N2 lesson-12 kanji (`力`, `植`, `木`, `飢`, `浮`, `承`, `受`, `取`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `力` away from `gravity`, `植`/`木` away from `garden shrubs, trees, potted plant`, `承` away from the whole-word humble phrase, and `受`/`取` away from `receipt`; filled readings/search text, added non-empty `relatedKanji`, removed old approval metadata, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `38` and added an N2 lesson-12 sentinel for `力` so existing browsers reseed the changed metadata.
- Verified locally: JSON parse passed, no false approval/draft tags remain in lesson 12, coverage audit reduced N2 incomplete current entries from `112` to `104`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), and full `flutter test` passed (`2340`).
- Built/deployed `ce8ff3a6` to Firebase Hosting. Live proof in VI/N2 `/#/kanji` with CDP cache disabled plus service-worker bypass: filtering `承` showed the updated card, and opening it showed `Thừa (tiếp nhận; thừa nhận; kính nghe)`, Hán-Việt `Thừa`, on `ショウ, ジョウ`, kun `うけたまわ.る, う.ける`, stroke count `8`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## 2026-05-19 N2 Kanji Lesson 13 Completeness Patch

- Source-verified all eight N2 lesson-13 kanji (`持`, `薄`, `暗`, `打`, `合`, `消`, `討`, `映`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `持` to `Trì (cầm; giữ; mang; duy trì)` and filling readings/search text, examples, mnemonics, and related kanji for the batch; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `39` and added an N2 lesson-13 sentinel for `持` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, no false approval/draft tags remain in lesson 13, coverage audit reduced N2 incomplete current entries from `104` to `96`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), and release web build succeeded.
- Built/deployed `0601e111` to Firebase Hosting. Live proof in VI/N2 `/#/kanji` with CDP cache disabled plus service-worker bypass: filtering `持` showed the updated card, and opening it showed `Trì (cầm; giữ; mang; duy trì)`, Hán-Việt `Trì`, on `ジ`, kun `も.つ, -も.ち, も.てる`, stroke count `9`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## 2026-05-19 N2 Kanji Lesson 14 Completeness Patch

- Source-verified all eight N2 lesson-14 kanji (`写`, `無`, `埋`, `敬`, `裏`, `返`, `口`, `占`) against local KANJIDIC2, Unihan where available, lower-level verified rows where useful, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `写` away from photo-only vocabulary gloss, `無` away from flag-marker text, `裏`/`返` away from whole-word `turn inside out`, and `口` away from whole-word `backdoor`; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `40` and added an N2 lesson-14 sentinel for `写` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, no false approval/draft tags remain in lesson 14, coverage audit reduced N2 incomplete current entries from `96` to `88`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), and release web build succeeded.
- Built/deployed `133d038d` to Firebase Hosting. Live proof in VI/N2 `/#/kanji` with CDP cache disabled plus service-worker bypass: filtering `写` showed the updated card, and opening it showed `Tả (chụp lại; sao chép; phản chiếu)`, Hán-Việt `Tả`, on `シャ, ジャ`, kun `うつ.す, うつ.る, うつ-, うつ.し`, stroke count `5`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## 2026-05-19 N2 Kanji Lesson 15 Completeness Patch

- Source-verified all eight N2 lesson-15 kanji (`恨`, `羨`, `売`, `上`, `切`, `行`, `運`, `河`) against local KANJIDIC2, Unihan where available, lower-level verified rows where useful, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `売`/`上` away from whole-word revenue, `切` away from `sold-out`, `行` away from `sales`, and `運`/`河` away from whole-word `canal`; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `41` and added an N2 lesson-15 sentinel for `恨` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, no false approval/draft tags remain in lesson 15, coverage audit reduced N2 incomplete current entries from `88` to `80`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), and release web build succeeded.
- Built/deployed `8d39fa0c` to Firebase Hosting. Live proof in VI/N2 `/#/kanji` with CDP cache disabled plus service-worker bypass: filtering `恨` showed the updated card, and opening it showed `Hận (oán hận; thù hằn; nỗi hận)`, Hán-Việt `Hận`, on `コン`, kun `うら.む, うら.めしい`, stroke count `9`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## 2026-05-19 N2 Kanji Lesson 16 Completeness Patch

- Source-verified all eight N2 lesson-16 kanji (`英`, `文`, `和`, `液`, `体`, `絵`, `具`, `偉`) against local KANJIDIC2, Unihan where available, existing N2 vocabulary examples, and an open Wiktionary spot-check for the `液` Hán-Việt conflict.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `英`/`文` away from whole-word `sentence in English`, `和` away from whole-word `English-Japanese`, `体` away from whole-word `liquid`, `絵`/`具` away from whole-word `paint`, and `偉` away from an overlong English gloss; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `42` and added an N2 lesson-16 sentinel for `英` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, no false approval/draft tags remain in lesson 16, coverage audit reduced N2 incomplete current entries from `80` to `72`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `1f97e53b` to Firebase Hosting. Live proof in VI/N2 `/#/kanji` with CDP cache disabled plus service-worker bypass: filtering `英` showed the updated card, and opening it showed `Anh (Anh; nước Anh; tiếng Anh; ưu tú)`, Hán-Việt `Anh`, on `エイ`, kun `はなぶさ`, stroke count `8`; console warnings/errors `0`.

## 2026-05-19 N2 Kanji Lesson 17 Completeness Patch

- Source-verified all eight N2 lesson-17 kanji (`宴`, `会`, `園`, `芸`, `演`, `劇`, `円`, `周`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `宴`/`会` away from whole-word banquet fallback, `園`/`芸` away from whole-word horticulture fallback, `演`/`劇` away from whole-word theatrical-play fallback, and `円`/`周` away from whole-word circumference fallback; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `43` and added an N2 lesson-17 sentinel for `宴` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, no false approval/draft tags remain in lesson 17, coverage audit reduced N2 incomplete current entries from `72` to `64`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `88aca79a` to Firebase Hosting. Live proof in VI/N2 `/#/kanji`: filtering `宴` showed `宴` and `会`; opening `宴` showed `Yến (yến; tiệc; yến tiệc; tiệc rượu)`, Hán-Việt `Yến`, on `エン`, kun `うたげ`, stroke count `10`; console warnings/errors `0`.

## 2026-05-19 N2 Kanji Lesson 18 Completeness Patch

- Source-verified all eight N2 lesson-18 kanji (`遠`, `延`, `長`, `煙`, `突`, `追`, `掛`, `越`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `遠` away from whole-word `trip`, `延`/`長` away from whole-word extension fallback, `煙`/`突` away from whole-word `chimney`, and `追`/`掛`/`越` away from whole-word chase/pass verbs; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `44` and added an N2 lesson-18 sentinel for `遠` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, no false approval/draft tags remain in lesson 18, coverage audit reduced N2 incomplete current entries from `64` to `56`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `1dc4252f` to Firebase Hosting. Live proof in VI/N2 `/#/kanji`: filtering `遠` showed the updated card, and opening it showed `Viễn (viễn; xa; xa xôi; cách xa)`, Hán-Việt `Viễn`, on `エン, オン`, kun `とお.い`, stroke count `13`; console warnings/errors `0`.

## 2026-05-19 N2 Kanji Lesson 19 Completeness Patch

- Source-verified all eight N2 lesson-19 kanji (`援`, `王`, `女`, `接`, `対`, `往`, `復`, `欧`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `援` away from whole-word help fallback, `王`/`女` away from whole-word `princess`, `接` away from `reception`, `対` away from `receiving, dealing with`, `往`/`復` away from whole-word round-trip fallback, and `欧` away from whole-word `Europe and America`; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `45` and added an N2 lesson-19 sentinel for `援` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, no false approval/draft tags remain in lesson 19, coverage audit reduced N2 incomplete current entries from `56` to `48`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `6e758b11` to Firebase Hosting. Live proof in VI/N2 `/#/kanji`: filtering `援` showed the updated card, and opening it showed `Viện (viện; hỗ trợ; viện trợ; cứu giúp)`, Hán-Việt `Viện`, on `エン`, stroke count `12`; console warnings/errors `0`.

## 2026-05-19 N2 Kanji Lesson 20 Completeness Patch

- Source-verified all eight N2 lesson-20 kanji (`米`, `用`, `大`, `通`, `凡`, `帰`, `拝`, `代`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `米` away from whole-word `Europe and America`, `用` away from application fallback, `大`/`通` away from whole-word `main street`, `凡` away from approximate phrase fallback, `帰` away from whole-word greeting fallback, `拝` away from whole-word worship verb fallback, and `代` away from second-helping fallback; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `46` and added an N2 lesson-20 sentinel for `米` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, no false approval/draft tags remain in lesson 20, coverage audit reduced N2 incomplete current entries from `48` to `40`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `1ed515fd` to Firebase Hosting. Live proof in VI/N2 `/#/kanji`: filtering `米` showed the updated card, and opening it showed `Mễ (mễ; gạo; lúa gạo; Hoa Kỳ)`, Hán-Việt `Mễ`, on `ベイ, マイ, メエトル`, kun `こめ, よね`, stroke count `6`; console warnings/errors `0`.

## 2026-05-19 N2 Kanji Lesson 21 Completeness Patch

- Source-verified all eight N2 lesson-21 kanji (`補`, `屋`, `送`, `仮`, `怠`, `押`, `納`, `治`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `補` away from whole-word `to compensate for`, `屋` away from `outdoors`, `送`/`仮` away from okurigana fallback, `怠` away from an overlong English verb gloss, and `押`/`納`/`治` away from whole-word verb fallbacks; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `47` and added an N2 lesson-21 sentinel for `補` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, coverage audit reduced N2 incomplete current entries from `40` to `32`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `3de785e8` to Firebase Hosting. Live proof in VI/N2 production browser: `/#/kanji` loaded without Kanji data failure; no-store fetch of deployed `lesson_21.json` showed `補` as `Bổ (bổ sung; bù đắp; hỗ trợ)`, Hán-Việt `Bổ`, on `ホ`, kun `おぎな.う`, stroke count `12`; console warnings/errors `0`.

## 2026-05-19 QA-A-017 Hosting Cache Regression

- Owner audit confirmed the one-day cache policy had returned for non-fingerprinted app-shell/content files, invalidating earlier live proofs that used CDP cache-disabled checks.
- Fixed and pushed `feeaca64`: `main.dart.js`, `flutter_bootstrap.js`, `flutter.js`, `assets/AssetManifest*`, and `assets/assets/data/content/**` revalidate with `Cache-Control: no-cache`; `sqlite3.wasm` and `drift_worker.js` keep `public, max-age=2592000`.
- Deployed Firebase Hosting. Header proof with cache-busted live requests: app-shell/content assets returned `no-cache`; wasm/worker returned `public, max-age=2592000`.
- Verification caveat: browsers that already stored a previous `max-age=86400` response for the same unversioned URL may remain stale until that cached response expires; all future responses now prevent another 24h stale window.

## 2026-05-19 N2 Kanji Lesson 22 Completeness Patch

- Source-verified all eight N2 lesson-22 kanji (`惜`, `御`, `辞`, `儀`, `伯`, `父`, `小`, `叔`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `惜` away from whole-word adjective fallback, `御`/`辞`/`儀` away from whole-word `bow`, and `伯`/`父`/`小`/`叔` away from uncle/person phrase fallbacks; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `48` and added an N2 lesson-22 sentinel for `惜` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, coverage audit reduced N2 incomplete current entries from `32` to `24`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `5dd4c6e0` to Firebase Hosting. Live proof after QA-A-017 header redeploy: VI/N2 `/#/kanji` loaded without Kanji data failure; normal-cache fetch of deployed `lesson_22.json` returned `Cache-Control: no-cache`, and `惜` showed `Tiếc (đáng tiếc; trân trọng; không nỡ)`, Hán-Việt `Tiếc`, on `セキ`, kun `お.しい/お.しむ`, stroke count `11`; console warnings/errors `0`.

## 2026-05-19 N2 Kanji Lesson 23 Completeness Patch

- Source-verified all eight N2 lesson-23 kanji (`教`, `落`, `着`, `手`, `洗`, `伝`, `驚`, `各`) against local KANJIDIC2, Unihan where available, existing verified lower-level rows where open sources diverged, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `教` away from whole-word `to be taught`, `落`/`着` away from whole-word calm-down fallback, `手`/`洗` away from purification-font fallback, `伝` away from `maid`, and `驚` away from whole-word causative verb fallback; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `49` and added an N2 lesson-23 sentinel for `教` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, coverage audit reduced N2 incomplete current entries from `24` to `16`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `00cd8047` to Firebase Hosting. Live proof: VI/N2 `/#/kanji` loaded without Kanji data failure; normal-cache fetch of deployed `lesson_23.json` returned `Cache-Control: no-cache`, and `教` showed `Giáo (dạy; giáo dục; giáo lý)`, Hán-Việt `Giáo`, on `キョウ`, kun `おし.える/おそ.わる`, stroke count `11`; console warnings/errors `0`.

## 2026-05-19 N2 Kanji Lesson 24 Completeness Patch

- Source-verified all eight N2 lesson-24 kanji (`母`, `参`, `思`, `込`, `重`, `親`, `指`, `卸`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `母` away from whole-word aunt fallback, `思`/`込` away from whole-word unexpected/convinced fallbacks, `親`/`指` away from whole-word thumb fallback, and `卸` away from whole-word wholesale/grated fallback; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `50` and added an N2 lesson-24 sentinel for `母` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, coverage audit reduced N2 incomplete current entries from `16` to `8`, focused DB/reachability/taxonomy/upper-JLPT tests passed, and release web build passed.
- Built/deployed `af3776a4` to Firebase Hosting. Live proof: VI/N2 `/#/kanji` loaded without Kanji data failure; normal-cache fetch of deployed `lesson_24.json` returned `Cache-Control: no-cache`, and `母` showed `Mẫu (mẹ; mẫu thân; bậc nữ lớn tuổi)`, Hán-Việt `Mẫu`, on `ボ`, kun `はは/も`, stroke count `5`; console warnings/errors `0`.

## 2026-05-19 N2 Kanji Lesson 25 Completeness Patch

- Source-verified all eight N2 lesson-25 kanji (`恩`, `恵`, `温`, `室`, `泉`, `帯`, `中`, `人`) against local KANJIDIC2, Unihan where available, and existing N2 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including correcting `恩`/`恵` away from whole-word grace fallback, `温`/`室` away from whole-word greenhouse fallback, `泉` away from onsen fallback, `帯` away from temperate-zone fallback, `中` away from formal-address suffix fallback, and `人` away from whole-word woman fallback; removed old approval metadata and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `51` and added an N2 lesson-25 sentinel for `恩` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, coverage audit reduced N2 incomplete current entries from `8` to `0`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `3448965e` to Firebase Hosting. Live proof: VI/N2 `/#/kanji` loaded without Kanji data failure; normal-cache fetch of deployed `lesson_25.json` returned `Cache-Control: no-cache`, and `恩` showed `Ân (ơn nghĩa; lòng tốt; ân huệ)`, Hán-Việt `Ân`, on `オン`, stroke count `10`; console warnings/errors `0`.

## 2026-05-19 N1 Kanji Lesson 1 Completeness Patch

- Source-verified all eight N1 lesson-1 kanji (`嗚`, `呼`, `相`, `変`, `愛`, `想`, `対`, `間`) against local KANJIDIC2, Unihan where available, and existing N1 vocabulary examples.
- Rewrote/filled generated metadata, including removing old approval tags, adding source-backed readings and related kanji, fixing `変/愛/対` no-Unihan cases with established learner-facing Hán-Việt, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `52` and added an N1 lesson-1 sentinel for `嗚` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, coverage audit reduced N1 incomplete current entries from `200` to `192`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `dbc11327` to Firebase Hosting. Live proof: VI/N1 `/#/kanji` loaded without Kanji data failure; normal-cache fetch of deployed `lesson_01.json` returned `Cache-Control: no-cache`, and `嗚` showed `Ô (than khóc; tiếng kêu than; chao ôi)`, Hán-Việt `Ô`, on `ウ/オ`, kun `ああ`, stroke count `13`; console warnings/errors `0`.

## 2026-05-19 N1 Kanji Lesson 2 Completeness Patch

- Source-verified all eight N1 lesson-2 kanji (`柄`, `憎`, `合`, `曖`, `昧`, `敢`, `仰`, `垢`) against local KANJIDIC2, Unihan where available, and existing N1 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including fixing `柄` away from handle-only gloss, correcting `憎` stroke count and `愛憎` reading, correcting `敢` stroke count, adding source-backed readings/related kanji, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `53` and added an N1 lesson-2 sentinel for `柄` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, coverage audit kept N2 incomplete current entries at `0` and reduced N1 incomplete current entries from `192` to `184`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `5a9620ac` to Firebase Hosting. Live proof used normal browser cache: shell/content assets returned `Cache-Control: no-cache`, wasm/worker remained `public, max-age=2592000`, and deployed `lesson_02.json` returned `柄` as `Bính (hoa văn; tính chất; tay cầm)` with on `ヘイ`, kun `がら/え/つか`, stroke count `9`.

## 2026-05-19 N1 Kanji Lesson 3 Completeness Patch

- Source-verified all eight N1 lesson-3 kanji (`亜`, `科`, `銅`, `証`, `赤`, `字`, `明`, `白`) against local KANJIDIC2, Unihan where available, and existing N1 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including replacing word-derived readings (`あか`, `あかじ`, `あからさま`) with source-backed kanji readings, correcting `明白` example reading to `めいはく`, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `54` and added an N1 lesson-3 sentinel for `亜` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, coverage audit kept N2 incomplete current entries at `0` and reduced N1 incomplete current entries from `184` to `176`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `8610360c` to Firebase Hosting. Live proof used normal browser cache: shell/content assets returned `Cache-Control: no-cache`, wasm/worker remained `public, max-age=2592000`, and deployed `lesson_03.json` returned `亜` as `Á (châu Á; thứ hai; phụ/á)` with on `ア`, kun `つ.ぐ`, stroke count `7`; console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lesson 4 Completeness Patch

- Source-verified all eight N1 lesson-4 kanji (`上`, `商`, `人`, `空`, `諦`, `呆`, `悪`, `灰`) against local KANJIDIC2, Unihan where available, existing verified rows for duplicate kanji, and existing N1 vocabulary examples.
- Rewrote generated word-gloss fallback rows into learner-ready Kanji meanings, including replacing word-level readings (`あきま`, `あく`) with source-backed kanji/example readings, correcting `灰皿` to `はいざら`, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `55` and added an N1 lesson-4 sentinel for `上` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, coverage audit kept N2 incomplete current entries at `0` and reduced N1 incomplete current entries from `176` to `168`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `b27a84cd` to Firebase Hosting. Live proof used normal browser cache: shell/content assets returned `Cache-Control: no-cache`, wasm/worker remained `public, max-age=2592000`, and deployed `lesson_04.json` returned `上` as `Thượng (trên; lên; tăng)` with on `ジョウ/ショウ/シャン`, stroke count `3`; console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lesson 5 Completeness Patch

- Rechecked the owner cache audit first. Current `main` and live Hosting already have the QA-A-017 fix: `main.dart.js`, `flutter_bootstrap.js`, `flutter.js`, `assets/AssetManifest*`, and `assets/assets/data/content/**` return `Cache-Control: no-cache`; `sqlite3.wasm` and `drift_worker.js` remain `public, max-age=2592000`. Live proof used normal browser cache, not CDP cache-disabled.
- Source-verified all eight N1 lesson-5 kanji (`日`, `憧`, `顎`, `麻`, `後`, `朝`, `寝`, `坊`) against local KANJIDIC2, Unihan where available, existing verified rows, and existing N1 vocabulary examples.
- Rewrote generated word-level readings into source-backed kanji readings, removed old approval metadata, added `vi-source-verified`, and replaced the suspicious `悪日/あくび` example for `日` with `明後日/あさって`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `56` and added an N1 lesson-5 sentinel for `日` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, coverage audit reduced N1 incomplete current entries from `168` to `160`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, node research tooling passed (`54`), full `flutter test` (`2340`), and release web build passed.
- Built/deployed `69a404f9` to Firebase Hosting. Live proof used normal browser cache: shell/content assets returned `Cache-Control: no-cache`, wasm/worker remained `public, max-age=2592000`, deployed `lesson_05.json` returned `日` as `Nhật (ngày; mặt trời; Nhật Bản)` with on `ニチ/ジツ`, kun `ひ/-び/-か`, stroke count `4`, and example `明後日/あさって = ngày mốt`; console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lesson 6 Completeness Patch

- Rechecked the owner cache audit first. Current `main` and live Hosting have the QA-A-017 fix: `main.dart.js`, `flutter_bootstrap.js`, `flutter.js`, `assets/AssetManifest*`, and `assets/assets/data/content/**` return `Cache-Control: no-cache`; `sqlite3.wasm` and `drift_worker.js` remain `public, max-age=2592000`. Verification used normal browser cache and default fetch, not CDP cache-disabled.
- Source-verified all eight N1 lesson-6 kanji (`浅`, `欺`, `鮮`, `笑`, `味`, `東`, `焦`, `彼`) against local KANJIDIC2, Unihan where available, existing verified rows, and existing N1 vocabulary examples.
- Corrected generated metadata, including `浅` stroke count `8 -> 9`, replacing word-level readings with source-backed kanji readings, normalizing learner-facing `東` to `Đông`, replacing the awkward `彼処` example with `彼`, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `57` and added an N1 lesson-6 sentinel for `浅` so existing browsers reseed the changed metadata.
- Verified locally before deploy: coverage audit reduced N1 incomplete current entries from `160` to `152`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, release web build passed, and Firebase Hosting deploy completed.
- Live proof used normal browser cache: shell/content assets returned `Cache-Control: no-cache`, wasm/worker remained `public, max-age=2592000`, deployed `lesson_06.json` returned `浅` as `Thiển (nông; cạn; hời hợt)` with on `セン`, kun `あさ.い`, stroke count `9`, and `vi-source-verified`; console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lesson 7 Completeness Patch

- Source-verified all eight N1 lesson-7 kanji (`処`, `値`, `私`, `当`, `前`, `他`, `方`, `此`) against local KANJIDIC2, Unihan where available, and existing vocabulary examples.
- Corrected generated metadata, including replacing word-level readings with source-backed kanji readings, replacing the sensitive/awkward `彼処` example for `処` with `処理`, correcting `他人` example reading to `たにん`, replacing the ateji `彼方此方` example for `方` with `方法`, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `58` and added an N1 lesson-7 sentinel for `処` so existing browsers reseed the changed metadata.
- Verified locally before deploy: coverage audit reduced N1 incomplete current entries from `152` to `144`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, full `flutter test` passed (`2340`), release web build passed, and Firebase Hosting deploy completed.
- Live proof used normal browser cache: shell/content assets returned `Cache-Control: no-cache`, wasm/worker remained `public, max-age=2592000`, deployed `lesson_07.json` returned `処` as `Xử (xử lý; giải quyết; nơi chốn)` with on `ショ`, kun `ところ/-こ/お.る`, stroke count `5`, and example `処理/しょり = xử lý`; console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lesson 8 Completeness Patch

- Source-verified all eight N1 lesson-8 kanji (`化`, `気`, `口`, `圧`, `迫`, `扱`, `集`, `誂`) against local KANJIDIC2, Unihan where available, existing verified duplicate rows, and existing vocabulary examples.
- Corrected generated metadata, including replacing word-level readings with source-backed kanji readings, aligning duplicate `化`, `口`, and `圧` with verified rows, correcting `誂` away from the misleading English `tempt` gloss, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `59` and added an N1 lesson-8 sentinel for `化` so existing browsers reseed the changed metadata.
- Verified locally before deploy: coverage audit reduced N1 incomplete current entries from `144` to `136`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, full `flutter test` passed (`2340`), release web build passed, and Firebase Hosting deploy completed.
- Live proof used normal browser cache: shell/content assets returned `Cache-Control: no-cache`, wasm/worker remained `public, max-age=2592000`, deployed `lesson_08.json` returned `化` as `Hóa (biến đổi; biến hóa; -hóa)` with on `カ/ケ`, kun `ば.ける/ば.かす/ふ.ける/け.する`, stroke count `4`, and example `悪化/あっか = sự xấu đi; trở nên nghiêm trọng hơn`; console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lesson 9 Completeness Patch

- Rechecked the owner cache audit before continuing. Current `firebase.json` and live Hosting enforce the corrected QA-A-017 policy: `main.dart.js`, `flutter_bootstrap.js`, `flutter.js`, `assets/AssetManifest*`, and `assets/assets/data/content/**` return `Cache-Control: no-cache`; `sqlite3.wasm` and `drift_worker.js` remain `public, max-age=2592000`. Verification used normal browser/page-context fetch, not CDP cache-disabled.
- Source-verified all eight N1 lesson-9 kanji (`力`, `宛`, `跡`, `継`, `回`, `貴`, `女`, `溢`) against local KANJIDIC2, Unihan where available, existing verified duplicate rows, and vocabulary examples.
- Corrected generated metadata, including replacing word-level readings (`あつりょく`, `あとつぎ`, `あとまわし`, `あなた`) with source-backed kanji readings, correcting `女` Hán-Việt from `Nữa` to learner-facing `Nữ`, replacing `貴女/あなた` with `貴い/たっとい`, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `60` and added an N1 lesson-9 sentinel for `力` so existing browsers reseed the changed metadata.
- Verified locally before deploy: hosting cache header guard passed, coverage audit reduced N1 incomplete current entries from `136` to `128`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, full `flutter test` passed (`2340`), release web build passed, and Firebase Hosting deploy completed.
- Live proof used normal browser cache: page-context fetch of deployed `lesson_09.json` returned `Cache-Control: no-cache`; `力` returned `Lực (sức mạnh; lực; năng lực)`, on `リョク/リキ/リイ`, kun `ちから`, and `vi-source-verified`; current page console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lesson 10 Completeness Patch

- Source-verified all eight N1 lesson-10 kanji (`油`, `絵`, `炙`, `甘`, `雨`, `具`, `天`, `網`) against local KANJIDIC2, Unihan where available, existing verified duplicate rows, and vocabulary examples.
- Corrected generated metadata, including replacing word-level readings (`あぶらえ`, `あぶる`, `あまえる`, `あまぐ`) with source-backed kanji readings, normalizing learner-facing `油` to `Du`, replacing bare `天/あまつ` with `天地/あめつち`, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `61` and added an N1 lesson-10 sentinel for `油` so existing browsers reseed the changed metadata.
- Verified locally before deploy: coverage audit reduced N1 incomplete current entries from `128` to `120`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, hosting cache header guard passed, full `flutter test` passed (`2340`), release web build passed, and Firebase Hosting deploy completed.
- Live proof used normal browser cache: page-context fetch of deployed `lesson_10.json` returned `Cache-Control: no-cache`; `油` returned `Du (dầu; chất béo; sơn dầu)`, on `ユ/ユウ`, kun `あぶら`, and `vi-source-verified`; current page console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lesson 11 Completeness Patch

- Source-verified all eight N1 lesson-11 kanji (`地`, `操`, `危`, `過`, `誤`, `歩`, `予`, `荒`) against local KANJIDIC2, Unihan where available, existing verified duplicate rows, and vocabulary examples.
- Corrected generated metadata, including replacing word-level readings (`あめつち`, `あやつる`, `あやぶむ`, `あやまち`, `あやまる`, `あゆみ`, `あらかじめ`, `あらす`) with source-backed kanji readings, correcting learner-facing `予` from generated `Nhừ` to `Dự`, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `62` and added an N1 lesson-11 sentinel for `予` so existing browsers reseed the changed metadata.
- Verified locally before deploy: coverage audit reduced N1 incomplete current entries from `120` to `112`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, hosting cache header guard passed, full `flutter test` passed (`2340`), release web build passed, and Firebase Hosting deploy completed.
- Live proof used normal browser cache: page-context fetch of deployed `lesson_11.json` returned `Cache-Control: no-cache`; `予` returned `Dự (trước; dự tính; chuẩn bị)`, on `ヨ/シャ`, kun `あらかじ.め`, and `vi-source-verified`; current page console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lesson 12 Completeness Patch

- Source-verified all eight N1 lesson-12 kanji (`粗`, `筋`, `争`, `改`, `凡`, `現`, `有`, `難`) against local KANJIDIC2, Unihan where available, existing verified duplicate rows, and vocabulary examples.
- Corrected generated metadata, including replacing word-level readings (`あらすじ`, `あらそい`, `あらたまる`, `あらゆる`, `あらわれ`, `ありがとう`) with source-backed kanji readings, correcting `筋` from vernacular `Gân` to learner-facing Hán-Việt `Cân`, replacing ateji `有難う` examples with clearer `有無`/`困難`, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `63` and added an N1 lesson-12 sentinel for `粗` so existing browsers reseed the changed metadata.
- Verified locally before deploy: coverage audit reduced N1 incomplete current entries from `112` to `104`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, hosting cache header guard passed, full `flutter test` passed (`2340`), release web build passed, and Firebase Hosting deploy completed.
- Live proof used normal browser cache: page-context fetch of deployed `lesson_12.json` returned `Cache-Control: no-cache`; `粗` returned `Thô (thô; sơ sài; thô ráp)`, on `ソ`, kun `あら.い/あら-`, and `vi-source-verified`; current page console errors/warnings `0`.

## 2026-05-19 Cache Audit Recheck + N1 Kanji Lesson 13 Completeness Patch

- Rechecked the owner cache audit before continuing. Current `firebase.json` and live Firebase Hosting have the corrected QA-A-017 policy: `main.dart.js`, `flutter_bootstrap.js`, `flutter.js`, `assets/AssetManifest*`, and `assets/assets/data/content/**` return `Cache-Control: no-cache`; `sqlite3.wasm` and `drift_worker.js` remain `public, max-age=2592000`. Verification used normal browser/page-context fetch, not CDP cache-disabled.
- Source-verified all eight N1 lesson-13 kanji (`様`, `或`, `慌`, `暗`, `殺`, `算`, `示`, `案`) against local KANJIDIC2, Unihan where available, existing verified duplicate rows, and vocabulary examples.
- Corrected generated metadata, including replacing word-level readings (`ありさま`, `あんさつ`, `あんざん`, `あんじ`) with source-backed Kanji readings, correcting `示` from generated `Kì Thị` to learner-facing `Thị`, correcting `案` from generated `An Án Yên` to `Án`, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `64` and added an N1 lesson-13 sentinel for `示` so existing browsers reseed the changed metadata.
- Verified locally before deploy: coverage audit reduced N1 incomplete current entries from `104` to `96`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, hosting cache header guard passed, full `flutter test` passed (`2340`), release web build passed, and Firebase Hosting deploy completed.
- Live proof used normal browser cache: page-context fetch of deployed `lesson_13.json` returned `Cache-Control: no-cache`; `示` returned `Thị (chỉ ra; biểu thị; cho thấy)`, on `ジ/シ`, kun `しめ.す`, example `暗示/あんじ = gợi ý ngầm; ám chỉ`, and `vi-source-verified`; current page console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lesson 14 Completeness Patch

- Source-verified all eight N1 lesson-14 kanji (`安`, `静`, `定`, `余`, `依`, `良`, `伊`, `井`) against local KANJIDIC2, Unihan where available, existing verified duplicate rows, and vocabulary examples.
- Corrected generated metadata, including replacing word-level readings (`あんせい`, `あんのじょう`, `あんまり`, `いい`) with source-backed Kanji readings, replacing bare `依/い` with `依存`, replacing suspicious generated `伊井/いい` examples with `伊豆/いず` and `井戸/いど`, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `65` and added an N1 lesson-14 sentinel for `伊` so existing browsers reseed the changed metadata.
- Verified locally before deploy: coverage audit reduced N1 incomplete current entries from `96` to `88`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, hosting cache header guard passed, full `flutter test` passed (`2340`), release web build passed, and Firebase Hosting deploy completed.
- Live proof used normal browser cache: page-context fetch of deployed `lesson_14.json` returned `Cache-Control: no-cache`; `伊` returned `Y (Ý; người ấy; dùng trong tên riêng)`, on `イ`, kun `かれ`, example `伊豆/いず = Izu; địa danh ở Nhật`, and `vi-source-verified`; old approval tags were absent; current page console errors/warnings `0`.
