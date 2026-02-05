import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

enum LessonPracticeMode { learn, test, match, write }

LessonPracticeMode? lessonPracticeModeFromPath(String value) {
  switch (value) {
    case 'learn':
      return LessonPracticeMode.learn;
    case 'test':
      return LessonPracticeMode.test;
    case 'match':
      return LessonPracticeMode.match;
    case 'write':
      return LessonPracticeMode.write;
  }
  return null;
}

class LessonPracticeScreen extends ConsumerWidget {
  const LessonPracticeScreen({
    super.key,
    required this.lessonId,
    required this.mode,
  });

  final int lessonId;
  final LessonPracticeMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final fallbackTitle = language.lessonTitle(lessonId);
    final titleAsync = ref.watch(
      lessonTitleProvider(LessonTitleArgs(lessonId, fallbackTitle)),
    );
    final title = titleAsync.maybeWhen(
      data: (value) => value,
      orElse: () => fallbackTitle,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${_modeLabel(language, mode)} - $title'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.handyman, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              language.lessonModeTemporarilyDisabledLabel(
                _modeLabel(language, mode),
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(language.lessonPracticeMaintenanceLabel),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: Text(language.backToLessonLabel),
            ),
          ],
        ),
      ),
    );
  }

  String _modeLabel(AppLanguage language, LessonPracticeMode mode) {
    switch (mode) {
      case LessonPracticeMode.learn:
        return language.learnModeLabel;
      case LessonPracticeMode.test:
        return language.testModeLabel;
      case LessonPracticeMode.match:
        return language.matchModeLabel;
      case LessonPracticeMode.write:
        return language.writeModeLabel;
    }
  }
}
