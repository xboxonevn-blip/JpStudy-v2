# Autonomous Loop Status

## 2026-05-21 QA-A-030 Phase 3 Vocab app diff reports

- Added `tool/research/build_vocab_app_diff.js` with RED/GREEN coverage for bundled app vocab parsing, term+reading matching, wrong meaning/reading/POS, missing, extra, and explicit `WRONG-LEVEL` drift.
- Generated `docs/research/canonical/vocab-app-diff-n1.md` through `vocab-app-diff-n5.md` from owner-provided local canonical markdown plus bundled app vocab JSON only; banned websites were not accessed.
- Diff summary: N5 `ok=451 wrong=666 missing=128 extra=827`; N4 `ok=209 wrong=951 missing=171 extra=904`; N3 `ok=53 wrong=1158 missing=168 extra=846`; N2 `ok=65 wrong=1155 missing=730 extra=2342`; N1 `ok=29 wrong=2016 missing=228 extra=4864`.
- Logged `DECISION-038` for lowest-level canonical assignment and explicit `WRONG-LEVEL` reporting.
- Next: gate and commit Phase 3 report-only batch, then plan first safe app vocab mutation batch from high-confidence rows.

## 2026-05-21 QA-A-030 Phase 3 N5 Minna vocab fix batch 1

- Added `tool/research/apply_vocab_app_diff_fixes.js` with RED/GREEN coverage for selecting consensus-only meaning fixes, rejecting obvious polysemy via Vietnamese token-overlap guard, updating `meaningVi`/search text/source tags, and writing a batch report.
- Added per-level `vocabSeedRevision:<level>` content-meta refresh so returning browsers reseed the active vocab level after bundled JSON edits; regressions prove stale `学校` is repaired and first-revision installs upgrade to revision `2`.
- Added lesson-term definition sync so already-opened curriculum lessons update stale `userLessonTerm` rows from refreshed content while preserving learner progress; regression covers stale `あの方`.
- Applied the first cautious N5 Minna batch: `19` high-confidence `WRONG-MEANING` rows across lessons `01`, `04`, `05`, `06`, `07`, `09`, `11`, `12`, `14`, `17`, `19`, `23`, `24`, and `25`.
- Batch report: `docs/research/canonical/vocab-fix-batch-n5-minna-wrong-meaning-001.md`.
- Gates: JS focused apply/diff tests `6/6`; focused content DB + lesson repository tests `27/27`; `flutter analyze lib test` clean; UI string guard `0`; content VI status `0` machine/open-review rows; full `flutter test --concurrency=1` passed `2073+` tests; `git diff --check` clean except CRLF warnings.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof on `https://jpstudy.web.app`: in the same browser that previously showed stale cache, VI `/#/lesson/1?level=N5` updated `あの方` to `Vị kia` and no longer showed `người kia (lịch sự)`; VI `/#/lesson/4?level=N5` updated `映画` to `Phim, điện ảnh`.
- Next: commit batch, then handle owner-requested Phase 3 §7.4 Hajimete placeholder violation.

# 2026-05-21 — Megaprompt Phase 7 final reverify

- Re-ran Phase 7 probes after handoff and fixed two QA-tool defects: vocab samples now use level-aware Hajimete chapter routes instead of invalid numeric detail IDs, and visual regression now compares decoded pixels after waiting for route-specific content instead of comparing compressed PNG bytes or spinner baselines.
- Fresh gates: Phase 7 probe unit suite `18/18`, random sample E2E `25/25`, visual regression `PASS` after regenerating content-ready baselines, persona flows `PASS`, Lighthouse thresholds `PASS`, `flutter analyze lib test` clean, UI string guard `0`, `npm run test:research-tooling` `105/105`, `flutter test --concurrency=1` `2459/2459`.
- No owner-only approval tag or banned source-domain additions in the final diff; only existing legacy content still contains older tags.

# 2026-05-21 — Megaprompt Phase 7 live proof + acceptance

- Added Phase 7 acceptance probe tooling for random sample E2E, visual regression, persona flows, and Lighthouse threshold evaluation.
- Random sample E2E passed `25/25` across grammar, vocab, kanji, conjugation, and reading comprehension.
- Visual regression passed across mobile/tablet/desktop after resetting baseline for the intentional JS -> Wasm renderer switch.
- Persona flows passed for new learner, returning learner, and power user.
- Switched production deploy to Flutter web Wasm, deferred cloud bootstrap after first frame, added a Phase 7 Lighthouse QA seed, and added `llms.txt`.
- Lighthouse final JSON passed thresholds: mobile `100/100/100/100`; desktop `89/100/100/100`.
- Deployed with `node tool\deploy\hosting_deploy.js`; live headers prove `/`, `main.dart.wasm`, `main.dart.mjs`, and `flutter_bootstrap.js` cache policy is correct.
- Live telemetry proof observed Wasm runtime, App Check monitoring/reCAPTCHA exchange, anonymous Auth, Sentry ingest, and GA4 page-view requests; App Check enforcement was not enabled.
- Gate artifacts: `docs/research/phase7-random-sample-e2e-2026-05-21.md`, `docs/research/phase7-visual-regression-2026-05-21.md`, `docs/research/phase7-persona-flows-2026-05-21.md`, `docs/research/lighthouse-mobile-2026-05-21.json`, `docs/research/lighthouse-desktop-2026-05-21.json`, `docs/research/phase7-live-verify-2026-05-21.md`.

# 2026-05-21 — Megaprompt Overhaul COMPLETE

- All 8 phases done (see per-phase entries above).
- Acceptance gate: all checkboxes green.
- Live verified: https://jpstudy.web.app
- Owner review pending.
- DECISIONS_MADE: 31 entries.
- OPEN_QUESTIONS: 10 entries (pending owner review).
- Rollback safe: migrations have dual-read/static fallback; deploy remains a conventional Firebase Hosting release.

# 2026-05-21 — Megaprompt Phase 3 lesson page redesign batch 3

- Added flashcard progress, content/context toggle, direction toggle, and visible shortcut hints to the lesson workspace.
- Added conditional seventh `Chia thể` mode to the mode picker when the current lesson has conjugation lemmas; it opens the existing 50-question conjugation drill.
- Added a term-level Grammar badge beside Kanji and Practice badges so terms can jump to the lesson grammar panel before Phase 5 item-specific interlink graph lands.
- TDD: RED tests first failed for missing grammar badge, flashcard controls, and conditional conjugation mode; GREEN focused lesson test passed `15/15`.
- Gate: broader lesson/conjugation/nav suite passed `58/58`; `flutter analyze lib test` clean; UI string guard `0`; `git diff --check` clean; full `flutter test --concurrency=1` passed `2429/2429`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: VI `/#/lesson/1?level=N5`, `N4`, `N3`, `N2`, and `N1` rendered the redesigned lesson workspace on production. N5 showed the conditional `Chia thể` mode + 50-question conjugation widget; N1 correctly omitted `Chia thể` when lesson 1 had no conjugation lemmas. Screenshots: `output/playwright/live-phase3-lesson-*.png`; proof JSON: `output/playwright/live-phase3-lesson-proof.json`; `main.dart.js` returned `200/no-cache`; unexpected console/page errors `0`.

# 2026-05-21 — Megaprompt Phase 3 lesson page redesign batch 1

- Removed the deceptive empty Kanji tab from lesson navigation; Vocab and Grammar tabs remain functional while Kanji access moved to term-level badges.
- Added a `lesson_responsive_container` max-width shell (`1040`) for the lesson workspace.
- Added a six-mode lesson picker for flashcard, MCQ, sentence sort, typing, reading, and listening entry points; the Phase 2 inline conjugation widget remains the conditional conjugation anchor.
- Added a term list under the flashcard zone with numbered term cards, reading/meaning, Kanji cross-link badge, and practice CTA.
- TDD: new RED tests covered no Kanji tab, mode picker keys, term-list badges, and desktop max-width; targeted lesson/nav suite passed `54/54`.
- Gate: `flutter analyze lib test` clean; UI string guard `0`; `git diff --check` clean; full `flutter test --concurrency=1` passed `2426/2426`.

# 2026-05-21 — Megaprompt Phase 3 lesson page redesign batch 2

- Added in-page breadcrumb and lesson header below the app bar with previous/next lesson actions, `Góp ý`/report action, and writing-practice action.
- Header actions reuse existing live lesson detail/write/report flows; no placeholder route was added.
- TDD: new RED test covered breadcrumb/header/action keys; targeted lesson/nav suite passed `55/55`.
- Gate: `flutter analyze lib test` clean; UI string guard `0`; `git diff --check` clean; full `flutter test --concurrency=1` passed `2427/2427`.

# 2026-05-21 — Megaprompt Phase 2 conjugation layer done

- Added `tool/research/generate_conjugation_corpus.js` with validation and generated `assets/data/content/conjugation/conjugation_corpus.json`.
- Corpus counts: `1236` verbs, `747` adjectives, `30` manual irregular seeds, and `0` missing required forms; generation error log is empty.
- Raised default conjugation drill density to `50` questions and added a regression for default `>=50` generation with unique options.
- Upgraded `/grammar/conjugation` to a searchable/filterable lemma list with a `Practice 50+ forms` entry point.
- Added the inline `ConjugationLessonWidget` after lesson practice actions; it renders only after lesson terms load and only when the lesson has verb/adjective lemmas.
- Root-caused the full-suite fail to eager inline conjugation DB loading during the lesson loading-state test; fixed by deferring the widget until lesson terms resolve.
- Gate: corpus validator passed; conjugation focused suites passed; failing lesson loading-state regression passed; `flutter analyze lib test` clean; UI string guard `0`; `npm run test:research-tooling` passed `83/83`; full `flutter test --concurrency=1` passed `2424/2424`.

# 2026-05-21 — Megaprompt Phase 0 done

- Created 7 design docs under `docs/design/`: IA restructure, conjugation layer, exercise engine, lesson page, responsive, interlink graph, and home redesign.
- Appended Directive F to `docs/agent-directives.md`; current repo has no Directive E text, so F was appended after Directive D and logged as DECISION-001/OQ-001.
- Opened mission logs: `docs/research/decisions-log-2026-05-21.md` and `docs/research/open-questions-2026-05-21.md`.
- Acceptance check: 7/7 docs exist, Directive F grep present, `git diff --check` clean.

# 2026-05-21 — Megaprompt Phase 1 data migration done

- Added `tool/migration/restructure_to_theme_lesson.js` and `tool/migration/validate_migration.js` with TDD coverage.
- Generated `lib/data/manifests/textbook_index.json`, `lesson_index_*.json`, `item_index_*.json`, and `migration_summary.json`.
- `textbook_index.json` covers Minna N5/N4, Hajimete Tango N5-N1, Mimikara N5-N1, Shin Kanzen N3-N1, plus canonical kanji supporting tracks.
- Migration result: old flat reader scope `19580` items; new manifest reader `19580` items; lost `0`, orphan refs `0`, empty generated lessons `0`; generated lesson indexes `400`.
- Gate: `node --test test/tool/research/theme_lesson_manifest_test.js` passed `3/3`; `node tool/migration/validate_migration.js --content-root assets/data/content --manifest-root lib/data/manifests` passed; `npm run test:research-tooling` passed `80/80`; `git diff --check` clean.

# 2026-05-21 — Megaprompt Overhaul kickoff

- Context loaded: CLAUDE.md, AGENTS.md, agent-directives, quality-backlog, loop-status, free-web-stack-reference, jlpt-exam-source-reference, upper-jlpt-sources; `docs/SHIPPING.md` absent.
- Mission acknowledged: 8 phases, Directive F to be appended.
- DECISIONS_MADE log opened: `docs/research/decisions-log-2026-05-21.md`.
- OPEN_QUESTIONS log opened: `docs/research/open-questions-2026-05-21.md`.

## 2026-05-20 QA-A-029 Graph View Phase 1 MVP

- Implemented `/kanji/:character/graph` using local canonical kanji assets only; no banned web sources accessed.
- Added a deterministic radial graph renderer with focus/related/component styling, directed arrows, edge labels, pan/zoom, fit/refresh/reset/fullscreen toolbar, node click navigation, and a visible graph-cluster practice CTA.
- Linked Kanji detail modals to the graph route with `Xem mạng liên quan`.
- Live proof first caught a cold direct-route loading defect when graph construction waited on ContentDB seeding; fixed graph data loading to parse bundled canonical kanji JSON directly.
- Live proof also moved the practice CTA above the fold and made fullscreen graph navigation close the dialog before routing.
- Verified locally: graph model/widget/screen suites, Kanji detail CTA suite, Kanji reading scoped practice suite, handwriting scoped practice suite, `flutter analyze lib test`, UI string guard `0`, `git diff --check`, and full `flutter test --concurrency=1` `2421/2421`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: VI direct graph rendered focus blue + related/component nodes, node click rebuilt graph around `泊`, graph practice CTA opened Kanji practice hub, `人` detail CTA opened a graph, EN/JA graph route rendered localized chrome, `main.dart.js` returned `200/no-cache`, unexpected console/failed requests were `0` after filtering known App Check/reCAPTCHA noise.
- Artifacts: `output/playwright/live-qaa029-graph-phase1-proof.json`, `output/playwright/live-qaa029-click-proof.json`, `output/playwright/live-qaa029-final-*.png`.
- Remaining QA-A-029: Phase 2 SRS overlay + true graph quiz/SRS updates; Phase 3 review mini-graph interlink.

## 2026-05-20 QA-A-029 Graph View Phase 0 Design/Audit

- Audited the Kanji graph feature against current app structure without accessing banned sources.
- Package audit: `dart pub add graphview --dry-run` resolves `graphview 1.5.1`; local package README/API show Flutter web support, `InteractiveViewer` pan/zoom, `FruchtermanReingoldAlgorithm`, `ArrowEdgeRenderer`, and `GraphViewController` fit/reset support.
- Data audit: scanned `125` kanji lesson files with `2114` unique kanji; `250` have components, `558` have related kanji, one-hop max is `8`, depth-2 max is `34`; decided to cap rendered graph nodes at `15`.
- Route/design decisions: use full route `/kanji/:character/graph`, full-screen graph widget, custom edge-label renderer, SRS node borders, graph cluster quiz, and `/review` mini-graph interlink.
- Wrote `docs/research/kanji-graph-view-design-2026-05-20.md` with DECISIONS MADE and OPEN_QUESTIONS.
- Next: commit Phase 0 doc, then implement QA-A-029 Phase 1 MVP.

## 2026-05-20 QA-A-028 Personalized Hán-Việt Practice Closeout

- Finished the remaining QA-A-028 personalized sampling slice: `/kanji/han-viet` now loads SRS state for visible practice kanji and orders due kanji first, then active kanji, then untouched kanji in original asset order.
- Added a regression proving an already-active/due kanji practice item (`旧`) appears before a new item (`学`) on the v2 rule card.
- Cached the SRS-priority future per visible kanji-id set so the live screen does not create a new DB future on every rebuild.
- Verified locally: targeted RED/GREEN personalized test, full Hán-Việt reference screen suite `6/6`, `flutter analyze lib test`, UI string guard `0`, `git diff --check`, and full `flutter test --concurrency=1` passed `2415/2415`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: fresh VI/N5 `/kanji/han-viet` rendered the v2 rule card, examples, and MC options; clicking an answer produced inline feedback on the same card. `main.dart.js` returned `200/no-cache`; unexpected console warnings/errors and unexpected failed requests were `0` after filtering known headless App Check/reCAPTCHA/WebGL noise.
- Live artifact: `output/playwright/live-qaa028-hanviet-personalized-proof.json` plus screenshots `output/playwright/live-qaa028-hanviet-personalized-initial.png` and `output/playwright/live-qaa028-hanviet-personalized-answered.png`.
- Next queue: QA-A-029 Kanji relationship graph view Phase 0 design/audit.

## 2026-05-20 QA-A-028 Phase 3 Detail + Review Interlinks

