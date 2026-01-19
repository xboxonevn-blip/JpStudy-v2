import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/services/srs_service.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/db/database_provider.dart';

import 'package:jpstudy/data/db/content_database.dart' hide UserProgressCompanion, UserProgressData;
import 'package:jpstudy/data/db/content_database_provider.dart';

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepository(
    ref.watch(databaseProvider),
    ref.watch(contentDatabaseProvider),
  );
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
  await repo.seedTermsIfEmpty(args.lessonId, args.level);
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

final progressSummaryProvider = FutureProvider<ProgressSummary>((ref) async {
  final repo = ref.watch(lessonRepositoryProvider);
  return repo.fetchProgressSummary();
});

final lessonPracticeSettingsProvider =
    FutureProvider.family<LessonPracticeSettings, int>((ref, lessonId) async {
  final repo = ref.watch(lessonRepositoryProvider);
  return repo.fetchLessonPracticeSettings(lessonId);
});

final reviewHistoryProvider = FutureProvider<List<ReviewDaySummary>>((ref) async {
  final repo = ref.watch(lessonRepositoryProvider);
  return repo.fetchReviewHistory();
});

final attemptHistoryProvider =
    FutureProvider<List<AttemptSummary>>((ref) async {
  final repo = ref.watch(lessonRepositoryProvider);
  return repo.fetchAttemptHistory();
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
    required this.tags,
    required this.termCount,
    required this.completedCount,
    required this.dueCount,
    required this.updatedAt,
  });

  final int id;
  final String level;
  final String title;
  final bool isCustomTitle;
  final String tags;
  final int termCount;
  final int completedCount;
  final int dueCount;
  final DateTime? updatedAt;
}

class LessonPracticeSettings {
  const LessonPracticeSettings({
    required this.learnTermLimit,
    required this.testQuestionLimit,
    required this.matchPairLimit,
  });

  static const LessonPracticeSettings defaults = LessonPracticeSettings(
    learnTermLimit: 0,
    testQuestionLimit: 12,
    matchPairLimit: 8,
  );

  final int learnTermLimit;
  final int testQuestionLimit;
  final int matchPairLimit;
}

class LessonTermDraft {
  const LessonTermDraft({
    required this.term,
    required this.reading,
    required this.definition,
    required this.kanjiMeaning,
  });

  final String term;
  final String reading;
  final String definition;
  final String kanjiMeaning;
}

class AttemptAnswerDraft {
  const AttemptAnswerDraft({
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
  });

  final int questionId;
  final int selectedIndex;
  final bool isCorrect;
}

class AttemptSummary {
  const AttemptSummary({
    required this.id,
    required this.mode,
    required this.level,
    required this.startedAt,
    required this.finishedAt,
    required this.score,
    required this.total,
  });

  final int id;
  final String mode;
  final String level;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final int score;
  final int total;

  Duration? get duration =>
      finishedAt?.difference(startedAt);
}

class ReviewDaySummary {
  const ReviewDaySummary({
    required this.day,
    required this.reviewed,
    required this.again,
    required this.hard,
    required this.good,
    required this.easy,
  });

  final DateTime day;
  final int reviewed;
  final int again;
  final int hard;
  final int good;
  final int easy;
}

class ProgressSummary {
  const ProgressSummary({
    required this.totalXp,
    required this.todayXp,
    required this.streak,
    required this.totalAttempts,
    required this.totalCorrect,
    required this.totalQuestions,
  });

  final int totalXp;
  final int todayXp;
  final int streak;
  final int totalAttempts;
  final int totalCorrect;
  final int totalQuestions;
}

class LessonRepository {
  LessonRepository(this._db, this._contentDb);

  final AppDatabase _db;
  final ContentDatabase _contentDb;
  final SrsService _srsService = SrsService();
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

  Future<List<UserLessonData>> getAllLessons() {
    return _db.select(_db.userLesson).get();
  }

