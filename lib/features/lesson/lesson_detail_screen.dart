import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/core/services/audio_service.dart';
import 'package:jpstudy/core/tts/tts_service.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/shared/widgets/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _LessonMode { flashcards, review }

enum _AudioMode { term, reading, definition }

enum _AudioVoice { female, male }

enum _MenuAction { edit, addTerm, reset, combine, report }

class LessonDetailScreen extends ConsumerStatefulWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final int lessonId;

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  bool _showHints = true;
  bool _trackProgress = false;
  bool _autoPlay = false;
  bool _autoSpeak = false;
  bool _shuffle = false;
  bool _focusMode = false;
  final Set<int> _flippedTermIds = {};
  final Set<int> _starredTermIds = {};
  final Set<int> _learnedTermIds = {};
  Set<int> _syncedTermIds = {};
  double _speed = 1.0;
  _LessonMode _mode = _LessonMode.flashcards;
  int _currentIndex = 0;
  final Random _random = Random();
  List<int>? _shuffledOrder;
  Timer? _autoTimer;
  int _autoTotal = 0;
  SharedPreferences? _prefs;
  late final AudioPlayer _audioPlayer;
  late final TtsService _ttsService;
  StreamSubscription<PlayerState>? _playerStateSub;
  _AudioMode _audioMode = _AudioMode.term;
  _AudioVoice _audioVoice = _AudioVoice.female;
  bool _isAudioPlaying = false;
  int _ttsCacheBytes = 0;
  bool _isClearingCache = false;
  int? _lastAutoSpeakTermId;
  int _reviewedCount = 0;
  int _reviewAgainCount = 0;
  int _reviewHardCount = 0;
  int _reviewGoodCount = 0;
  int _reviewEasyCount = 0;

  static const _prefShowHints = 'lesson.showHints';
  static const _prefTrackProgress = 'lesson.trackProgress';
  static const _prefAutoPlay = 'lesson.autoPlay';
  static const _prefAutoSpeak = 'lesson.autoSpeak';
  static const _prefShuffle = 'lesson.shuffle';
  static const _prefSpeed = 'lesson.speed';
  static const _prefFocusMode = 'lesson.focusMode';
  static const _prefAudioMode = 'lesson.audioMode';
  static const _prefAudioVoice = 'lesson.audioVoice';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _ttsService = TtsService();
    final language = ref.read(appLanguageProvider);
    _audioMode = _defaultAudioMode(language);
    _audioVoice = _defaultAudioVoice();
    _playerStateSub = _audioPlayer.playerStateStream.listen((state) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isAudioPlaying = state.playing;
      });
    });
    _loadSettings();
    _refreshTtsCacheSize();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _playerStateSub?.cancel();
    _audioPlayer.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider) ?? StudyLevel.n5;
    final fallbackTitle = language.lessonTitle(widget.lessonId);
    final titleAsync = ref.watch(
      lessonTitleProvider(LessonTitleArgs(widget.lessonId, fallbackTitle)),
    );
    final termsAsync = ref.watch(
      lessonTermsProvider(
        LessonTermsArgs(widget.lessonId, level.shortLabel, fallbackTitle),
      ),
    );

    final title = titleAsync.maybeWhen(
      data: (value) => value,
      orElse: () => fallbackTitle,
    );
    final terms = termsAsync.asData?.value ?? const <UserLessonTermData>[];
    final dueAsync = _mode == _LessonMode.review
        ? ref.watch(lessonDueTermsProvider(widget.lessonId))
        : const AsyncValue.data(<UserLessonTermData>[]);
    final activeTermsAsync =
        _mode == _LessonMode.review ? dueAsync : termsAsync;
    final activeTerms =
        activeTermsAsync.asData?.value ?? const <UserLessonTermData>[];
    _maybeSyncTermFlags(terms);
    final displayTerms = _orderedTerms(activeTerms);
    final totalTerms = displayTerms.length;
    final currentIndex = totalTerms == 0
        ? 0
        : _currentIndex.clamp(0, totalTerms - 1);
    final currentTerm =
        totalTerms == 0 ? null : displayTerms.elementAt(currentIndex);
    final isSaved = terms.isNotEmpty && _starredTermIds.length == terms.length;
    final learnedCount = terms.where((term) => term.isLearned).length;
    final dueCount = dueAsync.asData?.value.length ?? 0;
    final isStarred = currentTerm != null &&
        _starredTermIds.contains(currentTerm.id);
    final isLearned = currentTerm != null &&
        _learnedTermIds.contains(currentTerm.id);
    final isFlipped =
        currentTerm != null && _flippedTermIds.contains(currentTerm.id);
    final canFlip = currentTerm?.definition.trim().isNotEmpty == true;
    final onFlip = canFlip ? () => _toggleFlip(currentTerm) : null;

    if (_autoPlay && totalTerms != _autoTotal) {
      _autoTotal = totalTerms;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _syncAutoTimer(totalTerms);
        }
      });
    }
    _maybeAutoSpeak(language, currentTerm);

    return Scaffold(
      appBar: _focusMode
          ? null
          : AppBar(
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              tooltip: language.backToLessonLabel,
              onPressed: () => context.pop(),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${level.shortLabel} / $title',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          _SavedPill(
            label: language.savedLabel,
            active: isSaved,
            onTap:
                totalTerms == 0 ? null : () => _toggleSaved(terms, level),
          ),
          const SizedBox(width: 8),
          _OverflowMenu(
            language: language,
            onSelected: (action) => _handleMenu(
              action,
              context,
              language,
              level,
              title,
              terms,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FocusableActionDetector(
        autofocus: true,
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              onFlip?.call();
              return null;
            },
          ),
        },
        child: LayoutBuilder(
          builder: (context, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, _focusMode ? 20 : 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!_focusMode) ...[
                    _ModeSwitcher(
                      language: language,
                      mode: _mode,
                      onModeChanged: (mode) {
                        setState(() {
                          _mode = mode;
                          _currentIndex = 0;
                          _shuffledOrder = null;
                          if (mode == _LessonMode.review) {
                            _resetReviewStats();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _StatsRow(
                      language: language,
                      total: terms.length,
                      learned: learnedCount,
                      due: dueCount,
                    ),
                    if (_mode == _LessonMode.review) ...[
                      const SizedBox(height: 8),
                      Text(language.reviewCountLabel(totalTerms)),
                    ],
                    const SizedBox(height: 12),
                    _PracticeActions(
                      language: language,
                      lessonId: widget.lessonId,
                      lessonTitle: title,
                    ),
                    const SizedBox(height: 20),
                  ],
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 960),
                        child: SizedBox(
                          height: _focusMode ? 520 : 460,
                          child: GestureDetector(
                            onHorizontalDragEnd: (details) {
                              if (details.primaryVelocity! > 0) {
                                AudioService.instance.play('swipe');
                                _goPrev(totalTerms);
                              } else if (details.primaryVelocity! < 0) {
                                AudioService.instance.play('swipe');
                                _goNext(totalTerms);
                              }
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                final offset = Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation);
                                return SlideTransition(
                                  position: offset,
                                  child: child,
                                );
                              },
                              child: KeyedSubtree(
                                key: ValueKey(currentIndex),
                                child: _LessonCard(
                                  language: language,
                                  termsAsync: activeTermsAsync,
                                  term: currentTerm,
                                  showHints: _showHints,
                                  isFlipped: isFlipped,
                                  trackProgress: _trackProgress,
                                  isStarred: isStarred,
                                  isLearned: isLearned,
                                  emptyLabel: _mode == _LessonMode.review
                                      ? language.reviewEmptyLabel
                                      : null,
                                  onShowHintsChanged: (value) =>
                                      _updateShowHints(value),
                                  onFlip: onFlip,
                                  onEdit: () => context.push(
                                    '/lesson/${widget.lessonId}/edit',
                                  ),
                                  onAudio: currentTerm == null
                                      ? null
                                      : () => _playTts(language, currentTerm),
                                  onStar: currentTerm == null
                                      ? null
                                      : () => _toggleStar(currentTerm, level),
                                  onLearned: !_trackProgress || currentTerm == null
                                      ? null
                                      : () => _toggleLearned(currentTerm, level),
                                  isAudioPlaying: _isAudioPlaying,
                                  onStopAudio: _stopTts,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_mode == _LessonMode.review) ...[
                    const SizedBox(height: 16),
                    _ReviewActions(
                      language: language,
                      enabled: currentTerm != null,
                      onRate: currentTerm == null
                          ? null
                          : (level) => _reviewTerm(currentTerm, level.value),
                    ),
                    const SizedBox(height: 12),
                    _ReviewSummary(
                      language: language,
                      reviewed: _reviewedCount,
                      again: _reviewAgainCount,
                      hard: _reviewHardCount,
                      good: _reviewGoodCount,
                      easy: _reviewEasyCount,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _PlayerBar(
        language: language,
        trackProgress: _trackProgress,
        onTrackProgressChanged: (value) => _updateTrackProgress(value),
        currentIndex: currentIndex,
        total: totalTerms,
        onPrev: () => _goPrev(totalTerms),
        onNext: () => _goNext(totalTerms),
        shuffle: _shuffle,
        autoPlay: _autoPlay,
        speed: _speed,
        fullscreen: _focusMode,
        onToggleShuffle: () => _toggleShuffle(activeTerms),
        onToggleAuto: () => _toggleAuto(totalTerms),
        onSpeedChanged: (value) => _setSpeed(value, totalTerms),
        onSettings: () => _showSettings(language, totalTerms, activeTerms),
        onFullscreen: _toggleFocusMode,
      ),
    );
  }

  List<UserLessonTermData> _orderedTerms(List<UserLessonTermData> terms) {
    if (!_shuffle) {
      _shuffledOrder = null;
      return terms;
    }
    if (terms.isEmpty) {
      _shuffledOrder = null;
      return terms;
    }
    final ids = terms.map((term) => term.id).toSet();
    final order = _shuffledOrder;
    if (order == null ||
        order.length != ids.length ||
        !order.every(ids.contains)) {
      final nextOrder = ids.toList()..shuffle(_random);
      _shuffledOrder = nextOrder;
    }
    final lookup = {for (final term in terms) term.id: term};
    return _shuffledOrder!.map((id) => lookup[id]!).toList();
  }

  Future<void> _toggleSaved(
    List<UserLessonTermData> terms,
    StudyLevel level,
  ) async {
    final repo = ref.read(lessonRepositoryProvider);
    final shouldStarAll = _starredTermIds.length != terms.length;
    setState(() {
      if (shouldStarAll) {
        _starredTermIds
          ..clear()
          ..addAll(terms.map((term) => term.id));
      } else {
        _starredTermIds.clear();
      }
    });
    await repo.setStarredForLesson(widget.lessonId, shouldStarAll);
    ref.invalidate(lessonMetaProvider(level.shortLabel));
  }

  Future<void> _toggleStar(
    UserLessonTermData term,
    StudyLevel level,
  ) async {
    final repo = ref.read(lessonRepositoryProvider);
    final nextValue = !_starredTermIds.contains(term.id);
    setState(() {
      if (nextValue) {
        _starredTermIds.add(term.id);
      } else {
        _starredTermIds.remove(term.id);
      }
    });
    await repo.updateTermStar(
      term.id,
      lessonId: widget.lessonId,
      isStarred: nextValue,
    );
    ref.invalidate(lessonMetaProvider(level.shortLabel));
  }

  Future<void> _toggleLearned(
    UserLessonTermData term,
    StudyLevel level,
  ) async {
    final repo = ref.read(lessonRepositoryProvider);
    final nextValue = !_learnedTermIds.contains(term.id);
    setState(() {
      if (nextValue) {
        _learnedTermIds.add(term.id);
      } else {
        _learnedTermIds.remove(term.id);
      }
    });
    await repo.updateTermLearned(
      term.id,
      lessonId: widget.lessonId,
      isLearned: nextValue,
    );
    if (nextValue) {
      final now = DateTime.now();
      await repo.upsertSrsState(
        termId: term.id,
        box: 1,
        repetitions: 0,
        ease: 2.5,
        lastReviewedAt: now,
        nextReviewAt: now.add(const Duration(days: 1)),
      );
    } else {
      await repo.deleteSrsState(term.id);
    }
    ref.invalidate(lessonMetaProvider(level.shortLabel));
    ref.invalidate(lessonDueTermsProvider(widget.lessonId));
  }

  Future<void> _reviewTerm(UserLessonTermData term, int quality) async {
    final repo = ref.read(lessonRepositoryProvider);
    // Use the comprehensive saveTermReview method which handles SRS calculation
    await repo.saveTermReview(termId: term.id, quality: quality);
    
    ref.invalidate(lessonDueTermsProvider(widget.lessonId));
    if (!mounted) {
      return;
    }
    setState(() {
      _incrementReviewStats(quality);
      _currentIndex = 0;
    });
  }

  void _toggleFlip(UserLessonTermData? term) {
    if (term == null || term.definition.trim().isEmpty) {
      return;
    }
    setState(() {
      if (_flippedTermIds.contains(term.id)) {
        _flippedTermIds.remove(term.id);
      } else {
        _flippedTermIds.add(term.id);
      }
    });
  }

  void _resetReviewStats() {
    _reviewedCount = 0;
    _reviewAgainCount = 0;
    _reviewHardCount = 0;
    _reviewGoodCount = 0;
    _reviewEasyCount = 0;
  }

  void _incrementReviewStats(int quality) {
    _reviewedCount += 1;
    switch (quality) {
      case 0:
        _reviewAgainCount += 1;
        break;
      case 3:
        _reviewHardCount += 1;
        break;
      case 4:
        _reviewGoodCount += 1;
        break;
      case 5:
        _reviewEasyCount += 1;
        break;
    }
  }

  void _updateShowHints(bool value) {
    setState(() => _showHints = value);
    _saveBool(_prefShowHints, value);
  }

  void _updateTrackProgress(bool value) {
    setState(() => _trackProgress = value);
    _saveBool(_prefTrackProgress, value);
  }

  void _updateAutoSpeak(bool value) {
    setState(() => _autoSpeak = value);
    if (!value) {
      _lastAutoSpeakTermId = null;
    }
    _saveBool(_prefAutoSpeak, value);
  }

  void _toggleFocusMode() {
    final nextValue = !_focusMode;
    setState(() => _focusMode = nextValue);
    _saveBool(_prefFocusMode, nextValue);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }
    setState(() {
      _prefs = prefs;
      _showHints = prefs.getBool(_prefShowHints) ?? true;
      _trackProgress = prefs.getBool(_prefTrackProgress) ?? false;
      _autoPlay = prefs.getBool(_prefAutoPlay) ?? false;
      _autoSpeak = prefs.getBool(_prefAutoSpeak) ?? false;
      _shuffle = prefs.getBool(_prefShuffle) ?? false;
      _speed = prefs.getDouble(_prefSpeed) ?? 1.0;
      _focusMode = prefs.getBool(_prefFocusMode) ?? false;
      final storedAudioMode = prefs.getString(_prefAudioMode);
      if (storedAudioMode != null) {
        _audioMode = _audioModeFromString(storedAudioMode);
      }
      final storedAudioVoice = prefs.getString(_prefAudioVoice);
      if (storedAudioVoice != null) {
        _audioVoice = _audioVoiceFromString(storedAudioVoice);
      }
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs ??= prefs;
    await prefs.setBool(key, value);
  }

  Future<void> _saveDouble(String key, double value) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs ??= prefs;
    await prefs.setDouble(key, value);
  }

  Future<void> _saveString(String key, String value) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs ??= prefs;
    await prefs.setString(key, value);
  }

  void _updateAudioMode(_AudioMode mode) {
    setState(() => _audioMode = mode);
    _saveString(_prefAudioMode, _audioModeToString(mode));
  }

  void _updateAudioVoice(_AudioVoice voice) {
    setState(() => _audioVoice = voice);
    _saveString(_prefAudioVoice, _audioVoiceToString(voice));
  }

  _AudioMode _defaultAudioMode(AppLanguage language) {
    switch (language) {
      case AppLanguage.ja:
        return _AudioMode.reading;
      case AppLanguage.vi:
        return _AudioMode.definition;
      case AppLanguage.en:
        return _AudioMode.term;
    }
  }

  String _audioModeToString(_AudioMode mode) {
    switch (mode) {
      case _AudioMode.term:
        return 'term';
      case _AudioMode.reading:
        return 'reading';
      case _AudioMode.definition:
        return 'definition';
    }
  }

  _AudioMode _audioModeFromString(String? value) {
    switch (value) {
      case 'reading':
        return _AudioMode.reading;
      case 'definition':
        return _AudioMode.definition;
      case 'term':
      default:
        return _AudioMode.term;
    }
  }

  _AudioVoice _defaultAudioVoice() {
    return _AudioVoice.female;
  }

  String _audioVoiceToString(_AudioVoice voice) {
    switch (voice) {
      case _AudioVoice.female:
        return 'female';
      case _AudioVoice.male:
        return 'male';
    }
  }

  _AudioVoice _audioVoiceFromString(String value) {
    switch (value) {
      case 'male':
        return _AudioVoice.male;
      case 'female':
      default:
        return _AudioVoice.female;
    }
  }

  Future<void> _refreshTtsCacheSize() async {
    final bytes = await _ttsService.cacheSizeBytes();
    if (!mounted) {
      return;
    }
    setState(() => _ttsCacheBytes = bytes);
  }

  Future<void> _clearTtsCache() async {
    if (_isClearingCache) {
      return;
    }
    setState(() => _isClearingCache = true);
    try {
      await _ttsService.clearCache();
      await _refreshTtsCacheSize();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.read(appLanguageProvider).audioCacheClearedLabel)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.read(appLanguageProvider).audioCacheClearFailedLabel)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isClearingCache = false);
      }
    }
  }

  void _stopTts() {
    _audioPlayer.stop();
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    final kb = bytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    }
    final mb = kb / 1024;
    if (mb < 1024) {
      return '${mb.toStringAsFixed(1)} MB';
    }
    final gb = mb / 1024;
    return '${gb.toStringAsFixed(1)} GB';
  }

  String _termKey(String term, String reading, String definition) {
    final cleanTerm = _normalizeKeyPart(term);
    final cleanReading = _normalizeKeyPart(reading);
    final cleanDefinition = _normalizeKeyPart(definition);
    return '$cleanTerm|$cleanReading|$cleanDefinition';
  }

  String _normalizeKeyPart(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }

  void _maybeSyncTermFlags(List<UserLessonTermData> terms) {
    final ids = terms.map((term) => term.id).toSet();
    final starred =
        terms.where((term) => term.isStarred).map((term) => term.id).toSet();
    final learned =
        terms.where((term) => term.isLearned).map((term) => term.id).toSet();
    final needsSync = !_setsEqual(ids, _syncedTermIds) ||
        !_setsEqual(starred, _starredTermIds) ||
        !_setsEqual(learned, _learnedTermIds);
    if (!needsSync) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _syncedTermIds = ids;
        _starredTermIds
          ..clear()
          ..addAll(starred);
        _learnedTermIds
          ..clear()
          ..addAll(learned);
      });
    });
  }

  bool _setsEqual(Set<int> a, Set<int> b) {
    return a.length == b.length && a.containsAll(b);
  }

  void _goPrev(int total) {
    if (total == 0) {
      return;
    }
    setState(() {
      _currentIndex = (_currentIndex - 1).clamp(0, total - 1);
    });
  }

  void _goNext(int total) {
    if (total == 0) {
      return;
    }
    setState(() {
      _currentIndex = (_currentIndex + 1).clamp(0, total - 1);
    });
  }

  void _goNextAuto(int total) {
    if (total == 0) {
      return;
    }
    setState(() {
      _currentIndex = (_currentIndex + 1) % total;
    });
  }

  void _maybeAutoSpeak(AppLanguage language, UserLessonTermData? term) {
    if (!_autoSpeak || term == null) {
      return;
    }
    if (_lastAutoSpeakTermId == term.id) {
      return;
    }
    _lastAutoSpeakTermId = term.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_autoSpeak) {
        return;
      }
      _playTts(language, term);
    });
  }

  Future<void> _playTts(AppLanguage language, UserLessonTermData term) async {
    final text = _ttsTextForTerm(term).trim();
    await _playTtsText(language, text);
  }

  Future<void> _playTtsSample(AppLanguage language) async {
    final text = language.audioTestSample;
    await _playTtsText(language, text);
  }

  Future<void> _playTtsText(AppLanguage language, String text) async {
    if (text.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language.audioEmptyLabel)),
      );
      return;
    }
    try {
      final file = await _ttsService.synthesize(
        text: text,
        locale: _ttsLocaleForLanguage(language),
        voice: _audioVoiceToString(_audioVoice),
      );
      await _audioPlayer.stop();
      await _audioPlayer.setFilePath(file.path);
      await _audioPlayer.play();
      _refreshTtsCacheSize();
    } on TtsNotConfiguredException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language.audioNotConfigured)),
      );
      if (_autoSpeak) {
        _updateAutoSpeak(false);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language.audioErrorLabel)),
      );
    }
  }

  String _ttsLocaleForLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.ja:
        return 'ja-JP';
      case AppLanguage.vi:
        return 'vi-VN';
      case AppLanguage.en:
        return 'en-US';
    }
  }

  String _ttsTextForTerm(UserLessonTermData term) {
    switch (_audioMode) {
      case _AudioMode.reading:
        return term.reading.isNotEmpty ? term.reading : term.term;
      case _AudioMode.definition:
        return term.definition.isNotEmpty ? term.definition : term.term;
      case _AudioMode.term:
        return term.term;
    }
  }

  void _handleMenu(
    _MenuAction action,
    BuildContext context,
    AppLanguage language,
    StudyLevel level,
    String title,
    List<UserLessonTermData> terms,
  ) {
    switch (action) {
      case _MenuAction.edit:
        context.push('/lesson/${widget.lessonId}/edit');
        break;
      case _MenuAction.addTerm:
        _showQuickAddTerm(language, level);
        break;
      case _MenuAction.reset:
        _resetProgress(language, level);
        break;
      case _MenuAction.combine:
        _combineLesson(language, level, terms);
        break;
      case _MenuAction.report:
        _reportLesson(language, level, title, terms);
        break;
    }
  }

  Future<void> _showQuickAddTerm(
    AppLanguage language,
    StudyLevel level,
  ) async {
    final termController = TextEditingController();
    final readingController = TextEditingController();
    final definitionController = TextEditingController();
    var canSave = false;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(language.addTermLabel),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: termController,
                      decoration: InputDecoration(
                        labelText: language.termLabel,
                      ),
                      onChanged: (value) {
                        final next = value.trim().isNotEmpty;
                        if (next != canSave) {
                          setDialogState(() => canSave = next);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: readingController,
                      decoration: InputDecoration(
                        labelText: language.readingLabel,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: definitionController,
                      decoration: InputDecoration(
                        labelText: language.definitionLabel,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child:
                      Text(MaterialLocalizations.of(context).cancelButtonLabel),
                ),
                ElevatedButton(
                  onPressed: canSave
                      ? () => Navigator.of(context).pop(true)
                      : null,
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );
    if (saved != true || !context.mounted) {
      termController.dispose();
      readingController.dispose();
      definitionController.dispose();
      return;
    }
    final term = termController.text.trim();
    final reading = readingController.text.trim();
    final definition = definitionController.text.trim();
    termController.dispose();
    readingController.dispose();
    definitionController.dispose();
    if (term.isEmpty) {
      return;
    }
    final repo = ref.read(lessonRepositoryProvider);
    await repo.appendTerms(
      widget.lessonId,
      [
        LessonTermDraft(
          term: term,
          reading: reading,
          definition: definition,
          kanjiMeaning: '',
        ),
      ],
    );
    ref.invalidate(lessonMetaProvider(level.shortLabel));
    ref.invalidate(
      lessonTermsProvider(
        LessonTermsArgs(
          widget.lessonId,
          level.shortLabel,
          language.lessonTitle(widget.lessonId),
        ),
      ),
    );
  }

  Future<void> _resetProgress(
    AppLanguage language,
    StudyLevel level,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(language.resetProgressTitle),
        content: Text(language.resetProgressBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(language.resetProgressConfirmLabel),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    try {
      final repo = ref.read(lessonRepositoryProvider);
      await repo.resetLessonProgress(widget.lessonId);
      ref.invalidate(lessonMetaProvider(level.shortLabel));
      ref.invalidate(lessonDueTermsProvider(widget.lessonId));
      ref.invalidate(
        lessonTermsProvider(
          LessonTermsArgs(
            widget.lessonId,
            level.shortLabel,
            language.lessonTitle(widget.lessonId),
          ),
        ),
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language.resetProgressSuccessLabel)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language.resetProgressErrorLabel)),
      );
    }
  }

  Future<void> _combineLesson(
    AppLanguage language,
    StudyLevel level,
    List<UserLessonTermData> terms,
  ) async {
    if (terms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language.combineEmptyLabel)),
      );
      return;
    }
    final repo = ref.read(lessonRepositoryProvider);
    final lessons =
        await ref.read(lessonMetaProvider(level.shortLabel).future);
    if (!mounted) {
      return;
    }
    final options = lessons
        .where((lesson) => lesson.id != widget.lessonId)
        .toList();
    final targetId = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            children: [
              Text(
                language.combineSetLabel,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: Text(language.combineNewLessonLabel),
                onTap: () => Navigator.of(context).pop(-1),
              ),
              if (options.isNotEmpty) const Divider(),
              for (final lesson in options)
                ListTile(
                  title: Text(lesson.title),
                  subtitle:
                      Text(language.termsCountLabel(lesson.termCount)),
                  onTap: () => Navigator.of(context).pop(lesson.id),
                ),
            ],
          ),
        );
      },
    );
    if (targetId == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    int destinationId = targetId;
    if (targetId == -1) {
      final nextId = await repo.nextLessonId();
      if (!mounted) {
        return;
      }
      final defaultTitle = language.lessonTitle(nextId);
      final controller = TextEditingController(text: defaultTitle);
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(language.combineNewLessonLabel),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: defaultTitle),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child:
                  Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(language.createLessonLabel),
            ),
          ],
        ),
      );
      if (confirmed != true) {
        controller.dispose();
        return;
      }
      final resolvedTitle = controller.text.trim().isEmpty
          ? defaultTitle
          : controller.text.trim();
      final isCustomTitle = resolvedTitle != defaultTitle;
      controller.dispose();
      destinationId = await repo.createLesson(
        level: level.shortLabel,
        title: resolvedTitle,
        isPublic: true,
        isCustomTitle: isCustomTitle,
      );
    }
    final drafts = terms
        .map(
          (term) => LessonTermDraft(
            term: term.term,
            reading: term.reading,
            definition: term.definition,
            kanjiMeaning: term.kanjiMeaning,
          ),
        )
        .toList();
    try {
      final existing = await repo.fetchTerms(destinationId);
      if (!mounted) {
        return;
      }
      final existingKeys = existing
          .map(
            (term) => _termKey(term.term, term.reading, term.definition),
          )
          .toSet();
      final filteredDrafts = <LessonTermDraft>[];
      var skipped = 0;
      for (final draft in drafts) {
        final key = _termKey(draft.term, draft.reading, draft.definition);
        if (existingKeys.add(key)) {
          filteredDrafts.add(draft);
        } else {
          skipped += 1;
        }
      }
      if (filteredDrafts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(language.combineNoNewLabel)),
        );
        return;
      }
      await repo.appendTerms(destinationId, filteredDrafts);
      ref.invalidate(lessonMetaProvider(level.shortLabel));
      if (!mounted) {
        return;
      }
      final message = skipped == 0
          ? language.combineSuccessLabel
          : language.combineSkippedLabel(skipped);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language.combineErrorLabel)),
      );
    }
  }

  Future<void> _reportLesson(
    AppLanguage language,
    StudyLevel level,
    String title,
    List<UserLessonTermData> terms,
  ) async {
    final buffer = StringBuffer()
      ..writeln('Lesson ID: ${widget.lessonId}')
      ..writeln('Level: ${level.shortLabel}')
      ..writeln('Title: $title')
      ..writeln('Terms: ${terms.length}')
      ..writeln('---')
      ..writeln('Sample:');
    final sampleCount = terms.length < 5 ? terms.length : 5;
    for (var i = 0; i < sampleCount; i++) {
      final term = terms[i];
      buffer.writeln(
        '${i + 1}. ${term.term}\t${term.reading}\t${term.definition}',
      );
    }
    final reportText = buffer.toString();
    final copied = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(language.reportLabel),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: SelectableText(reportText),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(MaterialLocalizations.of(context).copyButtonLabel),
          ),
        ],
      ),
    );
    if (copied != true) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: reportText));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(language.reportCopiedLabel)),
    );
  }

  void _toggleShuffle(List<UserLessonTermData> terms) {
    final currentId = _currentTermId(terms);
    final nextValue = !_shuffle;
    setState(() {
      _shuffle = nextValue;
      if (nextValue) {
        final ids = terms.map((term) => term.id).toList();
        if (ids.isEmpty) {
          _shuffledOrder = null;
          _currentIndex = 0;
          return;
        }
        ids.shuffle(_random);
        _shuffledOrder = ids;
        if (currentId != null) {
          _currentIndex = ids.indexOf(currentId).clamp(0, ids.length - 1);
        } else {
          _currentIndex = 0;
        }
      } else {
        _shuffledOrder = null;
        if (currentId != null) {
          final index =
              terms.indexWhere((term) => term.id == currentId);
          _currentIndex = index == -1 ? 0 : index;
        } else {
          _currentIndex = 0;
        }
      }
    });
    _saveBool(_prefShuffle, nextValue);
  }

  int? _currentTermId(List<UserLessonTermData> terms) {
    final ordered = _orderedTerms(terms);
    if (ordered.isEmpty) {
      return null;
    }
    final index = _currentIndex.clamp(0, ordered.length - 1);
    return ordered[index].id;
  }

  void _toggleAuto(int total) {
    final nextValue = !_autoPlay;
    setState(() => _autoPlay = nextValue);
    _saveBool(_prefAutoPlay, nextValue);
    _syncAutoTimer(total);
  }

  void _setSpeed(double value, int total) {
    setState(() => _speed = value);
    _saveDouble(_prefSpeed, value);
    _syncAutoTimer(total);
  }

  void _syncAutoTimer(int total) {
    _autoTimer?.cancel();
    if (!_autoPlay || total == 0) {
      return;
    }
    final intervalMs =
        (3800 / _speed).round().clamp(900, 8000).toInt();
    _autoTimer = Timer.periodic(
      Duration(milliseconds: intervalMs),
      (_) {
        if (!mounted || !_autoPlay) {
          return;
        }
        _goNextAuto(total);
      },
    );
  }

  Future<void> _showSettings(
    AppLanguage language,
    int total,
    List<UserLessonTermData> terms,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.settingsLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(language.showHintsLabel),
                      value: _showHints,
                      onChanged: (value) {
                        _updateShowHints(value);
                        setModalState(() {});
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(language.trackProgressLabel),
                      value: _trackProgress,
                      onChanged: (value) {
                        _updateTrackProgress(value);
                        setModalState(() {});
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(language.shuffleLabel),
                      value: _shuffle,
                      onChanged: (value) {
                        _toggleShuffle(terms);
                        setModalState(() {});
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(language.autoLabel),
                      value: _autoPlay,
                      onChanged: (value) {
                        _toggleAuto(total);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(language.speedLabel),
                    Slider(
                      value: _speed,
                      min: 0.8,
                      max: 2.0,
                      divisions: 6,
                      label: '${_speed.toStringAsFixed(1)}x',
                      onChanged: (value) {
                        _setSpeed(value, total);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                      Text(
                        language.audioSettingsLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(language.audioAutoPlayLabel),
                        value: _autoSpeak,
                        onChanged: (value) {
                          _updateAutoSpeak(value);
                          setModalState(() {});
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(language.audioModeLabel),
                    const SizedBox(height: 8),
                    SegmentedButton<_AudioMode>(
                      segments: [
                        ButtonSegment(
                          value: _AudioMode.term,
                          label: Text(language.audioModeTerm),
                        ),
                        ButtonSegment(
                          value: _AudioMode.reading,
                          label: Text(language.audioModeReading),
                        ),
                        ButtonSegment(
                          value: _AudioMode.definition,
                          label: Text(language.audioModeDefinition),
                        ),
                      ],
                      selected: {_audioMode},
                      onSelectionChanged: (selection) {
                        if (selection.isEmpty) {
                          return;
                        }
                        _updateAudioMode(selection.first);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(language.audioVoiceLabel),
                    const SizedBox(height: 8),
                    SegmentedButton<_AudioVoice>(
                      segments: [
                        ButtonSegment(
                          value: _AudioVoice.female,
                          label: Text(language.audioVoiceFemale),
                        ),
                        ButtonSegment(
                          value: _AudioVoice.male,
                          label: Text(language.audioVoiceMale),
                        ),
                      ],
                      selected: {_audioVoice},
                      onSelectionChanged: (selection) {
                        if (selection.isEmpty) {
                          return;
                        }
                        _updateAudioVoice(selection.first);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => _playTtsSample(language),
                      icon: const Icon(Icons.play_arrow),
                      label: Text(language.audioTestVoiceLabel),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${language.audioCacheLabel}: ${_formatBytes(_ttsCacheBytes)}',
                          ),
                        ),
                        TextButton(
                          onPressed:
                              _isClearingCache ? null : _clearTtsCache,
                          child: Text(language.audioClearCacheLabel),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}



class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.language,
    required this.total,
    required this.learned,
    required this.due,
  });

  final AppLanguage language;
  final int total;
  final int learned;
  final int due;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _StatChip(
          label: language.statsTotalLabel,
          value: total.toString(),
        ),
        _StatChip(
          label: language.statsLearnedLabel,
          value: learned.toString(),
        ),
        _StatChip(
          label: language.statsDueLabel,
          value: due.toString(),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7390),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ReviewActions extends StatelessWidget {
  const _ReviewActions({
    required this.language,
    required this.enabled,
    required this.onRate,
  });

  final AppLanguage language;
  final bool enabled;
  final ValueChanged<ConfidenceLevel>? onRate;

  @override
  Widget build(BuildContext context) {
    return enabled
        ? ConfidenceRatingWidget(
            onSelect: (level) => onRate?.call(level),
          )
        : const SizedBox.shrink();
  }
}

class _ReviewSummary extends StatelessWidget {
  const _ReviewSummary({
    required this.language,
    required this.reviewed,
    required this.again,
    required this.hard,
    required this.good,
    required this.easy,
  });

  final AppLanguage language;
  final int reviewed;
  final int again;
  final int hard;
  final int good;
  final int easy;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _SummaryChip(
          label: language.reviewedLabel,
          value: reviewed.toString(),
        ),
        _SummaryChip(
          label: language.reviewAgainLabel,
          value: again.toString(),
        ),
        _SummaryChip(
          label: language.reviewHardLabel,
          value: hard.toString(),
        ),
        _SummaryChip(
          label: language.reviewGoodLabel,
          value: good.toString(),
        ),
        _SummaryChip(
          label: language.reviewEasyLabel,
          value: easy.toString(),
        ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E6F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7390)),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _SavedPill extends StatelessWidget {
  const _SavedPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEFF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? const Color(0xFFD6DDFF) : const Color(0xFFE1E6F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? Icons.star : Icons.star_border,
              size: 16,
              color: active ? const Color(0xFF4255FF) : null,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({
    required this.language,
    required this.onSelected,
  });

  final AppLanguage language;
  final ValueChanged<_MenuAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuAction>(
      onSelected: onSelected,
      icon: const Icon(Icons.more_horiz),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: _MenuAction.edit,
            child: Text(language.copySetLabel),
          ),
          PopupMenuItem(
            value: _MenuAction.addTerm,
            child: Text(language.addTermLabel),
          ),
          PopupMenuItem(
            value: _MenuAction.reset,
            child: Text(language.resetProgressLabel),
          ),
        PopupMenuItem(
          value: _MenuAction.combine,
          child: Text(language.combineSetLabel),
        ),
        PopupMenuItem(
          value: _MenuAction.report,
          child: Text(language.reportLabel),
        ),
      ],
    );
  }
}

class _ModeSwitcher extends StatelessWidget {
  const _ModeSwitcher({
    required this.language,
    required this.mode,
    required this.onModeChanged,
  });

  final AppLanguage language;
  final _LessonMode mode;
  final ValueChanged<_LessonMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SegmentedButton<_LessonMode>(
          segments: [
            ButtonSegment(
              value: _LessonMode.flashcards,
              label: Text(language.flashcardsAction),
            ),
            ButtonSegment(
              value: _LessonMode.review,
              label: Text(language.reviewAction),
            ),
          ],
          selected: {mode},
          onSelectionChanged: (selection) {
            if (selection.isNotEmpty) {
              onModeChanged(selection.first);
            }
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFF4255FF);
              }
              return Colors.white;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return const Color(0xFF1C2440);
            }),
            side: WidgetStateProperty.all(
              const BorderSide(color: Color(0xFFE1E6F0)),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}

class _PracticeActions extends StatelessWidget {
  const _PracticeActions({
    required this.language,
    required this.lessonId,
    required this.lessonTitle,
  });

  final AppLanguage language;
  final int lessonId;
  final String lessonTitle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        _PracticeButton(
          label: language.learnModeLabel,
          onTap: () => context.push(
            '/lesson/$lessonId/learn-enhanced?title=${Uri.encodeComponent(lessonTitle)}',
          ),
        ),
        _PracticeButton(
          label: language.testModeLabel,
          onTap: () => context.push(
            '/lesson/$lessonId/test-enhanced?title=${Uri.encodeComponent(lessonTitle)}',
          ),
        ),
        _PracticeButton(
          label: language.matchModeLabel,
          onTap: () => context.push('/lesson/$lessonId/practice/match'),
        ),
        _PracticeButton(
          label: language.writeModeLabel,
          onTap: () => context.push('/lesson/$lessonId/practice/write'),
        ),
        _PracticeButton(
          label: language.spellModeLabel,
          onTap: () => context.push('/lesson/$lessonId/practice/spell'),
        ),
      ],
    );
  }
}

class _PracticeButton extends StatelessWidget {
  const _PracticeButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1C2440),
        side: const BorderSide(color: Color(0xFFE1E6F0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      child: Text(label),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.language,
    required this.termsAsync,
    required this.term,
    required this.showHints,
    required this.isFlipped,
    required this.trackProgress,
    required this.isStarred,
    required this.isLearned,
    required this.isAudioPlaying,
    required this.onShowHintsChanged,
    required this.onFlip,
    required this.onEdit,
    required this.onAudio,
    required this.onStar,
    required this.onLearned,
    required this.onStopAudio,
    this.emptyLabel,
  });

  final AppLanguage language;
  final AsyncValue<List<UserLessonTermData>> termsAsync;
  final UserLessonTermData? term;
  final bool showHints;
  final bool isFlipped;
  final bool trackProgress;
  final bool isStarred;
  final bool isLearned;
  final bool isAudioPlaying;
  final ValueChanged<bool> onShowHintsChanged;
  final VoidCallback? onFlip;
  final VoidCallback onEdit;
  final VoidCallback? onAudio;
  final VoidCallback? onStar;
  final VoidCallback? onLearned;
  final VoidCallback? onStopAudio;
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A2E3A59),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 18),
                    const SizedBox(width: 6),
                    Text(language.showHintsLabel),
                    const SizedBox(width: 8),
                    Switch(
                      value: showHints,
                      onChanged: onShowHintsChanged,
                    ),
                  ],
                ),
                const Spacer(),
                _ActionPill(
                  isStarred: isStarred,
                  isLearned: isLearned,
                  isAudioPlaying: isAudioPlaying,
                  onEdit: onEdit,
                  onAudio: onAudio,
                  onStar: onStar,
                  onLearned: onLearned,
                  onStopAudio: onStopAudio,
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: onFlip,
                child: _CardContent(
                  language: language,
                  termsAsync: termsAsync,
                  term: term,
                  showHints: showHints,
                  isFlipped: isFlipped,
                  emptyLabel: emptyLabel,
                ),
              ),
            ),
          ),
          if (trackProgress) _ShortcutBar(language: language),
        ],
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.language,
    required this.termsAsync,
    required this.term,
    required this.showHints,
    required this.isFlipped,
    required this.emptyLabel,
  });

  final AppLanguage language;
  final AsyncValue<List<UserLessonTermData>> termsAsync;
  final UserLessonTermData? term;
  final bool showHints;
  final bool isFlipped;
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (termsAsync.isLoading) {
      return const CircularProgressIndicator();
    }
    if (termsAsync.hasError) {
      return Text(language.loadErrorLabel);
    }
    final resolvedTerm = term;
    if (resolvedTerm == null) {
      final label = emptyLabel;
      if (label == null || label.isEmpty) {
        return const SizedBox.shrink();
      }
      return Text(
        label,
        style: const TextStyle(color: Color(0xFF6B7390)),
        textAlign: TextAlign.center,
      );
    }

    final showBack = isFlipped && resolvedTerm.definition.trim().isNotEmpty;
    final hintText =
        showHints ? _hintForDefinition(resolvedTerm.definition) : '';

    final front = _CardFace(
      key: const ValueKey(false),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            resolvedTerm.term,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C2440),
            ),
            textAlign: TextAlign.center,
          ),
          if (resolvedTerm.reading.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              resolvedTerm.reading,
              style: const TextStyle(fontSize: 18, color: Color(0xFF6B7390)),
              textAlign: TextAlign.center,
            ),
          ],
          if (resolvedTerm.kanjiMeaning.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              resolvedTerm.kanjiMeaning,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4D5877),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (hintText.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              hintText,
              style: const TextStyle(fontSize: 14, color: Color(0xFF4D5877)),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    final backContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          language.definitionLabel,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8F9BB3),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          resolvedTerm.definition,
          style: const TextStyle(fontSize: 18, color: Color(0xFF1C2440)),
          textAlign: TextAlign.center,
        ),
      ],
    );

    final back = _CardFace(
      key: const ValueKey(true),
      child: backContent,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        final rotate = Tween(begin: pi, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotate,
          child: child,
          builder: (context, child) {
            final isUnder = child?.key != ValueKey(showBack);
            var value = rotate.value;
            if (isUnder) {
              value = min(rotate.value, pi / 2);
            }
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value);
            return Transform(
              transform: transform,
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      },
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: showBack ? back : front,
    );
  }

  String _hintForDefinition(String definition) {
    final clean = definition.replaceAll('\n', ' ').trim();
    if (clean.isEmpty) {
      return '';
    }
    const maxChars = 3;
    if (clean.length <= maxChars) {
      return clean;
    }
    return '${clean.substring(0, maxChars)}...';
  }
}

