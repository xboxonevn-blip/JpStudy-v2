import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/repositories/conjugation_repository.dart';
import 'package:jpstudy/features/conjugation/models/conjugation_practice_args.dart';
import 'package:jpstudy/features/interlink/widgets/related_section.dart';

class ConjugationHubScreen extends ConsumerStatefulWidget {
  const ConjugationHubScreen({super.key, this.contentVocabId});

  final int? contentVocabId;

  @override
  ConsumerState<ConjugationHubScreen> createState() =>
      _ConjugationHubScreenState();
}

class _ConjugationHubScreenState extends ConsumerState<ConjugationHubScreen> {
  late Future<List<ConjugationLemmaData>> _lemmasFuture;
  var _query = '';
  var _filter = _ConjugationKindFilter.all;

  @override
  void initState() {
    super.initState();
    _lemmasFuture = _loadLemmas();
  }

  Future<List<ConjugationLemmaData>> _loadLemmas() {
    final level = ref.read(studyLevelProvider)?.shortLabel ?? 'N5';
    final repo = ref.read(conjugationRepositoryProvider);
    return widget.contentVocabId == null
        ? repo.fetchByLevel(level)
        : repo.fetchByContentVocabIds([widget.contentVocabId!]);
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(_tr(language, 'Conjugation', 'Chia thể', '活用')),
      ),
      body: FutureBuilder(
        future: _lemmasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final lemmas = snapshot.data ?? const [];
          final visible = _filterLemmas(lemmas);
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
                TextField(
                  key: const ValueKey('conjugation_search_field'),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded),
                    labelText: _tr(
                      language,
                      'Search lemma',
                      'Tìm động từ/tính từ',
                      '語を検索',
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      key: const ValueKey('conjugation_filter_all'),
                      selected: _filter == _ConjugationKindFilter.all,
                      label: Text(_tr(language, 'All', 'Tất cả', 'すべて')),
                      onSelected: (_) =>
                          setState(() => _filter = _ConjugationKindFilter.all),
                    ),
                    FilterChip(
                      key: const ValueKey('conjugation_filter_verb'),
                      selected: _filter == _ConjugationKindFilter.verb,
                      label: Text(_tr(language, 'Verbs', 'Động từ', '動詞')),
                      onSelected: (_) =>
                          setState(() => _filter = _ConjugationKindFilter.verb),
                    ),
                    FilterChip(
                      key: const ValueKey('conjugation_filter_adjective'),
                      selected: _filter == _ConjugationKindFilter.adjective,
                      label: Text(
                        _tr(language, 'Adjectives', 'Tính từ', '形容詞'),
                      ),
                      onSelected: (_) => setState(
                        () => _filter = _ConjugationKindFilter.adjective,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: Text(
                    _tr(
                      language,
                      'Practice 50+ forms',
                      'Luyện chia thể 50+ câu',
                      '50問以上の活用練習',
                    ),
                  ),
                  onPressed: () {
                    context.pushNamed(
                      AppRouteName.grammarConjugationPractice,
                      extra: ConjugationPracticeArgs(
                        contentVocabIds: widget.contentVocabId == null
                            ? null
                            : [widget.contentVocabId!],
                        targetCount: 50,
                        source: 'conjugation_practice',
                      ),
                    );
                  },
                ),
                if (widget.contentVocabId != null && lemmas.length == 1) ...[
                  const SizedBox(height: 12),
                  RelatedSection.lookup(
                    type: 'conjugation',
                    level: lemmas.single.level,
                    lookupId:
                        'conjugation:${lemmas.single.level.toLowerCase()}:${lemmas.single.id}',
                    label: lemmas.single.dictionaryForm,
                    language: language,
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  _tr(
                    language,
                    '${visible.length} shown',
                    'Đang hiện ${visible.length} mục',
                    '${visible.length}語を表示',
                  ),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: visible.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final lemma = visible[index];
                      return ListTile(
                        dense: true,
                        title: Text(lemma.dictionaryForm),
                        subtitle: Text(
                          [
                            lemma.dictionaryReading,
                            _kindLabel(language, lemma.kind),
                            lemma.conjugationClass,
                          ].whereType<String>().join(' · '),
                        ),
                        trailing: Text(lemma.level),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<ConjugationLemmaData> _filterLemmas(List<ConjugationLemmaData> lemmas) {
    final normalizedQuery = _query.trim().toLowerCase();
    return lemmas
        .where((lemma) {
          final kindMatch = switch (_filter) {
            _ConjugationKindFilter.all => true,
            _ConjugationKindFilter.verb => lemma.kind == 'verb',
            _ConjugationKindFilter.adjective => lemma.kind != 'verb',
          };
          if (!kindMatch) return false;
          if (normalizedQuery.isEmpty) return true;
          return lemma.dictionaryForm.toLowerCase().contains(normalizedQuery) ||
              (lemma.dictionaryReading ?? '').toLowerCase().contains(
                normalizedQuery,
              );
        })
        .toList(growable: false);
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

  String _kindLabel(AppLanguage language, String kind) {
    if (kind == 'verb') {
      return _tr(language, 'verb', 'động từ', '動詞');
    }
    return _tr(language, 'adjective', 'tính từ', '形容詞');
  }
}

enum _ConjugationKindFilter { all, verb, adjective }
