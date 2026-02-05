import 'package:jpstudy/data/db/app_database.dart';

import '../../../core/app_language.dart';

enum GrammarQuestionType {
  sentenceBuilder,
  cloze,
  multipleChoice,
  reverseMultipleChoice,
  contextChoice,
  errorCorrection,
  transformation,
  pairContrast,
  errorReason,
}

class GeneratedQuestion {
  const GeneratedQuestion({
    required this.type,
    required this.point,
    required this.question,
    required this.correctAnswer,
    required this.options,
    required this.familyKey,
    required this.stemKey,
    required this.answerShapeKey,
    this.explanation,
    this.feedback,
  });

  final GrammarQuestionType type;
  final GrammarPoint point;
  final String question;
  final String correctAnswer;
  final List<String> options;
  final String familyKey;
  final String stemKey;
  final String answerShapeKey;
  final String? explanation;
  final String? feedback;
}

class GrammarQuestionGenerator {
  static const List<List<String>> _minimalPairPack = [
    ['は', 'が'],
    ['に', 'で'],
    ['を', 'が'],
    ['から', 'まで'],
    ['より', 'ほど'],
    ['ている', 'てある'],
    ['たい', 'ほしい'],
    ['そう', 'よう'],
    ['ために', 'ように'],
    ['ことができる', 'られる'],
  ];

  /// Generate practice questions from grammar point details.
  static List<GeneratedQuestion> generateQuestions(
    List<({GrammarPoint point, List<GrammarExample> examples})> details, {
    List<GrammarPoint>? allPoints,
    required AppLanguage language,
  }) {
    final questions = <GeneratedQuestion>[];
    final dedupeKeys = <String>{};
    final examplePool = <({GrammarPoint point, GrammarExample example})>[
      for (final detail in details)
        for (final example in detail.examples)
          (point: detail.point, example: example),
    ];

    for (final detail in details) {
      final point = detail.point;
      final pointMeaning = _localizedPointMeaning(point, language);
      final pointExplanation = _localizedPointExplanation(point, language);
      final primaryExample = detail.examples.isEmpty
          ? null
          : detail.examples.first;

      _addQuestion(
        questions,
        dedupeKeys,
        _buildReverseMeaningQuestion(
          point: point,
          pointMeaning: pointMeaning,
          pointExplanation: pointExplanation,
          allPoints: allPoints,
          language: language,
        ),
      );

      _addQuestion(
        questions,
        dedupeKeys,
        _buildMeaningQuestion(
          point: point,
          pointMeaning: pointMeaning,
          pointExplanation: pointExplanation,
          allPoints: allPoints,
          language: language,
        ),
      );

      _addQuestion(
        questions,
        dedupeKeys,
        _buildPairContrastQuestion(
          point: point,
          pointMeaning: pointMeaning,
          pointExplanation: pointExplanation,
          primaryExample: primaryExample,
          allPoints: allPoints,
          language: language,
        ),
      );

      for (final example in detail.examples) {
        final localizedTranslation = _localizedExampleTranslation(
          example,
          language,
        );
        final sentenceTokens = _tokenizeSentence(example.japanese);

        if (sentenceTokens.isNotEmpty) {
          _addQuestion(
            questions,
            dedupeKeys,
            GeneratedQuestion(
              type: GrammarQuestionType.sentenceBuilder,
              point: point,
              question: _tr(
                language,
                en: 'Arrange the sentence.',
                vi: 'Ghép thành câu hoàn chỉnh.',
                ja: '文を並び替えてください。',
              ),
              correctAnswer: example.japanese,
              options: sentenceTokens,
              familyKey: 'builder_${point.id}',
              stemKey: _normalizeStem(example.japanese),
              answerShapeKey: 'builder_${sentenceTokens.length}',
              explanation: localizedTranslation,
              feedback: _tr(
                language,
                en: 'Target pattern: ${point.grammarPoint}. ${pointExplanation.trim()}',
                vi: 'Mẫu ngữ pháp: ${point.grammarPoint}. ${pointExplanation.trim()}',
                ja: '使うべき文型: ${point.grammarPoint}。${pointExplanation.trim()}',
              ),
            ),
          );
        }

        _addQuestion(
          questions,
          dedupeKeys,
          _buildClozeQuestion(
            point: point,
            pointMeaning: pointMeaning,
            pointExplanation: pointExplanation,
            example: example,
            allPoints: allPoints,
            language: language,
          ),
        );

        _addQuestion(
          questions,
          dedupeKeys,
          _buildContextChoiceQuestion(
            point: point,
            pointMeaning: pointMeaning,
            pointExplanation: pointExplanation,
            targetExample: example,
            examplePool: examplePool,
            language: language,
          ),
        );

        _addQuestion(
          questions,
          dedupeKeys,
          _buildErrorCorrectionQuestion(
            point: point,
            pointMeaning: pointMeaning,
            pointExplanation: pointExplanation,
            example: example,
            allPoints: allPoints,
            language: language,
          ),
        );

        _addQuestion(
          questions,
          dedupeKeys,
          _buildErrorReasonQuestion(
            point: point,
            pointMeaning: pointMeaning,
            pointExplanation: pointExplanation,
            example: example,
            allPoints: allPoints,
            language: language,
          ),
        );

        _addQuestion(
          questions,
          dedupeKeys,
          _buildTransformationQuestion(
            point: point,
            pointMeaning: pointMeaning,
            pointExplanation: pointExplanation,
            example: example,
            language: language,
          ),
        );
      }
    }

    return questions;
  }

