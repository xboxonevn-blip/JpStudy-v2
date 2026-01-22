import 'package:jpstudy/data/db/app_database.dart';
import '../../../core/app_language.dart';

enum GrammarQuestionType { sentenceBuilder, cloze, multipleChoice, reverseMultipleChoice }

class GeneratedQuestion {
  final GrammarQuestionType type;
  final GrammarPoint point;
  final String question;
  final String correctAnswer;
  final List<String> options;
  final String? explanation;

  GeneratedQuestion({
    required this.type,
    required this.point,
    required this.question,
    required this.correctAnswer,
    required this.options,
    this.explanation,
  });
}

class GrammarQuestionGenerator {
  /// Generate questions for a list of grammar points
  static List<GeneratedQuestion> generateQuestions(
    List<({GrammarPoint point, List<GrammarExample> examples})> details, {
    List<GrammarPoint>? allPoints,
    required AppLanguage language,
  }) {
    final questions = <GeneratedQuestion>[];

    for (final detail in details) {
      final point = detail.point;
      
      // Select localized fields
      final pointMeaning = language == AppLanguage.vi 
          ? (point.meaningVi ?? point.meaning) 
          : point.meaning;
      final pointExplanation = language == AppLanguage.vi 
          ? (point.explanationVi ?? point.explanation) 
          : point.explanation;

      // Strategy 0: Reverse MCQ (Meaning -> Grammar Point)
      // This doesn't depend on examples, so we do it once per point.
      if (allPoints != null && allPoints.isNotEmpty) {
          final reverseDistractors = <String>[];
          final pool = allPoints.where((p) => p.id != point.id).toList()..shuffle();
          reverseDistractors.addAll(pool.take(3).map((p) => p.grammarPoint));
          
          questions.add(GeneratedQuestion(
            type: GrammarQuestionType.reverseMultipleChoice,
            point: point,
            question: language == AppLanguage.vi
                ? 'Cấu trúc nào có nghĩa là "$pointMeaning"?'
                : 'Which structure means "$pointMeaning"?',
            correctAnswer: point.grammarPoint,
            options: [point.grammarPoint, ...reverseDistractors]..shuffle(),
            explanation: pointExplanation,
          ));
      }

      if (detail.examples.isEmpty) continue;

      // Strategy: Use ALL examples for variety
      for (final example in detail.examples) {
        final exTranslation = language == AppLanguage.vi 
            ? (example.translationVi ?? example.translation) 
            : (example.translationEn ?? example.translation);

        // Strategy 1: Sentence Builder (Jumbled Sentence)
        final chars = example.japanese.split('');
        questions.add(GeneratedQuestion(
          type: GrammarQuestionType.sentenceBuilder,
          point: point,
          question: language == AppLanguage.vi ? 'Sắp xếp câu:' : 'Arrange the sentence:',
          correctAnswer: example.japanese,
          options: chars..shuffle(),
          explanation: exTranslation, // The valid prompt/translation
        ));

        // Strategy 2: Cloze (Fill in the blank)
        if (example.japanese.contains(point.grammarPoint)) {
          final distractors = <String>[];
          if (allPoints != null && allPoints.isNotEmpty) {
             final pool = allPoints.where((p) => p.id != point.id && p.grammarPoint != point.grammarPoint).toList();
             pool.shuffle();
             distractors.addAll(pool.take(3).map((p) => p.grammarPoint));
          }
          
          while (distractors.length < 3) {
             distractors.add('Wrong ${distractors.length}'); 
          }

          questions.add(GeneratedQuestion(
            type: GrammarQuestionType.cloze,
            point: point,
            question: example.japanese.replaceFirst(point.grammarPoint, '___'),
            correctAnswer: point.grammarPoint,
            options: [point.grammarPoint, ...distractors]..shuffle(),
            explanation: pointMeaning,
          ));
          
          // Strategy 3: Multiple Choice (Grammar in Context -> Meaning)
          // We can link this to the example context if we want, or keep it generic.
          // Let's keep one generic MCQ per point (outside loop) OR per exampe?
          // Per example might be too repetitive for meaning check.
          // Let's Skip generic MCQ inside loop to avoid spamming "What does this mean?"
        }
      }
      
      // Add ONE generic MCQ per point to check basic meaning retention
      final meaningDistractors = <String>[];
      if (allPoints != null && allPoints.isNotEmpty) {
         final pool = allPoints.where((p) => p.id != point.id).toList()..shuffle();
         meaningDistractors.addAll(
             pool.take(3).map((p) => language == AppLanguage.vi 
                ? (p.meaningVi ?? p.meaning) 
                : p.meaning
             )
         );
      }
      questions.add(GeneratedQuestion(
        type: GrammarQuestionType.multipleChoice,
        point: point,
        question: language == AppLanguage.vi 
            ? 'Ý nghĩa của "${point.grammarPoint}" là gì?'
            : 'What is the meaning of "${point.grammarPoint}"?',
        correctAnswer: pointMeaning,
        options: [pointMeaning, ...meaningDistractors]..shuffle(),
        explanation: pointExplanation,
      ));
    }

    return questions;
  }
}
