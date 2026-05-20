import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/data/repositories/conjugation_repository.dart';
import 'package:jpstudy/features/conjugation/models/conjugation_practice_args.dart';

class ConjugationHubScreen extends ConsumerWidget {
  const ConjugationHubScreen({super.key, this.contentVocabId});

  final int? contentVocabId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider)?.shortLabel ?? 'N5';
    final repo = ref.watch(conjugationRepositoryProvider);
    final future = contentVocabId == null
        ? repo.fetchByLevel(level)
        : repo.fetchByContentVocabIds([contentVocabId!]);
    return Scaffold(
      appBar: AppBar(
        title: Text(_tr(language, 'Conjugation', 'Chia thể', '活用')),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final lemmas = snapshot.data ?? const [];
          if (lemmas.isEmpty) {
            return Center(
              child: Text(
                _tr(
                  language,
                  'No conjugation content for this scope yet.',
                  'Chưa có nội dung chia thể cho phạm vi này.',
                  'この範囲の活用データはまだありません。',
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _tr(
                    language,
                    '${lemmas.length} sourced lemmas ready',
                    '${lemmas.length} mục có nguồn sẵn sàng',
                    '${lemmas.length}語の活用データ',
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: Text(
                    _tr(language, 'Practice forms', 'Luyện chia thể', '活用練習'),
                  ),
                  onPressed: () {
                    context.pushNamed(
                      AppRouteName.grammarConjugationPractice,
                      extra: ConjugationPracticeArgs(
                        contentVocabIds: contentVocabId == null
                            ? null
                            : [contentVocabId!],
                        targetCount: 5,
                        source: 'conjugation_practice',
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _tr(AppLanguage language, String en, String vi, String ja) {
    switch (language) {
      case AppLanguage.en:
        return en;
      case AppLanguage.vi:
        return vi;
      case AppLanguage.ja:
        return ja;
    }
  }
}
