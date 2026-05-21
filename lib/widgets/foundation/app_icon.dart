import 'package:flutter/material.dart';
import 'package:jpstudy/theme/app_theme.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.icon,
    this.label,
    this.color,
    this.size = 48,
    this.iconSize,
  });

  final IconData icon;
  final String? label;
  final Color? color;
  final double size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final iconColor = color ?? palette.primary;
    return Semantics(
      label: label,
      image: label != null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              iconColor.withValues(alpha: 0.16),
              palette.secondary.withValues(alpha: 0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadiusTokens.lg),
        ),
        child: Icon(icon, color: iconColor, size: iconSize ?? size * 0.44),
      ),
    );
  }
}
