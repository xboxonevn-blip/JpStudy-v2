import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'reading passage titles are learner-facing, not generator/source labels',
    () {
      final decoded =
          jsonDecode(
                File(
                  'assets/data/content/reading_passages/reading_passages_corpus.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      final payload = (decoded['passages'] as List)
          .cast<Map<String, dynamic>>();
      final internalTitlePattern = RegExp(
        r'(Shin Kanzen Master|Bunpou Grammar set|^Mina I Lesson|翻訳の不足解説|translation missing|missing translation)',
        caseSensitive: false,
      );
      final badTitles = <String>[
        for (final item in payload)
          if (internalTitlePattern.hasMatch('${item['title'] ?? ''}'))
            '${item['level']} ${item['lesson_id']}: ${item['title']}',
      ];

      expect(badTitles, isEmpty, reason: badTitles.take(20).join('\n'));
    },
  );
}