  static void _addQuestion(
    List<GeneratedQuestion> out,
    Set<String> dedupeKeys,
    GeneratedQuestion? question,
  ) {
    if (question == null) return;
    if (question.options.isEmpty) return;

    final key = '${question.type}:${question.point.id}:${question.question}';
    if (dedupeKeys.add(key)) {
      out.add(question);
    }
  }

  static GeneratedQuestion? _buildReverseMeaningQuestion({
    required GrammarPoint point,
    required String pointMeaning,
    required String pointExplanation,
    required List<GrammarPoint>? allPoints,
    required AppLanguage language,
  }) {
    if (allPoints == null || allPoints.isEmpty) return null;

    final distractors = _pickOtherGrammarPoints(
      allPoints,
      point.id,
      3,
    ).map((p) => p.grammarPoint).toList(growable: false);
    if (distractors.length < 2) return null;

    final options = _uniqueShuffled([point.grammarPoint, ...distractors]);
    if (options.length < 3) return null;

    final questionText = _tr(
      language,
      en: 'Which pattern matches: "$pointMeaning"?',
      vi: 'Mẫu nào có nghĩa là: "$pointMeaning"?',
      ja: '「$pointMeaning」に合う文型はどれですか？',
    );

    return GeneratedQuestion(
      type: GrammarQuestionType.reverseMultipleChoice,
      point: point,
      question: questionText,
      correctAnswer: point.grammarPoint,
      options: options,
      familyKey: 'reverse_meaning_${point.id}',
      stemKey: _normalizeStem(questionText),
      answerShapeKey: 'choice_${options.length}',
      explanation: pointExplanation,
      feedback: _tr(
        language,
        en: 'Use ${point.grammarPoint} when you mean: $pointMeaning.',
        vi: 'Dùng ${point.grammarPoint} để diễn đạt: $pointMeaning.',
        ja: '$pointMeaning を表すときは ${point.grammarPoint} を使います。',
      ),
    );
  }

  static GeneratedQuestion? _buildMeaningQuestion({
    required GrammarPoint point,
    required String pointMeaning,
    required String pointExplanation,
    required List<GrammarPoint>? allPoints,
    required AppLanguage language,
  }) {
    if (allPoints == null || allPoints.isEmpty) return null;

    final distractors = _pickOtherGrammarPoints(
      allPoints,
      point.id,
      3,
    ).map((p) => _localizedPointMeaning(p, language)).toList(growable: false);
    if (distractors.length < 2) return null;

    final options = _uniqueShuffled([pointMeaning, ...distractors]);
    if (options.length < 3) return null;

    final questionText = _tr(
      language,
      en: 'What is the best meaning of "${point.grammarPoint}"?',
      vi: '"${point.grammarPoint}" có nghĩa là gì?',
      ja: '「${point.grammarPoint}」の意味として最も適切なのはどれですか？',
    );

    return GeneratedQuestion(
      type: GrammarQuestionType.multipleChoice,
      point: point,
      question: questionText,
      correctAnswer: pointMeaning,
      options: options,
      familyKey: 'meaning_${point.id}',
      stemKey: _normalizeStem(questionText),
      answerShapeKey: 'choice_${options.length}',
      explanation: pointExplanation,
      feedback: pointExplanation,
    );
  }

