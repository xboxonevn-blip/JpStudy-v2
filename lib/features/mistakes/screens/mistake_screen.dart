import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_language.dart';
import '../../../core/language_provider.dart';
import '../../home/providers/dashboard_provider.dart';
import '../repositories/mistake_repository.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/models/vocab_item.dart';
import '../../../data/models/kanji_item.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../learn/models/learn_session_args.dart';
import 'package:go_router/go_router.dart';
import '../../../data/db/app_database.dart';
import '../../write/screens/handwriting_practice_screen.dart';

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
    final lessonRepo = ref.watch(lessonRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(language.mistakeBankTitle)),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    language.mistakeEmptyTitle,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    language.mistakeEmptySubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF6B7390)),
                  ),
                ],
              ),
            );
          }

          return FutureBuilder<_MistakeDetails>(
            future: _loadMistakeDetails(allMistakes, db, lessonRepo),
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
                        final display = _buildMistakeDisplay(
                          mistake,
                          details,
                          language,
                        );
                        final contextLines = _buildContextLines(
                          mistake,
                          language,
                        );
                        final icon = _mistakeIcon(mistake.type);
                        final color = _mistakeColor(mistake.type);

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: Icon(icon, color: color),
                            title: Text(display.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(display.subtitle),
                                if (contextLines.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  ...contextLines.map(
                                    (line) => Text(
                                      line,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7390),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
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
                          ),
                        );
                      },
                    ),
                  ),
                  _buildPracticeActions(
                    context,
                    ref,
                    allMistakes,
                    details,
                    language,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPracticeActions(
    BuildContext context,
    WidgetRef ref,
    List<UserMistake> mistakes,
    _MistakeDetails details,
    AppLanguage language,
  ) {
    final vocabIds = <int>{};
    final preferContentVocabIds = <int>{};
    final grammarIds = <int>{};
    final kanjiIds = <int>{};
    final kanjiByLesson = <int, List<int>>{};

    for (final m in mistakes) {
      if (m.type == 'vocab') {
        vocabIds.add(m.itemId);
        final extra = _parseExtraJson(m.extraJson);
        final vocabSource = (extra['vocabSource'] ?? '').toString().trim();
        if (vocabSource == 'content') {
          preferContentVocabIds.add(m.itemId);
        }
      } else if (m.type == 'grammar') {
        grammarIds.add(m.itemId);
      } else if (m.type == 'kanji') {
        kanjiIds.add(m.itemId);
        final kanji = details.kanji[m.itemId];
        if (kanji != null) {
          kanjiByLesson.putIfAbsent(kanji.lessonId, () => []).add(m.itemId);
        }
      }
    }

    final actions = <Widget>[];
    if (vocabIds.isNotEmpty) {
      actions.add(
        _buildPracticeButton(
          icon: Icons.translate,
          label: language.practiceVocabMistakesLabel(vocabIds.length),
          onPressed: () => _startVocabPractice(
            context,
            vocabIds.toList(),
            details,
            language,
            preferContentIds: preferContentVocabIds,
          ),
        ),
      );
    }
    if (grammarIds.isNotEmpty) {
      actions.add(
        _buildPracticeButton(
          icon: Icons.menu_book_rounded,
          label: language.practiceGrammarMistakesLabel(grammarIds.length),
          onPressed: () => _startGrammarPractice(context, grammarIds.toList()),
        ),
      );
    }
    if (kanjiIds.isNotEmpty) {
      actions.add(
        _buildPracticeButton(
          icon: Icons.edit_rounded,
          label: language.practiceKanjiMistakesLabel(kanjiIds.length),
          onPressed: () => _startKanjiPractice(
            context,
            kanjiIds.toList(),
            details,
            language,
          ),
        ),
      );
      if (kanjiByLesson.length > 1) {
        final sortedLessons = kanjiByLesson.keys.toList()..sort();
        for (final lessonId in sortedLessons) {
          final ids = kanjiByLesson[lessonId]!;
          actions.add(
            _buildPracticeButton(
              icon: Icons.layers_clear_rounded,
              label:
                  '${language.practiceKanjiMistakesLabel(ids.length)} • '
                  '${language.lessonLabel} $lessonId',
              onPressed: () =>
                  _startKanjiPractice(context, ids, details, language),
            ),
          );
        }
      }
    }

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      child: Column(
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            actions[i],
            if (i != actions.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildPracticeButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }

  Future<void> _startVocabPractice(
    BuildContext context,
    List<int> vocabIds,
    _MistakeDetails details,
    AppLanguage language, {
    required Set<int> preferContentIds,
  }) async {
    final items = <VocabItem>[];
    for (final id in vocabIds) {
      final term = details.vocab[id];
      final fallback = details.vocabFallback[id];
      if (term == null && fallback == null) continue;
      final preferContent = preferContentIds.contains(id);

      if (preferContent && fallback != null) {
        items.add(
          VocabItem(
            id: fallback.id,
            term: fallback.term,
            reading: fallback.reading,
            meaning: fallback.meaning,
            meaningEn: fallback.meaningEn,
            kanjiMeaning: fallback.kanjiMeaning,
            level: fallback.level,
          ),
        );
      } else if (term != null) {
        items.add(
          VocabItem(
            id: term.id,
            term: term.term,
            reading: term.reading,
            meaning: term.definition,
            meaningEn: term.definitionEn,
            kanjiMeaning: term.kanjiMeaning,
            level: 'Unknown',
          ),
        );
      } else if (fallback != null) {
        items.add(
          VocabItem(
            id: fallback.id,
            term: fallback.term,
            reading: fallback.reading,
            meaning: fallback.meaning,
            meaningEn: fallback.meaningEn,
            kanjiMeaning: fallback.kanjiMeaning,
            level: fallback.level,
          ),
        );
      }
    }

    if (items.isEmpty || !context.mounted) return;
    context.push(
      '/learn/session',
      extra: LearnSessionArgs(
        lessonId: -999,
        lessonTitle: language.mistakesLabel,
        items: items,
      ),
    );
  }

  void _startGrammarPractice(BuildContext context, List<int> grammarIds) {
    if (grammarIds.isEmpty || !context.mounted) return;
    context.push('/grammar-practice', extra: grammarIds);
  }

  Future<void> _startKanjiPractice(
    BuildContext context,
    List<int> kanjiIds,
    _MistakeDetails details,
    AppLanguage language,
  ) async {
    final items = <KanjiItem>[];
    for (final id in kanjiIds) {
      final item = details.kanji[id];
      if (item != null) {
        items.add(item);
      }
    }
    if (items.isEmpty || !context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HandwritingPracticeScreen(
          lessonTitle: language.ghostKanjiTitle,
          items: items,
        ),
      ),
    );
  }

  Future<_MistakeDetails> _loadMistakeDetails(
    List<UserMistake> mistakes,
    AppDatabase db,
    LessonRepository lessonRepo,
  ) async {
    final lessonVocabIds = <int>{};
    final contentVocabIds = <int>{};
    final grammarIds = <int>{};
    final kanjiIds = <int>{};
    for (final mistake in mistakes) {
      if (mistake.type == 'vocab') {
        final extra = _parseExtraJson(mistake.extraJson);
        final vocabSource = (extra['vocabSource'] ?? '').toString().trim();
        if (vocabSource == 'content') {
          contentVocabIds.add(mistake.itemId);
        } else {
          // Legacy rows (without vocabSource) are treated as lesson first
          // and can still fallback to content lookup when missing.
          lessonVocabIds.add(mistake.itemId);
        }
      } else if (mistake.type == 'grammar') {
        grammarIds.add(mistake.itemId);
      } else if (mistake.type == 'kanji') {
        kanjiIds.add(mistake.itemId);
      }
    }

    final vocabMap = <int, UserLessonTermData>{};
    if (lessonVocabIds.isNotEmpty) {
      final terms = await (db.select(
        db.userLessonTerm,
      )..where((t) => t.id.isIn(lessonVocabIds.toList()))).get();
      for (final term in terms) {
        vocabMap[term.id] = term;
      }
    }

    final vocabFallbackMap = <int, VocabItem>{};
    final fallbackIds = <int>{
      ...contentVocabIds,
      ...lessonVocabIds.where((id) => !vocabMap.containsKey(id)),
    }.toList();
    if (fallbackIds.isNotEmpty) {
      final fallbackItems = await lessonRepo.fetchContentVocabByIds(
        fallbackIds,
      );
      for (final item in fallbackItems) {
        vocabFallbackMap[item.id] = item;
      }
    }

    final grammarMap = <int, GrammarPoint>{};
    if (grammarIds.isNotEmpty) {
      final points = await (db.select(
        db.grammarPoints,
      )..where((g) => g.id.isIn(grammarIds.toList()))).get();
      for (final point in points) {
        grammarMap[point.id] = point;
      }
    }

    final kanjiMap = <int, KanjiItem>{};
    if (kanjiIds.isNotEmpty) {
      final items = await lessonRepo.fetchKanjiByIds(kanjiIds.toList());
      for (final item in items) {
        kanjiMap[item.id] = item;
      }
    }

    return _MistakeDetails(
      vocab: vocabMap,
      vocabFallback: vocabFallbackMap,
      grammar: grammarMap,
      kanji: kanjiMap,
    );
  }

  _MistakeDisplay _buildMistakeDisplay(
    UserMistake mistake,
    _MistakeDetails details,
    AppLanguage language,
  ) {
    final remainingLabel = language.mistakeRemainingLabel(mistake.wrongCount);
    if (mistake.type == 'vocab') {
      final extra = _parseExtraJson(mistake.extraJson);
      final preferContent =
          (extra['vocabSource'] ?? '').toString().trim() == 'content';
      final term = preferContent ? null : details.vocab[mistake.itemId];
      final fallback = details.vocabFallback[mistake.itemId];
      final meaning = term != null
          ? _resolveMeaning(language, term.definition, term.definitionEn)
          : _resolveMeaning(
              language,
              fallback?.meaning ?? '',
              fallback?.meaningEn,
            );
      final reading = (term?.reading ?? fallback?.reading ?? '').trim();
      final termText = term?.term ?? fallback?.term;
      final title = termText == null
          ? language.mistakeItemIdLabel(mistake.itemId)
          : '$termText${reading.isNotEmpty ? ' - $reading' : ''}';
      final subtitle = meaning.isNotEmpty
          ? '$meaning - $remainingLabel'
          : remainingLabel;
      return _MistakeDisplay(title: title, subtitle: subtitle);
    }

    if (mistake.type == 'kanji') {
      final kanji = details.kanji[mistake.itemId];
      final meaning = kanji == null
          ? ''
          : _resolveMeaning(language, kanji.meaning, kanji.meaningEn);
      final readingParts = [
        if ((kanji?.onyomi ?? '').trim().isNotEmpty) kanji!.onyomi!,
        if ((kanji?.kunyomi ?? '').trim().isNotEmpty) kanji!.kunyomi!,
      ];
      final reading = readingParts.join(' - ');
      final title = kanji == null
          ? language.mistakeItemIdLabel(mistake.itemId)
          : kanji.character;
      final subtitle = [
        if (meaning.isNotEmpty) meaning,
        if (reading.isNotEmpty) reading,
        if (kanji != null) '${language.lessonLabel} ${kanji.lessonId}',
        remainingLabel,
      ].join(' - ');
      return _MistakeDisplay(title: title, subtitle: subtitle);
    }

    final grammar = details.grammar[mistake.itemId];
    final meaning = _resolveMeaning(
      language,
      grammar?.meaning ?? '',
      language == AppLanguage.vi ? grammar?.meaningVi : grammar?.meaningEn,
    );
    final title = grammar == null
        ? language.mistakeItemIdLabel(mistake.itemId)
        : grammar.grammarPoint;
    final subtitle = meaning.isNotEmpty
        ? '$meaning - $remainingLabel'
        : remainingLabel;
    return _MistakeDisplay(title: title, subtitle: subtitle);
  }

  List<String> _buildContextLines(UserMistake mistake, AppLanguage language) {
    final lines = <String>[];
    final prompt = (mistake.prompt ?? '').trim();
    if (prompt.isNotEmpty) {
      lines.add('${language.mistakePromptLabel}: $prompt');
    }
    final userAnswer = (mistake.userAnswer ?? '').trim();
    if (userAnswer.isNotEmpty) {
      lines.add('${language.mistakeYourAnswerLabel}: $userAnswer');
    }
    final correct = (mistake.correctAnswer ?? '').trim();
    if (correct.isNotEmpty) {
      lines.add('${language.mistakeCorrectAnswerLabel}: $correct');
    }
    final extra = _parseExtraJson(mistake.extraJson);
    final strokeSummary = _strokeSummary(extra, language);
    if (strokeSummary != null) {
      lines.add(strokeSummary);
    }
    final sourceLabel = _sourceLabel(language, mistake.source);
    if (sourceLabel.isNotEmpty) {
      lines.add('${language.mistakeSourceLabel}: $sourceLabel');
    }
    return lines;
  }

  Map<String, dynamic> _parseExtraJson(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const {};
    try {
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return const {};
  }

  String? _strokeSummary(Map<String, dynamic> extra, AppLanguage language) {
    final expected = extra['expectedStrokes'];
    final drawn = extra['drawnStrokes'];
    if (expected is num && drawn is num) {
      return language.mistakeStrokeSummaryLabel(
        drawn.toInt(),
        expected.toInt(),
      );
    }
    return null;
  }

  String _sourceLabel(AppLanguage language, String? source) {
    switch (source) {
      case 'learn':
        return language.mistakeSourceLearnLabel;
      case 'review':
        return language.mistakeSourceReviewLabel;
      case 'lesson_review':
        return language.mistakeSourceLessonReviewLabel;
      case 'test':
        return language.mistakeSourceTestLabel;
      case 'grammar_practice':
        return language.mistakeSourceGrammarPracticeLabel;
      case 'handwriting':
        return language.mistakeSourceHandwritingLabel;
      case 'match_game':
        return language.practiceMatchLabel;
      case 'kanji_dash':
        return language.practiceKanjiDashLabel;
      default:
        return (source ?? '').trim();
    }
  }

  IconData _mistakeIcon(String type) {
    switch (type) {
      case 'vocab':
        return Icons.translate;
      case 'grammar':
        return Icons.menu_book_rounded;
      case 'kanji':
        return Icons.edit_rounded;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  Color _mistakeColor(String type) {
    switch (type) {
      case 'vocab':
        return Colors.orange;
      case 'grammar':
        return Colors.purple;
      case 'kanji':
        return const Color(0xFF0F766E);
      default:
        return Colors.grey;
    }
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
  final Map<int, VocabItem> vocabFallback;
  final Map<int, GrammarPoint> grammar;
  final Map<int, KanjiItem> kanji;

  const _MistakeDetails({
    this.vocab = const {},
    this.vocabFallback = const {},
    this.grammar = const {},
    this.kanji = const {},
  });
}

class _MistakeDisplay {
  final String title;
  final String subtitle;

  const _MistakeDisplay({required this.title, required this.subtitle});
}
