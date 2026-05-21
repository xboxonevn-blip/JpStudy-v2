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
**Owner answer**: CONFIRMED 2026-05-21 — Facts-only is safest. Hold this policy through beta. If publisher clearance arrives later, expand scope incrementally per item.

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
**Owner answer**: CONFIRMED 2026-05-21 — Default action approved with DEADLINE **2026-05-22**. Mimikara N1-N5 must be live (not `planned_source_pending`) by end of day 2026-05-22 so beta ships with full textbook coverage.

## OQ-006 - Lesson rows do not have a dedicated example field
**Phase**: 3
**Date**: 2026-05-21 07:14
**Blocking**: no
**Default action taken**: Flashcard context mode uses sourced mnemonic/context text when available and falls back to the localized meaning. Phase 4 exercise/reading assets should provide real sentence examples.
**Owner answer**: HYBRID (a)+(c) — Apply BOTH: (a) Migrate vocab schema to add `example_sentences[]` field; (c) Pull 1-2 examples from `examples_corpus.json` (Phase 4) to populate that field for every vocab item. Flashcard back side shows 1-2 example sentences inline (no need to switch mode). Apply across all levels N5-N1 and all textbooks (Mina I/II, Hajimete, Mimikara N1-N5, Shin Kanzen).

## OQ-007 - Authored uniqueness threshold for generated repetitions
**Phase**: 4
**Date**: 2026-05-21 07:55
**Blocking**: no
**Default action taken**: Grammar ExerciseBank uses deterministic variants to reach >=50 exercises per item while preserving validator uniqueness by prompt/signature. Later authored/static generation should replace repeated variants where source examples allow.
**Owner answer**: OPTION (b) 2026-05-21 — Raise uniqueness threshold for ALL items, not just top 200. Codex must author hand-crafted templates FIRST (multiple genuine angles per item: form, meaning, usage, context, contrast), THEN apply variant generation only if hand-crafted templates exhaust under 50. Owner accepts longer runtime for higher per-question quality. Apply Directive E.3 Multi-Perspective to template authoring. Quality target: a learner cannot pass 50 questions by pattern-matching surface features; must actually understand the item.

## OQ-008 - Human review depth for generated reading corpus
**Phase**: 4
**Date**: 2026-05-21 08:20
**Blocking**: no
**Default action taken**: Shipped original JpStudy reading passages with level-length validation and 3-question sets per passage; mark owner review pending for pedagogical nuance, not copyright clearance.
**Owner answer**: SCALE-UP 2026-05-21 — Online sources have abundant reading material. Copy from whitelisted sources OR author original is acceptable. NO owner review required. NEW REQUIREMENT: EVERY lesson in Mina I, Mina II, Hajimete Tango N5/N4, Shin Kanzen N3/N2/N1 must have ≥ 2 LONG, QUALITY reading-comprehension passages.

Source policy (per OQ-004 + Directive E.5 Research Ladder):
- Tatoeba (CC-BY 2.0) — verbatim copy OK with attribution
- Aozora Bunko (public domain Japanese literature) — verbatim copy OK
- Wikipedia/Wiktionary JA (CC-BY-SA) — paraphrase OK
- NHK Easy News — paraphrase + link-only, never verbatim
- Original Codex authoring — always OK, must pass Directive E.7 Teaching Test

Scope estimate: Mina I (25 × 2 = 50) + Mina II (25 × 2 = 50) + Hajimete N5 (50 sub-lessons × 2 = 100) + Hajimete N4 (50 × 2 = 100) + Shin Kanzen N3 (83 × 2 = 166) + Shin Kanzen N2 (163 × 2 = 326) + Shin Kanzen N1 (88 × 2 = 176) = ~968 passages total. Currently 80 exist; need ~888 more. Codex autonomous-author per Directive E.4 Human Moment + E.7 Teaching Test as quality gate. Validator must reject passages < target length per level + passages without 3 comprehension Qs.