- Added a v2 Hán-Việt rule matcher for kanji detail: exact example/practice kanji wins, then Hán-Việt initial + On-yomi target-kana heuristic.
- Replaced the old detail-only legacy preview with a VI-only mini-card showing the matching v2 rule, target row/kana, and example mapping; EN/JA detail continues to hide Hán-Việt rule content.
- Wired the mini-card CTA to the full Kanji-owned Hán-Việt rules/practice screen and fixed a live-caught modal-pop navigation race by deferring the route push one frame after closing the dialog.
- Added due Hán-Việt rule SRS into the Practice/Review board as a dedicated VI-only action that opens `/kanji/han-viet`.
- Updated the stale content-service guard so v2 rules are expected at `32` cards after Phase 2 completion.
- Verified locally: focused Kanji hub, Hán-Việt reference, Practice board, and Hán-Việt SRS DAO tests passed; `flutter analyze lib test` clean; UI string guard `0`; `git diff --check` clean; full `flutter test --concurrency=1` passed `2414/2414`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: fresh VI `/kanji` search `校` opened detail with `Quy tắc Hán-Việt áp dụng`, rule `1. Âm đầu là H/K/Gi/C/Qu`, target `K/G`, and `Giáo -> 校`; mini-card CTA opened the full Hán-Việt rule practice content. Fresh EN/JA `校` details had no Hán-Việt rule panel or Hán-Việt row leak. `main.dart.js` returned `200/no-cache`; unexpected console warnings/errors were `0` after filtering known headless App Check/WebGL noise.
- Live artifact: `output/playwright/live-qaa028-hanviet-phase3-proof.json` plus `output/playwright/live-qaa028-phase3-*.png` screenshots.
- Remaining QA-A-028: personalized rule practice sampling from the user's active kanji pool, then continue to QA-A-029.

## 2026-05-20 QA-A-028 Phase 2 Final

- Expanded `han_viet_on_rules_v2.json` from `30` to all `32` legacy rule cards.
- Added final usage cards for Hán-Việt-as-heuristic discipline and multiple-On-reading discipline; each has `6` examples and `5` MC practice items.
- Phase 2 now totals `32` ready rule cards and `160` generated practice questions, all from local app kanji/vocab assets with blocked crawl domains excluded.
- Verified locally: `node --test test/tool/research/han_viet_rule_content_generator_test.js`, `flutter test test/data/content/han_viet_on_rules_asset_test.dart`, `flutter test test/features/foundations/han_viet_reference_screen_test.dart`, `npm run test:research-tooling` (`77/77`), and `git diff --check` passed.
- Deployed with `node tool/deploy/hosting_deploy.js`.
- Live proof on production: live v2 asset returned `32` rules and `160` practice items with no-cache; `/kanji/han-viet` loaded in VI, filtered `nhiều âm On`, showed rule 32 practice, clicked correct `だい`, `main.dart.js` returned `200/no-cache`, unexpected console errors were `0` after known headless App Check noise filtering. Feedback text remains screenshot-backed because CanvasKit semantics omitted card text from `body.innerText` in this run.
- Live artifact: `output/playwright/live-qaa028-hanviet-phase2-final-proof.json` plus `output/playwright/live-qaa028-hanviet-phase2-final-*.png` screenshots.
- Next queue: QA-A-028 Phase 3 interlinks: kanji detail mini-card, personalized rule practice selection, and review queue rule cards.

## 2026-05-20 QA-A-028 Phase 2 Batch 6

- Expanded `han_viet_on_rules_v2.json` from `25` to `30` ready practice cards.
- Added exception/usage cards for onbin gemination, Kun/mixed readings, word-level Hán-Việt composition, dictionary-check discipline, and compound On-yomi usage; each has `6` examples and `5` MC practice items.
- Added explicit candidate-kanji generation for usage/exception rules so these cards stay practice-ready while still using local app kanji/vocab assets only.
- Verified locally: `node --test test/tool/research/han_viet_rule_content_generator_test.js`, `flutter test test/data/content/han_viet_on_rules_asset_test.dart`, `flutter test test/features/foundations/han_viet_reference_screen_test.dart`, `npm run test:research-tooling` (`77/77`), and `git diff --check` passed.
- Deployed with `node tool/deploy/hosting_deploy.js`.
- Live proof on production: live v2 asset returned `30` rules with no-cache; `/kanji/han-viet` loaded in VI, filtered `Từ ghép Hán tự`, showed rule 30 practice, clicked correct `こく`, `main.dart.js` returned `200/no-cache`, unexpected console errors were `0` after known headless App Check noise filtering. Feedback text remains screenshot-backed because CanvasKit semantics omitted card text from `body.innerText` in this run.
- Live artifact: `output/playwright/live-qaa028-hanviet-phase2-batch6-proof.json` plus `output/playwright/live-qaa028-hanviet-phase2-batch6-*.png` screenshots.
- Next queue: finish QA-A-028 Phase 2 rules `31-32`, then Phase 3 interlinks.

## 2026-05-20 QA-A-028 Phase 2 Batch 5

- Expanded `han_viet_on_rules_v2.json` from `20` to `25` ready practice cards.
- Added rime `-ác/-ạc/-ước/-ược -> AKU/YAKU`, rime `-ịch/-ích -> EKI/SEKI/TEKI`, rime `-ưu/-iêu/-yêu -> YUU/YOU`, long-vowel `OU` from `-ang/-ong/-ông`, and long-vowel `EI` from `-inh/-anh/-ênh`; each has `6` examples and `5` MC practice items.
- Verified locally: `node --test test/tool/research/han_viet_rule_content_generator_test.js`, `flutter test test/data/content/han_viet_on_rules_asset_test.dart`, `flutter test test/features/foundations/han_viet_reference_screen_test.dart`, `npm run test:research-tooling` (`77/77`), and `git diff --check` passed.
- Deployed with `node tool/deploy/hosting_deploy.js`.
- Live proof on production: live v2 asset returned `25` rules with no-cache; `/kanji/han-viet` loaded in VI, filtered `Trường âm EI`, showed rule 25 practice, clicked correct `せい`, `main.dart.js` returned `200/no-cache`, unexpected console errors were `0` after known headless App Check noise filtering. Feedback text remains screenshot-backed because CanvasKit semantics omitted card text from `body.innerText` in this run.
- Live artifact: `output/playwright/live-qaa028-hanviet-phase2-batch5-proof.json` plus `output/playwright/live-qaa028-hanviet-phase2-batch5-*.png` screenshots.
- Next queue: continue QA-A-028 Phase 2 rules `26-32`, then Phase 3 interlinks.

## 2026-05-20 QA-A-028 Phase 2 Batch 4

- Expanded `han_viet_on_rules_v2.json` from `15` to `20` ready practice cards.
- Added final `-p -> OU/UU/TSU`, final `-ch -> KU/KI`, rime `-inh/-anh/-ênh -> EI`, rime `-iên/-iêm/-yên -> EN`, and rime `-ông/-ung/-ương -> OU/UU/YOU`; each has `6` examples and `5` MC practice items.
- Verified locally: `node --test test/tool/research/han_viet_rule_content_generator_test.js`, `flutter test test/data/content/han_viet_on_rules_asset_test.dart`, `flutter test test/features/foundations/han_viet_reference_screen_test.dart`, `npm run test:research-tooling` (`77/77`), and `git diff --check` passed.
- Deployed with `node tool/deploy/hosting_deploy.js`.
- Live proof on production: live v2 asset returned `20` rules with no-cache; `/kanji/han-viet` loaded in VI, keyboard-scroll reached rule 20 practice, clicked correct `よう`, `main.dart.js` returned `200/no-cache`, console errors were `0`. Feedback text remains screenshot-backed because CanvasKit semantics omitted it from `body.innerText`.
- Live artifact: `output/playwright/live-qaa028-hanviet-phase2-batch4-proof.json` plus `output/playwright/live-qaa028-hanviet-phase2-batch4-*.png` screenshots.
- Next queue: continue QA-A-028 Phase 2 rules `21-25` (`rime-ac`, `rime-ich`, `rime-uu`, long-vowel rules).

## 2026-05-20 QA-A-028 Phase 2 Batch 3

- Expanded `han_viet_on_rules_v2.json` from `10` to `15` ready practice cards.
- Added rules `Đ -> T/D`, `V -> B/M/nguyên âm`, final `-n/-m -> ん`, final `-c -> KU/KI`, and final `-t -> TSU/CHI`; each has `6` examples and `5` MC practice items.
- Fixed generator matching so Vietnamese `D` and `Đ` remain distinct after accent normalization; added a regression for `Dụng`, `Đại`, and `Giải`.
- Added final-syllable matching for final/rime rules instead of treating them as initial-consonant rules.
- Verified locally: `node --test test/tool/research/han_viet_rule_content_generator_test.js`, `flutter test test/data/content/han_viet_on_rules_asset_test.dart`, `flutter test test/features/foundations/han_viet_reference_screen_test.dart`, `npm run test:research-tooling` (`77/77`), and `git diff --check` passed.
- Deployed with `node tool/deploy/hosting_deploy.js`.
- Live proof on production: live v2 asset returned `15` rules with no-cache; `/kanji/han-viet` loaded in VI, keyboard-scroll reached batch-3 final-rule practice, clicked correct `しつ` for rule 15, `main.dart.js` returned `200/no-cache`, console errors were `0`. Feedback text remains screenshot-backed because CanvasKit semantics omitted it from `body.innerText`.
- Live artifact: `output/playwright/live-qaa028-hanviet-phase2-batch3-proof.json` plus `output/playwright/live-qaa028-hanviet-phase2-batch3-*.png` screenshots.
- Next queue: continue QA-A-028 Phase 2 rules `16-20` (`final-p`, `final-ch`, rime groups), then remaining rime/long-vowel/exception rules.

## 2026-05-20 QA-A-028 Phase 2 Batch 2

- Expanded `assets/data/content/kanji/han_viet_on_rules_v2.json` from `5` to `10` generated practice cards after the QA-A-026 canonical kanji rewrite.
- Added rules `M -> M`, `B/Ph -> H/F/B`, `D/Gi -> Y`, `Ch/Tr -> SH/CH`, and `S/X -> S/SH`; each has `6` examples and `5` ready MC practice items.
- Refined generated practice explanations so they name the Vietnamese initial consonant instead of repeating the whole Hán-Việt syllable.
- Verified locally: `node --test test/tool/research/han_viet_rule_content_generator_test.js`, `flutter test test/data/content/han_viet_on_rules_asset_test.dart`, `flutter test test/features/foundations/han_viet_reference_screen_test.dart`, `npm run test:research-tooling`, and `git diff --check` passed.
- Deployed with `node tool/deploy/hosting_deploy.js`.
- Live proof on production: live v2 asset returned `10` rules with no-cache; `/kanji/han-viet` loaded in VI, keyboard-scroll reached batch-2 practice, clicked the correct `しゃ` answer for rule 10, `main.dart.js` returned `200/no-cache`, console errors were `0` after known headless App Check noise filtering. CanvasKit still exposes option labels but not all title/feedback text through `body.innerText`, so title/feedback verification is screenshot-backed.
- Live artifact: `output/playwright/live-qaa028-hanviet-phase2-batch2-proof.json` plus `output/playwright/live-qaa028-hanviet-phase2-batch2-*.png` screenshots.
- Next queue: continue QA-A-028 Phase 2 rules `11-15`, then remaining final/rime/exception rules, then Phase 3 interlinks.

## 2026-05-20 QA-A-026 Kanji Canonical App Rewrite

- Applied QA-A-027 master mapping to the app kanji assets without accessing banned sites. Final app counts now match the master exactly: `N5=103`, `N4=178`, `N3=316`, `N2=461`, `N1=1056`, total `2114`.
- Pre-apply audit remains in `docs/research/kanji-level-audit-2026-05-20.md`: MOVE `421`, DUPLICATE `196`, MISSING `1556`, EXTRA `80`. Post-apply regeneration audit in `tmp/qaa026-regenerate-audit.md` was `MOVE=0 DUPLICATE=0 MISSING=0 EXTRA=0`.
- Added `tool/research/apply_kanji_master_mapping.js` and guards so app assets must equal `docs/research/canonical/kanji-master-mapping-2026-05-20.json`, with no cross-level duplicate characters and no `vi-human-approved` tags in kanji assets.
- Bumped `_kanjiSeedRevision` from `70` to `90`; seeded QA-A-026 sentinels cover `海`, `帰`, `親`, `銀`, `重`, `議`, and an N1 row so existing browsers reseed stale/partial content DBs.
- Root-caused full-suite failures after the rewrite: the expanded canonical N5/N4 set outgrew handwriting support assets, and ebook OCR stroke counts for `社`/`漢` conflicted with KANJIDIC2/KanjiVG. Fixed by making KANJIDIC2 stroke counts win and regenerating N5/N4 stroke template/vector support from current content assets.
- Verified locally: `npm run test:research-tooling` passed `76/76`; focused canonical/reachability/DB/upper-JLPT/stroke suites passed; `flutter analyze lib test` clean; UI string guard `0`; content VI status machine/open-review `0`; `git diff --check` clean; full `flutter test --concurrency=1` passed `2412/2412`.
- Deployed with `node tool/deploy/hosting_deploy.js` after release build.
- Live proof on normal production cache used the app search route with Kanji filter, matching `/kanji` search delegation: VI search/detail showed `海` and `帰` only in N5, `親` only in N4, `銀` and `重` only in N3, and `議` only in N2; wrong-level searches returned no exact result. Detail modal verification is screenshot-based because CanvasKit semantics did not expose modal body text reliably. EN/JA kanji search showed `海` with no Vietnamese/Hán-Việt leak. `main.dart.js` returned `200` with `Cache-Control: no-cache`; unexpected console warnings/errors were `0` after filtering known headless App Check/reCAPTCHA/WebGL noise.
- Live artifact: `output/playwright/live-qaa026-kanji-taxonomy-proof.json` plus `output/playwright/live-qaa026-*.png` screenshots.
- Next queue: resume QA-A-028 Phase 2 remaining Hán-Việt rules, then QA-A-028 Phase 3, QA-A-029, QA-A-030, QA-A-031.

## 2026-05-20 QA-A-027 Phase 1B/1C

- Re-extracted canonical N4/N1 writing-grid ebooks from local pixel/OCR cache, without accessing banned sites. Parser now chooses the hint-line target kanji when the first row only exposes mnemonic components; regressions cover `酉` vs `西/一`, `光` vs `小/一/儿`, and `洒` from `洒落`.
- Regenerated `docs/research/canonical/kanji-n4.md` (`193` entries) and `docs/research/canonical/kanji-n1.md` (`1164` entries). Spot samples fixed: N4 `究`, `光`, `王`; N1 `洒`, `酉`.
- Built `docs/research/canonical/kanji-master-mapping-2026-05-20.json`: `2114` selected kanji, counts `N5=103`, `N4=178`, `N3=316`, `N2=461`, `N1=1056`.
- Applied owner hard overrides in master mapping: `海 -> N5`, `帰 -> N5`, `銀 -> N3`, `重 -> N3`, `議 -> N2`; canonical keeps `親 -> N4`.
- Logged conflicts/uncertainties in `docs/research/canonical/kanji-canonical-open-questions-2026-05-20.md` for later owner review. These do not block QA-A-026.
- Verified: `npm run test:research-tooling` passed `72/72`.
- Next: QA-A-026 app kanji MOVE/DEDUPE/MISSING/EXTRA diff + implementation from master mapping.

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

## 2026-05-19 Cache Audit Recheck + N1 Kanji Lesson 15 Completeness Patch

- Rechecked the owner cache audit first. Current `firebase.json` and live Firebase Hosting already enforce the corrected QA-A-017 policy: `main.dart.js`, `flutter_bootstrap.js`, `flutter.js`, `assets/AssetManifest*`, and `assets/assets/data/content/**` return `Cache-Control: no-cache`; `sqlite3.wasm` remains `public, max-age=2592000`. No cache-header code change was needed.
- Source-verified all eight N1 lesson-15 kanji (`否`, `加`, `減`, `言`, `訳`, `家`, `出`, `主`) against local KANJIDIC2, Unihan where available, existing verified duplicate rows, and vocabulary examples.
- Corrected generated metadata, including learner-facing `否 -> Phủ`, `主 -> Chủ`, replacing word-level readings (`いいかげん`, `いいわけ`, `いえで`) with source-backed Kanji readings, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `66` and added an N1 lesson-15 sentinel for `否` so existing browsers reseed the changed metadata.
- Verified locally before deploy: coverage audit reduced N1 incomplete current entries from `88` to `80`, focused DB/reachability/taxonomy/upper-JLPT tests passed (`45`), hosting cache header guard passed, and release web build passed.
- Built/deployed `18e84e51` to Firebase Hosting. Live proof used normal browser cache: page-context fetch of deployed `lesson_15.json` returned `Cache-Control: no-cache`; `否` returned `Phủ (không; phủ định; từ chối)`, on `ヒ`, kun `いな/いや`, example `拒否/きょひ = từ chối; bác bỏ; phủ nhận`, and `vi-source-verified`; old approval tags were absent; current page console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lesson 16 Completeness Patch

