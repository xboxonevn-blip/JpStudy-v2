import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/core/tts/tts_service.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:just_audio/just_audio.dart';

enum LessonPracticeMode { learn, test, match, write, spell }

LessonPracticeMode? lessonPracticeModeFromPath(String value) {
  switch (value) {
    case 'learn':
      return LessonPracticeMode.learn;
    case 'test':
      return LessonPracticeMode.test;
    case 'match':
      return LessonPracticeMode.match;
    case 'write':
      return LessonPracticeMode.write;
    case 'spell':
      return LessonPracticeMode.spell;
  }
  return null;
}

class LessonPracticeScreen extends ConsumerWidget {
  const LessonPracticeScreen({
    super.key,
    required this.lessonId,
    required this.mode,
  });

  final int lessonId;
  final LessonPracticeMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider) ?? StudyLevel.n5;
    final fallbackTitle = language.lessonTitle(lessonId);
    final titleAsync = ref.watch(
      lessonTitleProvider(LessonTitleArgs(lessonId, fallbackTitle)),
    );
    final termsAsync = ref.watch(
      lessonTermsProvider(
        LessonTermsArgs(lessonId, level.shortLabel, fallbackTitle),
      ),
    );
    final settingsAsync = ref.watch(lessonPracticeSettingsProvider(lessonId));
    final title = titleAsync.maybeWhen(
      data: (value) => value,
      orElse: () => fallbackTitle,
    );
    final settings = settingsAsync.maybeWhen(
      data: (value) => value,
      orElse: () => LessonPracticeSettings.defaults,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${_modeLabel(language, mode)} - $title'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: termsAsync.when(
        data: (terms) {
          if (terms.isEmpty) {
            return Center(child: Text(language.noTermsLabel));
          }
          switch (mode) {
            case LessonPracticeMode.learn:
              return _LearnMode(
                lessonId: lessonId,
                level: level,
                language: language,
                terms: terms,
                termLimit: settings.learnTermLimit,
              );
            case LessonPracticeMode.test:
              return _TestMode(
                lessonId: lessonId,
                level: level,
                language: language,
                terms: terms,
                questionLimit: settings.testQuestionLimit,
              );
            case LessonPracticeMode.match:
              return _MatchMode(
                lessonId: lessonId,
                level: level,
                language: language,
                terms: terms,
                pairLimit: settings.matchPairLimit,
              );
            case LessonPracticeMode.write:
              return _WriteSpellMode(
                lessonId: lessonId,
                level: level,
                language: language,
                terms: terms,
                useAudioPrompt: false,
              );
            case LessonPracticeMode.spell:
              return _WriteSpellMode(
                lessonId: lessonId,
                level: level,
                language: language,
                terms: terms,
                useAudioPrompt: true,
              );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(language.loadErrorLabel)),
      ),
    );
  }

  String _modeLabel(AppLanguage language, LessonPracticeMode mode) {
    switch (mode) {
      case LessonPracticeMode.learn:
        return language.learnModeLabel;
      case LessonPracticeMode.test:
        return language.testModeLabel;
      case LessonPracticeMode.match:
        return language.matchModeLabel;
      case LessonPracticeMode.write:
        return language.writeModeLabel;
      case LessonPracticeMode.spell:
        return language.spellModeLabel;
    }
  }
}
class _LearnMode extends ConsumerStatefulWidget {
  const _LearnMode({
    required this.lessonId,
    required this.level,
    required this.language,
    required this.terms,
    required this.termLimit,
  });

  final int lessonId;
  final StudyLevel level;
  final AppLanguage language;
  final List<UserLessonTermData> terms;
  final int termLimit;

  @override
  ConsumerState<_LearnMode> createState() => _LearnModeState();
}

class _LearnModeState extends ConsumerState<_LearnMode> {
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();
  final Map<int, int> _mastery = {};
  final Set<int> _learnedIds = {};
  late final LessonRepository _lessonRepo;
  late List<UserLessonTermData> _sessionTerms;
  bool _trackProgress = true;
  bool _showResult = false;
  bool _lastCorrect = false;
  bool _isChoice = true;
  bool _completed = false;
  int _correctCount = 0;
  int _answeredCount = 0;
  int _xpEarned = 0;
  _LearnQuestion? _current;

  @override
  void initState() {
    super.initState();
    _lessonRepo = ref.read(lessonRepositoryProvider);
    _sessionTerms = _limitTerms(widget.terms, widget.termLimit);
    _nextQuestion();
  }

