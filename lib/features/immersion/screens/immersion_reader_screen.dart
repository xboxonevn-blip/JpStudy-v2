import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

import '../models/immersion_article.dart';
import '../providers/immersion_providers.dart';
import '../services/immersion_service.dart';

class ImmersionReaderScreen extends ConsumerStatefulWidget {
  final ImmersionArticle article;

  const ImmersionReaderScreen({super.key, required this.article});

  @override
  ConsumerState<ImmersionReaderScreen> createState() =>
      _ImmersionReaderScreenState();
}

class _ImmersionReaderScreenState extends ConsumerState<ImmersionReaderScreen> {
  bool _showFurigana = true;
  Future<ImmersionArticle?>? _detailFuture;

  static const int _immersionLessonId = 9999;
  static const String _immersionLessonTitle = 'Immersion Notes';
  static const String _immersionLevel = 'IMMERSION';

  @override
  void initState() {
    super.initState();
    _ensureDetailLoaded();
  }

  void _ensureDetailLoaded({bool forceRefresh = false}) {
    if (widget.article.paragraphs.isNotEmpty) {
      return;
    }
    if (widget.article.source != ImmersionService.nhkSourceLabel) {
      return;
    }
    _detailFuture = ref
        .read(immersionServiceProvider)
        .loadNhkArticleDetail(widget.article.id, forceRefresh: forceRefresh);
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);

    if (_detailFuture != null) {
      return FutureBuilder<ImmersionArticle?>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(title: Text(language.immersionTitle)),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(title: Text(language.immersionTitle)),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(language.loadErrorLabel),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _ensureDetailLoaded(forceRefresh: true);
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(language.immersionRefreshLabel),
                    ),
                  ],
                ),
              ),
            );
          }
          return _buildArticleScaffold(
            context,
            language,
            snapshot.data!,
          );
        },
      );
    }

    return _buildArticleScaffold(context, language, widget.article);
  }

  Scaffold _buildArticleScaffold(
    BuildContext context,
    AppLanguage language,
    ImmersionArticle article,
  ) {
    final dateLabel =
        MaterialLocalizations.of(context).formatMediumDate(article.publishedAt);
    return Scaffold(
      appBar: AppBar(
        title: Text(language.immersionTitle),
        actions: [
          Row(
            children: [
              Text(language.immersionFuriganaLabel),
              Switch(
                value: _showFurigana,
                onChanged: (value) {
                  setState(() {
                    _showFurigana = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            article.titleFurigana != null && _showFurigana
                ? article.titleFurigana!
                : article.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            '${article.source} • ${article.level} • $dateLabel',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7390)),
          ),
          const SizedBox(height: 16),
          ...article.paragraphs.map((tokens) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 6,
                  children: tokens
                      .map((token) => _TokenChip(
                            token: token,
                            showFurigana: _showFurigana,
                            language: language,
                            onTap: token.hasMeaning
                                ? () => _showTokenDetail(token, language)
                                : null,
                          ))
                      .toList(),
                ),
              )),
          if (article.translation != null) ...[
            const SizedBox(height: 12),
            Text(
              language.immersionTranslateLabel,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              article.translation!,
              style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showTokenDetail(
    ImmersionToken token,
    AppLanguage language,
  ) async {
    final meaning = language == AppLanguage.en
        ? (token.meaningEn?.trim().isNotEmpty == true
            ? token.meaningEn!
            : token.meaningVi ?? '')
        : (token.meaningVi?.trim().isNotEmpty == true
            ? token.meaningVi!
            : token.meaningEn ?? '');

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                token.surface,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (token.reading != null && token.reading!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  token.reading!,
                  style: const TextStyle(color: Color(0xFF6B7390)),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                meaning,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _addToSrs(token, language);
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add),
                  label: Text(language.immersionAddSrsLabel),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addToSrs(ImmersionToken token, AppLanguage language) async {
    final repo = ref.read(lessonRepositoryProvider);
    await repo.ensureLesson(
      lessonId: _immersionLessonId,
      level: _immersionLevel,
      title: _immersionLessonTitle,
    );

    final existing = await repo.findTermInLesson(
      _immersionLessonId,
      token.surface,
      token.reading,
    );
    if (existing != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(language.immersionAlreadyAddedLabel)),
        );
      }
      return;
    }

    await repo.addTerm(
      _immersionLessonId,
      term: token.surface,
      reading: token.reading,
      definition: token.meaningVi ?? token.meaningEn,
      definitionEn: token.meaningEn,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language.immersionAddedLabel)),
      );
    }
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip({
    required this.token,
    required this.showFurigana,
    required this.language,
    this.onTap,
  });

  final ImmersionToken token;
  final bool showFurigana;
  final AppLanguage language;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasMeaning = token.hasMeaning;
    final color = hasMeaning ? const Color(0xFFE0F2FE) : Colors.transparent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showFurigana &&
                token.reading != null &&
                token.reading!.isNotEmpty)
              Text(
                token.reading!,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7390),
                ),
              ),
            Text(
              token.surface,
              style: TextStyle(
                fontSize: 16,
                fontWeight: hasMeaning ? FontWeight.w600 : FontWeight.w400,
                color: hasMeaning ? Colors.black : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
