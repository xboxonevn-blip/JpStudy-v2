# Kanji Relationship Graph View Design - 2026-05-20

Ticket: QA-A-029  
Mode: AUTONOMOUS OVERNIGHT MODE - NO OWNER GATE  
Scope: Add a learner-facing graph view for kanji components, related kanji, SRS state, and cluster practice.  
Source policy: local app kanji assets only. No search/crawl/fetch/scrape of `nhaikanji.com` or `thocodehoctiengnhat.com`.

## Audit Summary

### Package

- Candidate package: `graphview`.
- Version from `dart pub add graphview --dry-run`: `1.5.1`.
- Local package audit path: `C:/Users/xboxo/AppData/Local/Pub/Cache/hosted/pub.dev/graphview-1.5.1/`.
- README states it supports Flutter web, small graphs, force-directed layout, tree/layered/circular/radial layouts, node builders, pan/zoom through `InteractiveViewer`, and automatic fit/reset through `GraphViewController`.
- API audit:
  - `GraphView.builder(...)` accepts `Graph`, `Algorithm`, node builder, `GraphViewController`, `autoZoomToFit`.
  - `FruchtermanReingoldAlgorithm` supports force-directed layouts.
  - `ArrowEdgeRenderer` draws directed arrows.
  - No first-class edge-label widget API was found; implement a small custom `EdgeRenderer` subclass that calls `super.renderEdge(...)` and paints short labels near edge midpoints using `TextPainter`.

### Existing App Touchpoints

- Routes: `lib/app/navigation/routes/kanji_routes.dart`.
- Route constants: `lib/app/navigation/app_route_constants.dart`.
- Kanji hub/detail: `lib/features/kanji_hub/kanji_hub_screen.dart` and `kanji_hub_screen_parts.dart`.
- Kanji copy: `lib/features/kanji_hub/kanji_copy.dart`.
- Review board: `lib/features/practice/practice_screen.dart` plus `lib/features/practice/providers/practice_session_board_provider.dart`.
- Kanji SRS: `lib/data/daos/kanji_srs_dao.dart`, especially `getStatesForIds`, `getDueKanjiIds`, and `recordReview`.
- Current detail is an `AlertDialog`, so the full graph should not be embedded there by default. A detail CTA should open a full route.

### Data Shape

App kanji assets after QA-A-026 canonical rewrite:

| Metric | Value |
| --- | ---: |
| Files scanned | 125 |
| Unique kanji | 2114 |
| With components | 250 |
| With relatedKanji | 558 |
| With both components + relatedKanji | 250 |
| With no relation data | 1556 |

Per-level relation density:

| Level | Count | Avg one-hop | Max one-hop | Avg depth-2 | Max depth-2 |
| --- | ---: | ---: | ---: | ---: | ---: |
| N5 | 103 | 2.94 | 7 | 8.85 | 31 |
| N4 | 178 | 2.49 | 7 | 7.41 | 24 |
| N3 | 316 | 2.15 | 8 | 6.75 | 30 |
| N2 | 461 | 1.26 | 7 | 4.07 | 34 |
| N1 | 1056 | 0.32 | 7 | 0.90 | 34 |

Example focus `校`:

- Components: `木`, `交`.
- Related kanji: `木`, `学`.
- Good MVP proof target: focus `校`, component edges to `木`/`交`, related edge to `学`.

## Design

### Route Decision

Use a new full-screen route:

- Public route: `/kanji/:character/graph`.
- Route constant pattern: `/kanji/:character/graph`.
- Detail CTA: `Xem mạng liên quan` opens `/kanji/<char>/graph`.
- Graph screen has a back button to `/kanji?kanjiId=<id>` when the focus kanji exists in the app DB, otherwise `/kanji`.

Rationale: the graph needs pan/zoom, toolbar, and practice controls. A dialog or small panel would fight existing detail layout and mobile viewport constraints.

### Component Boundaries

- `lib/features/kanji_hub/models/kanji_relationship_graph.dart`
  - Pure data: node type, edge type, graph payload, graph cap policy.
  - No Flutter dependency beyond enums/values.
- `lib/features/kanji_hub/providers/kanji_relationship_graph_provider.dart`
  - Loads all kanji through `LessonRepository.fetchKanjiByLevel`.
  - Builds a character index.
  - Builds graph data for a focus character with `depthLimit=2`, `maxNodes=15`.
  - Loads SRS state for included app kanji IDs.