  @override
  void dispose() {
    _answerController.dispose();
    if (_xpEarned > 0) {
      _lessonRepo.recordStudyActivity(xpDelta: _xpEarned);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = widget.language;
    if (_completed) {
      return _CompletionPanel(
        title: language.learnCompleteLabel,
        subtitle: language.learnSummaryLabel(
          _correctCount,
          _answeredCount,
        ),
        onRestart: _restart,
        restartLabel: language.restartLabel,
      );
    }
    final question = _current;
    if (question == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                language.learnProgressLabel(
                  _masteredCount(),
                  _sessionTerms.length,
                ),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(language.trackProgressLabel),
              const SizedBox(width: 8),
              Switch(
                value: _trackProgress,
                onChanged: (value) => setState(() => _trackProgress = value),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _QuestionCard(
              title: question.prompt,
              subtitle: question.subtitle,
              child: _isChoice
                  ? _ChoiceList(
                      choices: question.choices,
                      enabled: !_showResult,
                      onSelected: _handleChoice,
                    )
                  : _WriteAnswer(
                      controller: _answerController,
                      enabled: !_showResult,
                      onCheck: _handleWritten,
                      checkLabel: language.checkLabel,
                    ),
            ),
          ),
          const SizedBox(height: 12),
          _ResultBar(
            visible: _showResult,
            correct: _lastCorrect,
            correctLabel: language.correctLabel,
            incorrectLabel: language.incorrectLabel,
            onNext: _nextQuestion,
            nextLabel: language.nextLabel,
          ),
        ],
      ),
    );
  }

  void _restart() {
    setState(() {
      _sessionTerms = _limitTerms(widget.terms, widget.termLimit);
      _mastery.clear();
      _learnedIds.clear();
      _correctCount = 0;
      _answeredCount = 0;
      _completed = false;
      _xpEarned = 0;
      _nextQuestion(reset: true);
    });
  }

  void _nextQuestion({bool reset = false}) {
    if (!reset) {
      setState(() => _showResult = false);
    }
    final remaining = _sessionTerms
        .where((term) => (_mastery[term.id] ?? 0) < 2)
        .toList();
    if (remaining.isEmpty) {
      setState(() => _completed = true);
      return;
    }
    final term = remaining[_random.nextInt(remaining.length)];
    final meaning = _termMeaning(term);
    if (meaning.isEmpty || _sessionTerms.length < 4) {
      _isChoice = false;
    } else {
      _isChoice = _random.nextBool();
    }
    _answerController.clear();
    if (_isChoice) {
      final choices = _buildChoices(term, _sessionTerms);
      _current = _LearnQuestion(
        term: term,
        prompt: term.term,
        subtitle: term.reading,
        choices: choices,
        correctAnswer: meaning,
      );
    } else {
      _current = _LearnQuestion(
        term: term,
        prompt: meaning,
        subtitle: term.reading,
        choices: const [],
        correctAnswer: term.term,
      );
    }
    setState(() {});
  }

  int _masteredCount() {
    var count = 0;
    for (final value in _mastery.values) {
      if (value >= 2) {
        count += 1;
      }
    }
    return count;
  }

  List<UserLessonTermData> _limitTerms(
    List<UserLessonTermData> terms,
    int limit,
  ) {
    if (limit <= 0 || terms.length <= limit) {
      return terms;
    }
    final pool = List<UserLessonTermData>.from(terms)..shuffle(_random);
    return pool.take(limit).toList();
  }

  void _handleChoice(String value) {
    final question = _current;
    if (question == null) {
      return;
    }
    final correct = value == question.correctAnswer;
    _applyAnswer(correct, question.term);
  }

  void _handleWritten() {
    final question = _current;
    if (question == null) {
      return;
    }
    final input = _answerController.text;
    final correct = _matchesAnswer(input, question.term);
    _applyAnswer(correct, question.term);
  }

  void _applyAnswer(bool correct, UserLessonTermData term) {
    setState(() {
      _showResult = true;
      _lastCorrect = correct;
      _answeredCount += 1;
      if (correct) {
        _correctCount += 1;
        _xpEarned += 2;
        _mastery[term.id] = (_mastery[term.id] ?? 0) + 1;
      } else {
        _xpEarned += 1;
        _mastery[term.id] = 0;
      }
    });
    if (correct && _trackProgress) {
      final mastered = (_mastery[term.id] ?? 0) >= 2;
      if (mastered && !_learnedIds.contains(term.id)) {
        _learnedIds.add(term.id);
        _markLearned(term);
      }
    }
  }

  Future<void> _markLearned(UserLessonTermData term) async {
    final repo = ref.read(lessonRepositoryProvider);
    await repo.updateTermLearned(
      term.id,
      lessonId: widget.lessonId,
      isLearned: true,
    );
    final now = DateTime.now();
    await repo.upsertSrsState(
      termId: term.id,
      box: 1,
      repetitions: 0,
      ease: 2.5,
      lastReviewedAt: now,
      nextReviewAt: now.add(const Duration(days: 1)),
    );
    ref.invalidate(lessonMetaProvider(widget.level.shortLabel));
  }
}

