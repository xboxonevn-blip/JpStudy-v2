import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/db/content_database_provider.dart';

final vocabPreviewProvider =
    FutureProvider.family<List<VocabData>, String>((ref, level) async {
  final db = ref.watch(contentDatabaseProvider);
  final query = db.select(db.vocab)
    ..where((tbl) => tbl.level.equals(level))
    ..limit(100); // Increase limit for more variety
  return query.get();
});

class ContentRepository {
  final ContentDatabase _db;

  ContentRepository(this._db);

  Future<void> updateProgress(int vocabId, bool isCorrect) async {
    final existing = await (_db.select(_db.userProgress)
          ..where((tbl) => tbl.vocabId.equals(vocabId)))
        .getSingleOrNull();

    if (existing == null) {
      await _db.into(_db.userProgress).insert(
            UserProgressCompanion.insert(
              vocabId: Value(vocabId),
              correctCount: Value(isCorrect ? 1 : 0),
              missedCount: Value(isCorrect ? 0 : 1),
              lastReviewedAt: Value(DateTime.now()),
            ),
          );
    } else {
      await (_db.update(_db.userProgress)
            ..where((tbl) => tbl.vocabId.equals(vocabId)))
          .write(
        UserProgressCompanion(
          correctCount: Value(existing.correctCount + (isCorrect ? 1 : 0)),
          missedCount: Value(existing.missedCount + (isCorrect ? 0 : 1)),
          lastReviewedAt: Value(DateTime.now()),
        ),
      );
    }
  }
}

final contentRepositoryProvider = Provider((ref) {
  return ContentRepository(ref.watch(contentDatabaseProvider));
});
