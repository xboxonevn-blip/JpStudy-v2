import 'package:jpstudy/theme/tokens/radius_tokens.dart';
import 'package:jpstudy/theme/tokens/spacing_tokens.dart';

/// Design-token spacing constants — 4px base grid.
///
/// Use these instead of raw pixel literals so every component snaps to the
/// same grid. For layout padding/margin/gap, prefer the named sizes below.
///
/// Migration guide: when touching a file that uses ad-hoc values (10, 14, 18…)
/// round to the nearest token and update the file. Don't do a mass find-replace
/// without a visual review.
///
/// Common ad-hoc values → nearest token:
///   5 → [xs]        6 → [xs]/[sm]    9 → [sm]    10 → [sm]/[md]
///  11 → [md]       13 → [md]        14 → [md]    18 → [xl]
abstract final class AppSpacing {
  /// 4 px — icon gaps, micro dividers
  static const double xs = AppSpacingTokens.xs;

  /// 8 px — component-internal gaps, small badges
  static const double sm = AppSpacingTokens.sm;

  /// 12 px — card-internal row gaps, grid spacing
  static const double md = AppSpacingTokens.md;

  /// 16 px — default card padding, horizontal page margin
  static const double lg = AppSpacingTokens.lg;

  /// 20 px — section padding, larger card insets
  static const double xl = AppSpacingTokens.xl;

  /// 24 px — screen-level section gaps, dialog padding
  static const double xxl = AppSpacingTokens.xxl;

  /// 32 px — hero areas, display section spacing
  static const double xxxl = AppSpacingTokens.xxxl;

  /// 40 px — wide-layout section gutters
  static const double displaySm = AppSpacingTokens.displaySm;

  /// 48 px — desktop hero spacing
  static const double displayMd = AppSpacingTokens.displayMd;

  /// 64 px — ultra-wide section spacing
  static const double displayLg = AppSpacingTokens.displayLg;

  // ── Semantic aliases ────────────────────────────────────────────────────

  /// Standard horizontal page margin used by HomeSurface.
  static const double pageInset = AppSpacingTokens.pageInset;

  /// Bottom padding so content clears the floating bottom nav / FAB area.
  static const double pageBottom = AppSpacingTokens.pageBottom;

  // ── Border radius tokens ──────────────────────────────────────────────

  /// 8 px — small chips, badges
  static const double radiusSm = AppRadiusTokens.sm;

  /// 12 px — buttons, input fields
  static const double radiusMd = AppRadiusTokens.md;

  /// 16 px — cards, dialogs
  static const double radiusLg = AppRadiusTokens.lg;

  /// 20 px — panels, modals
  static const double radiusXl = 20;

  /// 24 px — hero cards, large containers
  static const double radiusXxl = AppRadiusTokens.xxl;

  /// 999 px — fully rounded (pills, circular badges)
  static const double radiusPill = AppRadiusTokens.pill;
}

abstract final class AppTouchTargets {
  /// Minimum active touch target for mobile/tablet controls.
  static const double min = 44;
}
