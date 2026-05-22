import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/features/exercise/models/exercise.dart';
import 'package:jpstudy/features/exercise/services/exercise_bank.dart';
import 'package:jpstudy/features/exercise/services/exercise_validator.dart';

void main() {
  group('ExerciseBank', () {
    test('counts exercises by item and type', () async {
      final bank = GeneratedExerciseBank(
        exercises: [
          _exercise(
            id: 'g1-r1',
            itemId: 'grammar:n5:001',
            type: ExerciseType.recognition,
            bloomLevel: BloomLevel.l1Remember,
          ),
          _exercise(
            id: 'g1-p1',
            itemId: 'grammar:n5:001',
            type: ExerciseType.production,
            bloomLevel: BloomLevel.l3Apply,
          ),
        ],
      );

      expect(
        await bank.countForItem(
          itemId: 'grammar:n5:001',
          type: ExerciseType.recognition,
        ),
        1,
      );
      expect(
        await bank.getForItem(
          itemId: 'grammar:n5:001',
          type: ExerciseType.production,
        ),
        hasLength(1),
      );
    });

    test('throws when item density is below minimum', () async {
      final bank = GeneratedExerciseBank(
        exercises: [
          _exercise(
            id: 'g1-r1',
            itemId: 'grammar:n5:001',
            type: ExerciseType.recognition,
            bloomLevel: BloomLevel.l1Remember,
          ),
        ],
      );

      expect(
        () => bank.ensureMinimumDensity(itemId: 'grammar:n5:001', min: 50),
        throwsA(isA<ExerciseDensityViolation>()),
      );
    });

    test('reports Bloom coverage only when L1-L4 are present', () async {
      final completeBank = GeneratedExerciseBank(
        exercises: [
          _exercise(
            id: 'l1',
            itemId: 'grammar:n5:001',
            type: ExerciseType.recognition,
            bloomLevel: BloomLevel.l1Remember,
          ),
          _exercise(
            id: 'l2',
            itemId: 'grammar:n5:001',
            type: ExerciseType.recall,
            bloomLevel: BloomLevel.l2Understand,
          ),
          _exercise(
            id: 'l3',
            itemId: 'grammar:n5:001',
            type: ExerciseType.production,
            bloomLevel: BloomLevel.l3Apply,
          ),
          _exercise(
            id: 'l4',
            itemId: 'grammar:n5:001',
            type: ExerciseType.readingComp,
            bloomLevel: BloomLevel.l4Analyze,
          ),
        ],
      );

      expect(
        await completeBank.hasBloomCoverage(itemId: 'grammar:n5:001'),
        isTrue,
      );

      final incompleteBank = GeneratedExerciseBank(
        exercises: [
          _exercise(
            id: 'l1',
            itemId: 'grammar:n5:001',
            type: ExerciseType.recognition,
            bloomLevel: BloomLevel.l1Remember,
          ),
        ],
      );

      expect(
        await incompleteBank.hasBloomCoverage(itemId: 'grammar:n5:001'),
        isFalse,
      );
    });
  });

  group('ExerciseValidator', () {
    test('rejects duplicate answer options', () {
      expect(
        () => ExerciseValidator.validate(
          _exercise(
            id: 'bad-options',
            itemId: 'grammar:n5:001',
            type: ExerciseType.recognition,
            bloomLevel: BloomLevel.l1Remember,
            options: const ['a', 'b', 'b', 'c'],
          ),
        ),
        throwsA(isA<ExerciseValidationException>()),
      );
    });

    test('rejects choices that omit the correct answer', () {
      expect(
        () => ExerciseValidator.validate(
          _exercise(
            id: 'missing-correct',
            itemId: 'grammar:n5:001',
            type: ExerciseType.recognition,
            bloomLevel: BloomLevel.l1Remember,
            correctAnswer: 'a',
            options: const ['b', 'c', 'd', 'e'],
          ),
        ),
        throwsA(isA<ExerciseValidationException>()),
      );
    });

    test('rejects choice prompts that literally contain the answer', () {
      expect(
        () => ExerciseValidator.validate(
          _exercise(
            id: 'literal-answer',
            itemId: 'grammar:n5:001',
            type: ExerciseType.recognition,
            bloomLevel: BloomLevel.l1Remember,
            correctAnswer: 'N + も',
            prompt: 'Mẫu nào có nghĩa là "N + も"?',
            options: const ['N + も', 'N + は', 'N + が', 'N + を'],
          ),
        ),
        throwsA(isA<ExerciseValidationException>()),
      );
    });

    test('rejects placeholder distractor labels', () {
      expect(
        () => ExerciseValidator.validate(
          _exercise(
            id: 'placeholder-option',
            itemId: 'grammar:n5:001',
            type: ExerciseType.recognition,
            bloomLevel: BloomLevel.l1Remember,
            correctAnswer: 'được phép',
            options: const [
              'được phép',
              'Phương án nhiễu 1',
              'bị cấm',
              'không cần',
            ],
          ),
        ),
        throwsA(isA<ExerciseValidationException>()),
      );
    });
  });
}

Exercise _exercise({
  required String id,
  required String itemId,
  required ExerciseType type,
  required BloomLevel bloomLevel,
  String correctAnswer = 'a',
  String? prompt,
  List<String> options = const ['a', 'b', 'c', 'd'],
}) {
  return Exercise(
    id: id,
    itemId: itemId,
    type: type,
    bloomLevel: bloomLevel,
    prompt: prompt ?? 'Prompt for $id',
    correctAnswer: correctAnswer,
    options: options,
    source: ExerciseSource.generated,
  );
}
