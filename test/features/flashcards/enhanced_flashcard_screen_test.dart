import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/models/vocab_item.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/flashcards/screens/enhanced_flashcard_screen.dart';
import 'package:jpstudy/features/flashcards/widgets/enhanced_flashcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLesson = 'Lesson 1';

VocabItem _item(
  int id,
  String term,
  String meaning, {
  List<VocabExampleSentence> examples = const [],
}) => VocabItem(
  id: id,
  term: term,
  meaning: meaning,
  meaningEn: meaning,
  exampleSentences: examples,
  level: 'N5',
);

Widget buildFlashcardScreen(List<VocabItem> items) {
  return ProviderScope(
    overrides: [
      appLanguageProvider.overrideWith(
        (ref) => AppLanguageController.test(AppLanguage.en),
      ),
      // srsStateProvider returns null SRS (new card) for every id
      for (final item in items)
        srsStateProvider(item.id).overrideWith((ref) async => null),
    ],
    child: MaterialApp(
      home: EnhancedFlashcardScreen(
        items: items,
        lessonId: 1,
        lessonTitle: _kLesson,
      ),
    ),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows lesson title in AppBar', (tester) async {
    final items = [_item(1, '食べる', 'to eat')];
    await tester.pumpWidget(buildFlashcardScreen(items));
    await tester.pump();
    expect(find.text(_kLesson), findsOneWidget);
  });

  testWidgets('shows settings icon in AppBar', (tester) async {
    final items = [_item(1, '食べる', 'to eat')];
    await tester.pumpWidget(buildFlashcardScreen(items));
    await tester.pump();
    expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
  });

  testWidgets('shows first flashcard term', (tester) async {
    final items = [_item(1, '食べる', 'to eat'), _item(2, '飲む', 'to drink')];
    await tester.pumpWidget(buildFlashcardScreen(items));
    await tester.pumpAndSettle();
    expect(find.text('食べる'), findsOneWidget);
  });

  testWidgets('front side exposes TTS audio even when audioUrl is empty', (
    tester,
  ) async {
    final items = [_item(1, '学校', 'school')];
    await tester.pumpWidget(buildFlashcardScreen(items));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Play Japanese audio'), findsOneWidget);
    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
  });

  testWidgets('shows progress bar', (tester) async {
    final items = [_item(1, '食べる', 'to eat'), _item(2, '飲む', 'to drink')];
    await tester.pumpWidget(buildFlashcardScreen(items));
    await tester.pump();
    // LinearProgressIndicator represents the card progress
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('back side renders example sentences with JP/VI toggle', (
    tester,
  ) async {
    final items = [
      _item(
        1,
        '学生',
        'student',
        examples: const [
          VocabExampleSentence(
            exampleId: 'ex-001',
            ja: '私は学生です。',
            vi: 'Tôi là học sinh.',
            audioUrl: 'https://example.com/audio.mp3',
            source: 'original-jpstudy',
          ),
        ],
      ),
    ];
    await tester.pumpWidget(buildFlashcardScreen(items));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(EnhancedFlashcard));
    await tester.pumpAndSettle();

    expect(find.text('私は学生です。'), findsOneWidget);
    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('flashcard_example_lang_toggle')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tôi là học sinh.'), findsOneWidget);
  });

  testWidgets('mobile swipe gestures move between flashcards', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final items = [_item(1, '食べる', 'to eat'), _item(2, '飲む', 'to drink')];
    await tester.pumpWidget(buildFlashcardScreen(items));
    await tester.pumpAndSettle();

    await tester.drag(
      find.byType(EnhancedFlashcardScreen),
      const Offset(-320, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('飲む'), findsOneWidget);

    await tester.drag(
      find.byType(EnhancedFlashcardScreen),
      const Offset(320, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('食べる'), findsOneWidget);
  });

  testWidgets('mobile vertical swipe gestures move between flashcards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final items = [_item(1, '食べる', 'to eat'), _item(2, '飲む', 'to drink')];
    await tester.pumpWidget(buildFlashcardScreen(items));
    await tester.pumpAndSettle();

    await tester.drag(
      find.byType(EnhancedFlashcardScreen),
      const Offset(0, -320),
    );
    await tester.pumpAndSettle();
    expect(find.text('飲む'), findsOneWidget);

    await tester.drag(
      find.byType(EnhancedFlashcardScreen),
      const Offset(0, 320),
    );
    await tester.pumpAndSettle();
    expect(find.text('食べる'), findsOneWidget);
  });

  testWidgets('long press marks current flashcard for practice', (
    tester,
  ) async {
    final items = [_item(1, '食べる', 'to eat'), _item(2, '飲む', 'to drink')];
    await tester.pumpWidget(buildFlashcardScreen(items));
    await tester.pumpAndSettle();

    await tester.longPress(find.byType(EnhancedFlashcardScreen));
    await tester.pumpAndSettle();

    expect(find.text('Need Practice'), findsOneWidget);
    expect(find.text('飲む'), findsOneWidget);
  });

  testWidgets('mobile flashcard uses compact header and edge-to-edge card', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final items = [_item(1, '食べる', 'to eat')];
    await tester.pumpWidget(buildFlashcardScreen(items));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.settings_rounded), findsNothing);
    expect(tester.getTopLeft(find.byType(EnhancedFlashcard)).dx, 0);
  });

  testWidgets('mobile flashcard uses fullscreen gesture surface', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final items = [_item(1, '食べる', 'to eat'), _item(2, '飲む', 'to drink')];
    await tester.pumpWidget(buildFlashcardScreen(items));
    await tester.pumpAndSettle();

    expect(find.text('Previous'), findsNothing);
    expect(find.text('Next'), findsNothing);
    expect(
      tester.getSize(find.byType(EnhancedFlashcard)).height,
      greaterThan(700),
    );
  });
}
