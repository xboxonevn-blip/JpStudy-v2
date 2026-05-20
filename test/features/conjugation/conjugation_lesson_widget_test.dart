import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/repositories/conjugation_repository.dart';
import 'package:jpstudy/features/conjugation/widgets/conjugation_lesson_widget.dart';

class FakeConjugationRepository extends ConjugationRepository {
  FakeConjugationRepository(this.lemmas, this._contentDb) : super(_contentDb);

  final List<ConjugationLemmaData> lemmas;
  final ContentDatabase _contentDb;

  @override
  Future<List<ConjugationLemmaData>> fetchByLevel(String level) async => lemmas;

  Future<void> close() => _contentDb.close();
}

ConjugationLemmaData lemma(int id, String term, int lessonId) {
  return ConjugationLemmaData(
    id: id,
    contentVocabId: id,
    contentEntryId: 'entry_$id',
    term: term,
    reading: null,
    dictionaryForm: term,
    dictionaryReading: null,
    kind: 'verb',
    conjugationClass: 'godanRu',
    posTagsJson: '[]',
    jmdictEntrySeq: '$id',
    sourceVocabId: 'src_$id',
    sourceSenseId: 'sense_$id',
    level: 'N5',
    series: 'test',
    lessonId: lessonId,
    matchMethod: 'test',
  );
}

void main() {
  testWidgets('renders only when lesson has conjugable lemmas', (tester) async {
    final contentDb = ContentDatabase(executor: NativeDatabase.memory());
    final repo = FakeConjugationRepository([
      lemma(1, '帰る', 1),
      lemma(2, '走る', 2),
    ], contentDb);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLanguageProvider.overrideWith(
            (ref) => AppLanguageController.test(AppLanguage.vi),
          ),
          conjugationRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ConjugationLessonWidget(levelCode: 'N5', lessonId: 1),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byKey(const ValueKey('lesson_conjugation_widget')),
      findsOneWidget,
    );
    expect(find.textContaining('1 động từ/tính từ'), findsOneWidget);
    expect(find.text('帰る'), findsOneWidget);
    expect(find.text('走る'), findsNothing);
    expect(find.textContaining('50+'), findsOneWidget);

    await tester.pumpWidget(Container());
    await tester.pump(const Duration(milliseconds: 100));
    await repo.close();
  });
}
