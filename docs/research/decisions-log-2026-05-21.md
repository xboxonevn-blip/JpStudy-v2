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