class _CardFace extends StatelessWidget {
  const _CardFace({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class _ShortcutBar extends StatelessWidget {
  const _ShortcutBar({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFE9EBFF),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.keyboard, size: 16),
          ),
          const SizedBox(width: 10),
          Text(
            language.shortcutLabel,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              language.shortcutInstruction,
              style: const TextStyle(color: Color(0xFF4D5877)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.isStarred,
    required this.isLearned,
    required this.isAudioPlaying,
    required this.onEdit,
    required this.onAudio,
    required this.onStar,
    required this.onLearned,
    required this.onStopAudio,
  });

  final bool isStarred;
  final bool isLearned;
  final bool isAudioPlaying;
  final VoidCallback onEdit;
  final VoidCallback? onAudio;
  final VoidCallback? onStar;
  final VoidCallback? onLearned;
  final VoidCallback? onStopAudio;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E6F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _IconPillButton(icon: Icons.edit_outlined, onTap: onEdit),
          const SizedBox(width: 4),
          _IconPillButton(
            icon: isAudioPlaying
                ? Icons.stop_circle_outlined
                : Icons.volume_up_outlined,
            onTap: isAudioPlaying ? onStopAudio : onAudio,
          ),
          if (onLearned != null) ...[
            const SizedBox(width: 4),
            _IconPillButton(
              icon: isLearned
                  ? Icons.check_circle
                  : Icons.check_circle_outline,
              onTap: onLearned,
              active: isLearned,
            ),
          ],
          const SizedBox(width: 4),
          _IconPillButton(
            icon: isStarred ? Icons.star : Icons.star_border,
            onTap: onStar,
            active: isStarred,
          ),
        ],
      ),
    );
  }
}

