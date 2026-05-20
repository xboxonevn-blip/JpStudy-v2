import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/repositories/conjugation_repository.dart';
import 'package:jpstudy/features/conjugation/screens/conjugation_hub_screen.dart';

class FakeConjugationRepository extends ConjugationRepository {
  FakeConjugationRepository(this.lemmas, this._contentDb) : super(_contentDb);

  final List<ConjugationLemmaData> lemmas;
  final ContentDatabase _contentDb;

  @override
  Future<List<ConjugationLemmaData>> fetchByLevel(String level) async {
    return lemmas;
  }

  Future<void> close() => _contentDb.close();
}

ConjugationLemmaData lemma({
  required int id,
  required String term,
  required String kind,
  required String klass,
}) {
  return ConjugationLemmaData(
    id: id,
    contentVocabId: id,
    contentEntryId: 'entry_$id',
    term: term,
    reading: null,
    dictionaryForm: term,
    dictionaryReading: null,
    kind: kind,
    conjugationClass: klass,
    posTagsJson: '[]',
    jmdictEntrySeq: '$id',
    sourceVocabId: 'src_$id',
    sourceSenseId: 'sense_$id',
    level: 'N5',
    series: 'test',
    lessonId: 1,
    matchMethod: 'test',
  );
}

Widget buildHub(FakeConjugationRepository repo) {
  return ProviderScope(
    overrides: [
      appLanguageProvider.overrideWith(
        (ref) => AppLanguageController.test(AppLanguage.vi),
      ),
      studyLevelProvider.overrideWith((ref) => StudyLevel.n5),
      conjugationRepositoryProvider.overrideWithValue(repo),
    ],
    child: const MaterialApp(home: ConjugationHubScreen()),
  );
}

void main() {
  testWidgets('renders searchable conjugation list and filter chips', (
    tester,
  ) async {
    final contentDb = ContentDatabase(executor: NativeDatabase.memory());
    final repo = FakeConjugationRepository([
      lemma(id: 1, term: '帰る', kind: 'verb', klass: 'godanRu'),
      lemma(id: 2, term: '静か', kind: 'na_adjective', klass: 'naAdjective'),
    ], contentDb);

    await tester.pumpWidget(buildHub(repo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byKey(const ValueKey('conjugation_search_field')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('conjugation_filter_verb')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('conjugation_filter_adjective')),
      findsOneWidget,
    );
    expect(find.widgetWithText(ListTile, '帰る'), findsOneWidget);
    expect(find.widgetWithText(ListTile, '静か'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('conjugation_search_field')),
      '帰る',
    );
    await tester.pump();
    expect(find.widgetWithText(ListTile, '帰る'), findsOneWidget);
    expect(find.widgetWithText(ListTile, '静か'), findsNothing);

    await tester.pumpWidget(Container());
    await tester.pump(const Duration(milliseconds: 100));
    await repo.close();
  });
}
