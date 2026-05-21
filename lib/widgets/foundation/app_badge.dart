import 'package:flutter/material.dart';
import 'package:jpstudy/theme/app_theme.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.level,
    this.color,
    this.icon,
  });

  final String label;
  final String? level;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final badgeColor = color ?? _levelColor(palette);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacingTokens.sm,
        vertical: AppSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadiusTokens.pill),
        border: Border.all(color: badgeColor.withValues(alpha: 0.26)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: badgeColor),
            const SizedBox(width: AppSpacingTokens.xs),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Color _levelColor(AppThemePalette palette) {
    final code = level ?? label;
    if (RegExp(r'^N[1-5]$', caseSensitive: false).hasMatch(code)) {
      return AppColorTokens.level(code);
    }
    return palette.primary;
  }
}
