# Home Redesign - 2026-05-21

## Mục tiêu

Turn Home into a learning dashboard with four useful widgets:

1. today's plan
2. level progress
3. streak
4. last context

The page should be quiet, scannable, and study-focused.

## Bối cảnh

Owner called the current home page generic. The redesign must show what to do next, how progress is moving, and where the learner left off.

## Widget registry

```dart
class HomeWidgetSpec {
  const HomeWidgetSpec({
    required this.id,
    required this.priority,
    required this.supportedBreakpoints,
    required this.builder,
  });

  final String id;
  final int priority;
  final Set<Breakpoint> supportedBreakpoints;
  final WidgetBuilder builder;
}
```

## Component tree

```text
HomeDashboard
├── DashboardHeader
├── HomeWidgetGrid
│   ├── TodayPlanWidget
│   ├── LevelProgressWidget
│   ├── StreakWidget
│   └── LastContextWidget
└── RecommendationStrip
```

Responsive grid:

```text
mobile: 1 column
tablet portrait: 2 columns
tablet landscape: 2 columns
desktop: 4 columns
```

## Widget specs

### TodayPlanWidget

Shows:

- due SRS total
- vocab/grammar/kanji/conjugation breakdown
- one recommended lesson
- CTA `Bắt đầu học hôm nay`

State:

- loading with bounded skeleton
- empty state when no due items and no current path
- error state with retry

### LevelProgressWidget

Shows:

- N5-N1 progress bars
- mastered / total count
- current level emphasized
- tap routes into level page

### StreakWidget

Shows:

- current streak
- best streak
- freeze count
- last review date

Rules:

- counts only real graded practice/review, not app open
- no self-attestation

### LastContextWidget

Shows:

- current textbook
- lesson
- last item/mode
- progress bar
- CTA `Học tiếp`

Fallback:

- if no history, point to onboarding/level path plan.

## Migration plan

1. Add widget registry and responsive grid.
2. Move current daily/session pieces behind widget adapters.
3. Add last-context storage using existing persisted study state.
4. Add progress aggregation from local DB/content manifests.
5. Add tests for empty/loading/error states.
6. Add live proof at four viewports.

## Acceptance criteria

- Four widgets render on Home.
- Grid is 1/2/2/4 columns across breakpoints.
- Every CTA routes to non-empty content.
- No generic marketing copy; every card is actionable.
- No overflow on mobile.

## Open questions

- Streak freeze product policy is not finalized; default is display 0 available until owner decides.
- Progress denominator should switch from flat item count to manifest item count after Phase 1 dual-read is live.
