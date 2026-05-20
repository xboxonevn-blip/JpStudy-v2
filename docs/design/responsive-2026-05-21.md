# Responsive Design - 2026-05-21

## Mục tiêu

Fix desktop wasted side space, mobile overflow, and generic home layouts with a clear four-breakpoint system.

## Bối cảnh

Owner reported desktop layout wasting both sides and mobile breaking. The app needs operational study surfaces, not marketing-style cards.

## Breakpoints

```dart
enum Breakpoint {
  mobile,          // < 768
  tabletPortrait,  // 768-1023
  tabletLandscape, // 1024-1279
  desktop,         // >= 1280
}
```

Helper:

```dart
class Breakpoints {
  static Breakpoint fromWidth(double width) {
    if (width < 768) return Breakpoint.mobile;
    if (width < 1024) return Breakpoint.tabletPortrait;
    if (width < 1280) return Breakpoint.tabletLandscape;
    return Breakpoint.desktop;
  }
}
```

## Layout rules

Mobile 360-767:

- one column
- bottom navigation/sheet mode picker
- fullscreen flashcard
- sticky compact header
- swipe left/right for next/previous card
- all buttons at least 44 px tap target

Tablet portrait 768-1023:

- one rich column
- constrained content width 760
- mode picker remains inline
- flashcard keeps 16 px page padding

Tablet landscape 1024-1279:

- two-column lesson layout where useful
- flashcard/content primary width around 640
- secondary panel for term list or related links

Desktop 1280+:

- max content width 1040 for lesson pages
- home dashboard can use four compact widgets
- avoid full-width stretched cards
- sidebars remain useful but not dominant

## Component tree

```text
BreakpointBuilder
└── ResponsiveScaffold
    ├── AdaptiveHeader
    ├── AdaptiveBody
    │   ├── OneColumnLayout
    │   ├── TwoColumnLayout
    │   └── DashboardGrid
    └── AdaptiveBottomSheet
```

## Visual regression plan

Playwright viewport matrix:

- 360 x 640 mobile
- 768 x 1024 tablet portrait
- 1024 x 768 tablet landscape
- 1280 x 800 desktop

Screens:

- Home
- Learn level page
- Textbook page
- Lesson page
- Grammar detail
- Vocab detail
- Kanji detail
- Conjugation page
- Practice modes

Failure threshold: more than 1 percent pixel diff or any visible overflow.

## Migration plan

1. Add breakpoint helper and widget tests.
2. Refactor home into responsive widget grid.
3. Refactor lesson page with responsive container.
4. Add mobile full-screen flashcard.
5. Add visual regression scripts and baseline artifacts.
6. Fix overflow defects from screenshots before Phase 7.

## Acceptance criteria

- No overflow at 360, 768, 1024, 1280 widths.
- Home uses 1/2/2/4 column layout.
- Lesson page uses full mobile surface and constrained desktop surface.
- Mode picker works as bottom sheet on mobile and inline tabs/buttons elsewhere.
- Visual regression report exists.

## Open questions

- Exact mobile gesture sensitivity should be tuned from live proof; default is conservative swipe threshold.
- Some CanvasKit text measurement differences may affect screenshot diffs; default is tolerance plus semantic checks.