class _LearnQuestion {
  const _LearnQuestion({
    required this.term,
    required this.prompt,
    required this.subtitle,
    required this.choices,
    required this.correctAnswer,
  });

  final UserLessonTermData term;
  final String prompt;
  final String subtitle;
  final List<String> choices;
  final String correctAnswer;
}
class _TestMode extends ConsumerStatefulWidget {
  const _TestMode({
    required this.lessonId,
    required this.level,
    required this.language,
    required this.terms,
    required this.questionLimit,
  });

  final int lessonId;
  final StudyLevel level;
  final AppLanguage language;
  final List<UserLessonTermData> terms;
  final int questionLimit;

  @override
  ConsumerState<_TestMode> createState() => _TestModeState();
}

class _TestModeState extends ConsumerState<_TestMode> {
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();
  late final DateTime _startedAt;
  late List<_TestQuestion> _questions;
  final List<_TestAnswer> _answers = [];
  int _index = 0;
  int _xpEarned = 0;
  late final LessonRepository _lessonRepo;

  @override
  void initState() {
    super.initState();
    _lessonRepo = ref.read(lessonRepositoryProvider);
    _startedAt = DateTime.now();
    _questions = _buildQuestions();
  }

  @override
  void dispose() {
    _answerController.dispose();
    if (_answers.isNotEmpty) {
      final score = _answers.where((a) => a.correct).length;
      final total = _answers.length;
      _lessonRepo.recordAttempt(
        mode: 'test',
        level: widget.level.shortLabel,
        startedAt: _startedAt,
        finishedAt: DateTime.now(),
        score: score,
        total: total,
        answers: _answers
            .map(
              (answer) => AttemptAnswerDraft(
                questionId: answer.questionId,
                selectedIndex: answer.selectedIndex,
                isCorrect: answer.correct,
              ),
            )
            .toList(),
      );
      if (_xpEarned > 0) {
        _lessonRepo.recordStudyActivity(xpDelta: _xpEarned);
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = widget.language;
    if (_index >= _questions.length) {
      return _TestSummary(
        language: language,
        answers: _answers,
        onRestart: _restart,
      );
    }
    final question = _questions[_index];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            language.testProgressLabel(_index + 1, _questions.length),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _QuestionCard(
              title: question.prompt,
              subtitle: question.subtitle,
              child: question.type == _TestQuestionType.choice
                  ? _ChoiceList(
                      choices: question.choices,
                      enabled: true,
                      onSelected: (value) => _submitChoice(question, value),
                    )
                  : _WriteAnswer(
                      controller: _answerController,
                      enabled: true,
                      onCheck: () => _submitWritten(question),
                      checkLabel: language.checkLabel,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _restart() {
    setState(() {
      _index = 0;
      _answers.clear();
      _questions = _buildQuestions();
      _xpEarned = 0;
    });
  }

  List<_TestQuestion> _buildQuestions() {
    final shuffled = List<UserLessonTermData>.from(widget.terms)
      ..shuffle(_random);
    final limit =
        widget.questionLimit <= 0 ? shuffled.length : widget.questionLimit;
    final count = min(limit, shuffled.length);
    final selected = shuffled.take(count).toList();
    final questions = <_TestQuestion>[];
    for (var i = 0; i < selected.length; i++) {
      final term = selected[i];
      final useChoice = i.isEven && _termMeaning(term).isNotEmpty;
      if (useChoice) {
        final choices = _buildChoices(term, widget.terms);
        questions.add(
          _TestQuestion(
            term: term,
            type: _TestQuestionType.choice,
            prompt: term.term,
            subtitle: term.reading,
            choices: choices,
            correctAnswer: _termMeaning(term),
          ),
        );
      } else {
        questions.add(
          _TestQuestion(
            term: term,
            type: _TestQuestionType.written,
            prompt: _termMeaning(term),
            subtitle: term.reading,
            choices: const [],
            correctAnswer: term.term,
          ),
        );
      }
    }
    return questions;
  }

  void _submitChoice(_TestQuestion question, String value) {
    final correct = value == question.correctAnswer;
    _answers.add(
      _TestAnswer(
        questionId: question.term.id,
        correct: correct,
        selectedIndex: question.choices.indexOf(value),
        userAnswer: value,
        correctAnswer: question.correctAnswer,
      ),
    );
    _advance(correct);
  }

  void _submitWritten(_TestQuestion question) {
    final input = _answerController.text;
    _answerController.clear();
    final correct = _matchesAnswer(input, question.term);
    _answers.add(
      _TestAnswer(
        questionId: question.term.id,
        correct: correct,
        selectedIndex: -1,
        userAnswer: input,
        correctAnswer: question.correctAnswer,
      ),
    );
    _advance(correct);
  }

  void _advance(bool correct) {
    setState(() {
      _xpEarned += correct ? 4 : 1;
      _index += 1;
    });
  }
}
class _MatchMode extends ConsumerStatefulWidget {
  const _MatchMode({
    required this.lessonId,
    required this.level,
    required this.language,
    required this.terms,
    required this.pairLimit,
  });

  final int lessonId;
  final StudyLevel level;
  final AppLanguage language;
  final List<UserLessonTermData> terms;
  final int pairLimit;

  @override
  ConsumerState<_MatchMode> createState() => _MatchModeState();
}

class _MatchModeState extends ConsumerState<_MatchMode> {
  final Random _random = Random();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _elapsedSeconds = 0;
  int? _firstIndex;
  bool _finished = false;
  late List<_MatchCard> _cards;

  @override
  void initState() {
    super.initState();
    _buildCards();
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _elapsedSeconds = _stopwatch.elapsed.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = widget.language;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                language.matchTimeLabel(_elapsedSeconds),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                language.matchPairsLabel(
                  _matchedPairs(),
                  _cards.length ~/ 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width >= 900
                    ? 4
                    : width >= 600
                        ? 3
                        : 2;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    final card = _cards[index];
                    final isRevealed = card.matched || card.revealed;
                    return GestureDetector(
                      onTap: _finished ? null : () => _onCardTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isRevealed
                              ? const Color(0xFFEFF2FF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE1E6F0)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              isRevealed ? card.label : '?',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_finished)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                language.matchFinishedLabel(_elapsedSeconds),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  void _buildCards() {
    final limit =
        widget.pairLimit <= 0 ? widget.terms.length : widget.pairLimit;
    final pairCount = min(limit, widget.terms.length);
    final pairs = widget.terms.take(pairCount).toList();
    final cards = <_MatchCard>[];
    for (final term in pairs) {
      cards.add(
        _MatchCard(
          pairId: term.id,
          label: term.term,
        ),
      );
      cards.add(
        _MatchCard(
          pairId: term.id,
          label: _termMeaning(term),
        ),
      );
    }
    cards.shuffle(_random);
    _cards = cards;
  }

  int _matchedPairs() {
    final matched = _cards.where((card) => card.matched).length;
    return matched ~/ 2;
  }

  void _onCardTap(int index) {
    final card = _cards[index];
    if (card.matched || card.revealed) {
      return;
    }
    setState(() {
      card.revealed = true;
    });
    if (_firstIndex == null) {
      _firstIndex = index;
      return;
    }
    final firstIndex = _firstIndex!;
    if (firstIndex == index) {
      return;
    }
    final firstCard = _cards[firstIndex];
    final isMatch = firstCard.pairId == card.pairId;
    if (isMatch) {
      setState(() {
        firstCard.matched = true;
        card.matched = true;
        _firstIndex = null;
      });
      if (_matchedPairs() == _cards.length ~/ 2) {
        _finishMatch();
      }
    } else {
      Future.delayed(const Duration(milliseconds: 650), () {
        if (!mounted) {
          return;
        }
        setState(() {
          firstCard.revealed = false;
          card.revealed = false;
          _firstIndex = null;
        });
      });
    }
  }

  void _finishMatch() {
    _stopwatch.stop();
    _timer?.cancel();
    setState(() {
      _finished = true;
    });
    final repo = ref.read(lessonRepositoryProvider);
    repo.recordStudyActivity(xpDelta: _cards.length);
  }
}
class _WriteSpellMode extends ConsumerStatefulWidget {
  const _WriteSpellMode({
    required this.lessonId,
    required this.level,
    required this.language,
    required this.terms,
    required this.useAudioPrompt,
  });

  final int lessonId;
  final StudyLevel level;
  final AppLanguage language;
  final List<UserLessonTermData> terms;
  final bool useAudioPrompt;

  @override
  ConsumerState<_WriteSpellMode> createState() => _WriteSpellModeState();
}

class _WriteSpellModeState extends ConsumerState<_WriteSpellMode> {
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();
  late final AudioPlayer _audioPlayer;
  late final TtsService _ttsService;
  late final LessonRepository _lessonRepo;
  int _index = 0;
  int _correctCount = 0;
  int _answeredCount = 0;
  int _xpEarned = 0;
  bool _showResult = false;
  bool _lastCorrect = false;
  late List<UserLessonTermData> _queue;

  @override
  void initState() {
    super.initState();
    _lessonRepo = ref.read(lessonRepositoryProvider);
    _audioPlayer = AudioPlayer();
    _ttsService = TtsService();
    _queue = List<UserLessonTermData>.from(widget.terms)..shuffle(_random);
    if (widget.useAudioPrompt) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _playPrompt());
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _audioPlayer.dispose();
    _ttsService.dispose();
    if (_xpEarned > 0) {
      _lessonRepo.recordStudyActivity(xpDelta: _xpEarned);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = widget.language;
    if (_index >= _queue.length) {
      return _CompletionPanel(
        title: widget.useAudioPrompt
            ? language.spellCompleteLabel
            : language.writeCompleteLabel,
        subtitle: language.practiceSummaryLabel(
          _correctCount,
          _answeredCount,
        ),
        onRestart: _restart,
        restartLabel: language.restartLabel,
      );
    }
    final term = _queue[_index];
    final prompt = widget.useAudioPrompt
        ? language.spellPromptLabel
        : _termMeaning(term);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            language.practiceProgressLabel(_index + 1, _queue.length),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _QuestionCard(
              title: prompt,
              subtitle: term.reading,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.useAudioPrompt)
                    TextButton.icon(
                      onPressed: _playPrompt,
                      icon: const Icon(Icons.volume_up_outlined),
                      label: Text(language.playAudioLabel),
                    ),
                  const SizedBox(height: 12),
                  _WriteAnswer(
                    controller: _answerController,
                    enabled: !_showResult,
                    onCheck: () => _submit(term),
                    checkLabel: language.checkLabel,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _ResultBar(
            visible: _showResult,
            correct: _lastCorrect,
            correctLabel: language.correctLabel,
            incorrectLabel: language.incorrectLabel,
            onNext: () => _next(term),
            nextLabel: language.nextLabel,
          ),
        ],
      ),
    );
  }

  void _restart() {
    setState(() {
      _index = 0;
      _correctCount = 0;
      _answeredCount = 0;
      _xpEarned = 0;
      _showResult = false;
      _queue = List<UserLessonTermData>.from(widget.terms)..shuffle(_random);
    });
    if (widget.useAudioPrompt) {
      _playPrompt();
    }
  }

  void _submit(UserLessonTermData term) {
    final input = _answerController.text;
    final correct = _matchesAnswer(input, term);
    setState(() {
      _answeredCount += 1;
      _showResult = true;
      _lastCorrect = correct;
      if (correct) {
        _correctCount += 1;
        _xpEarned += 2;
      } else {
        _xpEarned += 1;
      }
    });
  }

  void _next(UserLessonTermData term) {
    setState(() {
      _showResult = false;
      _answerController.clear();
      _index += 1;
    });
    if (widget.useAudioPrompt && _index < _queue.length) {
      _playPrompt();
    }
  }

  Future<void> _playPrompt() async {
    final term = _index < _queue.length ? _queue[_index] : null;
    if (term == null) {
      return;
    }
    final text = term.reading.isNotEmpty ? term.reading : term.term;
    if (text.trim().isEmpty) {
      return;
    }
    try {
      final file = await _ttsService.synthesize(
        text: text,
        locale: _ttsLocaleForLanguage(widget.language),
        voice: 'female',
      );
      await _audioPlayer.stop();
      await _audioPlayer.setFilePath(file.path);
      await _audioPlayer.play();
    } on TtsNotConfiguredException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.language.audioNotConfigured)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.language.audioErrorLabel)),
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
}
class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7390)),
            ),
          ],
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _ChoiceList extends StatelessWidget {
  const _ChoiceList({
    required this.choices,
    required this.enabled,
    required this.onSelected,
  });

  final List<String> choices;
  final bool enabled;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final choice in choices)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: enabled ? () => onSelected(choice) : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(choice, textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _WriteAnswer extends StatelessWidget {
  const _WriteAnswer({
    required this.controller,
    required this.enabled,
    required this.onCheck,
    required this.checkLabel,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onCheck;
  final String checkLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: const InputDecoration(),
          textAlign: TextAlign.center,
          onSubmitted: (_) => enabled ? onCheck() : null,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: enabled ? onCheck : null,
          child: Text(checkLabel),
        ),
      ],
    );
  }
}

