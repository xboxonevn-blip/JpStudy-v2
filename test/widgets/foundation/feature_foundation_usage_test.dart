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
      'lib/features/vocab/widgets/kanji_inline_popover.dart',
      'lib/features/flashcards/widgets/flashcard_summary.dart',
      'lib/features/flashcards/widgets/flashcard_settings_dialog.dart',
      'lib/features/learn/widgets/achievement_popup.dart',
      'lib/features/quiz/widgets/shared_answer_selection.dart',
      'lib/features/vocab/screens/vocab_ghost_review_screen.dart',
      'lib/features/vocab/screens/minna_lesson_catalog_screen.dart',
      'lib/features/vocab/screens/hajimete_chapter_detail_screen.dart',
      'lib/features/home/widgets/discover_practice_panel.dart',
      'lib/features/home/widgets/goal_selection_banner.dart',
      'lib/features/common/widgets/error_state_widget.dart',
      'lib/features/common/widgets/compact_ui.dart',
      'lib/features/flashcards/screens/enhanced_flashcard_screen.dart',
      'lib/features/conjugation/screens/conjugation_practice_screen.dart',
      'lib/features/grammar/widgets/cloze_test_widget.dart',
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
