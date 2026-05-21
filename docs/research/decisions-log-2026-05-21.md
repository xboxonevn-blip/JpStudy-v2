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
