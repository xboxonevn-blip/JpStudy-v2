import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/srs/cross_modal_srs.dart';

void main() {
  test('migrates legacy SRS state into flashcard mode without data loss', () {
    final next = DateTime(2026, 5, 21, 8);
    final last = DateTime(2026, 5, 20, 8);
    final migrated = const CrossModalSrsMigrator().migrateLegacy([
      LegacySrsSnapshot(
        itemType: 'vocab',
        itemId: '42',
        repetitions: 3,
        stability: 4.5,
        difficulty: 6.25,
        fsrsState: 2,
        fsrsStep: null,
        lastConfidence: 3,
        lastReviewedAt: last,
        nextReviewAt: next,
      ),
    ]);

    expect(migrated, hasLength(1));
    final flashcard = migrated.single.modes[ExerciseMode.flashcard]!;
    expect(flashcard.itemType, 'vocab');
    expect(flashcard.itemId, '42');
    expect(flashcard.repetitions, 3);
    expect(flashcard.stability, 4.5);
    expect(flashcard.difficulty, 6.25);
    expect(flashcard.fsrsState, 2);
    expect(flashcard.fsrsStep, isNull);
    expect(flashcard.lastConfidence, 3);
    expect(flashcard.lastReviewedAt, last);
    expect(flashcard.nextReviewAt, next);
  });

  test('markKnown is blocked for self-attestation removal', () {
    expect(
      () => const SrsStore().markKnown('vocab:42'),
      throwsA(isA<UnsupportedError>()),
    );
  });
}
