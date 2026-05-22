import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/db/content_database_provider.dart';

final conjugationRepositoryProvider = Provider<ConjugationRepository>((ref) {
  return ConjugationRepository(ref.watch(contentDatabaseProvider));
});

const _conjugableKinds = ['verb', 'i_adjective', 'na_adjective'];

class ConjugationRepository {
  ConjugationRepository(this._db);

  final ContentDatabase _db;

  Future<ConjugationLemmaData?> findByContentVocabId(int contentVocabId) {
    return (_db.select(_db.conjugationLemma)
          ..where(
            (tbl) =>
                tbl.contentVocabId.equals(contentVocabId) &
                tbl.kind.isIn(_conjugableKinds),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<ConjugationLemmaData>> fetchByContentVocabIds(
    List<int> contentVocabIds,
  ) {
    if (contentVocabIds.isEmpty) {
      return Future.value(const []);
    }
    final query = _db.select(_db.conjugationLemma)
      ..where(
        (tbl) =>
            tbl.contentVocabId.isIn(contentVocabIds) &
            tbl.kind.isIn(_conjugableKinds),
      )
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.lessonId),
        (tbl) => OrderingTerm.asc(tbl.term),
      ]);
    return query.get();
  }

  Future<List<ConjugationLemmaData>> fetchByDueSkillIds(
    List<int> contentVocabIds,
  ) {
    return fetchByContentVocabIds(contentVocabIds);
  }

  Future<List<ConjugationLemmaData>> fetchByLevel(String level) {
    final query = _db.select(_db.conjugationLemma)
      ..where(
        (tbl) =>
            tbl.level.equals(level.trim().toUpperCase()) &
            tbl.kind.isIn(_conjugableKinds),
      )
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.lessonId),
        (tbl) => OrderingTerm.asc(tbl.term),
      ]);
    return query.get();
  }

  Future<List<ConjugationLemmaData>> fetchByLesson(
    String level,
    int lessonId, {
    String? series,
    int? limit,
  }) {
    final query = _db.select(_db.conjugationLemma)
      ..where(
        (tbl) =>
            tbl.level.equals(level.trim().toUpperCase()) &
            tbl.lessonId.equals(lessonId) &
            tbl.kind.isIn(_conjugableKinds),
      )
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.term),
        (tbl) => OrderingTerm.asc(tbl.contentVocabId),
      ]);
    final normalizedSeries = series?.trim();
    if (normalizedSeries != null && normalizedSeries.isNotEmpty) {
      query.where((tbl) => tbl.series.equals(normalizedSeries));
    }
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<ConjugationLemmaData?> findBySourceIds({
    String? sourceVocabId,
    String? sourceSenseId,
  }) {
    final normalizedSourceVocabId = sourceVocabId?.trim();
    final normalizedSourceSenseId = sourceSenseId?.trim();
    if ((normalizedSourceVocabId == null ||
            normalizedSourceVocabId.isEmpty) &&
        (normalizedSourceSenseId == null || normalizedSourceSenseId.isEmpty)) {
      return Future.value(null);
    }

    final query = _db.select(_db.conjugationLemma);
    query.where((tbl) => tbl.kind.isIn(_conjugableKinds));
    if (normalizedSourceVocabId != null && normalizedSourceVocabId.isNotEmpty) {
      query.where(
        (tbl) => tbl.sourceVocabId.equals(normalizedSourceVocabId),
      );
    }
    if (normalizedSourceSenseId != null && normalizedSourceSenseId.isNotEmpty) {
      query.where(
        (tbl) => tbl.sourceSenseId.equals(normalizedSourceSenseId),
      );
    }
    query.limit(1);
    return query.getSingleOrNull();
  }
}
