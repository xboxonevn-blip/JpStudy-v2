import 'package:flutter/material.dart';
import 'package:jpstudy/theme/app_theme.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.axis = Axis.horizontal,
    this.spacing = AppSpacingTokens.md,
  });

  final Axis axis;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final color = context.appPalette.outlineSoft;
    if (axis == Axis.vertical) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing),
        child: VerticalDivider(width: 1, thickness: 1, color: color),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing),
      child: Divider(height: 1, thickness: 1, color: color),
    );
  }
}