- Source-verified all eight N1 lesson-16 kanji (`如`, `何`, `生`, `雷`, `怒`, `歪`, `粋`, `域`) against local KANJIDIC2, Unihan where available, existing verified duplicate rows, and vocabulary examples.
- Corrected generated metadata, including learner-facing `歪 -> Oai`, replacing word-level readings (`いかが`, `いかす`, `いかり`, `いきがい`) with source-backed Kanji readings, replacing `域外` with clearer `領域`, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `67` and added an N1 lesson-16 sentinel for `歪` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, old approval-tag grep returned no matches, coverage audit reduced N1 incomplete current entries from `80` to `72`, focused DB/reachability/taxonomy/upper-JLPT tests passed (`45`), `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, hosting cache guard passed, and release web build passed.
- Built/deployed `b124248f` to Firebase Hosting. Live proof used normal browser cache: page-context fetch of deployed `lesson_16.json` returned `Cache-Control: no-cache`; `歪` returned `Oai (méo; lệch; vặn vẹo)`, on `ワイ/エ`, kun `いが.む/いびつ/ひず.む/ゆが.む`, example `歪む/いがむ = bị cong; bị méo; bị bóp méo`, and `vi-source-verified`; old approval tags were absent; current page console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lesson 17 Completeness Patch

- Source-verified all eight N1 lesson-17 kanji (`外`, `意`, `込`, `経`, `緯`, `行`, `違`, `成`) against local KANJIDIC2, Unihan where available, existing verified duplicate rows, and vocabulary examples.
- Corrected generated metadata, including `緯` stroke count `15 -> 16`, learner-facing `行 -> Hành`, replacing word-level readings (`いきがい`, `いきごむ`, `いきさつ`, `いきちがい`, `いきなり`) with source-backed Kanji readings, replacing ateji `行き成り` with clearer `達成`, removing old approval metadata, and adding truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `68` and added an N1 lesson-17 sentinel for `緯` so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, old approval-tag grep returned no matches, coverage audit reduced N1 incomplete current entries from `72` to `64`, focused DB/reachability/taxonomy/upper-JLPT tests passed (`45`), `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, hosting cache guard passed, and release web build passed.
- Built/deployed `058501e2` to Firebase Hosting. Live proof used normal browser cache: page-context fetch of deployed `lesson_17.json` returned `Cache-Control: no-cache`; `緯` returned stroke count `16`, `Vĩ (vĩ tuyến; sợi ngang; chiều ngang)`, on `イ`, kun `よこいと/ぬき`, example `経緯/いきさつ = diễn biến; đầu đuôi sự việc; quá trình`, and `vi-source-verified`; old approval tags were absent; current page console errors/warnings `0`.

## 2026-05-19 N1 Kanji Lessons 18-22 Completeness Batch

- Applied the owner batch-policy update: five lesson files verified together, one full gate, one deploy, one rendered live proof, and one combined content/docs commit.
- Source-verified forty N1 kanji (`異`, `議`, `軍`, `戦`, `育`, `幾`, `多`, `活`, `見`, `向`, `移`, `碑`, `衣`, `装`, `苛`, `住`, `弄`, `性`, `遺`, `然`, `存`, `委`, `託`, `戯`, `頂`, `戴`, `至`, `痛`, `炒`, `労`, `市`, `位`, `一`, `概`, `著`, `同`, `部`, `分`, `別`, `面`) against local KANJIDIC2, Unihan, existing verified duplicate rows, and vocabulary examples.
- Corrected generated word-level readings to source-backed kanji readings, fixed learner-facing Hán-Việt/display defects (`移 -> Di`, `別 -> Biệt`), corrected Japanese stroke counts (`碑 14`, `概 14`, `部 11`), removed old approval metadata, and added truthful `vi-source-verified`. No `vi-human-approved` tag was added.
- Bumped content DB Kanji seed revision to `69` and added sentinels for N1 lessons 18-22 (`議`, `移`, `託`, `位`, `別`) so existing browsers reseed the changed metadata.
- Verified locally before deploy: JSON parse passed, old approval-tag grep returned no matches, related-kanji shape check passed, coverage audit reduced N1 incomplete current entries `64 -> 24`, focused DB/reachability/taxonomy/upper-JLPT tests passed (`45`), `flutter analyze lib test` clean, UI string guard `0`, content status report machine/open-review `0`, hosting cache guard passed, full `flutter test` passed (`2340`), and release web build passed.
- Built/deployed to Firebase Hosting. Live proof used normal browser cache and real rendered UI: VI/N1 `/#/kanji` search `議` showed `Học chữ 議, Hán-Việt Nghị, âm On ギ, âm Kun はか.る`; opening detail rendered `Nghị (bàn luận; nghị sự; ý kiến)` and the new mnemonic. Search `別` showed `Hán-Việt Biệt`, stale `Biết` absent. Page-context fetch with `cache: default` returned `main.dart.js`, `lesson_18.json`, and `lesson_22.json` as `Cache-Control: no-cache`; `sqlite3.wasm` and `drift_worker.js` remained `public, max-age=2592000`; console warnings/errors `0`.

## 2026-05-19 N1 Kanji Lessons 23-25 Completeness Batch

- Source-verified final current N1 kanji batch (`目`..`民`), removed stale approval metadata, added `vi-source-verified`, and bumped Kanji seed revision to `70`; no `vi-human-approved`.
- Key corrections: `挑 -> Khiêu`, `未 -> Vị`, `営` Japanese stroke count `12`, `稲` keeps owner-fixed `Đạo (lúa; cây lúa)`.
- Gate matched Directive C: focused DB/reachability/taxonomy/upper-JLPT tests `47/47`, coverage audit N1 incomplete `24 -> 0`, analyze clean, UI string `0`, content status machine/open-review `0`, release build pass. Full `flutter test` was run once before Directive C arrived and passed `2340`; future content batches should not repeat it unless level/logic criteria apply.
- Deployed `hosting:jpstudy`. Live proof used normal browser cache and real UI: VI/N1 `/#/kanji` detail for `挑` rendered `Khiêu (thách thức; khiêu chiến; đương đầu)`; detail for `未` rendered `Vị (chưa; chưa hoàn thành; tương lai)`. Page-context `cache: default` returned `no-cache` for `main.dart.js`, `lesson_23.json`, `lesson_25.json`; new console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N2 Lessons 1-5 Batch

- Source-verified 38 N2 grammar points in lessons 1-5; added truthful `vi-source-verified`, no `vi-human-approved`.
- Corrected `ことなく` formation/explanation to `Verb-dictionary form + ことなく` / `V辞書形 + ことなく`.
- Fixed user-visible grammar reseed path: `GrammarSeeder` revision `12`, `fetchPointsByLevel` now invokes the versioned seeder, and seed-key matching no longer collapses unrelated Japanese grammar keys.
- Verified: focused suite `68/68`, `flutter analyze lib test` clean, content status machine/open-review `0`, full `flutter test` `2343/2343`, release build pass, deploy pass.
- Live proof: existing production browser, normal cache, no IndexedDB clear. `/#/grammar` at N2 upgraded `flutter.grammar_data_version_N2` to `12`; searching/opening `ことなく` rendered `Verb-dictionary form + ことなく` and `Cấu trúc: V辞書形 + ことなく.` Console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N2 Lessons 6-10 Batch

- Source-verified 38 N2 grammar points in lessons 6-10; added truthful `vi-source-verified`, no `vi-human-approved`.
- Corrected `っこない` formation/explanation to `Verb-ます stem + っこない` / `Vます bỏ ます + っこない`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `13`.
- Verified under Directive C: JSON/tag check `38/38`, focused suite `62/62`, `flutter analyze lib test` clean, UI string guard `0`, content status machine/open-review `0`, release build pass, deploy pass. Full `flutter test` intentionally deferred until N2 grammar level completion or next non-trivial Dart logic change.
- Live proof: existing production browser, normal cache. `/#/grammar` at N2 upgraded `flutter.grammar_data_version_N2` to `13`; searching/opening `っこない` rendered `Verb-ます stem + っこない` and `Cấu trúc: Vます bỏ ます + っこない.` Console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N2 Lessons 11-15 Batch

- Source-verified 38 N2 grammar points in lessons 11-15; added truthful `vi-source-verified`, no `vi-human-approved`.
- Corrected formations/explanations for `っぽい`, `てかなわない`, `とおり`, `ないことはない`, `ないこともない`, `ながら`, `にあたり`, and `にしたがって`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `14`.
- Verified under Directive C: JSON/tag check `38/38`, focused suite `62/62`, `flutter analyze lib test` clean, UI string guard `0`, content status machine/open-review `0`, release build pass, deploy pass. Full `flutter test` deferred until N2 grammar level completion or non-trivial Dart logic.
- Live proof: existing production browser, normal cache. A normal reload upgraded `flutter.grammar_data_version_N2` to `14`; searching/opening `ながら` rendered the corrected structure and explanation. Console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N2 Lessons 16-20 Batch

- Source-verified 38 N2 grammar points in lessons 16-20; added truthful `vi-source-verified`, no `vi-human-approved`.
- Corrected formations/explanations for `にともなって`, `にほかならない`, `により`, `に決まっている`, `に関わって`, `に際して`, `の下で`, `ばかりだ`, `ば～というものでもない`, `ままに`, and `もかまわず`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `15`.
- Verified under Directive C: JSON/source-tag check `38/38`, focused suite `50/50`, `flutter analyze lib test` clean, literal-route guard clean, content status machine/open-review `0`, release build pass, deploy pass. Full `flutter test` deferred until N2 grammar level completion or non-trivial Dart logic.
- Live proof: existing production browser, normal cache. The real N2 Grammar UI rendered the corrected `Verb-dictionary form + ばかりだ` list row and detail `KẾT NỐI`, including `Cấu trúc: V辞書形 + ばかりだ.` `main.dart.js`, `grammar_n2_19.json`, and `grammar_n2_20.json` returned `Cache-Control: no-cache`; console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N2 Lessons 21-25 Batch

- Source-verified 39 N2 grammar points in lessons 21-25; added truthful `vi-source-verified`, no `vi-human-approved`.
- Corrected/clarified formations and explanations for `ものなら`, `も同然だ`, `わけがない`, `わけだ`, `わけではない`, `わけにはいかない`, `上で`, `上は`, `以上`, `以来`, `恐れがある`, `末`, `次第です`, `気味`, and `際に`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `16`; this completes the N2 grammar verification pass.
- Verified under Directive C: JSON/source-tag check `39/39`, focused suite `32/32`, `flutter analyze lib test` clean, literal-route guard clean, content status machine/open-review `0`, full `flutter test` passed (`2343`) because N2 grammar level is now complete, release build pass, and Firebase Hosting deploy pass.
- Live proof: existing production browser, normal cache. The real N2 Grammar UI rendered `/#/grammar/175` with `KẾT NỐI: Verb-dictionary form + 上で, Verb-た form + 上で, Noun + の上で` and `/#/grammar/185` with `KẾT NỐI: Verb-た form + 末(に), Noun + の末(に)`. Page-context `cache: default` returned `no-cache` for `main.dart.js`, `grammar_n2_23.json`, and `grammar_n2_25.json`; `sqlite3.wasm` and `drift_worker.js` remained `public, max-age=2592000`; console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N3 Lessons 1-5 Batch

- Source-verified 20 N3 grammar points in lessons 1-5; added truthful `vi-source-verified`, no `vi-human-approved`.
- Corrected/clarified formations and explanations for `代わりに`, `わりに`, `うちに`, `間に`, `はずだ`, `わけではない`, `わけにはいかない`, and `はずがない`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `17`.
- Verified under Directive C: JSON/source-tag check `20/20`, focused suite `32/32`, `flutter analyze lib test` clean, literal-route guard clean, content status machine/open-review `0`, release build pass, and Firebase Hosting deploy pass. Full `flutter test` deferred until N3 grammar level completion.
- Live proof: existing production browser, normal cache. The real N3 Grammar UI rendered the corrected list row and detail for `代わりに` with `KẾT NỐI: V普通形 / いA / なAな / Nの + 代わりに`; it also rendered `わけにはいかない` with `KẾT NỐI: V辞書 / Vない + わけにはいかない`. Page-context `cache: default` returned `no-cache` for `main.dart.js`, `grammar_n3_3.json`, and `grammar_n3_5.json`; `sqlite3.wasm` and `drift_worker.js` remained `public, max-age=2592000`; console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N3 Lessons 6-10 Batch

- Source-verified 20 N3 grammar points in lessons 6-10; added truthful `vi-source-verified`, no `vi-human-approved`.
- Corrected/clarified formations and explanations for `すぎる`, `かえって`, `おそれがある`, `に違いない`, `ようだ`, `らしい`, `みたいだ`, `ように見える`, and `そうだ（伝聞）`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `19`. Revision `18` reached the browser during the in-progress batch, so final revision `19` forces existing browsers to reseed the post-proof `すぎる`/`かえって` corrections.
- Verified under Directive C: JSON/source-tag check `20/20`, focused suite `63/63`, `flutter analyze lib test` clean, UI string guard clean, literal-route guard clean, content status machine/open-review `0`, release build pass, and Firebase Hosting deploy pass. Full `flutter test` deferred until N3 grammar level completion.
- Live proof: existing production browser, normal cache. The real N3 Grammar UI upgraded `flutter.grammar_data_version_N3` to `19`; opening `すぎる` rendered `KẾT NỐI: Vます語幹 / いA語幹 / なA + すぎる`, and opening `かえって` rendered `KẾT NỐI: かえって + 文`. Page-context fetch with `cache: default` returned `no-cache` for `main.dart.js`, `grammar_n3_6.json`, and `grammar_n3_8.json`; `sqlite3.wasm` and `drift_worker.js` remained `public, max-age=2592000`. New console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N3 Lessons 11-15 Batch

- Source-verified 20 N3 grammar points in lessons 11-15; added truthful `vi-source-verified`, no `vi-human-approved`.
- Corrected/clarified formations and explanations for `せいで`, `おかげで`, `ため`, `可能性がある`, `ほど`, `くらい/ぐらい`, `さ`, `ばかりか`, `ことがある`, `ないことはない`, `ないこともない`, `といい`, `ばよかった`, and `といいな`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `20`.
- Verified under Directive C: JSON/source-tag check `20/20`, focused suite `63/63`, `flutter analyze lib test` clean, UI string guard clean, literal-route guard clean, content status machine/open-review `0`, release build pass, and Firebase Hosting deploy pass. Full `flutter test` deferred until N3 grammar level completion.
- Live proof: existing production browser, normal cache. The real N3 Grammar UI upgraded `flutter.grammar_data_version_N3` to `20`; opening `せいで` rendered `KẾT NỐI: V普通形 / いA / なAな / Nの + せいで`, and opening `ないことはない` rendered `KẾT NỐI: Vない / いAくない / なAではない / Nではない + ことはない`. Page-context fetch with `cache: default` returned `no-cache` for `main.dart.js`, `grammar_n3_11.json`, `grammar_n3_13.json`, and `grammar_n3_15.json`; `sqlite3.wasm` and `drift_worker.js` remained `public, max-age=2592000`. New console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N3 Lessons 16-20 Batch

- Source-verified 20 N3 grammar points in lessons 16-20; added truthful `vi-source-verified`, no `vi-human-approved`.
- Corrected/clarified formations and explanations for `続ける`, `きる`, `抜く`, `という`, `といわれている`, `ことから`, `とされている`, `べきだ`, `べきではない`, `たとたん`, `ついでに`, `際に`, `気がする`, `ものだ`, `わけだ`, and `に決まっている`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `21`.
- Verified under Directive C: JSON/source-tag check `20/20`, focused suite `63/63`, `flutter analyze lib test` clean, UI string guard clean, literal-route guard clean, content status machine/open-review `0`, release build pass, and Firebase Hosting deploy pass. Full `flutter test` deferred until N3 grammar level completion.
- Live proof: existing production browser, normal cache. The real N3 Grammar UI upgraded `flutter.grammar_data_version_N3` to `21`; opening `べきだ` rendered `KẾT NỐI: V辞書 + べきだ（する→するべき・すべき）`, and opening `わけだ` rendered `KẾT NỐI: V普通形 / いA / なAな / Nな・Nである + わけだ`. Page-context fetch with `cache: default` returned `no-cache` for `main.dart.js`, `grammar_n3_16.json`, `grammar_n3_18.json`, and `grammar_n3_20.json`; `sqlite3.wasm` and `drift_worker.js` remained `public, max-age=2592000`. New console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N3 Lessons 21-25 Batch

