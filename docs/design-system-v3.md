# Design System V3

Published: 2026-05-21  
Scope: Phase H.2-H.6 UI system, foundation primitives, responsive rules, and
learner-facing voice rules.

## Principles

- Build for repeated study sessions, not a marketing page.
- Keep information dense but calm: visible progress, clear next action, no
  decorative clutter that competes with Japanese text.
- Prefer app tokens and foundation primitives over local one-off styling.
- Treat mobile as a real practice surface: bottom sheets for choice-heavy
  controls, edge-to-edge flashcards, and gesture-first review.
- Learner-facing teaching copy follows Directive E: Dr. Linh-Phan-Tran voice,
  specific etymology, Han-Viet bridge, concrete contrast, no generic filler.

## Tokens

Token source files live in `lib/theme/tokens/` and are integrated through
`lib/theme/app_theme.dart`.

### Spacing

Use `AppSpacingTokens` / `AppSpacing`.

| Token | Value | Use |
|---|---:|---|
| `xs` | 4 | Tight icon/text gap |
| `sm` | 8 | Inline chip gap |
| `md` | 12 | Compact card internals |
| `lg` | 16 | Default panel padding |
| `xl` | 20 | Section spacing |
| `xxl` | 24 | Large panel padding |
| `xxxl` | 32 | Major section separation |
| `displaySm` | 40 | Hero/module gap |
| `displayMd` | 48 | Wide page gap |
| `displayLg` | 64 | Rare desktop separation |

### Radius

Use `AppRadiusTokens`: `4 / 8 / 12 / 16 / 24 / pill`. Cards should normally
stay at 8-16 unless a legacy surface already uses a larger soft panel.

### Color

Use semantic palette names, not raw color literals.

| Token group | Meaning |
|---|---|
| `background`, `base`, `surface`, `elevated` | Page, shell, card, raised panel |
| `primary`, `secondary`, `accent` | Brand action, support color, emphasis |
| `textHigh`, `textMedium`, `textLow` | Primary, secondary, muted text |
| `success`, `warning`, `danger`, `info` | Status states |
| `outline`, `outlineSoft` | Borders and separators |
| `heroStart`, `heroEnd` | Hero gradients |
| `level(N5-N1)` | JLPT convention: N5 red, N4 orange, N3 yellow, N2 green, N1 blue |

### Typography

Use `AppTypographyTokens`.

| Scale | Values |
|---|---|
| Display | 32 / 40 / 48 |
| Heading | 20 / 24 / 28 |
| Body | 14 / 16 / 18 |
| Caption | 12 / 13 |

Font defaults: `Be Vietnam Pro` for Vietnamese, `Manrope` for bundled Latin,
`Yu Gothic UI` / `Noto Sans JP` for Japanese fallback.

### Elevation

Use `AppElevationTokens`: `dp0 / dp1 / dp2 / dp4 / dp8`.

- `dp0`: flat sections and lists.
- `dp1-dp2`: normal cards.
- `dp4`: active dashboard panels.
- `dp8`: modal/sheet emphasis only.

### Motion

Use `AppMotionTokens`: `instant`, `snap` 120ms, `fast` 180ms, `smooth` 240ms,
`slow` 360ms. Respect `reducedMotionDuration` for animated learning surfaces.

## Foundation Components

Foundation primitives live in `lib/widgets/foundation/` and export through
`foundation.dart`.

| Component | Purpose | Default use |
|---|---|---|
| `AppCard` | Generic framed surface | Repeated item, tappable tile, dense panel |
| `AppButton` | CTA/action button | Primary, secondary, ghost, destructive |
| `AppChip` | Short state/action label | Due, complete, warning, level state |
| `AppBadge` | Compact count/level marker | SRS due, streak, JLPT, rank |
| `AppIcon` | Semantic icon wrapper | Consistent icon color/background |
| `AppDivider` | Section separator | Horizontal/vertical rhythm |
| `AppSection` | Title/caption/body wrapper | Dashboard and detail sections |
| `AppEmptyState` | Empty/error placeholder | No data, no recent activity, no due queue |

Use these before `Card`, `FilledButton`, `OutlinedButton`, `TextButton`,
`Chip`, or local containers. Material primitives are allowed inside foundation
itself and rare low-level platform widgets.

## Layout Patterns

### Page Frame

- Use `AppResponsiveFrame` for constrained content.
- Home H.4 adaptive max-width:
  - `<1280`: 1040
  - `1280-1439`: 1280
  - `1440-1599`: 1440
  - `>=1600`: 1600
- Avoid large empty bands. On wide desktop, pair short hero modules with
  sidebar/status content in the same column.

### Home Dashboard

- Top: `Featured this week`.
- Desktop `>=1280`: two-column top split, left learning foundation/roadmap,
  right `Dojo hôm nay` plus sidebar signals.
- Bottom: overview, due cards, daily plan, lanes, weakness, discovery,
  recent activity.
- Sidebar carries weekly streak, lessons due chip, collapsible state, and
  compact progress modules.

### Lesson Page

- Mobile `<768`: mode picker opens from a bottom sheet.
- Tablet/desktop: mode picker can render inline as a wrap/grid.
- Sticky mobile header stays compact: back affordance plus lesson title.
- Lesson content uses one rich column on tablet portrait, wider content at
  tablet landscape/desktop.

### Flashcard

- Mobile: edge-to-edge fullscreen practice surface.
- Tap flips the card.
- Swipe left/up advances; swipe right/down goes back.
- Long-press marks current item difficult.
- Desktop/tablet may keep explicit previous/next buttons as assistive controls.

## Responsive Breakpoints

Canonical runtime helper: `lib/responsive/breakpoints.dart`.

| Class | Width |
|---|---:|
| Mobile | `<768` |
| Tablet portrait | `768-1023` |
| Tablet landscape | `1024-1279` |
| Desktop | `>=1280` |

Required verification viewports for responsive QA:

- `360x640`
- `768x1024`
- `1024x768`
- `1280x800`

H.7 visual regression adds:

- `1600x900`
- `1920x1080`

## Accessibility

- Minimum touch target: 44x44; prefer `AppSpacing.minTouchTarget`.
- Text contrast target: WCAG AA, especially chip text on tinted backgrounds.
- Do not encode meaning by color alone; pair with icon/text.
- Keep focus order aligned with visual order.
- Modal and bottom sheet actions must be reachable by keyboard and screen
  reader labels.
- Respect reduced motion for card flips, transitions, and celebratory effects.
- Japanese text must not shrink to illegibility; wrap or scroll before clipping.

## Anti-Patterns

- Raw `Card`/button/chip styling in feature screens when a foundation primitive
  fits.
- Nested cards for page sections.
- Empty desktop columns caused by mismatched row heights.
- Mobile segmented controls with too many options; use a bottom sheet.
- Decorative blobs/orbs or one-note gradients as page fillers.
- Learner-facing copy that sounds like generic advice and survives pattern
  substitution. Directive E rejects that in Phase G.

## Brand Voice

Teaching content follows `docs/agent-directives.md` Directive E.

- Explain from roots first: form, meaning, usage.
- Use the Vietnamese learner advantage: Han-Viet bridge where relevant.
- Include a human moment only when it is specific and useful.
- Contrast confusable patterns/items directly.
- Never add owner-only Vietnamese approval markers; only the owner can apply
  them after review.