  static GeneratedQuestion? _buildPairContrastQuestion({
    required GrammarPoint point,
    required String pointMeaning,
    required String pointExplanation,
    required GrammarExample? primaryExample,
    required List<GrammarPoint>? allPoints,
    required AppLanguage language,
  }) {
    if (allPoints == null || allPoints.isEmpty) return null;

    final contrast = _pickContrastPoint(point, allPoints);
    if (contrast == null) return null;

    final context = primaryExample == null
        ? pointMeaning
        : _localizedExampleTranslation(primaryExample, language);
    final questionText = _tr(
      language,
      en: 'Contrast drill\nA: ${point.grammarPoint}  vs  B: ${contrast.grammarPoint}\nContext: $context\nWhich pattern fits better?',
      vi: 'Phân biệt mẫu\nA: ${point.grammarPoint}  vs  B: ${contrast.grammarPoint}\nNgữ cảnh: $context\nChọn đáp án phù hợp.',
      ja: '対比ドリル\nA: ${point.grammarPoint}  vs  B: ${contrast.grammarPoint}\n文脈: $context\nより適切な文型はどれですか？',
    );

    final options = _uniqueShuffled([
      point.grammarPoint,
      contrast.grammarPoint,
    ]);
    if (options.length < 2) return null;

    return GeneratedQuestion(
      type: GrammarQuestionType.pairContrast,
      point: point,
      question: questionText,
      correctAnswer: point.grammarPoint,
      options: options,
      familyKey: 'contrast_${point.id}_${contrast.id}',
      stemKey: _normalizeStem(questionText),
      answerShapeKey: 'choice_${options.length}',
      explanation: pointExplanation,
      feedback: _tr(
        language,
        en: 'Pick ${point.grammarPoint} for this nuance. Contrast option: ${contrast.grammarPoint} (minimal pair).',
        vi: 'Sắc thái này nên dùng ${point.grammarPoint}. Mẫu đối chiếu là ${contrast.grammarPoint}.',
        ja: 'このニュアンスでは ${point.grammarPoint} が適切です。対比候補は ${contrast.grammarPoint} です。',
      ),
    );
  }

  static GrammarPoint? _pickContrastPoint(
    GrammarPoint point,
    List<GrammarPoint> allPoints,
  ) {
    final self = _normalizePattern(point.grammarPoint);
    final pool = allPoints
        .where((candidate) => candidate.id != point.id)
        .toList(growable: false);
    if (pool.isEmpty) return null;

    for (final pair in _minimalPairPack) {
      final selfToken = pair.firstWhere(
        (token) => self.contains(_normalizePattern(token)),
        orElse: () => '',
      );
      if (selfToken.isEmpty) continue;
      for (final token in pair) {
        if (token == selfToken) continue;
        final normalized = _normalizePattern(token);
        for (final candidate in pool) {
          if (_normalizePattern(candidate.grammarPoint).contains(normalized)) {
            return candidate;
          }
        }
      }
    }

    for (final candidate in pool) {
      if (candidate.jlptLevel == point.jlptLevel) {
        return candidate;
      }
    }
    return pool.first;
  }

  static GeneratedQuestion? _buildClozeQuestion({
    required GrammarPoint point,
    required String pointMeaning,
    required String pointExplanation,
    required GrammarExample example,
    required List<GrammarPoint>? allPoints,
    required AppLanguage language,
  }) {
    if (!example.japanese.contains(point.grammarPoint)) return null;
    if (allPoints == null || allPoints.isEmpty) return null;

    final distractors = _pickOtherGrammarPoints(
      allPoints,
      point.id,
      3,
    ).map((p) => p.grammarPoint).toList(growable: false);

    final options = _uniqueShuffled([point.grammarPoint, ...distractors]);
    if (options.length < 3) return null;

    final questionText = example.japanese.replaceFirst(
      point.grammarPoint,
      '{blank}',
    );

    return GeneratedQuestion(
      type: GrammarQuestionType.cloze,
      point: point,
      question: questionText,
      correctAnswer: point.grammarPoint,
      options: options,
      familyKey: 'cloze_${point.id}',
      stemKey: _normalizeStem(questionText),
      answerShapeKey: 'choice_${options.length}',
      explanation: pointMeaning,
      feedback: _tr(
        language,
        en: 'Expected ${point.grammarPoint}. It matches "$pointMeaning". ${pointExplanation.trim()}',
        vi: 'Đáp án đúng là ${point.grammarPoint}. Mẫu này khớp với "$pointMeaning". ${pointExplanation.trim()}',
        ja: '正解は ${point.grammarPoint} です。「$pointMeaning」に合います。${pointExplanation.trim()}',
      ),
    );
  }