- Source-verified 20 N3 grammar points in lessons 21-25; added truthful `vi-source-verified`, no `vi-human-approved`.
- Corrected/clarified formations and explanations for `つつある`, `にかけて`, `ほど〜ない`, `というより`, `ばかりでなく`, and `どんなに〜ても`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `22`; this completes the current N3 grammar pass.
- Verified under Directive C: JSON/source-tag check `20/20`, focused suite passed, `flutter analyze lib test` clean, UI string guard clean, literal-route guard clean, content status machine/open-review `0`, full `flutter test` passed (`2343`) because N3 grammar level is now complete, release build pass, and Firebase Hosting deploy pass.
- Live proof: production browser with normal cache. The real N3 Grammar UI upgraded `flutter.grammar_data_version_N3` to `22`; the list rendered `N1 + から + N2 + にかけて`, `N + ほど + いAくない / なAではない / Vない`, `V普通形 / いA / なAな / N + ばかりでなく`, and `どんなに + Vても / いAくても / なAでも / Nでも`. Opening `ばかりでなく` rendered the corrected `KẾT NỐI`. Page-context fetch with `cache: default` returned `no-cache` for `main.dart.js`, `grammar_n3_21.json`, `grammar_n3_24.json`, and `grammar_n3_25.json`; `sqlite3.wasm` and `drift_worker.js` remained `public, max-age=2592000`. New console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N4 Lessons 26-30 Batch

- Source-verified 20 N4 grammar points in lessons 26-30; replaced old `vi-human-approved` tags with truthful `vi-source-verified`.
- Corrected/clarified formations for `んです`, `Vていただけませんか`, `Vたらいいですか`, `んですが`, `しか〜ない`, `ながら`, `し`, result-state `ている`, `てしまう/ちゃう`, `てある`, and `ておく`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `24`. Revision `23` was superseded during live proof because bracket notes with `なA/N` were stripped by canonicalization; final data uses `な形容詞 / 名詞` and reseeds existing N4 browsers.
- Verified under Directive C: JSON/source-tag check `20/20`, banned-tag check clean, focused suite passed, `flutter analyze lib test` clean, UI string guard clean, literal-route guard clean, content status machine/open-review `0`, release build pass, and Firebase Hosting deploy pass. Full `flutter test` deferred until N4 grammar level completion.
- Live proof: production browser with normal cache. The real N4 Grammar UI upgraded `flutter.grammar_data_version_N4` to `24`; list rows rendered `普通形 + んです（な形容詞 / 名詞 + なんです）`, `V普通形 / いA / なAだ / Nだ + し`, `Nが + 他動詞て形 + あります`, and `Vて + おきます`. Opening `Nが + 他動詞て形 + あります` rendered the corrected `KẾT NỐI`. Page-context fetch with `cache: default` returned `no-cache` for `main.dart.js`, `grammar_n4_26.json`, `grammar_n4_29.json`, and `grammar_n4_30.json`; `sqlite3.wasm` and `drift_worker.js` remained `public, max-age=2592000`. New console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N4 Lessons 31-35 Batch

- Source-verified 20 N4 grammar points in lessons 31-35; replaced old `vi-human-approved` tags with truthful `vi-source-verified`.
- Corrected/clarified formations for `つもり`, `予定`, `ほうがいい`, `でしょう`, `かもしれません`, `でしょうか`, imperative/prohibitive, `と読みます`, `という意味です`, `と言っていました`, `ば`, and `ても`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `25`.
- Verified under Directive C: JSON/source-tag check `20/20`, banned-tag check clean, focused suite passed, `flutter analyze lib test` clean, UI string guard clean, literal-route guard clean, content status machine/open-review `0`, release build pass, and Firebase Hosting deploy pass. Full `flutter test` deferred until N4 grammar level completion.
- Live proof: production browser with normal cache. The real N4 Grammar UI upgraded `flutter.grammar_data_version_N4` to `25`; list rows rendered `V普通形 / いA / なA語幹 / N + でしょう`, `命令形 / V辞書 + な`, `Vば / いAければ / なAなら / Nなら`, and `Vても / いAくても / なAでも / Nでも`. Opening `ても` rendered the corrected `KẾT NỐI`. Page-context fetch with `cache: default` returned `no-cache` for `main.dart.js`, `grammar_n4_31.json`, `grammar_n4_32.json`, and `grammar_n4_35.json`; `sqlite3.wasm` and `drift_worker.js` remained `public, max-age=2592000`. New console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N4 Lessons 36-40 Batch

- Source-verified 20 N4 grammar points in lessons 36-40; replaced old `vi-human-approved` tags with truthful `vi-source-verified`.
- Corrected/clarified formations for `ように`, `ようになりました`, `ようにしています`, passive forms, nominalization with `の`, cause `て`, `ので`, `ために`, `おかげで`, embedded questions, `かどうか`, and `てみます`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `26`.
- Verified under Directive C: JSON/source-tag check `20/20`, banned-tag check clean, focused suite `48/48`, `flutter analyze lib test` clean, UI string guard clean, literal-route guard clean, content status machine/open-review `0`, release build pass, and Firebase Hosting deploy pass. Full `flutter test` deferred until N4 grammar level completion.
- Live proof: production browser with normal cache. The real N4 Grammar UI upgraded `flutter.grammar_data_version_N4` to `26`; searching `かどうか` rendered corrected rows, and opening the first result rendered `KẾT NỐI: V普通形 / いA / なA語幹 / N + かどうか`. Page-context fetch with `cache: default` returned `no-cache` for `main.dart.js`, `grammar_n4_36.json`, `grammar_n4_39.json`, and `grammar_n4_40.json`; `sqlite3.wasm` and `drift_worker.js` remained `public, max-age=2592000`. New console warnings/errors `0`.

## 2026-05-19 QA-B-001 Grammar N4 Lessons 41-45 Batch

- Source-verified 20 N4 grammar points in lessons 41-45; replaced old `vi-human-approved` tags with truthful `vi-source-verified`.
- Corrected/clarified formations for giving/honorific receiving patterns, purpose `ために`, usage `のに`, appearance `そうだ`, `てくる/ていく`, `すぎます`, `やすい/にくい`, state-change `く/にする・なる`, `場合は`, contrast `のに`, `とき`, and `ても`.
- Bumped AppDatabase and ContentDatabase grammar seed revisions to `28`.
- Verified under Directive C: JSON/source-tag check `20/20`, banned-tag check clean, focused suite `48/48`, `flutter analyze lib test` clean, UI string guard clean, literal-route guard clean, content status machine/open-review `0`, release build pass, and Firebase Hosting deploy pass. Full `flutter test` deferred until N4 grammar level completion.
- Live proof: production browser with normal cache. The real N4 Grammar UI upgraded `flutter.grammar_data_version_N4` to `28`; searching `すぎ` rendered the corrected row, and opening the result rendered `KẾT NỐI: Vます語幹 / いA語幹 / なA語幹 + すぎます`. Page-context fetch with `cache: default` returned `no-cache` for `main.dart.js`, `grammar_n4_41.json`, `grammar_n4_44.json`, and `grammar_n4_45.json`; `sqlite3.wasm` and `drift_worker.js` remained `public, max-age=2592000`. New console warnings/errors `0`.

## 2026-05-19 QA-A-018 App Check Deploy Guard

- Owner P1 defect: Firebase Console showed Authentication App Check traffic at `0% verified / 100% unverified`.
- Confirmed production symptom: live Network did not show App Check token exchange or reCAPTCHA/App Check SDK requests, and Auth requests lacked `X-Firebase-AppCheck`.
- Added RED/GREEN guard for App Check preload, deploy build key injection, and explicit startup logging when a release web build lacks `JPSTUDY_RECAPTCHA_SITE_KEY`.
- Implemented shared `tool/deploy/hosting_deploy.js`; all loop deploys must use this helper so deployable web builds abort when `JPSTUDY_RECAPTCHA_SITE_KEY` is empty.
- Patched CI deploy to use the same helper. Enforcement remains off by owner policy.

## 2026-05-20 App Check, Sentry CSP, and Grammar Surface Batch

- Completed QA-A-018 deploy path: `web/preload.js` now preloads `firebase-app-check.js`, `lib/main.dart` logs missing release App Check keys instead of silently skipping, CI deploy uses `node tool/deploy/hosting_deploy.js`, and the helper redacts tokens while avoiding Windows `shell:true` deploy warnings.
- Fixed Sentry CSP: Hosting `script-src` includes `https://browser.sentry-cdn.com`, while `connect-src` keeps `https://*.sentry.io`.
- Fixed upper-level grammar examples: `GrammarSeeder`, `ContentDatabase`, and `findGrammarExamplesForDefinition` now handle object-wrapped flat example rows. Added integrity coverage so every N5-N1 grammar definition must match examples.
- Fixed direct grammar detail deep links: `GrammarRepository.getGrammarDetail` now seeds the active level before returning not-found for a missing id. RED proof was `/#/grammar/81` in a fresh VI/N4 context.
- Source-verified N4 grammar lessons 46-50, replaced old `vi-human-approved` tags with truthful `vi-source-verified`, corrected formations/explanations for timing, expectation, hearsay, appearance, causative, honorific, humble, and formal polite patterns, and bumped grammar seed revisions to `29`.
- Verified locally: `npm run test:research-tooling` passed `61`, `python tooling/audit_ui_string_literals.py --check` reported `0`, `dart run tool\research\content_vi_status_report.dart` scanned `23,444` items with machine/open-review `0`, `flutter analyze lib test` clean, focused Flutter suite passed `72`, and full `flutter test` passed `2347`.
- Deployed with `node tool\deploy\hosting_deploy.js`; `npm run test:web-resource-smoke` passed against `build/web`.
- Live headers: `main.dart.js`, `grammar_n4_46.json`, and `grammar_examples/n4/lesson_46.json` returned `Cache-Control: no-cache`; CSP contains reCAPTCHA, `browser.sentry-cdn.com`, and `*.sentry.io`.
- Live proof: App Check SDK loaded, reCAPTCHA loaded, `firebaseappcheck.googleapis.com` exchange attempted, Auth requests carried `X-Firebase-AppCheck`, and Sentry CDN returned `200`. Headless reCAPTCHA exchange returned `403`, so App Check enforcement remains off.
- Live proof: fresh VI/N2 direct `/#/grammar/1` rendered real examples for `A あるいは B` and the grammar gate opened `Câu 1/5`; fresh VI/N4 direct `/#/grammar/81` rendered examples for `ところです`, the gate opened `Câu 1/5`, and catalog search `ところです` returned the row instead of an empty state.

## 2026-05-20 Directive D Foundations/Kana Copy Batch

- Fixed QA-A-022: Kana detail sheets no longer expose the self-attestation `Tôi đã thuộc`; the learner must enter the existing Kana quiz gate, and Kana progress/SRS comes from quiz grading.
- Fixed QA-A-023: learner-facing Mistakes, JLPT support, and Weakness Radar copy no longer exposes internal `D1/D3/D7` checkpoint labels; copy now uses 1-day/3-day/7-day labels across VI/EN/JA.
- Fixed QA-A-024: Foundations hub and Kana detail copy no longer exposes `Open`, `66 yoon`, `32 rules`, `strokes`, `clear`, or `yoon`; VI hub renders `Mở luyện tập`, `71 ký tự`, `66 âm ghép`, and `32 quy tắc`.
- Verified locally: focused Foundations/Mistakes/JLPT/Home suites passed, English plural-risk guard passed, UI string literal guard reported `0`, `flutter analyze lib test` clean, and full `flutter test` passed with `2351`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: fresh VI/N5 Foundations opened Hiragana, opened the `あ` sheet, verified `3 nét`, verified no self-attestation CTA, opened `Luyện bảng chữ`, and reached the live quiz with `1/10` counter. `main.dart.js` returned `Cache-Control: no-cache` and had no stale `Tôi đã thuộc`, `I know this`, `D1 `/`D3 `/`D7 `, `66 yoon`, or `32 rules` strings. Unexpected console warnings/errors and unexpected HTTP 4xx/5xx were `0`; known headless App Check 403/throttle noise remained.

## 2026-05-20 QA-C-001 Conjugation Phase 0

- Wrote `docs/research/conjugation-feature-design-2026-05-19.md` for the owner-requested conjugation feature.
- Phase 0 covers JMdict POS/source policy, app/schema/SRS audit, IA/routes, content/user data models, pure Dart engine plan, form coverage, drill model, Grammar/Vocab/Kanji cross-links, and implementation/live-proof gates.
- Directive D code audit found a connected defect: Vocab detail currently uses suffix-guessed `_conjugationLines` and a generic `ます grammar` action. Logged it as QA-C-002; implementation must replace it with JMdict POS-backed forms and scoped practice.
- Verified doc batch: `git diff --check`, no placeholder strings in the new design doc, and no app/assets/test diff added `vi-human-approved`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live smoke: `https://jpstudy.web.app/?codexFresh=conj-phase0-20260520#/` booted, main nav rendered, `main.dart.js` returned `Cache-Control: no-cache`, and screenshot saved as `output/playwright/live-conjugation-phase0-home-smoke.png`. Console had one known report-only Google frame-ancestor message from the App Check/reCAPTCHA path, not a Flutter app exception.
- No `vi-human-approved` tag was added.

## 2026-05-20 QA-C-001 Conjugation Engine Slice

- TDD RED: added `test/core/conjugation/japanese_conjugator_test.dart`; it failed because `lib/core/conjugation/*` did not exist.
- GREEN: added pure Dart engine files under `lib/core/conjugation/` for JMdict POS normalization and deterministic forms.
- Covered fixtures: godan endings, `行く`, ichidan/godan `る` contrast, `する`, `勉強する`, `来る`, `ある`, `高い`, `いい`, and `静か`.
- Verified: focused conjugation test passed `6/6`, `flutter analyze lib test` reported no issues, UI string literal guard reported `0`, and full `flutter test` passed `2357/2357`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live smoke: `https://jpstudy.web.app/?codexFresh=conj-engine-20260520#/` booted, main nav rendered, `main.dart.js` returned `Cache-Control: no-cache`, console errors/warnings were `0`, and screenshot saved as `output/playwright/live-conjugation-engine-home-smoke.png`.
- Remaining QA-C-001 work: source metadata builder, content DB lemma table, conjugation SRS/mistakes, Vocab/Grammar/Kanji UI integration, deploy/live proof of learner flows.

## 2026-05-20 QA-C-001 Conjugation Metadata Slice

- TDD RED: added `test/tool/research/conjugation_lemma_builder_test.dart`; it failed because `ConjugationLemmaBuilder` and the CLI did not exist.
- GREEN: added `lib/core/conjugation/conjugation_lemma_builder.dart` and `tool/research/build_conjugation_lemmas.dart`.
- Directive D follow-up: generated output showed real JMdict cache POS values are expanded descriptions such as `Godan verb with 'ru' ending`; added a RED/GREEN engine regression so godan/suru description POS maps correctly instead of silently dropping godan verbs.
- Generated `assets/data/content/conjugation/lemmas.json` from the local JMdict_e cache. Output: `3907` source-backed rows; `365` rows matched polite curriculum `ます` forms by generating forms from JMdict POS, not by suffix guessing.
- Diagnostics retained in the asset: `198` unmatched conjugatable-looking rows, `183` suffix-only skips, and `153` ambiguous matches for later normalization/content cleanup.
- Verified locally: focused engine/builder suite passed `9/9`, `flutter analyze lib test` clean, UI string guard `0`, content status machine/open-review `0`, `git diff --check` clean, and full `flutter test` passed `2360/2360`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: `https://jpstudy.web.app/assets/assets/data/content/conjugation/lemmas.json?codexFresh=conj-lemmas-20260520` returned `200`, `Cache-Control: no-cache`, `source=JMdict_e`, and `entryCount=3907`. `main.dart.js` also returned `no-cache`.
- Live smoke: `https://jpstudy.web.app/?codexFresh=conj-lemmas-20260520#/` booted the Vietnamese shell and main nav; Playwright console had no Flutter errors/warnings. The only report was the known Google frame-ancestor report-only message from the App Check/reCAPTCHA path. Screenshot saved as `live-conjugation-lemmas-home-smoke.png`.
- Remaining QA-C-001 work: content DB lemma table, conjugation SRS/mistakes, Vocab/Grammar/Kanji UI integration, deploy/live proof of learner flows.

## 2026-05-20 QA-C-001 Conjugation Content DB Slice

