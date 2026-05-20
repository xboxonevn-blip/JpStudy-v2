import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/data/daos/conjugation_srs_dao.dart';
import 'package:jpstudy/data/db/database_provider.dart';
import 'package:jpstudy/data/repositories/conjugation_repository.dart';
import 'package:jpstudy/features/conjugation/models/conjugation_practice_args.dart';
import 'package:jpstudy/features/conjugation/services/conjugation_question_generator.dart';
import 'package:jpstudy/features/quiz/widgets/shared_answer_selection.dart';

class ConjugationPracticeScreen extends ConsumerStatefulWidget {
  const ConjugationPracticeScreen({super.key, this.args});

  final ConjugationPracticeArgs? args;

  @override
  ConsumerState<ConjugationPracticeScreen> createState() =>
      _ConjugationPracticeScreenState();
}

class _ConjugationPracticeScreenState
    extends ConsumerState<ConjugationPracticeScreen> {
  late Future<List<ConjugationQuestion>> _questionsFuture;
  var _index = 0;
  int? _selectedIndex;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _questionsFuture = _loadQuestions();
  }

  Future<List<ConjugationQuestion>> _loadQuestions() async {
    final args = widget.args ?? const ConjugationPracticeArgs();
    final repo = ref.read(conjugationRepositoryProvider);
    final level = ref.read(studyLevelProvider)?.shortLabel ?? 'N5';
    final ids = args.contentVocabIds;
    final lemmas = ids == null || ids.isEmpty
        ? await repo.fetchByLevel(level)
        : await repo.fetchByContentVocabIds(ids);
    return ConjugationQuestionGenerator().build(
      lemmas: lemmas,
      formKeys: args.formKeys,
      directions: args.directions,
      targetCount: args.targetCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(_tr(language, 'Practice forms', 'Luyện chia thể', '活用練習')),
      ),
      body: FutureBuilder<List<ConjugationQuestion>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final questions = snapshot.data ?? const [];
          if (questions.isEmpty) {
            return Center(
              child: Text(
                _tr(
                  language,
                  'No conjugation drills yet.',
                  'Chưa có bài luyện chia thể.',
                  '活用練習はまだありません。',
                ),
              ),
            );
          }
          if (_index >= questions.length) {
            return Center(
              child: Text(
                _tr(language, 'Session complete', 'Đã xong lượt luyện', '練習完了'),
              ),
            );
          }
          final question = questions[_index];
          final displayPrompt = _displayPrompt(language, question);
          final displayOptions = _displayOptions(language, question);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _tr(
                        language,
                        'Question ${_index + 1} of ${questions.length}',
                        'Câu ${_index + 1}/${questions.length}',
                        '${_index + 1}/${questions.length}問',
                      ),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      displayPrompt,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    SharedAnswerSelection(
                      questionKey:
                          '${question.contentVocabId}_${question.formKey}_${question.direction}_$_index',
                      options: displayOptions,
                      selectedIndex: _selectedIndex,
                      correctIndex: question.correctIndex,
                      revealResult: _revealed,
                      keyPrefix: 'conjugation_answer',
                      confirmLabel: _tr(language, 'Answer', 'Trả lời', '回答'),
                      onConfirm: (value) => _confirm(
                        question,
                        value,
                        prompt: displayPrompt,
                        options: displayOptions,
                      ),
                      optionBuilder: (context, option) =>
                          _ConjugationAnswerTile(option: option),
                    ),
                    if (_revealed) ...[
                      const SizedBox(height: 16),
                      Text(
                        _selectedIndex == question.correctIndex
                            ? _tr(language, 'Correct', 'Đúng', '正解')
                            : _tr(
                                language,
                                'Review this form',
                                'Ôn lại thể này',
                                'この活用を復習',
                              ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: _next,
                        child: Text(_tr(language, 'Next', 'Câu tiếp', '次へ')),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirm(
    ConjugationQuestion question,
    int selectedIndex, {
    required String prompt,
    required List<String> options,
  }) async {
    final selectedAnswer = options[selectedIndex];
    final correctAnswer = options[question.correctIndex];
    final correct = selectedIndex == question.correctIndex;
    final args = widget.args ?? const ConjugationPracticeArgs();
    final db = ref.read(databaseProvider);
    await ConjugationSrsDao(db).recordReview(
      contentVocabId: question.contentVocabId,
      formKey: question.formKey,
      direction: question.direction,
      conjugationClass: question.conjugationClass,
      dictionaryForm: question.dictionaryForm,
      expectedSurface: question.promptSurface,
      grammarId: args.grammarId,
      grade: correct ? 4 : 1,
      prompt: prompt,
      correctAnswer: correctAnswer,
      userAnswer: selectedAnswer,
      source: args.source,
    );
    if (!mounted) return;
    setState(() {
      _selectedIndex = selectedIndex;
      _revealed = true;
    });
  }

  void _next() {
    setState(() {
      _index += 1;
      _selectedIndex = null;
      _revealed = false;
    });
  }

  String _tr(AppLanguage language, String en, String vi, String ja) {
    switch (language) {
      case AppLanguage.en:
        return en;
      case AppLanguage.vi:
        return vi;
      case AppLanguage.ja:
        return ja;
    }
  }

  String _displayPrompt(AppLanguage language, ConjugationQuestion question) {
    final form = _formLabel(language, question.formKey);
    if (question.direction == 'recognize') {
      return switch (language) {
        AppLanguage.en =>
          '${question.promptSurface} is which form of ${question.dictionaryForm}?',
        AppLanguage.vi =>
          '${question.promptSurface} là thể nào của ${question.dictionaryForm}?',
        AppLanguage.ja =>
          '${question.promptSurface}は${question.dictionaryForm}のどの形ですか。',
      };
    }
    return switch (language) {
      AppLanguage.en => 'Choose the $form of ${question.dictionaryForm}.',
      AppLanguage.vi => 'Chọn $form của ${question.dictionaryForm}.',
      AppLanguage.ja => '${question.dictionaryForm}の$formを選んでください。',
    };
  }

  List<String> _displayOptions(
    AppLanguage language,
    ConjugationQuestion question,
  ) {
    if (question.direction != 'recognize') return question.options;
    return [
      for (final option in question.options)
        _recognitionOptionLabel(language, option),
    ];
  }

  String _recognitionOptionLabel(AppLanguage language, String option) {
    return switch (option.trim()) {
      'te form' => _formLabel(language, 'te'),
      'negative form' => _formLabel(language, 'nai'),
      'past form' => _formLabel(language, 'ta'),
      'polite form' => _formLabel(language, 'masu'),
      'dictionary form' => _formLabel(language, 'dictionary'),
      _ => option,
    };
  }

  String _formLabel(AppLanguage language, String formKey) {
    final key = formKey.trim();
    return switch (language) {
      AppLanguage.en => switch (key) {
        'te' => 'te form',
        'nai' => 'negative form',
        'ta' => 'past form',
        'masu' => 'polite form',
        'dictionary' => 'dictionary form',
        _ => '$key form',
      },
      AppLanguage.vi => switch (key) {
        'te' => 'thể て',
        'nai' => 'thể phủ định',
        'ta' => 'thể quá khứ',
        'masu' => 'thể lịch sự',
        'dictionary' => 'thể từ điển',
        _ => 'thể $key',
      },
      AppLanguage.ja => switch (key) {
        'te' => 'て形',
        'nai' => 'ない形',
        'ta' => 'た形',
        'masu' => 'ます形',
        'dictionary' => '辞書形',
        _ => '$key形',
      },
    };
  }
}

class _ConjugationAnswerTile extends StatelessWidget {
  const _ConjugationAnswerTile({required this.option});

  final SharedAnswerOption option;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = option.isCorrect
        ? scheme.primary
        : option.isWrong
        ? scheme.error
        : option.isSelected
        ? scheme.secondary
        : scheme.outline;
    return InkWell(
      key: option.key,
      onTap: option.onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(option.label),
      ),
    );
  }
}
