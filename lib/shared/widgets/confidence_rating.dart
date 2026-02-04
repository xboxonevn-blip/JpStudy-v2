import 'package:flutter/material.dart';
import 'package:jpstudy/core/app_language.dart';

/// Confidence level enum for SRS reviews
enum ConfidenceLevel {
  again(1, Colors.red, Icons.replay),
  hard(2, Colors.orange, Icons.trending_down),
  good(3, Colors.blue, Icons.check),
  easy(4, Colors.green, Icons.bolt);

  final int value;
  final Color color;
  final IconData icon;

  const ConfidenceLevel(this.value, this.color, this.icon);
}

/// Widget for selecting confidence/difficulty rating
class ConfidenceRatingWidget extends StatelessWidget {
  final Function(ConfidenceLevel) onSelect;
  final ConfidenceLevel? selected;
  final bool showLabels;
  final bool compact;
  final AppLanguage language;

  const ConfidenceRatingWidget({
    super.key,
    required this.onSelect,
    required this.language,
    this.selected,
    this.showLabels = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ConfidenceLevel.values.map((level) {
          final isSelected = selected == level;
          return IconButton(
            onPressed: () => onSelect(level),
            icon: Icon(level.icon),
            color: isSelected ? level.color : Colors.grey,
            iconSize: 28,
            tooltip: _labelFor(level),
          );
        }).toList(),
      );
    }

    return Row(
      children: ConfidenceLevel.values.map((level) {
        final isSelected = selected == level;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildButton(context, level, isSelected),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildButton(
    BuildContext context,
    ConfidenceLevel level,
    bool isSelected,
  ) {
    return Material(
      color: isSelected ? level.color : level.color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => onSelect(level),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                level.icon,
                color: isSelected ? Colors.white : level.color,
                size: 24,
              ),
              if (showLabels) ...[
                const SizedBox(height: 4),
                Text(
                  _labelFor(level),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : level.color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _labelFor(ConfidenceLevel level) {
    switch (level) {
      case ConfidenceLevel.again:
        return language.reviewAgainLabel;
      case ConfidenceLevel.hard:
        return language.reviewHardLabel;
      case ConfidenceLevel.good:
        return language.reviewGoodLabel;
      case ConfidenceLevel.easy:
        return language.reviewEasyLabel;
    }
  }
}

/// A simple star rating widget for quick feedback
class StarRating extends StatelessWidget {
  final int rating; // 1-5
  final Function(int)? onRatingChanged;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const StarRating({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isActive = starIndex <= rating;

        return GestureDetector(
          onTap: onRatingChanged != null
              ? () => onRatingChanged!(starIndex)
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              isActive ? Icons.star_rounded : Icons.star_border_rounded,
              size: size,
              color: isActive
                  ? (activeColor ?? Colors.amber)
                  : (inactiveColor ?? Colors.grey[300]),
            ),
          ),
        );
      }),
    );
  }
}
