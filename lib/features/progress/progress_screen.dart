import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider);
    final levelSuffix = level == null ? '' : ' (${level.shortLabel})';
    final summaryAsync = ref.watch(progressSummaryProvider);
    return Scaffold(
      appBar: AppBar(title: Text('${language.progressTitle}$levelSuffix')),
      body: summaryAsync.when(
        data: (summary) {
          if (summary.totalAttempts == 0) {
            return Center(child: Text(language.progressEmptyLabel));
          }
          final accuracy = summary.totalQuestions == 0
              ? 0
              : (summary.totalCorrect / summary.totalQuestions * 100).round();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _StatCard(
                label: language.progressStreakLabel,
                value: summary.streak.toString(),
              ),
              _StatCard(
                label: language.progressTodayXpLabel,
                value: summary.todayXp.toString(),
              ),
              _StatCard(
                label: language.progressTotalXpLabel,
                value: summary.totalXp.toString(),
              ),
              _StatCard(
                label: language.progressAttemptsLabel,
                value: summary.totalAttempts.toString(),
              ),
              _StatCard(
                label: language.progressAccuracyLabel,
                value: '$accuracy%',
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(language.loadErrorLabel)),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A2E3A59),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
