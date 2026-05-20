import 'package:jpstudy/core/conjugation/conjugation_class.dart';
import 'package:jpstudy/core/conjugation/conjugation_form.dart';
import 'package:jpstudy/core/conjugation/japanese_conjugator.dart';
import 'package:jpstudy/data/db/content_database.dart';

class ConjugationQuestion {
  const ConjugationQuestion({
    required this.contentVocabId,
    required this.dictionaryForm,
    required this.formKey,
    required this.direction,
    required this.conjugationClass,
    required this.prompt,
    required this.promptSurface,
    required this.options,
    required this.correctIndex,
    required this.correctAnswer,
  });

  final int contentVocabId;
  final String dictionaryForm;
  final String formKey;
  final String direction;
  final String conjugationClass;
  final String prompt;
  final String promptSurface;
  final List<String> options;
  final int correctIndex;
  final String correctAnswer;
}

class ConjugationQuestionGenerator {
  ConjugationQuestionGenerator({JapaneseConjugator? conjugator})
    : _conjugator = conjugator ?? const JapaneseConjugator();

  final JapaneseConjugator _conjugator;

  List<ConjugationQuestion> build({
    required List<ConjugationLemmaData> lemmas,
    List<String>? formKeys,
    List<String>? directions,
    int targetCount = 50,
  }) {
    if (lemmas.isEmpty || targetCount <= 0) return const [];
    final selectedForms = (formKeys == null || formKeys.isEmpty)
        ? const [
            'dictionary',
            'masu',
            'nai',
            'ta',
            'te',
            'ba',
            'tara',
            'volitional',
            'potential',
            'passive',
            'causative',
            'causativePassive',
            'imperative',
          ]
        : formKeys;
    final selectedDirections = (directions == null || directions.isEmpty)
        ? const ['produce', 'recognize']
        : directions;

    final questions = <ConjugationQuestion>[];
    while (questions.length < targetCount) {
      final beforePass = questions.length;
      for (final lemma in lemmas) {
        final spec = _specFor(lemma);
        if (spec == null) continue;
        for (final formKey in selectedForms) {
          final form = _formFor(formKey);
          if (form == null) continue;
          final surface = _safeForm(lemma.dictionaryForm, spec, form);
          if (surface == null) continue;
          for (final direction in selectedDirections) {
            final normalizedDirection = direction.trim();
            if (normalizedDirection == 'produce') {
              questions.add(
                _produceQuestion(
                  lemma: lemma,
                  spec: spec,
                  form: form,
                  formKey: formKey,
                  correctSurface: surface,
                  peerLemmas: lemmas,
                ),
              );
            } else if (normalizedDirection == 'recognize') {
              questions.add(
                _recognizeQuestion(
                  lemma: lemma,
                  formKey: formKey,
                  correctSurface: surface,
                  availableFormKeys: selectedForms,
                ),
              );
            }
            if (questions.length >= targetCount) return questions;
          }
        }
      }
      if (questions.length == beforePass) break;
    }
    return questions;
  }

  ConjugationQuestion _produceQuestion({
    required ConjugationLemmaData lemma,
    required ConjugationSpec spec,
    required ConjugationForm form,
    required String formKey,
    required String correctSurface,
    required List<ConjugationLemmaData> peerLemmas,
  }) {
    final distractors = <String>[];
    for (final peer in peerLemmas) {
      if (peer.contentVocabId == lemma.contentVocabId) continue;
      final peerSpec = _specFor(peer);
      if (peerSpec == null) continue;
      final peerSurface = _safeForm(peer.dictionaryForm, peerSpec, form);
      if (peerSurface != null) distractors.add(peerSurface);
    }
    for (final fallback in _fallbackForms(lemma.dictionaryForm, spec)) {
      distractors.add(fallback);
    }
    final options = _options(correctSurface, distractors);
    return ConjugationQuestion(
      contentVocabId: lemma.contentVocabId,
      dictionaryForm: lemma.dictionaryForm,
      formKey: formKey,
      direction: 'produce',
      conjugationClass: lemma.conjugationClass,
      prompt: 'Choose the ${_formLabel(formKey)} of ${lemma.dictionaryForm}.',
      promptSurface: correctSurface,
      options: options,
      correctIndex: options.indexOf(correctSurface),
      correctAnswer: correctSurface,
    );
  }

  ConjugationQuestion _recognizeQuestion({
    required ConjugationLemmaData lemma,
    required String formKey,
    required String correctSurface,
    required List<String> availableFormKeys,
  }) {
    final distractors = availableFormKeys
        .where((key) => key != formKey)
        .map(_formLabel)
        .toList(growable: true);
    distractors.addAll(const ['dictionary form', 'polite form', 'past form']);
    final correct = _formLabel(formKey);
    final options = _options(correct, distractors);
    return ConjugationQuestion(
      contentVocabId: lemma.contentVocabId,
      dictionaryForm: lemma.dictionaryForm,
      formKey: formKey,
      direction: 'recognize',
      conjugationClass: lemma.conjugationClass,
      prompt: '$correctSurface is which form of ${lemma.dictionaryForm}?',
      promptSurface: correctSurface,
      options: options,
      correctIndex: options.indexOf(correct),
      correctAnswer: correct,
    );
  }

  List<String> _fallbackForms(String lemma, ConjugationSpec spec) {
    final values = <String>[];
    for (final form in ConjugationForm.values) {
      final surface = _safeForm(lemma, spec, form);
      if (surface != null) values.add(surface);
    }
    return values;
  }

  List<String> _options(String correct, Iterable<String> candidates) {
    final values = <String>[correct];
    for (final candidate in candidates) {
      final normalized = candidate.trim();
      if (normalized.isEmpty || values.contains(normalized)) continue;
      values.add(normalized);
      if (values.length == 4) break;
    }
    return values;
  }

  String? _safeForm(String lemma, ConjugationSpec spec, ConjugationForm form) {
    try {
      return _conjugator.form(lemma, spec, form);
    } on UnsupportedError {
      return null;
    } on ArgumentError {
      return null;
    }
  }

  ConjugationSpec? _specFor(ConjugationLemmaData lemma) {
    if (lemma.kind == 'verb') {
      final verb = _enumByName(VerbClass.values, lemma.conjugationClass);
      return verb == null ? null : ConjugationSpec.verb(verb);
    }
    final adjective = _enumByName(
      AdjectiveClass.values,
      lemma.conjugationClass,
    );
    return adjective == null ? null : ConjugationSpec.adjective(adjective);
  }

  T? _enumByName<T extends Enum>(List<T> values, String name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }

  ConjugationForm? _formFor(String formKey) {
    return _enumByName(ConjugationForm.values, formKey.trim());
  }
}

String _formLabel(String formKey) {
  return switch (formKey.trim()) {
    'te' => 'te form',
    'nai' => 'negative form',
    'ta' => 'past form',
    'masu' => 'polite form',
    'dictionary' => 'dictionary form',
    _ => '${formKey.trim()} form',
  };
}
