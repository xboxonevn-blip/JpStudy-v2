import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('feature widgets use foundation primitives', () {
    const batchOneFiles = [
      'lib/features/foundations/widgets/kana_review_due_card.dart',
      'lib/features/foundations/widgets/han_viet_inline_panel.dart',
      'lib/features/foundations/widgets/foundations_soft_suggest_gate.dart',
      'lib/features/conjugation/widgets/conjugation_lesson_widget.dart',
      'lib/features/test/widgets/practice_test_dashboard.dart',
    ];

    final rawPrimitivePattern = RegExp(
      r'\b(Card|ElevatedButton|OutlinedButton|TextButton|FilledButton|'
      r'Chip|ActionChip|FilterChip|ChoiceChip)\s*\(',
    );

    for (final path in batchOneFiles) {
      test('$path delegates cards, buttons, and chips to foundation', () {
        final source = File(path).readAsStringSync();

        expect(
          source,
          contains("package:jpstudy/widgets/foundation/foundation.dart"),
        );
        expect(source, isNot(matches(rawPrimitivePattern)));
      });
    }
  });
}
