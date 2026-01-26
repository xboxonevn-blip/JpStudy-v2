import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_language.dart';
import '../../../core/language_provider.dart';
import '../../learn/models/question_type.dart';
import '../models/test_config.dart';
import '../../../core/services/session_storage.dart';

class TestConfigScreen extends ConsumerStatefulWidget {
  final int lessonId;
  final String lessonTitle;
  final int maxQuestions;
  final Function(TestConfig) onStart;
  final TestSessionSnapshot? resumeSnapshot;
  final VoidCallback? onResume;
  final Future<void> Function()? onDiscardResume;

  const TestConfigScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.maxQuestions,
    required this.onStart,
    this.resumeSnapshot,
    this.onResume,
    this.onDiscardResume,
  });

  @override
  ConsumerState<TestConfigScreen> createState() => _TestConfigScreenState();
}

class _TestConfigScreenState extends ConsumerState<TestConfigScreen> {
  late TestConfig _config;
  TestSessionSnapshot? _resumeSnapshot;

  @override
  void initState() {
    super.initState();
    _config = TestConfig(
      questionCount: widget.maxQuestions.clamp(10, 50),
    );
    _resumeSnapshot = widget.resumeSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('${language.testModeLabel}: ${widget.lessonTitle}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_resumeSnapshot != null) ...[
              _buildResumeCard(language),
              const SizedBox(height: 24),
            ],
            // Header
            _buildHeader(context, language),
            const SizedBox(height: 32),

            // Question count
            _buildQuestionCountSection(language),
            const SizedBox(height: 24),

            // Question types
            _buildQuestionTypesSection(language),
            const SizedBox(height: 24),

            // Time limit
            _buildTimeLimitSection(language),
            const SizedBox(height: 24),

            // Options
            _buildOptionsSection(language),
            const SizedBox(height: 40),

            // Start button
            _buildStartButton(context, language),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.quiz_rounded,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language.configureTestLabel,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  language.testQuestionsAvailableLabel(widget.maxQuestions),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCountSection(AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(language.numberOfQuestionsLabel),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [10, 20, 30, 50, widget.maxQuestions]
              .where((n) => n <= widget.maxQuestions)
              .toSet()
              .map((count) => ChoiceChip(
                    label: Text(
                      count == widget.maxQuestions
                          ? language.allCountLabel(count)
                          : '$count',
                    ),
                    selected: _config.questionCount == count,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _config = _config.copyWith(questionCount: count);
                        });
                      }
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildQuestionTypesSection(AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(language.questionTypesLabel),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: QuestionType.values.map((type) {
            final isSelected = _config.enabledTypes.contains(type);
            return FilterChip(
              label: Text('${type.icon} ${type.label(language)}'),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final types = List<QuestionType>.from(_config.enabledTypes);
                  if (selected) {
                    types.add(type);
                  } else if (types.length > 1) {
                    types.remove(type);
                  }
                  _config = _config.copyWith(enabledTypes: types);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeLimitSection(AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(language.timeLimitLabel),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [0, 5, 10, 15, 30].map((minutes) {
            final label = minutes == 0
                ? language.noTimeLimitLabel
                : language.timeLimitMinutesLabel(minutes);
            final isSelected = minutes == 0 
                ? _config.timeLimitMinutes == null 
                : _config.timeLimitMinutes == minutes;
            return ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    if (minutes == 0) {
                      _config = _config.copyWith(clearTimeLimit: true);
                    } else {
                      _config = _config.copyWith(timeLimitMinutes: minutes);
                    }
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOptionsSection(AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(language.optionsLabel),
        const SizedBox(height: 12),
        SwitchListTile(
          title: Text(language.shuffleQuestionsLabel),
          subtitle: Text(language.shuffleQuestionsHint),
          value: _config.shuffleQuestions,
          onChanged: (value) {
            setState(() {
              _config = _config.copyWith(shuffleQuestions: value);
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: Text(language.showCorrectAnswerLabel),
          subtitle: Text(language.showCorrectAnswerHint),
          value: _config.showCorrectAfterWrong,
          onChanged: (value) {
            setState(() {
              _config = _config.copyWith(showCorrectAfterWrong: value);
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: Text(language.adaptiveTestingLabel),
          subtitle: Text(language.adaptiveTestingHint),
          value: _config.adaptiveTesting,
          onChanged: (value) {
            setState(() {
              _config = _config.copyWith(adaptiveTesting: value);
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildResumeCard(AppLanguage language) {
    final snapshot = _resumeSnapshot!;
    final progress = snapshot.totalQuestions == 0
        ? 0
        : (snapshot.answeredCount / snapshot.totalQuestions * 100).round();
    final lastSaved = MaterialLocalizations.of(context).formatMediumDate(snapshot.lastSavedAt);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language.resumeSessionTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            language.resumeSessionSubtitle(progress, lastSaved),
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7390)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: widget.onResume,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(language.resumeButtonLabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () async {
                  await widget.onDiscardResume?.call();
                  setState(() {
                    _resumeSnapshot = null;
                  });
                },
                child: Text(language.discardButtonLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, AppLanguage language) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => widget.onStart(_config),
        icon: const Icon(Icons.play_arrow_rounded),
        label: Text(
          language.startTestLabel,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
