import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/features/home/weakness_radar_copy.dart';

void main() {
  test('weakness radar Japanese copy no longer falls back to English', () {
    expect(
      weaknessRecoveryTitle(AppLanguage.ja, 'Lesson 5'),
      'Lesson 5 からのリカバリーパック',
    );
    expect(weaknessVocabTitle(AppLanguage.ja, '水'), '語彙が不安定: 水');
    expect(weaknessRetentionTitle(AppLanguage.ja), '新しいカードがまだ不安定です');
  });

  test('weakness due subtitle is localized in Japanese', () {
    expect(
      weaknessDueSubtitle(
        AppLanguage.ja,
        vocabDue: 4,
        grammarDue: 2,
        kanjiDue: 1,
        nextGrammarReview: DateTime(2026, 3, 31),
      ),
      '語彙 4件、文法 2件、漢字 1件が期限です。 文法レビューもまもなく戻ってきます。',
    );
  });

  test('new checkpoint label is localized in Japanese', () {
    expect(
      weaknessDueCheckpointShortLabel(AppLanguage.ja, const Duration(hours: 3)),
      '新規',
    );
  });

  test('Vietnamese checkpoint labels are learner-facing', () {
    final labels = [
      weaknessDueCheckpointShortLabel(
        AppLanguage.vi,
        const Duration(hours: 48),
      ),
      weaknessDueCheckpointShortLabel(
        AppLanguage.vi,
        const Duration(hours: 96),
      ),
      weaknessDueCheckpointShortLabel(AppLanguage.vi, const Duration(days: 8)),
    ];

    expect(labels.join(' '), isNot(contains('D1')));
    expect(labels.join(' '), isNot(contains('D3')));
    expect(labels.join(' '), isNot(contains('D7')));
    expect(labels, ['1 ngày', '3 ngày', '7 ngày']);
  });
}
