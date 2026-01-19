import 'package:flutter/material.dart';

import '../../learn/models/question_type.dart';
import '../models/test_config.dart';

class TestConfigScreen extends StatefulWidget {
  final int lessonId;
  final String lessonTitle;
  final int maxQuestions;
  final Function(TestConfig) onStart;

  const TestConfigScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.maxQuestions,
    required this.onStart,
  });

  @override
  State<TestConfigScreen> createState() => _TestConfigScreenState();
}

class _TestConfigScreenState extends State<TestConfigScreen> {
  late TestConfig _config;

  @override
  void initState() {
    super.initState();
    _config = TestConfig(
      questionCount: widget.maxQuestions.clamp(10, 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test: ${widget.lessonTitle}'),
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

            // Time limit
            _buildTimeLimitSection(),
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
                const Text(
                  'Configure Your Test',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${widget.maxQuestions} terms available',
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
          children: [10, 20, 30, 50, widget.maxQuestions]
              .where((n) => n <= widget.maxQuestions)
              .toSet()
              .map((count) => ChoiceChip(
                    label: Text(count == widget.maxQuestions ? 'All ($count)' : '$count'),
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

  Widget _buildTimeLimitSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Time Limit'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [0, 5, 10, 15, 30].map((minutes) {
            final label = minutes == 0 ? 'No Limit' : '$minutes min';
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
          title: const Text('Show Correct Answer'),
          subtitle: const Text('Display correct answer after wrong response'),
          value: _config.showCorrectAfterWrong,
          onChanged: (value) {
            setState(() {
              _config = _config.copyWith(showCorrectAfterWrong: value);
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
          'Start Test',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
