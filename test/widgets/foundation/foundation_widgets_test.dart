import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/features/common/widgets/compact_ui.dart';
import 'package:jpstudy/theme/app_theme.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light(),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('foundation primitives render expected content and callbacks', (
    tester,
  ) async {
    var tapped = 0;
    await tester.pumpWidget(
      _wrap(
        AppSection(
          title: 'Section',
          caption: 'Caption',
          actionLabel: 'Open',
          onActionTap: () => tapped++,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppCard(onTap: () => tapped++, child: const Text('Card')),
              AppButton(
                label: 'Primary',
                icon: Icons.check_rounded,
                onPressed: () => tapped++,
              ),
              const AppChip(label: 'Chip', tone: AppChipTone.success),
              const AppBadge(label: 'N3', level: 'N3'),
              const AppIcon(icon: Icons.school_rounded, label: 'Study'),
              const AppDivider(),
              AppEmptyState(
                icon: Icons.search_off_rounded,
                title: 'No results',
                message: 'Try another query.',
                actionLabel: 'Reset',
                onActionTap: () => tapped++,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Section'), findsOneWidget);
    expect(find.text('Caption'), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
    expect(find.text('Primary'), findsOneWidget);
    expect(find.text('Chip'), findsOneWidget);
    expect(find.text('N3'), findsOneWidget);
    expect(find.byIcon(Icons.school_rounded), findsOneWidget);
    expect(find.text('No results'), findsOneWidget);

    await tester.tap(find.text('Open'));
    await tester.tap(find.text('Card'));
    await tester.tap(find.text('Primary'));
    await tester.tap(find.text('Reset'));
    expect(tapped, 4);
  });

  testWidgets('compact UI wrappers delegate repeated visuals to foundation', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AppFeatureCard(
          icon: Icons.menu_book_rounded,
          title: 'Feature',
          subtitle: 'Shared surface',
          status: const AppStatusChip(label: 'Live'),
          primaryLabel: 'Start',
          onPrimaryTap: () {},
        ),
      ),
    );

    expect(find.byType(AppCard), findsAtLeastNWidgets(1));
    expect(find.byType(AppChip), findsOneWidget);
    expect(find.byType(AppButton), findsOneWidget);
    expect(find.byType(AppIcon), findsOneWidget);
  });
}
