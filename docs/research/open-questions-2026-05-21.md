# Open Questions - 2026-05-21 Megaprompt Overhaul

Autonomous overnight mission log. Blocking questions are skipped around when possible.

## OQ-001 - Directive E source text is missing
**Phase**: 0
**Date**: 2026-05-21 00:00
**Blocking**: no
**Default action taken**: Appended Directive F after the existing directive block and did not fabricate Directive E.
**Owner answer**: RESOLVED 2026-05-21 — Owner asked Claude to author Directive E (Pedagogy & Human Voice). Directive E now lives in `docs/agent-directives.md` between Directive D and Directive F. Codex's default action (skip without fabricating) was the correct safe choice. Apply Directive E to all future explanation/mnemonic/etymology content per the persona Dr. Linh-Phan-Trần and 7 sub-rules E.1-E.7.

## OQ-002 - Exact publisher lesson/theme names
**Phase**: 1
**Date**: 2026-05-21 00:00
**Blocking**: no
**Default action taken**: Use conservative textbook labels from existing app/source references, mark unclear titles as `needs-owner-title-review`, and preserve old lesson IDs during dual-read.
**Owner answer**: CONFIRMED 2026-05-21 — Default action approved. Keep `needs-owner-title-review` tag on uncertain titles; owner will batch-review and correct them once canonical extraction (QA-A-030) surfaces the authoritative publisher names from owner-provided PDFs.

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
**Owner answer**: CONFIRMED 2026-05-21 — Original JpStudy passages + paraphrased/link-only references is the correct policy. Never reuse official JLPT exam questions (copyright + leak risk). NHK Easy News allowed via paraphrase + link-only, never verbatim. Per Directive E.5 Research Ladder, escalate to owner only when both original-authoring and licensed paraphrase fail.

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

## OQ-009 - Full KANJIVG diff for upper-level lookalikes
**Phase**: 4
**Date**: 2026-05-21 09:12
**Blocking**: no
**Default action taken**: Used bundled kanji decomposition plus known visual pairs, rejected stroke-only pairs, and kept the report owner-reviewable. A later quality pass can import full KANJIVG vectors for N3-N1 if owner wants pixel-distance lookalike ranking.
**Owner answer**: pending

## OQ-010 - Static graph detail routes for vocab and grammar ids
**Phase**: 5
**Date**: 2026-05-21 09:25
**Blocking**: no
**Default action taken**: Graph nodes use stable semantic IDs and route to existing non-empty hub/detail-capable surfaces (`/vocab`, `/grammar`, `/kanji/:char/graph`, `/grammar/conjugation`, `/jlpt/reading`). Later UI loaders can resolve semantic IDs to DB numeric detail ids once ContentDB is ready.
**Owner answer**: pending

## OQ-011 - Missing Mimikara unit files in local folder
**Phase**: P1 QA-A-030 Phase 0
**Date**: 2026-05-21 15:32
**Blocking**: no
**Default action taken**: Extract only local files that exist. N1 currently lacks units `6` and `10`; N2 currently lacks units `5` and `9`. Log gaps in the canonical report rather than fabricating rows.
**Owner answer**: pending

## OQ-012 - No N1 kanji-vocab folder in `Tu Vung`
**Phase**: P1 QA-A-030 Phase 0
**Date**: 2026-05-21 15:32
**Blocking**: no
**Default action taken**: Do not create `kanji-vocab-n1.md` from another source. Use Mimikara N1 and existing app vocab first, then JMdict fallback only where needed.
**Owner answer**: pending

## OQ-013 - Grammar source coverage in `Tu Vung` root
**Phase**: P1 QA-A-030 Phase 0
**Date**: 2026-05-21 15:32
**Blocking**: no
**Default action taken**: Proceed vocab-first for Phase 1. If grammar facts are not present in these files, run a separate local-folder inventory before grammar app mutation.
**Owner answer**: pending
