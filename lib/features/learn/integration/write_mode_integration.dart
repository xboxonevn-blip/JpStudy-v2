import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_language.dart';
import '../../../core/language_provider.dart';
import '../../../data/models/vocab_item.dart';
import '../../../data/db/app_database.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../../core/level_provider.dart';
import '../../../core/study_level.dart';
import '../models/question_type.dart';
import '../screens/learn_screen.dart';

/// Write mode - Learn mode with only fillBlank questions
class WriteModeIntegration extends ConsumerWidget {
  final int lessonId;
  final String lessonTitle;

  const WriteModeIntegration({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
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
            appBar: AppBar(
              title: Text('${language.writeModeLabel}: $lessonTitle'),
            ),
            body: Center(
              child: Text(language.noTermsAvailableLabel),
            ),
          );
        }

        // Convert to VocabItem
        final vocabItems = _convertToVocabItems(terms);

        // Go directly to LearnScreen with only fillBlank enabled
        return LearnScreen(
          lessonId: lessonId,
          lessonTitle: lessonTitle,
          items: vocabItems,
          enabledTypes: const [QuestionType.fillBlank],
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text('${language.writeModeLabel}: $lessonTitle'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(
          title: Text('${language.writeModeLabel}: $lessonTitle'),
        ),
        body: Center(child: Text(language.loadErrorLabel)),
      ),
    );
  }

  List<VocabItem> _convertToVocabItems(List<UserLessonTermData> terms) {
    return terms.map((term) => VocabItem(
      id: term.id,
      term: term.term,
      reading: term.reading,
      meaning: term.definition,
      meaningEn: term.definitionEn,
      level: 'N5', // Default level
    )).toList();
  }
}