- TDD RED: added `test/data/content/conjugation_content_seed_test.dart`; it failed because `ConjugationRepository` and the content DB lemma plumbing did not exist.
- GREEN: added `ConjugationLemma` to ContentDatabase schema v36, created DB indexes, seeded active-level lemma metadata from `assets/data/content/conjugation/lemmas.json`, and added repository lookups by content vocab id, source ids, level, and due content vocab ids.
- Verified locally: focused conjugation seed test proved N5 `帰る` resolves as `godanRu`, N5 `起きる` resolves as `ichidan`, `学生` returns no lemma, source-id lookup works, and N4 remains unseeded when active level is N5.
- Verified gates: focused conjugation suites passed, `flutter analyze lib test` clean, UI string guard `0`, content status machine/open-review `0`, `git diff --check` clean, and full `flutter test` passed `2362/2362`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: `main.dart.js?codexFresh=conj-db-20260520` returned `200/no-cache` and contained `conjugation_lemma` plus `idx_conjugation_lemma_vocab`; `lemmas.json` returned `200/no-cache`, `source=JMdict_e`, `entryCount=3907`, with `haj_n5_ch10_v033` and `haj_n5_ch01_v008` present.
- Directive D defect logged during fresh-browser live proof: onboarding language screen at 1366x768 lets `Tiếng Việt` be selected but shows no visible continue CTA because the analytics consent banner occupies the bottom; logged QA-A-025 as next P0 before lower-priority QA-C work.
- Remaining QA-C-001 work after QA-A-025: conjugation SRS/mistakes, Vocab/Grammar/Kanji UI integration, deploy/live proof of learner flows.

## 2026-05-20 QA-A-025 Onboarding Consent Banner Fix

- TDD RED: added a full router regression where a fresh 1366x768 browser shows language onboarding with the analytics consent banner; selecting `Tiếng Việt` then tapping `language_continue` failed to reach the level screen.
- GREEN: changed `AnalyticsConsentBanner` from a bottom overlay to a bottom layout block using `Expanded(child: child)` plus a reserved banner area, so the banner cannot cover or intercept app CTAs.
- Verified locally: focused onboarding/consent suite passed, `flutter analyze lib test` clean, UI string guard `0`, `git diff --check` clean, and full `flutter test` passed `2363/2363`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: fresh browser at `https://jpstudy.web.app/?codexFresh=onboarding-banner-20260520#/` showed the Continue button above the consent banner, selected VI, continued to `/#/onboarding/level`, selected N5, started onboarding, and reached VI/N5 home. `main.dart.js` returned `200/no-cache`; only known headless App Check 403/throttle and WebGL readback warnings appeared.
- Next queue item returns to QA-C-001 remaining work: conjugation SRS/mistakes.

## 2026-05-20 QA-C-001 Conjugation SRS/Mistakes Slice

- TDD RED: `test/data/daos/conjugation_srs_dao_test.dart` failed before generated DAO/schema wiring; `test/features/mistakes/mistake_screen_test.dart` failed because `conjugation` mistakes showed fallback grammar UI and raw source context; `test/data/daos/mistake_dao_test.dart` proved conjugation rows were missing from total mistake counts.
- GREEN: added AppDatabase schema v32 `ConjugationSrsState`, exact `(contentVocabId, formKey, direction)` SRS rows, due/stage-count DAO methods, `FsrsService` review updates, wrong-answer `conjugation` mistake logging with skill context, and learner-facing Mistakes rendering for form/direction/source with no raw `conjugation_practice` label.
- Fixed connected count behavior: `MistakeDao.watchMistakeCounts()` and `getMistakeCounts()` keep existing vocab/grammar/kanji buckets but total now includes all types, including conjugation.
- Verified locally: focused conjugation/mistake suites passed `36/36`, `flutter analyze lib test` clean, UI string guard `0`, `git diff --check` clean, and full `flutter test` passed `2368/2368`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: `https://jpstudy.web.app/?codexFresh=conj-srs-20260520#/mistakes` rendered the Saved Mistakes empty state cleanly, Home nav CTA returned to dashboard, console warnings/errors were `0` after route load, and `main.dart.js` returned `200/no-cache` containing `conjugation_srs_state`, `idx_conjugation_srs_due`, `idx_conjugation_srs_skill`, and `Conjugation practice`.
- Remaining QA-C-001 work: connected conjugation hub/practice routes and Vocab/Grammar/Kanji/Daily Plan/Practice Board entry points.

## 2026-05-20 QA-C-001 Conjugation Hub/Practice Slice

- TDD RED: route smoke failed because `/#/grammar/conjugation` was swallowed by `/grammar/:id`; VI practice prompt regression failed because the question body still showed `Choose`.
- GREEN: registered Grammar-owned conjugation hub/practice/scoped routes before the generic detail route; added `ConjugationHubScreen`, `ConjugationPracticeScreen`, `ConjugationPracticeArgs`, and sourced question generation from `ConjugationLemma` + `JapaneseConjugator`.
- Directive D follow-up: localized practice prompts/options for VI, kept hub wrong-answer source as learner-facing `conjugation_practice`, and stored `dictionaryForm` in conjugation mistake context so Mistakes can render the lemma instead of a raw fallback.
- Verified locally: focused conjugation/route suite passed `10/10`, UI string literal guard reported `0`, `git diff --check` clean, `flutter analyze lib test` clean, and full `flutter test` passed `2372/2372`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: VI/N5 `/#/grammar/conjugation` rendered `398 mục có nguồn sẵn sàng`; `Luyện chia thể` opened the practice screen; selecting an option enabled `Trả lời`; confirming recorded the review and showed `Đúng` plus `Câu tiếp`. Screenshots saved under `output/playwright/live-conjugation-*.png`.
- Live bundle/header proof: `main.dart.js` returned `200/no-cache`, contained `grammar-conjugation` and `conjugation_practice`, and did not contain raw `conjugation_hub`; Playwright console had no app warnings/errors, only the known report-only Google frame-ancestor App Check message.
- Remaining QA-C-001 work: Vocab detail suffix-guess deletion/QA-C-002, scoped Grammar/Kanji CTAs, Daily Plan/Practice Board due conjugation entry points, and advanced context/repair/minimal-pair question families.

## 2026-05-20 QA-C-002 Vocab Detail Conjugation Slice

- Fixed QA-C-002: Vocab detail no longer guesses conjugation from suffixes or shows the generic `ます grammar` chip. It now fetches `ConjugationLemma` by content vocab id and renders `て/ない/た/ます` forms through `JapaneseConjugator`.
- Vocab detail hides the conjugation panel for nouns and un-sourced rows; sourced rows get a scoped `Luyện chia thể` CTA into `/grammar/conjugation/:contentVocabId`.
- Verified locally before docs: focused Vocab detail test passed `8/8`, focused Vocab + conjugation suites passed `12/12`, UI string guard `0`, `git diff --check` clean, `flutter analyze lib test` clean, and full `flutter test` passed `2374/2374`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: decoded the live content DB to resolve `帰る` content id `21438` and noun control `学生` id `21556`. VI/N5 `/#/vocab/21438` rendered examples plus sourced `thể て: 帰って` and no fake `帰て`; `Luyện chia thể` opened the scoped one-item hub, practice loaded `Câu 1/5`, selecting `帰って` and confirming showed `Đúng` + `Câu tiếp`. VI/N5 `/#/vocab/21556` rendered `学生` with examples and no `Chia động từ` panel.
- Live bundle/header proof: `main.dart.js` returned `200/no-cache`, contained the Vocab detail `Practice forms` path, contained `grammar-conjugation`, and did not contain old `ます grammar`, `Ngữ pháp 〜ます`, or `帰て`.
- Directive D connected defect logged as QA-A-026: Search `かえる` returned a visible `国へ帰るの` card, but clicking it did not navigate or change the route.
- Remaining QA-C-001 work: Grammar/Kanji/Daily Plan/Practice Board conjugation entry points plus advanced context/repair/minimal-pair drills.

## 2026-05-20 QA-A-026 Search Top-Hit Navigation Fix

- TDD RED: added `tap top search hit deep-links to vocab detail route`; it failed because tapping the top-hit card stayed on Search.
- GREEN: factored Search navigation into `_openSearchEntry` and wired `_SearchTopHitCard` to the same vocab/kanji/kana route helper already used by normal result tiles.
- Verified locally: targeted RED/GREEN test passed, full Search screen suite passed `14/14`, `git diff --check` clean, UI string guard `0`, and `flutter analyze lib test` clean.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: VI/N5 `/#/search`, query `かえる`, top-hit `国へ帰るの` opened the `Chi tiết từ` screen for that result. `main.dart.js` returned `200/no-cache`; console warnings/errors were `0`.
- Remaining queue: QA-C-001 connected Grammar/Kanji/Daily Plan/Practice Board conjugation entry points, then advanced context/repair/minimal-pair drills unless a higher-priority defect appears.

## 2026-05-20 QA-C-001 Connected Conjugation Entry Points

- Completed the remaining connected entry-point slice: Grammar detail detects form-related patterns and opens related conjugation practice, Kanji detail example words expose sourced `Luyện chia thể`, Home/Continue/Daily Plan/Daily Session/Next Step/Progress count `conjugationDue`, and Practice Board routes due conjugation to `grammarConjugationPractice`.
- Directive D live proof caught a detector gap: live grammar rows normalized as `Verb-て` were not matched by the original `Vて` checks. Added `Verb-て/Verb-た/Verb-ます/Verb-ない` detection and a regression.
- Due practice now scopes `due`/`queue` sources to `conjugationSrsDao.getDueContentVocabIds()` instead of falling back to all level lemmas.
- Verified locally: focused grammar route regression, focused conjugation/SRS suite, `flutter analyze lib test`, `git diff --check`, UI string guard `0`, and full `flutter test` passed `2381/2381`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: fresh VI/N4 `/#/grammar/81` rendered examples and `Luyện chia thể liên quan`; CTA opened a non-empty form drill; a wrong answer created `Ôn lại thể này` and a due SRS card.
- Live proof: fresh VI/N4 Kanji grid opened `飼`; detail showed example words and `Luyện chia thể`; CTA opened scoped `1 mục có nguồn sẵn sàng`, then a non-empty conjugation question.
- Live proof: after the due interval, Practice Board showed `Ôn chia thể đến hạn`, Daily Plan included the same lane, and `Mở chia thể` opened due-scoped `Câu 1/1`; `main.dart.js` returned `200/no-cache` with `grammar-conjugation`; Flutter/app exceptions were `0`, with only the known report-only Google frame-ancestor console entry.
- Remaining QA-C-001 work: advanced context/repair/minimal-pair drills. Continue the broader Directive D full-app sweep before opening lower-priority content work.

## 2026-05-20 QA-A-027 Lesson And Ghost Self-Attestation Sweep

- Directive D full-app sweep found lesson vocab flashcards still exposed a manual learned checkmark that toggled `isLearned` and seeded SRS without testing the learner.
- The same sweep found legacy ghost grammar practice exposed `Mark as Mastered` after an answer; removed it and now records each answer through `GrammarRepository.recordReview`, so correct answers clear ghost state through the SRS path and wrong answers remain due.
- Fixed connected copy defects: lesson grammar `v? d?`, grammar hub "Đã đánh dấu..." caption, Practice "chặn rơi nhớ/vá điểm yếu", and roadmap "vá điểm yếu".
- Verified locally: focused lesson/grammar/home/practice suites, `flutter analyze lib test`, UI string guard, `git diff --check`, and full `flutter test` passed with `2387/2387`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: VI/N5 lesson vocab flashcard shows the star action but no manual learned checkmark; lesson Grammar tab shows natural `10 ví dụ` copy instead of `v? d?`; Practice shows `Một lộ trình ngắn để giữ trí nhớ, củng cố điểm yếu...`; `main.dart.js` is `200/no-cache` and contains none of the stale `Mark as Mastered`, `Đánh dấu đã thuộc`, `Đã đánh dấu`, `v? d?`, `Dọn hàng`, `chặn rơi`, or `vá điểm yếu` strings.
- Fresh live CSP proof: a new Chromium context loaded reCAPTCHA and Sentry CDN with no CSP violations and no Flutter/app exceptions; only the known headless App Check 403/throttle and WebGL readback warnings appeared.

## 2026-05-20 P0 Backlog Live-Proof Cleanup

- Rechecked old fixed-local P0 backlog rows after the latest deploy.
- QA-A-001 live proof: fresh VI/N5 `/#/exam-center`, then sidebar `Hồ sơ`, changed the route to `#/me`, rendered the `Cá nhân` profile screen, and did not fall back to `/#/vocab`.
- QA-A-004 live proof: fresh VI/N2 `/#/lesson/1?level=N2` rendered `N2 / Shin Kanzen N2 Bài 1`, not the stale Minna label; after load the Vocab card showed `73` terms, and the Grammar tab rendered N2 grammar with `28 ví dụ` plus `Bắt đầu học (25 câu)`.
- No code changes in this cleanup; docs/backlog statuses now reflect the deployed live state.

## 2026-05-20 QA-A-028/QA-A-029 Copy And Vocab Cold-Route Batch

- Completed the dirty batch from the Directive D sweep: QA-A-028 replaced Home/Library Vietnamese copy such as `dọn review`, `dọn hàng đợi`, mixed `level`/`lesson`, and live-caught `TÍN HIỆU LEVEL` with learner-facing Vietnamese copy.
- Fixed QA-A-029: Vocab hub no longer waits for ContentDB-backed catalog/review providers before first paint. Catalog counts now come from bundled asset manifests/counts, and the screen renders a `VocabHomeSection` fallback while review-home data is loading or unavailable.
- Connected defect logged for next queue: QA-A-030 covers the same cold direct-route loading class on fresh `/#/grammar` and `/#/kanji`.
- Verified locally: focused copy/vocab suite passed `56/56`, `flutter analyze lib test` clean, UI string guard `0`, `git diff --check` clean, and full `flutter test` passed `2392/2392`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof after deploy: fresh VI/N5 `/#/vocab` rendered `Hôm nay`, `Tra nhanh từ vựng`, `Học phần cốt lõi`, `Hajimete no Nihongo Tango`, `Minna no Nihongo I`, and `1,327 mục từ`; `Ôn ngay` opened `Ôn N5`; `Minna no Nihongo I` opened the lesson catalog with `Bài 1`, `51 từ trong bài này`, and progress copy.
- Live proof after deploy: VI/N2 Home, Daily Summary, and Library copy sweep found no `dọn review`, `dọn hàng đợi`, `TÍN HIỆU LEVEL`, `level `, or `lesson ` leaks. Proof JSON: `output/playwright/live-qaa028-qaa029-proof.json`. Headless App Check 403/throttle messages were ignored as environment-only Firebase App Check noise; no Flutter app exception was observed.

## 2026-05-20 QA-A-030 Grammar/Kanji Cold Direct Routes

- Fixed QA-A-030: direct `/#/grammar` and `/#/kanji` no longer show spinner-only content panels during first-run DB-backed seed/fetch work.
- Grammar now renders a bounded learner-facing loading panel for the grammar bank, examples, and practice entry points; Kanji grid now renders a bounded learner-facing loading panel while level tabs, writing practice, and Hán-Việt rules remain reachable.
- Verified locally: targeted RED/GREEN loading tests, focused Grammar/Kanji suites `30/30`, `flutter analyze lib test` clean, UI string guard `0`, `git diff --check` clean, and full `flutter test` passed `2394/2394`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof after deploy: VI/N5 `/#/grammar` rendered the Grammar hub; Grammar practice CTA opened a non-empty drill; Grammar detail CTA opened a non-empty point drill; VI/N5 `/#/kanji` rendered the Kanji hub; `Viết` opened writing practice; Hán-Việt CTA opened the rules screen.
- Live artifacts: `output/playwright/live-qaa030-proof.json`, `output/playwright/live-qaa030-grammar-direct.png`, `output/playwright/live-qaa030-grammar-practice-cta.png`, `output/playwright/live-qaa030-grammar-detail-cta.png`, `output/playwright/live-qaa030-kanji-direct.png`, `output/playwright/live-qaa030-kanji-write-cta.png`, and `output/playwright/live-qaa030-kanji-hanviet-cta.png`.
- Known environment-only live noise: headless Firebase App Check 403/throttle messages. Flutter/app failures were `0`.

## 2026-05-20 P1 Backlog Live-Proof Cleanup

