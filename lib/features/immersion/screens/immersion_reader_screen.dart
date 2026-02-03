import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/common/widgets/japanese_background.dart';

import '../models/immersion_article.dart';
import '../providers/immersion_providers.dart';
import '../services/immersion_service.dart';

class ImmersionReaderScreen extends ConsumerStatefulWidget {
  const ImmersionReaderScreen({super.key, required this.article});

  final ImmersionArticle article;

  @override
  ConsumerState<ImmersionReaderScreen> createState() =>
      _ImmersionReaderScreenState();
}

class _ImmersionReaderScreenState extends ConsumerState<ImmersionReaderScreen> {
  static const int _immersionLessonId = 9999;
  static const String _immersionLessonTitle = 'Immersion Notes';
  static const String _immersionLevel = 'IMMERSION';

  bool _showFurigana = true;
  bool _isAutoScrolling = false;
  Future<ImmersionArticle?>? _detailFuture;
  Set<String> _savedTokens = {};

  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _ensureDetailLoaded();
    _loadSavedTokens();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _ensureDetailLoaded({bool forceRefresh = false}) {
    if (widget.article.paragraphs.isNotEmpty) return;
    if (widget.article.source != ImmersionService.nhkSourceLabel) return;
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

    const step = 1.8;
    const duration = Duration(milliseconds: 40);
    _autoScrollTimer = Timer.periodic(duration, (timer) {
      if (!_scrollController.hasClients) return;
      final maxScroll = _scrollController.position.maxScrollExtent;
      final current = _scrollController.offset;
      if (current >= maxScroll) {
        _stopAutoScroll();
        return;
      }
      _scrollController.jumpTo((current + step).clamp(0, maxScroll));
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    setState(() {
      _isAutoScrolling = false;
    });
  }

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
            return _buildLoading(language);
          }
          if (snapshot.hasError || snapshot.data == null) {
            return _buildError(language);
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

  Scaffold _buildLoading(AppLanguage language) {
    return Scaffold(
      appBar: AppBar(title: Text(language.immersionTitle)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Scaffold _buildError(AppLanguage language) {
    return Scaffold(
      appBar: AppBar(title: Text(language.immersionTitle)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                language.immersionFallbackToLocalLabel,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _ensureDetailLoaded(forceRefresh: true);
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(language.retryLabel),
            ),
          ],
        ),
      ),
    );
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(language.immersionTitle),
        actions: [
          IconButton(
            tooltip: language.immersionMarkReadLabel,
            onPressed: _toggleReadStatus,
            icon: Icon(
              isRead ? Icons.check_circle_rounded : Icons.check_circle_outline,
              color: isRead ? const Color(0xFF059669) : null,
            ),
          ),
          IconButton(
            tooltip: language.immersionFuriganaLabel,
            onPressed: () {
              setState(() {
                _showFurigana = !_showFurigana;
              });
            },
            icon: Icon(
              _showFurigana
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
            ),
          ),
          IconButton(
            tooltip: language.immersionAutoScrollLabel,
            onPressed: _toggleAutoScroll,
            icon: Icon(
              _isAutoScrolling
                  ? Icons.pause_circle_rounded
                  : Icons.play_circle_rounded,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleAutoScroll,
        icon: Icon(
          _isAutoScrolling ? Icons.pause_rounded : Icons.play_arrow_rounded,
        ),
        label: Text(language.immersionAutoScrollLabel),
      ),
      body: JapaneseBackground(
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 92),
          children: [
            _ArticleHeaderCard(
              title: article.title,
              titleFurigana: article.titleFurigana,
              source: article.source,
              level: article.level,
              dateLabel: dateLabel,
              showFurigana: _showFurigana,
              isRead: isRead,
              language: language,
            ),
            const SizedBox(height: 14),
            ...article.paragraphs.map(
              (tokens) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ParagraphCard(
                  children: tokens
                      .map(
                        (token) => _TokenChip(
                          token: token,
                          showFurigana: _showFurigana,
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
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDCE8F8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.immersionTranslateLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.translation!,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
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
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (token.reading != null && token.reading!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  token.reading!,
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
              ],
              const SizedBox(height: 10),
              Text(meaning, style: const TextStyle(fontSize: 14, height: 1.4)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isSaved
                      ? null
                      : () async {
                          await _addToSrs(token, language);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        },
                  icon: const Icon(Icons.add_rounded),
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

class _ArticleHeaderCard extends StatelessWidget {
  const _ArticleHeaderCard({
    required this.title,
    required this.titleFurigana,
    required this.source,
    required this.level,
    required this.dateLabel,
    required this.showFurigana,
    required this.isRead,
    required this.language,
  });

  final String title;
  final String? titleFurigana;
  final String source;
  final String level;
  final String dateLabel;
  final bool showFurigana;
  final bool isRead;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final heading = (titleFurigana?.trim().isNotEmpty == true && showFurigana)
        ? titleFurigana!
        : title;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF5FAFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDCE8F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
              height: 1.28,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _TinyTag(label: source),
              _TinyTag(label: level),
              _TinyTag(label: dateLabel),
              _TinyTag(
                label: isRead
                    ? language.doneLabel
                    : language.immersionMarkReadLabel,
                emphasize: isRead,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParagraphCard extends StatelessWidget {
  const _ParagraphCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCE8F8)),
      ),
      child: Wrap(spacing: 4, runSpacing: 6, children: children),
    );
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip({
    required this.token,
    required this.showFurigana,
    required this.isSaved,
    this.onTap,
  });

  final ImmersionToken token;
  final bool showFurigana;
  final bool isSaved;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasMeaning = token.hasMeaning;
    final bg = isSaved
        ? const Color(0xFFDCFCE7)
        : hasMeaning
        ? const Color(0xFFE0F2FE)
        : const Color(0xFFF8FAFC);
    final border = isSaved
        ? const Color(0xFF86EFAC)
        : hasMeaning
        ? const Color(0xFFBAE6FD)
        : const Color(0xFFE2E8F0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border),
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
                    color: Color(0xFF64748B),
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    token.surface,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: hasMeaning
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  if (isSaved) ...[
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 12,
                      color: Color(0xFF16A34A),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TinyTag extends StatelessWidget {
  const _TinyTag({required this.label, this.emphasize = false});

  final String label;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: emphasize ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: emphasize ? const Color(0xFF166534) : const Color(0xFF475569),
        ),
      ),
    );
  }
}
