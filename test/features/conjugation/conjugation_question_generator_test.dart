import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/features/conjugation/services/conjugation_question_generator.dart';

ConjugationLemmaData lemma({
  required int id,
  required int vocabId,
  required String term,
  required String klass,
}) {
  return ConjugationLemmaData(
    id: id,
    contentVocabId: vocabId,
    contentEntryId: 'entry_$vocabId',
    term: term,
    reading: null,
    dictionaryForm: term,
    dictionaryReading: null,
    kind: 'verb',
    conjugationClass: klass,
    posTagsJson: '[]',
    jmdictEntrySeq: '$vocabId',
    sourceVocabId: 'src_$vocabId',
    sourceSenseId: 'sense_$vocabId',
    level: 'N5',
    series: 'hajimete',
    lessonId: 1,
    matchMethod: 'test',
  );
}

void main() {
  test('generates sourced production questions without suffix guessing', () {
    final questions = ConjugationQuestionGenerator().build(
      lemmas: [
        lemma(id: 1, vocabId: 10, term: '帰る', klass: 'godanRu'),
        lemma(id: 2, vocabId: 20, term: '起きる', klass: 'ichidan'),
      ],
      formKeys: const ['te'],
      directions: const ['produce'],
      targetCount: 2,
    );

    final kaeru = questions.firstWhere((q) => q.dictionaryForm == '帰る');
    final okiru = questions.firstWhere((q) => q.dictionaryForm == '起きる');

    expect(kaeru.correctAnswer, '帰って');
    expect(kaeru.options, isNot(contains('帰るて')));
    expect(okiru.correctAnswer, '起きて');
    expect(kaeru.formKey, 'te');
    expect(kaeru.direction, 'produce');
  });

  test(
    'recognition questions ask for the form label of a generated surface',
    () {
      final questions = ConjugationQuestionGenerator().build(
        lemmas: [lemma(id: 1, vocabId: 10, term: '帰る', klass: 'godanRu')],
        formKeys: const ['te'],
        directions: const ['recognize'],
        targetCount: 1,
      );

      expect(questions.single.prompt, contains('帰って'));
      expect(questions.single.correctAnswer, 'te form');
      expect(questions.single.options, contains('te form'));
    },
  );

  test('default drill density is at least fifty questions', () {
    final questions = ConjugationQuestionGenerator().build(
      lemmas: [
        lemma(id: 1, vocabId: 10, term: '帰る', klass: 'godanRu'),
        lemma(id: 2, vocabId: 20, term: '起きる', klass: 'ichidan'),
        lemma(id: 3, vocabId: 30, term: '書く', klass: 'godanKu'),
        lemma(id: 4, vocabId: 40, term: '話す', klass: 'godanSu'),
      ],
    );

    expect(questions.length, greaterThanOrEqualTo(50));
    expect(
      questions.every((q) => q.options.toSet().length == q.options.length),
      isTrue,
    );
  });
}
