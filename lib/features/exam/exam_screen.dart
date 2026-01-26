import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_language.dart';
import '../../core/language_provider.dart';
import '../../core/services/session_storage_provider.dart';
import '../../data/repositories/lesson_repository.dart';
import '../test/models/test_config.dart';
import '../test/screens/test_config_screen.dart';
import '../test/screens/test_screen.dart';

class ExamScreen extends ConsumerWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);

    return Scaffold(
      appBar: AppBar(title: Text(language.examTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            language.mockExamSubtitle,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7390)),
          ),
          const SizedBox(height: 16),
          _ExamLevelCard(
            level: 'N5',
            color: const Color(0xFFF472B6),
            subtitle: language.examSubtitle('N5'),
            onTap: () => _startMockExam(context, ref, language, 'N5'),
          ),
          const SizedBox(height: 12),
          _ExamLevelCard(
            level: 'N4',
            color: const Color(0xFFF59E0B),
            subtitle: language.examSubtitle('N4'),
            onTap: () => _startMockExam(context, ref, language, 'N4'),
          ),
        ],
      ),
    );
  }

  Future<void> _startMockExam(
    BuildContext context,
    WidgetRef ref,
    AppLanguage language,
    String level,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final repo = ref.read(lessonRepositoryProvider);
      final allVocab = await repo.getVocabByLevel(level);
      final sessionKey = 'mock_$level';

      if (!context.mounted) return;
      Navigator.pop(context);

      if (allVocab.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(language.noTermsAvailableLabel)));
        return;
      }

      final storage = ref.read(sessionStorageProvider);
      final resumeSnapshot = await storage.loadTestSession(sessionKey);
      if (!context.mounted) return;

      final initialConfig = TestConfig.mockExam(questionCount: allVocab.length);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TestConfigScreen(
            lessonId: -1,
            lessonTitle: language.mockExamTitle(level),
            maxQuestions: allVocab.length,
            initialConfig: initialConfig,
            resumeSnapshot: resumeSnapshot,
            onResume: resumeSnapshot == null
                ? null
                : () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => TestScreen(
                          items: allVocab,
                          lessonId: -1,
                          lessonTitle: language.mockExamTitle(level),
                          config: resumeSnapshot.config,
                          resumeSnapshot: resumeSnapshot,
                          sessionKey: sessionKey,
                        ),
                      ),
                    );
                  },
            onDiscardResume: resumeSnapshot == null
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
                    lessonTitle: language.mockExamTitle(level),
                    config: config,
                    sessionKey: sessionKey,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } catch (_) {
      if (context.mounted) Navigator.pop(context);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(language.loadErrorLabel)));
    }
  }
}

class _ExamLevelCard extends StatelessWidget {
  const _ExamLevelCard({
    required this.level,
    required this.color,
    required this.subtitle,
    required this.onTap,
  });

  final String level;
  final Color color;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.9), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.timer, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'JLPT $level',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
