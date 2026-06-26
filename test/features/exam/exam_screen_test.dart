import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/services/session_storage.dart';
import 'package:jpstudy/core/services/session_storage_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/models/vocab_item.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/exam/exam_screen.dart';
import 'package:jpstudy/features/test/screens/test_config_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeLessonRepository extends LessonRepository {
  _FakeLessonRepository({
    required this.items,
    this.throwOnFetch = false,
    this.delay = Duration.zero,
  }) : super(
         AppDatabase(executor: NativeDatabase.memory()),
         ContentDatabase(executor: NativeDatabase.memory()),
       );

  final List<VocabItem> items;
  final bool throwOnFetch;
  final Duration delay;

  @override
  Future<List<VocabItem>> getVocabByLevel(String level) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (throwOnFetch) {
      throw Exception('boom');
    }
    return items;
  }
}

class _FakeSessionStorage extends SessionStorage {
  @override
  Future<TestSessionSnapshot?> loadTestSession(String sessionKey) async => null;
}

const _sampleItem = VocabItem(
  id: 1,
  term: '猫',
  reading: 'ねこ',
  meaning: 'mèo',
  meaningEn: 'cat',
  level: 'N5',
);

Widget buildExamScreen({
  LessonRepository? repo,
  SessionStorage? storage,
  StudyLevel? level,
}) {
  return ProviderScope(
    overrides: [
      appLanguageProvider.overrideWith(
        (ref) => AppLanguageController.test(AppLanguage.en),
      ),
      if (level != null) studyLevelProvider.overrideWith((ref) => level),
      if (repo != null) lessonRepositoryProvider.overrideWithValue(repo),
      if (storage != null) sessionStorageProvider.overrideWithValue(storage),
    ],
    child: const MaterialApp(home: ExamScreen()),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows AppBar title "Mock Exam"', (tester) async {
    await tester.pumpWidget(buildExamScreen());
    await tester.pump();
    expect(find.text('Mock Exam'), findsWidgets);
  });

  testWidgets('shows N5 and N4 level cards', (tester) async {
    await tester.pumpWidget(buildExamScreen());
    await tester.pump();

    expect(find.text('JLPT N5'), findsOneWidget);
    expect(find.text('JLPT N4'), findsOneWidget);
  });

  testWidgets('surfaces the current selected level in exam choices', (
    tester,
  ) async {
    await tester.pumpWidget(buildExamScreen(level: StudyLevel.n2));
    await tester.pump();

    expect(find.text('N2'), findsOneWidget);
    expect(find.text('JLPT N2'), findsOneWidget);
  });

  testWidgets('shows level subtitles with JLPT metadata', (tester) async {
    await tester.pumpWidget(buildExamScreen());
    await tester.pump();

    expect(
      find.text('90 min · 95 questions · vocabulary, reading, listening'),
      findsOneWidget,
    );
    expect(
      find.text(
        '115 min · 105 questions · vocabulary, grammar, reading, listening',
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows "Choose level" section header', (tester) async {
    await tester.pumpWidget(buildExamScreen());
    await tester.pump();

    expect(find.text('Choose level'), findsOneWidget);
  });

  testWidgets('shows empty start panel when selected level has no terms', (
    tester,
  ) async {
    final repo = _FakeLessonRepository(items: const []);

    await tester.pumpWidget(buildExamScreen(repo: repo));
    await tester.pump();

    await tester.tap(find.text('JLPT N5'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('No N5 exam questions yet'), findsOneWidget);
    expect(find.byType(TestConfigScreen), findsNothing);
  });

  testWidgets('shows load error panel when repository throws', (tester) async {
    final repo = _FakeLessonRepository(items: const [], throwOnFetch: true);

    await tester.pumpWidget(buildExamScreen(repo: repo));
    await tester.pump();

    await tester.tap(find.text('JLPT N5'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Could not prepare JLPT N5'), findsOneWidget);
    expect(find.text(AppLanguage.en.loadErrorLabel), findsOneWidget);
  });

  testWidgets('renders start screen then opens TestConfigScreen', (
    tester,
  ) async {
    final repo = _FakeLessonRepository(items: const [_sampleItem]);
    final storage = _FakeSessionStorage();

    await tester.pumpWidget(buildExamScreen(repo: repo, storage: storage));
    await tester.pump();

    await tester.tap(find.text('JLPT N5'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('JLPT N5 start screen'), findsOneWidget);
    expect(find.text(AppLanguage.en.questionsCountLabel(1)), findsWidgets);
    expect(find.byType(TestConfigScreen), findsNothing);

    await tester.drag(find.byType(ListView), const Offset(0, -260));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start exam'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(TestConfigScreen), findsOneWidget);
    expect(
      find.textContaining(AppLanguage.en.mockExamTitle('N5')),
      findsWidgets,
    );
  });

  testWidgets('keeps loading instead of emptying while first seed is slow', (
    tester,
  ) async {
    final repo = _FakeLessonRepository(
      items: const [_sampleItem],
      delay: const Duration(seconds: 9),
    );
    final storage = _FakeSessionStorage();

    await tester.pumpWidget(buildExamScreen(repo: repo, storage: storage));
    await tester.pump();

    await tester.tap(find.text('JLPT N5'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 8));

    expect(find.text('Preparing JLPT N5 questions...'), findsOneWidget);
    expect(find.text('No N5 exam questions yet'), findsNothing);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('JLPT N5 start screen'), findsOneWidget);
    expect(find.text('Start exam'), findsOneWidget);
  });

  testWidgets('all JLPT level choices prepare a nonblank start state', (
    tester,
  ) async {
    final repo = _FakeLessonRepository(items: const [_sampleItem]);
    final storage = _FakeSessionStorage();

    await tester.pumpWidget(buildExamScreen(repo: repo, storage: storage));
    await tester.pump();

    for (final level in ['N5', 'N4', 'N3', 'N2', 'N1']) {
      await tester.scrollUntilVisible(
        find.text('JLPT $level'),
        -220,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('JLPT $level'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('JLPT $level start screen'), findsOneWidget);
    }
  });
}
