import 'package:drift/drift.dart';

import '../../core/services/fsrs_service.dart';
import '../db/app_database.dart';
import '../db/han_viet_rule_tables.dart';

part 'han_viet_rule_srs_dao.g.dart';

@DriftAccessor(tables: [HanVietRuleSrsState])
class HanVietRuleSrsDao extends DatabaseAccessor<AppDatabase>
    with _$HanVietRuleSrsDaoMixin {
  HanVietRuleSrsDao(super.db);

  final FsrsService _fsrsService = FsrsService();

  Future<HanVietRuleSrsStateData?> getSrsState(String ruleId) {
    return (select(
      hanVietRuleSrsState,
    )..where((t) => t.ruleId.equals(ruleId))).getSingleOrNull();
  }

  Future<int> initializeSrsState(String ruleId, {DateTime? nextReviewAt}) {
    return into(hanVietRuleSrsState).insert(
      HanVietRuleSrsStateCompanion.insert(
        ruleId: ruleId,
        nextReviewAt: nextReviewAt ?? DateTime.now(),
        fsrsState: Value(FsrsCardState.learning.dbValue),
        fsrsStep: const Value(0),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> recordReview({
    required String ruleId,
    required int grade,
    DateTime? now,
  }) async {
    final reviewTime = now ?? DateTime.now();
    await initializeSrsState(ruleId, nextReviewAt: reviewTime);
    final state = await getSrsState(ruleId);
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

    await (update(
      hanVietRuleSrsState,
    )..where((t) => t.ruleId.equals(ruleId))).write(
      HanVietRuleSrsStateCompanion(
        stability: Value(result.stability),
        difficulty: Value(result.difficulty),
        lastConfidence: Value(nextGrade),
        lastReviewedAt: Value(reviewTime),
        nextReviewAt: Value(result.nextReviewAt),
        fsrsState: Value(result.cardState.dbValue),
        fsrsStep: Value(result.step),
      ),
    );
  }

  Future<int> getDueReviewCount({DateTime? now}) async {
    final countExpr = hanVietRuleSrsState.id.count();
    final row =
        await (selectOnly(hanVietRuleSrsState)
              ..addColumns([countExpr])
              ..where(
                hanVietRuleSrsState.nextReviewAt.isSmallerOrEqualValue(
                  now ?? DateTime.now(),
                ),
              ))
            .getSingle();
    return row.read(countExpr) ?? 0;
  }

  Future<List<HanVietRuleSrsStateData>> getDueReviews({DateTime? now}) {
    return (select(hanVietRuleSrsState)..where(
          (t) => t.nextReviewAt.isSmallerOrEqualValue(now ?? DateTime.now()),
        ))
        .get();
  }

  Stream<int> watchDueReviewCount() {
    final countExpr = hanVietRuleSrsState.id.count();
    return (selectOnly(hanVietRuleSrsState)
          ..addColumns([countExpr])
          ..where(
            hanVietRuleSrsState.nextReviewAt.isSmallerOrEqualValue(
              DateTime.now(),
            ),
          ))
        .map((row) => row.read(countExpr) ?? 0)
        .watchSingle();
  }
}