class _IconPillButton extends StatelessWidget {
  const _IconPillButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEFF2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? const Color(0xFF4255FF) : null,
        ),
      ),
    );
  }
}

class _PlayerBar extends StatelessWidget {
  const _PlayerBar({
    required this.language,
    required this.trackProgress,
    required this.onTrackProgressChanged,
    required this.currentIndex,
    required this.total,
    required this.onPrev,
    required this.onNext,
    required this.shuffle,
    required this.autoPlay,
    required this.speed,
    required this.fullscreen,
    required this.onToggleShuffle,
    required this.onToggleAuto,
    required this.onSpeedChanged,
    required this.onSettings,
    required this.onFullscreen,
  });

  final AppLanguage language;
  final bool trackProgress;
  final ValueChanged<bool> onTrackProgressChanged;
  final int currentIndex;
  final int total;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final bool shuffle;
  final bool autoPlay;
  final double speed;
  final bool fullscreen;
  final VoidCallback onToggleShuffle;
  final VoidCallback onToggleAuto;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onSettings;
  final VoidCallback onFullscreen;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE8ECF5))),
        ),
        child: Row(
          children: [
            Row(
              children: [
                Text(language.trackProgressLabel),
                const SizedBox(width: 8),
                Switch(
                  value: trackProgress,
                  onChanged: onTrackProgressChanged,
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: onPrev,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  '${total == 0 ? 0 : currentIndex + 1} / $total',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const Spacer(),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _PlayerChip(
                  icon: Icons.shuffle,
                  label: language.shuffleLabel,
                  active: shuffle,
                  onTap: onToggleShuffle,
                ),
                _PlayerChip(
                  icon: Icons.play_circle_outline,
                  label: language.autoLabel,
                  active: autoPlay,
                  onTap: onToggleAuto,
                ),
                PopupMenuButton<double>(
                  onSelected: onSpeedChanged,
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 0.8, child: Text('0.8x')),
                    PopupMenuItem(value: 1.0, child: Text('1x')),
                    PopupMenuItem(value: 1.2, child: Text('1.2x')),
                    PopupMenuItem(value: 1.5, child: Text('1.5x')),
                    PopupMenuItem(value: 2.0, child: Text('2x')),
                  ],
                  child: _PlayerChip(
                    icon: Icons.speed,
                    label: '${language.speedLabel} ${_speedLabel(speed)}',
                    interactive: false,
                  ),
                ),
                _PlayerChip(
                  icon: Icons.settings_outlined,
                  label: language.settingsLabel,
                  onTap: onSettings,
                ),
                _PlayerChip(
                  icon: Icons.fullscreen,
                  label: language.fullscreenLabel,
                  active: fullscreen,
                  onTap: onFullscreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _speedLabel(double value) {
    final clean = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
    return '${clean}x';
  }
}

class _PlayerChip extends StatelessWidget {
  const _PlayerChip({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
    this.interactive = true,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEFF2FF) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? const Color(0xFFD6DDFF) : const Color(0xFFE1E6F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: active ? const Color(0xFF4255FF) : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );

    if (!interactive) {
      return content;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: content,
    );
  }
}
