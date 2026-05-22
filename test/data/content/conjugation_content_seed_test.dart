import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/repositories/conjugation_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('seeds active-level conjugation lemmas linked to vocab rows', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({'onboarding.level': 'N5'});
    final db = ContentDatabase(executor: NativeDatabase.memory());
    addTearDown(db.close);
    final repo = ConjugationRepository(db);

    final kaeruVocab = await _vocabBySourceId(db, 'haj_n5_ch10_v033');
    final okiruVocab = await _vocabBySourceId(db, 'haj_n5_ch01_v008');
    final gakuseiVocab = await _vocabBySourceId(db, 'n5_l01_v009');

    final kaeru = await repo.findByContentVocabId(kaeruVocab.id);
    final okiru = await repo.findByContentVocabId(okiruVocab.id);
    final gakusei = await repo.findByContentVocabId(gakuseiVocab.id);

    expect(kaeru, isNotNull);
    expect(kaeru!.dictionaryForm, '帰る');
    expect(kaeru.conjugationClass, 'godanRu');
    expect(kaeru.contentVocabId, kaeruVocab.id);

    expect(okiru, isNotNull);
    expect(okiru!.dictionaryForm, '起きる');
    expect(okiru.conjugationClass, 'ichidan');
    expect(okiru.contentVocabId, okiruVocab.id);

    expect(gakusei, isNull);
  });

  test('looks up conjugation lemmas by level, source ids, and vocab ids', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({'onboarding.level': 'N5'});
    final db = ContentDatabase(executor: NativeDatabase.memory());
    addTearDown(db.close);
    final repo = ConjugationRepository(db);

    final kaeruVocab = await _vocabBySourceId(db, 'haj_n5_ch10_v033');
    final okiruVocab = await _vocabBySourceId(db, 'haj_n5_ch01_v008');

    final n5 = await repo.fetchByLevel('N5');
    final bySource = await repo.findBySourceIds(
      sourceVocabId: 'haj_n5_ch10_v033',
      sourceSenseId: 'haj_n5_ch10_s033',
    );
    final byIds = await repo.fetchByContentVocabIds([
      kaeruVocab.id,
      okiruVocab.id,
    ]);
    final n4 = await repo.fetchByLevel('N4');

    expect(n5.length, greaterThan(0));
    expect(n5.every((entry) => entry.level == 'N5'), isTrue);
    expect(bySource?.contentVocabId, kaeruVocab.id);
    expect(
      byIds.map((entry) => entry.contentVocabId),
      unorderedEquals([kaeruVocab.id, okiruVocab.id]),
    );
    expect(n4, isEmpty);
  });

  test('lesson-scoped lookup hides non-conjugable lessons', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({'onboarding.level': 'N5'});
    final db = ContentDatabase(executor: NativeDatabase.memory());
    addTearDown(db.close);
    final repo = ConjugationRepository(db);

    final lesson1 = await repo.fetchByLesson('N5', 1, series: 'minna', limit: 8);
    final lesson8 = await repo.fetchByLesson('N5', 8, series: 'minna', limit: 8);

    expect(lesson1, isEmpty);
    expect(lesson8, hasLength(8));
    expect(lesson8.every((entry) => entry.level == 'N5'), isTrue);
    expect(lesson8.every((entry) => entry.lessonId == 8), isTrue);
    expect(
      lesson8.map((entry) => entry.kind),
      everyElement(isIn({'verb', 'i_adjective', 'na_adjective'})),
    );
  });

  test('lesson-scoped lookup ignores malformed non-conjugable rows', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({'onboarding.level': 'N5'});
    final db = ContentDatabase(executor: NativeDatabase.memory());
    addTearDown(db.close);
    final repo = ConjugationRepository(db);
    final gakuseiVocab = await _vocabBySourceId(db, 'n5_l01_v009');

    await db
        .into(db.conjugationLemma)
        .insert(
          ConjugationLemmaCompanion.insert(
            id: const Value(999999),
            contentVocabId: gakuseiVocab.id,
            contentEntryId: 'malformed_noun',
            term: '学生',
            reading: const Value('がくせい'),
            dictionaryForm: '学生',
            dictionaryReading: const Value('がくせい'),
            kind: 'noun',
            conjugationClass: 'noun',
            posTagsJson: '["noun"]',
            jmdictEntrySeq: '999999',
            sourceVocabId: const Value('n5_l01_v009'),
            sourceSenseId: const Value('n5_l01_s009'),
            level: 'N5',
            series: 'minna',
            lessonId: 1,
            matchMethod: 'test',
          ),
        );

    final lesson1 = await repo.fetchByLesson('N5', 1, series: 'minna');

    expect(lesson1, isEmpty);
  });
}

Future<VocabData> _vocabBySourceId(ContentDatabase db, String sourceVocabId) {
  return (db.select(db.vocab)
        ..where((tbl) => tbl.sourceVocabId.equals(sourceVocabId))
        ..limit(1))
      .getSingle();
}