  // Returns a map of lessonId -> {termCount, completedCount}
  Future<Map<int, LessonProgressStats>> getAllLessonProgress() async {
    final termCounts = await (_db.selectOnly(_db.userLessonTerm)
          ..addColumns([_db.userLessonTerm.lessonId, _db.userLessonTerm.id.count()])
          ..groupBy([_db.userLessonTerm.lessonId]))
        .get();

    final completedCounts = await (_db.selectOnly(_db.userLessonTerm)
          ..addColumns([_db.userLessonTerm.lessonId, _db.userLessonTerm.id.count()])
          ..where(_db.userLessonTerm.isLearned.equals(true))
          ..groupBy([_db.userLessonTerm.lessonId]))
        .get();

    final stats = <int, LessonProgressStats>{};

    for (final row in termCounts) {
      final lessonId = row.read(_db.userLessonTerm.lessonId);
      final count = row.read(_db.userLessonTerm.id.count()) ?? 0;
      if (lessonId != null) {
        stats[lessonId] = LessonProgressStats(termCount: count, completedCount: 0);
      }
    }

    for (final row in completedCounts) {
      final lessonId = row.read(_db.userLessonTerm.lessonId);
      final count = row.read(_db.userLessonTerm.id.count()) ?? 0;
      if (lessonId != null) {
        if (stats.containsKey(lessonId)) {
          stats[lessonId] = stats[lessonId]!.copyWith(completedCount: count);
        } else {
           // Should not happen usually as learned implies existing
           stats[lessonId] = LessonProgressStats(termCount: 0, completedCount: count);
        }
      }
    }
    
    return stats;
  }

  Future<LessonPracticeSettings> fetchLessonPracticeSettings(
    int lessonId,
  ) async {
    final existing = await (_db.select(_db.userLesson)
          ..where((tbl) => tbl.id.equals(lessonId)))
        .getSingleOrNull();
    if (existing == null) {
      return LessonPracticeSettings.defaults;
    }
    return LessonPracticeSettings(
      learnTermLimit: existing.learnTermLimit,
      testQuestionLimit: existing.testQuestionLimit,
      matchPairLimit: existing.matchPairLimit,
    );
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
            learnTermLimit:
                Value(LessonPracticeSettings.defaults.learnTermLimit),
            testQuestionLimit:
                Value(LessonPracticeSettings.defaults.testQuestionLimit),
            matchPairLimit:
                Value(LessonPracticeSettings.defaults.matchPairLimit),
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
    final dueCounts = await _fetchDueCounts(ids);
    return lessons
        .map(
          (lesson) => LessonMeta(
            id: lesson.id,
            level: lesson.level,
            title: lesson.title,
            isCustomTitle: lesson.isCustomTitle,
            tags: lesson.tags,
            termCount: counts[lesson.id] ?? 0,
            completedCount: completedCounts[lesson.id] ?? 0,
            dueCount: dueCounts[lesson.id] ?? 0,
            updatedAt: lesson.updatedAt,
          ),
        )
        .toList();
  }

