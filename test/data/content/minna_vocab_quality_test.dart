import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Minna N5/N4 vocab does not include generated kanji coverage rows', () {
    final files = <File>[
      ..._jsonFiles(Directory('assets/data/content/vocab/n5/minna')),
      ..._jsonFiles(Directory('assets/data/content/vocab/n4/minna')),
    ];

    expect(files, isNotEmpty);

    for (final file in files) {
      final payload =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final entries = (payload['entries'] as List).cast<Map<String, dynamic>>();

      expect(payload['entryCount'], entries.length, reason: file.path);
      expect(
        entries.map((entry) => entry['order']),
        List<int>.generate(entries.length, (index) => index + 1),
        reason: file.path,
      );

      for (final entry in entries) {
        final classification =
            entry['classification'] as Map<String, dynamic>? ?? const {};
        final tags = (entry['tags'] as List? ?? const <Object?>[])
            .cast<Object?>();
        expect(
          classification['origin'],
          isNot('generated_coverage'),
          reason: '${file.path} ${entry['entryId']}',
        );
        expect(
          tags,
          isNot(contains('kanji-coverage')),
          reason: '${file.path} ${entry['entryId']}',
        );
        expect(
          tags,
          isNot(contains('kanji-example')),
          reason: '${file.path} ${entry['entryId']}',
        );
      }
    }
  });

  test('Minna N5 lesson 1 keeps lesson words, not orphan kanji glosses', () {
    final payload =
        jsonDecode(
              File(
                'assets/data/content/vocab/n5/minna/lesson_01.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
    final terms = (payload['entries'] as List)
        .cast<Map<String, dynamic>>()
        .map((entry) => (entry['lemma'] as Map<String, dynamic>)['term'])
        .toSet();

    expect(terms, isNot(contains('社')));
    expect(terms, isNot(contains('生')));
    expect(terms, isNot(contains('来')));
    expect(terms, contains('会社員'));
    expect(terms, contains('学生'));
  });

  test('Minna manifest vocab refs match current lesson assets', () {
    for (final level in ['n5', 'n4']) {
      final textbookId = 'minna_$level';
      final assetDir = Directory('assets/data/content/vocab/$level/minna');
      for (final assetFile in _jsonFiles(assetDir)) {
        final payload =
            jsonDecode(assetFile.readAsStringSync()) as Map<String, dynamic>;
        final lessonId = payload['lessonId'] as int;
        final relativeAsset =
            'vocab/$level/minna/${assetFile.uri.pathSegments.last}';
        final validKeys = {
          for (final entry
              in (payload['entries'] as List).cast<Map<String, dynamic>>())
            '$relativeAsset#vocab:${entry['entryId']}',
        };
        final manifestFile = File(
          'lib/data/manifests/item_index_${textbookId}_${textbookId}_${lessonId.toString().padLeft(2, '0')}.json',
        );
        expect(manifestFile.existsSync(), isTrue, reason: manifestFile.path);
        final manifest =
            jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
        final items = (manifest['items'] as List).cast<Map<String, dynamic>>();
        final vocabRefs = items.where((item) {
          if (item['type'] != 'vocab') return false;
          final legacyRef = item['legacy_ref'] as Map<String, dynamic>? ?? {};
          return legacyRef['file'] == relativeAsset;
        }).toList();

        expect(vocabRefs, hasLength(validKeys.length), reason: assetFile.path);
        for (final item in vocabRefs) {
          final legacyRef = item['legacy_ref'] as Map<String, dynamic>? ?? {};
          expect(
            validKeys,
            contains(legacyRef['key']),
            reason: '${manifestFile.path} ${legacyRef['key']}',
          );
        }
      }
    }
  });
}

List<File> _jsonFiles(Directory dir) {
  if (!dir.existsSync()) return const [];
  return dir
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.json'))
      .toList()
    ..sort((left, right) => left.path.compareTo(right.path));
}
