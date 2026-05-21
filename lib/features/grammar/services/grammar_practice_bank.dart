import '../../../core/app_language.dart';
import '../../../data/db/app_database.dart';
import '../../exercise/models/exercise.dart';
import '../../exercise/services/exercise_bank.dart';
import 'grammar_question_generator.dart';

class GrammarPracticeBank {
  const GrammarPracticeBank._();

  static List<GeneratedQuestion> buildGenerated({
    required List<({GrammarPoint point, List<GrammarExample> examples})>
    details,
    required List<GrammarPoint> allPoints,
    required AppLanguage language,
  }) {
    return GrammarQuestionGenerator.generateQuestions(
      details,
      allPoints: allPoints,
      language: language,
    );
  }

  static String exerciseItemId(GrammarPoint point) {
    return 'grammar:${point.jlptLevel.toLowerCase()}:${point.id}';
  }

  static GeneratedExerciseBank buildExerciseBank({
    required List<({GrammarPoint point, List<GrammarExample> examples})>
    details,
    required List<GrammarPoint> allPoints,
    required AppLanguage language,
    int minPerItem = 50,
  }) {
    final generated = buildGenerated(
      details: details,
      allPoints: allPoints,
      language: language,
    );
    final questionsByPoint = <int, List<GeneratedQuestion>>{};
    for (final question in generated) {
      questionsByPoint.putIfAbsent(question.point.id, () => []).add(question);
    }

    final exercises = <Exercise>[];
    for (final detail in details) {
      final itemId = exerciseItemId(detail.point);
      final base = <Exercise>[
        ..._seedExercisesFor(
          itemId: itemId,
          detail: detail,
          allPoints: allPoints,
          language: language,
        ),
        for (final entry in questionsByPoint[detail.point.id] ?? const [])
          _fromGeneratedQuestion(
            itemId: itemId,
            question: entry,
            allPoints: allPoints,
            language: language,
            ordinal: (questionsByPoint[detail.point.id] ?? const []).indexOf(
              entry,
            ),
          ),
      ];
      exercises.addAll(_densify(itemId: itemId, source: base, min: minPerItem));
    }
    return GeneratedExerciseBank(exercises: exercises);
  }

  static Exercise _fromGeneratedQuestion({
    required String itemId,
    required GeneratedQuestion question,
    required List<GrammarPoint> allPoints,
    required AppLanguage language,
    required int ordinal,
  }) {
    final type = _exerciseTypeFor(question.type);
    final bloomLevel = _bloomLevelFor(question.type);
    final options = _choiceOptions(
      correct: question.correctAnswer,
      rawOptions: question.options,
      allPoints: allPoints,
      point: question.point,
      language: language,
    );
    return Exercise(
      id: '$itemId:generated:$ordinal:${question.type.name}',
      itemId: itemId,
      type: type,
      bloomLevel: bloomLevel,
      prompt: question.question,
      correctAnswer: question.correctAnswer,
      options:
          type == ExerciseType.recognition ||
              type == ExerciseType.readingComp ||
              type == ExerciseType.listening
          ? options
          : _productionChunks(question),
      explanation: question.explanation ?? question.feedback,
      sourceQuestionId: question.familyKey,
      source: ExerciseSource.generated,
      tags: ['grammar', question.type.name, question.point.jlptLevel],
      metadata: {
        'stemKey': question.stemKey,
        'answerShapeKey': question.answerShapeKey,
      },
    );
  }

