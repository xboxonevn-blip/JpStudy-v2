import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/vocab_item.dart';
import '../models/flashcard_session.dart';
import '../models/flashcard_settings.dart';
import '../models/swipe_action.dart';
import '../widgets/enhanced_flashcard.dart';
import '../widgets/flashcard_settings_dialog.dart';
import '../widgets/flashcard_summary.dart';

class EnhancedFlashcardScreen extends ConsumerStatefulWidget {
  final List<VocabItem> items;
  final int lessonId;
  final String lessonTitle;

  const EnhancedFlashcardScreen({
    super.key,
    required this.items,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  ConsumerState<EnhancedFlashcardScreen> createState() =>
      _EnhancedFlashcardScreenState();
}

class _EnhancedFlashcardScreenState
    extends ConsumerState<EnhancedFlashcardScreen> {
  int _currentIndex = 0;
  late FlashcardSession _session;
  late List<VocabItem> _displayItems;
  FlashcardSettings _settings = const FlashcardSettings();

  @override
  void initState() {
    super.initState();
    _initSession();
  }

  void _initSession() {
    _displayItems = _settings.shuffleCards
        ? (List.from(widget.items)..shuffle())
        : widget.items;

    _session = FlashcardSession(
      sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
      lessonId: widget.lessonId,
      startedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = _displayItems[_currentIndex];
    final progress = (_currentIndex + 1) / _displayItems.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: _showSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          _buildProgressBar(progress),

          // Stats row
          _buildStatsRow(),

          // Flashcard
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: EnhancedFlashcard(
                key: ValueKey(currentItem.id),
                item: currentItem,
                enableSwipeGestures: _settings.enableSwipeGestures,
                showTermFirst: _settings.showTermFirst,
                onSwipe: _handleSwipe,
              ),
            ),
          ),

          // Bottom navigation
          if (!_settings.enableSwipeGestures) _buildManualButtons(),

          // Card counter
          _buildCardCounter(),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatChip(
            icon: Icons.check_circle_rounded,
            label: 'Known',
            value: _session.knownTermIds.length,
            color: Colors.green,
          ),
          _buildStatChip(
            icon: Icons.replay_rounded,
            label: 'Practice',
            value: _session.needPracticeTermIds.length,
            color: Colors.orange,
          ),
          _buildStatChip(
            icon: Icons.star_rounded,
            label: 'Starred',
            value: _session.starredTermIds.length,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            '$value',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleSwipe(SwipeAction.needPractice),
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Need Practice'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleSwipe(SwipeAction.know),
              icon: const Icon(Icons.check_rounded),
              label: const Text('Know It'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardCounter() {
    return Text(
      '${_currentIndex + 1} / ${_displayItems.length}',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
    );
  }

  void _handleSwipe(SwipeAction action) {
    final currentItem = _displayItems[_currentIndex];

    // Update session
    switch (action) {
      case SwipeAction.know:
        _session.knownTermIds.add(currentItem.id);
        break;
      case SwipeAction.needPractice:
        _session.needPracticeTermIds.add(currentItem.id);
        break;
      case SwipeAction.star:
        _session.starredTermIds.add(currentItem.id);
        // Don't advance to next card for star
        setState(() {});
        return;
      case SwipeAction.skip:
        _session.skippedTermIds.add(currentItem.id);
        break;
    }

    // Move to next card or show summary
    setState(() {
      if (_currentIndex < _displayItems.length - 1) {
        _currentIndex++;
      } else {
        _showSummary();
      }
    });
  }

  void _showSettings() {
    showFlashcardSettingsDialog(
      context,
      currentSettings: _settings,
      onSave: (newSettings) {
        setState(() {
          _settings = newSettings;
          if (newSettings.shuffleCards != _settings.shuffleCards) {
            _displayItems = newSettings.shuffleCards
                ? (List.from(widget.items)..shuffle())
                : widget.items;
          }
        });
      },
    );
  }

  void _showSummary() {
    _session.completedAt = DateTime.now();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FlashcardSummaryScreen(
          session: _session,
          onPracticeAgain: () {
            // Practice only terms that need practice
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => EnhancedFlashcardScreen(
                  items: widget.items
                      .where((item) =>
                          _session.needPracticeTermIds.contains(item.id))
                      .toList(),
                  lessonId: widget.lessonId,
                  lessonTitle: '${widget.lessonTitle} (Practice)',
                ),
              ),
            );
          },
          onDone: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
