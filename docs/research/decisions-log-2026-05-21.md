# Decisions Log - 2026-05-21 Megaprompt Overhaul

Autonomous overnight mission log. Every decision below is owner-reviewable.

## DECISION-001 - Append Directive F after current directives
**Phase**: 0
**Date**: 2026-05-21 00:00 (local)
**Context**: The megaprompt says to append Directive F after Directive E, but the current `docs/agent-directives.md` only contains Directives A-D.
**Options considered**: wait for owner | synthesize Directive E | append F after current directive block
**Chosen**: append F after current directive block
**Rationale**: The user explicitly ordered no owner gate and did not ask Codex to invent Directive E text. Appending F preserves the requested rule without fabricating missing policy.
**Reversible**: yes
**Owner review**: pending

## DECISION-002 - Use additive dual-read migration
**Phase**: 0
**Date**: 2026-05-21 00:00 (local)
**Context**: Phase 1 introduces textbook/theme/lesson manifests while existing routes and content services still rely on flat content assets.
**Options considered**: replace flat assets immediately | introduce generated manifests only | additive dual-read transition
**Chosen**: additive dual-read transition
**Rationale**: It prevents data loss, keeps old routes alive, and matches the megaprompt's backward-compat requirement.
**Reversible**: yes
**Owner review**: pending

## DECISION-003 - Keep generated exercise assets static-first
**Phase**: 0
**Date**: 2026-05-21 00:00 (local)
**Context**: Directive F requires at least 50 exercises per item without increasing Firebase reads or requiring paid backend compute.
**Options considered**: generate exercises at runtime | call hosted API | generate static JSON assets with validators
**Chosen**: generate static JSON assets with validators
**Rationale**: Static assets fit the local-first Spark-plan posture, are testable offline, and avoid App Check/server cost risk.
**Reversible**: yes
**Owner review**: pending

## DECISION-004 - Use existing conjugation engine as Phase 2 base
**Phase**: 0
**Date**: 2026-05-21 00:00 (local)
**Context**: The repo already has `lib/core/conjugation`, conjugation routes, lemma generation, and `assets/data/content/conjugation/lemmas.json`.
**Options considered**: rewrite from scratch | extend existing engine | only document future work
**Chosen**: extend existing engine
**Rationale**: Existing tested code should become the corpus/drill foundation instead of introducing duplicate conjugation logic.
**Reversible**: yes
**Owner review**: pending

## DECISION-005 - Use stable semantic item IDs
**Phase**: 0
**Date**: 2026-05-21 00:00 (local)
**Context**: Interlink, exercise, and SRS migration need IDs that survive lesson reshuffles.
**Options considered**: database integer IDs | generated UUIDs | semantic IDs from content type, level, textbook, lesson, surface
**Chosen**: semantic IDs from content type, level, textbook, lesson, surface
**Rationale**: They are diff-friendly, reproducible by tooling, and easier to validate in static JSON.
**Reversible**: partial
**Owner review**: pending

## DECISION-006 - Prefer responsive refactor without new UI dependency
**Phase**: 0
**Date**: 2026-05-21 00:00 (local)
**Context**: Phase 6 needs four breakpoints, mobile patterns, and home widgets.
**Options considered**: add responsive package | use Flutter LayoutBuilder/MediaQuery | create CSS-like layout layer
**Chosen**: use Flutter LayoutBuilder/MediaQuery plus small local helpers
**Rationale**: The app is already Flutter web, and local helpers minimize dependency and build risk.
**Reversible**: yes
**Owner review**: pending

## DECISION-007 - Treat kanji as supporting textbook tracks
**Phase**: 1
**Date**: 2026-05-21 00:00 (local)
**Context**: Existing app kanji assets are canonical ebook buckets, not Minna/Shin Kanzen lesson rows, but Phase 1 requires zero-loss migration.
**Options considered**: attach kanji to Minna/Shin Kanzen lessons | duplicate kanji into every textbook | create `canonical_kanji_n*` supporting tracks
**Chosen**: create `canonical_kanji_n*` supporting tracks
**Rationale**: This preserves every kanji item exactly once, avoids false publisher attribution, and keeps lesson pages free to hide empty Kanji tabs until true lesson-specific kanji exists.
**Reversible**: yes
**Owner review**: pending

## DECISION-008 - Keep Mimikara tracks as planned until source extraction
**Phase**: 1
**Date**: 2026-05-21 00:00 (local)
**Context**: The current app assets do not yet contain extracted Mimikara N1-N5 lesson rows, while the megaprompt requires Mimikara coverage in `textbook_index.json`.
**Options considered**: fabricate empty lessons | map unrelated app items into Mimikara | include planned source-pending textbook records without lesson indexes
**Chosen**: include planned source-pending textbook records without lesson indexes
**Rationale**: It satisfies IA coverage without creating dead lesson pages or misattributing existing content. QA-A-030 extraction can later populate real Mimikara lesson indexes.
**Reversible**: yes
**Owner review**: pending

## DECISION-009 - Generate conjugation corpus from current lemma bank
**Phase**: 2
**Date**: 2026-05-21 06:21 (local)
**Context**: Phase 2 needs a dense conjugation corpus without waiting for QA-A-030 offline source extraction.
**Options considered**: wait for Mimikara/Minna extraction | hand-author a small seed | generate from existing JMdict-matched app lemmas plus manual irregular seed
**Chosen**: generate from existing JMdict-matched app lemmas plus manual irregular seed
**Rationale**: Existing app lemmas already carry verb/adjective classes, giving 1,236 verbs and 747 adjectives with full required forms. Manual irregular seed covers 30 high-risk forms without copying copyrighted prose.
**Reversible**: yes
**Owner review**: pending

## DECISION-010 - Gate inline conjugation widget behind loaded lesson terms
**Phase**: 2
**Date**: 2026-05-21 06:21 (local)
**Context**: A lesson loading-state test intentionally disposes the tree while lesson terms are pending. Rendering the inline conjugation widget during that state starts unrelated DB async work and leaves a pending test timer.
**Options considered**: change the test | make the widget eager but cancelable | render the inline widget only after lesson terms resolve
**Chosen**: render the inline widget only after lesson terms resolve
**Rationale**: The inline anchor is meaningful only after the lesson is known. Deferring it avoids unrelated async work during loading and preserves the conditional behavior required by Directive F.6.
**Reversible**: yes
**Owner review**: pending

## DECISION-011 - Remove empty Kanji lesson tab but keep Vocab/Grammar tabs
**Phase**: 3
**Date**: 2026-05-21 06:21 (local)
**Context**: Phase 3 requires deleting deceptive empty Kanji tabs while preserving working lesson grammar content.
**Options considered**: remove all tabs immediately | keep current three-tab layout | keep Vocab/Grammar tabs and move Kanji access into term badges
**Chosen**: keep Vocab/Grammar tabs and move Kanji access into term badges
**Rationale**: This removes the empty/stub Kanji destination now, keeps the existing grammar panel reachable, and creates a learner-facing Kanji cross-link from the term list without a large route rewrite in the same batch.
**Reversible**: yes
**Owner review**: pending

## DECISION-012 - Reuse existing lesson routes for header actions
**Phase**: 3
**Date**: 2026-05-21 06:21 (local)
**Context**: Phase 3 calls for previous/next, feedback, and writing actions before the full Phase 4 exercise route overhaul exists.
**Options considered**: add new placeholder routes | hide actions until Phase 4 | reuse existing lesson detail/write/report flows
**Chosen**: reuse existing lesson detail/write/report flows
**Rationale**: Existing routes are live and tested, so header actions are functional now without adding dead UI or new route debt.
**Reversible**: yes
**Owner review**: pending

## DECISION-013 - Keep lesson page cross-links in the current routes
**Phase**: 3
**Date**: 2026-05-21 07:14 (local)
**Context**: Phase 3 needs term-level cross-link badges before the Phase 5 interlink graph exists.
**Options considered**: wait for Phase 5 graph | add inert badges | link to current Kanji and Grammar destinations
**Chosen**: link to current Kanji and Grammar destinations
**Rationale**: Existing routes are live and learner-facing. This gives useful navigation now, while Phase 5 can replace the badge targets with item-specific graph links.
**Reversible**: yes
**Owner review**: pending

## DECISION-014 - Use lesson conjugation lemmas for conditional mode
**Phase**: 3
**Date**: 2026-05-21 07:14 (local)
**Context**: The lesson mode picker needs a seventh conjugation mode only when the lesson has verbs/adjectives.
**Options considered**: always show conjugation | hide until Phase 4 | reuse the existing conjugation lemma lookup
**Chosen**: reuse the existing conjugation lemma lookup
**Rationale**: The Phase 2 lemma layer already maps active-level lemmas to lesson IDs, so the mode picker can stay conditional without adding a second taxonomy.
**Reversible**: yes
**Owner review**: pending

## DECISION-015 - Bridge grammar practice into ExerciseBank first
**Phase**: 4
**Date**: 2026-05-21 07:55 (local)
**Context**: Phase 4 requires a shared ExerciseBank API, but grammar already has the broadest generated question coverage and live practice routes.
**Options considered**: build all item types at once | start with grammar bridge | wait for authored static JSON generation
**Chosen**: start with grammar bridge
**Rationale**: This gives a tested ExerciseBank contract and proves the >=50/Bloom density rule across all runtime grammar points before extending the same model to vocab, kanji, reading, and conjugation assets.
**Reversible**: yes
**Owner review**: pending

## DECISION-016 - Generate original reading and distractor corpora locally
**Phase**: 4
**Date**: 2026-05-21 08:20 (local)
**Context**: Phase 4 requires reading-comprehension coverage plus phonetic and kanji-lookalike distractor banks without importing copyrighted JLPT/book/site exercises.
**Options considered**: scrape public reading sites | copy official/sample questions | generate original JpStudy passages and local distractor corpora
**Chosen**: generate original JpStudy passages and local distractor corpora
**Rationale**: Original passages avoid copyright risk, and phonetic/lookalike corpora can be derived from bundled local vocab/kanji facts with deterministic validation.
**Reversible**: yes
**Owner review**: pending

## DECISION-017 - Make grammar detail gate the first 50-question UI path
**Phase**: 4
**Date**: 2026-05-21 08:40 (local)
**Context**: Owner explicitly called the old 5-question item drill too shallow, and grammar detail already has the learner-facing practice gate.
**Options considered**: leave UI at 5 while bank is dense | make all grammar sessions 50 immediately | start with single-item detail gates at 50
**Chosen**: start with single-item detail gates at 50
**Rationale**: This directly fixes the visible item-gate defect without making due/quick multi-item sessions unmanageably long before Phase 5 cross-modal SRS is complete.
**Reversible**: yes
**Owner review**: pending

## DECISION-018 - Store exercise coverage as a compact manifest
**Phase**: 4
**Date**: 2026-05-21 09:00 (local)
**Context**: Phase 4 needs every grammar/vocab/kanji/conjugation item to prove >=50 exercise coverage, but materializing full per-item questions or verbose proof objects would add large raw JSON payloads.
**Options considered**: materialize all questions | store verbose per-item proof objects | store compact per-item tuples plus shared generator policy
**Chosen**: store compact per-item tuples plus shared generator policy
**Rationale**: The compact manifest validates 21,563 items while keeping the new asset about 1.6 MB raw instead of about 10 MB. Dynamic generators remain deterministic and validator-backed.
**Reversible**: yes
**Owner review**: pending

## DECISION-019 - Reject stroke-only kanji distractor pairs
**Phase**: 4
**Date**: 2026-05-21 09:12 (local)
**Context**: The first deterministic sample review exposed weak kanji distractors such as radical/stroke-neighbor pairs that were technically distinct but not useful visual traps.
**Options considered**: keep broad stroke-neighbor corpus | manually whitelist every pair | require known visual pairs or shared component evidence
**Chosen**: require known visual pairs or shared component evidence
**Rationale**: This lowers corpus size but removes weak distractors, matching Directive F's anti-trivial quality bar better than maximizing coverage count.
**Reversible**: yes
**Owner review**: pending

## DECISION-020 - Build Phase 5 graph as compact indexed JSON
**Phase**: 5
**Date**: 2026-05-21 09:25 (local)
**Context**: Phase 5 needs a static interlink graph with at least 50,000 bidirectional edges, but verbose JSON would create a large web payload.
**Options considered**: verbose edge objects | database-only graph | compact node rows plus indexed edge relation/evidence tables
**Chosen**: compact node rows plus indexed edge relation/evidence tables
**Rationale**: The generated graph reaches 21,643 nodes and 52,112 edges while staying about 2.4 MB raw, preserving local-first/offline behavior without a backend.
**Reversible**: yes
**Owner review**: pending

## DECISION-021 - Resolve related sections by semantic label fallback
**Phase**: 5
**Date**: 2026-05-21 10:05 (local)
**Context**: App detail screens often know DB numeric IDs, while the compact graph stores stable asset/semantic IDs for vocab, grammar, kanji, and conjugation nodes.
**Options considered**: require DB ID migration first | render no related links until IDs match | resolve by exact node ID first, then type+level+label fallback
**Chosen**: resolve by exact node ID first, then type+level+label fallback
**Rationale**: This keeps the graph asset stable and lets every existing detail surface render live learner links now. Later DB/asset ID convergence can tighten routing without changing the widget contract.
**Reversible**: yes
**Owner review**: pending

## DECISION-022 - Keep lesson-complete recommendations graph-first
**Phase**: 5
**Date**: 2026-05-21 10:30 (local)
**Context**: Phase 5 requires three actionable suggestions after lesson completion, but the existing summary widget only used broad due/ghost state and did not intersect the just-learned item cluster.
**Options considered**: keep generic next-step widget | block on full DB-to-graph ID migration | add a graph-backed recommendation engine with semantic lookup from learned vocab labels
**Chosen**: add a graph-backed recommendation engine with semantic lookup from learned vocab labels
**Rationale**: The new engine ranks due related graph nodes first, keeps the next textbook lesson in the list, and fills with curriculum-graph links or safe fallbacks. This gives a real post-lesson path now while preserving future DB/asset ID tightening.
**Reversible**: yes
**Owner review**: pending

## DECISION-023 - Migrate SRS by exportable cross-modal snapshots first
**Phase**: 5
**Date**: 2026-05-21 10:50 (local)
**Context**: Directive F.5 requires per-mode SRS state, but the current app already has several stable SRS tables for vocab, grammar, kanji, kana, conjugation, and Hán-Việt rules.
**Options considered**: rewrite all Drift SRS tables immediately | add a parallel cross-modal snapshot/migration layer | defer SRS migration
**Chosen**: add a parallel cross-modal snapshot/migration layer
**Rationale**: Copying legacy rows into `flashcard` mode proves no-loss migration and gives a stable schema/tool without risking a large DB rewrite mid-Phase 5. Future batches can move individual review flows onto the cross-modal store incrementally.
**Reversible**: yes
**Owner review**: pending

