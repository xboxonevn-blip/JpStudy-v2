import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';

import 'models/immersion_article.dart';
import 'providers/immersion_providers.dart';
import 'screens/immersion_reader_screen.dart';
import 'services/immersion_service.dart';

class ImmersionHomeScreen extends ConsumerStatefulWidget {
  const ImmersionHomeScreen({super.key});

  @override
  ConsumerState<ImmersionHomeScreen> createState() =>
      _ImmersionHomeScreenState();
}

class _ImmersionHomeScreenState extends ConsumerState<ImmersionHomeScreen> {
  late Future<List<ImmersionArticle>> _future;
  ImmersionSource _source = ImmersionSource.nhkEasy;

  @override
  void initState() {
    super.initState();
    _future = _loadArticles(forceRefresh: false);
  }

  Future<List<ImmersionArticle>> _loadArticles({
    required bool forceRefresh,
  }) {
    final service = ref.read(immersionServiceProvider);
    switch (_source) {
      case ImmersionSource.nhkEasy:
        return service.loadNhkEasySummaries(forceRefresh: forceRefresh);
      case ImmersionSource.local:
        return service.loadLocalSamples();
    }
  }

  void _setSource(ImmersionSource next) {
    if (_source == next) return;
    setState(() {
      _source = next;
      _future = _loadArticles(forceRefresh: false);
    });
  }

  void _refresh() {
    if (_source != ImmersionSource.nhkEasy) return;
    setState(() {
      _future = _loadArticles(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(language.immersionTitle),
        actions: [
          if (_source == ImmersionSource.nhkEasy)
            IconButton(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              tooltip: language.immersionRefreshLabel,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _buildSourcePicker(language),
          ),
          Expanded(
            child: FutureBuilder<List<ImmersionArticle>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(language.loadErrorLabel));
                }
                final articles = snapshot.data ?? [];
                if (articles.isEmpty) {
                  return Center(child: Text(language.immersionEmptyLabel));
                }
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      language.immersionSubtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7390),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...articles.map((article) => _ArticleCard(
                          article: article,
                          language: language,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ImmersionReaderScreen(
                                  article: article,
                                ),
                              ),
                            );
                          },
                        )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourcePicker(AppLanguage language) {
    return Row(
      children: [
        Text(
          language.immersionSourceLabel,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 12),
        ChoiceChip(
          label: Text(language.immersionSourceNhkLabel),
          selected: _source == ImmersionSource.nhkEasy,
          onSelected: (_) => _setSource(ImmersionSource.nhkEasy),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: Text(language.immersionSourceLocalLabel),
          selected: _source == ImmersionSource.local,
          onSelected: (_) => _setSource(ImmersionSource.local),
        ),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({
    required this.article,
    required this.language,
    required this.onTap,
  });

  final ImmersionArticle article;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        MaterialLocalizations.of(context).formatMediumDate(article.publishedAt);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(article.title),
        subtitle: Text('${article.source} • ${article.level} • $dateLabel'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
