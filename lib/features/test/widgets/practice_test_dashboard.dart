import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/core/language_provider.dart'; 
import 'package:jpstudy/core/app_language.dart'; // Explicit import
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/test/screens/test_config_screen.dart';
import 'package:jpstudy/features/test/screens/test_screen.dart';

class PracticeTestDashboard extends ConsumerWidget {
  const PracticeTestDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine the level color theme
    final level = ref.watch(studyLevelProvider) ?? StudyLevel.n5;
    final isN5 = level == StudyLevel.n5;
    final color = isN5 ? Colors.pink : Colors.orange;
    final levelLabel = isN5 ? 'N5' : 'N4';
    
    // Localization
    final language = ref.watch(appLanguageProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _buildTestCard(context, ref, levelLabel, color, language),
    );
  }

  Widget _buildTestCard(BuildContext context, WidgetRef ref, String level, Color color, AppLanguage language) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => _startLevelTest(context, ref, level),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.85), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school_rounded, size: 32, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.startPracticeTitle(level),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      language.mockExamSubtitle,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startLevelTest(BuildContext context, WidgetRef ref, String level) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Fetch data
      final repo = ref.read(lessonRepositoryProvider);
      final allVocab = await repo.getVocabByLevel(level);
      
      if (!context.mounted) return;
      Navigator.pop(context); // Hide loading

      if (allVocab.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No vocabulary found for JLPT $level')),
        );
        return;
      }

      // Navigate to Config Screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TestConfigScreen(
            lessonId: -1, // Special ID for Mock Tests
            lessonTitle: 'JLPT $level Mock Exam',
            maxQuestions: allVocab.length,
            onStart: (config) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => TestScreen(
                    items: allVocab, // Pass all, TestScreen handles selection/shuffling based on count
                    lessonId: -1,
                    lessonTitle: 'JLPT $level Mock Exam',
                    config: config,
                  ),
                ),
              );
            },
          ),
        ),
      );

    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading test: $e')),
      );
    }
  }
}