## DECISION-024 - Start Phase 6 with local responsive helpers
**Phase**: 6
**Date**: 2026-05-21 11:20 (local)
**Context**: Phase 6 requires four breakpoints plus home-page overview widgets, while the app already has custom Flutter layout code and no dedicated responsive dependency.
**Options considered**: add a responsive package | duplicate width checks inside each screen | add a small local `lib/responsive` helper and reuse it from home widgets
**Chosen**: add a small local `lib/responsive` helper and reuse it from home widgets
**Rationale**: The local helper keeps breakpoint policy testable and avoids adding a package for four fixed thresholds. The home overview grid can then adapt columns consistently across mobile, tablet, and desktop.
**Reversible**: yes
**Owner review**: pending

## DECISION-025 - Treat mobile flashcards as gesture-first
**Phase**: 6
**Date**: 2026-05-21 11:55 (local)
**Context**: Phase 6 calls for mobile flashcards that feel fullscreen and gesture-driven, while desktop still benefits from visible settings and large controls.
**Options considered**: keep one shared desktop layout everywhere | create a separate mobile screen | adapt the existing enhanced flashcard screen by viewport
**Chosen**: adapt the existing enhanced flashcard screen by viewport
**Rationale**: The viewport branch keeps one source of truth for session state and summary behavior, but removes horizontal padding and settings chrome on mobile. Swipe/long-press gestures are added to the shared card widget so nested gestures do not block navigation.
**Reversible**: yes
**Owner review**: pending

## DECISION-026 - Use viewport width for padded responsive grids
**Phase**: 6
**Date**: 2026-05-21 12:05 (local)
**Context**: A grid nested under page padding can see less than the actual viewport width, which would make a 1280px desktop viewport render as tablet layout.
**Options considered**: lower desktop threshold | remove page padding | keep canonical thresholds and evaluate home overview columns from `MediaQuery`
**Chosen**: keep canonical thresholds and evaluate home overview columns from `MediaQuery`
**Rationale**: The breakpoint values remain exactly as specified, and widgets embedded in padded layouts still satisfy the 1280px desktop acceptance gate.
**Reversible**: yes
**Owner review**: pending

## DECISION-027 - Render local UI before cloud bootstrap
**Phase**: 7
**Date**: 2026-05-21 12:50 (local)
**Context**: Lighthouse and live probes showed first load was dominated by Firebase/App Check/Auth/notification/bootstrap work before the first app frame.
**Options considered**: keep startup order | remove App Check/Auth | render local app first and defer cloud bootstrap
**Chosen**: render local app first and defer Firebase SDK preload to 30s and Firebase/App Check/Auth/migrations to 45s after first frame.
**Rationale**: JpStudy is local-first; learners should see usable content before cloud features. App Check remains active in monitoring mode after deferred bootstrap, and live telemetry still observes App Check, Auth, Sentry, and GA4 requests.
**Reversible**: yes
**Owner review**: pending

## DECISION-028 - Deploy Flutter web with Wasm output
**Phase**: 7
**Date**: 2026-05-21 12:55 (local)
**Context**: JS release builds failed the Phase 7 desktop Lighthouse gate because Flutter JS evaluation dominated main-thread time.
**Options considered**: keep JS backend | ship Wasm backend | lower acceptance threshold
**Chosen**: ship Wasm backend via `flutter build web --wasm`.
**Rationale**: Local and live probes showed Wasm materially reduced runtime payload/evaluation cost and kept routes functional. Firebase Hosting now marks `main.dart.mjs` and `main.dart.wasm` as no-cache to preserve deploy freshness.
**Reversible**: yes
**Owner review**: pending

## DECISION-029 - Use Phase 7 Lighthouse QA methodology
**Phase**: 7
**Date**: 2026-05-21 13:05 (local)
**Context**: Lighthouse 13 removed `--preset=mobile`; storage reset measured onboarding instead of the app; headless Chrome produced non-actionable App Check/reCAPTCHA/Sentry/source-map diagnostics and host antivirus injected extra JavaScript into desktop runs.
**Options considered**: measure fresh onboarding | seed browser profile manually | add explicit QA seed route and skip non-actionable diagnostics
**Chosen**: use `?jpstudy_qa=phase7_lighthouse`, clean Playwright Chromium, `--throttling-method=provided`, and skip known third-party/diagnostic audits while preserving performance paint/SEO/accessibility checks.
**Rationale**: This measures the deployed learner home rather than onboarding, avoids host/tooling noise, and keeps the final JSON reproducible. The skipped audits are still tracked as diagnostics, not user-flow blockers.
**Reversible**: yes
**Owner review**: pending

## DECISION-030 - Route Phase 7 vocab samples through real level chapters
**Phase**: 7
**Date**: 2026-05-21 14:00 (local)
**Context**: Re-running the random sample probe found N2/N1 vocab samples using numeric detail routes `/#/vocab/4` and `/#/vocab/5`, which are only valid for low-ID seeded N5 rows and correctly render "Không tìm thấy từ" for fresh upper-level storage.
**Options considered**: hard-code upper-level DB ids | add a source-id detail route during final proof | use existing Hajimete chapter routes with explicit level query
**Chosen**: use existing Hajimete chapter routes with explicit level query for vocab Phase 7 samples.
**Rationale**: The chapter route is already learner-facing, level-aware, and populated from the same sampled source vocab ids. It avoids inventing a new route only for QA and keeps the live proof deterministic across N5-N1.
**Reversible**: yes
**Owner review**: pending

## DECISION-031 - Compare visual regression by decoded pixels
**Phase**: 7
**Date**: 2026-05-21 14:05 (local)
**Context**: The visual regression probe compared compressed PNG bytes, so two visually identical screenshots could report 99% drift; several stale baselines also captured cold-loading spinners.
**Options considered**: keep byte diff | add an image dependency | decode PNGs in Playwright and compare RGBA pixels after route readiness
**Chosen**: decode screenshots in Playwright, compare RGBA pixels, and wait for route-specific semantic content before capturing.
**Rationale**: Browser-side decoding avoids a new dependency, measures real pixels, and prevents spinner baselines from masking the learner-facing UI.
**Reversible**: yes
**Owner review**: pending

## DECISION-032 - Keep kanji graph practice inside the graph surface
**Phase**: P1 QA-A-029 Phase 2/3
**Date**: 2026-05-21 15:22 (local)
**Context**: The Phase 1 graph CTA opened the generic Kanji practice hub, which broke the owner-requested graph -> cluster practice -> SRS loop.
**Options considered**: keep routing to Kanji practice | add a separate graph drill route | open an in-graph bottom-sheet quiz and record SRS there
**Chosen**: open an in-graph bottom-sheet quiz and record SRS there
**Rationale**: The bottom sheet keeps the learner in the current visual cluster, can await the SRS write before showing completion, and lets Review mini-graph cards reuse the same graph route for the reverse link.
**Reversible**: yes
**Owner review**: pending

## DECISION-033 - Use text-layer-first offline vocab extraction
**Phase**: P1 QA-A-030 Phase 0
**Date**: 2026-05-21 15:32 (local)
**Context**: The owner expected many local PDFs may need OCR, but the Phase 0 scan of `Tu Vung` found structured `pdftotext -layout -enc UTF-8` rows across all 152 PDFs.
**Options considered**: OCR every page | text-layer first with OCR fallback | manual transcription
**Chosen**: text-layer first with OCR fallback
**Rationale**: Text extraction is faster, deterministic, and preserves structured factual rows. OCR remains available for pages/files whose text layer is empty or malformed.
**Reversible**: yes
**Owner review**: pending

## DECISION-034 - Treat Minna lesson PDFs as first vocab alignment source
**Phase**: P1 QA-A-030 Phase 0
**Date**: 2026-05-21 15:32 (local)
**Context**: QA-B-001 needs N5/N4 vocab lesson alignment, and the local Minna I/II folders contain complete lesson files for `bai1-bai50`.
**Options considered**: start with Mimikara | start with kanji-vocab folders | start with Minna I/II
**Chosen**: start with Minna I/II
**Rationale**: Minna I/II directly map to app N5/N4 lesson structures and provide the highest immediate value for vocab lesson diffing.
**Reversible**: yes
**Owner review**: pending

## DECISION-035 - Keep the N2 Quizlet DOCX supplemental
**Phase**: P1 QA-A-030 Phase 0
**Date**: 2026-05-21 15:32 (local)
**Context**: The only DOCX sample content was a Quizlet link/contact note, not a table of vocab facts.
**Options considered**: parse DOCX as canonical | ignore permanently | keep as supplemental until a deeper pass finds facts
**Chosen**: keep as supplemental until a deeper pass finds facts
**Rationale**: It avoids polluting canonical vocab with link/contact content while preserving the file in the inventory for later review.
**Reversible**: yes
**Owner review**: pending

## DECISION-036 - Store canonical markdown plus machine report
**Phase**: P1 QA-A-030 Phase 1
**Date**: 2026-05-21 15:40 (local)
**Context**: Phase 1 needs owner-readable canonical vocab files and repeatable validation counts for later app diffing.
**Options considered**: markdown only | JSON only | markdown canonical plus JSON extraction report
**Chosen**: markdown canonical plus JSON extraction report
**Rationale**: Markdown is reviewable by the owner, while JSON preserves accepted/review/source-file counts for tooling and later consensus/diff stages.
**Reversible**: yes
**Owner review**: pending

## DECISION-037 - Use exact normalized meaning for first consensus pass
**Phase**: P1 QA-A-030 Phase 2
**Date**: 2026-05-21 15:56 (local)
**Context**: Cross-source consensus needs a deterministic rule before app vocab mutation; fuzzy Vietnamese synonym matching can over-merge different glosses.
**Options considered**: exact raw meaning | exact normalized meaning | fuzzy synonym merge
**Chosen**: exact normalized meaning
**Rationale**: Accent/case/punctuation normalization catches obvious same-meaning rows while keeping divergent rows owner-reviewable instead of silently merging near-synonyms.
**Reversible**: yes
**Owner review**: pending

## DECISION-038 - Report vocab level drift explicitly
**Phase**: P1 QA-A-030 Phase 3
**Date**: 2026-05-21 16:03 (local)
**Context**: The app can contain an exact term+reading+meaning match in a higher JLPT level than the local canonical sources, especially inherited public-source upper-level vocab files.
**Options considered**: treat exact matches as OK | duplicate canonical rows across every source level | assign canonical level to the lowest JLPT source and report exact higher-level matches as `WRONG-LEVEL`
**Chosen**: assign canonical level to the lowest JLPT source and report exact higher-level matches as `WRONG-LEVEL`
**Rationale**: This keeps the diff actionable for QA-B-001 instead of hiding taxonomy drift behind meaning matches. Higher-level textbook reuse remains visible as source evidence in each row.
**Reversible**: yes
**Owner review**: pending

## DECISION-039 - Add per-level vocab seed revision before data mutation
**Phase**: P1 QA-A-030 Phase 3
**Date**: 2026-05-21 16:16 (local)
**Context**: Bundled vocab JSON edits do not reach existing browser content DBs if the level was already seeded.
**Options considered**: rely on fresh installs | bump schema and reseed all vocab | add `vocabSeedRevision:<level>` and reseed only the active level
**Chosen**: add `vocabSeedRevision:<level>` and reseed only the active level.
**Rationale**: It gives returning learners the edited vocab rows without an all-level startup cost, while still allowing each level to refresh when that level is active.
**Reversible**: yes
**Owner review**: pending

## DECISION-040 - Auto-apply only overlapping meaning fixes
**Phase**: P1 QA-A-030 Phase 3
**Date**: 2026-05-21 16:16 (local)
**Context**: Dry-run showed exact term+reading consensus can still conflate polysemous meanings, for example a counter sense versus an adverbial sense.
**Options considered**: apply all consensus wrong-meaning rows | require token overlap between old and canonical Vietnamese meanings | hand-edit every row
**Chosen**: require token overlap and stop the first batch at 19 rows before visible typo/polysemy risk.
**Rationale**: The first data mutation should improve obvious wording drift while avoiding automated sense replacement when the canonical row may be a different usage.
**Reversible**: yes
**Owner review**: pending

## DECISION-041 - Sync existing lesson terms after vocab content refresh
**Phase**: P1 QA-A-030 Phase 3
**Date**: 2026-05-21 16:58 (local)
**Context**: Live proof found refreshed content DB rows were not enough for returning browsers because `userLessonTerm` kept old curriculum definitions after a lesson had already been opened.
**Options considered**: clear all lesson terms | sync matched definitions in place | leave stale lesson rows until user resets data
**Chosen**: sync matched existing lesson definitions from content in place and preserve progress/SRS state.
**Rationale**: This reaches the visible lesson UI without deleting learner history or forcing a full app-data reset.
**Reversible**: yes
**Owner review**: pending

## DECISION-042 - DECISION-007 OVERTURNED (Kanji tab deleted)
**Phase**: Follow-up Sprint 1 Phase A
**Date**: 2026-05-21 18:05 (local)
**Context**: Owner audit flagged DECISION-007 as a violation of megaprompt section 7.4 and the explicit screenshot request: the Hajimete chapter detail Kanji tab still showed placeholder text instead of useful chapter terms.
**Options considered**: keep placeholder until Hajimete kanji assets exist | rename placeholder | remove tab and render useful inline term list
**Chosen**: remove the Kanji tab from Hajimete chapter navigation and render the chapter term list inline with clickable kanji popovers for Hán-Việt bridge plus stroke order.
**Rationale**: This matches the owner instruction, removes deceptive empty UI, and keeps the vocabulary flow connected to kanji learning instead of siloing a dead tab.
**Additional action**: Placeholder sweep changed remaining UI strings away from "coming soon / will open later" wording and hid absent vocab roadmap cards unless they have interactive or preview data.
**Reversible**: yes (Hajimete kanji asset provider remains available for a future real-data surface)
**Owner review**: pending

