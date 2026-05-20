import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('kanji assets match QA-A-027 master mapping by level', () {
    final master =
        jsonDecode(
              File(
                'docs/research/canonical/kanji-master-mapping-2026-05-20.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
    final kanjiToLevel = (master['kanjiToLevel'] as Map<String, dynamic>)
        .cast<String, dynamic>();
    final expectedByLevel = <String, Set<String>>{
      for (final level in _levels) level: <String>{},
    };
    kanjiToLevel.forEach((kanji, rawLevel) {
      expectedByLevel[rawLevel as String]!.add(kanji);
    });

    final actualByLevel = <String, Set<String>>{
      for (final level in _levels) level: <String>{},
    };
    final placementsByKanji = <String, List<String>>{};
    final humanApprovedTags = <String>[];

    for (final level in _levels) {
      final dir = Directory('assets/data/content/kanji/${level.toLowerCase()}');
      for (final file in _jsonFiles(dir)) {
        final payload =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        final lessonId = payload['lessonId'];
        for (final raw in payload['entries'] as List<dynamic>) {
          final entry = raw as Map<String, dynamic>;
          final character = entry['character'] as String;
          actualByLevel[level]!.add(character);
          placementsByKanji
              .putIfAbsent(character, () => <String>[])
              .add('$level lesson $lessonId');
          final tags = ((entry['tags'] as List<dynamic>?) ?? const [])
              .map((tag) => tag.toString())
              .toList();
          if (tags.contains('vi-human-approved')) {
            humanApprovedTags.add('$character $level lesson $lessonId');
          }
        }
      }
    }

    final duplicateRows = placementsByKanji.entries
        .where((entry) => entry.value.length > 1)
        .map((entry) => '${entry.key}: ${entry.value.join(', ')}')
        .toList();

    expect(duplicateRows, isEmpty, reason: duplicateRows.take(40).join('\n'));
    expect(
      humanApprovedTags,
      isEmpty,
      reason: humanApprovedTags.take(40).join('\n'),
    );
    for (final level in _levels) {
      expect(
        actualByLevel[level],
        expectedByLevel[level],
        reason: 'App kanji $level must equal canonical master mapping.',
      );
    }
    expect(actualByLevel['N5'], containsAll(['海', '帰']));
    expect(actualByLevel['N4'], contains('親'));
    expect(actualByLevel['N3'], containsAll(['銀', '重']));
    expect(actualByLevel['N2'], contains('議'));
  });
}

const _levels = ['N5', 'N4', 'N3', 'N2', 'N1'];

List<File> _jsonFiles(Directory dir) {
  return dir
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
}
