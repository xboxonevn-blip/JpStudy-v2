import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/core/widgets/juicy_button.dart';
import 'package:jpstudy/data/models/vocab_item.dart';
import 'package:jpstudy/data/repositories/content_repository.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

class KanjiDashScreen extends ConsumerStatefulWidget {
  const KanjiDashScreen({super.key});

  @override
  ConsumerState<KanjiDashScreen> createState() => _KanjiDashScreenState();
}

class _KanjiDashScreenState extends ConsumerState<KanjiDashScreen> {
  Timer? _timer;
  double _timeLeft = 30.0; // Starts with 30 seconds
  int _score = 0;
  bool _isGameActive = false;
  bool _isGameOver = false;
  
  VocabItem? _currentQuestion;
  List<String> _options = [];
  List<VocabItem> _vocabPool = [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame(List<VocabItem> vocab) {
    if (vocab.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Need at least 4 vocabulary words to play')),
      );
      return;
    }

    setState(() {
      _vocabPool = List.from(vocab)..shuffle();
      _timeLeft = 30.0;
      _score = 0;
      _isGameActive = true;
      _isGameOver = false;
    });

    _nextQuestion();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _timeLeft -= 0.05;
        if (_timeLeft <= 0) {
          _endGame();
        }
      });
    });
  }

  void _nextQuestion() {
    if (_vocabPool.isEmpty) return;

    final random = Random();
    _currentQuestion = _vocabPool[random.nextInt(_vocabPool.length)];
    
    // Generate 3 wrong answers
    final wrongAnswers = _vocabPool
        .where((v) => v.id != _currentQuestion!.id)
        .toList()
      ..shuffle();
    
    final wrongOptions = wrongAnswers.take(3).map((v) => v.meaning).toList();
    
    // Mix correct answer with wrong ones
    final allOptions = [...wrongOptions, _currentQuestion!.meaning]..shuffle();
    
    setState(() {
      _options = allOptions;
    });
  }

  void _handleAnswer(String selectedMeaning) {
    if (!_isGameActive) return;

    final isCorrect = selectedMeaning == _currentQuestion!.meaning;
    
    if (isCorrect) {
      HapticFeedback.mediumImpact();
      setState(() {
        _score++;
        _timeLeft += 3.0; // Bonus time for correct answer
        if (_timeLeft > 60) _timeLeft = 60; // Cap at 60s
      });
      _nextQuestion();
    } else {
      HapticFeedback.vibrate();
      setState(() {
        _timeLeft -= 2.0; // Penalty for wrong answer
      });
    }
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _isGameActive = false;
      _isGameOver = true;
    });

    // Award XP based on score
    final xp = _score * 5; // 5 XP per correct answer
    ref.read(lessonRepositoryProvider).recordStudyActivity(xpDelta: xp);
  }

  @override
  Widget build(BuildContext context) {
    final level = ref.watch(studyLevelProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Kanji Dash${level != null ? ' (${level.shortLabel})' : ''}'),
      ),
      body: level == null
          ? const Center(child: Text('Select a level first.'))
          : _buildBody(level),
    );
  }

  Widget _buildBody(StudyLevel level) {
    final language = ref.watch(appLanguageProvider);
    final vocabAsync = ref.watch(vocabPreviewProvider(level.shortLabel));

    return vocabAsync.when(
      data: (dataItems) {
        if (dataItems.isEmpty) {
          return const Center(child: Text('No vocabulary found.'));
        }

        final items = dataItems
            .map((e) => _mapToVocabItem(e, language))
            .toList();

        if (_isGameOver) {
          return _buildGameOver();
        }

        if (!_isGameActive) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flash_on, size: 80, color: Colors.amber),
                const SizedBox(height: 24),
                const Text(
                  'Kanji Dash',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Answer quickly to extend your time!\n+3s for correct, -2s for wrong',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 32),
                JuicyButton(
                  label: 'Start',
                  onPressed: () => _startGame(items),
                  icon: Icons.play_arrow,
                  height: 64,
                ),
              ],
            ),
          );
        }

        return _buildGame();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildGame() {
    final theme = Theme.of(context);
    final progress = _timeLeft / 60.0;

    return Column(
      children: [
        // Timer bar
        SizedBox(
          height: 8,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(
              progress > 0.3 ? Colors.green : Colors.red,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time: ${_timeLeft.toStringAsFixed(1)}s',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: progress > 0.3 ? Colors.green : Colors.red,
                ),
              ),
              Text(
                'Score: $_score',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Question
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Text(
                _currentQuestion?.term ?? '',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _currentQuestion?.reading ?? '',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        // Options
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: _options.map((meaning) {
              return _buildOptionButton(meaning);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(String meaning) {
    return ElevatedButton(
      onPressed: () => _handleAnswer(meaning),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          meaning,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildGameOver() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
          const SizedBox(height: 24),
          Text(
            'Final Score: $_score',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          Text(
            '+${_score * 5} XP',
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 32),
          JuicyButton(
            label: 'Play Again',
            onPressed: () {
              final vocabAsync = ref.read(vocabPreviewProvider(
                ref.read(studyLevelProvider)!.shortLabel,
              ));
              vocabAsync.whenData((dataItems) {
                final language = ref.read(appLanguageProvider);
                final items = dataItems
                    .map((e) => _mapToVocabItem(e, language))
                    .toList();
                _startGame(items);
              });
            },
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  VocabItem _mapToVocabItem(dynamic source, AppLanguage language) {
    final meaningEn = (source.meaningEn ?? '').toString().trim();
    final meaning = language == AppLanguage.en
        ? (meaningEn.isNotEmpty ? meaningEn : source.meaning)
        : source.meaning;
    return VocabItem(
      id: source.id,
      term: source.term,
      reading: source.reading,
      meaning: meaning,
      meaningEn: source.meaningEn,
      level: source.level,
    );
  }
}