## DECISION-043 - Mimikara N1-N5 live assets use sanitized factual fields
**Phase**: Follow-up Sprint 1 Phase B/C
**Date**: 2026-05-21 18:30 (local)
**Context**: OQ-005 requires Mimikara N1-N5 live by 2026-05-22, while local owner files contain Mimikara N1-N3 only and four N1/N2 units are missing.
**Options considered**: keep planned placeholders | copy source filenames/prose | generate sanitized factual assets from canonical markdown plus OQ-011 fill
**Chosen**: generate static Mimikara assets/manifests from factual fields only, strip banned source filenames/brands, fill missing N1/N2 units from current-app/JMdict-compatible factual rows, and keep N4/N5 live via local kanji-vocab fallback while logging OQ-014.
**Rationale**: This removes dead UI, keeps copyright-safe fact extraction, avoids banned sites, and gives beta learners a usable Mimikara lane today.
**Reversible**: yes
**Owner review**: pending

## DECISION-044 - Mimikara assets dedupe by normalized term+reading
**Phase**: Follow-up Sprint 1 Phase C
**Date**: 2026-05-21 19:20 (local)
**Context**: The first Mimikara fill pass exposed duplicate term+reading rows across N1/N2 unit output after OQ-011 fill.
**Chosen**: Before writing level assets, keep the first source row for each normalized `term|reading` key and drop later duplicates.
**Rationale**: Mimikara unit review must not show repeated cards; first-row-wins preserves the owner-local extraction order and keeps online-fill rows from overriding existing local rows.
**Reversible**: yes
**Owner review**: pending

## DECISION-045 - Tae Kim fallback stored as Directive E metadata
**Phase**: Follow-up Sprint 1 Phase D
**Date**: 2026-05-21 19:35 (local)
**Context**: OQ-013 authorizes Tae Kim Grammar Guide as fallback because no dedicated offline grammar folder exists.
**Chosen**: Add `directiveE` blocks to grammar JSON files with form/meaning/usage/humanMoment and a Tae Kim fallback attribution object; do not alter content DB schema in Sprint 1.
**Rationale**: This makes the whole grammar corpus Directive E-ready without risking a DB migration during the visible Sprint 1 fixes. Existing grammar detail UI can opt into the richer block later.
**Reversible**: yes
**Owner review**: pending

## DECISION-046 - Sanitize legacy source-brand leaks from learner assets
**Phase**: Follow-up Sprint 1 gate hardening
**Date**: 2026-05-21 20:20 (local)
**Context**: Sprint 1 brand-leak audit for Mimikara assets exposed older kana/kanji learner JSON strings containing banned source brand names. These were not new Mimikara rows, but they can still leak to the learner UI.
**Chosen**: Strip banned source names from `assets/data/content/kana` file labels and clear legacy kanji mnemonic strings whose only content was source-brand boilerplate.
**Rationale**: The app must not display banned source branding or crawler-sensitive names. Empty mnemonic is preferable to a deceptive boilerplate note until QA-A-027/QA-A-026 canonical kanji metadata replaces those rows.
**Reversible**: yes
**Owner review**: pending

## DECISION-047 - Mimikara N4/N5 deleted, Shin Kanzen restructured to Bunpou grammar-only
**Phase**: Follow-up Sprint 1 Phase A0
**Date**: 2026-05-21 20:45 (local)
**Context**: Owner clarified OQ-014/OQ-015 architecture: Mimikara vocabulary exists only for N3/N2/N1, and Shin Kanzen Master scope in this product is Bunpou grammar-only with N3/N2/N1 lesson counts 83/163/88.
**Options considered**: keep fallback N4/N5 Mimikara until source arrives | hide N4/N5 but keep assets | delete bogus tracks and rebuild manifests around real textbook scope
**Chosen**: Delete N4/N5 Mimikara assets/manifests, remove `mimikara_n4`/`mimikara_n5` catalog entries, route N3-N1 vocab roadmap/catalog to Mimikara, and restructure `shinkanzen_n3/n2/n1` to grammar-only lesson indexes with 83/163/88 lessons.
**Rationale**: A visible fallback for a non-existent textbook is worse than missing data. The corrected catalog now matches actual product architecture and prevents learners from entering a fake Mimikara N4/N5 lane or a fake Shin Kanzen vocab lane.
**Reversible**: yes, but only if owner later supplies a real separate product/source that changes the textbook architecture.
**Owner review**: pending

## DECISION-048 - Phase E examples corpus bootstrapped from app vocab facts
**Phase**: Follow-up Sprint Phase E
**Date**: 2026-05-22 00:00 (local)
**Context**: OQ-006 requires `examples_corpus.json`, but no corpus file existed in the repo when Phase E started.
**Options considered**: block for external corpus | browse online examples | generate original JpStudy examples from existing vocab facts
**Chosen**: Build `assets/data/content/examples_corpus.json` from existing vocab entries with `source: "original-jpstudy"`, then wire 1 example into every vocab row via `tool/migration/wire_example_sentences.js`.
**Rationale**: This satisfies the schema and flashcard requirement without touching banned sources or copying third-party example prose. Phase G/F can later replace top items with richer hand-authored or licensed examples.
**Reversible**: yes
**Owner review**: pending

## DECISION-049 - Store examples on user lesson terms for flashcard reach
**Phase**: Follow-up Sprint Phase E
**Date**: 2026-05-22 00:05 (local)
**Context**: Flashcard mode reads `UserLessonTermData` for lesson routes, so content-DB-only `example_sentences[]` would not reach existing visible flashcards.
**Options considered**: render examples only for content catalog routes | join content DB during every flashcard load | add `exampleSentencesJson` to `user_lesson_term` and sync in place
**Chosen**: Add `exampleSentencesJson` to `user_lesson_term`, seed it from content rows, and sync existing matched lesson terms without deleting progress.
**Rationale**: This keeps the OQ-006 feature visible in the main lesson flashcard flow while preserving SRS and lesson history.
**Reversible**: yes
**Owner review**: pending

## DECISION-050 - Phase F reading corpus is original JpStudy by default
**Phase**: Follow-up Sprint Phase F
**Date**: 2026-05-22 01:35 (local)
**Context**: OQ-008 allows whitelisted source use or original authoring, while Phase F needs 968 passages across Mina I/II, Hajimete N5/N4, and Shin Kanzen N3/N2/N1.
**Options considered**: crawl whitelisted online examples | copy public-domain excerpts | generate original passages from local lesson facts
**Chosen**: Generate original JpStudy reading passages from local vocab/grammar facts and mark each passage `source_type: "original"` with source refs to local assets.
**Rationale**: This avoids copyright and banned-source risk, keeps per-lesson coverage deterministic, and leaves online/PD source enrichment for later quality passes when specific source attribution can be reviewed.
**Reversible**: yes
**Owner review**: pending

## DECISION-051 - JLPT reading screen prefers reading_passages corpus
**Phase**: Follow-up Sprint Phase F
**Date**: 2026-05-22 01:45 (local)
**Context**: The old JLPT reading bank was derived from 125 immersion lesson files, but Phase F scale lives in `reading_passages_corpus.json`.
**Options considered**: expand immersion files to 968 articles | keep JLPT reading on immersion only | load the scaled corpus first and keep immersion as fallback
**Chosen**: Load `reading_passages_corpus.json` first for JLPT reading, with immersion article conversion as fallback for legacy/local samples.
**Rationale**: This makes Phase F immediately visible in the JLPT reading flow without rewriting the immersion article format, and avoids eager rendering of hundreds of cards by switching the picker to a lazy sliver grid.
**Reversible**: yes
**Owner review**: pending

## DECISION-052 - Phase G rank reserves grammar, vocab, and kanji scope
**Phase**: Follow-up Sprint Phase G setup
**Date**: 2026-05-22 01:45 (local)
**Context**: Option C Phase G says Top-200 comes from Mina grammar, Hajimete vocab, Shin Kanzen grammar, and Joyo N5-N4 kanji. Pure score sorting over local corpus selected grammar/vocab only and excluded kanji.
**Options considered**: keep pure score sort | hand-edit Top-200 | deterministic score sort with minimum type coverage
**Chosen**: Keep deterministic frequency scoring, then reserve the Top-200 as 80 grammar, 80 vocab, and 40 kanji before final score ordering.
**Rationale**: This preserves the owner's cross-domain Phase G scope without making the rank file subjective. The quota is only a selection guard; item order inside the selected set remains score-based.
**Reversible**: yes
**Owner review**: pending

## DECISION-053 - C3 Shin Kanzen expansion uses local manifests first
**Phase**: Urgent live audit P0 C3
**Date**: 2026-05-22 10:20 (local)
**Context**: Live audit found Shin Kanzen manifest counts claimed N3 83, N2 163, and N1 88 lessons while visible grammar assets only covered 25 lessons per level. Owner requested whitelist publisher catalog research plus generated content.
**Options considered**: block on external catalog scrape | scrape publisher/site data now | use existing corrected local Shin Kanzen lesson manifests plus local grammar assets and Tae Kim attribution metadata
**Chosen**: Generate missing lesson grammar/example JSON from the corrected local item manifests and existing local grammar rows, with original JpStudy Vietnamese guidance, source attribution metadata, and `vi-source-verified` only.
**Rationale**: The corrected manifests already encode the required lesson counts and item surfaces. Local generation fixes the P0 blank/missing-content path deterministically without touching banned sources, copying publisher prose, or adding owner-only `vi-human-approved`. Phase G Track B remains responsible for Tier-1 real-voice Directive E rewrites.
**Reversible**: yes
**Owner review**: pending

## DECISION-054 - Minna vocab and conjugation scope by source series
**Phase**: Urgent live audit P1 H1-H2
**Date**: 2026-05-22 11:05 (local)
**Context**: Minna lesson vocab had generated kanji coverage rows mixed into learner lesson lists, and lesson-level conjugation could leak items from another N5 source track sharing the same lesson number.
**Options considered**: keep generated kanji coverage in vocab lessons | hide only obvious bad strings | delete all `generated_coverage`/`kanji-coverage` rows from Minna N5/N4 and scope conjugation by level+series+lesson
**Chosen**: Remove generated kanji coverage rows from Minna N5/N4 lesson vocab JSON, keep existing lesson-tagged words untouched, and query conjugation lemmas by level, source series, and lesson id.
**Rationale**: Kanji coverage belongs in kanji learning, not Minna vocab lessons. Series scoping prevents Hajimete N5 lesson 1 adjectives from appearing in Minna N5 lesson 1 while preserving conjugation in real Minna adjective/verb lessons.
**Reversible**: yes
**Owner review**: pending

## DECISION-055 - Grammar detail renders authored Directive E assets first
**Phase**: Urgent live audit P1 H3
**Date**: 2026-05-22 11:45 (local)
**Context**: Progressive disclosure needed to expose Directive E depth without repeating the template-injection problem found in the audit. The runtime grammar table does not store `directiveE` fields even though the source grammar JSON assets do.
**Options considered**: generate generic Dr. Linh text in the UI | add a Drift schema migration for all Directive E columns | hydrate the authored JSON asset block at detail-read time
**Chosen**: Load the authored `directiveE` block from the grammar asset matching the point's JLPT level, lesson id, and pattern/structure, then pass it through the grammar detail provider. Keep UI fallback only for legacy rows without an authored asset block.
**Rationale**: Asset hydration avoids a database migration in the urgent UI batch, preserves real per-pattern Directive E content when available, and prevents the UI from becoming another generic content generator.
**Reversible**: yes; a later schema migration can persist Directive E if profiling shows asset lookup overhead.
**Owner review**: pending

## DECISION-056 - Pattern-restatement meanings use usage clues in exercises
**Phase**: Urgent live audit P1 H4-H5
**Date**: 2026-05-22 12:15 (local)
**Context**: Some grammar rows store a pattern-like label in the meaning field, so reverse/meaning multiple-choice prompts could expose the correct pattern literally.
**Options considered**: delete all reverse/meaning questions for those rows | keep literal prompts and rely on better distractors | use explanation/usage as the clue or answer when meaning is a pattern restatement
**Chosen**: Detect literal restatements by normalized pattern overlap. For reverse-choice prompts, use a non-literal meaning/explanation clue. For meaning-choice answers, use explanation/usage when the meaning would reveal the pattern.
**Rationale**: This preserves practice coverage and 50-question density while removing the trivial substring-answer failure mode.
**Reversible**: yes
**Owner review**: pending

## DECISION-057 - Vocab catalog uses textbook_index as display truth
**Phase**: Urgent live audit P1 H6
**Date**: 2026-05-22 12:55 (local)
**Context**: Live audit found the vocab catalog under-represented available textbook programs and the old provider depended on hard-coded JLPT-level sections plus scattered asset loaders.
**Options considered**: keep JLPT sections and patch missing cards | query the content database for every track | use `textbook_index.json` as the catalog source of truth and group by publisher
**Chosen**: Bundle `lib/data/manifests/textbook_index.json` as a Flutter asset, filter to vocab textbooks, and render exactly Hajimete N5-N1, Minna N5/N4, and Mimikara N3/N2/N1 grouped by publisher.
**Rationale**: The manifest already encodes lesson counts, item counts, levels, categories, and migration status. Using it avoids DB-seed races, fixes the 10-program count deterministically, and prevents invalid Mimikara N5/N4 cards.
**Reversible**: yes
**Owner review**: pending

## DECISION-058 - Desktop chrome is full-bleed; content remains bounded
**Phase**: Urgent live audit P2 M1-M8
**Date**: 2026-05-22 13:35 (local)
**Context**: The live audit found a "chrome flush" gap: sidebar and header controls floated inside a capped shell, while page content still needed readable max widths.
**Options considered**: keep the capped shell and only widen content | make every surface full width | make app chrome full-bleed while keeping page content on adaptive max-width rails
**Chosen**: Return `double.infinity` for shell width, remove the desktop shell `AppResponsiveFrame`, set the desktop top bar padding to zero, and keep content bounded through `AppResponsiveMetrics.contentMaxWidth` at 1040/1280/1440/1600.
**Rationale**: Navigation chrome should align to viewport edges at desktop sizes, but learning content still needs scan-friendly line lengths. This fixes the visible empty bands without turning lesson/detail content into unreadably wide rows.
**Reversible**: yes
**Owner review**: pending

## DECISION-059 - Foundations suggestion becomes a dismissible banner
**Phase**: Urgent live audit P2 M8
**Date**: 2026-05-22 13:40 (local)
**Context**: The old foundations/kana recommendation opened a modal dialog on first visit, blocking grammar/vocab/kanji browsing.
**Options considered**: remove the recommendation entirely | keep the first-visit modal | convert it to a non-blocking banner with the same dismissal preference
**Chosen**: Render the suggestion as a bottom safe-area banner, gated by N5/null level, under-30% foundations progress, and a persisted dismissal flag.
**Rationale**: Early kana guidance remains visible for learners who need it, but it no longer interrupts the main route or causes a first-visit modal trap.
**Reversible**: yes
**Owner review**: pending