class _ResultBar extends StatelessWidget {
  const _ResultBar({
    required this.visible,
    required this.correct,
    required this.correctLabel,
    required this.incorrectLabel,
    required this.onNext,
    required this.nextLabel,
  });

  final bool visible;
  final bool correct;
  final String correctLabel;
  final String incorrectLabel;
  final VoidCallback onNext;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }
    final color = correct ? const Color(0xFFEFFAF0) : const Color(0xFFFFF2F2);
    final text = correct ? correctLabel : incorrectLabel;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E6F0)),
      ),
      child: Row(
        children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          TextButton(
            onPressed: onNext,
            child: Text(nextLabel),
          ),
        ],
      ),
    );
  }
}

class _CompletionPanel extends StatelessWidget {
  const _CompletionPanel({
    required this.title,
    required this.subtitle,
    required this.onRestart,
    required this.restartLabel,
  });

  final String title;
  final String subtitle;
  final VoidCallback onRestart;
  final String restartLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRestart,
              child: Text(restartLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestSummary extends StatelessWidget {
  const _TestSummary({
    required this.language,
    required this.answers,
    required this.onRestart,
  });

  final AppLanguage language;
  final List<_TestAnswer> answers;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final total = answers.length;
    final correct = answers.where((a) => a.correct).length;
    final accuracy = total == 0 ? 0 : (correct / total * 100).round();
    final wrong = answers.where((a) => !a.correct).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            language.testScoreLabel(correct, total, accuracy),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: wrong.isEmpty
                ? Center(child: Text(language.testAllCorrectLabel))
                : ListView.separated(
                    itemCount: wrong.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final answer = wrong[index];
                      return ListTile(
                        title: Text(language.testWrongLabel(answer.correctAnswer)),
                        subtitle: Text(
                          language.testYourAnswerLabel(answer.userAnswer),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRestart,
            child: Text(language.retryLabel),
          ),
        ],
      ),
    );
  }
}

