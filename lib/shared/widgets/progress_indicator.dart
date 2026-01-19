import 'package:flutter/material.dart';

/// A reusable circular progress indicator widget for study sessions
class StudyProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final int current;
  final int total;
  final Color? color;
  final double size;
  final double strokeWidth;

  const StudyProgressIndicator({
    super.key,
    required this.progress,
    required this.current,
    required this.total,
    this.color,
    this.size = 60,
    this.strokeWidth = 6,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? Theme.of(context).primaryColor;
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation(
              progressColor.withValues(alpha: 0.2),
            ),
          ),
          // Progress circle
          CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation(progressColor),
          ),
          // Counter text
          Text(
            '$current/$total',
            style: TextStyle(
              fontSize: size * 0.22,
              fontWeight: FontWeight.bold,
              color: progressColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// A linear progress bar with labels
class StudyProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String? label;
  final Color? color;
  final double height;

  const StudyProgressBar({
    super.key,
    required this.progress,
    this.label,
    this.color,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color ?? Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: height,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(
              color ?? Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
