enum ExerciseMode {
  flashcard,
  recognition,
  production,
  recall,
  readingComp,
  listening,
  conjugationDrill,
  kanjiWriting,
}

extension ExerciseModeKey on ExerciseMode {
  String get key => switch (this) {
    ExerciseMode.flashcard => 'flashcard',
    ExerciseMode.recognition => 'recognition',
    ExerciseMode.production => 'production',
    ExerciseMode.recall => 'recall',
    ExerciseMode.readingComp => 'reading_comp',
    ExerciseMode.listening => 'listening',
    ExerciseMode.conjugationDrill => 'conjugation_drill',
    ExerciseMode.kanjiWriting => 'kanji_writing',
  };
}

class LegacySrsSnapshot {
  const LegacySrsSnapshot({
    required this.itemType,
    required this.itemId,
    required this.repetitions,
    required this.stability,
    required this.difficulty,
    required this.fsrsState,
    required this.fsrsStep,
    required this.lastConfidence,
    required this.lastReviewedAt,
    required this.nextReviewAt,
  });

  final String itemType;
  final String itemId;
  final int repetitions;
  final double stability;
  final double difficulty;
  final int fsrsState;
  final int? fsrsStep;
  final int lastConfidence;
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewAt;

  Map<String, Object?> toJson() => {
    'itemType': itemType,
    'itemId': itemId,
    'repetitions': repetitions,
    'stability': stability,
    'difficulty': difficulty,
    'fsrsState': fsrsState,
    'fsrsStep': fsrsStep,
    'lastConfidence': lastConfidence,
    'lastReviewedAt': lastReviewedAt?.toIso8601String(),
    'nextReviewAt': nextReviewAt?.toIso8601String(),
  };
}

class CrossModalSrsSnapshot {
  const CrossModalSrsSnapshot({
    required this.itemType,
    required this.itemId,
    required this.modes,
  });

  final String itemType;
  final String itemId;
  final Map<ExerciseMode, LegacySrsSnapshot> modes;

  Map<String, Object?> toJson() => {
    'itemType': itemType,
    'itemId': itemId,
    'modes': {
      for (final entry in modes.entries) entry.key.key: entry.value.toJson(),
    },
  };
}

class CrossModalSrsMigrator {
  const CrossModalSrsMigrator();

  List<CrossModalSrsSnapshot> migrateLegacy(
    Iterable<LegacySrsSnapshot> legacy, {
    ExerciseMode targetMode = ExerciseMode.flashcard,
  }) {
    final byItem = <String, CrossModalSrsSnapshot>{};
    for (final snapshot in legacy) {
      final key = '${snapshot.itemType}:${snapshot.itemId}';
      final existing = byItem[key];
      if (existing == null) {
        byItem[key] = CrossModalSrsSnapshot(
          itemType: snapshot.itemType,
          itemId: snapshot.itemId,
          modes: {targetMode: snapshot},
        );
      } else {
        existing.modes[targetMode] = snapshot;
      }
    }
    return byItem.values.toList(growable: false);
  }
}

class SrsStore {
  const SrsStore();

  @Deprecated('Self-attestation removed per Directive F.5')
  void markKnown(String itemId) {
    throw UnsupportedError('markKnown_removed_use_exercise_results');
  }
}