  static GeneratedQuestion? _buildContextChoiceQuestion({
    required GrammarPoint point,
    required String pointMeaning,
    required String pointExplanation,
    required GrammarExample targetExample,
    required List<({GrammarPoint point, GrammarExample example})> examplePool,
    required AppLanguage language,
  }) {
    final prompt = _localizedExampleTranslation(targetExample, language).trim();
    if (prompt.isEmpty) return null;

    final distractors = <String>[];
    final shuffledPool =
        List<({GrammarPoint point, GrammarExample example})>.of(examplePool)
          ..shuffle();
    for (final item in shuffledPool) {
      if (item.point.id == point.id) continue;
      final sentence = item.example.japanese.trim();
      if (sentence.isEmpty || sentence == targetExample.japanese.trim()) {
        continue;
      }
      distractors.add(sentence);
      if (distractors.length >= 3) break;
    }
    if (distractors.length < 2) return null;

    final options = _uniqueShuffled([targetExample.japanese, ...distractors]);
    if (options.length < 3) return null;

    final questionText = _tr(
      language,
      en: 'Pick the sentence that best matches this context:\n$prompt',
      vi: 'Chọn câu phù hợp nhất với ngữ cảnh sau:\n$prompt',
      ja: '次の文脈に最も合う文を選んでください:\n$prompt',
    );

    return GeneratedQuestion(
      type: GrammarQuestionType.contextChoice,
      point: point,
      question: questionText,
      correctAnswer: targetExample.japanese,
      options: options,
      familyKey: 'context_${point.id}',
      stemKey: _normalizeStem(prompt),
      answerShapeKey: 'choice_${options.length}',
      explanation: pointExplanation,
      feedback: _tr(
        language,
        en: 'Correct because it uses ${point.grammarPoint} in context.',
        vi: 'Đúng vì câu này dùng ${point.grammarPoint} đúng ngữ cảnh.',
        ja: '文脈に合う ${point.grammarPoint} が使われているため正解です。',
      ),
    );
  }

  static GeneratedQuestion? _buildErrorCorrectionQuestion({
    required GrammarPoint point,
    required String pointMeaning,
    required String pointExplanation,
    required GrammarExample example,
    required List<GrammarPoint>? allPoints,
    required AppLanguage language,
  }) {
    final corrupted = _buildCorruptedSentence(
      point: point,
      example: example,
      allPoints: allPoints,
    );
    if (corrupted == null) return null;

    final options = _uniqueShuffled([
      point.grammarPoint,
      corrupted.replacement,
      ...corrupted.alternativePatterns.take(2),
    ]);
    if (options.length < 3) return null;

    final questionText = _tr(
      language,
      en: 'This sentence has a grammar mistake:\n${corrupted.wrongSentence}\nWhich pattern fixes it?',
      vi: 'Câu sau bị sai ngữ pháp:\n${corrupted.wrongSentence}\nHãy chọn mẫu đúng để sửa.',
      ja: '次の文には文法の誤りがあります:\n${corrupted.wrongSentence}\nどの文型で直せますか？',
    );

    return GeneratedQuestion(
      type: GrammarQuestionType.errorCorrection,
      point: point,
      question: questionText,
      correctAnswer: point.grammarPoint,
      options: options,
      familyKey: 'error_fix_${point.id}',
      stemKey: _normalizeStem(corrupted.wrongSentence),
      answerShapeKey: 'choice_${options.length}',
      explanation: pointMeaning,
      feedback: _tr(
        language,
        en: 'Use ${point.grammarPoint}. Correct sentence: ${corrupted.correctSentence}',
        vi: 'Nên dùng ${point.grammarPoint}. Câu đúng: ${corrupted.correctSentence}',
        ja: '${point.grammarPoint} を使います。正しい文: ${corrupted.correctSentence}',
      ),
    );
  }