  static List<Exercise> _seedExercisesFor({
    required String itemId,
    required ({GrammarPoint point, List<GrammarExample> examples}) detail,
    required List<GrammarPoint> allPoints,
    required AppLanguage language,
  }) {
    final point = detail.point;
    final meaning = _localizedMeaning(point, language);
    final explanation = _localizedExplanation(point, language);
    final example = detail.examples.isEmpty ? null : detail.examples.first;
    final exampleJa = example?.japanese ?? point.grammarPoint;
    final exampleVi = example == null
        ? meaning
        : _firstNonEmpty([example.translationVi, example.translation]);
    final meaningOptions = _choiceOptions(
      correct: meaning,
      rawOptions: const [],
      allPoints: allPoints,
      point: point,
      language: language,
    );
    final patternOptions = _choiceOptions(
      correct: point.grammarPoint,
      rawOptions: const [],
      allPoints: allPoints,
      point: point,
      language: language,
      usePatterns: true,
    );

    return [
      Exercise(
        id: '$itemId:seed:recognition',
        itemId: itemId,
        type: ExerciseType.recognition,
        bloomLevel: BloomLevel.l1Remember,
        prompt: 'Mẫu "${point.grammarPoint}" có nghĩa gần nhất là gì?',
        correctAnswer: meaning,
        options: meaningOptions,
        explanation: explanation,
        source: ExerciseSource.generated,
        tags: ['grammar', 'recognition', point.jlptLevel],
      ),
      Exercise(
        id: '$itemId:seed:recall',
        itemId: itemId,
        type: ExerciseType.recall,
        bloomLevel: BloomLevel.l2Understand,
        prompt: 'Nhập mẫu ngữ pháp phù hợp với nghĩa: $meaning',
        correctAnswer: point.grammarPoint,
        explanation: explanation,
        source: ExerciseSource.generated,
        tags: ['grammar', 'recall', point.jlptLevel],
      ),
      Exercise(
        id: '$itemId:seed:production',
        itemId: itemId,
        type: ExerciseType.production,
        bloomLevel: BloomLevel.l3Apply,
        prompt: 'Sắp xếp phần kết nối cho mẫu "${point.grammarPoint}".',
        correctAnswer: point.connection,
        options: _uniqueChunks(point.connection),
        explanation: explanation,
        source: ExerciseSource.generated,
        tags: ['grammar', 'production', point.jlptLevel],
      ),
      Exercise(
        id: '$itemId:seed:reading',
        itemId: itemId,
        type: ExerciseType.readingComp,
        bloomLevel: BloomLevel.l4Analyze,
        prompt: 'Đọc câu "$exampleJa"\nÝ nào giải thích đúng ngữ cảnh này?',
        correctAnswer: exampleVi,
        options: _choiceOptions(
          correct: exampleVi,
          rawOptions: [meaning, ...meaningOptions],
          allPoints: allPoints,
          point: point,
          language: language,
        ),
        explanation: explanation,
        source: ExerciseSource.generated,
        tags: ['grammar', 'reading_comp', point.jlptLevel],
      ),
      Exercise(
        id: '$itemId:seed:listening',
        itemId: itemId,
        type: ExerciseType.listening,
        bloomLevel: BloomLevel.l2Understand,
        prompt: 'Nghe câu TTS rồi chọn mẫu xuất hiện.',
        correctAnswer: point.grammarPoint,
        options: patternOptions,
        explanation: explanation,
        audioText: exampleJa,
        source: ExerciseSource.ttsReady,
        tags: ['grammar', 'listening', point.jlptLevel],
      ),
      Exercise(
        id: '$itemId:seed:conjugation',
        itemId: itemId,
        type: ExerciseType.conjugationDrill,
        bloomLevel: BloomLevel.l3Apply,
        prompt: 'Dựa vào kết nối, nhập dạng/mẫu cần luyện.',
        correctAnswer: point.connection,
        explanation: explanation,
        source: ExerciseSource.generated,
        tags: ['grammar', 'structure_drill', point.jlptLevel],
      ),
    ];
  }

  static List<Exercise> _densify({
    required String itemId,
    required List<Exercise> source,
    required int min,
  }) {
    final exercises = List<Exercise>.of(source);
    if (exercises.isEmpty) return exercises;
    var index = 0;
    while (exercises.length < min) {
      final seed = source[index % source.length];
      exercises.add(
        Exercise(
          id: '$itemId:repeat:${exercises.length}:${seed.id.hashCode.abs()}',
          itemId: itemId,
          type: seed.type,
          bloomLevel: seed.bloomLevel,
          prompt: '${seed.prompt}\nLượt luyện ${exercises.length + 1}.',
          correctAnswer: seed.correctAnswer,
          options: seed.options,
          explanation: seed.explanation,
          sourceQuestionId: seed.sourceQuestionId,
          audioText: seed.audioText,
          source: seed.source,
          tags: seed.tags,
          metadata: seed.metadata,
        ),
      );
      index += 1;
    }
    return exercises;
  }

