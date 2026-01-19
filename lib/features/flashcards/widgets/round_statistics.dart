import 'package:flutter/material.dart';

import '../models/flashcard_session.dart';

/// Widget displaying real-time round statistics during a flashcard session
class RoundStatisticsWidget extends StatelessWidget {
  final FlashcardSession session;
  final int currentIndex;
  final int totalCards;

  const RoundStatisticsWidget({
    super.key,
    required this.session,
    required this.currentIndex,
    required this.totalCards,
  });

  @override
  Widget build(BuildContext context) {
    final remainingCards = totalCards - (currentIndex + 1);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Round Progress',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$remainingCards remaining',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress buckets
          Row(
            children: [
              Expanded(
                child: _BucketIndicator(
                  icon: Icons.check_circle_rounded,
                  label: 'Known',
                  count: session.knownTermIds.length,
                  color: Colors.green,
                  total: totalCards,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BucketIndicator(
                  icon: Icons.replay_rounded,
                  label: 'Practice',
                  count: session.needPracticeTermIds.length,
                  color: Colors.orange,
                  total: totalCards,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BucketIndicator(
                  icon: Icons.star_rounded,
                  label: 'Starred',
                  count: session.starredTermIds.length,
                  color: Colors.amber,
                  total: totalCards,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Accuracy bar
          _AccuracyBar(
            knownCount: session.knownTermIds.length,
            practiceCount: session.needPracticeTermIds.length,
            total: session.totalSeen,
          ),
        ],
      ),
    );
  }
}

class _BucketIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final int total;

  const _BucketIndicator({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (count / total * 100).toInt() : 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 11,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccuracyBar extends StatelessWidget {
  final int knownCount;
  final int practiceCount;
  final int total;

  const _AccuracyBar({
    required this.knownCount,
    required this.practiceCount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();

    final knownRatio = knownCount / total;
    final practiceRatio = practiceCount / total;
    final accuracy = total > 0 ? (knownCount / total * 100).toInt() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Accuracy',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '$accuracy%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: accuracy >= 70 ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 8,
            child: Row(
              children: [
                Expanded(
                  flex: (knownRatio * 100).toInt(),
                  child: Container(color: Colors.green),
                ),
                Expanded(
                  flex: (practiceRatio * 100).toInt(),
                  child: Container(color: Colors.orange),
                ),
                Expanded(
                  flex: 100 - (knownRatio * 100).toInt() - (practiceRatio * 100).toInt(),
                  child: Container(color: Colors.grey[300]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
