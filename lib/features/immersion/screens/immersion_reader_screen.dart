import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

import '../models/immersion_article.dart';
import '../providers/immersion_providers.dart';
import '../services/immersion_service.dart';
import 'dart:async';

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
  Set<String> _savedTokens = {};

  static const int _immersionLessonId = 9999;
  static const String _immersionLessonTitle = 'Immersion Notes';
  static const String _immersionLevel = 'IMMERSION';

  @override
  void initState() {
    super.initState();
    _ensureDetailLoaded();
    _loadSavedTokens();
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

  Future<void> _loadSavedTokens() async {
    final repo = ref.read(lessonRepositoryProvider);
    final terms = await repo.fetchTerms(_immersionLessonId);
    if (!mounted) return;
    setState(() {
      _savedTokens = terms.map((t) => _tokenKey(t.term, t.reading)).toSet();
    });
  }

  String _tokenKey(String surface, String? reading) {
    return '${surface.trim()}|${(reading ?? '').trim()}';
  }

  bool _isTokenSaved(ImmersionToken token) {
    return _savedTokens.contains(_tokenKey(token.surface, token.reading));
  }

  void _markTokenSaved(ImmersionToken token) {
    if (!mounted) return;
    setState(() {
      _savedTokens.add(_tokenKey(token.surface, token.reading));
    });
  }

  // --- Auto Scroll & Read Status ---

  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;
  bool _isAutoScrolling = false;

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _toggleReadStatus() async {
    await ref.read(readArticlesProvider.notifier).toggle(widget.article.id);
  }

  void _toggleAutoScroll() {
    if (_isAutoScrolling) {
      _stopAutoScroll();
    } else {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    setState(() {
      _isAutoScrolling = true;
    });
    // Scroll speed: ~20px every 100ms => 200px/sec (Adjustable)
    const step = 2.0;
    const duration = Duration(milliseconds: 50);
    _autoScrollTimer = Timer.periodic(duration, (timer) {
      if (!_scrollController.hasClients) return;
      
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      
      if (currentScroll >= maxScroll) {
        _stopAutoScroll();
        return;
      }
      
      _scrollController.jumpTo(currentScroll + step);
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    setState(() {
      _isAutoScrolling = false;
    });
  }

  // --- End Auto Scroll & Read Status ---

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final readIds = ref.watch(readArticlesProvider);
    final isRead = readIds.contains(widget.article.id);

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
            isRead,
          );
        },
      );
    }

    return _buildArticleScaffold(context, language, widget.article, isRead);
  }

  Scaffold _buildArticleScaffold(
    BuildContext context,
    AppLanguage language,
    ImmersionArticle article,
    bool isRead,
  ) {
    final dateLabel = MaterialLocalizations.of(
      context,
    ).formatMediumDate(article.publishedAt);
    return Scaffold(
      appBar: AppBar(
        title: Text(language.immersionTitle),
        actions: [
          IconButton(
            onPressed: _toggleReadStatus,
            icon: Icon(
              isRead ? Icons.check_circle : Icons.check_circle_outline,
              color: isRead ? Colors.green : null,
            ),
            tooltip: language.immersionMarkReadLabel,
          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleAutoScroll,
        tooltip: language.immersionAutoScrollLabel,
        child: Icon(_isAutoScrolling ? Icons.pause : Icons.play_arrow),
      ),
      body: ListView(
        controller: _scrollController,
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
          ...article.paragraphs.map(
            (tokens) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Wrap(
                spacing: 4,
                runSpacing: 6,
                children: tokens
                    .map(
                      (token) => _TokenChip(
                        token: token,
                        showFurigana: _showFurigana,
                        language: language,
                        isSaved: _isTokenSaved(token),
                        onTap: token.hasMeaning
                            ? () => _showTokenDetail(token, language)
                            : null,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          if (article.translation != null) ...[
            const SizedBox(height: 12),
            Text(
              language.immersionTranslateLabel,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              article.translation!,
              style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
            ),
          ],
          // Extra space at bottom for scrolling comfortably
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Future<void> _showTokenDetail(
    ImmersionToken token,
    AppLanguage language,
  ) async {
    final isSaved = _isTokenSaved(token);
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
              Text(meaning, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isSaved
                      ? null
                      : () async {
                          await _addToSrs(token, language);
                          if (!context.mounted) {
                            return;
                          }
                          Navigator.pop(context);
                        },
                  icon: const Icon(Icons.add),
                  label: Text(
                    isSaved
                        ? language.immersionAlreadyAddedLabel
                        : language.immersionAddSrsLabel,
                  ),
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
      await repo.ensureSrsStateForTerm(existing.id);
      _markTokenSaved(token);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(language.immersionAlreadyAddedLabel)),
        );
      }
      return;
    }

    final termId = await repo.addTerm(
      _immersionLessonId,
      term: token.surface,
      reading: token.reading,
      definition: token.meaningVi ?? token.meaningEn,
      definitionEn: token.meaningEn,
    );
    await repo.ensureSrsStateForTerm(termId);
    _markTokenSaved(token);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(language.immersionAddedLabel)));
    }
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip({
    required this.token,
    required this.showFurigana,
    required this.language,
    required this.isSaved,
    this.onTap,
  });

  final ImmersionToken token;
  final bool showFurigana;
  final AppLanguage language;
  final bool isSaved;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasMeaning = token.hasMeaning;
    final color = isSaved
        ? const Color(0xFFD1FAE5)
        : hasMeaning
        ? const Color(0xFFE0F2FE)
        : Colors.transparent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: isSaved ? Border.all(color: const Color(0xFF34D399)) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showFurigana &&
                token.reading != null &&
                token.reading!.isNotEmpty)
              Text(
                token.reading!,
                style: const TextStyle(fontSize: 10, color: Color(0xFF6B7390)),
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
