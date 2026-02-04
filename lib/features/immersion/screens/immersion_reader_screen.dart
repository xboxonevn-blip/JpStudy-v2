import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _showTranslation = true;
  bool _isAutoScrolling = false;
  Future<ImmersionArticle?>? _detailFuture;
  Set<String> _savedTokens = {};
  Map<String, ImmersionToken> _unknownQueue = {};
  List<_ImmersionQuizQuestion> _quizQuestions = const [];
  Map<int, int> _quizAnswers = {};
  bool _quizSubmitted = false;
  String? _quizForArticleId;
  AppLanguage? _quizLanguage;
  List<ImmersionQuizAttempt> _quizHistory = const [];
  _QuizHistoryFilter _quizHistoryFilter = _QuizHistoryFilter.week;

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

  void _ensureArticleSession(ImmersionArticle article, AppLanguage language) {
    if (_quizForArticleId == article.id && _quizLanguage == language) return;
    _quizForArticleId = article.id;
    _quizLanguage = language;
    _unknownQueue = {};
    _quizAnswers = {};
    _quizSubmitted = false;
    _quizHistory = const [];
    _quizHistoryFilter = _QuizHistoryFilter.week;
    _quizQuestions = _buildQuizQuestions(article, language);
    unawaited(_loadQuizHistory(article.id));
  }

  Future<void> _loadQuizHistory(String articleId) async {
    final history = await ref
        .read(immersionServiceProvider)
        .getQuizHistory(articleId);
    if (!mounted || _quizForArticleId != articleId) return;
    setState(() {
      _quizHistory = history;
    });
  }

  List<_ImmersionQuizQuestion> _buildQuizQuestions(
    ImmersionArticle article,
    AppLanguage language,
  ) {
    final random = Random(article.id.hashCode);
    final allTokens = article.paragraphs.expand((p) => p).toList();

    final vocabCandidates = <_QuizVocab>[];
    final seenVocab = <String>{};
    for (final token in allTokens) {
      final meaning = _quizMeaning(token, language);
      if (meaning == null) continue;
      final key = '${token.surface.trim()}|$meaning';
      if (seenVocab.add(key)) {
        vocabCandidates.add(_QuizVocab(token: token, meaning: meaning));
      }
    }

    if (vocabCandidates.length >= 4) {
      vocabCandidates.shuffle(random);
      final questions = <_ImmersionQuizQuestion>[];
      final total = min(3, vocabCandidates.length);
      for (int i = 0; i < total; i++) {
        final current = vocabCandidates[i];
        final distractors = vocabCandidates
            .where((candidate) => candidate.meaning != current.meaning)
            .map((candidate) => candidate.meaning)
            .toSet()
            .toList();
        distractors.shuffle(random);
        final options = <String>{
          current.meaning,
          ...distractors.take(3),
        }.toList();
        options.shuffle(random);
        final correctIndex = options.indexOf(current.meaning);
        if (correctIndex < 0 || options.length < 3) continue;
        questions.add(
          _ImmersionQuizQuestion(
            prompt: _quizMeaningPrompt(language, current.token.surface),
            options: options,
            correctIndex: correctIndex,
          ),
        );
      }
      if (questions.length >= 2) {
        return questions;
      }
    }

    final wordCandidates = <String>[];
    final seenWords = <String>{};
    for (final token in allTokens) {
      final surface = token.surface.trim();
      if (!_isQuizSurfaceCandidate(surface)) continue;
      if (seenWords.add(surface)) {
        wordCandidates.add(surface);
      }
    }
    if (wordCandidates.length < 4) return const [];
    wordCandidates.shuffle(random);

    final paragraphTexts = article.paragraphs
        .map((tokens) => tokens.map((token) => token.surface).join())
        .where((text) => text.trim().isNotEmpty)
        .toList();

    final questions = <_ImmersionQuizQuestion>[];
    final total = min(3, wordCandidates.length);
    for (int i = 0; i < total; i++) {
      final target = wordCandidates[i];
      String contextText = paragraphTexts.firstWhere(
        (text) => text.contains(target),
        orElse: () => paragraphTexts.isNotEmpty ? paragraphTexts.first : '',
      );
      if (contextText.isEmpty) continue;
      contextText = contextText.replaceFirst(target, '____');
      if (contextText.length > 70) {
        contextText = '${contextText.substring(0, 70)}...';
      }
      final distractors =
          wordCandidates.where((word) => word != target).toList()
            ..shuffle(random);
      final options = <String>[target, ...distractors.take(3)];
      options.shuffle(random);
      final correctIndex = options.indexOf(target);
      if (correctIndex < 0 || options.length < 3) continue;
      questions.add(
        _ImmersionQuizQuestion(
          prompt: _quizClozePrompt(language, contextText),
          options: options,
          correctIndex: correctIndex,
        ),
      );
    }
    return questions.length >= 2 ? questions : const [];
  }

  bool _isQuizSurfaceCandidate(String surface) {
    if (surface.length < 2 || surface.length > 10) return false;
    if (RegExp(r'^[\s\d\.,!?;:(){}\[\]「」『』（）・…\-]+$').hasMatch(surface)) {
      return false;
    }
    return RegExp(r'[\u3040-\u30FF\u3400-\u9FFF]').hasMatch(surface);
  }

  String? _quizMeaning(ImmersionToken token, AppLanguage language) {
    final vi = token.meaningVi?.trim();
    final en = token.meaningEn?.trim();
    if (language == AppLanguage.en) {
      if (en != null && en.isNotEmpty) return en;
      if (vi != null && vi.isNotEmpty) return vi;
      return null;
    }
    if (vi != null && vi.isNotEmpty) return vi;
    if (en != null && en.isNotEmpty) return en;
    return null;
  }

  String _quizMeaningPrompt(AppLanguage language, String surface) {
    switch (language) {
      case AppLanguage.en:
        return 'What does "$surface" mean?';
      case AppLanguage.vi:
        return '“$surface” có nghĩa là gì?';
      case AppLanguage.ja:
        return '「$surface」の意味は？';
    }
  }

  String _quizClozePrompt(AppLanguage language, String context) {
    switch (language) {
      case AppLanguage.en:
        return 'Choose the best word for this blank:\n$context';
      case AppLanguage.vi:
        return 'Chọn từ phù hợp cho chỗ trống:\n$context';
      case AppLanguage.ja:
        return '空欄に入る語を選んでください:\n$context';
    }
  }

  String _quizTitle(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'Mini Quiz';
      case AppLanguage.vi:
        return 'Mini Quiz';
      case AppLanguage.ja:
        return 'ミニクイズ';
    }
  }

  String _quizSubtitle(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return '2-3 quick questions to confirm understanding.';
      case AppLanguage.vi:
        return '2-3 câu nhanh để kiểm tra mức hiểu bài.';
      case AppLanguage.ja:
        return '理解度を確認する2〜3問の小テストです。';
    }
  }

  String _quizSubmitLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'Check answers';
      case AppLanguage.vi:
        return 'Chấm điểm';
      case AppLanguage.ja:
        return '答え合わせ';
    }
  }

  String _quizRetryLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'Try again';
      case AppLanguage.vi:
        return 'Làm lại';
      case AppLanguage.ja:
        return 'もう一度';
    }
  }

  String _quizScoreLabel(AppLanguage language, int correct, int total) {
    switch (language) {
      case AppLanguage.en:
        return 'Score: $correct/$total';
      case AppLanguage.vi:
        return 'Điểm: $correct/$total';
      case AppLanguage.ja:
        return 'スコア: $correct/$total';
    }
  }

  String _quizHistoryTitle(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'History';
      case AppLanguage.vi:
        return 'Lịch sử';
      case AppLanguage.ja:
        return '履歴';
    }
  }

  String _quizHistoryEmptyLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'No attempts yet.';
      case AppLanguage.vi:
        return 'Chưa có lần làm nào.';
      case AppLanguage.ja:
        return 'まだ履歴がありません。';
    }
  }

  String _quizSavedLabel(AppLanguage language, int correct, int total) {
    switch (language) {
      case AppLanguage.en:
        return 'Saved result: $correct/$total';
      case AppLanguage.vi:
        return 'Đã lưu kết quả: $correct/$total';
      case AppLanguage.ja:
        return '結果を保存しました: $correct/$total';
    }
  }

  String _quizFilterDayLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'Day';
      case AppLanguage.vi:
        return 'Ngày';
      case AppLanguage.ja:
        return '日';
    }
  }

  String _quizFilterWeekLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'Week';
      case AppLanguage.vi:
        return 'Tuần';
      case AppLanguage.ja:
        return '週';
    }
  }

  String _quizFilterAllLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'All';
      case AppLanguage.vi:
        return 'Tất cả';
      case AppLanguage.ja:
        return 'すべて';
    }
  }

  String _quizProgressTitle(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'Progress chart';
      case AppLanguage.vi:
        return 'Biểu đồ tiến bộ';
      case AppLanguage.ja:
        return '進捗チャート';
    }
  }

  String _quizProgressEmptyLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'No progress data for this filter.';
      case AppLanguage.vi:
        return 'Chưa có dữ liệu theo bộ lọc này.';
      case AppLanguage.ja:
        return 'このフィルターのデータはまだありません。';
    }
  }

  String _quizSummaryLabel(
    AppLanguage language,
    List<ImmersionQuizAttempt> attempts,
  ) {
    if (attempts.isEmpty) return '';
    final totalCorrect = attempts.fold<int>(
      0,
      (sum, item) => sum + item.correct,
    );
    final totalQuestions = attempts.fold<int>(
      0,
      (sum, item) => sum + item.total,
    );
    final avgPercent = totalQuestions == 0
        ? 0
        : ((totalCorrect / totalQuestions) * 100).round();
    final bestPercent = attempts
        .map((item) => item.total == 0 ? 0.0 : item.correct / item.total)
        .fold<double>(0, max);
    final bestText = (bestPercent * 100).round();
    switch (language) {
      case AppLanguage.en:
        return 'Avg $avgPercent% • Best $bestText%';
      case AppLanguage.vi:
        return 'TB $avgPercent% • Cao nhất $bestText%';
      case AppLanguage.ja:
        return '平均 $avgPercent% ・ 最高 $bestText%';
    }
  }

  DateTime _startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  DateTime _startOfWeek(DateTime value) {
    final day = _startOfDay(value);
    final offset = day.weekday - DateTime.monday;
    return day.subtract(Duration(days: offset));
  }

  int _weekOfYear(DateTime value) {
    final firstDay = DateTime(value.year, 1, 1);
    final dayOfYear = value.difference(firstDay).inDays + 1;
    return ((dayOfYear - value.weekday + 10) / 7).floor();
  }

  List<ImmersionQuizAttempt> _historyForCurrentFilter() {
    final history = [..._quizHistory]
      ..sort((a, b) => b.attemptedAt.compareTo(a.attemptedAt));
    if (history.isEmpty) return const [];

    final now = DateTime.now();
    switch (_quizHistoryFilter) {
      case _QuizHistoryFilter.day:
        final from = _startOfDay(now).subtract(const Duration(days: 6));
        return history
            .where((item) => !item.attemptedAt.isBefore(from))
            .toList();
      case _QuizHistoryFilter.week:
        final from = _startOfWeek(now).subtract(const Duration(days: 7 * 7));
        return history
            .where((item) => !item.attemptedAt.isBefore(from))
            .toList();
      case _QuizHistoryFilter.all:
        return history;
    }
  }

  List<_QuizHistoryPoint> _historyPointsForChart() {
    final source = [..._quizHistory]
      ..sort((a, b) => a.attemptedAt.compareTo(b.attemptedAt));
    if (source.isEmpty) return const [];

    switch (_quizHistoryFilter) {
      case _QuizHistoryFilter.day:
        final from = _startOfDay(
          DateTime.now(),
        ).subtract(const Duration(days: 6));
        final buckets = <DateTime, _ScoreBucket>{};
        for (final item in source) {
          final day = _startOfDay(item.attemptedAt);
          if (day.isBefore(from)) continue;
          buckets
              .putIfAbsent(day, _ScoreBucket.new)
              .add(item.correct, item.total);
        }
        final points = <_QuizHistoryPoint>[];
        for (int i = 0; i < 7; i++) {
          final day = from.add(Duration(days: i));
          final bucket = buckets[day];
          if (bucket == null || bucket.total == 0) continue;
          points.add(
            _QuizHistoryPoint(
              label: '${day.month}/${day.day}',
              ratio: bucket.ratio,
            ),
          );
        }
        return points;
      case _QuizHistoryFilter.week:
        final from = _startOfWeek(
          DateTime.now(),
        ).subtract(const Duration(days: 7 * 7));
        final buckets = <DateTime, _ScoreBucket>{};
        for (final item in source) {
          final weekStart = _startOfWeek(item.attemptedAt);
          if (weekStart.isBefore(from)) continue;
          buckets
              .putIfAbsent(weekStart, _ScoreBucket.new)
              .add(item.correct, item.total);
        }
        final keys = buckets.keys.toList()..sort();
        return keys.where((key) => buckets[key]!.total > 0).map((key) {
          final bucket = buckets[key]!;
          return _QuizHistoryPoint(
            label: 'W${_weekOfYear(key)}',
            ratio: bucket.ratio,
          );
        }).toList();
      case _QuizHistoryFilter.all:
        final tail = source.reversed.take(12).toList().reversed.toList();
        return tail.map((item) {
          final d = item.attemptedAt;
          final ratio = item.total == 0 ? 0.0 : item.correct / item.total;
          return _QuizHistoryPoint(label: '${d.month}/${d.day}', ratio: ratio);
        }).toList();
    }
  }

  String _unknownQueueTitle(AppLanguage language, int count) {
    switch (language) {
      case AppLanguage.en:
        return 'Unknown words queue ($count)';
      case AppLanguage.vi:
        return 'Hàng đợi từ chưa chắc ($count)';
      case AppLanguage.ja:
        return '未知語キュー ($count)';
    }
  }

  String _unknownQueueSubtitle(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'Tapped words are stored here for quick review.';
      case AppLanguage.vi:
        return 'Các từ đã chạm sẽ lưu ở đây để ôn nhanh cuối bài.';
      case AppLanguage.ja:
        return 'タップした語をここに集めて後でまとめて復習できます。';
    }
  }

  String _unknownQueueReviewLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'Review queue';
      case AppLanguage.vi:
        return 'Xem hàng đợi';
      case AppLanguage.ja:
        return 'キューを見る';
    }
  }

  String _unknownQueueAddAllLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'Add all to SRS';
      case AppLanguage.vi:
        return 'Thêm tất cả vào SRS';
      case AppLanguage.ja:
        return 'すべてSRSに追加';
    }
  }

  String _unknownQueueClearLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return 'Clear queue';
      case AppLanguage.vi:
        return 'Xóa hàng đợi';
      case AppLanguage.ja:
        return 'キューをクリア';
    }
  }

  String _unknownQueueBulkResultLabel(
    AppLanguage language,
    int added,
    int existed,
  ) {
    final total = added + existed;
    switch (language) {
      case AppLanguage.en:
        return 'Processed $total words (new: $added, existing: $existed).';
      case AppLanguage.vi:
        return 'Đã xử lý $total từ (mới: $added, đã có: $existed).';
      case AppLanguage.ja:
        return '$total語を処理しました（新規: $added、既存: $existed）。';
    }
  }

  void _queueUnknownToken(ImmersionToken token) {
    if (_isTokenSaved(token)) return;
    final key = _tokenKey(token.surface, token.reading);
    if (_unknownQueue.containsKey(key)) return;
    setState(() {
      _unknownQueue = {..._unknownQueue, key: token};
    });
  }

  void _removeUnknownToken(ImmersionToken token) {
    final key = _tokenKey(token.surface, token.reading);
    if (!_unknownQueue.containsKey(key)) return;
    setState(() {
      final next = {..._unknownQueue};
      next.remove(key);
      _unknownQueue = next;
    });
  }

  void _clearUnknownQueue() {
    if (_unknownQueue.isEmpty) return;
    setState(() {
      _unknownQueue = {};
    });
  }

  Future<void> _submitQuizResult(String articleId, AppLanguage language) async {
    if (_quizSubmitted) return;
    final correct = _quizScore();
    final total = _quizQuestions.length;
    setState(() {
      _quizSubmitted = true;
    });
    await ref
        .read(immersionServiceProvider)
        .saveQuizAttempt(articleId: articleId, correct: correct, total: total);
    await _loadQuizHistory(articleId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_quizSavedLabel(language, correct, total))),
    );
  }

  Future<void> _addAllUnknownToSrs(AppLanguage language) async {
    final queue = _unknownQueue.values.toList();
    if (queue.isEmpty) return;
    var added = 0;
    var existed = 0;
    for (final token in queue) {
      final result = await _addToSrs(token, language, showFeedback: false);
      if (result == _AddSrsResult.added) {
        added += 1;
      } else {
        existed += 1;
      }
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_unknownQueueBulkResultLabel(language, added, existed)),
      ),
    );
  }

  Future<void> _showUnknownQueue(AppLanguage language) async {
    if (_unknownQueue.isEmpty) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final entries = _unknownQueue.values.toList();
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _unknownQueueTitle(language, entries.length),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.icon(
                          onPressed: entries.isEmpty
                              ? null
                              : () async {
                                  await _addAllUnknownToSrs(language);
                                  if (!mounted) return;
                                  setSheetState(() {});
                                },
                          icon: const Icon(Icons.library_add_check_rounded),
                          label: Text(_unknownQueueAddAllLabel(language)),
                        ),
                        OutlinedButton.icon(
                          onPressed: entries.isEmpty
                              ? null
                              : () {
                                  _clearUnknownQueue();
                                  if (!mounted) return;
                                  setSheetState(() {});
                                },
                          icon: const Icon(Icons.delete_sweep_rounded),
                          label: Text(_unknownQueueClearLabel(language)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                        itemCount: entries.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final token = entries[index];
                          final meaning = _quizMeaning(token, language) ?? '';
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              token.surface,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            subtitle: Text(
                              [
                                if (token.reading?.isNotEmpty == true)
                                  token.reading!,
                                if (meaning.isNotEmpty) meaning,
                              ].join(' • '),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: language.immersionAddSrsLabel,
                                  icon: const Icon(Icons.add_circle_rounded),
                                  onPressed: () async {
                                    await _addToSrs(token, language);
                                    if (!mounted) return;
                                    setSheetState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    _removeUnknownToken(token);
                                    if (!mounted) return;
                                    setSheetState(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  int _quizScore() {
    var correct = 0;
    for (int i = 0; i < _quizQuestions.length; i++) {
      if (_quizAnswers[i] == _quizQuestions[i].correctIndex) {
        correct += 1;
      }
    }
    return correct;
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
            return _buildLoading(context, language);
          }
          if (snapshot.hasError || snapshot.data == null) {
            return _buildError(context, language);
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

  SystemUiOverlayStyle _overlayStyle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
  }

  AppBar _buildAppBar(
    BuildContext context,
    AppLanguage language, {
    List<Widget>? actions,
  }) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: _overlayStyle(context),
      title: Text(language.immersionTitle),
      actions: actions,
    );
  }

  Scaffold _buildLoading(BuildContext context, AppLanguage language) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, language),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Scaffold _buildError(BuildContext context, AppLanguage language) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, language),
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
    _ensureArticleSession(article, language);
    final dateLabel = MaterialLocalizations.of(
      context,
    ).formatMediumDate(article.publishedAt);
    final filteredHistory = _historyForCurrentFilter();
    final chartPoints = _historyPointsForChart();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(
        context,
        language,
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
            tooltip: language.immersionTranslateLabel,
            onPressed: () {
              setState(() {
                _showTranslation = !_showTranslation;
              });
            },
            icon: Icon(
              _showTranslation
                  ? Icons.translate_rounded
                  : Icons.translate_outlined,
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
            if (_unknownQueue.isNotEmpty) ...[
              const SizedBox(height: 12),
              _UnknownQueueCard(
                title: _unknownQueueTitle(language, _unknownQueue.length),
                subtitle: _unknownQueueSubtitle(language),
                reviewLabel: _unknownQueueReviewLabel(language),
                addAllLabel: _unknownQueueAddAllLabel(language),
                onReview: () => _showUnknownQueue(language),
                onAddAll: () => _addAllUnknownToSrs(language),
                onClear: _clearUnknownQueue,
              ),
            ],
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
            if (_quizQuestions.isNotEmpty) ...[
              const SizedBox(height: 8),
              _ImmersionQuizCard(
                title: _quizTitle(language),
                subtitle: _quizSubtitle(language),
                historyTitle: _quizHistoryTitle(language),
                historyEmptyLabel: _quizHistoryEmptyLabel(language),
                historyItems: filteredHistory
                    .map(
                      (attempt) =>
                          '${attempt.correct}/${attempt.total} • ${MaterialLocalizations.of(context).formatShortDate(attempt.attemptedAt)}',
                    )
                    .toList(),
                progressTitle: _quizProgressTitle(language),
                progressEmptyLabel: _quizProgressEmptyLabel(language),
                progressSummaryLabel: _quizSummaryLabel(
                  language,
                  filteredHistory,
                ),
                progressPoints: chartPoints,
                filterDayLabel: _quizFilterDayLabel(language),
                filterWeekLabel: _quizFilterWeekLabel(language),
                filterAllLabel: _quizFilterAllLabel(language),
                selectedFilter: _quizHistoryFilter,
                onFilterChanged: (next) {
                  setState(() {
                    _quizHistoryFilter = next;
                  });
                },
                submitLabel: _quizSubmitLabel(language),
                retryLabel: _quizRetryLabel(language),
                scoreLabel: _quizScoreLabel(
                  language,
                  _quizScore(),
                  _quizQuestions.length,
                ),
                questions: _quizQuestions,
                answers: _quizAnswers,
                submitted: _quizSubmitted,
                onSelect: (questionIndex, optionIndex) {
                  setState(() {
                    _quizAnswers = {
                      ..._quizAnswers,
                      questionIndex: optionIndex,
                    };
                  });
                },
                onSubmit: _quizAnswers.length == _quizQuestions.length
                    ? () => _submitQuizResult(article.id, language)
                    : null,
                onRetry: () {
                  setState(() {
                    _quizAnswers = {};
                    _quizSubmitted = false;
                  });
                },
              ),
            ],
            if (article.translation != null && _showTranslation) ...[
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
    if (!isSaved) {
      _queueUnknownToken(token);
    }
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

  Future<_AddSrsResult> _addToSrs(
    ImmersionToken token,
    AppLanguage language, {
    bool showFeedback = true,
  }) async {
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
      _removeUnknownToken(token);
      if (showFeedback && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(language.immersionAlreadyAddedLabel)),
        );
      }
      return _AddSrsResult.existed;
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
    _removeUnknownToken(token);
    if (showFeedback && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(language.immersionAddedLabel)));
    }
    return _AddSrsResult.added;
  }
}