class _MatchCard {
  _MatchCard({
    required this.pairId,
    required this.label,
  });

  final int pairId;
  final String label;
  bool matched = false;
  bool revealed = false;
}

class _TestQuestion {
  const _TestQuestion({
    required this.term,
    required this.type,
    required this.prompt,
    required this.subtitle,
    required this.choices,
    required this.correctAnswer,
  });

  final UserLessonTermData term;
  final _TestQuestionType type;
  final String prompt;
  final String subtitle;
  final List<String> choices;
  final String correctAnswer;
}

enum _TestQuestionType { choice, written }

class _TestAnswer {
  const _TestAnswer({
    required this.questionId,
    required this.correct,
    required this.selectedIndex,
    required this.userAnswer,
    required this.correctAnswer,
  });

  final int questionId;
  final bool correct;
  final int selectedIndex;
  final String userAnswer;
  final String correctAnswer;
}
String _termMeaning(UserLessonTermData term) {
  if (term.definition.trim().isNotEmpty) {
    return term.definition.trim();
  }
  if (term.reading.trim().isNotEmpty) {
    return term.reading.trim();
  }
  return term.term.trim();
}

List<String> _buildChoices(
  UserLessonTermData term,
  List<UserLessonTermData> allTerms,
) {
  final random = Random();
  final options = <String>{_termMeaning(term)};
  final pool = allTerms
      .where((other) => other.id != term.id)
      .map(_termMeaning)
      .where((value) => value.isNotEmpty)
      .toList()
    ..shuffle(random);
  for (final item in pool) {
    if (options.length >= 4) {
      break;
    }
    options.add(item);
  }
  final list = options.toList()..shuffle(random);
  return list;
}

bool _matchesAnswer(String input, UserLessonTermData term) {
  final normalized = _normalizeAnswer(input);
  if (normalized.isEmpty) {
    return false;
  }
  return normalized == _normalizeAnswer(term.term) ||
      normalized == _normalizeAnswer(term.reading);
}

String _normalizeAnswer(String value) {
  return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
}
