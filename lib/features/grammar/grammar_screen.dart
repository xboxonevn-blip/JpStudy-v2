import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';

import 'package:jpstudy/features/grammar/grammar_providers.dart';

class GrammarScreen extends ConsumerWidget {
  const GrammarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider);
    final levelSuffix = level == null ? '' : ' (${level.shortLabel})';
    
    final levelStr = level?.shortLabel ?? 'N5';
    final pointsAsync = ref.watch(grammarPointsProvider(levelStr));

    return Scaffold(
      appBar: AppBar(
        title: Text('${language.grammarTitle}$levelSuffix'),
      ),
      body: pointsAsync.when(
        data: (points) {
          if (points.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_stories, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No grammar points for $levelStr yet.'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: points.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final point = points[index];
              return ListTile(
                title: Text(
                  point.grammarPoint,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(point.meaning),
                trailing: point.isLearned 
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.chevron_right, color: Colors.grey[400]),
                onTap: () => context.push('/grammar/${point.id}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: ref.watch(grammarDueCountProvider).when(
        data: (count) => count > 0 
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/grammar-practice'),
              icon: const Icon(Icons.psychology),
              label: Text('Review ($count)'),
              backgroundColor: Colors.orange[700],
              foregroundColor: Colors.white,
            )
          : null,
        loading: () => null,
        error: (_, _) => null,
      ),
    );
  }
}