enum _AddSrsResult { added, existed }

enum _QuizHistoryFilter { day, week, all }

class _ScoreBucket {
  int correct = 0;
  int total = 0;

  void add(int valueCorrect, int valueTotal) {
    correct += valueCorrect;
    total += valueTotal;
  }

  double get ratio => total <= 0 ? 0 : correct / total;
}

class _QuizHistoryPoint {
  const _QuizHistoryPoint({required this.label, required this.ratio});

  final String label;
  final double ratio;
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

class _UnknownQueueCard extends StatelessWidget {
  const _UnknownQueueCard({
    required this.title,
    required this.subtitle,
    required this.reviewLabel,
    required this.addAllLabel,
    required this.onReview,
    required this.onAddAll,
    required this.onClear,
  });

  final String title;
  final String subtitle;
  final String reviewLabel;
  final String addAllLabel;
  final VoidCallback onReview;
  final VoidCallback onAddAll;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFACC15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.inventory_2_rounded,
                size: 18,
                color: Color(0xFFB45309),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF7C2D12),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Clear',
                onPressed: onClear,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF57534E)),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: onReview,
                icon: const Icon(Icons.visibility_rounded),
                label: Text(reviewLabel),
              ),
              OutlinedButton.icon(
                onPressed: onAddAll,
                icon: const Icon(Icons.library_add_check_rounded),
                label: Text(addAllLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImmersionQuizCard extends StatelessWidget {
  const _ImmersionQuizCard({
    required this.title,
    required this.subtitle,
    required this.historyTitle,
    required this.historyEmptyLabel,
    required this.historyItems,
    required this.progressTitle,
    required this.progressEmptyLabel,
    required this.progressSummaryLabel,
    required this.progressPoints,
    required this.filterDayLabel,
    required this.filterWeekLabel,
    required this.filterAllLabel,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.submitLabel,
    required this.retryLabel,
    required this.scoreLabel,
    required this.questions,
    required this.answers,
    required this.submitted,
    required this.onSelect,
    required this.onSubmit,
    required this.onRetry,
  });

  final String title;
  final String subtitle;
  final String historyTitle;
  final String historyEmptyLabel;
  final List<String> historyItems;
  final String progressTitle;
  final String progressEmptyLabel;
  final String progressSummaryLabel;
  final List<_QuizHistoryPoint> progressPoints;
  final String filterDayLabel;
  final String filterWeekLabel;
  final String filterAllLabel;
  final _QuizHistoryFilter selectedFilter;
  final ValueChanged<_QuizHistoryFilter> onFilterChanged;
  final String submitLabel;
  final String retryLabel;
  final String scoreLabel;
  final List<_ImmersionQuizQuestion> questions;
  final Map<int, int> answers;
  final bool submitted;
  final void Function(int questionIndex, int optionIndex) onSelect;
  final VoidCallback? onSubmit;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC7D2FE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1B4B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.history_rounded,
                size: 16,
                color: Color(0xFF6366F1),
              ),
              const SizedBox(width: 6),
              Text(
                historyTitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF312E81),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: Text(filterDayLabel),
                selected: selectedFilter == _QuizHistoryFilter.day,
                onSelected: (_) => onFilterChanged(_QuizHistoryFilter.day),
              ),
              ChoiceChip(
                label: Text(filterWeekLabel),
                selected: selectedFilter == _QuizHistoryFilter.week,
                onSelected: (_) => onFilterChanged(_QuizHistoryFilter.week),
              ),
              ChoiceChip(
                label: Text(filterAllLabel),
                selected: selectedFilter == _QuizHistoryFilter.all,
                onSelected: (_) => onFilterChanged(_QuizHistoryFilter.all),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            progressTitle,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          _QuizProgressChart(
            points: progressPoints,
            emptyLabel: progressEmptyLabel,
          ),
          if (progressSummaryLabel.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              progressSummaryLabel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF475569),
              ),
            ),
          ],
          const SizedBox(height: 10),
          if (historyItems.isEmpty)
            Text(
              historyEmptyLabel,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            )
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: historyItems
                  .take(5)
                  .map(
                    (item) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3730A3),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 12),
          ...List.generate(questions.length, (questionIndex) {
            final question = questions[questionIndex];
            return Padding(
              padding: EdgeInsets.only(
                bottom: questionIndex == questions.length - 1 ? 0 : 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${questionIndex + 1}. ${question.prompt}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(question.options.length, (optionIndex) {
                    final selected = answers[questionIndex] == optionIndex;
                    final isCorrect = optionIndex == question.correctIndex;
                    final showResult = submitted && selected;
                    final bgColor = submitted
                        ? (isCorrect
                              ? const Color(0xFFDCFCE7)
                              : (showResult
                                    ? const Color(0xFFFEE2E2)
                                    : const Color(0xFFF8FAFC)))
                        : (selected
                              ? const Color(0xFFE0E7FF)
                              : const Color(0xFFF8FAFC));
                    final borderColor = submitted
                        ? (isCorrect
                              ? const Color(0xFF86EFAC)
                              : (showResult
                                    ? const Color(0xFFFCA5A5)
                                    : const Color(0xFFE2E8F0)))
                        : (selected
                              ? const Color(0xFFA5B4FC)
                              : const Color(0xFFE2E8F0));
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: submitted
                              ? null
                              : () => onSelect(questionIndex, optionIndex),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: borderColor),
                            ),
                            child: Text(
                              question.options[optionIndex],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          if (submitted) ...[
            Text(
              scoreLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.restart_alt_rounded),
              label: Text(retryLabel),
            ),
          ] else
            FilledButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.task_alt_rounded),
              label: Text(submitLabel),
            ),
        ],
      ),
    );
  }
}

class _QuizProgressChart extends StatelessWidget {
  const _QuizProgressChart({required this.points, required this.emptyLabel});

  final List<_QuizHistoryPoint> points;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Text(
          emptyLabel,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: points.map((point) {
                    final ratio = point.ratio.clamp(0.0, 1.0).toDouble();
                    final percent = (ratio * 100).round();
                    final barHeight = max(6.0, ratio * 48);
                    final color = Color.lerp(
                      const Color(0xFFF59E0B),
                      const Color(0xFF22C55E),
                      ratio,
                    )!;
                    return Expanded(
                      child: Tooltip(
                        message: '$percent%',
                        child: Center(
                          child: Container(
                            width: 12,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 14,
                child: Row(
                  children: points.map((point) {
                    return Expanded(
                      child: Text(
                        point.label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ImmersionQuizQuestion {
  const _ImmersionQuizQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
}

class _QuizVocab {
  const _QuizVocab({required this.token, required this.meaning});

  final ImmersionToken token;
  final String meaning;
}
