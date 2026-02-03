class FlashcardSettings {
  final bool showTermFirst;
  final bool enableSwipeGestures;
  final bool showOnlyStarred;
  final bool shuffleCards;

  const FlashcardSettings({
    this.showTermFirst = true,
    this.enableSwipeGestures = true,
    this.showOnlyStarred = false,
    this.shuffleCards = false,
  });

  FlashcardSettings copyWith({
    bool? showTermFirst,
    bool? enableSwipeGestures,
    bool? showOnlyStarred,
    bool? shuffleCards,
  }) {
    return FlashcardSettings(
      showTermFirst: showTermFirst ?? this.showTermFirst,
      enableSwipeGestures: enableSwipeGestures ?? this.enableSwipeGestures,
      showOnlyStarred: showOnlyStarred ?? this.showOnlyStarred,
      shuffleCards: shuffleCards ?? this.shuffleCards,
    );
  }
}
