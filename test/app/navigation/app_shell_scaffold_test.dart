import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/app/navigation/app_shell_scaffold.dart';
import 'package:jpstudy/core/study_level.dart';

void main() {
  test('desktop sidebar destinations expose button semantics labels', () {
    final source = File(
      'lib/app/navigation/app_shell_scaffold.dart',
    ).readAsStringSync();

    expect(source, contains('return Semantics('));
    expect(source, contains('label: item.label'));
    expect(source, contains('button: true'));
    expect(source, contains('selected: selected'));
    expect(source, contains('ExcludeSemantics('));
  });

  test('N5 shell destinations expose overflow through More', () {
    expect(visibleShellBranchIndicesForLevel(StudyLevel.n5), [0, 1, 2, 3, 4]);
    expect(bottomShellBranchIndicesForLevel(StudyLevel.n5), [0, 1, 2, 3]);
  });

  test('N4+ shell destinations expose overflow through More', () {
    for (final level in [
      StudyLevel.n4,
      StudyLevel.n3,
      StudyLevel.n2,
      StudyLevel.n1,
    ]) {
      final visible = visibleShellBranchIndicesForLevel(level);
      expect(visible, [0, 1, 2, 3, 4]);
      expect(bottomShellBranchIndicesForLevel(level), [0, 1, 2, 3]);
    }
  });

  test(
    'desktop shell destinations are grouped without product-sprawl branches',
    () {
      expect(navigationGroupForShellBranch(0), NavigationGroup.learning);
      expect(navigationGroupForShellBranch(1), NavigationGroup.learning);
      expect(navigationGroupForShellBranch(2), NavigationGroup.progress);
      expect(navigationGroupForShellBranch(3), NavigationGroup.other);
      expect(navigationGroupForShellBranch(4), NavigationGroup.other);
    },
  );

  test('desktop sidebar exposes compact dimensions for grouped layout', () {
    expect(sidebarItemHeightForTesting, 44);
    expect(sidebarFooterItemHeightForTesting, 36);
    expect(sidebarEstimatedContentHeightForTesting, lessThan(600));
  });

  test('shell branch tap uses deterministic URL navigation', () {
    final source = File(
      'lib/app/navigation/app_shell_scaffold.dart',
    ).readAsStringSync();
    final goToBranchBody = RegExp(
      r'void _goToBranch[\s\S]*?\n  \}',
    ).firstMatch(source)!.group(0)!;

    expect(goToBranchBody, contains('_dismissActiveOverlay(context)'));
    expect(goToBranchBody, contains('GoRouter.of(context).go'));
    expect(goToBranchBody, contains('item.location'));
    expect(goToBranchBody, isNot(contains('navigationShell.goBranch')));
    expect(source, contains('required this.location'));
    expect(source, contains('location: AppRoutePath.me'));
  });

  test('shell route changes dismiss active overlays', () {
    final source = File(
      'lib/app/navigation/app_shell_scaffold.dart',
    ).readAsStringSync();

    expect(source, contains('_lastRouteKey'));
    expect(source, contains('addPostFrameCallback'));
    expect(source, contains('_dismissActiveOverlay(context)'));
    expect(source, contains('route == null || route.isCurrent'));
    expect(source, contains('navigator.pop()'));
  });
}