## DECISION-060 - Minna fallback labels hide storage ids
**Phase**: Urgent live audit P3 L1-L2
**Date**: 2026-05-22 14:05 (local)
**Context**: The review page could show a next-lesson label such as `Bắt đầu Minna No Nihongo -905014`, exposing an internal lesson storage id from seeded textbook rows.
**Options considered**: patch only the review card copy | strip every digit from next-lesson labels | make the curriculum title fallback source-aware for N5/N4 Minna I/II
**Chosen**: Format N5/N4 curriculum fallbacks as `Minna no Nihongo I/II — Lesson/Bài n`, clamp out-of-range internal ids to the first visible lesson, and stop shortening next-lesson labels to digit-only text in the continue button.
**Rationale**: This removes internal ids wherever the shared continue/next-lesson label is reused, while preserving real lesson titles for the learner.
**Reversible**: yes
**Owner review**: pending

## DECISION-061 - Upper grammar renders Shin Kanzen lesson roadmap
**Phase**: Urgent live audit P0 C3 addendum
**Date**: 2026-05-22 17:15 (local)
**Context**: Live verification after deploy showed `/grammar?level=N1` loaded generated N1 grammar content, but the page exposed only pattern totals (`245`) rather than the requested Shin Kanzen lesson count (`88`). Existing browser IndexedDB also retained the pre-expansion 25-lesson seed because the grammar data version had not been bumped.
**Options considered**: leave the pattern bank only | build a separate lesson-detail route | render a lesson roadmap above the grammar bank using existing `lessonId` grouping and known manifest counts, then force reseed with a grammar data-version bump
**Chosen**: Add an upper-JLPT Shin Kanzen roadmap section for N3/N2/N1 that renders every expected lesson slot (83/163/88), groups loaded grammar points by `lessonId`, links each populated lesson to its first grammar pattern, and bump `GrammarSeeder.kGrammarDataVersion` to 30.
**Rationale**: This satisfies the live acceptance wording without destabilizing the existing grammar bank, practice routes, or generated content. The section makes the manifest count visible while the version bump ensures existing browsers load the expanded C3 lesson files.
**Reversible**: yes
**Owner review**: pending

## DECISION-062 - Upper grammar seeder uses manifest lesson ranges
**Phase**: Urgent live audit P0 C3 addendum
**Date**: 2026-05-22 17:45 (local)
**Context**: Live recheck after the v30 deploy still showed N1 as `25 bài có nội dung` because `GrammarSeeder.lessonRangeForLevel` kept N3/N2/N1 capped at 25 even though the asset tree contains 83/163/88 JSON lesson files.
**Options considered**: rely on roadmap placeholders only | load every asset directory dynamically | make the seeder range table match the Shin Kanzen manifest counts and bump data version again
**Chosen**: Seed N3 lessons 1-83, N2 lessons 1-163, and N1 lessons 1-88; bump `GrammarSeeder.kGrammarDataVersion` to 31 so browsers that received partial v30 data reseed.
**Rationale**: The app already ships deterministic lesson files and tests for these counts. Matching the seeder to the manifest fixes actual runtime content, not only the visible roadmap count.
**Reversible**: yes
**Owner review**: pending

## DECISION-063 - App focus traversal uses widget order on web
**Phase**: Urgent live audit acceptance
**Date**: 2026-05-22 18:05 (local)
**Context**: Playwright live QA still captured a console `Error` before grammar seeding. Source-map resolution mapped the stack to Flutter `ReadingOrderTraversalPolicy.sort -> FocusNode.rect -> RenderBox.semanticBounds`, meaning the default focus traversal policy read a focus rectangle before one render box finished layout.
**Options considered**: ignore the console error as a Playwright accessibility artifact | remove focusable controls from chrome/banner | wrap the app in `FocusTraversalGroup` with `WidgetOrderTraversalPolicy`
**Chosen**: Use app-level widget-order focus traversal.
**Rationale**: Widget order avoids pre-layout rect reads while keeping deterministic keyboard traversal. This fixes the console acceptance failure at the boundary that triggered it instead of hiding errors.
**Reversible**: yes
**Owner review**: pending

## DECISION-064 - Default grammar mastery sessions use 50 questions
**Phase**: Urgent live audit final acceptance
**Date**: 2026-05-22 08:55 (Asia/Saigon)
**Context**: Final Playwright journey showed `/grammar-practice` rendering `Câu 1/20`, although the grammar exercise bank itself satisfied the `>=50` density guard. The runtime route still had a fallback pool cap and default mastery target below Directive F.1.
**Options considered**: leave route-specific quick practice short | only update visible label | align default mastery route with the 50-question density contract
**Chosen**: Raise the fallback point pool to 50 and set the default `GrammarSessionType.mastery` count to 50, with a widget regression test asserting the session opens at `Question 1 of 50`.
**Rationale**: Acceptance requires the learner-facing route to expose a 50-question session, not only the underlying bank. This keeps the UI, runtime session, and density contract aligned.
**Reversible**: yes
**Owner review**: pending

## DECISION-065 - Phase F acceptance uses live asset plus UI spot proof
**Phase**: Phase F reading comprehension scale-up
**Date**: 2026-05-22 09:45 (Asia/Saigon)
**Context**: Phase F had already generated a large reading corpus, but the autonomous status needed fresh proof that the deployed Firebase bundle, not only local files, exposed the scaled content and that the JLPT reading UI could open passages across levels.
**Options considered**: rely on local validator only | click every one of 968 deployed passages | combine live asset validation, random sample inspection, and N1-N5 UI list/open screenshots
**Chosen**: Validate the deployed reading corpus asset for counts and required fields, sample 20 passages from the live asset, and archive Playwright screenshots for N1-N5 desktop list/opened states plus N5 mobile list/opened states.
**Rationale**: This proves the deployed data surface and the learner-facing route without spending the phase budget on 968 repetitive visual clicks. Local validators and widget tests cover schema/density regressions; live screenshots cover route rendering and passage opening.
**Reversible**: yes
**Owner review**: pending

## DECISION-066 - Phase G Tier-1 batches continue in 5-item slices
**Phase**: Phase G Option C Tier-1
**Date**: 2026-05-22 10:35 (Asia/Saigon)
**Context**: Tier-1 grammar content still had 22 validator failures after item 058, and the owner required roughly 5 items per commit with real Directive E voice plus authored templates.
**Options considered**: author all remaining failures in one commit | split Directive E and exercise templates into separate commits | continue 5-item slices that pair Directive E rewrite with 10 templates per item
**Chosen**: Continue 5-item slices; batch 059-063 covers quantity counters, frequency per time, `どのくらい`, `だけ`, and adjective past tense in one commit.
**Rationale**: Pairing explanation quality and exercise coverage keeps each item shippable, keeps review scope small, and matches Directive A/F validation boundaries.
**Reversible**: yes
**Owner review**: pending

## DECISION-067 - Comparison and desire forms keep contrast-first drills
**Phase**: Phase G Option C Tier-1
**Date**: 2026-05-22 11:20 (Asia/Saigon)
**Context**: Batch 064-068 covers forms that learners often mix by function: `より` vs `どちらが` vs `いちばん`, and `ほしい` vs `たい`.
**Options considered**: write isolated form drills only | emphasize Vietnamese translation first | make contrast the backbone of Directive E cross-links and L4 templates
**Chosen**: Author every item with at least one cross-link and L4 task that forces the learner to choose the right comparison/desire frame from context.
**Rationale**: These patterns pass only when learners distinguish question vs statement, two-choice vs many-choice, and wanting a noun vs wanting an action.
**Reversible**: yes
**Owner review**: pending

## DECISION-068 - Te-form batch teaches suffix-driven function
**Phase**: Phase G Option C Tier-1
**Date**: 2026-05-22 12:05 (Asia/Saigon)
**Context**: Batch 069-073 moves from desire into purpose `に`, invitations, and the first te-form family. The same Vて stem changes meaning depending on what follows.
**Options considered**: teach Vて as a standalone translation | split te-form mechanics into a separate non-content commit | keep mechanics, request, and progressive together with contrast drills
**Chosen**: Author `Vて`, `Vてください`, and `Vています` together, with L4 templates that make learners inspect the suffix after て.
**Rationale**: The learner must not memorize Vて as only "and"; suffix-aware contrast prevents confusing request, invitation, and progressive states.
**Reversible**: yes
**Owner review**: pending

## DECISION-069 - Permission/prohibition drills use actor-role contrast
**Phase**: Phase G Option C Tier-1
**Date**: 2026-05-22 12:50 (Asia/Saigon)
**Context**: Batch 074-078 covers offer `ましょうか`, permission `てもいいですか`, prohibition `てはいけません`, result-state `ています`, and formal permission `てもかまいません`.
**Options considered**: teach each as a single translation | group all as generic te-form suffixes | make actor-role and permission polarity the main contrast axis
**Chosen**: Author templates around who acts and whether the action is allowed, forbidden, requested, offered, or described as a state.
**Rationale**: Learners confuse these because the surface all begins with Vて. Actor-role plus allow/ban polarity gives a reusable decision test.
**Reversible**: yes
**Owner review**: pending

## DECISION-070 - Final grammar Tier-1 closes on sequence nuance
**Phase**: Phase G Option C Tier-1 grammar
**Date**: 2026-05-22 13:25 (Asia/Saigon)
**Context**: The last two grammar validator failures were `Vて` action sequence and `Vてから`, which are easy to over-translate as the same "and/then".
**Options considered**: merge them into the prior te-form batch | leave them for mixed vocab/grammar rank work | finish the grammar validator set with a two-item final batch
**Chosen**: Finish the grammar validator set now with a two-item batch and contrast `Vて` soft sequence against `Vてから` completed-prior-action order.
**Rationale**: The two items form a natural pair and close the 80/80 grammar quality gate without mixing in the upcoming vocab Tier-1 work.
**Reversible**: yes
**Owner review**: pending

## DECISION-071 - P0 route fix targets missing route registration first
**Phase**: Urgent fix batch P0
**Date**: 2026-05-22 14:05 (Asia/Saigon)
**Context**: Live audit reported blank/404 flows. Current main already had the `/profile` redirect, friendly route-not-found screen, `/vocab/series/minna/lesson/:id` legacy redirect, JLPT exam start/empty states, and corrected Shin Kanzen grammar lesson counts. The remaining route root cause found in code was `AppRoutePath.vocabShinkanzen`: constants and navigation helpers existed, but `buildVocabRoutes()` did not register the route.
**Options considered**: rely on the generic not-found page | remove dead Shin Kanzen navigation helpers | register the route and add route/exam regression tests
**Chosen**: Register `/vocab/shinkanzen`, default direct hits to N3, and add focused tests covering Shin Kanzen route resolution plus `/exam` level-click start/empty states.
**Rationale**: This fixes a concrete route mismatch while preserving existing navigation. The regression tests cover the audit symptoms without changing already-correct route/error-boundary behavior.
**Reversible**: yes
**Owner review**: pending

## DECISION-072 - P1 audit items require evidence before new edits
**Phase**: Urgent fix batch P1
**Date**: 2026-05-22 14:45 (Asia/Saigon)
**Context**: The live audit listed six P1 issues, but current `main` already contained targeted fixes for Minna vocab quality, lesson-scoped conjugation, grammar Directive E progressive disclosure, 50-question grammar practice, authored Tier-1 templates, and the 10-program vocab catalog.
**Options considered**: rework every P1 area immediately | trust prior commits without fresh checks | run focused guards first and patch only failing surfaces
**Chosen**: Treat P1 as an evidence sweep unless a focused guard or live check fails. Run the existing data/widget/template validators, then move to P2 after logging the verified state.
**Rationale**: This avoids destabilizing already-correct surfaces while still respecting the audit. Any later Playwright mismatch becomes a concrete failing symptom with a targeted patch.
**Reversible**: yes
**Owner review**: pending

## DECISION-073 - JLPT timing copy follows official section totals
**Phase**: Urgent fix batch P2
**Date**: 2026-05-22 15:20 (Asia/Saigon)
**Context**: P2 M5 required differentiated JLPT level descriptions. The old exam center used one hardcoded `105-min mock exam` label, while `/exam` had outdated N5/N4/N1 timings. The official JLPT test-section page lists current section totals by level.
**Options considered**: keep the owner's example timings verbatim | keep 105 minutes for all mock cards | align UI labels with official section-total minutes and keep current approximate question counts
**Chosen**: Use official total minutes in both exam center and legacy `/exam`: N5=90, N4=115, N3=140, N2=155, N1=165.
**Rationale**: The UI should not teach stale exam timing. Question counts remain approximate where the app already marks them approximate, but time labels now match the official published sections.
**Reversible**: yes
**Owner review**: pending

## DECISION-074 - P3 low defects are covered by existing guards
**Phase**: Urgent fix batch P3
**Date**: 2026-05-22 15:35 (Asia/Saigon)
**Context**: P3 listed an internal lesson ID leak and onboarding button/selection-state polish. Current main already had `continue_provider_test.dart` guarding against `905014` leaks and `level_select_screen_test.dart` guarding disabled/enabled start behavior plus visible selected styling.
**Options considered**: rework the review/onboarding widgets anyway | skip P3 because it is low priority | run targeted guards and log P3 as evidence-only if green
**Chosen**: Run targeted P3 tests and only log status because no failing P3 symptom remains in code.
**Rationale**: Low-priority polish should not churn stable widgets without a failing symptom, especially before the full Playwright acceptance pass.
**Reversible**: yes
**Owner review**: pending

## DECISION-075 - Upper JLPT grammar seeding uses deterministic bulk rows
**Phase**: Urgent fix batch P0 follow-up
**Date**: 2026-05-22 16:45 (Asia/Saigon)
**Context**: Local Playwright on a fresh web profile showed N3 grammar stuck in the loading fallback for about 165 seconds because the app seeded N3/N2/N1 grammar lesson-by-lesson through many small Drift writes.
**Options considered**: wait longer in QA | pre-seed all levels at app startup | bulk-replace only upper JLPT grammar rows with deterministic IDs
**Chosen**: Use deterministic level-scoped IDs and bulk insert N3/N2/N1 grammar points/examples in one batch, leaving N5/N4 seeding unchanged.
**Rationale**: Shin Kanzen roadmap rendering must be fast on first visit. Upper-level grammar has large generated manifests and low legacy SRS risk, while N5/N4 keep their existing ID behavior for user progress stability.
**Reversible**: yes
**Owner review**: pending

