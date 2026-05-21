import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/app/navigation/app_navigation_extensions.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/repositories/conjugation_repository.dart';
import 'package:jpstudy/features/conjugation/models/conjugation_practice_args.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

class ConjugationLessonWidget extends ConsumerWidget {
  const ConjugationLessonWidget({
    super.key,
    required this.levelCode,
    required this.lessonId,
    this.series,
  });

  final String levelCode;
  final int lessonId;
  final String? series;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final repo = ref.watch(conjugationRepositoryProvider);
    return FutureBuilder<List<ConjugationLemmaData>>(
      future: repo.fetchByLesson(
        levelCode,
        lessonId,
        series: series,
        limit: 8,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final lemmas = snapshot.data!;
        if (lemmas.isEmpty) return const SizedBox.shrink();
        final ids = lemmas
            .map((lemma) => lemma.contentVocabId)
            .toList(growable: false);
        return AppCard(
          key: const ValueKey('lesson_conjugation_widget'),
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.swap_horiz_rounded),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _title(language),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(_countLabel(language, lemmas.length)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final lemma in lemmas)
                    AppChip(
                      label: lemma.dictionaryForm,
                      tone: AppChipTone.info,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: AppButton(
                  icon: Icons.school_rounded,
                  label: _practiceLabel(language),
                  compact: true,
                  onPressed: () => context.openConjugationPractice(
                    ConjugationPracticeArgs(
                      contentVocabIds: ids,
                      targetCount: 50,
                      source: 'lesson_conjugation_widget',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _title(AppLanguage language) => switch (language) {
    AppLanguage.vi => 'Chia thể trong bài',
    AppLanguage.en => 'Conjugation in this lesson',
    AppLanguage.ja => 'この課の活用',
  };

  String _countLabel(AppLanguage language, int count) => switch (language) {
    AppLanguage.vi => '$count động từ/tính từ có thể luyện ngay.',
    AppLanguage.en => '$count verb/adjective items are ready.',
    AppLanguage.ja => '$count語を練習できます。',
  };

  String _practiceLabel(AppLanguage language) => switch (language) {
    AppLanguage.vi => 'Luyện chia thể 50+ câu',
    AppLanguage.en => 'Practice 50+ forms',
    AppLanguage.ja => '50問以上の活用練習',
  };
}
