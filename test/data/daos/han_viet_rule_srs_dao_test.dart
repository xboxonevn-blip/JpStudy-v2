import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/services/fsrs_service.dart';
import 'package:jpstudy/data/daos/han_viet_rule_srs_dao.dart';
import 'package:jpstudy/data/db/app_database.dart';

void main() {
  late AppDatabase db;
  late HanVietRuleSrsDao dao;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    dao = HanVietRuleSrsDao(db);
  });

  tearDown(() => db.close());

  test('records one FSRS state per Han-Viet rule id', () async {
    final now = DateTime(2026, 5, 20, 9);

    await dao.recordReview(
      ruleId: 'rule_initial_h_k_gi_c_qu_to_k',
      grade: 4,
      now: now,
    );
    await dao.recordReview(
      ruleId: 'rule_initial_h_k_gi_c_qu_to_k',
      grade: 4,
      now: now.add(const Duration(minutes: 1)),
    );

    final state = await dao.getSrsState('rule_initial_h_k_gi_c_qu_to_k');
    final dueCount = await dao.getDueReviewCount(now: now);

    expect(state, isNotNull);
    expect(state!.ruleId, 'rule_initial_h_k_gi_c_qu_to_k');
    expect(state.lastConfidence, 4);
    expect(state.fsrsState, FsrsCardState.review.dbValue);
    expect(state.nextReviewAt.isAfter(now), isTrue);
    expect(dueCount, 0);
  });
}
