# Interlink Graph Design - 2026-05-21

## Mục tiêu

Make every detail page connected. A learner studying one item should immediately see related grammar, vocab, kanji, and conjugation forms.

## Bối cảnh

Directive D already requires connected flows. Directive F makes that explicit with a bidirectional graph and "Liên quan" section on every detail page.

The QA-A-029 kanji relationship graph handles visual kanji-component relations. This design adds a broader curriculum graph for all item types.

## Schema

`lib/data/interlink_graph.json`

```json
{
  "schema_version": 1,
  "generated_at": "2026-05-21T00:00:00+07:00",
  "nodes": {
    "grammar:n5:minna_n5:01:001": {
      "type": "grammar",
      "level": "N5",
      "textbook": "minna_n5",
      "lesson": "01",
      "label_ja": "N1 は N2 です",
      "label_vi": "N1 là N2",
      "route": "/learn/N5/minna_n5/minna_n5_01/grammar:n5:minna_n5:01:001"
    }
  },
  "edges": [
    {
      "from": "grammar:n5:minna_n5:01:001",
      "to": "vocab:n5:minna_n5:01:わたし",
      "rel": "uses",
      "weight": 1.0,
      "evidence": "example-scan"
    }
  ]
}
```

## Build pipeline

Tool: `tool/research/build_interlink_graph.js`.

Steps:

1. Load manifests and flat legacy content.
2. Create nodes for grammar, vocab, kanji, conjugation lemma/form, reading passage.
3. For grammar examples, tokenize Japanese text and match vocab/kanji.
4. For vocab, link contained kanji and conjugation lemma where POS supports it.
5. For kanji, link vocab containing the kanji and QA-A-029 component/related graph.
6. For conjugation, link forms back to vocab lemma and grammar patterns that require the form.
7. Emit forward and reverse edges.
8. Validate every route resolves.

## Related section UI

`lib/widgets/related_section.dart`

```text
RelatedSection(nodeId)
├── Grammar dùng item này
├── Vocab chứa item này
├── Kanji trong item này
├── Chia thể liên quan
└── Bài đọc dùng item này
```

Rules:

- max five rows per section
- "Xem tất cả" route if more exists
- hover/long-press preview
- no empty headings
- localized labels for VI/EN/JA

## Recommendation engine

`lib/services/recommendation_engine.dart`

Scoring:

```text
score = srsUrgency * 0.45 + graphWeight * 0.30 + lessonContinuity * 0.15 + novelty * 0.10
```

After a lesson or review, recommend:

1. due SRS linked to just-studied items
2. next lesson in the same textbook
3. cross-textbook similar pattern or weak related item

## Migration plan

1. Generate graph from current content.
2. Add static graph loader and tests.
3. Add `RelatedSection` to grammar, vocab, kanji, conjugation detail pages.
4. Add recommendation engine for lesson completion.
5. Add validator for route resolution and bidirectional coverage.

## Acceptance criteria

- `interlink_graph.json` exists with route-resolvable nodes and bidirectional edges.
- Every supported detail page renders "Liên quan" when links exist.
- No related row points to an empty/stub screen.
- Recommendation engine returns three actionable suggestions after lesson completion.
- `markKnown` self-attestation path is removed or throws.

## Open questions

- Edge count target 50,000 depends on final migrated item count; default is enforce no orphans first, then density target.
- Japanese tokenization may be heuristic without MeCab; default is surface/kanji matching plus known vocab dictionary.
