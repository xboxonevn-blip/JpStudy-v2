
import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../db/tables.dart';

part 'srs_dao.g.dart';

@DriftAccessor(tables: [SrsState])
class SrsDao extends DatabaseAccessor<AppDatabase> with _$SrsDaoMixin {
  SrsDao(super.db);

  /// Get SRS state for a specific vocab term
  Future<SrsStateData?> getSrsState(int vocabId) {
    return (select(srsState)..where((t) => t.vocabId.equals(vocabId)))
        .getSingleOrNull();
  }

  /// Initialize SRS state for a new term
  Future<int> initializeSrsState(int vocabId) {
    return into(srsState).insert(
      SrsStateCompanion.insert(
        vocabId: vocabId,
        nextReviewAt: DateTime.now(),
        // Defaults: box=1, reps=0, ease=2.5 defined in table
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  /// Update SRS state after a review
  Future<void> updateSrsState({
    required int vocabId,
    required int box,
    required int repetitions,
    required double ease,
    required int lastConfidence,
    required DateTime nextReviewAt,
  }) {
    return (update(srsState)..where((t) => t.vocabId.equals(vocabId))).write(
      SrsStateCompanion(
        box: Value(box),
        repetitions: Value(repetitions),
        ease: Value(ease),
        lastConfidence: Value(lastConfidence),
        lastReviewedAt: Value(DateTime.now()),
        nextReviewAt: Value(nextReviewAt),
      ),
    );
  }

  /// Get all due reviews
  Future<List<SrsStateData>> getDueReviews() {
    return (select(srsState)
          ..where((t) => t.nextReviewAt.isSmallerOrEqualValue(DateTime.now())))
        .get();
  }
}
