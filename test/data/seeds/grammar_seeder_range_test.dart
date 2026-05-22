import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/data/seeds/grammar_seeder.dart';

void main() {
  test('upper JLPT grammar seeding covers Shin Kanzen lesson manifests', () {
    expect(GrammarSeeder.lessonRangeForLevel('N3'), (start: 1, end: 83));
    expect(GrammarSeeder.lessonRangeForLevel('N2'), (start: 1, end: 163));
    expect(GrammarSeeder.lessonRangeForLevel('N1'), (start: 1, end: 88));
  });
}
