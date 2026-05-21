import 'package:flutter/material.dart';
import 'package:jpstudy/theme/app_theme.dart';

enum AppCardVariant { surface, elevated, outlined, accent }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.surface,
    this.padding = const EdgeInsets.all(AppSpacingTokens.xl),
    this.margin,
    this.onTap,
    this.borderRadius = AppRadiusTokens.xxl,
  });

  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final radius = BorderRadius.circular(borderRadius);
    final decoration = _decorationFor(palette, radius);
    final content = Ink(padding: padding, decoration: decoration, child: child);

    return Semantics(
      container: true,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: onTap == null
              ? content
              : InkWell(onTap: onTap, borderRadius: radius, child: content),
        ),
      ),
    );
  }

  BoxDecoration _decorationFor(AppThemePalette palette, BorderRadius radius) {
    final border = switch (variant) {
      AppCardVariant.outlined => palette.primary.withValues(alpha: 0.22),
      AppCardVariant.accent => palette.accent.withValues(alpha: 0.28),
      _ => palette.outline.withValues(alpha: 0.95),
    };

    final shadows = switch (variant) {
      AppCardVariant.elevated || AppCardVariant.accent => [
        BoxShadow(
          color: palette.primary.withValues(alpha: 0.08),
          blurRadius: 28,
          offset: const Offset(0, 14),
        ),
        BoxShadow(
          color: palette.ink.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      AppCardVariant.surface ||
      AppCardVariant.outlined => AppElevationTokens.shadowDp1,
    };

    return BoxDecoration(
      color: variant == AppCardVariant.outlined ? palette.base : null,
      gradient: variant == AppCardVariant.outlined
          ? null
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [palette.elevated, palette.base],
            ),
      borderRadius: radius,
      border: Border.all(color: border),
      boxShadow: shadows,
    );
  }
}