- `lib/features/kanji_hub/widgets/kanji_relationship_graph.dart`
  - Renders the graph using `graphview`.
  - Owns `GraphViewController`.
  - Owns toolbar: fit-to-screen, reset layout, fullscreen toggle.
  - Emits callbacks for node taps and cluster practice.
- `lib/features/kanji_hub/screens/kanji_relationship_graph_screen.dart`
  - Route-level scaffold, loading/error/empty states, language-aware copy.
  - Navigates node taps by replacing route with `/kanji/<node>/graph`.
- `lib/features/kanji_hub/widgets/kanji_graph_practice_panel.dart`
  - 5-question recognition/Hán-Việt quick drill for current graph nodes.
  - Pass `>=4/5` calls `kanjiSrsDao.recordReview` for every graph node with an app ID.
- `lib/features/practice/widgets/kanji_mini_graph_thumbnail.dart`
  - Review card thumbnail for due kanji, one-hop only, no interaction except open full graph.

### Graph Data Rules

Node types:

- `focus`: selected kanji.
- `component`: entries from `decomposition.components`.
- `related`: entries from `decomposition.relatedKanji`.
- `outsideApp`: component/related glyph not found in app kanji index.

Edge types:

- `component-of`: component -> focus, label `成分`.
- `related-meaning`: focus -> related, label `関連`.
- `related-form`: focus -> related, label `形`.

Initial MVP uses `component-of` and `related-meaning`. `related-form` remains available for future asset enrichment because current JSON does not split `relatedKanji` by reason.

Depth policy:

- Depth 1: always include all unique components and related kanji, capped after dedupe.
- Depth 2: include neighbors of depth-1 app nodes until `maxNodes=15`.
- Prefer lower JLPT level, then active/due SRS, then relation order from source JSON.
- If focus has no relation data, show a compact empty state with direct CTAs: practice kanji, search kanji, return detail.

### Layout

Use `FruchtermanReingoldAlgorithm` with `ArrowEdgeRenderer` subclass:

- Good for mixed component + related edges.
- Small graph cap keeps force layout stable.
- Use `autoZoomToFit` after build.
- Toolbar `fit-to-screen` calls `GraphViewController.zoomToFit`.
- Toolbar `refresh layout` rebuilds graph data key and reruns layout.
- Toolbar `fullscreen` swaps between in-page graph and a full-screen `Dialog.fullscreen` using the same graph widget.

Fallback:

- If force-directed layout overlaps badly in live proof, switch MVP to `CircleLayoutAlgorithm` with focus visually emphasized at center via custom node placement is not directly supported by graphview, so this is a fallback only after proving force layout fails.

### Visual Style

- Background: plain white with a subtle light-gray dot grid. Avoid decorative blobs.
- Focus node: `#1E88E5`, white kanji, 56px circle.
- Related node: `#FB8C00`, white kanji, 48px circle.
- Component node: `#7E57C2`, white kanji, 48px circle.
- Outside-app node: white fill, gray border, dark kanji, disabled tap.
- SRS overlay:
  - unseen: gray border `#9E9E9E`.
  - learning/due: amber border `#FBC02D`.
  - stable/mastered: green border `#43A047`.
- Edge: gray `#616161`, stroke `1.5`, arrowhead enabled.
- Edge labels: small white pill with gray border and 11px label text.
- Tooltip/popover: kanji, Hán-Việt in VI only, localized meaning, JLPT level, relation type.

### Interaction

- Pan/zoom by mouse, wheel, and touch through graphview's `InteractiveViewer`.
- Click/tap app node: navigate to `/kanji/<char>/graph`, replacing focus.
- Tap outside-app component: show tooltip only; no route.
- `Luyện cụm này`: starts a 5-question mini quiz using current graph app nodes.
- Quiz item types:
  - VI: `Hán-Việt -> kanji` and `nghĩa Việt -> kanji`.
  - EN/JA: localized meaning -> kanji.
- Pass `>=4/5`: record grade `3` review for all graph app nodes.
- Fail: record grade `1` only for missed nodes.

### Review Interlink

In `/review`:

