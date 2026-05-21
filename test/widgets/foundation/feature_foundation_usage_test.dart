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
      'lib/features/grammar/widgets/grammar_directive_e_section.dart',
      'lib/features/vocab/screens/hajimete_chapter_catalog_screen.dart',
      'lib/features/vocab/screens/shinkanzen_lesson_catalog_screen.dart',
      'lib/features/vocab/screens/mimikara_unit_catalog_screen.dart',
      'lib/features/vocab/screens/vocab_detail_screen.dart',
      'lib/features/kanji_reading/screens/kanji_reading_quiz_screen.dart',
      'lib/features/write/widgets/kanji_stroke_animator.dart',
      'lib/features/write/screens/home_handwriting_practice_screen.dart',
      'lib/features/write/screens/handwriting_practice_screen.dart',
      'lib/features/jlpt/widgets/jlpt_prep_hero.dart',
      'lib/features/jlpt/widgets/jlpt_plan_panel.dart',
      'lib/features/mistakes/screens/mistake_screen.dart',
      'lib/features/practice/screens/recall_sprint_screen.dart',
      'lib/features/kanji_hub/widgets/kanji_relationship_graph.dart',
      'lib/features/kanji_hub/widgets/kanji_graph_practice_panel.dart',
      'lib/features/home/widgets/ghost_review_banner.dart',
      'lib/features/auth/widgets/login_dialog.dart',
      'lib/features/conjugation/screens/conjugation_hub_screen.dart',
      'lib/features/home/widgets/daily_session_card.dart',
      'lib/features/home/screens/learning_path_screen.dart',
      'lib/features/immersion/screens/immersion_reader_screen.dart',
      'lib/features/lesson/widgets/kanji_list_widget.dart',
      'lib/features/lesson/widgets/grammar_list_widget.dart',
      'lib/features/grammar/widgets/sentence_builder_widget.dart',
      'lib/features/learn/widgets/fill_blank_widget.dart',
      'lib/features/grammar/screens/grammar_practice_screen.dart',
      'lib/features/test/screens/test_screen.dart',
      'lib/features/test/screens/test_review_screen.dart',
      'lib/features/test/screens/test_results_screen.dart',
      'lib/features/test/screens/test_config_screen.dart',
      'lib/features/learn/screens/learn_summary_screen.dart',
      'lib/features/foundations/screens/kana_table_screen.dart',
      'lib/features/foundations/screens/kana_quiz_screen.dart',
      'lib/features/foundations/screens/kana_locked_screen.dart',
      'lib/features/foundations/screens/han_viet_reference_screen.dart',
      'lib/features/foundations/screens/foundations_hub_screen.dart',
      'lib/features/learn/screens/learn_screen.dart',
      'lib/features/learn/screens/learn_config_screen.dart',
      'lib/features/grammar/screens/ghost_practice_screen.dart',
      'lib/features/jlpt/screens/jlpt_reading_screen.dart',
      'lib/features/jlpt/screens/jlpt_mock_pro_screen.dart',
      'lib/features/me/screens/data_settings_screen.dart',
    ];

    final rawPrimitivePattern = RegExp(
      r'\b(Card|ElevatedButton|OutlinedButton|TextButton|FilledButton|'
      r'Chip|ActionChip|FilterChip|ChoiceChip)\s*\(|'
      r'\b(FilledButton|OutlinedButton|ElevatedButton|TextButton)\.',
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
