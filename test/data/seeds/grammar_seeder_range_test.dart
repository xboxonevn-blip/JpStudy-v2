import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/data/seeds/grammar_seeder.dart';

void main() {
  test('upper JLPT grammar seeding covers Shin Kanzen lesson manifests', () {
    expect(GrammarSeeder.lessonRangeForLevel('N3'), (start: 1, end: 83));
    expect(GrammarSeeder.lessonRangeForLevel('N2'), (start: 1, end: 163));
    expect(GrammarSeeder.lessonRangeForLevel('N1'), (start: 1, end: 88));
  });

  test('upper JLPT deterministic grammar ids stay level-scoped', () {
    expect(
      GrammarSeeder.deterministicGrammarPointIdFor(
        level: 'N3',
        lessonId: 83,
        itemIndex: 4,
      ),
      3008304,
    );
    expect(
      GrammarSeeder.deterministicGrammarPointIdFor(
        level: 'N2',
        lessonId: 163,
        itemIndex: 4,
      ),
      2016304,
    );
    expect(
      GrammarSeeder.deterministicGrammarPointIdFor(
        level: 'N1',
        lessonId: 88,
        itemIndex: 4,
      ),
      1008804,
    );
  });
}
