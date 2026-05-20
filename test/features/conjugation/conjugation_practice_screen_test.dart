import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/db/database_provider.dart';
import 'package:jpstudy/data/repositories/conjugation_repository.dart';
import 'package:jpstudy/features/conjugation/models/conjugation_practice_args.dart';
import 'package:jpstudy/features/conjugation/screens/conjugation_practice_screen.dart';

class FakeConjugationRepository extends ConjugationRepository {
  FakeConjugationRepository(this.lemmas, this._contentDb) : super(_contentDb);

  final List<ConjugationLemmaData> lemmas;
  final ContentDatabase _contentDb;

  @override
  Future<List<ConjugationLemmaData>> fetchByContentVocabIds(
    List<int> contentVocabIds,
  ) async {
    return lemmas
        .where((lemma) => contentVocabIds.contains(lemma.contentVocabId))
        .toList(growable: false);
  }

  @override
  Future<List<ConjugationLemmaData>> fetchByLevel(String level) async {
    return lemmas
        .where((lemma) => lemma.level == level)
        .toList(growable: false);
  }

  Future<void> close() => _contentDb.close();
}

ConjugationLemmaData lemma() {
  return const ConjugationLemmaData(
    id: 900001,
    contentVocabId: 900001,
    contentEntryId: 'entry_900001',
    term: '帰る',
    reading: 'かえる',
    dictionaryForm: '帰る',
    dictionaryReading: 'かえる',
    kind: 'verb',
    conjugationClass: 'godanRu',
    posTagsJson: '[]',
    jmdictEntrySeq: '900001',
    sourceVocabId: 'src_900001',
    sourceSenseId: 'sense_900001',
    level: 'N5',
    series: 'hajimete',
    lessonId: 1,
    matchMethod: 'test',
  );
}

Widget buildPractice(
  AppDatabase db,
  FakeConjugationRepository repo, {
  AppLanguage language = AppLanguage.en,
}) {
  return ProviderScope(
    overrides: [
      appLanguageProvider.overrideWith(
        (ref) => AppLanguageController.test(language),
      ),
      studyLevelProvider.overrideWith((ref) => StudyLevel.n5),
      databaseProvider.overrideWithValue(db),
      conjugationRepositoryProvider.overrideWithValue(repo),
    ],
    child: const MaterialApp(
      home: ConjugationPracticeScreen(
        args: ConjugationPracticeArgs(
          contentVocabIds: [900001],
          formKeys: ['te'],
          directions: ['produce'],
          targetCount: 1,
          source: 'conjugation_practice',
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('selects first and records SRS/mistake only after confirm', (
    tester,
  ) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final fakeContentDb = ContentDatabase(executor: NativeDatabase.memory());
    final repo = FakeConjugationRepository([lemma()], fakeContentDb);

    await tester.pumpWidget(buildPractice(db, repo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Practice forms'), findsOneWidget);
    expect(find.textContaining('帰る'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('conjugation_answer_option_1')));
    await tester.pump();
    expect(await db.mistakeDao.getMistakesByType('conjugation'), isEmpty);
    expect(
      await db.conjugationSrsDao.getSrsState(
        contentVocabId: 900001,
        formKey: 'te',
        direction: 'produce',
      ),
      isNull,
    );

    await tester.tap(find.byKey(const ValueKey('conjugation_answer_confirm')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final state = await db.conjugationSrsDao.getSrsState(
      contentVocabId: 900001,
      formKey: 'te',
      direction: 'produce',
    );
    final mistakes = await db.mistakeDao.getMistakesByType('conjugation');

    expect(state, isNotNull);
    expect(mistakes, hasLength(1));
    expect(mistakes.single.correctAnswer, '帰って');
    expect(mistakes.single.userAnswer, isNot('帰って'));
    expect(mistakes.single.source, 'conjugation_practice');
    expect(mistakes.single.extraJson, contains('"formKey":"te"'));

    await tester.pumpWidget(Container());
    await tester.pump(const Duration(milliseconds: 100));
    await db.close();
    await repo.close();
  });

  testWidgets('Vietnamese practice prompt uses learner-facing copy', (
    tester,
  ) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final fakeContentDb = ContentDatabase(executor: NativeDatabase.memory());
    final repo = FakeConjugationRepository([lemma()], fakeContentDb);

    await tester.pumpWidget(
      buildPractice(db, repo, language: AppLanguage.vi),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Luyện chia thể'), findsOneWidget);
    expect(find.textContaining('Chọn'), findsOneWidget);
    expect(find.textContaining('Choose'), findsNothing);

    await tester.pumpWidget(Container());
    await tester.pump(const Duration(milliseconds: 100));
    await db.close();
    await repo.close();
  });
}
