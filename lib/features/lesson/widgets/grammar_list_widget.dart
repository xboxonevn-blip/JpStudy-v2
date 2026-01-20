import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

class GrammarListWidget extends ConsumerWidget {
  const GrammarListWidget({
    super.key,
    required this.lessonId,
    required this.language,
  });

  final int lessonId;
  final AppLanguage language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grammarAsync = ref.watch(lessonGrammarProvider(lessonId));

    return grammarAsync.when(
      data: (grammarList) {
        if (grammarList.isEmpty) {
          return Center(
            child: Text(
              language == AppLanguage.vi
                  ? 'Chưa có dữ liệu ngữ pháp.'
                  : 'No grammar data available.',
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: grammarList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final data = grammarList[index];
            return _GrammarPointCard(
              index: index + 1,
              data: data,
              language: language,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _GrammarPointCard extends StatelessWidget {
  const _GrammarPointCard({
    required this.index,
    required this.data,
    required this.language,
  });

  final int index;
  final GrammarPointData data;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final point = data.point;
    
    // Determine Meaning and Explanation based on Language
    String meaning = point.grammarPoint;
    String explanation = '';

    switch (language) {
      case AppLanguage.vi:
        meaning = point.meaningVi ?? point.grammarPoint;
        explanation = point.explanationVi ?? point.explanation;
        break;
      case AppLanguage.en:
        meaning = point.meaningEn ?? point.grammarPoint;
        explanation = point.explanationEn ?? point.explanation;
        break;
      case AppLanguage.ja:
        meaning = point.grammarPoint;
        explanation = point.connection; // For JP, show structure mainly
        break;
    }

    // Fallbacks if empty
    if (explanation.isEmpty) explanation = point.explanation;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE0E7FF),
          foregroundColor: const Color(0xFF4255FF),
          child: Text(
            '$index',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          point.grammarPoint,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C2440),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              meaning,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7390),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (point.connection.isNotEmpty) ...[
              const SizedBox(height: 4),
               Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  point.connection,
                  style: const TextStyle(
                    fontFamily: 'Courier', // Monospace for structure
                    fontSize: 12,
                    color: Color(0xFF4255FF),
                  ),
                ),
              ),
            ],
          ],
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  explanation,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF2E3A59),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          if (data.examples.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                language == AppLanguage.vi 
                    ? 'Ví dụ:' 
                    : language == AppLanguage.en ? 'Examples:' : '例文',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8F9BB3),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...data.examples.map((ex) {
              String translation = '';
               switch (language) {
                case AppLanguage.vi:
                  translation = ex.translationVi ?? ex.translation;
                  break;
                case AppLanguage.en:
                  translation = ex.translationEn ?? ex.translation;
                  break;
                case AppLanguage.ja:
                  translation = ''; // No translation for JP mode
                  break;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Color(0xFF4255FF))),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ex.japanese,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (translation.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              translation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7390),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
}
