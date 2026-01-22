import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/features/common/widgets/clay_button.dart';
import 'package:jpstudy/features/common/widgets/clay_card.dart';


void main() {
  testWidgets('ClayButton renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: ClayButton(
            label: 'Test Button',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('TEST BUTTON'), findsOneWidget); // Label is uppercased
    expect(find.byType(ClayButton), findsOneWidget);
  });

  testWidgets('ClayCard renders child correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: const Scaffold(
          body: ClayCard(
            child: Text('Card Content'),
          ),
        ),
      ),
    );

    expect(find.text('Card Content'), findsOneWidget);
    expect(find.byType(ClayCard), findsOneWidget);
  });
}
