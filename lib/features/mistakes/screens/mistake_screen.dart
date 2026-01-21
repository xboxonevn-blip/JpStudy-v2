import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/providers/dashboard_provider.dart';
import '../repositories/mistake_repository.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/models/vocab_item.dart';
import '../../learn/providers/learn_session_provider.dart';
import 'package:go_router/go_router.dart';

class MistakeScreen extends ConsumerStatefulWidget {
  const MistakeScreen({super.key});

  @override
  ConsumerState<MistakeScreen> createState() => _MistakeScreenState();
}

class _MistakeScreenState extends ConsumerState<MistakeScreen> {
  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(mistakeRepositoryProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mistake Bank'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          repo.getMistakesByType('vocab'),
          repo.getMistakesByType('grammar'),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final vocabMistakes = snapshot.data?[0] ?? [];
          final grammarMistakes = snapshot.data?[1] ?? [];
          final allMistakes = [...vocabMistakes, ...grammarMistakes];
          
          if (allMistakes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text('No mistakes! Great job!'),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: allMistakes.length,
                  itemBuilder: (context, index) {
                    final mistake = allMistakes[index];
                    final isVocab = mistake.type == 'vocab';

                    return ListTile(
                      leading: Icon(
                        isVocab ? Icons.translate : Icons.menu_book_rounded,
                        color: isVocab ? Colors.orange : Colors.purple,
                      ),
                      title: Text('${isVocab ? "Vocab" : "Grammar"} ID: ${mistake.itemId}'), 
                      subtitle: Text('Wrong count: ${mistake.wrongCount}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                           repo.removeMistake(
                             type: mistake.type, 
                             itemId: mistake.itemId
                           );
                           setState(() {}); // Refresh
                           ref.invalidate(dashboardProvider); 
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FilledButton.icon(
                  onPressed: () => _startPractice(context, ref, allMistakes),
                  icon: const Icon(Icons.build),
                  label: const Text('Fix Mistakes'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _startPractice(BuildContext context, WidgetRef ref, List<dynamic> mistakes) async {
    final db = ref.read(databaseProvider);
    
    // Separate mistakes
    final vocabIds = <int>[];
    final grammarIds = <int>[];

    for (final m in mistakes) {
      if (m.type == 'vocab') {
        vocabIds.add(m.itemId);
      } else if (m.type == 'grammar') {
        grammarIds.add(m.itemId);
      }
    }

    // 1. Handle Vocab Mistakes
    if (vocabIds.isNotEmpty) {
      final items = <VocabItem>[];
      for (final id in vocabIds) {
         final term = await (db.select(db.userLessonTerm)..where((t) => t.id.equals(id))).getSingleOrNull();
         if (term != null) {
            items.add(VocabItem(
              id: term.id, 
              term: term.term, 
              reading: term.reading, 
              meaning: term.definition, 
              level: 'Unknown', 
            ));
         }
      }

      if (items.isNotEmpty && context.mounted) {
        ref.read(learnSessionProvider.notifier).startSession(
          lessonId: -999,
          items: items,
        );
        // We push and return because we currently support one session at a time in UI
        context.push('/learn/session');
        return; 
      }
    }

    // 2. Handle Grammar Mistakes
    if (grammarIds.isNotEmpty && context.mounted) {
       // Navigate to Grammar Practice with IDs
       context.push('/grammar-practice', extra: grammarIds);
    }
  }
}
