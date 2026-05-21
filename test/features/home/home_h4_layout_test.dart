import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/shared_preferences_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/db/database_provider.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/foundations/providers/foundations_providers.dart';
import 'package:jpstudy/features/grammar/grammar_providers.dart';
import 'package:jpstudy/features/home/providers/backup_status_provider.dart';
import 'package:jpstudy/features/home/providers/continue_provider.dart';
import 'package:jpstudy/features/home/providers/dashboard_provider.dart';
import 'package:jpstudy/features/home/providers/daily_session_progress_provider.dart';
import 'package:jpstudy/features/home/providers/recovery_pack_provider.dart';
import 'package:jpstudy/features/home/providers/weakness_radar_provider.dart';
import 'package:jpstudy/features/home/screens/learning_path_screen.dart';
import 'package:jpstudy/features/me/providers/app_settings_controller.dart';
import 'package:jpstudy/features/me/providers/data_settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _dashboard = DashboardState(
  streak: 6,
  todayXp: 24,
  vocabDue: 8,
  grammarDue: 5,
  kanjiDue: 3,
  conjugationDue: 2,
  vocabMistakeCount: 1,
  grammarMistakeCount: 2,
  kanjiMistakeCount: 0,
  totalMistakeCount: 3,
);

class _PartialFoundationsProgressController
    extends FoundationsProgressController {
  @override
  FoundationsProgress build() => const FoundationsProgress(studied: {'あ', 'ア'});
}

void main() {
  late AppDatabase appDb;
  late ContentDatabase contentDb;
  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    appDb = AppDatabase(executor: NativeDatabase.memory());
    contentDb = ContentDatabase(executor: NativeDatabase.memory());
  });

  tearDown(() async {
    await contentDb.close();
    await appDb.close();
  });

  Widget buildScreen() {
    final repo = LessonRepository(appDb, contentDb);
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        appLanguageProvider.overrideWith(
          (ref) => AppLanguageController.test(AppLanguage.vi),
        ),
        studyLevelProvider.overrideWith((ref) => StudyLevel.n5),
        databaseProvider.overrideWithValue(appDb),
        lessonRepositoryProvider.overrideWithValue(repo),
        dashboardProvider.overrideWith((ref) => Stream.value(_dashboard)),
        continueActionProvider.overrideWith(
          (ref) async => const ContinueAction(
            type: ContinueActionType.grammarReview,
            label: 'Ôn ngữ pháp',
            count: 5,
            data: <int>[1, 2, 3],
          ),
        ),
        grammarGhostCountProvider.overrideWith((ref) async* {
          yield 0;
        }),
        weaknessRadarProvider.overrideWith(
          (ref) async => <WeaknessRadarItem>[],
        ),
        recoveryPackProvider.overrideWith((ref) async => null),
        dailySessionProgressProvider.overrideWith(
          (ref) async => DailySessionProgress.empty('2026-05-21'),
        ),
        backupStatusProvider.overrideWith(
          (ref) async => const BackupStatus(enabled: false, lastBackupAt: null),
        ),
        foundationsProgressProvider.overrideWith(
          () => _PartialFoundationsProgressController(),
        ),
        appSettingsControllerProvider.overrideWith(
          () => AppSettingsController(),
        ),
        dataSettingsControllerProvider.overrideWith(
          () => DataSettingsController(),
        ),
      ],
      child: const MaterialApp(home: LearningPathScreen()),
    );
  }

  Future<void> pumpHome(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildScreen());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
  }

  Future<void> cleanUp(WidgetTester tester) async {
    await tester.pumpWidget(Container());
    for (var i = 0; i < 5; i++) {
      await tester.pump(Duration.zero);
    }
  }

  test('uses H.4 adaptive max-width tiers', () {
    expect(homeAdaptiveMaxWidthForTesting(1024), 1040);
    expect(homeAdaptiveMaxWidthForTesting(1280), 1280);
    expect(homeAdaptiveMaxWidthForTesting(1440), 1440);
    expect(homeAdaptiveMaxWidthForTesting(1600), 1600);
    expect(homeAdaptiveMaxWidthForTesting(1920), 1600);
  });

  testWidgets('desktop renders H.4 home sections', (tester) async {
    await pumpHome(tester, const Size(1600, 1100));

    expect(
      find.byKey(const ValueKey('home_featured_this_week')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('home_top_split')), findsOneWidget);
    expect(find.byKey(const ValueKey('home_foundations_pane')), findsOneWidget);
    expect(find.byKey(const ValueKey('home_dojo_today_pane')), findsOneWidget);
    expect(find.byKey(const ValueKey('home_sidebar')), findsOneWidget);
    expect(find.byKey(const ValueKey('home_recent_activity')), findsOneWidget);

    expect(find.text('Nền tảng'), findsWidgets);
    expect(find.text('Dojo hôm nay'), findsWidgets);
    expect(find.text('Nổi bật tuần này'), findsOneWidget);
    expect(find.text('Hoạt động gần đây'), findsOneWidget);

    await cleanUp(tester);
  });

  testWidgets('sidebar can collapse without removing due signal', (
    tester,
  ) async {
    await pumpHome(tester, const Size(1600, 1100));

    await tester.tap(find.byKey(const ValueKey('home_sidebar_toggle')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('home_sidebar_collapsed')),
      findsOneWidget,
    );
    expect(find.textContaining('18'), findsWidgets);

    await cleanUp(tester);
  });
}