- Rechecked old fixed-local P1 rows after the latest deploy.
- QA-A-002 live proof: fresh VI/N5 `/#/vocab` showed `Hajimete no Nihongo Tango`, `Minna no Nihongo I`, `Sẵn sàng`, and `Bổ trợ`, with no `Ready now`, `Companion`, `14 chapter`, `Catalog`, or raw `review queue` leaks; clicking `Minna no Nihongo I` opened the populated catalog with `Bài 1` and `51 từ trong bài này`.
- QA-A-003 live proof: fresh VI/N5 `/#/review` rendered `Ôn tập` with no warehouse copy (`Chặn hàng review trước`, `Dọn hàng kanji`, `hàng đợi đang mở`); `Mở bài học`, `Mở ôn thi JLPT`, and `Mở bài đọc` each reached target content.
- QA-A-005 live proof: fresh VI/N2 Home and Review showed no `Bắt đầu Minna No Nihongo 200001` / `Minna No Nihongo 200001` storage-id leak.
- Bundle proof: `main.dart.js` returned `200/no-cache`. Unexpected console warnings/errors and unexpected failed requests were `0`; known environment-only font/App Check/Sentry/Kaspersky network noise was ignored.
- Artifact: `output/playwright/live-p1-backlog-cleanup-proof.json`. Screenshots: `output/playwright/live-qaa002-vocab-copy.png`, `output/playwright/live-qaa002-vocab-minna-catalog.png`, `output/playwright/live-qaa003-review-copy.png`, `output/playwright/live-qaa005-n2-home.png`, and `output/playwright/live-qaa005-n2-review.png`.

## 2026-05-20 QA-A-008 Closeout + QA-A-031 Grammar Option Quality

- Re-audited QA-A-008 after the P1 cleanup. Local guard confirms every runtime N5-N1 grammar point has generated practice questions; `assets/data/content/index.json` reports `grammarPractice.entries=754` and `authoredQuestions=0`.
- Closed QA-A-008 functionally: Grammar detail no longer exposes manual self-attestation, shared generated questions come through `GrammarPracticeBank`, JLPT mock grammar also uses the shared bank, and QA-A-009 already completed shared select -> confirm answer UI.
- Directive D live proof before the fix found a connected defect: upper-level transformation drills could show options that differed only by final punctuation. Logged and fixed this as QA-A-031.
- TDD: RED `transformation options avoid punctuation-only duplicates` failed with normalized option count `3` vs raw option count `5`; GREEN dedupes transformation options after stripping sentence-final punctuation while keeping the correct answer.
- Verified locally: focused grammar/JLPT bank suite passed `31/31`, `flutter analyze lib test` clean, UI string guard `0`, `git diff --check` clean, and full `flutter test` passed `2395/2395`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof after deploy: VI N5/N4/N3/N2/N1 Grammar hub -> first detail -> examples -> `Luyện tập để hiểu` all reached `Câu 1/5`, with no empty due state and no manual learned copy; rendered transformation option keys were unique after punctuation normalization. `main.dart.js` returned `200/no-cache`; unexpected console warnings/errors and unexpected failed requests were `0`.
- Artifacts: `output/playwright/live-qaa008-qaa031-grammar-proof.json` plus `output/playwright/live-qaa008-*-practice-gate.png`.
- QA-B-003 logged for later content enrichment: authored grammar practice bank is empty, but generated coverage is complete, so this no longer blocks QA-A-008.

## 2026-05-20 QA-A-026 Kanji Level Audit Phase 0

- Paused the older JA-locale dirty batch in `stash@{0}` before touching the new P0 kanji work.
- Repaired an accidental local `package.json` npm dependency dump back to `HEAD`; no app/code/data changes were kept from that leak.
- Added the new owner kanji taxonomy P0 row to `docs/research/quality-backlog.md` at the top of the queue. The ID collides with the already-fixed historical search QA-A-026 row; the backlog row notes the collision.
- Generated `docs/research/kanji-level-audit-2026-05-20.md` for Phase 0 only. No kanji JSON files were edited.
- Current app scan: `929` kanji entries, `638` unique characters. Candidate canonical scan after owner spot-check overrides: `2495` unique characters.
- Audit counts under the candidate policy: MOVE `479`, DUPLICATE `196`, MISSING `1872`, EXTRA `15`.
- Important blocker before Phase 1 data rewrite: the supplied PDFs are vector-glyph PDFs and not text-extractable, and visual inspection/public JLPT tables conflict with the owner's expected labels for `海`, `帰`, `銀`, `重`, and `議`. The audit doc therefore requires owner approval of the override policy before implementing MOVE/DEDUPE/MISSING changes or hard-coding canonical guards.

## 2026-05-20 JA Locale Cleanup + Source Ban

- Resumed the paused JA-locale dirty batch and completed the cross-flow cleanup so Japanese UI no longer leaks Vietnamese fallbacks across vocab, lesson, grammar, JLPT, kanji, practice, and handwriting surfaces when better localized/fallback text exists.
- Added `LessonTermDisplay` so shared lesson/vocab/kanji surfaces choose display text by active app language instead of directly reading Vietnamese labels.
- Added the owner-requested crawl/source ban to `AGENTS.md` and `docs/agent-directives.md`: do not search/fetch/crawl/browse `nhaikanji.com` or `thocodehoctiengnhat.com`; use local PDFs/files only.
- Verified before deploy: focused suite passed `235/235`, `flutter analyze lib test` clean, UI string guard `0`, content VI status machine/open-review `0`, taxonomy guard passed, and full `flutter test --concurrency=1` passed `2406/2406`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof used normal browser cache: `main.dart.js` returned `200/no-cache`; JA vocab, lesson, grammar, grammar practice, kanji, kanji practice, and mock surfaces rendered without Vietnamese fallback leaks; VI control still rendered Vietnamese where expected; unexpected console/page errors were `0`.
- Live artifacts: `output/playwright/live-ja-locale-cleanup-proof.json` and screenshots `output/playwright/live-ja-locale-*.png`.
- Next priority after this commit: QA-A-027 Phase 0 ebook extraction plan from local PDFs only, superseding the older QA-A-026 source plan.

## 2026-05-20 QA-A-027 Canonical Ebook Extraction Phase 0

- Added the new owner QA-A-027 P0 row to `docs/research/quality-backlog.md`, above the older QA-A-026 reclassification row, and added the new QA-A-028 Hán-Việt redesign P1 row queued after QA-A-027/QA-A-026.
- Confirmed all six local PDFs exist under `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Ebook/`; no banned website was accessed.
- Poppler `pdfinfo` page counts: N5 `40`, N4 `21`, N3 `126`, N2 part 1 `78`, N2 part 2 `92`, N1 `131`, total `488`.
- Rendered 3 sample pages per PDF at 150 DPI into `tmp/kanji_ebook_phase0_samples/` and ran Tesseract `vie+jpn+eng` baseline OCR into `tmp/kanji_ebook_phase0_ocr/`.
- Sample finding: N5/N3/N2 use full large-card entries with Hán-Việt, meaning, on/kun readings, vocab examples, and writing hints; N4/N1 use compact writing-grid rows with usable text layer for Hán-Việt/meaning/writing mnemonics but no full example/readings block in sampled pages.
- Created `docs/research/canonical/extraction-plan-2026-05-20.md` with schema, quirks, estimated entry counts, batch plan, and owner approval gate before full extraction.

## 2026-05-20 QA-A-027 Autonomous Extraction WIP Blocker

- Owner removed the approval gate. Ran Phase 1 candidate extraction from local PDFs only using `tool/research/extract_canonical_kanji_ebooks.js`; added tests in `test/tool/research/canonical_kanji_ebook_extractor_test.js`.
- Generated candidate canonical files: N5 `102`, N4 `172`, N3 `335`, N2 `489`, N1 `762`.
- Improved extraction during the run: large-card PDFs now OCR 3 cropped cards per page; missing Hán-Việt/readings/strokes are supplemented from local KANJIDIC2 and existing app source-verified rows with explicit field sources.
- Blocker: validation found `284` cross-level duplicate characters, and N4/N1 writing-grid PDFs sometimes expose mnemonic components instead of the visual target kanji in the text layer. Example class: heading `DẬU` can expose `一`/`西` while the visual target is `酉`.
- Decision: commit candidate canonical WIP and prominent blocker; do not run QA-A-026 app data MOVE/DEDUP/MISSING against these candidates yet because that would rewrite kanji levels from ambiguous source data.
- Added the new owner QA-A-029 Kanji relationship graph P1 row to backlog. Next unblocked queue item is QA-A-028 design/implementation, then QA-A-029, unless a stronger QA-A-027 extraction path becomes available.

## 2026-05-20 QA-A-028 Han-Viet Rules Redesign Phase 0

- Audited current static Hán-Việt rule system: `han_viet_on_rules.json` schema v1 has `32` rules across usage/initial/final/rime/long-vowel/exception categories; `/kanji/han-viet` currently renders static ExpansionTile reference cards.
- Audited generation inputs: kanji assets contain `929` entries with Hán-Việt and `926` with On readings; first-consonant pools are large enough for rule 1 (`H/K/Gi/C/Qu`) and most initial rules.
- Audited integration points: existing kanji SRS uses `KanjiSrsDao`; kanji detail already has an inline Hán-Việt panel but only matches exact example kanji, not real rule applicability.
- Added autonomous design doc `docs/research/han-viet-rules-redesign-2026-05-20.md` with v2 schema, generator policy, UI, SRS/interlink plan, DECISIONS MADE, and OPEN_QUESTIONS. No banned website was accessed.
- Owner added QA-A-030 during QA-A-028 implementation: offline vocab/grammar canonical extraction from `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Tu Vung`, with copyright-safe fact extraction and the same autonomous no-gate policy. Logged it in the backlog after QA-A-029; continue current QA-A-028 work first.
- Owner added QA-A-031 during QA-A-028 implementation: Usage Policy page with original JpStudy prose, copyright-learning-material disclaimer, `xboxonevn@gmail.com` contact/takedown email, VI/EN/JA copy, onboarding/settings/footer integration, and autonomous no-gate policy. Logged it in the backlog after QA-A-030; continue current QA-A-028 work first.

## 2026-05-20 QA-A-028 Han-Viet Rules Redesign Phase 1

- Implemented the reference rule `H/K/Gi/C/Qu -> K/G` as a full v2 learning card: generated examples, five MC practice questions, inline feedback, `Đã hiểu rule` threshold, rule SRS, and kanji SRS updates.
- Added `tool/research/generate_han_viet_rule_content.js`, `assets/data/content/kanji/han_viet_on_rules_v2.json`, v2 Dart models/service/provider, Drift table/DAO for Hán-Việt rule SRS, and a `KanjiSrsDao.recordReview` helper.
- Verified locally before live proof: generator test, focused asset/service/screen/DAO tests, `flutter analyze lib test`, UI string guard `0`, content status `0`, taxonomy/content guards, and full `flutter test --concurrency=1` passed with `2411/2411`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof on normal production cache: VI `/kanji/han-viet` rendered the v2 rule card, examples, and practice; answering the five correct options produced five `Đúng` feedbacks and `Đã hiểu rule`; `/review` loaded after the SRS write; EN/JA did not render Hán-Việt content; `main.dart.js` returned `Cache-Control: no-cache`; Flutter/app console errors were `0`.
- Live artifacts: `output/playwright/live-qaa028-hanviet-phase1-proof.json`, `output/playwright/live-qaa028-hanviet-phase1-initial.png`, `output/playwright/live-qaa028-hanviet-phase1-answered.png`, `output/playwright/live-qaa028-hanviet-phase1-review.png`, `output/playwright/live-qaa028-hanviet-phase1-en-gate.png`, and `output/playwright/live-qaa028-hanviet-phase1-ja-gate.png`.
- Remaining QA-A-028 work: Phase 2 scale all rules/sub-rules, then Phase 3 kanji-detail/review/personalized interlinks.

## 2026-05-20 QA-A-027 Blocker Resolution Policy

- Owner resolved the QA-A-027 blocker with autonomous policy alpha: keep N5/N3/N2 large-card candidates, re-extract N4/N1 writing-grid PDFs with 200-DPI pixel/vision OCR only, ignore text-layer mnemonic components, and choose the large central target kanji per grid cell.
- Duplicate policy for canonical master mapping: cross-level duplicates resolve to the lowest JLPT level, then hard owner overrides win for `海 -> N5`, `帰 -> N5`, `銀 -> N3`, `重 -> N3`, and `議 -> N2`.
- Required outputs when this P0 resumes: `docs/research/canonical/kanji-master-mapping-2026-05-20.json` and `docs/research/canonical/kanji-canonical-open-questions-2026-05-20.md`, then QA-A-026 app kanji MOVE/DEDUPE/MISSING/EXTRA implementation with cross-level duplicate guard and live proof.
- Current local state when policy arrived: QA-A-028 Phase 2 first 5-rule batch already dirty and deployed for proof. Finish and commit that batch first, then switch to QA-A-027/QA-A-026 P0 chain.

## 2026-05-20 QA-A-028 Han-Viet Rules Redesign Phase 2 Batch 1

- Expanded `han_viet_on_rules_v2.json` from the single reference card to five generated practice cards: `H/K/Gi/C/Qu -> K/G`, `T/Th -> T/S/SH`, `Ng/Ngh -> G/GY`, `L -> R`, and `N/Nh -> N/J/NY`.
- Batch now has 5 rule cards and 25 generated practice questions, all from local app kanji/vocab assets with banned domains excluded.
- Verified locally: generator test passed, focused Hán-Việt content/service/screen tests passed, UI string guard `0`, content status machine/open-review `0`, and `git diff --check` clean.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: VI `/kanji/han-viet` showed the first rule, search `Ng/Ngh` showed rule 3 and one answer produced `Đúng`, fresh search `N/Nh` showed rule 5, `main.dart.js` returned `Cache-Control: no-cache`, and Flutter/app console errors were `0`.
- Live artifacts: `output/playwright/live-qaa028-hanviet-phase2-batch1-proof.json`, `output/playwright/live-qaa028-hanviet-phase2-batch1-initial.png`, `output/playwright/live-qaa028-hanviet-phase2-batch1-ng-answer.png`, and `output/playwright/live-qaa028-hanviet-phase2-batch1-nnh-search.png`.
- Per owner's latest P0 direction, pause remaining QA-A-028 Phase 2/3 and switch to QA-A-027 blocker resolution + QA-A-026 kanji reclassification after committing this batch.

## 2026-05-21 Megaprompt Phase 4 Exercise Engine Batch 1

- Added the shared `Exercise`, `ExerciseType`, `BloomLevel`, `ExerciseBank`, `GeneratedExerciseBank`, and `ExerciseValidator` foundation for Directive F density checks.
- Bridged existing generated grammar practice into `GrammarPracticeBank.buildExerciseBank`, with deterministic per-item densification to `>=50` exercises, Bloom L1-L4 coverage, and engine coverage for all six Phase 4 exercise types.
- TDD RED/GREEN: `test/features/exercise/exercise_bank_test.dart` first failed on the missing Exercise API, then passed after implementation.
- Added runtime guard proving every N5-N1 grammar point reaches dense ExerciseBank coverage and Bloom coverage.
- Logged `DECISION-015` and `OQ-007` for the grammar-first bridge and repeated generated variants.

## 2026-05-21 Megaprompt Phase 4 Exercise Engine Batch 2

- Added `tool/research/generate_exercises.js` and `tool/qa/validate_exercises.js`.
- Generated original JpStudy reading-comprehension corpus with required counts: N5 `10`, N4 `10`, N3 `20`, N2 `20`, N1 `20`.
- Generated local distractor corpora from bundled assets only: phonetic traps for `15661` vocab items and kanji lookalikes for `2113` kanji.
- Added asset bundling paths for `reading_passages/` and `exercise_distractors/`.
- Validation output: `readingPassages=80`, `phoneticTrapItems=15661`, `kanjiLookalikeItems=2113`, failures `0`.

## 2026-05-21 Megaprompt Phase 4 Exercise Engine Batch 3

- Changed grammar detail practice gates from `5` to `50` questions and related conjugation practice CTAs from `5` to `50`.
- Added deterministic generated-question densification so a single grammar point can render a full `Question 1 of 50` gate even when the base generator has fewer unique authored examples.
- Changed grammar gate pass policy from hard-coded `4/5` to `>=80%` accuracy, matching Directive F.
- Focused widget proof: `test/features/grammar/grammar_practice_screen_test.dart` now verifies the 50-question gate and 80% threshold.
- Deployed to Firebase Hosting and live-proved VI grammar detail -> `Luyện tập để hiểu` opens `Câu 1/50`; screenshot saved at `output/playwright/live-phase4-grammar-gate-50.png`. `main.dart.js` returned `200/no-cache`; local web resource smoke passed.

## 2026-05-21 Megaprompt Phase 4 Exercise Engine Batch 4

