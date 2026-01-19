import 'package:flutter/material.dart';

import '../models/question_type.dart';

/// Settings for a Learn Mode session
class LearnConfig {
  final int questionCount;
  final List<QuestionType> enabledTypes;
  final bool shuffleQuestions;
  final bool enableHints;
  final bool showCorrectAnswer;

  const LearnConfig({
    this.questionCount = 20,
    this.enabledTypes = const [
      QuestionType.multipleChoice,
      QuestionType.trueFalse,
      QuestionType.fillBlank,
    ],
    this.shuffleQuestions = true,
    this.enableHints = true,
    this.showCorrectAnswer = true,
  });

  LearnConfig copyWith({
    int? questionCount,
    List<QuestionType>? enabledTypes,
    bool? shuffleQuestions,
    bool? enableHints,
    bool? showCorrectAnswer,
  }) {
    return LearnConfig(
      questionCount: questionCount ?? this.questionCount,
      enabledTypes: enabledTypes ?? this.enabledTypes,
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
      enableHints: enableHints ?? this.enableHints,
      showCorrectAnswer: showCorrectAnswer ?? this.showCorrectAnswer,
    );
  }
}

class LearnConfigScreen extends StatefulWidget {
  final int lessonId;
  final String lessonTitle;
  final int maxTerms;
  final Function(LearnConfig) onStart;

  const LearnConfigScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.maxTerms,
    required this.onStart,
  });

  @override
  State<LearnConfigScreen> createState() => _LearnConfigScreenState();
}

class _LearnConfigScreenState extends State<LearnConfigScreen> {
  late LearnConfig _config;

  @override
  void initState() {
    super.initState();
    _config = LearnConfig(
      questionCount: widget.maxTerms.clamp(10, 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn: ${widget.lessonTitle}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 32),

            // Question count
            _buildQuestionCountSection(),
            const SizedBox(height: 24),

            // Question types
            _buildQuestionTypesSection(),
            const SizedBox(height: 24),

            // Options
            _buildOptionsSection(),
            const SizedBox(height: 40),

            // Start button
            _buildStartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple,
            Colors.purple.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.psychology_rounded,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Configure Your Session',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${widget.maxTerms} terms available',
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

  Widget _buildQuestionCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Number of Questions'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [10, 20, 30, widget.maxTerms]
              .where((n) => n <= widget.maxTerms)
              .toSet()
              .map((count) => ChoiceChip(
                    label: Text(count == widget.maxTerms ? 'All ($count)' : '$count'),
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

  Widget _buildQuestionTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Question Types'),
        const SizedBox(height: 8),
        Text(
          'Select which question types to include',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: QuestionType.values.map((type) {
            final isSelected = _config.enabledTypes.contains(type);
            return FilterChip(
              label: Text('${type.icon} ${type.label}'),
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

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Options'),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Shuffle Questions'),
          subtitle: const Text('Randomize question order'),
          value: _config.shuffleQuestions,
          onChanged: (value) {
            setState(() {
              _config = _config.copyWith(shuffleQuestions: value);
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('Enable Hints'),
          subtitle: const Text('Show hints for fill-in-blank questions'),
          value: _config.enableHints,
          onChanged: (value) {
            setState(() {
              _config = _config.copyWith(enableHints: value);
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('Show Correct Answer'),
          subtitle: const Text('Display correct answer after wrong response'),
          value: _config.showCorrectAnswer,
          onChanged: (value) {
            setState(() {
              _config = _config.copyWith(showCorrectAnswer: value);
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
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

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => widget.onStart(_config),
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text(
          'Start Learning',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
