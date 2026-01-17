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

final lessonMetaProvider =
    FutureProvider.family<List<LessonMeta>, String>((ref, level) async {
  final repo = ref.watch(lessonRepositoryProvider);
  return repo.fetchLessonMeta(level);
});

final lessonDueTermsProvider =
    FutureProvider.family<List<UserLessonTermData>, int>((ref, lessonId) async {
  final repo = ref.watch(lessonRepositoryProvider);
  return repo.fetchDueTerms(lessonId);
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

class LessonMeta {
  const LessonMeta({
    required this.id,
    required this.level,
    required this.title,
    required this.isCustomTitle,
    required this.termCount,
    required this.completedCount,
    required this.updatedAt,
  });

  final int id;
  final String level;
  final String title;
  final bool isCustomTitle;
  final int termCount;
  final int completedCount;
  final DateTime? updatedAt;
}

class LessonTermDraft {
  const LessonTermDraft({
    required this.term,
    required this.reading,
    required this.definition,
  });

  final String term;
  final String reading;
  final String definition;
}

class LessonRepository {
  LessonRepository(this._db);

  final AppDatabase _db;
  static const int _defaultLessonCount = 25;

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

  Future<List<LessonMeta>> fetchLessonMeta(String level) async {
    final lessons = await (_db.select(_db.userLesson)
          ..where((tbl) => tbl.level.equals(level)))
        .get();
    if (lessons.isEmpty) {
      return const [];
    }
    final ids = lessons.map((lesson) => lesson.id).toList();
    final terms = await (_db.select(_db.userLessonTerm)
          ..where((tbl) => tbl.lessonId.isIn(ids)))
        .get();
    final counts = <int, int>{};
    final completedCounts = <int, int>{};
    for (final term in terms) {
      counts.update(term.lessonId, (value) => value + 1, ifAbsent: () => 1);
      if (term.isLearned) {
        completedCounts.update(
          term.lessonId,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }
    return lessons
        .map(
          (lesson) => LessonMeta(
            id: lesson.id,
            level: lesson.level,
            title: lesson.title,
            isCustomTitle: lesson.isCustomTitle,
            termCount: counts[lesson.id] ?? 0,
            completedCount: completedCounts[lesson.id] ?? 0,
            updatedAt: lesson.updatedAt,
          ),
        )
        .toList();
  }

  Future<int> nextLessonId() async {
    final maxId = await (_db.selectOnly(_db.userLesson)
          ..addColumns([_db.userLesson.id])
          ..orderBy([
            OrderingTerm(expression: _db.userLesson.id, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
    final currentMax = maxId?.read(_db.userLesson.id) ?? 0;
    final base = currentMax < _defaultLessonCount
        ? _defaultLessonCount
        : currentMax;
    return base + 1;
  }

  Future<int> createLesson({
    required String level,
    required String title,
    required bool isPublic,
    required bool isCustomTitle,
  }) async {
    final nextId = await nextLessonId();
    await _db.into(_db.userLesson).insert(
          UserLessonCompanion.insert(
            id: Value(nextId),
            level: level,
            title: title,
            description: const Value(''),
            isPublic: Value(isPublic),
            isCustomTitle: Value(isCustomTitle),
            updatedAt: Value(DateTime.now()),
          ),
        );
    return nextId;
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

  Future<void> updateLessonTitle(
    int lessonId,
    String title, {
    bool isCustomTitle = true,
  }) {
    return (_db.update(_db.userLesson)..where((tbl) => tbl.id.equals(lessonId)))
        .write(UserLessonCompanion(
      title: Value(title),
      isCustomTitle: Value(isCustomTitle),
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

  Future<int> addTerm(
    int lessonId, {
    String? term,
    String? reading,
    String? definition,
  }) async {
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
    final termId = await _db.into(_db.userLessonTerm).insert(
          UserLessonTermCompanion.insert(
            lessonId: lessonId,
            orderIndex: Value(nextOrder),
            term: term == null ? const Value.absent() : Value(term),
            reading: reading == null ? const Value.absent() : Value(reading),
            definition:
                definition == null ? const Value.absent() : Value(definition),
          ),
        );
    await _touchLesson(lessonId);
    return termId;
  }

  Future<void> updateTerm(
    int termId, {
    int? lessonId,
    String? term,
    String? reading,
    String? definition,
  }) {
    final update = (_db.update(_db.userLessonTerm)
          ..where((tbl) => tbl.id.equals(termId)))
        .write(UserLessonTermCompanion(
      term: term == null ? const Value.absent() : Value(term),
      reading: reading == null ? const Value.absent() : Value(reading),
      definition:
          definition == null ? const Value.absent() : Value(definition),
    ));
    if (lessonId == null) {
      return update;
    }
    return update.then((_) => _touchLesson(lessonId));
  }

  Future<void> updateTermStar(
    int termId, {
    required bool isStarred,
    int? lessonId,
  }) {
    final update = (_db.update(_db.userLessonTerm)
          ..where((tbl) => tbl.id.equals(termId)))
        .write(UserLessonTermCompanion(isStarred: Value(isStarred)));
    if (lessonId == null) {
      return update;
    }
    return update.then((_) => _touchLesson(lessonId));
  }

  Future<void> updateTermLearned(
    int termId, {
    required bool isLearned,
    int? lessonId,
  }) {
    final update = (_db.update(_db.userLessonTerm)
          ..where((tbl) => tbl.id.equals(termId)))
        .write(UserLessonTermCompanion(isLearned: Value(isLearned)));
    if (lessonId == null) {
      return update;
    }
    return update.then((_) => _touchLesson(lessonId));
  }

  Future<void> setStarredForLesson(int lessonId, bool isStarred) async {
    await (_db.update(_db.userLessonTerm)
          ..where((tbl) => tbl.lessonId.equals(lessonId)))
        .write(UserLessonTermCompanion(isStarred: Value(isStarred)));
    await _touchLesson(lessonId);
  }

  Future<void> deleteTerm(int termId, {int? lessonId}) {
    final delete = (_db.delete(_db.userLessonTerm)
          ..where((tbl) => tbl.id.equals(termId)))
        .go();
    if (lessonId == null) {
      return delete;
    }
    return delete.then((_) => _touchLesson(lessonId));
  }

  Future<void> updateTermOrder(int lessonId, List<int> orderedIds) async {
    await _db.batch((batch) {
      for (var i = 0; i < orderedIds.length; i++) {
        batch.update(
          _db.userLessonTerm,
          UserLessonTermCompanion(orderIndex: Value(i + 1)),
          where: (tbl) => tbl.id.equals(orderedIds[i]),
        );
      }
    });
    await _touchLesson(lessonId);
  }

  Future<void> replaceTerms(
    int lessonId,
    List<LessonTermDraft> terms,
  ) async {
    await _db.transaction(() async {
      await (_db.delete(_db.userLessonTerm)
            ..where((tbl) => tbl.lessonId.equals(lessonId)))
          .go();
      for (var i = 0; i < terms.length; i++) {
        final term = terms[i];
        await _db.into(_db.userLessonTerm).insert(
              UserLessonTermCompanion.insert(
                lessonId: lessonId,
                orderIndex: Value(i + 1),
                term: Value(term.term),
                reading: Value(term.reading),
                definition: Value(term.definition),
              ),
            );
      }
    });
    await _touchLesson(lessonId);
  }

  Future<void> appendTerms(
    int lessonId,
    List<LessonTermDraft> terms,
  ) async {
    if (terms.isEmpty) {
      return;
    }
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
    var nextOrder = (maxOrder?.read(_db.userLessonTerm.orderIndex) ?? 0) + 1;
    await _db.batch((batch) {
      for (final term in terms) {
        batch.insert(
          _db.userLessonTerm,
          UserLessonTermCompanion.insert(
            lessonId: lessonId,
            orderIndex: Value(nextOrder),
            term: Value(term.term),
            reading: Value(term.reading),
            definition: Value(term.definition),
          ),
        );
        nextOrder += 1;
      }
    });
    await _touchLesson(lessonId);
  }

  Future<List<UserLessonTermData>> fetchDueTerms(int lessonId) {
    final now = DateTime.now();
    final query = _db.select(_db.userLessonTerm).join([
      innerJoin(
        _db.srsState,
        _db.srsState.vocabId.equalsExp(_db.userLessonTerm.id),
      ),
    ]);
    query
      ..where(_db.userLessonTerm.lessonId.equals(lessonId))
      ..where(_db.srsState.nextReviewAt.isSmallerOrEqualValue(now))
      ..orderBy([
        OrderingTerm(expression: _db.userLessonTerm.orderIndex),
      ]);
    return query.map((row) => row.readTable(_db.userLessonTerm)).get();
  }

  Future<SrsStateData?> getSrsState(int termId) {
    return (_db.select(_db.srsState)
          ..where((tbl) => tbl.vocabId.equals(termId)))
        .getSingleOrNull();
  }

  Future<void> upsertSrsState({
    required int termId,
    required int box,
    required int repetitions,
    required double ease,
    required DateTime nextReviewAt,
    required DateTime lastReviewedAt,
  }) {
    return _db.into(_db.srsState).insertOnConflictUpdate(
          SrsStateCompanion(
            vocabId: Value(termId),
            box: Value(box),
            repetitions: Value(repetitions),
            ease: Value(ease),
            lastReviewedAt: Value(lastReviewedAt),
            nextReviewAt: Value(nextReviewAt),
          ),
        );
  }

  Future<void> deleteSrsState(int termId) {
    return (_db.delete(_db.srsState)
          ..where((tbl) => tbl.vocabId.equals(termId)))
        .go();
  }

  Future<void> _touchLesson(int lessonId) {
    return (_db.update(_db.userLesson)..where((tbl) => tbl.id.equals(lessonId)))
        .write(UserLessonCompanion(updatedAt: Value(DateTime.now())));
  }
}
