import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/db/content_database_provider.dart';

final vocabPreviewProvider = FutureProvider.family<List<VocabData>, String>((
  ref,
  level,
) async {
  final db = ref.watch(contentDatabaseProvider);
  final query = db.select(db.vocab)
    ..where(
      (tbl) =>
          tbl.level.equals(level) &
          tbl.term.like('%?%').not() &
          tbl.reading.like('%?%').not(),
    );
  final result = await query.get();
  // DEBUG: Check for specific Minna words
  // final debugTerms = ['私', '見ます', '探します', '食べる'];
  // for (final t in debugTerms) {
  //   try {
  //     final found = result.firstWhere((item) => item.term == t);
  //     // print('DEBUG_TAGS_SPECIFIC: ${found.term} - ${found.tags} - ${found.level}');
  //   } catch (_) {
  //     // print('DEBUG_TAGS_SPECIFIC: $t NOT FOUND');
  //   }
  // }
  return result;
});

class ContentRepository {
  final ContentDatabase _db;

  ContentRepository(this._db);

  Future<String> getDebugTags(String term) async {
    final item = await (_db.select(
      _db.vocab,
    )..where((tbl) => tbl.term.equals(term))).getSingleOrNull();
    return item != null
        ? '${item.term}: ${item.tags} (Level: ${item.level})'
        : '$term NOT FOUND';
  }

  Future<void> updateProgress(int vocabId, bool isCorrect) async {
    final existing = await (_db.select(
      _db.userProgress,
    )..where((tbl) => tbl.vocabId.equals(vocabId))).getSingleOrNull();

    if (existing == null) {
      await _db
          .into(_db.userProgress)
          .insert(
            UserProgressCompanion.insert(
              vocabId: Value(vocabId),
              correctCount: Value(isCorrect ? 1 : 0),
              missedCount: Value(isCorrect ? 0 : 1),
              lastReviewedAt: Value(DateTime.now()),
            ),
          );
    } else {
      await (_db.update(
        _db.userProgress,
      )..where((tbl) => tbl.vocabId.equals(vocabId))).write(
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
