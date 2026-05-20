import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/db/database_provider.dart';
import 'package:jpstudy/features/foundations/models/han_viet_rule.dart';
import 'package:jpstudy/features/foundations/providers/foundations_providers.dart';
import 'package:jpstudy/features/foundations/screens/han_viet_reference_screen.dart';

const _testRuleSet = HanVietRuleSet(
  sources: [],
  rules: [
    HanVietRule(
      id: 'usage-kanji-compounds-often-use-on',
      category: 'usage',
      titleVi: 'Từ ghép Hán tự thường dùng âm On',
      titleEn: 'Kanji compounds → On-yomi',
      pattern:
          'Kanji compounds copied from Chinese roots often prefer on-yomi.',
      patternHv: 'từ ghép Hán tự',
      patternJp: 'on-yomi',
      descriptionVi: 'Cách dùng: dùng để đoán âm từ ghép Hán tự.',
      descriptionEn: 'Kanji compounds often prefer on-yomi.',
      confidence: 0.9,
      examples: [
        HanVietExample(
          kanji: '学生',
          onyomi: 'がくせい (gakusei)',
          hanViet: 'học sinh',
          meaningVi: 'học sinh',
        ),
      ],
      sourceIds: [],
    ),
    HanVietRule(
      id: 'initial-l-to-r',
      category: 'initial',
      titleVi: 'Phụ âm đầu L → R',
      titleEn: 'Initial L → R',
      pattern: 'Han-Viet initial L often maps to Japanese R row.',
      patternHv: 'L',
      patternJp: 'r',
      descriptionVi:
          'Phụ âm L trong Hán Việt thường tương ứng với hàng R trong tiếng Nhật.',
      descriptionEn: 'Han-Viet initial L often maps to Japanese R row.',
      confidence: 0.86,
      examples: [
        HanVietExample(
          kanji: '来',
          onyomi: 'ライ (rai)',
          hanViet: 'lai',
          meaningVi: 'đến',
        ),
      ],
      sourceIds: [],
    ),
    HanVietRule(
      id: 'final-t-to-tsu-chi',
      category: 'final',
      titleVi: 'Âm cuối -t → -tsu/-chi',
      titleEn: 'Final -t → -tsu/-chi',
      pattern: 'Han-Viet final -t often maps to -tsu or -chi.',
      patternHv: '-t',
      patternJp: '-tsu/-chi',
      descriptionVi: 'Âm cuối -t thường chuyển thành -tsu hoặc -chi.',
      descriptionEn: 'Han-Viet final -t often maps to -tsu or -chi.',
      confidence: 0.86,
      examples: [
        HanVietExample(
          kanji: '日',
          onyomi: 'にち/じつ (nichi/jitsu)',
          hanViet: 'nhật',
          meaningVi: 'ngày/mặt trời',
        ),
      ],
      sourceIds: [],
    ),
  ],
);

const _emptyRuleSetV2 = HanVietRuleSetV2(rules: []);

const _testRuleSetV2 = HanVietRuleSetV2(
  rules: [
    HanVietRuleV2(
      ruleId: 'rule_initial_h_k_gi_c_qu_to_k',
      legacyId: 'initial-c-k-kh-gi-h-qu-to-k',
      section: '1',
      category: 'initial',
      title: 'Âm đầu là H/K/Gi/C/Qu',
      consonants: ['H', 'K', 'Gi', 'C', 'Qu'],
      targetRow: 'K/G',
      targetKana: ['か', 'き', 'く', 'け', 'こ', 'が'],
      percentage: 90,
      explanation:
          "Phụ âm đầu Hán-Việt H/K/Gi/C/Qu thường chuyển sang hàng K/G trong On'yomi.",
      examples: [
        HanVietRuleExampleV2(
          hanViet: 'Học',
          kanji: '学',
          kanjiId: 1,
          assetKanjiId: 'n5_l01_k008',
          level: 'N5',
          onyomi: 'がく',
          romaji: 'gaku',
          compound: '学校',
          compoundKana: 'がっこう',
          compoundMeaning: 'trường học',
        ),
      ],
      practice: HanVietRulePractice(
        count: 1,
        questionTemplate: 'Âm Hán-Việt {hanViet} ({kanji}) -> On\'yomi nào?',
        status: 'ready',
        items: [
          HanVietRulePracticeItem(
            itemId: 'rule_initial_h_k_gi_c_qu_to_k_学',
            kanji: '学',
            kanjiId: 1,
            assetKanjiId: 'n5_l01_k008',
            hanViet: 'Học',
            correct: 'がく',
            options: ['がく', 'そう', 'とう', 'りょう'],
            explanation: 'Học bắt đầu bằng H, thường về hàng K/G.',
          ),
        ],
      ),
    ),
  ],
);

