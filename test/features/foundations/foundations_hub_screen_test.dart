import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/db/database_provider.dart';
import 'package:jpstudy/features/foundations/screens/foundations_hub_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Vietnamese hub uses learner-facing module copy', (tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          appLanguageProvider.overrideWith(
            (ref) => AppLanguageController.test(AppLanguage.vi),
          ),
        ],
        child: const MaterialApp(home: FoundationsHubScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Open'), findsNothing);
    expect(find.textContaining('yoon'), findsNothing);
    expect(find.textContaining('rules'), findsNothing);
    expect(find.text('Mở luyện tập'), findsWidgets);
    expect(find.text('66 âm ghép'), findsOneWidget);
    expect(find.text('32 quy tắc'), findsOneWidget);
  });
}
