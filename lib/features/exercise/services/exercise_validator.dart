import '../models/exercise.dart';

class ExerciseValidationException implements Exception {
  const ExerciseValidationException(this.message);

  final String message;

  @override
  String toString() => 'ExerciseValidationException: $message';
}

class ExerciseDensityViolation implements Exception {
  const ExerciseDensityViolation({
    required this.itemId,
    required this.actual,
    required this.minimum,
  });

  final String itemId;
  final int actual;
  final int minimum;

  @override
  String toString() {
    return 'ExerciseDensityViolation: $itemId has $actual/$minimum exercises';
  }
}

class ExerciseValidator {
  const ExerciseValidator._();

  static void validate(Exercise exercise) {
    if (exercise.id.trim().isEmpty) {
      throw const ExerciseValidationException('missing exercise id');
    }
    if (exercise.itemId.trim().isEmpty) {
      throw const ExerciseValidationException('missing item id');
    }
    if (exercise.prompt.trim().isEmpty) {
      throw ExerciseValidationException('missing prompt: ${exercise.id}');
    }
    if (exercise.correctAnswer.trim().isEmpty) {
      throw ExerciseValidationException(
        'missing correct answer: ${exercise.id}',
      );
    }

    if (exercise.options.isNotEmpty) {
      final normalized = exercise.options
          .map(_normalizeOption)
          .where((option) => option.isNotEmpty)
          .toList(growable: false);
      if (normalized.length != exercise.options.length) {
        throw ExerciseValidationException('blank option in ${exercise.id}');
      }
      if (normalized.toSet().length != normalized.length) {
        throw ExerciseValidationException(
          'duplicate options in ${exercise.id}',
        );
      }
      if (exercise.isChoiceBased && normalized.length < 4) {
        throw ExerciseValidationException(
          'choice exercise needs 4 options: ${exercise.id}',
        );
      }
      final correct = _normalizeOption(exercise.correctAnswer);
      if (exercise.isChoiceBased && !normalized.contains(correct)) {
        throw ExerciseValidationException(
          'choice options omit correct answer: ${exercise.id}',
        );
      }
    }
  }

  static void validateBank(Iterable<Exercise> exercises) {
    final ids = <String>{};
    final signatures = <String>{};
    for (final exercise in exercises) {
      validate(exercise);
      if (!ids.add(exercise.id)) {
        throw ExerciseValidationException('duplicate id: ${exercise.id}');
      }
      final signature =
          '${exercise.itemId}|${exercise.type.name}|'
          '${_normalizeOption(exercise.prompt)}|'
          '${_normalizeOption(exercise.correctAnswer)}';
      if (!signatures.add(signature)) {
        throw ExerciseValidationException(
          'duplicate exercise signature: ${exercise.id}',
        );
      }
    }
  }

  static String _normalizeOption(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }
}
