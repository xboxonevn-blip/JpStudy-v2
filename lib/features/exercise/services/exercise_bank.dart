import '../models/exercise.dart';
import 'exercise_validator.dart';

abstract class ExerciseBank {
  Future<List<Exercise>> getForItem({
    required String itemId,
    required ExerciseType type,
    BloomLevel? minLevel,
    int? limit,
  });

  Future<int> countForItem({
    required String itemId,
    required ExerciseType type,
  });

  Future<void> ensureMinimumDensity({required String itemId, int min = 50});

  Future<bool> hasBloomCoverage({required String itemId});
}

class GeneratedExerciseBank implements ExerciseBank {
  GeneratedExerciseBank({required Iterable<Exercise> exercises})
    : _exercises = List<Exercise>.unmodifiable(exercises) {
    ExerciseValidator.validateBank(_exercises);
  }

  final List<Exercise> _exercises;

  List<Exercise> get allExercises => _exercises;

  @override
  Future<List<Exercise>> getForItem({
    required String itemId,
    required ExerciseType type,
    BloomLevel? minLevel,
    int? limit,
  }) async {
    final minIndex = minLevel == null
        ? null
        : BloomLevel.values.indexOf(minLevel);
    final filtered = _exercises
        .where((exercise) {
          if (exercise.itemId != itemId || exercise.type != type) return false;
          if (minIndex == null) return true;
          return BloomLevel.values.indexOf(exercise.bloomLevel) >= minIndex;
        })
        .toList(growable: false);
    if (limit == null || limit >= filtered.length) return filtered;
    return filtered.take(limit).toList(growable: false);
  }

  @override
  Future<int> countForItem({
    required String itemId,
    required ExerciseType type,
  }) async {
    return _exercises
        .where((exercise) => exercise.itemId == itemId && exercise.type == type)
        .length;
  }

  @override
  Future<void> ensureMinimumDensity({
    required String itemId,
    int min = 50,
  }) async {
    final actual = _exercises
        .where((exercise) => exercise.itemId == itemId)
        .length;
    if (actual < min) {
      throw ExerciseDensityViolation(
        itemId: itemId,
        actual: actual,
        minimum: min,
      );
    }
  }

  @override
  Future<bool> hasBloomCoverage({required String itemId}) async {
    final levels = _exercises
        .where((exercise) => exercise.itemId == itemId)
        .map((exercise) => exercise.bloomLevel)
        .toSet();
    return BloomLevel.values.every(levels.contains);
  }
}
