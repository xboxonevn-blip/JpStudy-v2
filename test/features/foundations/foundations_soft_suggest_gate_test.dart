import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/features/foundations/widgets/foundations_soft_suggest_gate.dart';

void main() {
  test('foundations soft suggest is limited to N5 learners', () {
    expect(shouldSuggestFoundationsForLevel(null), isTrue);
    expect(shouldSuggestFoundationsForLevel(StudyLevel.n5), isTrue);

    expect(shouldSuggestFoundationsForLevel(StudyLevel.n4), isFalse);
    expect(shouldSuggestFoundationsForLevel(StudyLevel.n3), isFalse);
    expect(shouldSuggestFoundationsForLevel(StudyLevel.n2), isFalse);
    expect(shouldSuggestFoundationsForLevel(StudyLevel.n1), isFalse);
  });

  test(
    'foundations soft suggest visibility is gated by progress and dismissal',
    () {
      expect(
        shouldShowFoundationsSoftSuggest(
          level: StudyLevel.n5,
          percentComplete: 0.0,
          dismissed: false,
        ),
        isTrue,
      );
      expect(
        shouldShowFoundationsSoftSuggest(
          level: StudyLevel.n4,
          percentComplete: 0.0,
          dismissed: false,
        ),
        isFalse,
      );
      expect(
        shouldShowFoundationsSoftSuggest(
          level: StudyLevel.n5,
          percentComplete: 0.31,
          dismissed: false,
        ),
        isFalse,
      );
      expect(
        shouldShowFoundationsSoftSuggest(
          level: StudyLevel.n5,
          percentComplete: 0.0,
          dismissed: true,
        ),
        isFalse,
      );
    },
  );

  test('foundations soft suggest is non-blocking, not a modal dialog', () {
    final source = File(
      'lib/features/foundations/widgets/foundations_soft_suggest_gate.dart',
    ).readAsStringSync();

    expect(source, isNot(contains('showDialog')));
    expect(source, isNot(contains('AlertDialog')));
  });
}