  static GeneratedQuestion? _buildErrorReasonQuestion({
    required GrammarPoint point,
    required String pointMeaning,
    required String pointExplanation,
    required GrammarExample example,
    required List<GrammarPoint>? allPoints,
    required AppLanguage language,
  }) {
    final corrupted = _buildCorruptedSentence(
      point: point,
      example: example,
      allPoints: allPoints,
    );
    if (corrupted == null) return null;

    final correctReason = _tr(
      language,
      en: 'The pattern "${corrupted.replacement}" does not match this meaning. Use "${point.grammarPoint}".',
      vi: 'Mẫu "${corrupted.replacement}" không hợp nghĩa. Cần dùng "${point.grammarPoint}".',
      ja: '「${corrupted.replacement}」はこの意味に合いません。「${point.grammarPoint}」を使います。',
    );

    final options = _uniqueShuffled([
      correctReason,
      _tr(
        language,
        en: 'Only kanji writing is wrong; grammar is fine.',
        vi: 'Chỉ sai cách viết kanji, ngữ pháp vẫn đúng.',
        ja: '漢字の書き方だけが誤りで、文法自体は正しい。',
      ),
      _tr(
        language,
        en: 'Word order alone is the issue; pattern choice is correct.',
        vi: 'Chỉ sai trật tự từ; việc chọn mẫu ngữ pháp là đúng.',
        ja: '語順だけが問題で、文型の選択は正しい。',
      ),
      _tr(
        language,
        en: 'The sentence lacks vocabulary, not grammar.',
        vi: 'Vấn đề là thiếu từ vựng, không phải ngữ pháp.',
        ja: '問題は語彙不足で、文法の誤りではない。',
      ),
    ]);
    if (options.length < 3) return null;

    final questionText = _tr(
      language,
      en: 'Why is this sentence wrong?\n${corrupted.wrongSentence}',
      vi: 'Vì sao câu này sai?\n${corrupted.wrongSentence}',
      ja: 'この文が誤りなのはなぜですか？\n${corrupted.wrongSentence}',
    );

    return GeneratedQuestion(
      type: GrammarQuestionType.errorReason,
      point: point,
      question: questionText,
      correctAnswer: correctReason,
      options: options,
      familyKey: 'error_reason_${point.id}',
      stemKey: _normalizeStem(corrupted.wrongSentence),
      answerShapeKey: 'choice_${options.length}',
      explanation: pointExplanation,
      feedback: _tr(
        language,
        en: 'Correct sentence: ${corrupted.correctSentence}',
        vi: 'Câu đúng: ${corrupted.correctSentence}',
        ja: '正しい文: ${corrupted.correctSentence}',
      ),
    );
  }

  static GeneratedQuestion? _buildTransformationQuestion({
    required GrammarPoint point,
    required String pointMeaning,
    required String pointExplanation,
    required GrammarExample example,
    required AppLanguage language,
  }) {
    final transformed = _transformToNegative(example.japanese);
    if (transformed == null || transformed == example.japanese) return null;

    final options = _uniqueShuffled([
      transformed,
      example.japanese,
      _softVariant(example.japanese),
      _softVariant(transformed),
    ]);
    if (options.length < 3) return null;

    final questionText = _tr(
      language,
      en: 'Transform this sentence to negative form:\n${example.japanese}',
      vi: 'Hãy đổi câu sau sang dạng phủ định:\n${example.japanese}',
      ja: '次の文を否定形に変えてください:\n${example.japanese}',
    );

    return GeneratedQuestion(
      type: GrammarQuestionType.transformation,
      point: point,
      question: questionText,
      correctAnswer: transformed,
      options: options,
      familyKey: 'transform_${point.id}',
      stemKey: _normalizeStem(example.japanese),
      answerShapeKey: 'choice_${options.length}',
      explanation: pointMeaning,
      feedback: _tr(
        language,
        en: 'Negative form: ${example.japanese} -> $transformed. ${pointExplanation.trim()}',
        vi: 'Dạng phủ định: ${example.japanese} -> $transformed. ${pointExplanation.trim()}',
        ja: '否定形: ${example.japanese} -> $transformed。${pointExplanation.trim()}',
      ),
    );
  }

  static _CorruptedSentence? _buildCorruptedSentence({
    required GrammarPoint point,
    required GrammarExample example,
    required List<GrammarPoint>? allPoints,
  }) {
    if (allPoints == null || allPoints.isEmpty) return null;
    if (!example.japanese.contains(point.grammarPoint)) return null;

    final alternatives = _pickOtherGrammarPoints(allPoints, point.id, 5);
    String? replacement;
    for (final value in alternatives.map((p) => p.grammarPoint)) {
      if (value.trim().isEmpty) continue;
      replacement = value;
      break;
    }
    if (replacement == null) return null;

    return _CorruptedSentence(
      wrongSentence: example.japanese.replaceFirst(
        point.grammarPoint,
        replacement,
      ),
      correctSentence: example.japanese,
      replacement: replacement,
      alternativePatterns: alternatives
          .map((item) => item.grammarPoint)
          .where((value) => value.trim().isNotEmpty)
          .toList(growable: false),
    );
  }

