# UI/UX Progress Log

Track each design iteration so everyone can review the process, not just the final screen.

## How to use

1. Add one entry per iteration.
2. Attach screenshot names (before/after).
3. Keep notes short and measurable.

---

## Iteration 001 - Design Lab Setup (2026-02-03)

- Goal: Create a visible workflow for UI/UX design progress.
- Scope:
  - Add in-app design playground route: `/design-lab`.
  - Add quick access from Settings -> Design Lab.
  - Add documentation templates for progress + review checklist.
- Output:
  - `lib/features/design_lab/design_lab_screen.dart`
  - `docs/uiux-progress.md`
  - `docs/uiux-review-checklist.md`
- Next:
  - Move one real screen (recommended: Practice Hub) through Discover -> Visual -> Validate stages.

## Iteration 002 - Learning Path Desktop Variant (2026-02-03)

- Goal: Keep the new reference-inspired visual style while making desktop layout intentional.
- Scope:
  - Add responsive split layout for desktop (map column + action column).
  - Scale node panel sizes/spacing for larger screens.
  - Keep all original navigation and actions unchanged.
- Output:
  - `lib/features/home/screens/learning_path_screen.dart`
  - `lib/features/home/widgets/unit_map_widget.dart`
  - `lib/features/home/widgets/continue_button.dart`
- Verification:
  - `flutter analyze`
  - `flutter test`

## Iteration 003 - Clean Product UI Pass (2026-02-03)

- Goal: Reduce visual noise and improve hierarchy after feedback ("still ugly").
- Scope:
  - Keep all existing functionality/routes, but switch from heavy glow style to a cleaner card-based look.
  - Refine both desktop and mobile presentation in Learning Path screen.
  - Improve readability of lesson labels and CTA actions.
- Output:
  - `lib/features/home/home_screen.dart`
  - `lib/features/home/screens/learning_path_screen.dart`
  - `lib/features/home/widgets/mini_dashboard.dart`
  - `lib/features/home/widgets/unit_map_widget.dart`
  - `lib/features/home/widgets/lesson_node_widget.dart`
  - `lib/features/home/widgets/path_painter.dart`
  - `lib/features/home/widgets/continue_button.dart`
- Verification:
  - `flutter analyze`
  - `flutter test`
