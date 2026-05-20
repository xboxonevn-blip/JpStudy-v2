import 'dart:convert';

import 'package:drift/drift.dart';
import '../../core/services/fsrs_service.dart';
import '../db/app_database.dart';
import '../db/conjugation_tables.dart';
import '../db/mistake_tables.dart';

part 'conjugation_srs_dao.g.dart';

@DriftAccessor(tables: [ConjugationSrsState, UserMistakes])
class ConjugationSrsDao extends DatabaseAccessor<AppDatabase>
    with _$ConjugationSrsDaoMixin {
  ConjugationSrsDao(super.db);

  final FsrsService _fsrsService = FsrsService();

  Future<ConjugationSrsStateData?> getSrsState({
    required int contentVocabId,
    required String formKey,
    required String direction,
  }) {
    return (select(conjugationSrsState)..where(
          (t) =>
              t.contentVocabId.equals(contentVocabId) &
              t.formKey.equals(formKey) &
              t.direction.equals(direction),
        ))
        .getSingleOrNull();
  }

  Future<List<ConjugationSrsStateData>> getStatesForContentVocabIds(
    List<int> contentVocabIds,
  ) {
    if (contentVocabIds.isEmpty) return Future.value(const []);
    return (select(conjugationSrsState)
          ..where((t) => t.contentVocabId.isIn(contentVocabIds))
          ..orderBy([
            (t) => OrderingTerm.asc(t.contentVocabId),
            (t) => OrderingTerm.asc(t.formKey),
            (t) => OrderingTerm.asc(t.direction),
          ]))
        .get();
  }

  Future<int> initializeSrsState({
    required int contentVocabId,
    required String formKey,
    required String direction,
    DateTime? nextReviewAt,
  }) {
    return into(conjugationSrsState).insert(
      ConjugationSrsStateCompanion.insert(
        contentVocabId: contentVocabId,
        formKey: formKey,
        direction: direction,
        nextReviewAt: nextReviewAt ?? DateTime.now(),
        fsrsState: Value(FsrsCardState.learning.dbValue),
        fsrsStep: const Value(0),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> updateSrsState({
    required int contentVocabId,
    required String formKey,
    required String direction,
    required double stability,
    required double difficulty,
    required int lastConfidence,
    required DateTime nextReviewAt,
    required DateTime lastReviewedAt,
    FsrsCardState? fsrsState,
    int? fsrsStep,
  }) {
    return (update(conjugationSrsState)..where(
          (t) =>
              t.contentVocabId.equals(contentVocabId) &
              t.formKey.equals(formKey) &
              t.direction.equals(direction),
        ))
        .write(
          ConjugationSrsStateCompanion(
            stability: Value(stability),
            difficulty: Value(difficulty),
            lastConfidence: Value(lastConfidence),
            lastReviewedAt: Value(lastReviewedAt),
            nextReviewAt: Value(nextReviewAt),
            fsrsState: fsrsState == null
                ? const Value.absent()
                : Value(fsrsState.dbValue),
            fsrsStep: fsrsState == null && fsrsStep == null
                ? const Value.absent()
                : Value(fsrsStep),
          ),
        );
  }

  Future<void> recordReview({
    required int contentVocabId,
    required String formKey,
    required String direction,
    required int grade,
    String? conjugationClass,
    String? expectedSurface,
    int? grammarId,
    String? dictionaryForm,
    String? prompt,
    String? correctAnswer,
    String? userAnswer,
    String? source,
    DateTime? now,
  }) async {
    final reviewTime = now ?? DateTime.now();
    await initializeSrsState(
      contentVocabId: contentVocabId,
      formKey: formKey,
      direction: direction,
      nextReviewAt: reviewTime,
    );
    final state = await getSrsState(
      contentVocabId: contentVocabId,
      formKey: formKey,
      direction: direction,
    );
    if (state == null) return;

    final nextGrade = grade.clamp(1, 4);
    final result = _fsrsService.review(
      grade: nextGrade,
      stability: state.stability,
      difficulty: state.difficulty,
      lastReviewedAt: state.lastReviewedAt,
      now: reviewTime,
      cardState: FsrsCardState.fromDbValue(state.fsrsState),
      step: state.fsrsStep,
    );

    await updateSrsState(
      contentVocabId: contentVocabId,
      formKey: formKey,
      direction: direction,
      stability: result.stability,
      difficulty: result.difficulty,
      lastConfidence: nextGrade,
      lastReviewedAt: reviewTime,
      nextReviewAt: result.nextReviewAt,
      fsrsState: result.cardState,
      fsrsStep: result.step,
    );

    if (nextGrade == 1) {
      final extra = <String, Object?>{
        'contentVocabId': contentVocabId,
        'formKey': formKey,
        'direction': direction,
      };
      if (conjugationClass != null) {
        extra['conjugationClass'] = conjugationClass;
      }
      if (expectedSurface != null) {
        extra['expectedSurface'] = expectedSurface;
      }
      if (dictionaryForm != null) {
        extra['dictionaryForm'] = dictionaryForm;
      }
      if (grammarId != null) {
        extra['grammarId'] = grammarId;
      }
      await db.mistakeDao.addMistake(
        'conjugation',
        contentVocabId,
        prompt: prompt,
        correctAnswer: correctAnswer,
        userAnswer: userAnswer,
        source: source,
        extraJson: json.encode(extra),
      );
    }
  }

  Future<List<ConjugationSrsStateData>> getDueReviews({DateTime? now}) {
    return (select(conjugationSrsState)..where(
          (t) => t.nextReviewAt.isSmallerOrEqualValue(now ?? DateTime.now()),
        ))
        .get();
  }

  Future<int> getDueReviewCount({DateTime? now}) async {
    final countExpr = conjugationSrsState.id.count();
    final row =
        await (selectOnly(conjugationSrsState)
              ..addColumns([countExpr])
              ..where(
                conjugationSrsState.nextReviewAt.isSmallerOrEqualValue(
                  now ?? DateTime.now(),
                ),
              ))
            .getSingle();
    return row.read(countExpr) ?? 0;
  }

  Stream<int> watchDueReviewCount() {
    final countExpr = conjugationSrsState.id.count();
    return (selectOnly(conjugationSrsState)
          ..addColumns([countExpr])
          ..where(
            conjugationSrsState.nextReviewAt.isSmallerOrEqualValue(
              DateTime.now(),
            ),
          ))
        .map((row) => row.read(countExpr) ?? 0)
        .watchSingle();
  }

  Future<List<int>> getDueContentVocabIds({DateTime? now}) {
    final idExpr = conjugationSrsState.contentVocabId;
    return (selectOnly(conjugationSrsState)
          ..addColumns([idExpr])
          ..where(
            conjugationSrsState.nextReviewAt.isSmallerOrEqualValue(
              now ?? DateTime.now(),
            ),
          ))
        .map((row) => row.read(idExpr)!)
        .get();
  }

  Future<({int learning, int review, int relearning})> getStageCounts() async {
    final stateCol = conjugationSrsState.fsrsState;
    final countExpr = conjugationSrsState.id.count();
    final rows =
        await (selectOnly(conjugationSrsState)
              ..addColumns([stateCol, countExpr])
              ..groupBy([stateCol]))
            .get();
    var learning = 0;
    var review = 0;
    var relearning = 0;
    for (final row in rows) {
      final count = row.read(countExpr) ?? 0;
      switch (row.read(stateCol)) {
        case 2:
          review = count;
        case 3:
          relearning = count;
        default:
          learning = count;
      }
    }
    return (learning: learning, review: review, relearning: relearning);
  }
}
