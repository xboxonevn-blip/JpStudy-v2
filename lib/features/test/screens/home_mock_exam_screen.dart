import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/services/session_storage_provider.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

import '../models/test_config.dart';
import '../screens/test_config_screen.dart';
import '../screens/test_screen.dart';

class HomeMockExamScreen extends ConsumerWidget {
  const HomeMockExamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider);

    if (level == null) {
      return Scaffold(
        appBar: AppBar(title: Text(language.practiceExamLabel)),
        body: Center(child: Text(language.levelMenuTitle)),
      );
    }

    final levelLabel = level.shortLabel;
    final repo = ref.read(lessonRepositoryProvider);

    return FutureBuilder(
      future: repo.getVocabByLevel(levelLabel),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(language.mockExamTitle(levelLabel))),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(language.mockExamTitle(levelLabel))),
            body: Center(child: Text(language.loadErrorLabel)),
          );
        }

        final allVocab = snapshot.data ?? const [];
        if (allVocab.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(language.mockExamTitle(levelLabel))),
            body: Center(child: Text(language.noTermsAvailableLabel)),
          );
        }

        final sessionKey = 'mock_$levelLabel';
        final initialConfig = TestConfig.mockExam(
          questionCount: allVocab.length,
        );
        final storage = ref.read(sessionStorageProvider);

        return FutureBuilder(
          future: storage.loadTestSession(sessionKey),
          builder: (context, resumeSnapshot) {
            final resume = resumeSnapshot.data;
            return TestConfigScreen(
              lessonId: -1,
              lessonTitle: language.mockExamTitle(levelLabel),
              maxQuestions: allVocab.length,
              initialConfig: initialConfig,
              resumeSnapshot: resume,
              onResume: resume == null
                  ? null
                  : () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => TestScreen(
                            items: allVocab,
                            lessonId: -1,
                            lessonTitle: language.mockExamTitle(levelLabel),
                            config: resume.config,
                            resumeSnapshot: resume,
                            sessionKey: sessionKey,
                          ),
                        ),
                      );
                    },
              onDiscardResume: resume == null
                  ? null
                  : () async {
                      await storage.clearTestSession(sessionKey);
                    },
              onStart: (config) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TestScreen(
                      items: allVocab,
                      lessonId: -1,
                      lessonTitle: language.mockExamTitle(levelLabel),
                      config: config,
                      sessionKey: sessionKey,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
