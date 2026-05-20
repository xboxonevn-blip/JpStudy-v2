import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/conjugation/conjugation_lemma_builder.dart';

import '../../support/dart_cli_test_helper.dart';

void main() {
  test(
    'matches curriculum vocab to supported JMdict conjugation classes',
    () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'jpstudy_conj_lemmas_',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      final contentRoot = Directory('${tempDir.path}/content');
      await File('${contentRoot.path}/vocab/n5/minna/lesson_01.json')
          .create(recursive: true)
          .then(
            (file) => file.writeAsString(
              jsonEncode({
                'schemaVersion': 2,
                'dataset': 'vocab',
                'series': 'minna',
                'level': 'N5',
                'lessonId': 1,
                'entries': [
                  _vocabEntry(
                    entryId: 'n5_l01_s001',
                    vocabId: 'n5_l01_v001',
                    term: '帰る',
                    reading: 'かえる',
                    tags: ['verb'],
                    sourceVocabId: '1001',
                    sourceSenseId: '1',
                  ),
                  _vocabEntry(
                    entryId: 'n5_l01_s002',
                    vocabId: 'n5_l01_v002',
                    term: '起きる',
                    reading: 'おきる',
                    tags: ['verb'],
                  ),
                  _vocabEntry(
                    entryId: 'n5_l01_s003',
                    vocabId: 'n5_l01_v003',
                    term: '静か',
                    reading: 'しずか',
                    tags: ['adj_na'],
                  ),
                  _vocabEntry(
                    entryId: 'n5_l01_s004',
                    vocabId: 'n5_l01_v004',
                    term: 'っぽい',
                    reading: 'っぽい',
                    tags: ['adj_i'],
                  ),
                  _vocabEntry(
                    entryId: 'n5_l01_s005',
                    vocabId: 'n5_l01_v005',
                    term: '待ちます',
                    reading: 'まちます',
                    tags: ['verb'],
                  ),
                  _vocabEntry(
                    entryId: 'n5_l01_s006',
                    vocabId: 'n5_l01_v006',
                    term: '未登録します',
                    reading: 'みとうろくします',
                    tags: ['verb'],
                  ),
                  _vocabEntry(
                    entryId: 'n5_l01_s007',
                    vocabId: 'n5_l01_v007',
                    term: '学生',
                    reading: 'がくせい',
                    tags: ['noun'],
                  ),
                ],
              }),
            ),
          );

      final jmdict = File('${tempDir.path}/jmdict_e_min.json');
      await jmdict.writeAsString(
        jsonEncode({
          'source': 'https://ftp.edrdg.org/pub/Nihongo/JMdict_e.gz',
          'entryCount': 6,
          'entries': [
            _jmdictEntry('1001', ['帰る'], ['かえる'], ['v5r']),
            _jmdictEntry('1002', ['起きる'], ['おきる'], ['v1']),
            _jmdictEntry('1003', ['静か'], ['しずか'], ['adj-na']),
            _jmdictEntry('1004', ['っぽい'], ['っぽい'], ['adj-i', 'suf']),
            _jmdictEntry('1005', ['待つ'], ['まつ'], ['v5t']),
            _jmdictEntry('1006', ['学生'], ['がくせい'], ['n']),
          ],
        }),
      );

      final report = await ConjugationLemmaBuilder.build(
        contentRoot: contentRoot,
        jmdictCache: jmdict,
        generatedAt: DateTime.utc(2026, 5, 20),
      );

      expect(report.entries, hasLength(4));
      expect(
        report.entries.map(
          (entry) => [
            entry.contentVocabId,
            entry.dictionaryForm,
            entry.conjugationClass,
            entry.matchMethod,
          ],
        ),
        containsAll([
          ['n5_l01_v001', '帰る', 'godanRu', 'sourceVocabId'],
          ['n5_l01_v002', '起きる', 'ichidan', 'termReading'],
          ['n5_l01_v003', '静か', 'naAdjective', 'termReading'],
          ['n5_l01_v005', '待つ', 'godanTsu', 'generatedMasu'],
        ]),
      );
      expect(
        report.suffixOnlySkipped.map((entry) => entry.term),
        contains('っぽい'),
      );
      expect(
        report.unmatchedConjugatableLooking.map((entry) => entry.term),
        contains('未登録します'),
      );
      expect(report.toJson(), containsPair('source', 'JMdict_e'));
    },
  );

  test('prints JSON from the CLI', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'jpstudy_conj_lemmas_cli_',
    );
    addTearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    final contentRoot = Directory('${tempDir.path}/content');
    await File('${contentRoot.path}/vocab/n4/minna/lesson_26.json')
        .create(recursive: true)
        .then(
          (file) => file.writeAsString(
            jsonEncode({
              'series': 'minna',
              'level': 'N4',
              'lessonId': 26,
              'entries': [
                _vocabEntry(
                  entryId: 'n4_l26_s001',
                  vocabId: 'n4_l26_v001',
                  term: '高い',
                  reading: 'たかい',
                  tags: ['adj_i'],
                ),
              ],
            }),
          ),
        );
    final jmdict = File('${tempDir.path}/jmdict_e_min.json');
    await jmdict.writeAsString(
      jsonEncode({
        'source': 'https://ftp.edrdg.org/pub/Nihongo/JMdict_e.gz',
        'entryCount': 1,
        'entries': [
          _jmdictEntry('2001', ['高い'], ['たかい'], ['adj-i']),
        ],
      }),
    );
    final output = File('${tempDir.path}/lemmas.json');

    final result = await runDartTool(
      [
        'tool/research/build_conjugation_lemmas.dart',
        '--content-root',
        contentRoot.path,
        '--jmdict-cache',
        jmdict.path,
        '--output',
        output.path,
        '--generated-at',
        '2026-05-20T00:00:00Z',
      ],
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );

    expect(result.stderr, isEmpty);
    expect(result.exitCode, 0);
    final stdout = result.stdout as String;
    expect(stdout, contains('"entryCount":1'));
    final decoded = jsonDecode(await output.readAsString());
    expect(decoded['entries'], hasLength(1));
    expect(decoded['entries'][0]['conjugationClass'], 'iAdjective');
  }, timeout: dartCliTestTimeout);
}

Map<String, Object?> _vocabEntry({
  required String entryId,
  required String vocabId,
  required String term,
  required String reading,
  required List<String> tags,
  String? sourceVocabId,
  String? sourceSenseId,
}) {
  final links = <String, Object?>{};
  if (sourceVocabId != null) links['sourceVocabId'] = sourceVocabId;
  if (sourceSenseId != null) links['sourceSenseId'] = sourceSenseId;

  return {
    'entryId': entryId,
    'level': entryId.substring(0, 2).toUpperCase(),
    'tags': tags,
    'lemma': {
      'vocabId': vocabId,
      'term': term,
      'reading': reading,
      'kanji': [],
    },
    'sense': {'senseId': entryId},
    'links': links,
  };
}

Map<String, Object?> _jmdictEntry(
  String entrySeq,
  List<String> terms,
  List<String> readings,
  List<String> pos,
) {
  return {
    'entrySeq': entrySeq,
    'primaryTerm': terms.first,
    'primaryReading': readings.first,
    'terms': terms,
    'readings': readings,
    'partOfSpeech': pos,
  };
}
