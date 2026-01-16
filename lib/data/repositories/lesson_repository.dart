import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/db/database_provider.dart';

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepository(ref.watch(databaseProvider));
});

final lessonTitleProvider =
    FutureProvider.family<String, LessonTitleArgs>((ref, args) async {
  final repo = ref.watch(lessonRepositoryProvider);
  return repo.getLessonTitle(args.lessonId, args.fallback);
});

final lessonTermsProvider =
    FutureProvider.family<List<UserLessonTermData>, LessonTermsArgs>(
        (ref, args) async {
  final repo = ref.watch(lessonRepositoryProvider);
  await repo.ensureLesson(
    lessonId: args.lessonId,
    level: args.level,
    title: args.fallbackTitle,
  );
  await repo.seedTermsIfEmpty(args.lessonId);
  return repo.fetchTerms(args.lessonId);
});

class LessonTitleArgs {
  const LessonTitleArgs(this.lessonId, this.fallback);

  final int lessonId;
  final String fallback;

  @override
  bool operator ==(Object other) {
    return other is LessonTitleArgs &&
        other.lessonId == lessonId &&
        other.fallback == fallback;
  }

  @override
  int get hashCode => Object.hash(lessonId, fallback);
}

class LessonTermsArgs {
  const LessonTermsArgs(this.lessonId, this.level, this.fallbackTitle);

  final int lessonId;
  final String level;
  final String fallbackTitle;

  @override
  bool operator ==(Object other) {
    return other is LessonTermsArgs &&
        other.lessonId == lessonId &&
        other.level == level &&
        other.fallbackTitle == fallbackTitle;
  }

  @override
  int get hashCode => Object.hash(lessonId, level, fallbackTitle);
}

class LessonRepository {
  LessonRepository(this._db);

  final AppDatabase _db;

  Future<String> getLessonTitle(int lessonId, String fallback) async {
    final existing = await (_db.select(_db.userLesson)
          ..where((tbl) => tbl.id.equals(lessonId)))
        .getSingleOrNull();
    if (existing == null) {
      return fallback;
    }
    return existing.isCustomTitle ? existing.title : fallback;
  }

  Future<UserLessonData> ensureLesson({
    required int lessonId,
    required String level,
    required String title,
  }) async {
    final existing = await (_db.select(_db.userLesson)
          ..where((tbl) => tbl.id.equals(lessonId)))
        .getSingleOrNull();
    if (existing != null) {
      return existing;
    }
    await _db.into(_db.userLesson).insert(
          UserLessonCompanion.insert(
            id: Value(lessonId),
            level: level,
            title: title,
            description: const Value(''),
            isPublic: const Value(true),
            isCustomTitle: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        );
    return (_db.select(_db.userLesson)
          ..where((tbl) => tbl.id.equals(lessonId)))
        .getSingle();
  }

  Future<List<UserLessonTermData>> fetchTerms(int lessonId) {
    return (_db.select(_db.userLessonTerm)
          ..where((tbl) => tbl.lessonId.equals(lessonId))
          ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.orderIndex),
          ]))
        .get();
  }

  Future<void> seedTermsIfEmpty(int lessonId) async {
    final existing = await fetchTerms(lessonId);
    if (existing.isNotEmpty) {
      return;
    }
    await _db.into(_db.userLessonTerm).insert(
          UserLessonTermCompanion.insert(
            lessonId: lessonId,
            term: const Value('見ます'),
            reading: const Value('みます'),
            definition: const Value('KIEN\nxem,nhìn'),
            orderIndex: const Value(1),
          ),
        );
    await _db.into(_db.userLessonTerm).insert(
          UserLessonTermCompanion.insert(
            lessonId: lessonId,
            term: const Value('探します'),
            reading: const Value('さがします'),
            definition: const Value('THAM\ntìm,tìm kiếm (cv,người...)'),
            orderIndex: const Value(2),
          ),
        );
  }

  Future<void> updateLessonTitle(int lessonId, String title) {
    return (_db.update(_db.userLesson)..where((tbl) => tbl.id.equals(lessonId)))
        .write(UserLessonCompanion(
      title: Value(title),
      isCustomTitle: const Value(true),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateLessonDescription(int lessonId, String description) {
    return (_db.update(_db.userLesson)..where((tbl) => tbl.id.equals(lessonId)))
        .write(UserLessonCompanion(
      description: Value(description),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateLessonPublic(int lessonId, bool isPublic) {
    return (_db.update(_db.userLesson)..where((tbl) => tbl.id.equals(lessonId)))
        .write(UserLessonCompanion(
      isPublic: Value(isPublic),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<int> addTerm(int lessonId) async {
    final maxOrder = await (_db.selectOnly(_db.userLessonTerm)
          ..addColumns([_db.userLessonTerm.orderIndex])
          ..where(_db.userLessonTerm.lessonId.equals(lessonId))
          ..orderBy([
            OrderingTerm(
              expression: _db.userLessonTerm.orderIndex,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(1))
        .getSingleOrNull();
    final nextOrder = (maxOrder?.read(_db.userLessonTerm.orderIndex) ?? 0) + 1;
    return _db.into(_db.userLessonTerm).insert(
          UserLessonTermCompanion.insert(
            lessonId: lessonId,
            orderIndex: Value(nextOrder),
          ),
        );
  }

  Future<void> updateTerm(
    int termId, {
    String? term,
    String? reading,
    String? definition,
  }) {
    return (_db.update(_db.userLessonTerm)..where((tbl) => tbl.id.equals(termId)))
        .write(UserLessonTermCompanion(
      term: term == null ? const Value.absent() : Value(term),
      reading: reading == null ? const Value.absent() : Value(reading),
      definition:
          definition == null ? const Value.absent() : Value(definition),
    ));
  }

  Future<void> deleteTerm(int termId) {
    return (_db.delete(_db.userLessonTerm)
          ..where((tbl) => tbl.id.equals(termId)))
        .go();
  }
}
