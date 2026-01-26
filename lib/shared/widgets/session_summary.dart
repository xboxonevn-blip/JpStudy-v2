import 'package:flutter/material.dart';

/// A reusable session summary card widget
class SessionSummaryCard extends StatelessWidget {
  final String title;
  final int correctCount;
  final int totalCount;
  final Duration timeSpent;
  final int xpEarned;
  final VoidCallback? onReview;
  final VoidCallback? onContinue;
  final Widget? extraContent;

  const SessionSummaryCard({
    super.key,
    required this.title,
    required this.correctCount,
    required this.totalCount,
    required this.timeSpent,
    required this.xpEarned,
    this.onReview,
    this.onContinue,
    this.extraContent,
  });

  double get accuracy => totalCount > 0 ? correctCount / totalCount : 0;

  String get grade {
    final percent = accuracy * 100;
    if (percent >= 90) return 'A';
    if (percent >= 80) return 'B';
    if (percent >= 70) return 'C';
    if (percent >= 60) return 'D';
    return 'F';
  }

  Color get gradeColor {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.deepOrange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Grade circle
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: gradeColor.withValues(alpha: 0.1),
                border: Border.all(color: gradeColor, width: 4),
              ),
              child: Center(
                child: Text(
                  grade,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: gradeColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Score
            Text(
              '${(accuracy * 100).toInt()}%',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: gradeColor,
              ),
            ),
            Text(
              '$correctCount / $totalCount correct',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  icon: Icons.timer_outlined,
                  label: 'Time',
                  value: _formatDuration(timeSpent),
                ),
                _StatItem(
                  icon: Icons.star_rounded,
                  label: 'XP Earned',
                  value: '+$xpEarned',
                  color: Colors.amber,
                ),
              ],
            ),

            // Extra content
            if (extraContent != null) ...[
              const SizedBox(height: 24),
              extraContent!,
            ],

            // Action buttons
            if (onReview != null || onContinue != null) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  if (onReview != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onReview,
                        icon: const Icon(Icons.visibility_outlined),
                        label: const Text('Review'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  if (onReview != null && onContinue != null)
                    const SizedBox(width: 12),
                  if (onContinue != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onContinue,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Continue'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = color ?? Theme.of(context).primaryColor;

    return Column(
      children: [
        Icon(icon, color: displayColor, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: displayColor,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
