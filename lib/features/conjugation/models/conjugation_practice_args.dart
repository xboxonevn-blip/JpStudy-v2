class ConjugationPracticeArgs {
  const ConjugationPracticeArgs({
    this.contentVocabIds,
    this.formKeys,
    this.directions,
    this.targetCount = 5,
    this.source = 'conjugation_practice',
    this.grammarId,
  });

  final List<int>? contentVocabIds;
  final List<String>? formKeys;
  final List<String>? directions;
  final int targetCount;
  final String source;
  final int? grammarId;
}