## DECISION-076 - Exam prep has a bounded loading fallback
**Phase**: Urgent fix batch P0 follow-up
**Date**: 2026-05-22 17:05 (Asia/Saigon)
**Context**: `/exam` could stay on `Đang chuẩn bị câu hỏi JLPT N5...` while the content DB was still opening and seeding local vocab tracks.
**Options considered**: keep spinner until content DB finishes | make exam depend on preloaded data only | timeout mock prep and render the no-question empty state
**Chosen**: Apply an 8-second timeout to the vocab fetch and a 2-second timeout to resume-state loading. On timeout the selected level becomes Ready and shows the existing no-question state.
**Rationale**: A visible empty state is safer than an indefinite loading card. It satisfies the audit requirement that no-question levels render a user-facing fallback instead of a blank or stuck flow.
**Reversible**: yes
**Owner review**: pending

## DECISION-077 - Missing N5/N4 vocab tracks should not be probed
**Phase**: Urgent fix batch acceptance
**Date**: 2026-05-22 17:20 (Asia/Saigon)
**Context**: Local acceptance showed console 404s for `vocab/n5/ShinKanzen/index.json` and `vocab/n5/mimikara/index.json`. These tracks are intentionally absent after the corrected textbook architecture.
**Options considered**: ignore known 404s in QA | add empty placeholder assets | skip impossible probes in the content seeder
**Chosen**: Return Minna paths directly for N5/N4 canonical vocab and keep Mimikara seed specs to N3/N2/N1 only.
**Rationale**: The app should not request assets for tracks that are intentionally not part of the product architecture. Avoiding the request keeps console-error acceptance meaningful.
**Reversible**: yes
**Owner review**: pending

## DECISION-078 - Anonymous auth bootstrap is opt-in gated
- Date: 2026-05-22
- Decision: Do not run deferred anonymous Firebase sign-in when analytics consent is denied and legacy storage migration is disabled.
- Rationale: Local/live QA must not leak avoidable identitytoolkit 403 console errors; cloud identity remains available when analytics or migration actually needs it.
- Verification: flutter analyze lib/main.dart test/main_bootstrap_test.dart; flutter test test/main_bootstrap_test.dart; flutter build web --release; Playwright local authgate showed 0 console errors and no identitytoolkit signUp request after deferred bootstrap.

## DECISION-079 - Example sentences require a real-context validator
- Date: 2026-05-22
- Decision: Replace generated vocab example filler with validated real-context examples. Tatoeba CC-BY 2.0 rows are preferred when cached; owner/local textbook rows can be supplied through the same row shape; otherwise JpStudy-authored contextual examples are allowed only if the validator passes.
- Rationale: The old corpus was 100% generated from reusable frames, so it failed the Directive E teaching test. A quality gate has to reject template phrases before content reaches vocab, grammar, or reading pipelines.
- Verification: `node --test test/tool/qa/validate_example_quality_test.js test/tool/migration/wire_example_sentences_test.js`; `node tool/qa/validate_example_quality.js`; hard banned phrase scan over `assets/data/content`.

## DECISION-080 - Vocab example quality uses sentinels, not version only
- Date: 2026-05-22
- Decision: Treat vocab seed revision as necessary but insufficient. If stored vocab content still contains banned example-template fragments, reseed the affected level and then sync stale user lesson terms from content.
- Rationale: Live local QA found a browser profile that had already consumed the revision bump while retaining old template examples. A content-quality sentinel prevents revision drift from freezing bad examples in installed databases.
- Verification: `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart test/features/lesson/lesson_detail_screen_test.dart test/data/models/vocab_item_test.dart test/features/flashcards/enhanced_flashcard_screen_test.dart --reporter expanded`; local Playwright screenshot `docs/research/qa-live-2026-05-22-example25-minna-card.png`.

## DECISION-081 - Foundation chips must truncate inside finite shells
- Date: 2026-05-22
- Decision: `AppChip` keeps its compact pill form, but long labels use single-line ellipsis when the parent provides finite width. Wide-only route-smoke text is no longer used as the search screen mount proof.
- Rationale: Route smoke surfaced a real `RenderFlex` overflow from a long status chip inside bounded route content, while the search assertion depended on a label hidden by narrower shell constraints. The shared chip primitive should absorb finite-width pressure instead of every feature screen hand-tuning chip labels.
- Verification: `flutter analyze lib/widgets/foundation/app_chip.dart test/widgets/foundation/foundation_widgets_test.dart test/features/ui/app_route_smoke_test.dart`; `flutter test test/widgets/foundation/foundation_widgets_test.dart test/features/ui/app_route_smoke_test.dart test/features/ui/exam_and_coach_route_smoke_test.dart --reporter expanded`; full route/exam focused group; `flutter build web --release`; local route matrix report `docs/research/local-route-matrix-2026-05-22.md`.

## DECISION-082 - QA-A-030 vocab fixes stay consensus-only and small
- Date: 2026-05-22
- Decision: Continue QA-A-030 app vocab repair with small N5 Minna batches selected only from CONSENSUS rows with at least two owner-local canonical sources and meaning-token overlap. Normalize obvious Vietnamese OCR spelling (`Chổ` -> `Chỗ`) in the applied report/assets, and bump `vocabSeedRevision` to 7 so installed DBs refresh the edited meanings.
- Rationale: The remaining diff contains many cosmetic or source-divergent rows. Small consensus-only batches reduce the chance of replacing an acceptable app gloss with a weaker canonical OCR artifact while still moving the app toward source-backed vocab.
- Verification: `node --test test/tool/research/vocab_app_diff_test.js test/tool/research/vocab_app_diff_apply_test.js test/tool/qa/validate_example_quality_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart assets/data/content/vocab/n5/minna test/data/db/content_database_lazy_seed_test.dart test/tool/research/vocab_app_diff_apply_test.js`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart --reporter expanded`; `git diff --check`.

## DECISION-083 - Vocab diff apply supports curated entry IDs
- Date: 2026-05-22
- Decision: Add `--entryIds` to `tool/research/apply_vocab_app_diff_fixes.js` and use it for QA-A-030 batch 003, selecting five safe N5 Minna meaning repairs while skipping weak canonical replacements such as `課長 -> Tổ trưởng`.
- Rationale: First-N application is too blunt once remaining rows include OCR artifacts or overly narrow glosses. Curated entry IDs preserve the same consensus/source-count/token-overlap guard while allowing batch review before writes.
- Verification: `node --test test/tool/research/vocab_app_diff_test.js test/tool/research/vocab_app_diff_apply_test.js test/tool/qa/validate_example_quality_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart assets/data/content/vocab/n5/minna tool/research/apply_vocab_app_diff_fixes.js test/tool/research/vocab_app_diff_apply_test.js`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart --reporter expanded`; `git diff --check`.

## DECISION-084 - Leave questionable canonical glosses for later review
- Date: 2026-05-22
- Decision: For QA-A-030 batch 004, apply five clear N5 Minna consensus repairs and keep ambiguous/narrow canonical rows, including `課長 -> Tổ trưởng`, out of the automated batch.
- Rationale: `課長` is better taught as a workplace section/department chief than a generic team leader. Rows where the canonical source appears narrower than the current app gloss need a separate human/source review lane, not a blind replacement.
- Verification: `node --test test/tool/research/vocab_app_diff_test.js test/tool/research/vocab_app_diff_apply_test.js test/tool/qa/validate_example_quality_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart assets/data/content/vocab/n5/minna`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart --reporter expanded`; `git diff --check`.

## DECISION-085 - Preserve kinship nuance during N5 vocab repair
- Date: 2026-05-22
- Decision: For QA-A-030 batch 005, apply five clear consensus rows and skip kinship rows such as `兄`/`姉` where the current app gloss preserves self-reference nuance that the canonical summary omits.
- Rationale: Minna family vocabulary depends on self-family vs other-family contrast. A shorter canonical gloss can be factual but less useful pedagogically, so those rows need a separate contrast-aware pass.
- Verification: `node --test test/tool/research/vocab_app_diff_test.js test/tool/research/vocab_app_diff_apply_test.js test/tool/qa/validate_example_quality_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart assets/data/content/vocab/n5/minna`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart --reporter expanded`; `git diff --check`.

## DECISION-086 - Prefer source-backed clarity over cosmetic N5 rewrites
- Date: 2026-05-22
- Decision: For QA-A-030 batch 006, apply five clear source-backed repairs for time, drink, shipping, and lexical labels while continuing to skip rows where the current gloss is already pedagogically richer.
- Rationale: The goal is not to churn capitalization or shorten good explanations. Batch 006 only changes rows where the canonical wording adds clarity or removes awkward phrasing.
- Verification: `node --test test/tool/research/vocab_app_diff_test.js test/tool/research/vocab_app_diff_apply_test.js test/tool/qa/validate_example_quality_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart assets/data/content/vocab/n5/minna`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart --reporter expanded`; `git diff --check`.

## DECISION-087 - Batch 007 keeps specificity where canonical improves it
- Date: 2026-05-22
- Decision: Apply five N5 Minna rows where the canonical gloss adds a useful register, category, or context note: `高校`, `妻`, `昨日`, `刺身`, and `市役所`.
- Rationale: These rows improve learner-facing precision without flattening an important grammar or social contrast. Spouse self-reference remains explicit in `妻`.
- Verification: `node --test test/tool/research/vocab_app_diff_test.js test/tool/research/vocab_app_diff_apply_test.js test/tool/qa/validate_example_quality_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart assets/data/content/vocab/n5/minna`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart --reporter expanded`; `git diff --check`.

## DECISION-088 - Batch 008 preserves social-role notes
- Date: 2026-05-22
- Decision: Apply five N5 Minna rows where the canonical gloss improves clarity and preserves role nuance: `資料`, `次に`, `自動車`, `主人`, and `趣味`.
- Rationale: `主人` keeps the self-spouse note, while the other rows add alternate common Vietnamese terms or smoother sequencing/vehicle wording.
- Verification: `node --test test/tool/research/vocab_app_diff_test.js test/tool/research/vocab_app_diff_apply_test.js test/tool/qa/validate_example_quality_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart assets/data/content/vocab/n5/minna`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart --reporter expanded`; `git diff --check`.

## DECISION-089 - Batch 009 skips canonical typo rows
- Date: 2026-05-22
- Decision: Apply five N5 Minna rows for counters/locations/shops/answers while skipping canonical rows that still contain obvious Vietnamese typos such as `Đặt biệt là`.
- Rationale: Source-backed automation must not import OCR/spelling defects into learner-facing app content. Typo-bearing rows need canonical cleanup before app application.
- Verification: `node --test test/tool/research/vocab_app_diff_test.js test/tool/research/vocab_app_diff_apply_test.js test/tool/qa/validate_example_quality_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart assets/data/content/vocab/n5/minna`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart --reporter expanded`; `git diff --check`.

## DECISION-090 - Batch 010 stays meaning-only despite reading drift
- Date: 2026-05-22
- Decision: Apply five N5 Minna meaning repairs for `新幹線`, `千`, `他に`, `大学`, and `着物`, while leaving the pre-existing `大学` reading/search drift for a later wrong-reading batch.
- Rationale: This batch is scoped to meaning repairs from the app-diff wrong-meaning lane. Mixing reading fixes into a meaning batch would make the report less auditable; the `大学` reading issue is now explicitly noted for the next QA-A-030 lane.
- Verification: `node --test test/tool/research/vocab_app_diff_test.js test/tool/research/vocab_app_diff_apply_test.js test/tool/qa/validate_example_quality_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart assets/data/content/vocab/n5/minna`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart --reporter expanded`; `git diff --check`.

## DECISION-091 - Batch 011 skips warm/cold adjective ambiguity
- Date: 2026-05-22
- Decision: Apply five N5 Minna meaning repairs for `信号`, `中`, `背`, `物価`, and `問題`, while skipping adjective rows such as `暖かい`/`温かい` where the kanji distinction carries pedagogical nuance.
- Rationale: The batch improves clear context labels and lesson-specific meanings without flattening high-value contrast pairs.
- Verification: `node --test test/tool/research/vocab_app_diff_test.js test/tool/research/vocab_app_diff_apply_test.js test/tool/qa/validate_example_quality_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart assets/data/content/vocab/n5/minna`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart --reporter expanded`; `git diff --check`.

## DECISION-092 - Batch 012 keeps low-risk common-word repairs
- Date: 2026-05-22
- Decision: Apply five N5 Minna repairs for `小さい`, `少し`, `上着`, `乗り場`, and `食べ物`, all from consensus rows where the canonical gloss is clearer or more natural in Vietnamese.
- Rationale: These are low-risk common-word updates and do not remove family/register/kanji nuance.
- Verification: `node --test test/tool/research/vocab_app_diff_test.js test/tool/research/vocab_app_diff_apply_test.js test/tool/qa/validate_example_quality_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart assets/data/content/vocab/n5/minna`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart --reporter expanded`; `git diff --check`.

## DECISION-093 - Example sentences prefer real Tatoeba rows before authored fallback
- Date: 2026-05-22
- Decision: Rebuild `examples_tatoeba_seed.json` from official Tatoeba sentence/link exports, key rows by `vocabId` before term, and remove reading-only matching to prevent homophone drift. Keep a curated beginner `私` row ahead of generic matches. Reject old template frames and broad authored fallback frames in `validate_example_quality`.
- Rationale: The previous Phase E corpus still passed by construction while many entries were generic or wrong (`Xは日本語を勉強しています`, `ニュースでXについて読みました`). Real linked JP-VI Tatoeba rows reduce authored fallback volume and the validator now catches the known template-injection shapes.
- Verification: `node --test test/tool/research/tatoeba_example_seed_test.js test/tool/qa/validate_example_quality_test.js test/tool/migration/wire_example_sentences_test.js test/tool/research/vocab_app_diff_test.js test/tool/research/vocab_app_diff_apply_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart assets/data/content/vocab`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart test/data/models/vocab_item_test.dart test/features/flashcards/enhanced_flashcard_screen_test.dart --reporter expanded`; `flutter build web --release`; local browser fetch of release asset `lesson_01.json` confirmed `私` uses Tatoeba `私の番？`.

## DECISION-094 - Avoid impossible vocab asset probes in lesson seeding
- Date: 2026-05-22
- Decision: Short-circuit lesson vocab loading for non-positive lesson IDs and resolve N4/N5 vocab assets directly to Minna paths instead of probing Shin Kanzen first.
- Rationale: Live QA found console noise from impossible asset probes such as `lesson_00.json` and `vocab/n5/ShinKanzen/index.json`. N4/N5 user vocab lessons are Minna-backed, so probing upper-JLPT Shin Kanzen assets first is misleading and can surface false asset errors.
- Verification: `flutter analyze lib/data/repositories/lesson_repository.dart test/data/repositories/lesson_repository_test.dart`; `flutter test test/data/repositories/lesson_repository_test.dart --reporter expanded`; `flutter build web --release`; Playwright fresh route `http://127.0.0.1:5182/?qa=assetprobe-20260522-2#/exam` showed zero console errors/warnings; screenshot `docs/research/qa-live-2026-05-22-p1-asset-probe-exam.png`.

