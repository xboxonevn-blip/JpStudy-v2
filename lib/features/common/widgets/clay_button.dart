import 'package:flutter/material.dart';
import '../../../theme/app_theme_v2.dart';

enum ClayButtonStyle {
  primary,
  secondary,
  tertiary,
  neutral,
}

class ClayButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ClayButtonStyle style;
  final bool isExpanded;

  const ClayButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.style = ClayButtonStyle.primary,
    this.isExpanded = false,
  });

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> {
  bool _isPressed = false;

  Color get _baseColor {
    switch (widget.style) {
      case ClayButtonStyle.primary: return AppThemeV2.primary;
      case ClayButtonStyle.secondary: return AppThemeV2.secondary;
      case ClayButtonStyle.tertiary: return AppThemeV2.tertiary;
      case ClayButtonStyle.neutral: return Colors.white;
    }
  }

  Color get _textColor {
    switch (widget.style) {
      case ClayButtonStyle.neutral: return AppThemeV2.textSub;
      default: return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _baseColor;
    final depthColor = AppThemeV2.getDepthColor(baseColor == Colors.white ? AppThemeV2.neutral : baseColor);
    final borderColor = baseColor == Colors.white ? AppThemeV2.neutral : depthColor;

    // When pressed, we translate Y by 4px and remove shadow to simulate depression
    final double offset = _isPressed ? 4.0 : 0.0;
    
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, color: _textColor),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );

    if (widget.isExpanded) {
      content = Center(child: content);
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        transform: Matrix4.translationValues(0, _isPressed ? 4 : 0, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: 2, // Thicker border for cartoon look
            ),
            boxShadow: [
              if (!_isPressed)
                BoxShadow(
                  color: borderColor,
                  offset: const Offset(0, 4), // The "height" of the button
                  blurRadius: 0, // Sharp shadow for flat/clay look
                ),
            ],
          ),
          child: content,
        ),
      ),
    );
  }
}
