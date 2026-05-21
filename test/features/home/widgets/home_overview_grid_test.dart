import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/features/home/providers/continue_provider.dart';
import 'package:jpstudy/features/home/providers/dashboard_provider.dart';
import 'package:jpstudy/features/home/widgets/home_overview_grid.dart';

void main() {
  const dashboard = DashboardState(
    streak: 5,
    todayXp: 18,
    vocabDue: 3,
    grammarDue: 2,
    kanjiDue: 1,
    vocabMistakeCount: 0,
    grammarMistakeCount: 1,
    kanjiMistakeCount: 0,
    totalMistakeCount: 1,
  );
  const action = ContinueAction(
    type: ContinueActionType.vocabReview,
    label: 'Review vocab',
    count: 3,
  );

  testWidgets('renders the four phase 6 home widgets', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeOverviewGrid(
            language: AppLanguage.en,
            level: StudyLevel.n5,
            dashboard: dashboard,
            continueAction: action,
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('home_today_plan_widget')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('home_level_progress_widget')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('home_streak_widget')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('home_last_context_widget')),
      findsOneWidget,
    );
  });

  testWidgets('uses one column on mobile and four on desktop', (tester) async {
    Future<int> columnsFor(double width) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox.expand(
              child: HomeOverviewGrid(
                language: AppLanguage.en,
                level: StudyLevel.n5,
                dashboard: dashboard,
                continueAction: action,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final grid = tester.widget<GridView>(
        find.byKey(const ValueKey('home_overview_grid')),
      );
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      return delegate.crossAxisCount;
    }

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    expect(await columnsFor(390), 1);
    expect(await columnsFor(1280), 4);
  });
}
