import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_relationship_graph.dart';

class KanjiGraphPracticeQuestion {
  const KanjiGraphPracticeQuestion({
    required this.target,
    required this.prompt,
    required this.options,
    required this.correctCharacter,
  });

  final KanjiGraphNode target;
  final String prompt;
  final List<String> options;
  final String correctCharacter;
}

class KanjiGraphPracticeSession {
  const KanjiGraphPracticeSession({required this.questions});

  final List<KanjiGraphPracticeQuestion> questions;

  static KanjiGraphPracticeSession generate({
    required KanjiRelationshipGraphData graphData,
    required AppLanguage language,
    int count = 5,
  }) {
    final targets = graphData.nodes
        .where((node) => node.item != null)
        .toList(growable: false);
    if (targets.isEmpty) {
      return const KanjiGraphPracticeSession(questions: []);
    }
    final optionCharacters = _optionCharacters(graphData);
    final questions = <KanjiGraphPracticeQuestion>[];
    for (var index = 0; index < count; index++) {
      final target = targets[index % targets.length];
      questions.add(
        KanjiGraphPracticeQuestion(
          target: target,
          prompt: _promptFor(target, language),
          options: _optionsFor(
            correct: target.character,
            pool: optionCharacters,
            rotation: index,
          ),
          correctCharacter: target.character,
        ),
      );
    }
    return KanjiGraphPracticeSession(questions: List.unmodifiable(questions));
  }

  static List<String> _optionCharacters(KanjiRelationshipGraphData graphData) {
    final seen = <String>{};
    final options = <String>[];
    for (final node in graphData.nodes) {
      if (seen.add(node.character)) {
        options.add(node.character);
      }
    }
    const pads = ['日', '月', '火', '水', '木', '金', '土', '山'];
    for (final pad in pads) {
      if (options.length >= 4) break;
      if (seen.add(pad)) {
        options.add(pad);
      }
    }
    return options;
  }

  static List<String> _optionsFor({
    required String correct,
    required List<String> pool,
    required int rotation,
  }) {
    final distractors = pool
        .where((character) => character != correct)
        .toList(growable: false);
    final rotated = distractors.isEmpty
        ? <String>[]
        : [
            for (var i = 0; i < distractors.length; i++)
              distractors[(i + rotation) % distractors.length],
          ];
    final options = <String>[correct, ...rotated.take(3)];
    while (options.length < 4) {
      options.add(correct);
    }
    final offset = rotation % options.length;
    return [
      for (var i = 0; i < options.length; i++)
        options[(i + offset) % options.length],
    ];
  }

  static String _promptFor(KanjiGraphNode target, AppLanguage language) {
    final item = target.item;
    final hanViet = item?.decomposition?.hanViet?.trim() ?? '';
    final meaning = item?.displayMeaning(language).trim() ?? target.character;
    return switch (language) {
      AppLanguage.vi when hanViet.isNotEmpty =>
        'Âm Hán-Việt $hanViet → kanji nào?',
      AppLanguage.vi => 'Nghĩa "$meaning" → kanji nào?',
      AppLanguage.en => 'Meaning "$meaning" -> which kanji?',
      AppLanguage.ja => '「$meaning」に合う漢字は？',
    };
  }
}

class KanjiGraphPracticeOutcome {
  const KanjiGraphPracticeOutcome({
    required this.correctCount,
    required this.totalCount,
    required this.practicedCharacters,
    required this.missedCharacters,
  });

  final int correctCount;
  final int totalCount;
  final Set<String> practicedCharacters;
  final Set<String> missedCharacters;

  bool get passed => totalCount > 0 && correctCount / totalCount >= 0.8;
}
