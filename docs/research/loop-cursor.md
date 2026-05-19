# Loop Cursor

Updated: 2026-05-19

Current policy:
- Batch commits: about five lesson/data files per logical content batch.
- Content-only gate: focused DB/reachability/taxonomy/content-status/coverage + relevant guards + release build/deploy + rendered live UI proof.
- Full `flutter test`: once per completed level or non-trivial Dart logic change.
- No cache-disabled live proof as primary proof; use normal browser cache.
- Do not recheck closed QA-A-017 unless `firebase.json` changes.

Current position:
- QA-B-002 current N1 kanji lessons 01-25: source-verified, deployed, live-rendered; current-entry incomplete count `0`.
- QA-B-001 grammar: N2 lessons 01-20 source-verified, deployed, live-rendered; AppDatabase grammar reseed revision is `15`.
- Owner added new Conjugation feature requirement on 2026-05-19. Phase 0 research/design must produce `docs/research/conjugation-feature-design-2026-05-19.md` before implementation slices.
- Next batch after Phase 0 checkpoint: QA-B-001 grammar N2 lessons 21-25.
- Then continue grammar first across remaining N5-N1, then vocab.
- Deferred after QA-B-001: QA-B-002 expansion to JLPT-complete kanji coverage + 214 radicals.
