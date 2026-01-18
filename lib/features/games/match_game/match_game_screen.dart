import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/models/vocab_item.dart';
import 'package:jpstudy/data/repositories/content_repository.dart';
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame(List<VocabItem> allVocab) {
    if (allVocab.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not enough vocabulary for a game (need at least 3).")),
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
        });
        _checkWinCondition();
      } else {
        // Mismatch
        setState(() {
          first.state = MatchCardState.mismatched;
          second.state = MatchCardState.mismatched;
        });

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
  }

  @override
  Widget build(BuildContext context) {
    final level = ref.watch(studyLevelProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Match Game${level != null ? ' (${level.shortLabel})' : ''}"),
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
          ? const Center(child: Text("Select a level first."))
          : _buildBody(level),
    );
  }

  Widget _buildBody(StudyLevel level) {
    final vocabAsync = ref.watch(vocabPreviewProvider(level.shortLabel));

    return vocabAsync.when(
      data: (dataItems) {
         if (dataItems.isEmpty) return const Center(child: Text("No vocabulary found."));

         // Map to VocabItem
         final items = dataItems.map((e) => VocabItem(
          id: e.id,
          term: e.term,
          reading: e.reading,
          meaning: e.meaning,
          level: e.level,
        )).toList();

        if (_isGameOver) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, size: 64, color: Colors.blue),
                const SizedBox(height: 16),
                Text("Time: ${_secondsElapsed}s", style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _startGame(items),
                  child: const Text("Play Again"),
                )
              ],
            ),
          );
        }

        if (!_isGameActive) {
          return Center(
             child: ElevatedButton.icon(
              onPressed: () => _startGame(items),
              icon: const Icon(Icons.play_circle_filled),
              label: const Text("Start Match Game"),
            ),
          );
        }

        return GridView.builder(
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
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Error: $e")),
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
              color: Colors.black.withOpacity(0.05),
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
