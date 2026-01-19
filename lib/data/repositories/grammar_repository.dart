import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';

final grammarRepositoryProvider = Provider<GrammarRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return GrammarRepository(db);
});

class GrammarRepository {
  final AppDatabase _db;

  GrammarRepository(this._db);

  /// Fetch all grammar points for a specific JLPT level
  Future<List<GrammarPoint>> fetchPointsByLevel(String level) {
    return _db.grammarDao.getGrammarPointsByLevel(level);
  }

  /// Fetch full details for a grammar point (including examples)
  Future<({GrammarPoint point, List<GrammarExample> examples})?> getGrammarDetail(int id) async {
    final point = await _db.grammarDao.getGrammarPoint(id);
    if (point == null) return null;
    
    final examples = await _db.grammarDao.getExamplesForPoint(id);
    return (point: point, examples: examples);
  }

  /// Initialize SRS for a grammar point if not exists
  Future<void> ensureSrsInitialized(int grammarId) async {
    final existing = await _db.grammarDao.getSrsState(grammarId);
    if (existing == null) {
      await _db.grammarDao.initializeSrsState(grammarId);
    }
  }

  /// Record a review for a grammar point
  /// Handles "Ghost Review" logic:
  /// - If quality < 3 (Wrong): Create/Reset Ghost.
  /// - If quality >= 3 (Correct): Reduce Ghost or Advance SRS.
  Future<void> recordReview({
    required int grammarId,
    required int quality, // 0-5
  }) async {
    await ensureSrsInitialized(grammarId);
    final state = await _db.grammarDao.getSrsState(grammarId);
    if (state == null) return;

    // Use SrsService logic here? Or custom Grammar logic?
    // For now, implementing basic SRS update similar to vocab but with Ghost concept stubbed.
    
    // Simple SM-2 implementation inline for now, can move to service later
    int newStreak = state.streak;
    double newEase = state.ease;
    int interval = 1;

    if (quality < 3) {
      newStreak = 0;
      interval = 1;
      // Ghost logic: Mark as needing special review
      // In future: set ghostReviewsDue = 1
    } else {
      newStreak += 1;
      if (newStreak == 1) {
        interval = 1;
      } else if (newStreak == 2) {
        interval = 6;
      } else {
        final daysSinceReview = state.lastReviewedAt == null 
            ? 0 
            : DateTime.now().difference(state.lastReviewedAt!).inDays;
        // Use max(1, days) to avoid 0 mul
        final days = daysSinceReview < 1 ? 1 : daysSinceReview;
        interval = (days * state.ease).round();
      }
      
      if (interval < 1) {
        interval = 1;
      }

      newEase = state.ease + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
      if (newEase < 1.3) {
        newEase = 1.3;
      }
    }

    await _db.grammarDao.updateSrsState(
      grammarId: grammarId,
      streak: newStreak,
      ease: newEase,
      nextReviewAt: DateTime.now().add(Duration(days: interval)),
    );
  }
}
