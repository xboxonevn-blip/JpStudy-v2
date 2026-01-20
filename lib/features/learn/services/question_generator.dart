import 'dart:math';

import '../../../data/models/vocab_item.dart';
import '../models/question.dart';
import '../models/question_type.dart';

/// Service to generate questions for Learn Mode
class QuestionGenerator {
  final Random _random = Random();

  /// Generate a batch of questions from vocabulary items
  List<Question> generateQuestions({
    required List<VocabItem> items,
    required List<QuestionType> enabledTypes,
    int count = 20,
  }) {
    if (items.isEmpty || enabledTypes.isEmpty) return [];

    final questions = <Question>[];
    final shuffledItems = List<VocabItem>.from(items)..shuffle(_random);

    for (int i = 0; i < count && i < shuffledItems.length; i++) {
      final item = shuffledItems[i];
      final type = enabledTypes[_random.nextInt(enabledTypes.length)];

      final question = _generateQuestion(
        item: item,
        type: type,
        allItems: items,
      );

      if (question != null) {
        questions.add(question);
      }
    }

    return questions;
  }

  /// Generate questions for a specific round with adaptive difficulty
  List<Question> generateAdaptiveRound({
    required List<VocabItem> items,
    required int round,
    required List<int> weakTermIds,
  }) {
    // Round 1: All terms as multiple choice (easy)
    // Round 2: Weak terms as fill-in-blank (harder)
    // Round 3+: Mix of types for remaining weak terms

    final targetItems = round == 1
        ? items
        : items.where((item) => weakTermIds.contains(item.id)).toList();

    if (targetItems.isEmpty) return [];

    final questionType = switch (round) {
      1 => QuestionType.multipleChoice,
      2 => QuestionType.fillBlank,
      _ => _random.nextBool() ? QuestionType.trueFalse : QuestionType.multipleChoice,
    };

    return generateQuestions(
      items: targetItems,
      enabledTypes: [questionType],
      count: targetItems.length,
    );
  }

  Question? _generateQuestion({
    required VocabItem item,
    required QuestionType type,
    required List<VocabItem> allItems,
  }) {
    switch (type) {
      case QuestionType.multipleChoice:
        return _generateMultipleChoice(item, allItems);
      case QuestionType.trueFalse:
        return _generateTrueFalse(item, allItems);
      case QuestionType.fillBlank:
        return _generateFillBlank(item);
    }
  }

  Question _generateMultipleChoice(VocabItem item, List<VocabItem> allItems) {
    // Generate 3 wrong options (distractors)
    final distractors = _selectDistractors(item, allItems, count: 3);
    final options = [item.meaning, ...distractors.map((d) => d.meaning)]..shuffle(_random);

    return Question(
      id: 'mcq_${item.id}_${DateTime.now().millisecondsSinceEpoch}',
      type: QuestionType.multipleChoice,
      targetItem: item,
      questionText: 'What does "${item.term}" mean?',
      correctAnswer: item.meaning,
      options: options,
    );
  }

  Question _generateTrueFalse(VocabItem item, List<VocabItem> allItems) {
    // 50% chance to show correct pairing
    final isTrue = _random.nextBool();
    
    String shownMeaning;
    if (isTrue) {
      shownMeaning = item.meaning;
    } else {
      // Pick a wrong meaning
      final wrongItems = allItems.where((i) => i.id != item.id).toList();
      if (wrongItems.isEmpty) {
        shownMeaning = item.meaning;
      } else {
        shownMeaning = wrongItems[_random.nextInt(wrongItems.length)].meaning;
      }
    }

    return Question(
      id: 'tf_${item.id}_${DateTime.now().millisecondsSinceEpoch}',
      type: QuestionType.trueFalse,
      targetItem: item,
      questionText: '"${item.term}" means "$shownMeaning"',
      correctAnswer: isTrue ? 'true' : 'false',
      isStatementTrue: isTrue,
    );
  }

  Question _generateFillBlank(VocabItem item) {
    // Ask for meaning or reading
    final askForMeaning = _random.nextBool();

    if (askForMeaning) {
      return Question(
        id: 'fb_${item.id}_${DateTime.now().millisecondsSinceEpoch}',
        type: QuestionType.fillBlank,
        targetItem: item,
        questionText: 'Type the meaning of "${item.term}"',
        correctAnswer: item.meaning,
        hint: item.meaning.isNotEmpty ? '${item.meaning[0]}...' : null,
      );
    } else {
      return Question(
        id: 'fb_${item.id}_${DateTime.now().millisecondsSinceEpoch}',
        type: QuestionType.fillBlank,
        targetItem: item,
        questionText: 'Type the reading of "${item.term}"',
        correctAnswer: item.reading ?? item.term,
        hint: item.reading?.isNotEmpty == true ? '${item.reading![0]}...' : null,
      );
    }
  }

  /// Select distractor items for multiple choice (similar difficulty/category)
  List<VocabItem> _selectDistractors(VocabItem target, List<VocabItem> allItems, {int count = 3}) {
    // Filter out the target item
    final candidates = allItems.where((item) => item.id != target.id).toList();

    if (candidates.length <= count) {
      return candidates;
    }

    // Prefer items from same level/category for harder distractors
    final sameLevel = candidates.where((item) => item.level == target.level).toList();
    
    final selected = <VocabItem>[];
    final source = sameLevel.length >= count ? sameLevel : candidates;
    
    source.shuffle(_random);
    selected.addAll(source.take(count));

    return selected;
  }
}