## OQ-009 - Full KANJIVG diff for upper-level lookalikes
**Phase**: 4
**Date**: 2026-05-21 09:12
**Blocking**: no
**Default action taken**: Used bundled kanji decomposition plus known visual pairs, rejected stroke-only pairs, and kept the report owner-reviewable. A later quality pass can import full KANJIVG vectors for N3-N1 if owner wants pixel-distance lookalike ranking.
**Owner answer**: DEFER 2026-05-21 — Current 558 lookalikes cover N5-N3 use case well. N2-N1 learners have lower kanji confusion rate (already know many). Re-evaluate when user feedback flags accuracy issue.

## OQ-010 - Static graph detail routes for vocab and grammar ids
**Phase**: 5
**Date**: 2026-05-21 09:25
**Blocking**: no
**Default action taken**: Graph nodes use stable semantic IDs and route to existing non-empty hub/detail-capable surfaces (`/vocab`, `/grammar`, `/kanji/:char/graph`, `/grammar/conjugation`, `/jlpt/reading`). Later UI loaders can resolve semantic IDs to DB numeric detail ids once ContentDB is ready.
**Owner answer**: DEFER 2026-05-21 — Current click-to-hub navigation acceptable. Re-evaluate in Phase 2 polish after ContentDB unified.

## OQ-011 - Missing Mimikara unit files in local folder
**Phase**: P1 QA-A-030 Phase 0
**Date**: 2026-05-21 15:32
**Blocking**: no
**Default action taken**: Extract only local files that exist. N1 currently lacks units `6` and `10`; N2 currently lacks units `5` and `9`. Log gaps in the canonical report rather than fabricating rows.
**Owner answer**: ONLINE FILL 2026-05-21 — Claude verified `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Tu Vung/Tu Vung Mimikara N1/` and `Tu Vung Mimikara N2/` — confirmed N1 units 6+10 and N2 units 5+9 are NOT present locally. Owner authorizes Codex to fill these 4 gaps from whitelisted online sources (per Directive E.5 Research Ladder: JMdict, Tatoeba, Wiktionary, MEXT, Tofugu reference). MUST deduplicate against already-extracted entries by normalized term+reading hash. MUST strip brand attribution (existing local PDFs have `[thocodehoctiengnhat]` in filenames — never propagate to extracted content). Logged-source tag for filled entries: `online-whitelisted-fill-OQ011`.

## OQ-012 - No N1 kanji-vocab folder in `Tu Vung`
**Phase**: P1 QA-A-030 Phase 0
**Date**: 2026-05-21 15:32
**Blocking**: no
**Default action taken**: Do not create `kanji-vocab-n1.md` from another source. Use Mimikara N1 and existing app vocab first, then JMdict fallback only where needed.
**Owner answer**: CONFIRMED 2026-05-21 — Default action approved. Mimikara N1 + JMdict fallback covers N1 vocab adequately. Owner may add a dedicated N1 kanji-vocab source later if a specific gap is identified.

## OQ-013 - Grammar source coverage in `Tu Vung` root
**Phase**: P1 QA-A-030 Phase 0
**Date**: 2026-05-21 15:32
**Blocking**: no
**Default action taken**: Proceed vocab-first for Phase 1. If grammar facts are not present in these files, run a separate local-folder inventory before grammar app mutation.
**Owner answer**: FALLBACK 2026-05-21 — Claude verified `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/` root and confirmed NO dedicated grammar folder exists (only `Ebook`, `Kanji`, `Tu Vung`, `Trick tai tai lieu bi khoa`). Owner authorizes Codex to use: (1) existing app grammar data, (2) Tae Kim Grammar Guide (CC-BY-NC-SA, attribution required) as the grammar reference fallback per Directive E.5 Research Ladder. Apply Directive E.3 Multi-Perspective to grammar explanations (form / meaning / usage angles).
