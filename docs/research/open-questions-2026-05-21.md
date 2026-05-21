# Open Questions - 2026-05-21 Megaprompt Overhaul

Autonomous overnight mission log. Blocking questions are skipped around when possible.

## OQ-001 - Directive E source text is missing
**Phase**: 0
**Date**: 2026-05-21 00:00
**Blocking**: no
**Default action taken**: Appended Directive F after the existing directive block and did not fabricate Directive E.
**Owner answer**: pending

## OQ-002 - Exact publisher lesson/theme names
**Phase**: 1
**Date**: 2026-05-21 00:00
**Blocking**: no
**Default action taken**: Use conservative textbook labels from existing app/source references, mark unclear titles as `needs-owner-title-review`, and preserve old lesson IDs during dual-read.
**Owner answer**: pending

## OQ-003 - Legal clearance for owner-provided textbook facts
**Phase**: 1
**Date**: 2026-05-21 00:00
**Blocking**: no
**Default action taken**: Extract only facts and citations for internal verification; do not copy long examples, explanations, layouts, or mnemonics.
**Owner answer**: pending

## OQ-004 - Reading comprehension source mix
**Phase**: 4
**Date**: 2026-05-21 00:00
**Blocking**: no
**Default action taken**: Prefer original JpStudy passages and paraphrased/link-only references where needed, with no official JLPT question reuse.
**Owner answer**: pending

## OQ-005 - Mimikara extraction timing
**Phase**: 1
**Date**: 2026-05-21 00:00
**Blocking**: no
**Default action taken**: Created Mimikara N1-N5 textbook records with `migration_status: planned_source_pending`; real lesson files wait for the offline canonical extraction pipeline.
**Owner answer**: pending

## OQ-006 - Lesson rows do not have a dedicated example field
**Phase**: 3
**Date**: 2026-05-21 07:14
**Blocking**: no
**Default action taken**: Flashcard context mode uses sourced mnemonic/context text when available and falls back to the localized meaning. Phase 4 exercise/reading assets should provide real sentence examples.
**Owner answer**: pending

## OQ-007 - Authored uniqueness threshold for generated repetitions
**Phase**: 4
**Date**: 2026-05-21 07:55
**Blocking**: no
**Default action taken**: Grammar ExerciseBank uses deterministic variants to reach >=50 exercises per item while preserving validator uniqueness by prompt/signature. Later authored/static generation should replace repeated variants where source examples allow.
**Owner answer**: pending

## OQ-008 - Human review depth for generated reading corpus
**Phase**: 4
**Date**: 2026-05-21 08:20
**Blocking**: no
**Default action taken**: Shipped original JpStudy reading passages with level-length validation and 3-question sets per passage; mark owner review pending for pedagogical nuance, not copyright clearance.
**Owner answer**: pending
