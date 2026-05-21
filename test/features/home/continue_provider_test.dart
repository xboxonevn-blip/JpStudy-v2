import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/features/home/providers/continue_provider.dart';

void main() {
  test('upper JLPT next lesson label uses Shin Kanzen source title', () {
    expect(
      continueLessonLabelForTesting(AppLanguage.vi, StudyLevel.n2, 200001),
      'Shin Kanzen N2 Bài 1',
    );
  });

  test('Minna next lesson labels hide internal storage ids', () {
    expect(
      continueLessonLabelForTesting(AppLanguage.vi, StudyLevel.n5, 1),
      'Minna no Nihongo I — Bài 1',
    );
    expect(
      continueLessonLabelForTesting(AppLanguage.vi, StudyLevel.n4, 26),
      'Minna no Nihongo II — Bài 1',
    );

    final leaked = continueLessonLabelForTesting(
      AppLanguage.vi,
      StudyLevel.n5,
      -905014,
    );
    expect(leaked, 'Minna no Nihongo I — Bài 1');
    expect(leaked, isNot(contains('905014')));
  });
}
