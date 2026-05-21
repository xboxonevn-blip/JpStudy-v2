import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/app/layout/app_responsive_frame.dart';

void main() {
  test('desktop metrics use full chrome and 1600px content at 1920+', () {
    expect(AppResponsiveMetrics.shellMaxWidth(1440), double.infinity);
    expect(AppResponsiveMetrics.shellMaxWidth(1920), double.infinity);
    expect(AppResponsiveMetrics.contentMaxWidth(1024), 1040);
    expect(AppResponsiveMetrics.contentMaxWidth(1280), 1280);
    expect(AppResponsiveMetrics.contentMaxWidth(1600), 1440);
    expect(AppResponsiveMetrics.contentMaxWidth(1920), 1600);
  });

  testWidgets('sizes to child inside vertically unbounded scrollables', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              AppResponsiveFrame(
                child: SizedBox(height: 120, child: Text('dashboard content')),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('dashboard content'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
