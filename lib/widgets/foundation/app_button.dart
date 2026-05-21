import 'package:flutter/material.dart';
import 'package:jpstudy/theme/app_theme.dart';

enum AppButtonVariant { primary, secondary, ghost, destructive }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.expanded = false,
    this.compact = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool expanded;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final style = _styleFor(palette);
    final child = icon == null ? _button(style) : _iconButton(style);

    return expanded ? SizedBox(width: double.infinity, child: child) : child;
  }

  Widget _button(ButtonStyle style) {
    return switch (variant) {
      AppButtonVariant.ghost => TextButton(
        onPressed: onPressed,
        style: style,
        child: Text(label),
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: Text(label),
      ),
      _ => FilledButton(onPressed: onPressed, style: style, child: Text(label)),
    };
  }

  Widget _iconButton(ButtonStyle style) {
    return switch (variant) {
      AppButtonVariant.ghost => TextButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: Text(label),
      ),
      AppButtonVariant.secondary => OutlinedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: Text(label),
      ),
      _ => FilledButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: Text(label),
      ),
    };
  }

  ButtonStyle _styleFor(AppThemePalette palette) {
    final foreground = switch (variant) {
      AppButtonVariant.secondary || AppButtonVariant.ghost => palette.ink,
      _ => Colors.white,
    };
    final background = switch (variant) {
      AppButtonVariant.primary => palette.primary,
      AppButtonVariant.destructive => palette.error,
      _ => Colors.transparent,
    };
    final border = switch (variant) {
      AppButtonVariant.secondary => palette.outline,
      AppButtonVariant.destructive => palette.error,
      _ => Colors.transparent,
    };

    return ButtonStyle(
      animationDuration: AppMotionTokens.smooth,
      elevation: const WidgetStatePropertyAll(AppElevationTokens.dp0),
      foregroundColor: WidgetStatePropertyAll(foreground),
      backgroundColor: WidgetStatePropertyAll(background),
      side: WidgetStatePropertyAll(BorderSide(color: border)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: compact ? AppSpacingTokens.md : AppSpacingTokens.xl,
          vertical: compact ? AppSpacingTokens.sm : AppSpacingTokens.md,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadiusTokens.lg),
        ),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(
          fontSize: AppTypographyTokens.bodyMd,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
