import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/repositories/content_repository.dart';

class VocabScreen extends ConsumerWidget {
  const VocabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider);
    final levelSuffix = level == null ? '' : ' (${level.shortLabel})';
    return Scaffold(
      appBar: AppBar(title: Text('${language.vocabTitle}$levelSuffix')),
      body: level == null
          ? Center(child: Text(language.selectLevelToViewVocab))
          : _VocabPreview(
              language: language,
              level: level,
            ),
    );
  }
}

class _VocabPreview extends ConsumerWidget {
  const _VocabPreview({
    required this.language,
    required this.level,
  });

  final AppLanguage language;
  final StudyLevel level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabAsync = ref.watch(vocabPreviewProvider(level.shortLabel));
    return vocabAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(child: Text(language.vocabScreenBody));
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              language.vocabPreviewTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            for (final item in items)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(item.term),
                  subtitle: Text(
                    item.reading == null || item.reading!.isEmpty
                        ? item.meaning
                        : '${item.reading} • ${item.meaning}',
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text(language.loadErrorLabel)),
    );
  }
}