const _personalizedRuleSetV2 = HanVietRuleSetV2(
  rules: [
    HanVietRuleV2(
      ruleId: 'rule_initial_h_k_gi_c_qu_to_k',
      legacyId: 'initial-c-k-kh-gi-h-qu-to-k',
      section: '1',
      category: 'initial',
      title: 'Âm đầu là H/K/Gi/C/Qu',
      consonants: ['H', 'K', 'Gi', 'C', 'Qu'],
      targetRow: 'K/G',
      targetKana: ['か', 'き', 'く', 'け', 'こ', 'が'],
      percentage: 90,
      explanation:
          "Phụ âm đầu Hán-Việt H/K/Gi/C/Qu thường chuyển sang hàng K/G trong On'yomi.",
      examples: [
        HanVietRuleExampleV2(
          hanViet: 'Học',
          kanji: '学',
          kanjiId: 1,
          assetKanjiId: 'n5_l01_k008',
          level: 'N5',
          onyomi: 'がく',
          romaji: 'gaku',
          compound: '学校',
          compoundKana: 'がっこう',
          compoundMeaning: 'trường học',
        ),
      ],
      practice: HanVietRulePractice(
        count: 2,
        questionTemplate: 'Âm Hán-Việt {hanViet} ({kanji}) -> On\'yomi nào?',
        status: 'ready',
        items: [
          HanVietRulePracticeItem(
            itemId: 'rule_initial_h_k_gi_c_qu_to_k_学',
            kanji: '学',
            kanjiId: 1,
            assetKanjiId: 'n5_l01_k008',
            hanViet: 'Học',
            correct: 'がく',
            options: ['がく', 'きゅう', 'とう', 'りょう'],
            explanation: 'Học bắt đầu bằng H, thường về hàng K/G.',
          ),
          HanVietRulePracticeItem(
            itemId: 'rule_initial_h_k_gi_c_qu_to_k_旧',
            kanji: '旧',
            kanjiId: 2,
            assetKanjiId: 'n3_l01_k001',
            hanViet: 'Cựu',
            correct: 'きゅう',
            options: ['きゅう', 'がく', 'とう', 'りょう'],
            explanation: 'Cựu bắt đầu bằng C, thường về hàng K/G.',
          ),
        ],
      ),
    ),
  ],
);