- When kanji is due, show a one-hop mini graph thumbnail inside the kanji review action/card.
- Thumbnail contains focus + up to 5 one-hop nodes, no pan/zoom.
- Click thumbnail: open `/kanji/<char>/graph`.
- Do not add graph noise to non-kanji review cards.

### Language Rules

- VI: show Hán-Việt in tooltips, practice prompts, and node subtitles where space allows.
- EN: hide Hán-Việt; show English meaning/radical/component copy.
- JA: hide Hán-Việt; show Japanese copy when present, English fallback otherwise.

## Verification Plan

Local:

- TDD model/provider tests:
  - graph builder emits `校 -> 木/交/学` nodes and typed edges.
  - cap policy keeps max nodes at `15`.
  - outside-app components are non-navigable.
  - SRS states map to node border tiers.
  - graph practice pass records SRS for included kanji.
- Widget tests:
  - graph renders focus, component, related nodes, toolbar buttons.
  - detail CTA opens route.
  - review card mini graph opens route.
- Gates:
  - `flutter test` focused suites.
  - `flutter analyze lib test`.
  - UI string guard.
  - `git diff --check`.
  - Full `flutter test --concurrency=1` before deploy because this adds routing, package dependency, UI widgets, and SRS behavior.

Live:

- VI `/kanji/校/graph`: focus `校` blue; `木`, `交`, `学` visible; directed arrows visible; labels visible; pan/zoom works; fit/reset/fullscreen toolbar works.
- Click `学`: route changes to `/kanji/学/graph`, focus changes to `学`.
- `Luyện cụm này`: answer 4/5 correctly; graph SRS border for included kanji changes to green/learning state after reload.
- EN/JA graph: no Hán-Việt leak.
- `/review`: due kanji card shows mini graph; click opens full graph.
- `main.dart.js` is `200/no-cache`; console has no unexpected app errors after filtering known headless App Check/reCAPTCHA/WebGL noise.

## DECISIONS MADE

1. Full-screen route wins over embedded detail panel because the graph needs room, toolbar controls, and mobile pan/zoom.
2. Use `graphview 1.5.1` because it is available through pub, supports web, `InteractiveViewer`, force-directed layout, arrows, and fit/reset controller APIs.
3. Use force-directed layout for MVP because the data is mixed, not a strict tree. Cap at `15` nodes to avoid edge clutter and web layout instability.
4. Paint edge labels through a custom `ArrowEdgeRenderer` subclass because `graphview` does not expose a first-class edge-label widget API.
5. Keep graph data app-local and factual. No external kanji graph source is needed for QA-A-029.
6. Start with relation labels `成分` and `関連`; defer `related-form` until the asset can distinguish form vs meaning relation.
7. Practice mode updates SRS for graph nodes only after a real quiz result; no self-attestation buttons.
8. For outside-app components, show nodes but disable navigation so decomposition remains visually honest without creating broken routes.

## OPEN_QUESTIONS

| Area | Temporary Decision | Alternative For Owner Review |
| --- | --- | --- |
| Edge relation taxonomy | Treat current `relatedKanji` as generic `関連`. | Split into meaning/form/pedagogy once source assets include reason codes. |
| Graph package | Use `graphview 1.5.1`. | Replace with custom `CustomPainter` if graphview web layout or edge-label rendering fails live proof. |
| Depth | Default depth 2 with `15` node cap. | Owner may prefer one-hop only for beginners or larger graphs for desktop. |
| Practice grading | Pass `>=4/5` records grade `3`; misses record grade `1`. | Tune grades after observing SRS pacing. |
| Route shape | `/kanji/:character/graph`. | Use `/kanji/graph?focus=<char>` if encoded route parameters cause issues with Japanese characters in deployed URLs. |

## Phase Plan

1. Phase 1 MVP:
   - Add `graphview`.
   - Add graph data model/provider.
   - Add full route `/kanji/:character/graph`.
   - Add graph widget with focus/components/related nodes, arrows, labels, pan/zoom, fit/reset/fullscreen toolbar.
   - Add detail CTA.
2. Phase 2 State + Practice:
   - Add SRS overlay borders.
   - Add `Luyện cụm này` 5-question quiz.
   - Record kanji SRS from quiz outcome.
3. Phase 3 Reverse Interlink:
   - Add review mini graph for due kanji.
   - Live proof end-to-end from review -> graph -> practice -> review state.