  Future<Map<int, int>> _fetchDueCounts(List<int> lessonIds) async {
    if (lessonIds.isEmpty) {
      return const {};
    }
    final now = DateTime.now();
    final query = _db.select(_db.userLessonTerm).join([
      innerJoin(
        _db.srsState,
        _db.srsState.vocabId.equalsExp(_db.userLessonTerm.id),
      ),
    ]);
    query
      ..where(_db.userLessonTerm.lessonId.isIn(lessonIds))
      ..where(_db.srsState.nextReviewAt.isSmallerOrEqualValue(now));
    final rows = await query.get();
    final counts = <int, int>{};
    for (final row in rows) {
      final term = row.readTable(_db.userLessonTerm);
      counts.update(term.lessonId, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts;
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

  Future<void> seedTermsIfEmpty(int lessonId, String currentLevelLabel) async {
    final existing = await fetchTerms(lessonId);
    
    // Check if existing terms are the dummy ones and should be replaced
    if (existing.length == 2 && 
        existing[0].term == '見ます' && 
        existing[1].term == '探します') {
       // Delete dummy terms
       await (_db.delete(_db.userLessonTerm)..where((tbl) => tbl.lessonId.equals(lessonId))).go();
    } else if (existing.isNotEmpty) {
      // Real data exists, do nothing
      return;
    }

    // Determine level and offset based on lessonId
    // Standard Minna No Nihongo: ~25-40 words per lesson.
    // If we assume sequential ID in DB:
    // N5: Lesson 1 starts at offset 0.
    // N4: Lesson 26 starts at offset 0 of N4 level?
    
    // We will use 25 words per lesson as a safe default if no mapping exists.
    int limit = 50; // Fetch generous amount, though typical lesson is ~30
    int offset = 0;

    // Normalize level label
    String dbLevel = currentLevelLabel; // e.g. "N5", "N4"

    if (currentLevelLabel == 'N5') {
       // Lesson 1 -> 0
       // Lesson 2 -> 25?
       // Let's assume vaguely 40 items per lesson to be safe, or just 100?
       // Actually, Minna vocab is roughly 1000 words for N5 (25 lessons). 1000/25 = 40 words/lesson.
       offset = (lessonId - 1) * 35; // Approximation
    } else if (currentLevelLabel == 'N4') {
       // N4 starts at Lesson 26.
       offset = (lessonId - 26) * 35;
    }

    if (offset < 0) offset = 0;

    // Fetch from ContentDatabase
    final vocabList = await (_contentDb.select(_contentDb.vocab)
      ..where((tbl) => tbl.level.equals(dbLevel))
      ..limit(limit, offset: offset)) // Fetch limit words
      .get();
    
    if (vocabList.isEmpty) {
      // Fallback if no vocab found
      return;
    }

    // Insert into UserLessonTerm
    await _db.batch((batch) {
      for (var i = 0; i < vocabList.length; i++) {
        final v = vocabList[i];
        batch.insert(
          _db.userLessonTerm,
          UserLessonTermCompanion.insert(
            lessonId: lessonId,
            term: Value(v.term),
            reading: Value(v.reading ?? ''),
            definition: Value(v.meaning),
            orderIndex: Value(i + 1),
          ),
        );
      }
    });
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

  Future<void> updateLessonTags(int lessonId, String tags) {
    return (_db.update(_db.userLesson)..where((tbl) => tbl.id.equals(lessonId)))
        .write(UserLessonCompanion(
      tags: Value(tags),
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

  Future<void> updateLessonPracticeSettings(
    int lessonId, {
    int? learnTermLimit,
    int? testQuestionLimit,
    int? matchPairLimit,
  }) {
    return (_db.update(_db.userLesson)..where((tbl) => tbl.id.equals(lessonId)))
        .write(UserLessonCompanion(
      learnTermLimit:
          learnTermLimit == null ? const Value.absent() : Value(learnTermLimit),
      testQuestionLimit: testQuestionLimit == null
          ? const Value.absent()
          : Value(testQuestionLimit),
      matchPairLimit:
          matchPairLimit == null ? const Value.absent() : Value(matchPairLimit),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<int> addTerm(
    int lessonId, {
    String? term,
    String? reading,
    String? definition,
    String? kanjiMeaning,
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
            kanjiMeaning:
                kanjiMeaning == null ? const Value.absent() : Value(kanjiMeaning),
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
    String? kanjiMeaning,
  }) {
    final update = (_db.update(_db.userLessonTerm)
          ..where((tbl) => tbl.id.equals(termId)))
        .write(UserLessonTermCompanion(
      term: term == null ? const Value.absent() : Value(term),
      reading: reading == null ? const Value.absent() : Value(reading),
      definition:
          definition == null ? const Value.absent() : Value(definition),
      kanjiMeaning:
          kanjiMeaning == null ? const Value.absent() : Value(kanjiMeaning),
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

  Future<void> resetLessonProgress(int lessonId) async {
    final ids = await (_db.selectOnly(_db.userLessonTerm)
          ..addColumns([_db.userLessonTerm.id])
          ..where(_db.userLessonTerm.lessonId.equals(lessonId)))
        .map((row) => row.read(_db.userLessonTerm.id)!)
        .get();
    if (ids.isEmpty) {
      return;
    }
    await _db.transaction(() async {
      await (_db.update(_db.userLessonTerm)
            ..where((tbl) => tbl.lessonId.equals(lessonId)))
          .write(const UserLessonTermCompanion(isLearned: Value(false)));
      await (_db.delete(_db.srsState)
            ..where((tbl) => tbl.vocabId.isIn(ids)))
          .go();
    });
    await _touchLesson(lessonId);
  }

  Future<UserProgressData> _ensureProgressRow(DateTime day) async {
    final existing = await (_db.select(_db.userProgress)
          ..where((tbl) => tbl.day.equals(day)))
        .getSingleOrNull();
    if (existing != null) {
      return existing;
    }
    final yesterday = day.subtract(const Duration(days: 1));
    final yesterdayRow = await (_db.select(_db.userProgress)
          ..where((tbl) => tbl.day.equals(yesterday)))
        .getSingleOrNull();
    final nextStreak = yesterdayRow == null ? 1 : yesterdayRow.streak + 1;
    final id = await _db.into(_db.userProgress).insert(
          UserProgressCompanion.insert(
            day: day,
            xp: const Value(0),
            streak: Value(nextStreak),
            reviewedCount: const Value(0),
            reviewAgainCount: const Value(0),
            reviewHardCount: const Value(0),
            reviewGoodCount: const Value(0),
            reviewEasyCount: const Value(0),
          ),
        );
    return (_db.select(_db.userProgress)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<void> recordStudyActivity({required int xpDelta}) async {
    if (xpDelta <= 0) {
      return;
    }
    final today = _startOfDay(DateTime.now());
    final todayRow = await _ensureProgressRow(today);
    await (_db.update(_db.userProgress)
          ..where((tbl) => tbl.id.equals(todayRow.id)))
        .write(UserProgressCompanion(
      xp: Value(todayRow.xp + xpDelta),
      streak: Value(todayRow.streak),
    ));
  }

  Future<void> recordReview({required int quality}) async {
    final today = _startOfDay(DateTime.now());
    final todayRow = await _ensureProgressRow(today);
    var againDelta = 0;
    var hardDelta = 0;
    var goodDelta = 0;
    var easyDelta = 0;
    switch (quality) {
      case 0:
        againDelta = 1;
        break;
      case 3:
        hardDelta = 1;
        break;
      case 4:
        goodDelta = 1;
        break;
      case 5:
        easyDelta = 1;
        break;
    }
    await (_db.update(_db.userProgress)
          ..where((tbl) => tbl.id.equals(todayRow.id)))
        .write(UserProgressCompanion(
      reviewedCount: Value(todayRow.reviewedCount + 1),
      reviewAgainCount: Value(todayRow.reviewAgainCount + againDelta),
      reviewHardCount: Value(todayRow.reviewHardCount + hardDelta),
      reviewGoodCount: Value(todayRow.reviewGoodCount + goodDelta),
      reviewEasyCount: Value(todayRow.reviewEasyCount + easyDelta),
      streak: Value(todayRow.streak),
    ));
  }

  /// Process an SRS review for a specific term
  Future<void> saveTermReview({
    required int termId,
    required int quality,
  }) async {
    // 1. Update Global Stats
    await recordReview(quality: quality);

    // 2. Get current SRS state
    var srsState = await _db.srsDao.getSrsState(termId);
    
    // Initialize if missing
    if (srsState == null) {
      await _db.srsDao.initializeSrsState(termId);
      srsState = await _db.srsDao.getSrsState(termId);
    }
    
    if (srsState == null) return; // Should not happen

    // 3. Calculate next review
    final result = _srsService.review(
      currentBox: srsState.box,
      xRepetitions: srsState.repetitions,
      xEaseFactor: srsState.ease,
      quality: quality,
    );

    // 4. Update SRS state
    await _db.srsDao.updateSrsState(
      vocabId: termId,
      box: result.box,
      repetitions: result.repetitions,
      ease: result.easeFactor,
      lastConfidence: quality,
      nextReviewAt: result.nextReview,
    );
  }

  Future<int> recordAttempt({
    required String mode,
    required String level,
    required DateTime startedAt,
    required DateTime finishedAt,
    required int score,
    required int total,
    List<AttemptAnswerDraft> answers = const [],
  }) async {
    return _db.transaction(() async {
      final attemptId = await _db.into(_db.attempt).insert(
            AttemptCompanion.insert(
              mode: mode,
              level: level,
              startedAt: startedAt,
              finishedAt: Value(finishedAt),
              score: Value(score),
              total: Value(total),
            ),
          );
      if (answers.isNotEmpty) {
        await _db.batch((batch) {
          for (final answer in answers) {
            batch.insert(
              _db.attemptAnswer,
              AttemptAnswerCompanion.insert(
                attemptId: attemptId,
                questionId: answer.questionId,
                selectedIndex: answer.selectedIndex,
                isCorrect: answer.isCorrect,
              ),
            );
          }
        });
      }
      return attemptId;
    });
  }

  Future<List<ReviewDaySummary>> fetchReviewHistory({int limit = 30}) async {
    final rows = await (_db.select(_db.userProgress)
          ..where((tbl) => tbl.reviewedCount.isBiggerThanValue(0))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.day, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .get();
    return rows
        .map(
          (row) => ReviewDaySummary(
            day: row.day,
            reviewed: row.reviewedCount,
            again: row.reviewAgainCount,
            hard: row.reviewHardCount,
            good: row.reviewGoodCount,
            easy: row.reviewEasyCount,
          ),
        )
        .toList();
  }

  Future<List<AttemptSummary>> fetchAttemptHistory({int limit = 50}) async {
    final rows = await (_db.select(_db.attempt)
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.startedAt,
                  mode: OrderingMode.desc,
                ),
          ])
          ..limit(limit))
        .get();
    return rows
        .map(
          (row) => AttemptSummary(
            id: row.id,
            mode: row.mode,
            level: row.level,
            startedAt: row.startedAt,
            finishedAt: row.finishedAt,
            score: row.score ?? 0,
            total: row.total ?? 0,
          ),
        )
        .toList();
  }

  Future<ProgressSummary> fetchProgressSummary() async {
    final today = _startOfDay(DateTime.now());
    final todayRow = await (_db.select(_db.userProgress)
          ..where((tbl) => tbl.day.equals(today)))
        .getSingleOrNull();
    final latestRow = await (_db.select(_db.userProgress)
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.day, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();

    var streak = 0;
    if (todayRow != null) {
      streak = todayRow.streak;
    } else if (latestRow != null) {
      final yesterday = today.subtract(const Duration(days: 1));
      if (_isSameDay(latestRow.day, yesterday)) {
        streak = latestRow.streak;
      }
    }

    final totalXpRow = await (_db.selectOnly(_db.userProgress)
          ..addColumns([_db.userProgress.xp.sum()]))
        .getSingleOrNull();
    final totalXp = totalXpRow?.read(_db.userProgress.xp.sum()) ?? 0;

    final attemptStats = await (_db.selectOnly(_db.attempt)
          ..addColumns([
            _db.attempt.id.count(),
            _db.attempt.score.sum(),
            _db.attempt.total.sum(),
          ]))
        .getSingleOrNull();
    final totalAttempts = attemptStats?.read(_db.attempt.id.count()) ?? 0;
    final totalCorrect = attemptStats?.read(_db.attempt.score.sum()) ?? 0;
    final totalQuestions = attemptStats?.read(_db.attempt.total.sum()) ?? 0;

    return ProgressSummary(
      totalXp: totalXp,
      todayXp: todayRow?.xp ?? 0,
      streak: streak,
      totalAttempts: totalAttempts,
      totalCorrect: totalCorrect,
      totalQuestions: totalQuestions,
    );
  }

  DateTime _startOfDay(DateTime time) {
    return DateTime(time.year, time.month, time.day);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
                kanjiMeaning: Value(term.kanjiMeaning),
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
            kanjiMeaning: Value(term.kanjiMeaning),
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

  Future<Map<String, dynamic>> exportBackup() async {
    final lessons = await _db.select(_db.userLesson).get();
    final terms = await _db.select(_db.userLessonTerm).get();
    final srs = await _db.select(_db.srsState).get();
    return {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
      'terms': terms.map((term) => term.toJson()).toList(),
      'srs': srs.map((state) => state.toJson()).toList(),
    };
  }

  Future<void> importBackup(Map<String, dynamic> data) async {
    final lessonsRaw = data['lessons'] as List<dynamic>? ?? const [];
    final termsRaw = data['terms'] as List<dynamic>? ?? const [];
    final srsRaw = data['srs'] as List<dynamic>? ?? const [];

    final lessons = lessonsRaw
        .whereType<Map<String, dynamic>>()
        .map(UserLessonData.fromJson)
        .toList();
    final terms = termsRaw
        .whereType<Map<String, dynamic>>()
        .map(UserLessonTermData.fromJson)
        .toList();
    final srs = srsRaw
        .whereType<Map<String, dynamic>>()
        .map(SrsStateData.fromJson)
        .toList();

    await _db.transaction(() async {
      await _db.delete(_db.srsState).go();
      await _db.delete(_db.userLessonTerm).go();
      await _db.delete(_db.userLesson).go();

      await _db.batch((batch) {
        for (final lesson in lessons) {
          batch.insert(
            _db.userLesson,
            lesson.toCompanion(true),
            mode: InsertMode.insertOrReplace,
          );
        }
        for (final term in terms) {
          batch.insert(
            _db.userLessonTerm,
            term.toCompanion(true),
            mode: InsertMode.insertOrReplace,
          );
        }
        for (final state in srs) {
          batch.insert(
            _db.srsState,
            state.toCompanion(true),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
    });
  }

  Future<void> _touchLesson(int lessonId) {
    return (_db.update(_db.userLesson)..where((tbl) => tbl.id.equals(lessonId)))
        .write(UserLessonCompanion(updatedAt: Value(DateTime.now())));
  }
}

class LessonProgressStats {
  const LessonProgressStats({
    required this.termCount,
    required this.completedCount,
  });

  final int termCount;
  final int completedCount;

  LessonProgressStats copyWith({
    int? termCount,
    int? completedCount,
  }) {
    return LessonProgressStats(
      termCount: termCount ?? this.termCount,
      completedCount: completedCount ?? this.completedCount,
    );
  }
}
