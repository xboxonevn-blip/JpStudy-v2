import 'package:flutter/material.dart';
import '../../../theme/app_theme_v2.dart';

class ClayCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const ClayCard({
    super.key,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? Colors.white;
    final depthColor = AppThemeV2.getDepthColor(baseColor == Colors.white ? AppThemeV2.neutral : baseColor);
    final borderColor = baseColor == Colors.white ? AppThemeV2.neutral : depthColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: borderColor,
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