  static String? _transformToNegative(String sentence) {
    final s = sentence.trim();
    if (s.isEmpty) return null;

    final rules = <MapEntry<String, String>>[
      const MapEntry('ました。', 'ませんでした。'),
      const MapEntry('ます。', 'ません。'),
      const MapEntry('でした。', 'ではありませんでした。'),
      const MapEntry('です。', 'ではありません。'),
      const MapEntry('だ。', 'ではない。'),
      const MapEntry('ました', 'ませんでした'),
      const MapEntry('ます', 'ません'),
      const MapEntry('でした', 'ではありませんでした'),
      const MapEntry('です', 'ではありません'),
      const MapEntry('だ', 'ではない'),
    ];

    for (final rule in rules) {
      if (s.endsWith(rule.key)) {
        return '${s.substring(0, s.length - rule.key.length)}${rule.value}';
      }
    }
    return null;
  }

  static String _softVariant(String sentence) {
    var value = sentence.trim();
    if (value.endsWith('。')) {
      value = value.substring(0, value.length - 1);
    }
    if (value.endsWith('です')) {
      return '$valueか';
    }
    if (value.endsWith('ます')) {
      return '$valueか';
    }
    return '$value。';
  }

  static List<String> _tokenizeSentence(String sentence) {
    final trimmed = sentence.trim();
    if (trimmed.isEmpty) return const [];
    if (trimmed.contains(' ')) {
      return trimmed
          .split(RegExp(r'\s+'))
          .where((part) => part.isNotEmpty)
          .toList(growable: false);
    }

    return trimmed.runes.map(String.fromCharCode).toList(growable: false);
  }

  static List<GrammarPoint> _pickOtherGrammarPoints(
    List<GrammarPoint> points,
    int id,
    int count,
  ) {
    final pool = points.where((p) => p.id != id).toList(growable: false)
      ..shuffle();
    return pool.take(count).toList(growable: false);
  }

  static List<String> _uniqueShuffled(List<String> values) {
    final list = values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList(growable: false);
    list.shuffle();
    return list;
  }

  static String _normalizeStem(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String _normalizePattern(String input) {
    return input
        .replaceAll(RegExp(r'[\s\u3000\(\)\[\]{}<>]'), '')
        .toLowerCase();
  }

  static String _localizedPointMeaning(
    GrammarPoint point,
    AppLanguage language,
  ) {
    switch (language) {
      case AppLanguage.vi:
        return (point.meaningVi ?? point.meaning).trim();
      case AppLanguage.en:
        return (point.meaningEn ?? point.meaning).trim();
      case AppLanguage.ja:
        return point.meaning.trim().isEmpty
            ? point.grammarPoint
            : point.meaning.trim();
    }
  }

  static String _localizedPointExplanation(
    GrammarPoint point,
    AppLanguage language,
  ) {
    switch (language) {
      case AppLanguage.vi:
        return (point.explanationVi ?? point.explanation).trim();
      case AppLanguage.en:
        return (point.explanationEn ?? point.explanation).trim();
      case AppLanguage.ja:
        return point.explanation.trim();
    }
  }

  static String _localizedExampleTranslation(
    GrammarExample example,
    AppLanguage language,
  ) {
    switch (language) {
      case AppLanguage.vi:
        return (example.translationVi ?? example.translation).trim();
      case AppLanguage.en:
        return (example.translationEn ?? example.translation).trim();
      case AppLanguage.ja:
        return example.translation.trim();
    }
  }

  static String _tr(
    AppLanguage language, {
    required String en,
    required String vi,
    required String ja,
  }) {
    switch (language) {
      case AppLanguage.en:
        return en;
      case AppLanguage.vi:
        return vi;
      case AppLanguage.ja:
        return ja;
    }
  }
}

class _CorruptedSentence {
  const _CorruptedSentence({
    required this.wrongSentence,
    required this.correctSentence,
    required this.replacement,
    required this.alternativePatterns,
  });

  final String wrongSentence;
  final String correctSentence;
  final String replacement;
  final List<String> alternativePatterns;
}
