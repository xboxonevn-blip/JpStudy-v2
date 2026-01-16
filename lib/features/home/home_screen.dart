import 'package:flutter/material.dart';
import 'package:jpstudy/features/exam/exam_screen.dart';
import 'package:jpstudy/features/grammar/grammar_screen.dart';
import 'package:jpstudy/features/progress/progress_screen.dart';
import 'package:jpstudy/features/vocab/vocab_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JpStudy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'MVP modules',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _ModuleCard(
            title: 'Flashcards + SRS',
            subtitle: 'Review vocabulary with scheduling.',
            onTap: () => _push(context, const VocabScreen()),
          ),
          _ModuleCard(
            title: 'Grammar Quiz',
            subtitle: 'N5 / N4 / N3 practice sets.',
            onTap: () => _push(context, const GrammarScreen()),
          ),
          _ModuleCard(
            title: 'Mock Exam',
            subtitle: 'Timer, scoring, and review.',
            onTap: () => _push(context, const ExamScreen()),
          ),
          _ModuleCard(
            title: 'Progress',
            subtitle: 'Streak, XP, and basic stats.',
            onTap: () => _push(context, const ProgressScreen()),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
