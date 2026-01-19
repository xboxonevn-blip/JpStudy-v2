class FlashcardSettings {
  final bool showTermFirst;
  final bool autoPlayTTS;
  final bool enableSwipeGestures;
  final bool showOnlyStarred;
  final bool shuffleCards;

  const FlashcardSettings({
    this.showTermFirst = true,
    this.autoPlayTTS = false,
    this.enableSwipeGestures = true,
    this.showOnlyStarred = false,
    this.shuffleCards = false,
  });

  FlashcardSettings copyWith({
    bool? showTermFirst,
    bool? autoPlayTTS,
    bool? enableSwipeGestures,
    bool? showOnlyStarred,
    bool? shuffleCards,
  }) {
    return FlashcardSettings(
      showTermFirst: showTermFirst ?? this.showTermFirst,
      autoPlayTTS: autoPlayTTS ?? this.autoPlayTTS,
      enableSwipeGestures: enableSwipeGestures ?? this.enableSwipeGestures,
      showOnlyStarred: showOnlyStarred ?? this.showOnlyStarred,
      shuffleCards: shuffleCards ?? this.shuffleCards,
    );
  }
}
