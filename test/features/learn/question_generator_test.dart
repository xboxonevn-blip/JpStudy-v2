import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/data/models/vocab_item.dart';
import 'package:jpstudy/features/learn/models/question_type.dart';
import 'package:jpstudy/features/learn/services/question_generator.dart';

void main() {
  test('generates requested density by cycling items and question types', () {
    final generator = QuestionGenerator();
    final items = [
      _item(1, '私', 'わたし', 'tôi'),
      _item(2, '学生', 'がくせい', 'học sinh'),
      _item(3, '先生', 'せんせい', 'giáo viên'),
    ];

    final questions = generator.generateQuestions(
      items: items,
      enabledTypes: QuestionType.values,
      count: 50,
      language: AppLanguage.vi,
      shuffleItems: false,
    );

    expect(questions, hasLength(50));
    expect(questions.map((q) => q.id).toSet(), hasLength(50));
    expect(questions.map((q) => q.targetItem.id).toSet(), equals({1, 2, 3}));
    expect(
      questions.map((q) => q.type).toSet(),
      containsAll(QuestionType.values),
    );
  });

  test('listening questions use reading audio and ask for meaning', () {
    final generator = QuestionGenerator();
    final items = [
      _item(1, '学校', 'がっこう', 'trường học'),
      _item(2, '先生', 'せんせい', 'giáo viên'),
      _item(3, '学生', 'がくせい', 'học sinh'),
      _item(4, '水', 'みず', 'nước'),
    ];
    final listeningType = QuestionType.values.firstWhere(
      (type) => type.name == 'listening',
    );

    final question = generator.generateQuestionForItem(
      item: items.first,
      type: listeningType,
      allItems: items,
      language: AppLanguage.vi,
    );

    expect(question, isNotNull);
    expect(question!.type.name, 'listening');
    expect(question.audioText, 'がっこう');
    expect(question.questionText, contains('Nghe'));
    expect(question.correctAnswer, 'trường học');
    expect(question.options, contains('trường học'));
    expect(question.checkAnswer('trường học'), isTrue);
  });
}

VocabItem _item(int id, String term, String reading, String meaning) {
  return VocabItem(
    id: id,
    term: term,
    reading: reading,
    meaning: meaning,
    level: 'N5',
  );
}
