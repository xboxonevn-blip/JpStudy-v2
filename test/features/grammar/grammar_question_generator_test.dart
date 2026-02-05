import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/features/grammar/services/grammar_question_generator.dart';

void main() {
  group('GrammarQuestionGenerator', () {
    test('builds new drill question types with stable metadata', () {
      final point1 = GrammarPoint(
        id: 1,
        lessonId: 1,
        grammarPoint: 'です',
        meaning: 'to be',
        meaningEn: 'to be',
        meaningVi: 'la',
        connection: 'N1 は N2 です',
        connectionEn: 'N1 is N2',
        explanation: 'Basic copula sentence.',
        explanationEn: 'Basic copula sentence.',
        explanationVi: 'Cau co ban.',
        jlptLevel: 'N5',
        isLearned: false,
      );
      final point2 = GrammarPoint(
        id: 2,
        lessonId: 1,
        grammarPoint: 'ます',
        meaning: 'polite verb ending',
        meaningEn: 'polite verb ending',
        meaningVi: 'duoi lich su',
        connection: 'V-ます',
        connectionEn: 'V-masu',
        explanation: 'Polite present/future.',
        explanationEn: 'Polite present/future.',
        explanationVi: 'Lich su hien tai.',
        jlptLevel: 'N5',
        isLearned: false,
      );
      final point3 = GrammarPoint(
        id: 3,
        lessonId: 1,
        grammarPoint: 'か',
        meaning: 'question marker',
        meaningEn: 'question marker',
        meaningVi: 'tro tu hoi',
        connection: '...か',
        connectionEn: '...ka',
        explanation: 'Marks questions.',
        explanationEn: 'Marks questions.',
        explanationVi: 'Danh dau cau hoi.',
        jlptLevel: 'N5',
        isLearned: false,
      );

      final details = <({GrammarPoint point, List<GrammarExample> examples})>[
        (
          point: point1,
          examples: const [
            GrammarExample(
              id: 1,
              grammarId: 1,
              japanese: 'わたしは学生です。',
              translation: 'I am a student.',
              translationEn: 'I am a student.',
              translationVi: 'Toi la hoc sinh.',
            ),
          ],
        ),
        (
          point: point2,
          examples: const [
            GrammarExample(
              id: 2,
              grammarId: 2,
              japanese: '毎日勉強します。',
              translation: 'I study every day.',
              translationEn: 'I study every day.',
              translationVi: 'Toi hoc moi ngay.',
            ),
          ],
        ),
      ];

      final questions = GrammarQuestionGenerator.generateQuestions(
        details,
        allPoints: [point1, point2, point3],
        language: AppLanguage.en,
      );

      expect(
        questions.any(
          (question) => question.type == GrammarQuestionType.pairContrast,
        ),
        isTrue,
      );
      expect(
        questions.any(
          (question) => question.type == GrammarQuestionType.transformation,
        ),
        isTrue,
      );
      expect(
        questions.any(
          (question) => question.type == GrammarQuestionType.errorReason,
        ),
        isTrue,
      );

      for (final question in questions) {
        expect(question.familyKey.trim().isNotEmpty, isTrue);
        expect(question.stemKey.trim().isNotEmpty, isTrue);
        expect(question.answerShapeKey.trim().isNotEmpty, isTrue);
        if (question.type != GrammarQuestionType.sentenceBuilder) {
          expect(question.options.contains(question.correctAnswer), isTrue);
        }
      }
    });

    test('prefers minimal-pair candidate for contrast question', () {
      const pointHa = GrammarPoint(
        id: 10,
        lessonId: 1,
        grammarPoint: '\u306f',
        meaning: 'topic marker',
        meaningEn: 'topic marker',
        meaningVi: 'tro tu chu de',
        connection: 'N \u306f',
        connectionEn: 'N wa',
        explanation: 'Marks topic.',
        explanationEn: 'Marks topic.',
        explanationVi: 'Danh dau chu de.',
        jlptLevel: 'N5',
        isLearned: false,
      );
      const pointGa = GrammarPoint(
        id: 11,
        lessonId: 1,
        grammarPoint: '\u304c',
        meaning: 'subject marker',
        meaningEn: 'subject marker',
        meaningVi: 'tro tu chu ngu',
        connection: 'N \u304c',
        connectionEn: 'N ga',
        explanation: 'Marks subject.',
        explanationEn: 'Marks subject.',
        explanationVi: 'Danh dau chu ngu.',
        jlptLevel: 'N5',
        isLearned: false,
      );
      const pointNi = GrammarPoint(
        id: 12,
        lessonId: 1,
        grammarPoint: '\u306b',
        meaning: 'direction/time marker',
        meaningEn: 'direction/time marker',
        meaningVi: 'tro tu huong/thoi gian',
        connection: 'N \u306b',
        connectionEn: 'N ni',
        explanation: 'Marks destination/time.',
        explanationEn: 'Marks destination/time.',
        explanationVi: 'Danh dau huong/thoi gian.',
        jlptLevel: 'N5',
        isLearned: false,
      );

      final questions = GrammarQuestionGenerator.generateQuestions(
        const [
          (
            point: pointHa,
            examples: [
              GrammarExample(
                id: 10,
                grammarId: 10,
                japanese:
                    '\u308f\u305f\u3057\u306f\u5b66\u751f\u3067\u3059\u3002',
                translation: 'I am a student.',
                translationEn: 'I am a student.',
                translationVi: 'Toi la hoc sinh.',
              ),
            ],
          ),
        ],
        allPoints: const [pointHa, pointGa, pointNi],
        language: AppLanguage.en,
      );

      final contrast = questions
          .where((q) => q.type == GrammarQuestionType.pairContrast)
          .where((q) => q.point.id == pointHa.id)
          .toList(growable: false);

      expect(contrast, isNotEmpty);
      expect(contrast.first.options.contains(pointHa.grammarPoint), isTrue);
      expect(contrast.first.options.contains(pointGa.grammarPoint), isTrue);
      expect(
        (contrast.first.feedback ?? '').toLowerCase(),
        contains('minimal pair'),
      );
    });
  });
}