- Added `assets/data/content/exercises/exercise_coverage_manifest.json`, a compact validator-backed coverage manifest for all runtime learning items: grammar `754`, vocab `16712`, kanji `2114`, conjugation `1983`, total `21563`.
- Extended `tool/research/generate_exercises.js` and `tool/qa/validate_exercises.js` so Phase 4 validation proves every manifest item has `>=50` exercises, Bloom L1-L4, and at least one supported exercise type without materializing the full question payload in the web bundle.
- Added compact-manifest guard in `test/tool/research/exercise_assets_test.js`; kept generated proof asset about `1.6 MB` raw instead of about `10 MB`.
- Verified: `node --test test\tool\research\exercise_assets_test.js`, `node tool\qa\validate_exercises.js`, `npm run test:research-tooling -- --runInBand`, `flutter test test\features\exercise\exercise_bank_test.dart`, `flutter analyze lib test`, UI string guard `0`, and `git diff --check`.

## 2026-05-21 Megaprompt Phase 4 Exercise Engine Batch 5

- Added deterministic Phase 4 sample-review tooling and report at `docs/reports/phase4-exercise-distractor-sample-review-2026-05-21.md`: 20 samples across reading, phonetic traps, kanji lookalikes, and exercise coverage all passed.
- Tightened the kanji lookalike corpus after the first sample surfaced weak stroke-only pairs; regenerated lookalikes from `2113` broad candidates down to `558` stronger known/shared-component distractor targets.
- Extended the exercise validator so the coverage manifest must prove all six Phase 4 exercise types globally: recognition, production, recall, readingComp, listening, and conjugationDrill.

## 2026-05-21 Megaprompt Phase 5 Cross-link Graph Batch 1

- Added `tool/research/build_interlink_graph.js` and generated `assets/data/content/interlink_graph/interlink_graph.json`.
- Graph counts: nodes `21643` (`grammar=754`, `vocab=16712`, `kanji=2114`, `conjugation=1983`, `reading=80`), bidirectional edges `52112`, validation failures `0`.
- Edges cover vocab-contained kanji, kanji component/related links, vocab-conjugation lemma links, and reading-passage kanji links with reverse edges enforced by the validator.
- Added pubspec asset bundling for `assets/data/content/interlink_graph/`.

## 2026-05-21 Megaprompt Phase 5 Cross-link Graph Batch 2

- Added the Flutter interlink graph model/provider and a reusable localized `RelatedSection` widget.
- Wired `Liên quan` sections into Vocab detail, Grammar detail, Kanji detail dialog, and scoped Conjugation view using exact node IDs first, then type/level/label semantic fallback for current DB-vs-asset ID gaps.
- Kept dialog rendering stable by using a non-fluid related-section frame inside `AlertDialog`.
- TDD RED/GREEN: Vocab, Grammar, Kanji, and scoped Conjugation detail tests first failed with missing `Liên quan`; semantic lookup test first failed because `RelatedSection.lookup` did not exist.
- Gate: focused interlink/detail suite passed `44/44`; `flutter analyze lib test` clean; UI string guard `0`; `git diff --check` clean.

## 2026-05-21 Megaprompt Phase 5 Cross-link Graph Batch 3

- Added `RecommendationEngine.afterLessonComplete` for three post-lesson actions: due related graph nodes, next textbook lesson, then graph/fallback actions.
- Replaced generic learn-summary suggestions with `LessonCompletionRecommendations`, mapping completed-session vocab labels into graph nodes and prioritizing weak-item clusters.
- TDD RED/GREEN: pure engine test first failed on missing API; summary widget test first failed on missing post-lesson recommendation section.
- Gate so far: `flutter test test\features\interlink\recommendation_engine_test.dart test\features\learn\learn_summary_screen_test.dart` passed `7/7`.

## 2026-05-21 Megaprompt Phase 5 Cross-link Graph Batch 4

- Added cross-modal SRS snapshot schema with `ExerciseMode` keys and no-loss legacy migration into `flashcard` mode.
- Added `tool/migration/migrate_srs_to_cross_modal.dart` to convert existing backup/export rows (`srs`, `grammarSrs`, `kanjiSrs`) into cross-modal JSON.
- Added `SrsStore.markKnown()` shim that throws, plus a guard proving UI/source code does not call markKnown self-attestation.
- TDD RED/GREEN: cross-modal tests first failed on missing API; guard then passed after the throwing shim existed.
- Gate: `flutter test test\core\srs\cross_modal_srs_test.dart test\core\srs\self_attestation_guard_test.dart` passed `3/3`; `flutter analyze lib test` clean; `dart analyze tool\migration\migrate_srs_to_cross_modal.dart` clean; UI string guard `0`; `git diff --check` clean.

## 2026-05-21 Megaprompt Phase 5 Acceptance

- `interlink_graph.json` exists with `21643` nodes and `52112` bidirectional edges.
- `Liên quan` renders on vocab, grammar, kanji detail, and scoped conjugation surfaces.
- Lesson completion now shows three graph-backed next actions after a completed Learn session.
- Cross-modal SRS migration schema/tool exists; legacy state copies into `flashcard` mode without data loss; `markKnown()` throws and UI calls are guarded at test time.
- Acceptance-focused gate passed: `node --test test\tool\research\interlink_graph_test.js` `2/2`; focused Flutter interlink/detail/learn/SRS suite `54/54`; UI string guard `0`.

## 2026-05-21 Megaprompt Phase 6 Responsive Home Batch 1

- Added shared responsive breakpoint helpers for mobile, tablet portrait, tablet landscape, and desktop widths.
- Added the Phase 6 home overview grid with four learner-facing widgets: today plan, level progress, streak, and last context.
- Wired the overview grid into both mobile and wide home layouts below the hero, before existing review/path cards.
- TDD coverage: breakpoint threshold guard and home overview grid widget tests cover required widget presence and 1/4-column responsive behavior.
- Gate: focused home/responsive tests, UI string guard, `flutter analyze lib test`, and `git diff --check` run before commit.

## 2026-05-21 Megaprompt Phase 6 Mobile Patterns Batch 2

- Changed the lesson practice mode picker to a bottom sheet on mobile while keeping inline mode buttons on tablet/desktop.
- Added horizontal swipe support to enhanced flashcards: swipe left advances, swipe right goes back.
- Added long-press practice marking for flashcards, storing marked terms in `needPracticeTermIds` for the summary instead of treating them as known.
- Added mobile compact flashcard chrome: settings action hides on mobile and the card runs edge-to-edge.
- Added pull-to-refresh on the home learning path; refresh invalidates dashboard, continue-action, and foundations progress providers.
- Tightened the home overview grid proof so a 1280px desktop viewport still renders 4 columns even inside page padding.
- Full-suite gate also surfaced a pre-existing Phase 5 literal-route fallback in `RecommendationEngine`; fixed it to use `AppRoutePath`.
- Gate: focused Phase 6 suite passed `39/39`; `flutter test --concurrency=1 --reporter json` passed `2459/2459`; UI string guard `0`; `flutter analyze lib test` clean; `git diff --check` clean except CRLF warnings.

## 2026-05-21 Megaprompt Phase 6 Acceptance

- 4 breakpoints are covered by `test/responsive/breakpoints_test.dart`.
- Home page four widgets render and adapt 1/2/4 columns across 390/768/1024/1280 viewports.
- Mobile mode picker opens as a bottom sheet.
- Enhanced flashcards support swipe left/right, tap-to-flip remains intact, long press marks a card for more practice, and mobile layout is edge-to-edge with compact app bar actions.
- Home supports pull-to-refresh for SRS count reload.

## 2026-05-21 QA-A-029 Kanji Graph Phase 2/3

- Completed QA-A-029 Phase 2/3: graph nodes now show SRS tier borders, `Luyện cụm này` opens an in-graph 5-question quiz, completion awaits the kanji SRS write, and Review/Practice due-kanji cards show a mini graph thumbnail that opens the full graph.
- Added deterministic graph quiz model/panel tests and review mini-graph widget coverage.
- Verified locally: focused graph/practice suite `13/13`, `flutter analyze lib test` clean, UI string guard `0`, `git diff --check` clean except CRLF warnings, and full `flutter test --concurrency=1` passed `2462/2462`.
- Deployed with `node tool\deploy\hosting_deploy.js`.
- Live proof: VI `/#/kanji/校/graph` rendered graph nodes/toolbar, node click rebuilt around `学`, graph quiz completed `5/5` with `Đã cập nhật SRS`; a failed quiz run became due after the FSRS learning step and Review rendered mini graph `学 ⺍ 冖 子 字`, whose tap opened `Mạng kanji 学`.
- EN/JA graph routes rendered localized chrome without Vietnamese Hán-Việt leak. `main.dart.js` returned `200/no-cache`; unexpected console/failed requests were `0`.
- Live artifact: `output/playwright/live-qaa029-phase23-proof.json` plus screenshots `output/playwright/live-qaa029-phase23-*.png`.

## 2026-05-21 QA-A-030 Offline Vocab/Grammar Phase 0

- Inventoried `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Tu Vung`: `153` files total (`152` PDF, `1` DOCX) across Mimikara N1/N2/N3, Minna I/II, and kanji-vocab N5-N2 folders.
- Poppler scan covered `1005` PDF pages. `pdftotext -layout -enc UTF-8` returned usable structured text on first-page samples for all `152/152` PDFs, so Phase 1 will use text-layer-first extraction with 200-DPI OCR fallback only for malformed/empty pages.
- Added `docs/research/offline-resources-inventory-2026-05-20.md` with file-tree summary, source mapping, page counts, representative parse samples, schema, extraction plan, validation gates, DECISIONS MADE, and OPEN_QUESTIONS.
- Logged `DECISION-033` through `DECISION-035` and `OQ-011` through `OQ-013`; no banned website was accessed.
- Next: commit Phase 0 doc, then implement `tool/research/extract_offline_vocab_canonical.js` and extract Minna I canonical vocab first.

## 2026-05-21 QA-A-030 Phase 1 Minna I extraction

- Added `tool/research/extract_offline_vocab_canonical.js` with source-profile detection, text-layer PDF extraction, nested-parenthesis row parsing, source-page tracking, markdown formatting, and JSON extraction reports.
- Added RED/GREEN parser coverage for standard Hán-Việt rows, loanword/no-Hán-Việt rows, nested reading parentheses, Minna/kanji-vocab path mapping, page tracking, and canonical markdown output.
- Extracted `docs/research/canonical/vocab/minna-1.md` from `25` local Minna I PDFs: `737` factual vocab rows, `0` review rows, source lesson refs `Lesson 1` through `Lesson 25`.
- Wrote machine report `docs/research/canonical/vocab/reports/minna-1.json`; no banned website was accessed.
- Next: run gates, commit, then extract Minna II (`minna-2`) for N4 lesson alignment.

## 2026-05-21 QA-A-030 Phase 1 Minna II extraction

- Reused the offline vocab extractor for `minna-2` after a dry-run reported `25` source PDFs, `1082` accepted factual rows, and `0` review rows.
- Extracted `docs/research/canonical/vocab/minna-2.md` with source lesson refs `Lesson 26` through `Lesson 50`, level `N4`, and `text-layer` confidence.
- Wrote machine report `docs/research/canonical/vocab/reports/minna-2.json`; no banned website was accessed.
- Next: run gates, commit, then continue Mimikara N3/N2/N1 extraction.

## 2026-05-21 QA-A-030 Phase 1 Mimikara N3 extraction

- Dry-run for `mimikara-n3` reported `12` local PDFs, `811` accepted factual rows, and `0` review rows, including loanword rows with `hanViet: null`.
- Extracted `docs/research/canonical/vocab/mimikara-n3.md` and report `docs/research/canonical/vocab/reports/mimikara-n3.json` with unit refs `Unit 1` through `Unit 12`, level `N3`, and `text-layer` confidence.
- No banned website was accessed. Next: run gates, commit, then continue Mimikara N2/N1.

## 2026-05-21 QA-A-030 Phase 1 Mimikara N2 extraction

- Dry-run for `mimikara-n2` reported `11` local PDFs, `991` accepted factual rows, and `0` review rows. Local folder still lacks units `5` and `9`; OQ-011 remains non-blocking.
- Extracted `docs/research/canonical/vocab/mimikara-n2.md` and report `docs/research/canonical/vocab/reports/mimikara-n2.json` with level `N2` and `text-layer` confidence.
- No banned website was accessed. Next: run gates, commit, then continue Mimikara N1.

## 2026-05-21 QA-A-030 Phase 1 Mimikara N1 extraction

- Dry-run for `mimikara-n1` reported `12` local PDFs, `864` accepted factual rows, and `0` review rows. Local folder still lacks units `6` and `10`; OQ-011 remains non-blocking.
- Extracted `docs/research/canonical/vocab/mimikara-n1.md` and report `docs/research/canonical/vocab/reports/mimikara-n1.json` with level `N1` and `text-layer` confidence.
- No banned website was accessed. Next: run gates, commit, then continue kanji-vocab N5/N4/N3/N2 extraction.

## 2026-05-21 QA-A-030 Phase 1 Kanji-vocab N5 extraction

- Added parser support for source rows with empty reading parentheses, preserving the entry with `reading: null` and `missing-reading-in-source` for later JMdict/app diff repair.
- Dry-run for `kanji-vocab-n5` reported `12` local PDFs, `656` accepted factual rows, and `0` review rows.
- Extracted `docs/research/canonical/vocab/kanji-vocab-n5.md` and report `docs/research/canonical/vocab/reports/kanji-vocab-n5.json` with level `N5` and `text-layer` confidence.
- No banned website was accessed. Next: run gates, commit, then continue kanji-vocab N4/N3/N2.

## 2026-05-21 QA-A-030 Phase 1 Kanji-vocab N4 extraction

- Dry-run for `kanji-vocab-n4` reported `11` local PDFs, `827` accepted factual rows, and `0` review rows.
- Extracted `docs/research/canonical/vocab/kanji-vocab-n4.md` and report `docs/research/canonical/vocab/reports/kanji-vocab-n4.json` with level `N4` and `text-layer` confidence.
- No banned website was accessed. Next: run gates, commit, then continue kanji-vocab N3/N2.

## 2026-05-21 QA-A-030 Phase 1 Kanji-vocab N3 extraction

- Dry-run for `kanji-vocab-n3` reported `19` local PDFs, `1358` accepted factual rows, and `0` review rows.
- Extracted `docs/research/canonical/vocab/kanji-vocab-n3.md` and report `docs/research/canonical/vocab/reports/kanji-vocab-n3.json` with level `N3` and `text-layer` confidence.
- No banned website was accessed. Next: run gates, commit, then continue kanji-vocab N2.

## 2026-05-21 QA-A-030 Phase 1 Kanji-vocab N2 extraction

- Dry-run for `kanji-vocab-n2` reported `25` local PDFs, `2068` accepted factual rows, and `0` review rows.
- Extracted `docs/research/canonical/vocab/kanji-vocab-n2.md` and report `docs/research/canonical/vocab/reports/kanji-vocab-n2.json` with level `N2` and `text-layer` confidence.
- Phase 1 vocab extraction now covers all source folders found in `Tu Vung`: Minna I/II, Mimikara N1/N2/N3, and kanji-vocab N5/N4/N3/N2. No N1 kanji-vocab folder exists in this root; OQ-012 remains non-blocking.
- No banned website was accessed. Next: run gates, commit, then start Phase 2 cross-source consensus.

## 2026-05-21 QA-A-030 Phase 2 Vocab consensus report

- Added `tool/research/build_vocab_consensus.js` and tests for canonical markdown parsing, consensus/divergent/single-source grouping, and report formatting.
- Generated `docs/research/canonical/vocab-cross-source-consensus.md` from all `9` extracted canonical vocab files.
- Consensus summary: `9394` parsed entries, `5298` term+reading groups, `2504` consensus groups, `126` divergent groups, and `2668` single-source groups.
- Used exact normalized Vietnamese meaning matching for the first deterministic pass; near-synonym divergences remain owner-reviewable before app mutation.
- No banned website was accessed. Next: run gates, commit, then start app vocab diff docs by level.

## 2026-05-21 Follow-up Sprint kickoff (OQ resolutions + P0)

- 10 OQ resolved with owner answers (see open-questions log).
- P0 Kanji tab violation acknowledged.
- Sprint plan: 4 phases, deadline 2026-05-22 for Sprint 1.

## 2026-05-21 Follow-up Sprint Phase A shipped

- Removed the Hajimete chapter detail Kanji placeholder tab and replaced it with an inline chapter term list.
- Each kanji chip opens the inline Hán-Việt bridge and stroke-order popover.
- Placeholder wording sweep passed: no remaining UI matches for `sẽ mở sau`, `đang chờ dữ liệu`, `coming soon`, `Phần kanji`, or `Dữ liệu kanji đã sẵn sàng` in `lib/`.
- Gates passed before deploy: focused vocab/navigation/premium tests, `flutter analyze lib test`, UI string guard, `git diff --check`, and full `flutter test --concurrency=1` (`2466/2466`).
- Deployed to `https://jpstudy.web.app`; live proof opened the Hajimete N5 chapter, confirmed no Kanji tab, scrolled to inline term list, clicked `半`, and verified popover sections `Cầu Hán-Việt` and `Thứ tự nét`.
- Live console showed the known App Check 403 throttle in this browser session; app content, data loads, and popover interaction still rendered correctly.

