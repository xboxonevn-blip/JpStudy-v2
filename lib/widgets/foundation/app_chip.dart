import 'package:flutter/material.dart';
import 'package:jpstudy/theme/app_theme.dart';

enum AppChipTone { primary, success, warning, danger, info, neutral }

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.tone = AppChipTone.neutral,
    this.icon,
  });

  final String label;
  final AppChipTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final colors = _colorsFor(palette);
    final labelText = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: colors.$2,
        fontWeight: FontWeight.w800,
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacingTokens.md,
            vertical: AppSpacingTokens.sm,
          ),
          decoration: BoxDecoration(
            color: colors.$1,
            borderRadius: BorderRadius.circular(AppRadiusTokens.pill),
            border: Border.all(color: colors.$2.withValues(alpha: 0.18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: colors.$2),
                const SizedBox(width: AppSpacingTokens.xs),
              ],
              if (constraints.maxWidth.isFinite)
                Flexible(child: labelText)
              else
                labelText,
            ],
          ),
        );
      },
    );
  }

  (Color, Color) _colorsFor(AppThemePalette palette) {
    return switch (tone) {
      AppChipTone.primary => (
        palette.primary.withValues(alpha: 0.12),
        palette.primary,
      ),
      AppChipTone.success => (
        palette.success.withValues(alpha: 0.14),
        palette.success,
      ),
      AppChipTone.warning => (
        palette.warning.withValues(alpha: 0.16),
        palette.warning,
      ),
      AppChipTone.danger => (
        palette.error.withValues(alpha: 0.14),
        palette.error,
      ),
      AppChipTone.info => (palette.info.withValues(alpha: 0.14), palette.info),
      AppChipTone.neutral => (
        palette.outlineSoft,
        palette.ink.withValues(alpha: 0.72),
      ),
    };
  }
}
