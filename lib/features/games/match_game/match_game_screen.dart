import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/widgets/juicy_button.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/models/vocab_item.dart';
import 'package:jpstudy/data/repositories/content_repository.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/games/match_game/logic/match_engine.dart';

class MatchGameScreen extends ConsumerStatefulWidget {
  const MatchGameScreen({super.key});

  @override
  ConsumerState<MatchGameScreen> createState() => _MatchGameScreenState();
}

class _MatchGameScreenState extends ConsumerState<MatchGameScreen> {
  List<MatchCard> _cards = [];
  MatchCard? _selectedCard;
  bool _isProcessingInfo = false;
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isGameActive = false;
  bool _isGameOver = false;
  int _combo = 0;
  int _maxCombo = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame(List<VocabItem> allVocab) {
    final language = ref.read(appLanguageProvider);
    if (allVocab.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language.notEnoughTermsLabel(3))),
      );
      return;
    }

    final engine = MatchEngine(allVocab);
    setState(() {
      _cards = engine.generateGame(6); // 6 pairs = 12 cards
      _selectedCard = null;
      _isGameActive = true;
      _isGameOver = false;
      _secondsElapsed = 0;
      _combo = 0;
      _maxCombo = 0;
      _isProcessingInfo = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _onCardTap(MatchCard card) {
    if (!_isGameActive || _isProcessingInfo || card.state == MatchCardState.matched) return;
    if (card == _selectedCard) return; // Tap same card

    setState(() {
      card.state = MatchCardState.selected;
    });

    if (_selectedCard == null) {
      // First card selected
      _selectedCard = card;
      HapticFeedback.selectionClick();
    } else {
      // Second card selected -> Check match
      _isProcessingInfo = true;
      final first = _selectedCard!;
      final second = card;

      if (first.vocabId == second.vocabId) {
        // Match!
        setState(() {
          first.state = MatchCardState.matched;
          second.state = MatchCardState.matched;
          _selectedCard = null;
          _isProcessingInfo = false;
          _combo++;
          if (_combo > _maxCombo) _maxCombo = _combo;
        });
        HapticFeedback.mediumImpact();
        // Save Progress (Correct)
        ref.read(contentRepositoryProvider).updateProgress(first.vocabId, true);
        
        _checkWinCondition();
      } else {
        // Mismatch
        setState(() {
          first.state = MatchCardState.mismatched;
          second.state = MatchCardState.mismatched;
          _combo = 0; // Reset combo
        });
        HapticFeedback.vibrate();

        // Save Progress (Incorrect)
        ref.read(contentRepositoryProvider).updateProgress(first.vocabId, false);
        ref.read(contentRepositoryProvider).updateProgress(second.vocabId, false);

        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              first.state = MatchCardState.defaultState;
              second.state = MatchCardState.defaultState;
              _selectedCard = null;
              _isProcessingInfo = false;
            });
          }
        });
      }
    }
  }

  void _checkWinCondition() {
    if (_cards.every((c) => c.state == MatchCardState.matched)) {
      _endGame();
    }
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _isGameActive = false;
      _isGameOver = true;
    });
    
    // Award XP based on performance
    // Base: 10 XP per pair, Combo bonus: 2 XP per max combo, Time bonus: up to 20 XP for fast completion
    final baseXp = (_cards.length ~/ 2) * 10; // 6 pairs = 60 XP
    final comboBonus = _maxCombo * 2;
    final timeBonus = _secondsElapsed < 30 ? 20 : (_secondsElapsed < 60 ? 10 : 0);
    final totalXp = baseXp + comboBonus + timeBonus;
    
    ref.read(lessonRepositoryProvider).recordStudyActivity(xpDelta: totalXp);
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${language.matchGameLabel}${level != null ? ' (${level.shortLabel})' : ''}',
        ),
        actions: [
          if (_isGameActive || _isGameOver)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  "${_secondsElapsed}s",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
        ],
      ),
      body: level == null
          ? Center(child: Text(language.selectLevelFirstLabel))
          : _buildBody(level),
    );
  }

  Widget _buildBody(StudyLevel level) {
    final vocabAsync = ref.watch(vocabPreviewProvider(level.shortLabel));

    return vocabAsync.when(
      data: (dataItems) {
         final language = ref.read(appLanguageProvider);
         if (dataItems.isEmpty) {
           return Center(child: Text(language.noVocabFoundLabel));
         }

         // Map to VocabItem
         final items = dataItems.map((e) {
          final meaningEn = e.meaningEn?.trim() ?? '';
          final meaning = language == AppLanguage.vi
              ? e.meaning
              : (meaningEn.isNotEmpty ? meaningEn : e.meaning);
          return VocabItem(
            id: e.id,
            term: e.term,
            reading: e.reading,
            meaning: meaning,
            meaningEn: e.meaningEn,
            level: e.level,
          );
        }).toList();

        if (_isGameOver) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events_rounded, size: 64, color: Colors.amber),
                const SizedBox(height: 16),
                Text(
                  language.timeSecondsLabel(_secondsElapsed),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  language.maxComboLabel(_maxCombo),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.deepPurple),
                ),
                const SizedBox(height: 24),
                JuicyButton(
                  label: language.playAgainLabel,
                  onPressed: () => _startGame(items),
                  icon: Icons.refresh,
                )
              ],
            ),
          );
        }

        if (!_isGameActive) {
         return Center(
             child: JuicyButton(
              label: language.startMatchGameLabel,
              onPressed: () => _startGame(items),
              icon: Icons.play_circle_filled,
              height: 64,
            ),
          );
        }

        return Column(
          children: [
            if (_combo > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AnimatedScale(
                  scale: 1.0 + (_combo * 0.1).clamp(0.0, 0.5),
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    language.comboLabel(_combo),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.orange,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return _buildCard(_cards[index]);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(
        child: Text(ref.read(appLanguageProvider).loadErrorLabel),
      ),
    );
  }

  Widget _buildCard(MatchCard card) {
    if (card.state == MatchCardState.matched) {
      return const SizedBox(); // Hide matched cards
    }

    Color color = Theme.of(context).cardColor;
    if (card.state == MatchCardState.selected) color = Colors.blue.shade100;
    if (card.state == MatchCardState.mismatched) color = Colors.red.shade100;

    return GestureDetector(
      onTap: () => _onCardTap(card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: card.state == MatchCardState.selected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
             BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ]
        ),
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            card.content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
