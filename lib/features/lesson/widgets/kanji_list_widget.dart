import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/data/models/kanji_item.dart';

class KanjiListWidget extends ConsumerWidget {
  final int lessonId;

  const KanjiListWidget({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiAsync = ref.watch(lessonKanjiProvider(lessonId));
    final language = ref.watch(appLanguageProvider);

    return kanjiAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('Chưa có dữ liệu Hán tự cho bài này.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final KanjiItem item = items[index];
            
            String primaryMeaning;
            String subtitle;

            switch (language) {
              case AppLanguage.vi:
                primaryMeaning = item.meaning;
                subtitle = 'On: ${item.onyomi ?? "-"} | Kun: ${item.kunyomi ?? "-"}';
                break;
              case AppLanguage.en:
                primaryMeaning = item.meaningEn ?? item.meaning;
                subtitle = 'On: ${item.onyomi ?? "-"} | Kun: ${item.kunyomi ?? "-"}';
                break;
              case AppLanguage.ja:
                final readings = [
                  if (item.onyomi != null) item.onyomi,
                  if (item.kunyomi != null) item.kunyomi
                ].join(' / ');
                primaryMeaning = readings.isNotEmpty ? readings : item.meaning;
                subtitle = item.meaning; 
                break;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.character,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  primaryMeaning,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(subtitle),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (language != AppLanguage.vi)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text('Nghĩa Việt: ${item.meaning}'),
                          ),
                        if (language != AppLanguage.en && item.meaningEn != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text('Nghĩa Anh: ${item.meaningEn}'),
                          ),
                        Text('Số nét: ${item.strokeCount}'),
                        if (item.examples.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Ví dụ:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...item.examples.map((ex) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      ex.word,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('(${ex.reading})'),
                                    const Spacer(),
                                    Flexible(
                                      child: Text(
                                        language == AppLanguage.en
                                            ? (ex.meaningEn ?? ex.meaning)
                                            : ex.meaning,
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Lỗi tải dữ liệu: $e')),
    );
  }
}