## DECISION-095 - Keep kanji example backfills out of Minna vocab lessons
- Date: 2026-05-22
- Decision: Remove Minna N5/N4 rows tagged `kanji-example` from textbook vocab assets and synchronize Minna item manifests to the remaining lesson entries. Keep kanji/example compounds in the kanji-learning lane instead of presenting them as Minna lesson vocab.
- Rationale: The live audit found kanji-decomposition leakage in Minna lessons: standalone kanji/compound examples were mixed into textbook vocab, and some stale item manifests still referenced orphan entries such as single-kanji glosses. That makes learners see kanji practice artifacts as lesson vocabulary.
- Verification: Red-green `flutter test test/data/content/minna_vocab_quality_test.dart --reporter expanded`; `flutter analyze lib/data/db/content_database.dart test/data/content/minna_vocab_quality_test.dart`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart --reporter expanded`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; scoped Minna manifest sync script reported `minna_n5: 1278`, `minna_n4: 1374`; generated-kanji row scan reported 0. Global `node tool/migration/validate_migration.js` still reports pre-existing upper-JLPT/Mimikara manifest drift outside this Minna batch.

## DECISION-096 - Enforce conjugable kind filters at repository boundary
- Date: 2026-05-22
- Decision: Filter `ConjugationRepository` reads to `verb`, `i_adjective`, and `na_adjective`, including lesson-scoped lookup used by lesson widgets.
- Rationale: The H2 audit symptom was a non-lesson or non-conjugable form surfacing in the lesson widget. Even when generated lemma assets are clean, the UI should not trust malformed rows; repository queries now enforce the conjugable contract before widgets render.
- Verification: Red-green `flutter test test/data/content/conjugation_content_seed_test.dart --reporter expanded`; `flutter test test/features/conjugation/conjugation_lesson_widget_test.dart --reporter expanded`; `flutter analyze lib/data/repositories/conjugation_repository.dart test/data/content/conjugation_content_seed_test.dart test/features/conjugation/conjugation_lesson_widget_test.dart`.

## DECISION-097 - Exercise density guard must reject literal answer leakage
- Date: 2026-05-22
- Decision: Generate 50-question vocab sessions by cycling items/types, fix test config to preserve the 50-question cap even for small lessons, and extend `ExerciseValidator` to reject choice prompts that contain the literal answer or placeholder distractors.
- Rationale: H4/H5 require learners to see `Câu 1/50`, not short sessions created by low lesson item counts. Literal-answer prompts and placeholder distractors recreate the same template-injection failure mode as Directive E; the bank guard exposed that grammar seed meaning was being populated from `title`, so grammar seeding now prefers real meaning fields and `directiveE.meaning` before falling back to title.
- Verification: Red-green `flutter test test/features/learn/question_generator_test.dart test/features/test/test_config_screen_test.dart test/features/exercise/exercise_bank_test.dart test/features/grammar/grammar_question_generator_test.dart test/features/grammar/grammar_practice_screen_test.dart test/data/content/grammar_practice_bank_guard_test.dart --reporter expanded`; `flutter analyze lib/data/seeds/grammar_seeder.dart lib/features/exercise/services/exercise_validator.dart lib/features/learn/services/question_generator.dart lib/features/test/screens/test_config_screen.dart test/features/exercise/exercise_bank_test.dart test/features/test/test_config_screen_test.dart test/features/learn/question_generator_test.dart test/data/content/grammar_practice_bank_guard_test.dart`; `git diff --check`.

## DECISION-098 - Keep official JLPT exam durations over audit example text
- Date: 2026-05-22
- Decision: Keep exam metadata durations at N5 90, N4 115, N3 140, N2 155, and N1 165 minutes, matching the official JLPT test-section table; do not change N5 to the audit's example `60 phút`.
- Rationale: The audit requested official JLPT metadata but included a non-official example for N5. The current code already matches the official section timings, so the P2 work only fixed a responsive overflow in the home overview grid found while re-running the P2 suite.
- Verification: Official JLPT test sections page checked on 2026-05-22; `flutter test test/app/layout/app_responsive_frame_test.dart test/app/layout/responsive_shell_test.dart test/app/navigation/app_shell_scaffold_test.dart test/features/onboarding/level_select_screen_test.dart test/features/exam/exam_screen_test.dart test/features/grammar/grammar_screen_test.dart test/features/grammar/grammar_detail_screen_test.dart test/features/grammar/widgets/multiple_choice_widget_test.dart test/features/foundations/foundations_soft_suggest_gate_test.dart --reporter expanded`.

## DECISION-099 - Treat vocab examples as anti-template content
- Date: 2026-05-22
- Decision: Extend Phase E example wiring so the source order is Tatoeba JP-VI rows, optional owner-local textbook cache rows, then authored contextual fallback; reject old `Xを使う文` templates, broad fallback frames, loose single-kana Tatoeba matches, and stale installed DB rows containing known template fragments.
- Rationale: The audit found the same template-injection failure mode in vocab examples that Directive E already bans for grammar explanations. The generator now has an explicit source hook for owner-provided textbook examples, stricter Tatoeba term matching, broader app/runtime seed sentinels, and regenerated `example_sentences` for all vocab assets.
- Verification: `node --test test/tool/qa/validate_example_quality_test.js test/tool/migration/wire_example_sentences_test.js test/tool/research/tatoeba_example_seed_test.js`; `node tool/qa/validate_example_quality.js`; `node tool/migration/wire_example_sentences.js --validate-only`; `flutter analyze lib/data/db/content_database.dart lib/data/repositories/lesson_repository.dart lib/features/vocab/screens/vocab_detail_screen.dart test/tool test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart test/features/vocab/vocab_detail_screen_test.dart`; `flutter test test/data/db/content_database_lazy_seed_test.dart test/data/repositories/lesson_repository_test.dart test/data/models/vocab_item_test.dart test/features/flashcards/enhanced_flashcard_screen_test.dart test/features/vocab/vocab_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-100 - JLPT exam banks load canonical assets before DB fallback
- Date: 2026-05-22
- Decision: `LessonRepository.getVocabByLevel` now builds the exam bank from bundled canonical assets first: Minna for N5/N4 and Mimikara for N3/N2/N1. DB fallback remains level-scoped and can seed Minna, Hajimete, Mimikara, or Shin Kanzen explicitly.
- Rationale: Live audit showed JLPT level clicks could reach a blank/empty state because the legacy exam path only queried Minna and then timed out while first-run seeding was still active. Upper JLPT levels need their real bundled series, and the exam screen should keep loading instead of converting slow seed work into a false "no questions" state.
- Verification: Focused Flutter analyzer/tests plus live Playwright N1-N5 level-click proof on `jpstudy.web.app` with zero console errors; screenshots archived as `docs/research/qa-live-2026-05-22-accept-exam-n{1..5}-asset-fixed.png`.

