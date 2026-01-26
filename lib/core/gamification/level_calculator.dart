class LevelCalculator {
  // Simple quadratic progression: XP = 100 * Level * Level
  // Level 1: 0 - 100
  // Level 2: 100 - 400
  // Level 3: 400 - 900

  static LevelInfo calculate(int totalXp) {
    if (totalXp < 0) totalXp = 0;

    // Solve L^2 * 100 <= XP for L
    // L <= sqrt(XP / 100)
    // Current Level = Floor(sqrt(XP/100)) + 1
    // Example: 0 XP -> sqrt(0) = 0 -> Level 1
    // Example: 150 XP -> sqrt(1.5) = 1.22 -> Level 2

    // Wait, let's make it simpler for low levels.
    // Level N starts at (N-1)^2 * 100
    // Level 1 starts at 0
    // Level 2 starts at 100
    // Level 3 starts at 400
    // Level 4 starts at 900

    // To find geometric level from XP:
    // sqrt(XP/100) = N-1
    // N = sqrt(XP/100) + 1

    // Level 1: 0-100
    // Level 2: 101-300 (200 XP gap)
    // Level 3: 301-600 (300 XP gap)

    int level = 1;
    int threshold = 100;
    int gap = 100;
    int previousThreshold = 0;

    // Iterative calculation (safe for typical XP ranges)
    while (totalXp >= threshold) {
      previousThreshold = threshold;
      level++;
      gap += 50; // Gap increases: 100, 150, 200, 250...
      threshold += gap;
    }

    // Now we have current level, and range [previousThreshold, threshold)
    final progressXp = totalXp - previousThreshold;
    final levelGap = threshold - previousThreshold;
    final progress = progressXp / levelGap;

    return LevelInfo(
      level: level,
      currentXp: progressXp,
      nextLevelXp: levelGap,
      progress: progress,
      totalXp: totalXp,
    );
  }
}

class LevelInfo {
  const LevelInfo({
    required this.level,
    required this.currentXp,
    required this.nextLevelXp,
    required this.progress,
    required this.totalXp,
  });

  final int level;
  final int currentXp; // XP earned in this level
  final int nextLevelXp; // XP needed to define this level length
  final double progress; // 0.0 to 1.0
  final int totalXp;

  String get label => 'Level $level';
}