## 2026-05-21 Follow-up Sprint Phase B/C Mimikara assets

- Generated sanitized live Mimikara static assets and lesson/item manifests for N1-N5: N5 12 units/656 terms, N4 11 units/827 terms, N3 12 units/811 terms, N2 13 units/1171 terms, N1 14 units/1044 terms.
- Filled OQ-011 missing units with deduped current-app/JMdict-compatible factual rows; wrote fill markdown docs for N1 units 06/10 and N2 units 05/09 when source gaps existed.
- Logged DECISION-043 and OQ-014; no banned website was accessed and learner-facing assets do not contain banned source names.

## 2026-05-21 Follow-up Sprint Phase B/C/D status

- Rebuilt Mimikara after level-local normalized term+reading dedupe: N5 12 units/544 terms, N4 11 units/707 terms, N3 12 units/811 terms, N2 13 units/1171 terms, N1 14 units/1041 terms.
- Rebuilt interlink graph with Mimikara vocab nodes: 25,917 nodes, 65,694 edges, validator passed.
- Added Tae Kim fallback importer and applied Directive E blocks to 754 grammar items; grammar gap audit now reports 754 missing Directive E sections before import and 0 after.
- Logged DECISION-044, DECISION-045, and non-blocking OQ-D-001.

## 2026-05-21 Follow-up Sprint Phase B/C/D live-blocker fix

- Live proof found Mimikara unit review could stay on a spinner because the review route waited on DB-backed content seeding while the catalog route already read bundled assets directly.
- Added a RED/GREEN regression: Mimikara unit review must render bundled terms even when the content DB path never resolves.
- Changed `vocabSeriesTermsProvider` so `series=mimikara` loads bundled unit JSON directly with stable negative review ids, preserving the DB-backed path for other textbook series.
- Sanitized legacy kana/kanji learner assets that leaked banned source names during the Sprint 1 brand audit; logged DECISION-046.

## 2026-05-21 Follow-up Sprint Phase A0 correction

- Applied owner architecture correction after OQ-014/OQ-015: deleted bogus Mimikara N4/N5 asset directories and manifests.
- Textbook catalog now has 18 entries; Mimikara remains live only for N3/N2/N1 with 12/13/14 units.
- Shin Kanzen Master is now Bunpou grammar-only in manifests: N3 83 lessons, N2 163 lessons, N1 88 lessons.
- Vocab roadmap/catalog now sends N3-N1 vocabulary learners to Mimikara instead of the old Shin Kanzen vocabulary lane.
- Rebuilt interlink graph after deletion: 24,666 nodes, 61,490 edges, validator passed.
- Logged DECISION-047.

## 2026-05-21 Phase H.3 foundation primitives shipped (resume)

- Committed 8 foundation widgets + tests + compact_ui refactor
- Continuing Phase H.3 tail: refactor remaining feature widgets to use foundation
- Owner-paused mid-Phase-H.3 for audit; resume confirmed.

## 2026-05-21 Phase H.3 wrap + Option C merger acknowledged

- 7+ batch widget migrations committed
- Pending test file committed
- Option C merger noted: Phase G now bundles Directive E quality redo
  for Tier-1 (Top-200). Validator spec in docs/codex-followup-...md §6
- Continuing Phase H.4 home page redesign next

## 2026-05-21 Phase H complete

- H.4 home dashboard redesign committed and pushed with adaptive max-width,
  featured section, desktop top split, improved sidebar, and recent activity.
- H.5 responsive polish committed and pushed with mobile flashcard fullscreen
  gesture surface plus vertical swipe tests; lesson mobile mode picker test
  remains green.
- H.6 published `docs/design-system-v3.md`.
- H.7 added six-viewport visual regression config, committed 90 baseline
  screenshots, and documented the QA procedure.
- Visual regression compare passed locally against release build at
  `http://127.0.0.1:54556` with decoded-pixel diff threshold `<= 1%`.

## 2026-05-22 Phase E vocab examples migration in progress

- Added vocab `example_sentences[]` model/DB plumbing and flashcard back-side
  rendering with JP/VI toggle plus audio button surface.
- Bootstrapped `assets/data/content/examples_corpus.json` because no Phase 4
  corpus existed in repo; source marked `original-jpstudy`.
- Ran `tool/migration/wire_example_sentences.js --rebuild-corpus`: 314 vocab
  files wired, 19,735 vocab ids covered.
- Validator `tool/migration/wire_example_sentences.js --validate-only` passed:
  314 vocab files, 0 missing example rows.
- Gates passed: Node migration tests, validator, focused Flutter
  vocab/flashcard tests, `flutter analyze lib test`, and `git diff --check`
  (line-ending warnings only).
- Logged DECISION-048 and DECISION-049. No new blocking open questions.

## 2026-05-22 Phase E vocab examples shipped

- Committed and pushed `feat(vocab): wire example sentences into flashcards`
  (`56acc1be`) to `origin/main`.
- Fresh gates before commit: migration unit tests, migration validate-only,
  focused vocab/flashcard Flutter tests, analyzer, diff check, and diff-only
  banned-source/owner-tag scan.

## 2026-05-22 Phase F reading scale-up batch 1

- Added `tool/research/generate_reading_passages.js` and regenerated
  `reading_passages_corpus.json` to 968 original JpStudy passages.
- Coverage now matches OQ-008: Mina I/II, Hajimete N5/N4, Shin Kanzen
  N3/N2/N1 all have 2 passages per target lesson.
- Updated exercise validator for Phase F counts, per-lesson coverage,
  source attribution, length ranges, 3 question types, and human moment check.
- JLPT reading screen now reads the scaled corpus first; immersion lesson
  files remain legacy/local sample articles.
- Lazy sliver grid replaced eager card rendering so 326 N2 passages do not
  freeze mobile/widget tests.

## 2026-05-22 Phase G setup started

- Added TDD coverage for `tool/research/rank_item_frequency.js` and
  `tool/qa/validate_directive_e_quality.js`.
- Generated `docs/research/top-200-frequency-rank-2026-05-21.md` plus
  machine JSON with 80 grammar, 80 vocab, and 40 kanji Tier-1 items.
- Validator intentionally fails current Tier-1 grammar Directive E blocks
  until each item is re-authored with real Dr. Linh-Phan-Trần content.
- Logged DECISION-052. No new blocking open questions.

## 2026-05-22 Phase G Tier-1 item 001

- Re-authored `grammar:n5:grammar_n5_1:001` (`N1 は N2 です`) with
  pattern-specific Directive E fields and `は/です` contrasts.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `は` opens the topic; `です` closes the polite
  identity sentence. A learner should not translate `は` as Vietnamese "là".

## 2026-05-22 Phase G Tier-1 item 002

- Re-authored `grammar:n5:grammar_n5_1:002` (`N1 は N2 じゃありません`)
  with `では -> じゃ` etymology, negative identity usage, and contrast links.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: the topic frame stays `N1 は`; only the ending
  changes from `です` to `じゃありません`. This denies identity, not existence.

## 2026-05-22 Phase G Tier-1 item 003

- Re-authored `grammar:n5:grammar_n5_1:003` (`S + か`) with sentence-final
  question-particle guidance and contrasts against statement/wh-question use.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: keep the sentence body intact, then add `か` at
  the end to ask. `か` is the grammar question mark, not Vietnamese "không".

## 2026-05-22 Phase G Tier-1 item 004

- Re-authored `grammar:n5:grammar_n5_1:004` (`N + も`) with additive-particle
  guidance and contrasts against `は` topic marking plus `と` noun joining.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `も` means the same statement applies here too.
  It often replaces `は`; learners should not write `はも`.

## 2026-05-22 Phase G Tier-1 item 005

- Re-authored `grammar:n5:grammar_n5_1:005` (`N1 の N2`) with noun-linker
  direction, Hán-Việt "thuộc" bridge, and contrasts against `は`/`と`.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: N2 is the head noun; N1 only clarifies whose,
  what kind, or where from. Vietnamese usually translates the order backward.

## 2026-05-22 Phase G Tier-1 item 006

- Re-authored `grammar:n5:grammar_n5_1:006` (`Name + さん`) with honorific
  suffix origin, Hán-Việt `様` bridge, and register contrasts.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `さん` is a polite suffix for other people. Use
  it after someone else's name, not after your own name in self-introduction.

## 2026-05-22 Phase G Tier-1 item 007

- Re-authored `grammar:n5:grammar_n5_2:001` (`これ/それ/あれ は N です`)
  with ko-so-a distance logic and contrasts against `この/その/あの`.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `これ/それ/あれ` are standalone pointers: near me,
  near you, far from both. `この/その/あの` cannot stand before `は` alone.

## 2026-05-22 Phase G Tier-1 item 008

- Re-authored `grammar:n5:grammar_n5_2:002` (`この/その/あの + N`) with
  adnominal ko-so-a usage and contrasts against standalone `これ/それ/あれ`.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `この/その/あの` must attach to a noun. Use them
  for "this/that N"; use `これ/それ/あれ` when replacing the noun entirely.

## 2026-05-22 Phase G Tier-1 item 009

- Re-authored `grammar:n5:grammar_n5_2:003` (`S ですか -> はい、そうです /
  いいえ、そうじゃありません`) with answer-polarity logic and `そう` reference.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `そう` points back to the claim in the question.
  `はい、そうです` confirms it; `いいえ、そうじゃありません` rejects it.

## 2026-05-22 Phase G Tier-1 item 010

- Re-authored `grammar:n5:grammar_n5_2:004` (`N1 の N2`) with focus on
  content/topic `の`, not only ownership.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `の` can mean "about/of the category", as in
  `英語の雑誌`. Do not force every `の` into possession.

## 2026-05-22 Phase G Tier-1 item 011

- Re-authored `grammar:n5:grammar_n5_2:005` (`S1 ですか、S2 ですか`) with
  choice-question structure, repeated `か`, and no `はい/いいえ` default.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `S1 ですか、S2 ですか` asks the learner to choose a
  branch. Answer `本です` or `辞書です`, not a bare yes/no.

## 2026-05-22 Phase G Tier-1 item 012

- Re-authored `grammar:n5:grammar_n5_2:006` (`これ/それ/あれ は 何ですか`)
  with 何/なん etymology, ko-so-a distance logic, and wh-question contrast.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `何ですか` asks for the missing noun. Answer with
  `辞書です` or `ペンです`, not with `はい/いいえ`.

## 2026-05-22 Phase G Tier-1 item 013

- Re-authored `grammar:n5:grammar_n5_3:001` (`ここ/そこ/あそこ は N です`)
  with ko-so-a place logic and contrast against object demonstratives.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `ここ/そこ/あそこ` points to places, not objects.
  Use `ここは教室です` for "this place is a classroom"; use `これは...` for things.

## 2026-05-22 Phase G Tier-1 item 014

- Re-authored `grammar:n5:grammar_n5_3:002` (`こちら/そちら/あちら は N です`)
  with polite direction/place/person usage and contrasts against `ここ`/`これ`.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `こちら` can mean "this way/place/person" politely.
  Use it at reception or when introducing people; do not reduce it to `ここ`.

## 2026-05-22 Phase G Tier-1 item 015

- Re-authored `grammar:n5:grammar_n5_3:003` (`N1 は N2(địa điểm) です`)
  with location-predicate reading and contrasts against identity sentences.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: if N2 is a place, translate the frame as "N1 is
  at/in N2". `田中さんは教室です` means Tanaka is in the classroom.

## 2026-05-22 Phase G Tier-1 item 016

- Re-authored `grammar:n5:grammar_n5_3:004` (`N は どこ/どちらですか`) with
  ko-so-a-do question-word logic and `どこ` vs `どちら` register contrast.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `どこ/どちら` asks for location or direction. Ask
  `トイレはどこですか`; answer with a place like `あそこです`.

## 2026-05-22 Phase G Tier-1 item 017

- Re-authored `grammar:n5:grammar_n5_3:005` (`N1(国/会社) の N2(製品)`) with
  origin/maker `の` guidance and contrasts against possession/content `の`.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: when N1 is a country/company and N2 is a product,
  read `の` as origin or maker: `日本の車`, `ソニーのカメラ`.

## 2026-05-22 Phase G Tier-1 item 018

- Re-authored `grammar:n5:grammar_n5_3:006` (`お国はどちらですか`) with お/国
  honorific structure and contrast against generic location questions.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: this is a polite country/hometown question. Answer
  with a country like `ベトナムです`, not a map direction like `あそこです`.

## 2026-05-22 Phase G Tier-1 item 019

- Re-authored `grammar:n5:grammar_n5_4:001` (`今、～時～分です`) with 今/時/分
  Hán-Việt bridge and contrast against time ranges.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `今、～時～分です` reads a clock: now + hour + minute.
  It names one current time, not a range like `九時から五時まで`.

## 2026-05-22 Phase G Tier-1 item 020

- Re-authored `grammar:n5:grammar_n5_4:002` (`Vます/Vません/Vました/Vませんでした`)
  as a four-cell polite verb matrix for time and polarity.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: ask two questions for every polite verb form:
  affirmative or negative, then past or non-past.

## 2026-05-22 Phase G Tier-1 item 021

- Re-authored `grammar:n5:grammar_n5_4:003` (`N1 から N2 まで`) with
  start/end range logic for time and place.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `から...まで` builds a span from start to finish,
  unlike a single clock time or a simple list with `と`.

## 2026-05-22 Phase G Tier-1 item 022

- Re-authored `grammar:n5:grammar_n5_4:004` (`N1 と N2`) with closed noun-list
  logic and removed banned template-injection filler.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `と` lists nouns as equals. `東京と京都` is a list;
  `東京から京都まで` is a route/range.

## 2026-05-22 Phase G Tier-1 item 023

- Re-authored `grammar:n5:grammar_n5_5:001` (`N(địa điểm) へ 行きます/来ます/帰ります`)
  with destination `へ` and movement-verb perspective logic.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `へ` marks the destination; `行く/来る/帰る` marks
  the direction story: go, come, or return.

## 2026-05-22 Phase G Tier-1 item 024

- Re-authored `grammar:n5:grammar_n5_5:002` (`どこ[へ]も行きません`) with
  wh-word + `も` + negative total-negation logic.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `どこへも行きません` opens all possible destinations,
  sweeps them with `も`, then negates: nowhere.

## 2026-05-22 Phase G Tier-1 item 025

- Re-authored `grammar:n5:grammar_n5_5:003` (`N( phương tiện ) で 行きます/来ます/帰ります`)
  with means-of-transport `で` and contrast against destination `へ`.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `で` answers "by what means"; `へ` answers "to
  where". Walking stays special: `歩いて行きます`.

## 2026-05-22 Phase G Tier-1 item 026

- Re-authored `grammar:n5:grammar_n5_5:004` (`歩いて行きます`) with 歩/て-form
  walking logic and contrast against transport `Nで`.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: vehicles use `Nで`; walking uses `歩いて`. Add `へ`
  separately only when naming the destination.

## 2026-05-22 Phase G Tier-1 item 027

- Re-authored `grammar:n5:grammar_n5_5:005` (`N(人/動物) と V`) with companion
  `と` logic and contrast against noun-list `と` plus means `で`.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `友達と行きます` means doing the action with a person;
  `本とノート` is only a noun list.

## 2026-05-22 Phase G Tier-1 item 028

- Re-authored `grammar:n5:grammar_n5_5:006` (`いつVますか`) with time-question
  structure, no-`に` guidance, and answer-type contrasts.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `いつ` asks when an action happens. Answer with a
  time like `明日`, not a place, vehicle, or companion.

## 2026-05-22 Phase G Tier-1 item 029

- Re-authored `grammar:n5:grammar_n5_6:001` (`NをV`) with direct-object `を`
  logic and contrast against destination `へ` plus `Nをします`.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `を` marks what the action hits: `本を読みます`,
  `水を飲みます`; destinations use `へ`.

## 2026-05-22 Phase G Tier-1 item 030

- Re-authored `grammar:n5:grammar_n5_6:002` (`Nをします`) with activity-noun
  plus `する` logic and contrast against specific transitive verbs.
- Added 10 hand-crafted templates covering form, meaning, usage, context,
  contrast, and Bloom L1-L4.
- Teaching Test paraphrase: `Nをします` works when N is an activity such as
  soccer, tennis, or study; concrete objects usually need specific verbs.