  static ExerciseType _exerciseTypeFor(GrammarQuestionType type) {
    return switch (type) {
      GrammarQuestionType.sentenceBuilder => ExerciseType.production,
      GrammarQuestionType.cloze => ExerciseType.recall,
      GrammarQuestionType.multipleChoice => ExerciseType.recognition,
      GrammarQuestionType.reverseMultipleChoice => ExerciseType.recognition,
      GrammarQuestionType.contextChoice => ExerciseType.readingComp,
      GrammarQuestionType.errorCorrection => ExerciseType.production,
      GrammarQuestionType.transformation => ExerciseType.production,
      GrammarQuestionType.pairContrast => ExerciseType.readingComp,
      GrammarQuestionType.errorReason => ExerciseType.readingComp,
    };
  }

  static BloomLevel _bloomLevelFor(GrammarQuestionType type) {
    return switch (type) {
      GrammarQuestionType.multipleChoice => BloomLevel.l1Remember,
      GrammarQuestionType.reverseMultipleChoice => BloomLevel.l1Remember,
      GrammarQuestionType.cloze => BloomLevel.l2Understand,
      GrammarQuestionType.sentenceBuilder => BloomLevel.l3Apply,
      GrammarQuestionType.errorCorrection => BloomLevel.l3Apply,
      GrammarQuestionType.transformation => BloomLevel.l3Apply,
      GrammarQuestionType.contextChoice => BloomLevel.l4Analyze,
      GrammarQuestionType.pairContrast => BloomLevel.l4Analyze,
      GrammarQuestionType.errorReason => BloomLevel.l4Analyze,
    };
  }

  static List<String> _choiceOptions({
    required String correct,
    required List<String> rawOptions,
    required List<GrammarPoint> allPoints,
    required GrammarPoint point,
    required AppLanguage language,
    bool usePatterns = false,
  }) {
    final values = <String>[];
    void add(String value) {
      final normalized = value.trim();
      if (normalized.isEmpty) return;
      if (values.any((item) => _optionKey(item) == _optionKey(normalized))) {
        return;
      }
      values.add(normalized);
    }

    add(correct);
    for (final option in rawOptions) {
      add(option);
    }
    for (final candidate in allPoints) {
      if (candidate.id == point.id) continue;
      add(
        usePatterns
            ? candidate.grammarPoint
            : _localizedMeaning(candidate, language),
      );
      if (values.length >= 4) break;
    }
    var fallback = 1;
    while (values.length < 4) {
      add('Phương án nhiễu $fallback');
      fallback += 1;
    }
    return values.take(4).toList(growable: false);
  }

  static List<String> _productionChunks(GeneratedQuestion question) {
    if (question.type == GrammarQuestionType.sentenceBuilder) {
      return question.options.toSet().take(8).toList(growable: false);
    }
    return _uniqueChunks(question.correctAnswer);
  }

  static List<String> _uniqueChunks(String value) {
    final chunks = value
        .split(RegExp(r'(\s+|[+/・、。])'))
        .map((chunk) => chunk.trim())
        .where((chunk) => chunk.isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (chunks.length >= 2) return chunks;
    return [value.trim(), '文脈'].where((chunk) => chunk.isNotEmpty).toList();
  }

  static String _localizedMeaning(GrammarPoint point, AppLanguage language) {
    return switch (language) {
      AppLanguage.vi => _firstNonEmpty([point.meaningVi, point.meaning]),
      AppLanguage.en => _firstNonEmpty([point.meaningEn, point.meaning]),
      AppLanguage.ja => _firstNonEmpty([point.meaningEn, point.meaning]),
    };
  }

  static String _localizedExplanation(
    GrammarPoint point,
    AppLanguage language,
  ) {
    return switch (language) {
      AppLanguage.vi => _firstNonEmpty([
        point.explanationVi,
        point.explanation,
      ]),
      AppLanguage.en => _firstNonEmpty([
        point.explanationEn,
        point.explanation,
      ]),
      AppLanguage.ja => _firstNonEmpty([
        point.explanationEn,
        point.explanation,
      ]),
    };
  }

  static String _firstNonEmpty(Iterable<String?> values) {
    for (final value in values) {
      final normalized = value?.trim() ?? '';
      if (normalized.isNotEmpty) return normalized;
    }
    return '';
  }

  static String _optionKey(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }
}
