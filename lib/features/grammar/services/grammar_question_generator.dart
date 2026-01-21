import 'package:jpstudy/data/db/app_database.dart';

enum GrammarQuestionType { sentenceBuilder, cloze, multipleChoice }

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
  }) {
    final questions = <GeneratedQuestion>[];

    for (final detail in details) {
      if (detail.examples.isEmpty) continue;
      
      final point = detail.point;
      // Use the first example for now, or randomize
      final example = detail.examples.first;
      
      // Strategy 1: Sentence Builder (Jumbled Sentence)
      // Split by characters for simplicity if no spaces, or custom logic
      // Ideally we want chunks. For minimalviable, char split or manual chunks if available.
      // Let's do Sentence Builder as Type 1
      final chars = example.japanese.split('');
      questions.add(GeneratedQuestion(
        type: GrammarQuestionType.sentenceBuilder,
        point: point,
        question: 'Arrange the sentence', // UI will show English translation as hint usually
        correctAnswer: example.japanese,
        options: chars..shuffle(), // Options are the shuffled chars
        explanation: example.translation,
      ));

      // Strategy 2: Cloze (Fill in the blank)
      // Remove the grammar point pattern from the sentence
      // This is hard to do perfectly automatically without regex matching the specific conjugation.
      // Simple heuristic: if the example contains the exact grammar point string
      if (example.japanese.contains(point.grammarPoint)) {
        // Generate Distractors
        final distractors = <String>[];
        if (allPoints != null && allPoints.isNotEmpty) {
           final pool = allPoints.where((p) => p.id != point.id).toList();
           pool.shuffle();
           distractors.addAll(pool.take(3).map((p) => p.grammarPoint));
        }
        
        // Fill remaining if needed
        while (distractors.length < 3) {
           distractors.add('Wrong ${distractors.length + 1}');
        }

        questions.add(GeneratedQuestion(
          type: GrammarQuestionType.cloze,
          point: point,
          question: example.japanese.replaceFirst(point.grammarPoint, '___'),
          correctAnswer: point.grammarPoint,
          options: [
            point.grammarPoint, 
            ...distractors,
          ]..shuffle(),
          explanation: point.meaning,
        ));
      }
    }

    return questions;
  }
}
