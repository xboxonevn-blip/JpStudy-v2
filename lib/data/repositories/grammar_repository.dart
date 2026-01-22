import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';

final grammarRepositoryProvider = Provider<GrammarRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return GrammarRepository(db);
});

class GrammarRepository {
  final AppDatabase _db;
  AppDatabase get db => _db;

  GrammarRepository(this._db);

  /// Fetch all grammar points for a specific JLPT level
  Future<List<GrammarPoint>> fetchPointsByLevel(String level) {
    return _db.grammarDao.getGrammarPointsByLevel(level);
  }

  /// Fetch all grammar points due for review
  Future<List<GrammarPoint>> fetchDuePoints() async {
    final dueStates = await _db.grammarDao.getDueReviews();
    final ids = dueStates.map((s) => s.grammarId).toList();
    if (ids.isEmpty) return [];
    
    // Fetch actual points for these ids
    final points = await (_db.select(_db.grammarPoints)..where((t) => t.id.isIn(ids))).get();
    return points;
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
    int ghostReviewsDue = state.ghostReviewsDue;

    if (quality < 3) {
      newStreak = 0;
      interval = 1;
      // Ghost logic: Mark as needing special review
      ghostReviewsDue = 1; // Need 1 successful review to clear ghost status
    } else {
      // If was ghost application, we just clear the ghost status but don't advance SRS much
      if (ghostReviewsDue > 0) {
         ghostReviewsDue = 0;
         // Don't change streak/ease significantly for ghost clearing, or maybe small boost
      } else {
        // Normal SRS advancement
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
    }

    await _db.grammarDao.updateSrsState(
      grammarId: grammarId,
      streak: newStreak,
      ease: newEase,
      nextReviewAt: DateTime.now().add(Duration(days: interval)),
      ghostReviewsDue: ghostReviewsDue,
    );
  }

  /// Fetch all grammar points that are "Ghosts" (failed previously)
  Future<List<GrammarPoint>> fetchGhostPoints() async {
    final ghostStates = await _db.grammarDao.getGhostReviews();
    final ids = ghostStates.map((s) => s.grammarId).toList();
    if (ids.isEmpty) return [];
    
    // Fetch actual points for these ids
    final points = await (_db.select(_db.grammarPoints)..where((t) => t.id.isIn(ids))).get();
    return points;
  }

  /// Mark a grammar point as learned and initialize SRS
  Future<void> markAsLearned(int grammarId) async {
    await _db.grammarDao.updateLearnedStatus(grammarId, true);
    await ensureSrsInitialized(grammarId);
  }
}
