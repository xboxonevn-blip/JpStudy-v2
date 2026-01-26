class FlashcardSession {
  final String sessionId;
  final int lessonId;
  final DateTime startedAt;
  DateTime? completedAt;
  final List<int> knownTermIds;
  final List<int> needPracticeTermIds;
  final List<int> starredTermIds;
  final List<int> skippedTermIds;

  FlashcardSession({
    required this.sessionId,
    required this.lessonId,
    required this.startedAt,
    this.completedAt,
    List<int>? knownTermIds,
    List<int>? needPracticeTermIds,
    List<int>? starredTermIds,
    List<int>? skippedTermIds,
  }) : knownTermIds = knownTermIds ?? [],
       needPracticeTermIds = needPracticeTermIds ?? [],
       starredTermIds = starredTermIds ?? [],
       skippedTermIds = skippedTermIds ?? [];

  int get totalSeen =>
      knownTermIds.length + needPracticeTermIds.length + skippedTermIds.length;

  double get accuracy {
    if (totalSeen == 0) return 0.0;
    return knownTermIds.length / totalSeen;
  }

  Duration? get duration {
    if (completedAt == null) return null;
    return completedAt!.difference(startedAt);
  }

  bool get isComplete => completedAt != null;

  int calculateXP() {
    int baseXP = knownTermIds.length * 5;

    // Bonus for high accuracy
    if (accuracy >= 0.9) {
      baseXP += 20; // 90%+ accuracy bonus
    }

    // Bonus for speed (if session < 10 minutes)
    if (duration != null && duration!.inMinutes < 10) {
      baseXP += 10;
    }

    return baseXP;
  }

  FlashcardSession copyWith({
    String? sessionId,
    int? lessonId,
    DateTime? startedAt,
    DateTime? completedAt,
    List<int>? knownTermIds,
    List<int>? needPracticeTermIds,
    List<int>? starredTermIds,
    List<int>? skippedTermIds,
  }) {
    return FlashcardSession(
      sessionId: sessionId ?? this.sessionId,
      lessonId: lessonId ?? this.lessonId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      knownTermIds: knownTermIds ?? this.knownTermIds,
      needPracticeTermIds: needPracticeTermIds ?? this.needPracticeTermIds,
      starredTermIds: starredTermIds ?? this.starredTermIds,
      skippedTermIds: skippedTermIds ?? this.skippedTermIds,
    );
  }
}
