
import 'dart:math';

class SrsReviewResult {
  final int box;
  final int repetitions;
  final double easeFactor;
  final int intervalDays;
  final DateTime nextReview;

  SrsReviewResult({
    required this.box,
    required this.repetitions,
    required this.easeFactor,
    required this.intervalDays,
    required this.nextReview,
  });
}

class SrsService {
  static const double _minEase = 1.3;


  /// Calculate next review based on SM-2 algorithm variant
  /// [quality]: 0-5 (0=Blackout, 1=Wrong, 2=Hard, 3=Ok, 4=Good, 5=Perfect)
  SrsReviewResult review({
    required int currentBox,
    required int xRepetitions, // using xRepetitions to avoid confusing with method name
    required double xEaseFactor,
    required int quality,
  }) {
    int repetitions = xRepetitions;
    double easeFactor = xEaseFactor;
    int interval = 1;

    if (quality < 3) {
      // Incorrect answer: reset repetitions, keep ease factor (or penalize slightly)
      repetitions = 0;
      interval = 1;
      // Optional: slight penalty to ease factor even on fail?
      // Standard SM-2 doesn't penalize ease on fail, only resets interval.
      // But we can limit ease drop.
    } else {
      // Correct answer
      repetitions += 1;
      
      // Calculate interval
      if (repetitions == 1) {
        interval = 1;
      } else if (repetitions == 2) {
        interval = 6;
      } else {
        // I(n) = I(n-1) * EF
        // We need previous interval. However, typically SM-2 calculates
        // based on repetition count sequence.
        // A simplified version uses the previous interval * ease.
        // Since we don't store previous interval in SrsState (only next_review),
        // we can approximate or use the box/reps model.
        
        // Let's use a standard approximation derived from repetitions if we lack prev interval
        // Or better, we assume 6 * ease^(reps-2)
        interval = (6 * pow(easeFactor, repetitions - 2)).round();
      }

      // Update Ease Factor
      // EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
      // q is quality 0-5.
      // Note: input quality might be mapped from 3-button system (Again, Hard, Good, Easy) -> (0, 3, 4, 5)
      
      easeFactor = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
      if (easeFactor < _minEase) easeFactor = _minEase;
    }

    return SrsReviewResult(
      box: 1, // field is legacy/Leitner, SM-2 uses reps/ease
      repetitions: repetitions,
      easeFactor: easeFactor,
      intervalDays: interval,
      nextReview: DateTime.now().add(Duration(days: interval)),
    );
  }
}
