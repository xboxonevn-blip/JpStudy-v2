import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/services/fsrs_service.dart';
import 'package:jpstudy/data/daos/conjugation_srs_dao.dart';
import 'package:jpstudy/data/db/app_database.dart';

void main() {
  late AppDatabase db;
  late ConjugationSrsDao dao;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    dao = ConjugationSrsDao(db);
  });

  tearDown(() => db.close());

  test('initializes one SRS row per exact conjugation skill', () async {
    await dao.initializeSrsState(
      contentVocabId: 10,
      formKey: 'te',
      direction: 'produce',
    );
    await dao.initializeSrsState(
      contentVocabId: 10,
      formKey: 'te',
      direction: 'produce',
    );
    await dao.initializeSrsState(
      contentVocabId: 10,
      formKey: 'nai',
      direction: 'produce',
    );

    final states = await dao.getStatesForContentVocabIds([10]);

    expect(states, hasLength(2));
    expect(
      states.map(
        (state) =>
            '${state.contentVocabId}:${state.formKey}:'
            '${state.direction}',
      ),
      unorderedEquals(['10:te:produce', '10:nai:produce']),
    );
    expect(states.every((state) => state.fsrsState == 1), isTrue);
  });

  test('records FSRS review state and due counts', () async {
    final now = DateTime(2026, 5, 20, 9);
    await dao.recordReview(
      contentVocabId: 20,
      formKey: 'te',
      direction: 'recognize',
      grade: 4,
      now: now,
    );

    final state = await dao.getSrsState(
      contentVocabId: 20,
      formKey: 'te',
      direction: 'recognize',
    );
    final stages = await dao.getStageCounts();

    expect(state, isNotNull);
    expect(state!.lastConfidence, 4);
    expect(state.lastReviewedAt, now);
    expect(state.nextReviewAt.isAfter(now), isTrue);
    expect(state.fsrsState, FsrsCardState.review.dbValue);
    expect(await dao.getDueReviewCount(now: now), 0);
    expect(stages.review, 1);
  });

  test(
    'wrong review creates a conjugation mistake with exact skill context',
    () async {
      await dao.recordReview(
        contentVocabId: 30,
        formKey: 'te',
        direction: 'produce',
        conjugationClass: 'godanRu',
        expectedSurface: '帰って',
        grammarId: 7,
        grade: 1,
        prompt: 'Chia 帰る sang thể て.',
        correctAnswer: '帰って',
        userAnswer: '帰るて',
        source: 'conjugation_practice',
        now: DateTime(2026, 5, 20, 9),
      );

      final mistakes = await db.mistakeDao.getMistakesByType('conjugation');

      expect(mistakes, hasLength(1));
      expect(mistakes.single.itemId, 30);
      expect(mistakes.single.prompt, 'Chia 帰る sang thể て.');
      expect(mistakes.single.correctAnswer, '帰って');
      expect(mistakes.single.userAnswer, '帰るて');
      expect(mistakes.single.source, 'conjugation_practice');
      expect(mistakes.single.extraJson, contains('"formKey":"te"'));
      expect(mistakes.single.extraJson, contains('"direction":"produce"'));
      expect(mistakes.single.extraJson, contains('"grammarId":7'));
    },
  );
}
