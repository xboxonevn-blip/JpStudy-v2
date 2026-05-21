import 'package:flutter/material.dart';
import 'package:jpstudy/theme/app_theme.dart';
import 'package:jpstudy/widgets/foundation/app_button.dart';
import 'package:jpstudy/widgets/foundation/app_icon.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionTap,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Padding(
      padding: const EdgeInsets.all(AppSpacingTokens.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(
            icon: icon,
            color: palette.ink.withValues(alpha: 0.58),
            label: title,
          ),
          const SizedBox(height: AppSpacingTokens.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: palette.ink,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacingTokens.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: palette.ink.withValues(alpha: 0.68),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (actionLabel != null && onActionTap != null) ...[
            const SizedBox(height: AppSpacingTokens.lg),
            AppButton(
              label: actionLabel!,
              onPressed: onActionTap,
              variant: AppButtonVariant.secondary,
              compact: true,
            ),
          ],
        ],
      ),
    );
  }
}
