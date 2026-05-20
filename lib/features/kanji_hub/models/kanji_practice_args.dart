enum KanjiPracticeMode { read, write, both }

class KanjiPracticeArgs {
  const KanjiPracticeArgs({
    required this.mode,
    required this.source,
    this.levelCode,
    this.kanjiIds = const [],
    this.kanjiCharacters = const [],
    this.preferredKanjiId,
    this.preferredKanjiCharacter,
  });

  final KanjiPracticeMode mode;
  final String source;
  final String? levelCode;
  final List<int> kanjiIds;
  final List<String> kanjiCharacters;
  final int? preferredKanjiId;
  final String? preferredKanjiCharacter;

  KanjiPracticeArgs copyWith({
    KanjiPracticeMode? mode,
    String? source,
    String? levelCode,
    List<int>? kanjiIds,
    List<String>? kanjiCharacters,
    int? preferredKanjiId,
    String? preferredKanjiCharacter,
  }) {
    return KanjiPracticeArgs(
      mode: mode ?? this.mode,
      source: source ?? this.source,
      levelCode: levelCode ?? this.levelCode,
      kanjiIds: kanjiIds ?? this.kanjiIds,
      kanjiCharacters: kanjiCharacters ?? this.kanjiCharacters,
      preferredKanjiId: preferredKanjiId ?? this.preferredKanjiId,
      preferredKanjiCharacter:
          preferredKanjiCharacter ?? this.preferredKanjiCharacter,
    );
  }
}
