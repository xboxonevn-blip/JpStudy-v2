import 'package:flutter/material.dart';
import 'package:jpstudy/theme/app_theme.dart';
import 'package:jpstudy/widgets/foundation/app_button.dart';

class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    required this.title,
    required this.child,
    this.caption,
    this.actionLabel,
    this.onActionTap,
    this.trailing,
    this.spacing = AppSpacingTokens.md,
  });

  final String title;
  final Widget child;
  final String? caption;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final Widget? trailing;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: palette.ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (caption != null && caption!.trim().isNotEmpty) ...[
                    const SizedBox(height: AppSpacingTokens.xs),
                    Text(
                      caption!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: palette.ink.withValues(alpha: 0.68),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacingTokens.sm),
              trailing!,
            ] else if (actionLabel != null && onActionTap != null)
              AppButton(
                label: actionLabel!,
                onPressed: onActionTap,
                variant: AppButtonVariant.ghost,
                compact: true,
              ),
          ],
        ),
        SizedBox(height: spacing),
        child,
      ],
    );
  }
}
