import 'package:flutter/material.dart';

import '../../../core/app_language.dart';
import '../../../data/models/vocab_item.dart';

class ContextualHintCard extends StatelessWidget {
  const ContextualHintCard({
    super.key,
    required this.item,
    required this.language,
  });

  final VocabItem item;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final meaning = item.displayMeaning(language);
    final lines = _buildContextLines(meaning, language);
    final reading = item.reading?.trim() ?? '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E8F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_stories_outlined,
                size: 18,
                color: Color(0xFF4B5EAA),
              ),
              const SizedBox(width: 6),
              Text(
                language.contextualLearningLabel,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            lines.jp,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          if (reading.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(reading, style: const TextStyle(color: Color(0xFF6B7390))),
          ],
          const SizedBox(height: 8),
          Text(
            lines.translation,
            style: const TextStyle(color: Color(0xFF1C2440)),
          ),
          const SizedBox(height: 10),
          Text(
            language.contextualLearningHelperLabel,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  _ContextLines _buildContextLines(String meaning, AppLanguage language) {
    final tags = item.tags ?? const <String>[];
    bool has(String value) => tags.contains(value);

    if (has('occupation')) {
      return _ContextLines(
        jp: '私は${item.term}です。',
        translation: _translate(language, 'I am $meaning.', 'Tôi là $meaning.'),
      );
    }
    if (has('place') || has('country')) {
      return _ContextLines(
        jp: '私は${item.term}に行きます。',
        translation: _translate(
          language,
          'I go to $meaning.',
          'Tôi đi đến $meaning.',
        ),
      );
    }
    if (has('question')) {
      return _ContextLines(
        jp: '${item.term}は何ですか。',
        translation: _translate(
          language,
          'What is $meaning?',
          '$meaning là gì?',
        ),
      );
    }
    if (has('phrase') || has('response')) {
      return _ContextLines(
        jp: '「${item.term}」と言います。',
        translation: _translate(
          language,
          'You say "$meaning".',
          'Bạn nói "$meaning".',
        ),
      );
    }

    return _ContextLines(
      jp: 'これは${item.term}です。',
      translation: _translate(
        language,
        'This is $meaning.',
        'Đây là $meaning.',
      ),
    );
  }

  String _translate(AppLanguage language, String en, String vi) {
    switch (language) {
      case AppLanguage.vi:
        return vi;
      case AppLanguage.en:
        return en;
      case AppLanguage.ja:
        return en;
    }
  }
}

class _ContextLines {
  const _ContextLines({required this.jp, required this.translation});

  final String jp;
  final String translation;
}