Future<void> _pumpReference(
  WidgetTester tester,
  AppLanguage language,
  Key key,
) async {
  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: [
        appLanguageProvider.overrideWith(
          (ref) => AppLanguageController.test(language),
        ),
        hanVietRulesProvider.overrideWith((ref) async => _testRuleSet),
        hanVietRulesV2Provider.overrideWith((ref) async => _emptyRuleSetV2),
      ],
      child: MaterialApp(home: HanVietReferenceScreen(key: key)),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 10));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders, expands, and filters han viet rules', (tester) async {
    await _pumpReference(
      tester,
      AppLanguage.en,
      const ValueKey('han_viet_reference'),
    );

    expect(
      find.byKey(const ValueKey('han_viet_rule_list_count_3')),
      findsOneWidget,
    );
    expect(find.byType(ExpansionTile), findsWidgets);

    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Examples'), findsOneWidget);
    expect(find.text('学生'), findsOneWidget);
    expect(find.text('がくせい (gakusei)'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'final -t');
    await tester.pump(const Duration(milliseconds: 350));

    expect(
      find.byKey(const ValueKey('han_viet_rule_list_count_3')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('han_viet_rule_list_count_1')),
      findsOneWidget,
    );
    expect(find.byType(ExpansionTile), findsWidgets);

    tester.testTextInput.hide();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('renders localized Vietnamese rule titles and examples', (
    tester,
  ) async {
    await _pumpReference(
      tester,
      AppLanguage.vi,
      const ValueKey('han_viet_reference_vi'),
    );

    expect(find.text('Tất cả'), findsOneWidget);
    expect(find.text('Cách dùng'), findsOneWidget);
    expect(find.text('Phụ âm đầu'), findsOneWidget);
    expect(find.text('Phụ âm đầu L → R'), findsOneWidget);
    expect(find.textContaining('Han-Viet initial L'), findsNothing);

    await tester.tap(find.text('Phụ âm đầu L → R'));
    await tester.pumpAndSettle();

    expect(find.text('Ví dụ'), findsWidgets);
    expect(find.text('来'), findsOneWidget);
    expect(find.text('lai'), findsOneWidget);
    expect(find.text('ライ (rai)'), findsOneWidget);
    expect(find.text('đến'), findsOneWidget);
    expect(find.textContaining('hàng R'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('han_viet_example_来')));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Đóng'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('search matches localized titles and example readings', (
    tester,
  ) async {
    await _pumpReference(
      tester,
      AppLanguage.vi,
      const ValueKey('han_viet_reference_search'),
    );

    await tester.enterText(find.byType(EditableText), 'lai');
    await tester.pump(const Duration(milliseconds: 350));

    expect(
      find.byKey(const ValueKey('han_viet_rule_list_count_3')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('han_viet_rule_list_count_1')),
      findsOneWidget,
    );
    expect(find.text('Phụ âm đầu L → R'), findsOneWidget);
  });

  testWidgets('renders v2 rule card and inline practice feedback', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [
          appLanguageProvider.overrideWith(
            (ref) => AppLanguageController.test(AppLanguage.vi),
          ),
          hanVietRulesProvider.overrideWith((ref) async => _testRuleSet),
          hanVietRulesV2Provider.overrideWith((ref) async => _testRuleSetV2),
        ],
        child: const MaterialApp(home: HanVietReferenceScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));

    expect(
      find.byKey(
        const ValueKey('han_viet_rule_card_rule_initial_h_k_gi_c_qu_to_k'),
      ),
      findsOneWidget,
    );
    expect(find.text('1. Âm đầu là H/K/Gi/C/Qu'), findsOneWidget);
    expect(find.textContaining('hàng K/G'), findsWidgets);
    expect(find.text('Ví dụ:'), findsOneWidget);
    expect(find.textContaining('Học -> 学 (がく)'), findsOneWidget);
    expect(find.text('Bài tập áp dụng'), findsOneWidget);
    expect(find.text("Âm Hán-Việt Học (学) -> On'yomi nào?"), findsOneWidget);

    await tester.tap(find.text('がく'));
    await tester.pumpAndSettle();

    expect(find.text('Đúng'), findsOneWidget);
    expect(find.textContaining('thường về hàng K/G'), findsOneWidget);
    expect(find.text('Đã hiểu rule'), findsOneWidget);
  });

  testWidgets('passing v2 practice records rule and kanji SRS', (tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [
          appLanguageProvider.overrideWith(
            (ref) => AppLanguageController.test(AppLanguage.vi),
          ),
          databaseProvider.overrideWithValue(db),
          hanVietRulesProvider.overrideWith((ref) async => _testRuleSet),
          hanVietRulesV2Provider.overrideWith((ref) async => _testRuleSetV2),
        ],
        child: const MaterialApp(home: HanVietReferenceScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));

    await tester.tap(find.text('がく'));
    await tester.pumpAndSettle();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );

    final ruleState = await db.hanVietRuleSrsDao.getSrsState(
      'rule_initial_h_k_gi_c_qu_to_k',
    );
    final kanjiState = await db.kanjiSrsDao.getSrsState(1);

    expect(ruleState, isNotNull);
    expect(ruleState!.lastConfidence, 3);
    expect(kanjiState, isNotNull);
    expect(kanjiState!.lastConfidence, 3);
  });

  testWidgets('v2 practice prioritizes kanji already active in SRS', (
    tester,
  ) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(db.close);
    await db.kanjiSrsDao.initializeSrsState(2);

    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [
          appLanguageProvider.overrideWith(
            (ref) => AppLanguageController.test(AppLanguage.vi),
          ),
          databaseProvider.overrideWithValue(db),
          hanVietRulesProvider.overrideWith((ref) async => _testRuleSet),
          hanVietRulesV2Provider.overrideWith(
            (ref) async => _personalizedRuleSetV2,
          ),
        ],
        child: const MaterialApp(home: HanVietReferenceScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    final dueQuestion = find.text("Âm Hán-Việt Cựu (旧) -> On'yomi nào?");
    final newQuestion = find.text("Âm Hán-Việt Học (学) -> On'yomi nào?");

    expect(dueQuestion, findsOneWidget);
    expect(newQuestion, findsOneWidget);
    expect(
      tester.getTopLeft(dueQuestion).dy,
      lessThan(tester.getTopLeft(newQuestion).dy),
    );
  });
}
