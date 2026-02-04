import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

import 'handwriting_practice_screen.dart';

class HomeHandwritingPracticeScreen extends ConsumerWidget {
  const HomeHandwritingPracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider);
    if (level == null) {
      return Scaffold(
        appBar: AppBar(title: Text(language.handwritingLabel)),
        body: Center(child: Text(language.levelMenuTitle)),
      );
    }

    final repo = ref.read(lessonRepositoryProvider);
    return FutureBuilder(
      future: repo.fetchKanjiByLevel(level.shortLabel),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${language.handwritingLabel} ${level.shortLabel}'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${language.handwritingLabel} ${level.shortLabel}'),
            ),
            body: Center(child: Text(language.loadErrorLabel)),
          );
        }

        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${language.handwritingLabel} ${level.shortLabel}'),
            ),
            body: Center(child: Text(language.noTermsAvailableLabel)),
          );
        }

        return HandwritingPracticeScreen(
          lessonTitle: '${level.shortLabel} - ${language.handwritingLabel}',
          items: items,
        );
      },
    );
  }
}
