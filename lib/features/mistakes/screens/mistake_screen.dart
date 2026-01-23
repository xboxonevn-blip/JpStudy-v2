import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_language.dart';
import '../../../core/language_provider.dart';
import '../../home/providers/dashboard_provider.dart';
import '../repositories/mistake_repository.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/models/vocab_item.dart';
import '../../learn/providers/learn_session_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../data/db/app_database.dart';

class MistakeScreen extends ConsumerStatefulWidget {
  const MistakeScreen({super.key});

  @override
  ConsumerState<MistakeScreen> createState() => _MistakeScreenState();
}

class _MistakeScreenState extends ConsumerState<MistakeScreen> {
  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(mistakeRepositoryProvider);
    final language = ref.watch(appLanguageProvider);
    final db = ref.watch(databaseProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mistake Bank'),
      ),
      body: StreamBuilder<List<UserMistake>>(
        stream: repo.watchAllMistakes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allMistakes = snapshot.data ?? [];
          
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

          return FutureBuilder<_MistakeDetails>(
            future: _loadMistakeDetails(allMistakes, db),
            builder: (context, detailSnapshot) {
              if (detailSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (detailSnapshot.hasError) {
                return Center(child: Text('Error: ${detailSnapshot.error}'));
              }

              final details = detailSnapshot.data ?? const _MistakeDetails();

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: allMistakes.length,
                      itemBuilder: (context, index) {
                        final mistake = allMistakes[index];
                        final isVocab = mistake.type == 'vocab';
                        final display = _buildMistakeDisplay(
                          mistake,
                          details,
                          language,
                        );

                        return ListTile(
                          leading: Icon(
                            isVocab ? Icons.translate : Icons.menu_book_rounded,
                            color: isVocab ? Colors.orange : Colors.purple,
                          ),
                          title: Text(display.title),
                          subtitle: Text(display.subtitle),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              repo.removeMistake(
                                type: mistake.type,
                                itemId: mistake.itemId,
                              );
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
                      onPressed: () => _startPractice(
                        context,
                        ref,
                        allMistakes,
                        details,
                        language,
                      ),
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
          );
        },
      ),
    );
  }

  Future<void> _startPractice(
    BuildContext context,
    WidgetRef ref,
    List<UserMistake> mistakes,
    _MistakeDetails details,
    AppLanguage language,
  ) async {
    
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
        final term = details.vocab[id];
        if (term == null) continue;
        items.add(VocabItem(
          id: term.id,
          term: term.term,
          reading: term.reading,
          meaning: term.definition,
          meaningEn: term.definitionEn,
          level: 'Unknown',
        ));
      }

      if (items.isNotEmpty && context.mounted) {
        ref.read(learnSessionProvider.notifier).startSession(
          lessonId: -999,
          items: items,
          language: language,
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

  Future<_MistakeDetails> _loadMistakeDetails(
    List<UserMistake> mistakes,
    AppDatabase db,
  ) async {
    final vocabIds = <int>{};
    final grammarIds = <int>{};
    for (final mistake in mistakes) {
      if (mistake.type == 'vocab') {
        vocabIds.add(mistake.itemId);
      } else if (mistake.type == 'grammar') {
        grammarIds.add(mistake.itemId);
      }
    }

    final vocabMap = <int, UserLessonTermData>{};
    if (vocabIds.isNotEmpty) {
      final terms = await (db.select(db.userLessonTerm)
            ..where((t) => t.id.isIn(vocabIds.toList())))
          .get();
      for (final term in terms) {
        vocabMap[term.id] = term;
      }
    }

    final grammarMap = <int, GrammarPoint>{};
    if (grammarIds.isNotEmpty) {
      final points = await (db.select(db.grammarPoints)
            ..where((g) => g.id.isIn(grammarIds.toList())))
          .get();
      for (final point in points) {
        grammarMap[point.id] = point;
      }
    }

    return _MistakeDetails(
      vocab: vocabMap,
      grammar: grammarMap,
    );
  }

  _MistakeDisplay _buildMistakeDisplay(
    UserMistake mistake,
    _MistakeDetails details,
    AppLanguage language,
  ) {
    if (mistake.type == 'vocab') {
      final term = details.vocab[mistake.itemId];
      final meaning = _resolveMeaning(
        language,
        term?.definition ?? '',
        term?.definitionEn,
      );
      final reading = (term?.reading ?? '').trim();
      final title = term == null
          ? 'Vocab ID: ${mistake.itemId}'
          : '${term.term}${reading.isNotEmpty ? ' • $reading' : ''}';
      final subtitle = meaning.isNotEmpty
          ? '$meaning • Cần đúng ${mistake.wrongCount} lần'
          : 'Cần đúng ${mistake.wrongCount} lần';
      return _MistakeDisplay(title: title, subtitle: subtitle);
    }

    final grammar = details.grammar[mistake.itemId];
    final meaning = _resolveMeaning(
      language,
      grammar?.meaning ?? '',
      language == AppLanguage.vi ? grammar?.meaningVi : grammar?.meaningEn,
    );
    final title = grammar == null
        ? 'Grammar ID: ${mistake.itemId}'
        : grammar.grammarPoint;
    final subtitle = meaning.isNotEmpty
        ? '$meaning • Cần đúng ${mistake.wrongCount} lần'
        : 'Cần đúng ${mistake.wrongCount} lần';
    return _MistakeDisplay(title: title, subtitle: subtitle);
  }

  String _resolveMeaning(
    AppLanguage language,
    String fallback,
    String? preferred,
  ) {
    final value = (preferred ?? '').trim();
    if (language == AppLanguage.vi) {
      return fallback;
    }
    return value.isNotEmpty ? value : fallback;
  }
}

class _MistakeDetails {
  final Map<int, UserLessonTermData> vocab;
  final Map<int, GrammarPoint> grammar;

  const _MistakeDetails({
    this.vocab = const {},
    this.grammar = const {},
  });
}

class _MistakeDisplay {
  final String title;
  final String subtitle;

  const _MistakeDisplay({
    required this.title,
    required this.subtitle,
  });
}
