import 'dart:math';

class FsrsReviewResult {
  final double stability;
  final double difficulty;
  final double retrievability;
  final double intervalDays;
  final DateTime nextReviewAt;

  const FsrsReviewResult({
    required this.stability,
    required this.difficulty,
    required this.retrievability,
    required this.intervalDays,
    required this.nextReviewAt,
  });
}

class FsrsService {
  static const double defaultRetention = 0.9;

  static const List<double> _w = [
    0.4,
    0.6,
    2.4,
    5.8,
    4.93,
    0.94,
    0.86,
    0.01,
    1.49,
    0.14,
    0.94,
    2.18,
    0.05,
    0.34,
    1.26,
    0.29,
    2.61,
  ];

  double _initialStability(int grade) {
    return _w[(grade - 1).clamp(0, 3)];
  }

  double _initialDifficulty(int grade) {
    return _w[4] - (grade - 3) * _w[5];
  }

  double _clampDifficulty(double difficulty) {
    return difficulty.clamp(1.0, 10.0);
  }

  double _meanReversionDifficulty(double difficulty, int grade) {
    final baseline = _initialDifficulty(3);
    final adjusted = difficulty - _w[6] * (grade - 3);
    return _w[7] * baseline + (1 - _w[7]) * adjusted;
  }

  double _retrievability({
    required double stability,
    required double elapsedDays,
  }) {
    final safeStability = max(0.1, stability);
    return pow(1 + elapsedDays / (9 * safeStability), -1).toDouble();
  }

  double _nextIntervalDays(double stability, double retention) {
    final safeRetention = retention.clamp(0.1, 0.99);
    return 9 * stability * (1 / safeRetention - 1);
  }

  double _stabilityAfterRecall({
    required double stability,
    required double difficulty,
    required double retrievability,
    required int grade,
  }) {
    final hardFactor = grade == 2 ? _w[15] : 1.0;
    final easyFactor = grade == 4 ? _w[16] : 1.0;
    final growth =
        exp(_w[8]) *
        (11 - difficulty) *
        pow(stability, -_w[9]) *
        (exp(_w[10] * (1 - retrievability)) - 1);
    return stability * (growth * hardFactor * easyFactor + 1);
  }

  double _stabilityAfterForget({
    required double stability,
    required double difficulty,
    required double retrievability,
  }) {
    return _w[11] *
        pow(difficulty, -_w[12]) *
        (pow(stability + 1, _w[13]) - 1) *
        exp(_w[14] * (1 - retrievability));
  }

  FsrsReviewResult review({
    required int grade,
    required double stability,
    required double difficulty,
    required DateTime? lastReviewedAt,
    DateTime? now,
    double retention = defaultRetention,
  }) {
    final normalizedGrade = grade.clamp(1, 4);
    final reviewTime = now ?? DateTime.now();

    if (lastReviewedAt == null) {
      final nextStability = _initialStability(normalizedGrade);
      final nextDifficulty = _clampDifficulty(
        _initialDifficulty(normalizedGrade),
      );
      final intervalDays = _nextIntervalDays(nextStability, retention);
      return FsrsReviewResult(
        stability: max(0.1, nextStability),
        difficulty: nextDifficulty,
        retrievability: 1,
        intervalDays: max(0.01, intervalDays),
        nextReviewAt: reviewTime.add(
          _intervalDuration(max(0.01, intervalDays)),
        ),
      );
    }

    final elapsedSeconds = reviewTime
        .difference(lastReviewedAt)
        .inSeconds
        .toDouble();
    final elapsedDays = max(0.0, elapsedSeconds / 86400.0);
    final retrievability = _retrievability(
      stability: stability,
      elapsedDays: elapsedDays,
    );
    final nextDifficulty = _clampDifficulty(
      _meanReversionDifficulty(difficulty, normalizedGrade),
    );

    final nextStability = normalizedGrade == 1
        ? _stabilityAfterForget(
            stability: stability,
            difficulty: nextDifficulty,
            retrievability: retrievability,
          )
        : _stabilityAfterRecall(
            stability: stability,
            difficulty: nextDifficulty,
            retrievability: retrievability,
            grade: normalizedGrade,
          );

    final intervalDays = _nextIntervalDays(max(0.1, nextStability), retention);

    return FsrsReviewResult(
      stability: max(0.1, nextStability),
      difficulty: nextDifficulty,
      retrievability: retrievability,
      intervalDays: max(0.01, intervalDays),
      nextReviewAt: reviewTime.add(_intervalDuration(max(0.01, intervalDays))),
    );
  }

  Duration _intervalDuration(double intervalDays) {
    final seconds = (intervalDays * 86400).round();
    return Duration(seconds: max(60, seconds));
  }

  double retrievability({
    required double stability,
    required DateTime? lastReviewedAt,
    DateTime? now,
  }) {
    if (lastReviewedAt == null) return 0;
    final elapsedSeconds = (now ?? DateTime.now())
        .difference(lastReviewedAt)
        .inSeconds
        .toDouble();
    final elapsedDays = max(0.0, elapsedSeconds / 86400.0);
    return _retrievability(stability: stability, elapsedDays: elapsedDays);
  }
}
