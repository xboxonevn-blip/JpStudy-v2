import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/vocab_item.dart';
import '../../../data/db/app_database.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../../core/level_provider.dart';
import '../../../core/study_level.dart';
import '../screens/test_config_screen.dart';
import '../screens/test_screen.dart';

/// Integration screen that shows config first, then navigates to test mode
class TestModeIntegration extends ConsumerWidget {
  final int lessonId;
  final String lessonTitle;

  const TestModeIntegration({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(studyLevelProvider) ?? StudyLevel.n5;
    final termsAsync = ref.watch(
      lessonTermsProvider(
        LessonTermsArgs(lessonId, level.shortLabel, lessonTitle),
      ),
    );

    return termsAsync.when(
      data: (terms) {
        if (terms.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text('Test: $lessonTitle')),
            body: const Center(
              child: Text('No terms available for this lesson'),
            ),
          );
        }

        // Convert to VocabItem
        final vocabItems = _convertToVocabItems(terms);

        return TestConfigScreen(
          lessonId: lessonId,
          lessonTitle: lessonTitle,
          maxQuestions: vocabItems.length,
          onStart: (config) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => TestScreen(
                  lessonId: lessonId,
                  lessonTitle: lessonTitle,
                  items: vocabItems,
                  config: config,
                ),
              ),
            );
          },
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text('Test: $lessonTitle')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text('Test: $lessonTitle')),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  List<VocabItem> _convertToVocabItems(List<UserLessonTermData> terms) {
    return terms.map((term) => VocabItem(
      id: term.id,
      term: term.term,
      reading: term.reading,
      meaning: term.definition,
      level: 'N5', // Default level
    )).toList();
  }
}
