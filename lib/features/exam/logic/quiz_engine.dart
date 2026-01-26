import 'dart:math';
import 'package:jpstudy/data/models/vocab_item.dart';

enum QuestionType { multipleChoice, typing }

class QuizQuestion {
  final VocabItem correctItem;
  final List<String> options; // For multiple choice
  final int correctOptionIndex;
  final QuestionType type;

  QuizQuestion({
    required this.correctItem,
    required this.options,
    required this.correctOptionIndex,
    this.type = QuestionType.multipleChoice,
  });
}

class QuizEngine {
  final List<VocabItem> _allVocab;
  final Random _random = Random();

  QuizEngine(this._allVocab);

  List<QuizQuestion> generateQuiz(int numberOfQuestions) {
    if (_allVocab.isEmpty) return [];

    final questions = <QuizQuestion>[];
    final availableVocab = List<VocabItem>.from(_allVocab)..shuffle(_random);

    // Determine how many questions to generate
    final count = min(numberOfQuestions, availableVocab.length);

    for (int i = 0; i < count; i++) {
      final target = availableVocab[i];
      // Randomly decide question type: 30% typing, 70% multiple choice
      if (_random.nextDouble() < 0.3) {
        questions.add(_createTypingQuestion(target));
      } else {
        questions.add(_createMultipleChoiceQuestion(target));
      }
    }

    return questions;
  }

  QuizQuestion _createMultipleChoiceQuestion(VocabItem target) {
    // Pick 3 distractors
    final distractors = <String>[];
    final potentialDistractors = List<VocabItem>.from(_allVocab)
      ..removeWhere((e) => e.id == target.id); // Remove target from distractors

    potentialDistractors.shuffle(_random);

    // Take up to 3 distractors
    for (int i = 0; i < min(3, potentialDistractors.length); i++) {
      // Use meaning for MC options
      distractors.add(potentialDistractors[i].meaning);
    }

    final options = List<String>.from(distractors);
    final correctAnswer = target.meaning;

    // Insert correct answer at random position
    final correctIndex = _random.nextInt(options.length + 1);
    options.insert(correctIndex, correctAnswer);

    return QuizQuestion(
      correctItem: target,
      options: options,
      correctOptionIndex: correctIndex,
      type: QuestionType.multipleChoice,
    );
  }

  QuizQuestion _createTypingQuestion(VocabItem target) {
    return QuizQuestion(
      correctItem: target,
      options: [], // No options for typing
      correctOptionIndex: -1,
      type: QuestionType.typing,
    );
  }
}
