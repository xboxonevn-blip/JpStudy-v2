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