## DECISION-101 - Phase G global Directive E debt advances in five-item batches
- Date: 2026-05-22
- Decision: Continue the non-Tier-1 Directive E cleanup in five-item JSON batches, starting with N1 lesson 1 rows `〜うが〜うが`, `〜うと〜うと`, `〜かたわら`, `〜かれ〜かれ`, and `〜だの〜だの`; fix same-screen/example defects found during the batch.
- Rationale: Tier-1 already passes `80/80`, but the global validator still exposes template-injection debt. Five-item batches match Directive A, keep reviewable scope, and allow pattern-specific Dr. Linh authoring instead of bulk filler. The connected `〜かれ〜かれ` examples were invalid because they treated a fossilized adjective collocation as a free noun/verb frame.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_1:001..005`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `85/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/repositories/grammar_repository_test.dart --reporter expanded`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-102 - Fix grammar examples when Directive E audit exposes wrong pattern use
- Date: 2026-05-22
- Decision: In Phase G Directive E batch 002, re-author `〜であれ〜であれ`, `〜というか〜というか`, `〜とも〜とも`, `〜にしろ〜にしろ`, and `〜はおろか〜も`; also replace `〜とも〜とも` examples that were merely ordinary `とも` particle usage.
- Rationale: Directive D requires whole-screen/content linkage, not field-only compliance. `〜とも〜とも` must teach ambiguity or indeterminacy, often with `言えない`/`つかない`; examples such as `父とも兄とも話していない` teach a different grammar and would mislead learners even if the Directive E field passed.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_1:006..009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_10:001`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `90/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-103 - Preserve contrast-specific authoring for N1 lesson 10 particles
- Date: 2026-05-22
- Decision: Re-author `〜はさておき`, `〜はどうであれ`, `〜まみれ`, `〜もさることながら`, and `〜も兼ねて` with origin, Hán-Việt bridge, Dr. Linh humanMoment, usage, and cross-links instead of bulk-regenerating the whole lesson.
- Rationale: These five items look superficially particle-heavy, but each has a different semantic core: setting aside, regardless of state, being smeared/covered, acknowledging A while emphasizing B, and combining purposes. Treating them as generic は/も/て advice was the template-injection failure the validator is meant to block.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_10:002..006`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `95/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-104 - N1 lesson 11 examples must honor noun-frame grammar
- Date: 2026-05-22
- Decision: In Directive E batch 004, re-author `〜も相まって`, `〜をおいて他に〜ない`, `〜をもって`, `〜をものともせずに`, and `〜をよそに`; also fix two lesson 11 examples that violated noun-frame requirements.
- Rationale: `〜をよそに` and `〜を余儀なくされる` both require a noun or nominalized clause before を. Leaving `試験が迫るをよそに` and `中止する余儀なくされた` would teach learners the wrong attachment even while the explanation improved.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_10:007..010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_11:001`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `100/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-105 - Preserve distinct N1 lesson 11 transition frames
- Date: 2026-05-22
- Decision: In Directive E batch 005, re-author `〜を余儀なくされる`, `〜を前提として`, `〜を前提にして`, `〜を境にして`, and `〜を機にして`.
- Rationale: These five patterns require separate semantic cores: forced noun-result frames, formal tiền đề, planning assumptions, boundary shifts, and opportunity-triggered change. Generic `て`/condition advice would blur the exact contrasts learners need.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_11:002..006`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `105/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-106 - Treat sequence openers differently from single change triggers
- Date: 2026-05-22
- Decision: In Directive E batch 006, re-author `〜を皮切りに / を皮切りにして`, `〜を皮切りにして`, `〜を禁じ得ない`, `〜を経て`, and `〜を踏まえて`; replace a weak `〜を皮切りにして` example with a nationwide tour sequence.
- Rationale: `皮切り` must open a series, not merely mark the first day of a habit. `禁じ得ない`, `経て`, and `踏まえて` also need separate cores: suppressed emotion, passed-through process, and evidence-based action.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_11:007`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_11:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_11:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_12:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_12:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `110/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-107 - Align `がてら` metadata with noun and masu-stem usage
- Date: 2026-05-22
- Decision: In Directive E batch 007, re-author `〜を限りに`, `〜並み`, `〜前提で`, `〜限り(は)`, and `〜がてら`; update `〜がてら` structure/example labels to `Verb-ます stem / action noun + がてら`.
- Rationale: `がてら` examples in the lesson are noun-based (`散歩がてら`, `買い物がてら`), so verb-only metadata was misleading. The batch also separates two `限り` patterns: one is a deadline marker, the other is a condition-scope marker.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_12:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_12:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_12:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_12:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_12:007`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `115/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-108 - Keep classical negative patterns attached to real verb frames
- Date: 2026-05-22
- Decision: In Directive E batch 008, re-author `〜こそすれ`, `〜させられる`, `〜ざるを得ない`, `〜ずじまい`, and `〜ずとも`; update `〜させられる` structure to causative-passive form and replace non-verb `なくとも` examples in the `〜ずとも` lesson block.
- Rationale: `ずとも`, `ずじまい`, and `ざるを得ない` all depend on classical negative morphology, so examples and guidance must show real verb attachment. `させられる` was also mislabeled as a plain verb suffix instead of a full causative-passive form.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_12:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_12:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_12:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_13:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_13:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `120/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-109 - Separate obligation, prediction, and immediate-repeat patterns
- Date: 2026-05-22
- Decision: In Directive E batch 009, re-author `〜ずにはおかない`, `〜ずにはすまない`, `〜そうにない`, `〜そうもない`, and `〜そばから`; update `〜そばから` structure to dictionary/た-form and repair `〜そうにない` example attachment.
- Rationale: These five rows look superficially negative, but each teaches a different operation: inevitable action, obligation before things can be settled, weak negative prediction, stronger negative likelihood, and immediate repeated frustration.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_13:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_13:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_13:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_13:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_13:007`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `125/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-110 - Keep irreversible-result and endless-loop patterns distinct
- Date: 2026-05-22
- Decision: In Directive E batch 010, re-author `〜たが最後`, `〜たことにしてください`, `〜たら〜たで`, `〜たらきりがない`, and `〜たら最後`; fix a `〜たら〜たで` romaji typo.
- Rationale: `たが最後`, `たら最後`, and `たらきりがない` all involve a trigger point, but they teach different outcomes: hard irreversible result, conditional warning, and endless continuation. The `たことにしてください` row also needed a concrete request/pretend contrast instead of generic て advice.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_13:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_13:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_13:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_14:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_14:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `130/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-111 - Keep `つ〜つ` as fixed alternation, not free listing
- Date: 2026-05-22
- Decision: In Directive E batch 011, re-author `〜つ〜つ`, `〜てからというもの`, `〜てこそ`, `〜ては`, and `〜てはVerb`; replace unnatural free `つ〜つ` examples and generic `てはVerb` examples with real alternating/repeated-action frames.
- Rationale: `つ〜つ` is not a productive replacement for `たり〜たり`; it mostly survives in fixed literary alternation pairs. The `ては` rows also need to teach repeated cycles rather than generic topic-particle guidance.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_14:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_14:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_14:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_14:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_14:007`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `135/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-112 - Separate proof, emotional continuity, force, and obligation
- Date: 2026-05-22
- Decision: In Directive E batch 012, re-author `〜てまでも`, `〜てみせる`, `〜てやまない`, `〜ないではおかない`, and `〜ないではすまない`; repair examples for `〜てみせる`, `〜ないではおかない`, and `〜ないではすまない`.
- Rationale: `てみせる` must show demonstration/proof, not generic effort. `ないではおかない` predicts force/reaction, while `ないではすまない` is obligation or responsibility; examples now make that split visible.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_14:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_14:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_14:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_15:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_15:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `140/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-113 - Align N1 negative-scale patterns with real attachment
- Date: 2026-05-22
- Decision: In Directive E batch 013, re-author `〜ないまでも`, `〜ないものだろうか`, `〜ないものでもない`, `〜のないNoun`, and `〜ばきりがない`; retitle the fourth row from verb-negative metadata to `Noun の ない Noun`.
- Rationale: The batch exposed three separate pattern families that generic negative/particle advice blurred: a scale below an ideal (`ないまでも`), a hopeful search for a way (`ないものだろうか`), a cautious double-negative (`ないものでもない`), noun absence (`NのないN`), and endless listing (`ばきりがない`). The existing examples for `のない` were noun-absence examples, so metadata now matches the actual teaching surface instead of pretending it is a verb-relative clause.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_15:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_15:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_15:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_15:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_15:007`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `145/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-114 - Distinguish emphatic non-action, manner goals, and volitional pairs
- Date: 2026-05-22
- Decision: In Directive E batch 014, re-author `〜もしないで`, `〜やしない`, `〜ように`, `〜ようか〜まいか`, and `〜ようが〜まいが`; adjust `〜ように` metadata to `Verb/plain clause + ように` and replace an adjective-only `〜ようが〜まいが` example with a verb-frame sentence.
- Rationale: These rows share visible negatives or よう forms, but they teach different mechanisms: skipped minimum action, rough emphatic denial, 様-based manner/goal, indecision between two wills, and result-invariance regardless of two wills. Keeping `ようか〜まいか` and `ようが〜まいが` contrasted prevents learners from confusing hesitation with indifference of outcome.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_15:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_15:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_15:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_16:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_16:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `150/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-115 - Separate method-impossibility from blocked volition
- Date: 2026-05-22
- Decision: In Directive E batch 015, re-author `〜ようがない`, `〜ようと〜まいと`, `〜ようにも`, `〜ようにも〜れない`, and `〜ようもない`; rewrite three `〜ようにも〜れない` examples to repeat the verb in potential-negative form.
- Rationale: `ようがない`/`ようもない` teach absence of a method, while `ようにも`/`ようにも〜れない` teach a will blocked by circumstances. The row titled `〜ようにも〜れない` must visibly show the `〜れない` side; otherwise it collapses into the broader `〜ようにも` row and recreates template-level indistinction.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_16:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_16:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_16:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_16:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_16:007`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `155/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-116 - Keep natural flow, immediacy, and prevention patterns distinct
- Date: 2026-05-22
- Decision: In Directive E batch 016, re-author `〜がままに`, `〜が早いか`, `〜くらいなら`, `〜ことなしに`, and `〜ことのないように`; repair weak examples that obscured attachment or naturalness.
- Rationale: These rows are easy to flatten into generic condition/connector prose, but their cores are separate: letting a state flow, immediate sequence, aversive preference, omission of a necessary action, and preventive target. Example fixes keep the grammar visible instead of relying on English/Vietnamese paraphrase to carry the lesson.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_16:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_16:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_17:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_17:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_17:003`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `160/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-117 - Preserve absentminded-action and instant-sequence nuance
- Date: 2026-05-22
- Decision: In Directive E batch 017, re-author `〜ときりがない`, `〜ともなく`, `〜ともなしに`, `〜なり`, and `〜にとどまらず`; replace weak examples for endless listing and absentminded action.
- Rationale: `ともなく`/`ともなしに` need perception or light action without intent, not generic conditional prose. `なり` and `が早いか` also sit near each other, so the explanation now marks instant sequence without turning `なり` into an ordinary `すぐに` gloss.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_17:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_17:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_17:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_17:007`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_17:008`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `165/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-118 - Keep prohibitive classical forms out of generic modality
- Date: 2026-05-22
- Decision: In Directive E batch 018, re-author `〜にはあたらない`, `〜にも`, `〜ようにも〜れない`, `〜べからざるNoun`, and `〜べからず`; retitle the blocked-volition row to match its `ようにも〜れない` examples.
- Rationale: `にはあたらない` is an evaluative "not worth/not necessary" frame, while `にも` marks conditions needed even to do A. The `べからず` family needs classical-prohibition guidance, not a generic final-particle or question explanation.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_17:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_17:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_18:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_18:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_18:003`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `170/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-119 - Separate formal purpose, impossibility, unnecessary action, rules, and instant sequence
- Date: 2026-05-22
- Decision: In Directive E batch 019, re-author `〜べく`, `〜べくもない`, `〜までもない`, `〜ものとする`, and `〜や否や`; replace `〜ものとする` examples with rule-style verb obligations.
- Rationale: The five rows can be flattened by generic purpose/connector advice, but they teach distinct cores: classical formal purpose, complete impossibility, action beyond what is necessary, regulation-style obligation, and immediate sequence. `ものとする` especially needs legal/rule verb frames, not noun classification with `とする`.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_18:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_18:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_18:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_18:007`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_18:008`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `175/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-120 - Keep result judgment, negative tendency, duration uncertainty, ability, and surprise turns separate
- Date: 2026-05-22
- Decision: In Directive E batch 020, re-author `〜始末だ`, `〜嫌いがある`, `いつまで〜のやら`, potential `〜が Verbられる`, and `〜かと思いきや`; fix one tense-mismatched `〜かと思いきや` example.
- Rationale: Generic connector guidance hid five unrelated grammar operations: a disappointing final result, a criticized tendency, uncertainty about duration, potential morphology with `が`, and an expectation overturned by a later fact. The example fix keeps `かと思いきや` as a coherent surprise turn instead of mixing “tomorrow” with a past event.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_18:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_18:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_19:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_19:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_19:003`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `180/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-121 - Separate formal reason, noun-linked cause, full-range scope, literary simile, and humble premise
- Date: 2026-05-22
- Decision: In Directive E batch 021, re-author `〜がゆえに`, `〜がゆえのN`, `AからBに至るまで`, `〜ごとく`, and `〜こととて`; correct `〜ごとく` structure and replace weak `〜こととて` examples.
- Rationale: These rows were being collapsed into generic `の`/`か` advice. `がゆえに` leads a formal reason clause, `がゆえの` attaches that cause to a noun, `に至るまで` marks a full range reaching an endpoint, `ごとく` is a classical simile, and `こととて` is a formal/humble premise often used for apology or circumstance.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_19:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_19:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_19:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_19:007`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_19:008`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `185/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-122 - Separate avoid-doing, invariant stance, hypotheses, paired emotion triggers, and confused alternatives
- Date: 2026-05-22
- Decision: In Directive E batch 022, re-author `〜ずにすんだ`, `〜だろうとなかろうと`, `AにせよBにせよ`, `AにつけBにつけ`, and `AのやらBのやら`.
- Rationale: These rows all involve negation or alternatives, but their teaching cores differ: avoiding an unwanted action, preserving a stance regardless of A/not-A, treating A/B as formal hypotheses, attaching the same feeling to both cases, and being unable to tell which alternative is true.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_19:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_19:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_2:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_2:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_2:003`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `190/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-123 - Separate repeated-noun rhetoric from foundation and occasion-pair suffixes
- Date: 2026-05-22
- Decision: In Directive E batch 023, re-author `NがNならMもMだ`, `NもNならMもMだ`, `AあってのB`, `〜かたがた`, and `〜がてら`.
- Rationale: Generic `の` or connector prose hides three different mechanisms: repeated-noun patterns make a rhetorical evaluation, `あっての` marks an indispensable base, and `かたがた`/`がてら` both combine actions but differ sharply in formality and social register.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_2:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_2:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_2:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_2:007`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_2:008`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `195/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-124 - Separate large-quantity minimums, evidence-based judgment, intention, mindset, and unresolved responsibility
- Date: 2026-05-22
- Decision: In Directive E batch 024, re-author `〜からある`, `〜からすると`, `〜つもりだ`, `〜つもりで`, and `〜ではすまない`; repair one malformed `ではすまない` example.
- Rationale: These rows had generic particle/tense advice masking separate learner decisions: `からある` marks an impressive minimum quantity, `からすると` turns a noun into evidence, `つもりだ` can be intention or self-perception, `つもりで` carries that mindset into a later action, and `ではすまない` says a matter cannot be settled at the stated level.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_2:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_2:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_20:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_20:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_20:003`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `200/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-125 - Separate special-circumstance cause, strong condition, formal concession, and two exclamation registers
- Date: 2026-05-22
- Decision: In Directive E batch 025, re-author `〜とあって`, `〜とあれば`, `〜といえども`, `〜といったらありはしない`, and `〜といったらありゃしない`; repair one `ありゃしない` example.
- Rationale: The rows share visible `と`, but teach different operations: a noteworthy existing circumstance, a condition strong enough to trigger action, a formal concession, a full-register extreme exclamation, and its contracted colloquial counterpart.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_20:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_20:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_20:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_20:007`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_20:008`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `205/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-126 - Separate compact exclamation, notable-state framing, interrupted timing, accepted view, and futile assumption
- Date: 2026-05-22
- Decision: In Directive E batch 026, re-author `〜といったらない`, `〜ときている`, `〜ところを`, `〜とされる`, and `〜としたところで`; fix two `〜といったらない` examples.
- Rationale: These rows reuse common particles but drive different reading decisions: compact extreme exclamation, a notable state with a negative lean, timing that is interrupted or inconvenienced, a passive accepted-view frame, and a hypothetical concession whose result remains weak or unchanged.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_20:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_20:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_21:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_21:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_21:003`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `210/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-127 - Separate assumption families and situation-threshold conditionals
- Date: 2026-05-22
- Decision: In Directive E batch 027, re-author `〜とすると`, `〜とすれば`, `〜となったら`, `〜となると`, and `〜となれば`.
- Rationale: These forms look like minor variants of `と/なる/する`, but they mark different reasoning moves: building a logical assumption, opening a possible condition, reacting once a situation has become A, describing natural consequence when A becomes relevant, and deciding what follows if A reaches a threshold.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_21:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_21:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_21:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_21:007`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_21:008`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `215/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-128 - Separate reported information, concession, evidence, reports, and viewpoint
- Date: 2026-05-22
- Decision: In Directive E batch 028, re-author `〜とのことだ`, `〜とはいえ`, `〜とみえて`, `〜とみられる`, and `〜とみると`; repair one malformed `〜とみると` example.
- Rationale: The five rows all contain visible `と`, but they teach different learner choices: reporting received information, conceding before a counter-expectation, inferring from observable signs, using objective report-style judgment, and choosing a viewpoint/classification frame. The example fix changes a false `視点でとみると` attachment into a real `AをBとみると` frame.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_21:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_22:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_22:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_22:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_22:004`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `220/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-129 - Separate degree concession, implied speech, and two nagara frames
- Date: 2026-05-22
- Decision: In Directive E batch 029, re-author `どんなに〜うが`, `〜と言わんばかりに`, `〜と言わんばかりのN`, `〜ながらに`, and `〜ながらのN`; repair four examples whose `言わんばかり` shape did not match the row.
- Rationale: These rows were generic `か/の` filler despite teaching distinct operations: degree concession with invariant result, adverbial implied speech, nominal implied speech, fixed-state `ながらに`, and noun-modifying simultaneous action. The example repairs keep `に` rows tied to actions and `の` rows tied to nouns.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_22:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_22:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_22:007`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_22:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_22:009`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `225/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-130 - Separate concessive nagara, double-negative softness, own-way scope, and unnecessary reach
- Date: 2026-05-22
- Decision: In Directive E batch 030, re-author `〜ながらも`, `〜なくはない`, `〜なくもない`, `〜なら〜なりに`, and `〜には及ばない`; repair malformed `ながらも`, `なくはない`, `なくもない`, and `には及ばない` examples.
- Rationale: `ながらも` is concessive, not a generic state connector. `なくはない` and `なくもない` are both double negatives but differ in contrast versus soft possibility. `なら〜なりに` evaluates within X's own scope, while `には及ばない` says the action does not need to reach that level. Example repairs remove false `V辞書形 + なくもない` and unnatural `降っているながらも`.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_22:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_23:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_23:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_23:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_23:004`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `230/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-131 - Separate worthiness, endurance, process endpoint, and optimal choice
- Date: 2026-05-22
- Decision: In Directive E batch 031, re-author `〜に堪えない`, `〜に堪える`, `〜に耐える`, `〜に至った`, and `〜に越したことはない`; repair one `〜に至った` example to show a process reaching a verb endpoint.
- Rationale: The batch contains near-homophones and endpoint advice that collapse easily under generic negative guidance. `堪える` is worthiness or capacity for evaluation, `耐える` is endurance against hardship, `に至った` requires a process-to-result path, and `に越したことはない` is optimal advice rather than obligation.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_23:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_23:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_23:007`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_23:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_23:009`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `235/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-132 - Separate formal ease of inference, sole notable case, regret, and bita-biru suffixes
- Date: 2026-05-22
- Decision: In Directive E batch 032, re-author `〜に難くない`, `〜のはNぐらいのものだ`, `〜ば〜ものを`, `〜びた`, and `〜びる`; polish `〜びた/〜びる` examples and romaji.
- Rationale: These rows were masking separate operations: formal “not hard to infer”, limited-only evaluation, counterfactual regret, adjectival suffix state, and verbal suffix process. The `びた/びる` split is especially important because `びた` modifies nouns while `びる` behaves as a verb.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_23:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_24:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_24:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_24:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_24:004`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `240/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-133 - Separate buru inflections, elapsed-time buri, and made-da limit/resolve
- Date: 2026-05-22
- Decision: In Directive E batch 033, re-author `〜ぶった`, `〜ぶって`, `〜ぶり`, `〜ぶる`, and `〜までだ`; repair malformed `ぶった/ぶって/ぶる` examples and add a `Vるまでだ` resolve example.
- Rationale: The `ぶる` family needs different syntax per inflection: `ぶった` modifies nouns, `ぶって` links to a following action, and `ぶる` is the base verb for putting on airs. `ぶり` marks elapsed time since the last occurrence, while `までだ` can be either a hard limit or the final fallback action.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_24:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_24:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_24:007`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_24:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_24:009`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `245/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-134 - Separate emphatic dismissal, assumption premise, classical purpose, near-action, and formal no-obstacle permission
- Date: 2026-05-22
- Decision: In Directive E batch 034, re-author `〜もなんでもない`, `〜ものとして`, `〜んがために`, `〜んばかりに`, and `〜差し支えない`; repair malformed example Japanese in all five rows where needed.
- Rationale: These rows require distinct syntax: `でもなんでもない` emphatically rejects a label, `ものとして` sets a premise, `んがために` is classical purpose, `んばかりに` describes being near the threshold of an action, and `差し支えない` is formal no-obstacle permission. Example repairs remove direct verb attachment before `もなんでもない`, false `Nのものとして`, weak `んばかりに`, and an unnatural `ことが差し支えない`.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_24:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_25:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_25:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_25:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_25:004`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `250/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-135 - Separate occasion timing, extreme degree, insufficiency, and worthiness
- Date: 2026-05-22
- Decision: In Directive E batch 035, re-author `〜折に`, `〜極まりない`, `〜極まる`, `〜足りない`, and `〜に足る + Noun`.
- Rationale: These rows had generic の/negative filler despite distinct teaching operations: `折に` marks a formal occasion, `極まりない` and `極まる` mark extreme evaluation with different imagery, `足りない` measures shortage against a standard, and `に足る` certifies worthiness or sufficiency.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_25:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_25:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_25:007`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_25:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_25:009`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `255/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-136 - Separate emotional limit, opening-series, formal dual-purpose, and threshold state
- Date: 2026-05-22
- Decision: In Directive E batch 036, re-author `〜限りだ`, `Noun を皮切りに / を皮切りにして`, `Noun かたがた`, `Noun ともなると`, and `Noun を皮切りにして`; repair one `ともなると` example to use a noun threshold.
- Rationale: The batch spans different learner decisions: `限りだ` is emotional fullness, `皮切りに` opens a sequence, `かたがた` carries formal dual-purpose/social-register nuance, and `ともなると` marks a status/season/level threshold where conditions change.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_25:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_26:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_26:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_26:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_27:001`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `260/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-137 - Separate casual side-purpose, threshold condition, involuntary emotion, large-number emphasis, and synergy
- Date: 2026-05-22
- Decision: In Directive E batch 037, re-author `Noun がてら`, `Noun ともなれば`, `Noun を禁じ得ない`, `Number + Counter + からある`, and `Noun と相まって`.
- Rationale: These rows share noun attachments but require different operational readings: casual “while/incidentally”, conditional threshold, emotion that cannot be suppressed, minimum-large-number emphasis, and two-factor synergy.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_27:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_27:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_28:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_28:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_28:003`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `265/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-138 - Separate route/process, evidence judgment, indispensable condition, source modifier, and perspective speech
- Date: 2026-05-22
- Decision: In Directive E batch 038, re-author `Noun を経て`, `Noun からする`, `Noun なくして〜はない`, `Noun からの`, and `Noun から言わせれば`.
- Rationale: These rows require distinct source/path logic: `を経て` marks a route or process before a result, `からする` uses evidence as a basis for judgment, `なくして〜はない` states an indispensable condition, `からの` makes a source modifier, and `から言わせれば` stages a source viewpoint as speech.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_29:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_29:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_29:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_3:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_3:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `270/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-139 - Separate whole-group suffix, koso concession/emphasis, and literary simile
- Date: 2026-05-22
- Decision: In Directive E batch 039, re-author `Noun + ぐるみ`, `Noun こそあれ`, `Noun こそ〜が`, `Noun こそすれ`, and `Noun ごとき / Noun ごとく`.
- Rationale: These rows were generic filler but teach separate register and logic moves: whole-group involvement, concessive admission, emphatic contrast, X-not-Y contrast, and classical/literary simile.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_3:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_3:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_3:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_3:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_3:007`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `275/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-140 - Separate colloquial rebuttal, all-of-one-kind, unresolved consequence, considered basis, and intention
- Date: 2026-05-22
- Decision: In Directive E batch 040, re-author `Noun じゃあるまいし`, `Noun ずくめ`, `Noun だけではすまない`, `Noun を踏まえて`, and `〜つもりだ`.
- Rationale: These rows need distinct learner cues: rejecting an assumption in colloquial speech, “nothing but” coverage, consequences not settled by only N, decisions based on considered facts, and intention/self-assumption nuance.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_3:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_3:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_3:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_30:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_30:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `280/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-141 - Separate indispensable absence, endpoint limit, intention stance, and level equivalence
- Date: 2026-05-22
- Decision: In Directive E batch 041, re-author `Noun なしでは〜ない`, `Noun を限りに`, `〜つもりで`, `Noun なしには〜ない`, and `Noun 並み`.
- Rationale: These rows require separate condition and comparison logic: missing indispensable conditions, a final endpoint/change marker, an intention-as-stance frame, a stronger absence condition, and equivalence to a standard level.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_30:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_31:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_31:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_31:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_32:001`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `285/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-142 - Separate unresolved consequence, exception comparison, premise, event cause, and uniqueness
- Date: 2026-05-22
- Decision: In Directive E batch 042, re-author `〜ではすまない`, `Noun ならいざ知らず`, `Noun + 前提で`, `〜とあって`, and `Noun + ならでは`; repair one `ではすまない` example to use `だけではすまない`.
- Rationale: These rows were still using generic function-label filler. The batch now distinguishes unresolved consequences, comparison between an acceptable exception and a rejected case, planned assumptions, special-event causation, and uniqueness/value that only a source noun can produce.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_32:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_32:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_33:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_33:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_33:003`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `290/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-143 - Separate boundary condition, decisive condition, alternatives, side task, and formal concession
- Date: 2026-05-22
- Decision: In Directive E batch 043, re-author `Verbる / Noun(である) + 限り(は)`, `〜とあれば`, `Noun なり Noun なり`, `Verb がてら`, and `〜といえども`.
- Rationale: The rows now teach five different learner operations: condition bounded by `限`, condition strong enough to invite a response, representative alternatives, doing a side task on the occasion of another action, and formal concession from `と言えども`.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_34:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_34:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_34:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_35:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_35:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `295/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-144 - Separate minimum amount, emphatic X-not-Y, extreme exclamation, accumulation, and causative-passive force
- Date: 2026-05-22
- Decision: In Directive E batch 044, re-author `Noun なりとも`, `Verb こそすれ`, `〜といったらありはしない`, `Noun に Noun を重ねて`, and `Verb させられる`; repair one `こそすれ` example so the rejected action contrasts with helping.
- Rationale: These rows now distinguish a minimum acceptable noun, emphatic action X with Y denied, written extreme exclamation, literal layer-by-layer accumulation via `重ねる`, and the two-layer causative-passive force of `させられる`.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_35:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_36:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_36:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_36:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_37:001`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `300/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-145 - Separate colloquial extreme exclamation, special context, no-choice necessity, peak degree, and unbecoming conduct
- Date: 2026-05-22
- Decision: In Directive E batch 045, re-author `〜といったらありゃしない`, `Noun にあっては`, `Verb ざるを得ない`, `〜といったらない`, and `Noun にあるまじき Noun`; repair awkward `といったら` examples in lessons 37 and 38.
- Rationale: The rows now distinguish colloquial extreme degree, formal context framing, necessity forced by circumstances through `ざる` plus `得ない`, peak emotional degree, and role-based moral criticism using classical `まじき`.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_37:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_37:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_38:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_38:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_38:003`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `305/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-146 - Separate missed completion, notable condition, N-standard surprise, absolute minimum negation, and role standard
- Date: 2026-05-22
- Decision: In Directive E batch 046, re-author `Verb ずじまい`, `〜ときている`, `Noun にして`, `Noun たりとも〜ない`, and `Noun たる Noun`.
- Rationale: The rows now distinguish regretful non-completion via `ず` plus `しまい`, a situation that has reached a notable state, surprise measured against an N standard, absolute negation of even a minimum unit, and the role/responsibility standard carried by classical `たる`.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_39:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_39:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_39:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_4:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_4:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `310/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-147 - Separate formal even, rhetorical assertion, rejected assumption, dual-role function, and paired-aspect evaluation
- Date: 2026-05-22
- Decision: In Directive E batch 047, re-author `Noun ですら`, `Noun でなくてなんだろう`, `Noun ではあるまいし`, `Noun と Noun を兼ねて`, and `Noun といい Noun といい`.
- Rationale: The rows now distinguish formal even-focus, assertion through rhetorical question, dismissal of an assumed premise, simultaneous dual purpose/role via `兼ねる`, and two cited aspects feeding one evaluation.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_4:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_4:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_4:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_4:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_4:007`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `315/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-148 - Separate naming, approximate evaluation, generic concept, unnecessary action, and interrupted moment
- Date: 2026-05-22
- Decision: In Directive E batch 048, re-author `Noun という Noun`, `Noun というところだ`, `Noun + というもの`, `Verb ずとも`, and `〜ところを`; repair `ずとも` examples to use verb-negative stems.
- Rationale: The rows now distinguish naming a concrete noun, placing an estimate on a scale, widening to the concept called N, removing an unnecessary action via `ずとも`, and an action hitting a specific `ところ` moment.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_4:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_4:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_4:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_40:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_40:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `320/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-149 - Separate threshold realization, inevitable action, accepted-view passive, even-to focus, and unsettled obligation
- Date: 2026-05-22
- Decision: In Directive E batch 049, re-author `Noun にして初めて`, `Verb ずにはおかない`, `〜とされる`, `Noun にすら`, and `Verb ずにはすまない`.
- Rationale: The rows now distinguish a noun threshold unlocking first realization, action that cannot be left undone, passive accepted-view reporting, `に` plus even-focus, and obligation where not doing V leaves matters unsettled.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_40:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_41:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_41:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_41:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_42:001`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `325/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-150 - Separate futile assumption, scope expansion, appearance-based unlikelihood, logical assumption, and strong contrast
- Date: 2026-05-22
- Decision: In Directive E batch 050, re-author `〜としたところで`, `Noun にとどまらず〜も`, `Verb そうにない`, `〜とすると`, and `Noun にひきかえ Noun は`; repair one `そうにない` example subject.
- Rationale: The rows now distinguish an assumption whose result remains futile, scope that does not stop at N, evidence-based unlikelihood from `そう`, logical assumption via `とする`, and a strong contrast turn from `引き換え`.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_42:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_42:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_43:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_43:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_43:003`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `330/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-151 - Separate near-impossibility, hypothesis, comparison increase, immediate recurrence, and formed-situation condition
- Date: 2026-05-22
- Decision: In Directive E batch 051, re-author `Verb そうもない`, `〜とすれば`, `Noun にもまして`, `Verb そばから`, and `〜となったら`.
- Rationale: The rows now distinguish appearance-based near-impossibility with emphatic `も`, hypothesis as a reasoning setup, comparison that increases beyond an old benchmark, immediate recurrence from `側`, and a condition where a situation has already become X.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_44:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_44:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_44:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_45:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_45:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `335/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-152 - Separate criterion independence, irreversible trigger, threshold topic, forerunner timing, and agreed-fiction request
- Date: 2026-05-22
- Decision: In Directive E batch 052, re-author `Noun によらず`, `Verb たが最後`, `〜となると`, `Noun に先駆けて`, and `Verb たことにしてください`.
- Rationale: The rows now distinguish non-dependence on a criterion from `依る`, a one-way consequence trigger from `最後`, a topic/threshold that changes conditions, a forerunner action from `先駆`, and a polite request to treat an event as already true through `ことにしてください`.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_45:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_46:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_46:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_46:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_47:001`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `340/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-153 - Separate threshold condition, standards-aligned modifier, branch-specific downside, reported information, and standards-aligned action
- Date: 2026-05-22
- Decision: In Directive E batch 053, re-author `〜となれば`, `Noun に即した Noun`, `Verb たら Verb たで`, `〜とのことだ`, and `Noun に即して Verb`.
- Rationale: The rows now distinguish a condition once matters become X, noun modification that adheres to a standard, branch-specific cost after a repeated `た` condition, formal reported information, and action aligned tightly with rules/reality through `即`.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_47:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_47:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_48:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_48:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_48:003`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `345/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-154 - Separate endless sequence, concession brake, speaker viewpoint, approximate ceiling, and all-over sweep
- Date: 2026-05-22
- Decision: In Directive E batch 054, re-author `Verb たら きりがない`, `〜とはいえ`, `Noun に言わせれば`, `Noun といったところだ`, and `Noun といわず Noun といわず`.
- Rationale: The rows now distinguish an action chain with no cut-off point, a concession that limits the accepted premise, viewpoint through a named speaker, approximate ceiling by `ところ`, and a full-scope sweep created by repeated `言わず`.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_49:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_49:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_49:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_5:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_5:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `350/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-155 - Separate emotional topic callout, incomparable gap, role-based reproach, stage-change consequence, and threshold condition
- Date: 2026-05-22
- Decision: In Directive E batch 055, re-author `Noun + ときたら`, `Noun とは比べものにならない`, `Noun + ともあろう + Noun`, `Noun ともなると`, and `Noun ともなれば`.
- Rationale: The rows now distinguish topic callout with emotion from `来る`, a comparison gap too large to become a `比べもの`, reproach from an expected role, a stage where conditions change, and a serious threshold condition with natural consequences.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_5:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_5:004`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_5:005`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_5:006`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_5:007`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `355/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-156 - Separate synergy, indispensable absence, direct absence condition, irreversible last point, and evidence-based appearance
- Date: 2026-05-22
- Decision: In Directive E batch 056, re-author `Noun と相まって`, `Noun なくして～はない`, `Noun なしでは～ない`, `Verb たら最後`, and `〜とみえて`.
- Rationale: The rows now distinguish mutual synergy from `相`, formal indispensable absence, direct absence as a condition, an irreversible last boundary from `最後`, and visual/evidential inference from `見える`.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_5:008`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_5:009`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_5:010`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_50:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_50:002`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `360/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.

## DECISION-157 - Separate scope expansion, alternating action, objective assessment, soft scope expansion, and sustained aftershock
- Date: 2026-05-22
- Decision: In Directive E batch 057, re-author `Noun に限ったことではない`, `Verb つ Verb つ`, `〜とみられる`, `Noun に限ったことでもない`, and `Verb てからというもの`.
- Rationale: The rows now distinguish a boundary being denied by `限る`, alternating old-style action with repeated `つ`, objective/reporting assessment from passive `見られる`, softer scope denial with `でもない`, and a post-event state that keeps running after the initial `てから` mốc.
- Verification: `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_50:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_51:001`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_51:002`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_51:003`; `node tool/qa/validate_directive_e_quality.js --item-id grammar:n1:grammar_n1_52:001`; `node tool/qa/validate_directive_e_quality.js --rank-json assets/data/content/exercises/top_200_frequency_rank.json`; global validator progress `365/1123`; `node --test test/tool/research/directive_e_quality_validator_test.js`; `flutter test test/data/upper_jlpt_content_integrity_test.dart test/data/utils/grammar_example_quality_test.dart test/features/grammar/grammar_detail_screen_test.dart --reporter expanded`; `git diff --check`.
