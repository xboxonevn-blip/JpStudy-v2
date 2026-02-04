import 'dart:convert';
import 'dart:collection';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'content_tables.dart';

part 'content_database.g.dart';

@DriftDatabase(
  tables: [
    Vocab,
    GrammarPoint,
    GrammarExample,
    Question,
    MockTest,
    MockTestSection,
    MockTestQuestionMap,
    UserProgress,
    Kanji,
  ],
)
class ContentDatabase extends _$ContentDatabase {
  ContentDatabase({QueryExecutor? executor})
    : super(executor ?? _openContentConnection());

  @override
  int get schemaVersion => 19;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedMinnaVocabulary();
        await _seedMinnaGrammar();
        await _seedMinnaKanji();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(userProgress);
        }
        if (from < 3) {
          await _addColumn(m, vocab, vocab.kanjiMeaning);
        }
        if (from < 6) {
          await _addColumn(m, vocab, vocab.meaningEn);
        }
        if (from < 7) {
          await m.createTable(grammarPoint);
          await m.createTable(grammarExample);
          await _seedMinnaGrammar();
        }
        if (from < 9) {
          await m.createTable(kanji);
          await _seedMinnaKanji();
        }
        if (from < 10) {
          await _reseedMinnaKanji();
        }
        if (from < 11) {
          await _seedMinnaGrammar();
          await _reseedMinnaVocabulary();
        }
        if (from < 14) {
          await _seedMinnaGrammar();
        }
        if (from >= 11 && from < 15) {
          await _reseedMinnaVocabulary();
        }
        if (from < 15) {
          await _seedMinnaGrammar();
        }
        // Force re-seed for grammar examples expansion (v16)
        if (from < 16) {
          await _seedMinnaGrammar();
        }
        if (from < 17) {
          await _addColumn(m, kanji, kanji.mnemonicVi);
          await _addColumn(m, kanji, kanji.mnemonicEn);
          await _reseedMinnaKanji();
        }
        if (from < 18) {
          // Backfill users who seeded during path-transition versions.
          await _reseedMinnaVocabulary();
        }
        if (from < 19) {
          await _addColumn(m, vocab, vocab.sourceVocabId);
          await _addColumn(m, vocab, vocab.sourceSenseId);
          // Populate new source IDs for existing installs.
          await _reseedMinnaVocabulary();
        }
      },
      beforeOpen: (details) async {
        await _ensureMinnaVocabularySeeded();
      },
    );
  }

  // ... (reseed methods)

  Future<void> _reseedMinnaVocabulary() async {
    // Delete all old Minna vocabulary (both N5 and N4)
    await (delete(vocab)..where((tbl) => tbl.tags.like('%minna_%'))).go();

    // Seed new vocabulary
    await _seedMinnaVocabulary();
  }

  Future<void> _ensureMinnaVocabularySeeded() async {
    final minnaCountExpr = vocab.id.count();
    final query = selectOnly(vocab)
      ..addColumns([minnaCountExpr])
      ..where(vocab.tags.like('%minna_%'));
    final row = await query.getSingle();
    final minnaCount = row.read(minnaCountExpr) ?? 0;
    if (minnaCount == 0) {
      await _seedMinnaVocabulary();
      return;
    }

    // Self-heal old seeded DBs that still contain placeholder/garbled rows.
    final corruptedCountExpr = vocab.id.count();
    final corruptedQuery = selectOnly(vocab)
      ..addColumns([corruptedCountExpr])
      ..where(vocab.tags.like('%minna_%'))
      ..where(
        vocab.term.like('%?%') |
            vocab.reading.like('%?%') |
            vocab.term.like('%ã%') |
            vocab.reading.like('%ã%') |
            vocab.term.like('%Ã%') |
            vocab.reading.like('%Ã%'),
      );
    final corruptedRow = await corruptedQuery.getSingle();
    final corruptedCount = corruptedRow.read(corruptedCountExpr) ?? 0;
    if (corruptedCount > 0) {
      await _reseedMinnaVocabulary();
    }
  }

  Future<void> _seedMinnaVocabulary() async {
    // Seed N5 Vocabulary from JSON files
    await _seedFromJsonFiles(isN5: true);

    // Seed N4 Vocabulary from JSON files
    await _seedFromJsonFiles(isN5: false);
  }

  Future<void> _seedMinnaGrammar() async {
    // Clear existing data to prevent duplicates and ensure fresh data
    await delete(grammarExample).go();
    await delete(grammarPoint).go();

    // Seeding Minna Grammar Lessons 1-5 (Batch 1)
    final List<String> grammarFiles = [
      // ... list remains same in implementation, just showing logic change ...
      'assets/data/grammar/n5/grammar_n5_1.json',
      'assets/data/grammar/n5/grammar_n5_2.json',
      'assets/data/grammar/n5/grammar_n5_3.json',
      'assets/data/grammar/n5/grammar_n5_4.json',
      'assets/data/grammar/n5/grammar_n5_5.json',
      // Batch 1: Lessons 6-10
      'assets/data/grammar/n5/grammar_n5_6.json',
      'assets/data/grammar/n5/grammar_n5_7.json',
      'assets/data/grammar/n5/grammar_n5_8.json',
      'assets/data/grammar/n5/grammar_n5_9.json',
      'assets/data/grammar/n5/grammar_n5_10.json',
      // Batch 2: Lessons 11-15
      'assets/data/grammar/n5/grammar_n5_11.json',
      'assets/data/grammar/n5/grammar_n5_12.json',
      'assets/data/grammar/n5/grammar_n5_13.json',
      'assets/data/grammar/n5/grammar_n5_14.json',
      'assets/data/grammar/n5/grammar_n5_15.json',
      // Batch 3: Lessons 16-20
      'assets/data/grammar/n5/grammar_n5_16.json',
      'assets/data/grammar/n5/grammar_n5_17.json',
      'assets/data/grammar/n5/grammar_n5_18.json',
      'assets/data/grammar/n5/grammar_n5_19.json',
      'assets/data/grammar/n5/grammar_n5_20.json',
      // Batch 4: Lessons 21-25
      'assets/data/grammar/n5/grammar_n5_21.json',
      'assets/data/grammar/n5/grammar_n5_22.json',
      'assets/data/grammar/n5/grammar_n5_23.json',
      'assets/data/grammar/n5/grammar_n5_24.json',
      'assets/data/grammar/n5/grammar_n5_25.json',

      // -- N4 Grammar --
      // Batch 1: Lessons 26-30
      'assets/data/grammar/n4/grammar_n4_26.json',
      'assets/data/grammar/n4/grammar_n4_27.json',
      'assets/data/grammar/n4/grammar_n4_28.json',
      'assets/data/grammar/n4/grammar_n4_29.json',
      'assets/data/grammar/n4/grammar_n4_30.json',
      // Batch 2: Lessons 31-35
      'assets/data/grammar/n4/grammar_n4_31.json',
      'assets/data/grammar/n4/grammar_n4_32.json',
      'assets/data/grammar/n4/grammar_n4_33.json',
      'assets/data/grammar/n4/grammar_n4_34.json',
      'assets/data/grammar/n4/grammar_n4_35.json',
      // Batch 3: Lessons 36-40
      'assets/data/grammar/n4/grammar_n4_36.json',
      'assets/data/grammar/n4/grammar_n4_37.json',
      'assets/data/grammar/n4/grammar_n4_38.json',
      'assets/data/grammar/n4/grammar_n4_39.json',
      'assets/data/grammar/n4/grammar_n4_40.json',
      // Batch 4: Lessons 41-45
      'assets/data/grammar/n4/grammar_n4_41.json',
      'assets/data/grammar/n4/grammar_n4_42.json',
      'assets/data/grammar/n4/grammar_n4_43.json',
      'assets/data/grammar/n4/grammar_n4_44.json',
      'assets/data/grammar/n4/grammar_n4_45.json',
      // Batch 5: Lessons 46-50
      'assets/data/grammar/n4/grammar_n4_46.json',
      'assets/data/grammar/n4/grammar_n4_47.json',
      'assets/data/grammar/n4/grammar_n4_48.json',
      'assets/data/grammar/n4/grammar_n4_49.json',
      'assets/data/grammar/n4/grammar_n4_50.json',
    ];

    for (final file in grammarFiles) {
      try {
        final jsonString = await rootBundle.loadString(file);
        final List<dynamic> points = json.decode(jsonString);

        if (points.isEmpty) continue;

        // Try load supplementary examples
        Map<String, List<dynamic>> extraExamplesMap = {};
        try {
          // Infer lesson and level from first point or file path
          // File path: assets/data/grammar/n5/grammar_n5_1.json
          // We can parse file path string usually, or take from point data
          final firstPoint = points.first;
          final lessonId = firstPoint['lessonId'] as int;
          final level = (firstPoint['level'] as String).toLowerCase(); // 'n5'

          final examplesFile =
              'assets/data/grammar/examples/$level/lesson_$lessonId.json';
          final exJsonString = await rootBundle.loadString(examplesFile);
          final List<dynamic> exList = json.decode(exJsonString);

          for (final item in exList) {
            final gp = item['grammarPoint'] as String;
            extraExamplesMap[gp] = item['examples'] as List<dynamic>;
          }
        } catch (_) {
          // No supplementary file or parse error, ignore
        }

        for (final pointData in points) {
          // Insert Grammar Point
          final pointId = await into(grammarPoint).insert(
            GrammarPointCompanion.insert(
              lessonId: pointData['lessonId'] as int,
              title: pointData['title'] as String,
              titleEn: Value(pointData['titleEn'] as String?),
              structure: pointData['structure'] as String,
              structureEn: Value(pointData['structureEn'] as String?),
              explanation: pointData['explanation'] as String,
              explanationEn: Value(pointData['explanationEn'] as String?),
              level: pointData['level'] as String,
              tags: Value(pointData['tags'] as String?),
            ),
            mode: InsertMode.insertOrReplace,
          );

          // Insert Original Examples
          final List<dynamic> examples = [...(pointData['examples'] ?? [])];

          // Merge Supplementary Examples
          final titleKey = pointData['title'] as String;
          if (extraExamplesMap.containsKey(titleKey)) {
            examples.addAll(extraExamplesMap[titleKey]!);
          }

          for (final ex in examples) {
            await into(grammarExample).insert(
              GrammarExampleCompanion.insert(
                grammarPointId: pointId,
                sentence: ex['sentence'] as String,
                translation: ex['translation'] as String,
                translationEn: Value(ex['translationEn'] as String?),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        }
      } catch (e) {
        // debugPrint('Error loading grammar file $file: $e');
      }
    }
  }

  Future<void> _seedFromJsonFiles({bool isN5 = false}) async {
    final level = isN5 ? 'N5' : 'N4';
    final levelLower = level.toLowerCase();
    final startLesson = isN5 ? 1 : 26;
    final endLesson = isN5 ? 25 : 50;

    final allRows = <Map<String, dynamic>>[];
    for (int lessonId = startLesson; lessonId <= endLesson; lessonId++) {
      final normalizedRows = await _loadNormalizedVocabRows(
        level: level,
        lessonId: lessonId,
      );

      // Prefer normalized rows when present; legacy files are only a fallback.
      if (normalizedRows.isNotEmpty) {
        allRows.addAll(
          _mergeLessonRows(
            preferred: normalizedRows,
            fallback: const [],
            level: level,
            lessonId: lessonId,
          ),
        );
        continue;
      }

      final legacyRows = await _loadLegacyVocabRows(
        levelLower: levelLower,
        lessonId: lessonId,
      );
      allRows.addAll(
        _mergeLessonRows(
          preferred: const [],
          fallback: legacyRows,
          level: level,
          lessonId: lessonId,
        ),
      );
    }

    final collapsedRows = _collapseExactDuplicateRows(allRows);
    for (final item in collapsedRows) {
      await into(vocab).insert(
        VocabCompanion.insert(
          term: item['term'] as String,
          reading: Value(item['reading'] as String?),
          kanjiMeaning: Value(item['kanjiMeaning'] as String?),
          sourceVocabId: Value(item['sourceVocabId'] as String?),
          sourceSenseId: Value(item['sourceSenseId'] as String?),
          meaning: item['meaning_vi'] as String,
          meaningEn: Value(item['meaning_en'] as String?),
          level: item['level'] as String,
          tags: Value(item['tags'] as String?),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  Future<List<Map<String, dynamic>>> _loadLegacyVocabRows({
    required String levelLower,
    required int lessonId,
  }) async {
    final path =
        'assets/data/vocab/$levelLower/vocab_${levelLower}_$lessonId.json';
    try {
      final jsonString = await rootBundle.loadString(path);
      final List<dynamic> list = json.decode(jsonString);
      return list
          .map((item) => _asMap(item))
          .whereType<Map<String, dynamic>>()
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<Map<String, dynamic>>> _loadNormalizedVocabRows({
    required String level,
    required int lessonId,
  }) async {
    final levelLower = level.toLowerCase();
    final paddedLessonId = lessonId.toString().padLeft(2, '0');
    final basePath = 'assets/data/vocab/$levelLower/lesson_$paddedLessonId';

    try {
      final masterJson = await rootBundle.loadString('$basePath/master.json');
      final senseJson = await rootBundle.loadString('$basePath/sense.json');
      final mapJson = await rootBundle.loadString('$basePath/map.json');

      final masterList = json.decode(masterJson) as List<dynamic>;
      final senseList = json.decode(senseJson) as List<dynamic>;
      final lessonMap = json.decode(mapJson) as List<dynamic>;

      final masterById = <String, Map<String, dynamic>>{};
      for (final raw in masterList) {
        final item = _asMap(raw);
        if (item == null) continue;
        final vocabId = _readText(item, 'vocabId');
        if (vocabId.isEmpty) continue;
        masterById[vocabId] = item;
      }

      final senseById = <String, Map<String, dynamic>>{};
      for (final raw in senseList) {
        final item = _asMap(raw);
        if (item == null) continue;
        final senseId = _readText(item, 'senseId');
        if (senseId.isEmpty) continue;
        senseById[senseId] = item;
      }

      final mapRows =
          lessonMap
              .map((row) => _asMap(row))
              .whereType<Map<String, dynamic>>()
              .toList()
            ..sort((a, b) {
              final aOrder = _readInt(a, 'order') ?? 0;
              final bOrder = _readInt(b, 'order') ?? 0;
              return aOrder.compareTo(bOrder);
            });

      final normalizedRows = <Map<String, dynamic>>[];
      for (final mapRow in mapRows) {
        final senseId = _readText(mapRow, 'senseId');
        if (senseId.isEmpty) continue;

        final sense = senseById[senseId];
        if (sense == null) continue;

        final vocabId = _readText(sense, 'vocabId');
        if (vocabId.isEmpty) continue;

        final lemma = masterById[vocabId];
        if (lemma == null) continue;

        final term = _readText(lemma, 'term');
        if (term.isEmpty) continue;

        final meaningVi = _readText(sense, 'meaningVi');
        if (meaningVi.isEmpty) continue;

        final mappedLesson = _readInt(mapRow, 'lessonId') ?? lessonId;
        final tag = _firstNonEmpty([
          _readText(mapRow, 'tag'),
          _readText(sense, 'tag'),
          _readText(lemma, 'tag'),
        ]);
        final tags = tag.isEmpty
            ? 'minna_$mappedLesson'
            : 'minna_$mappedLesson,$tag';

        normalizedRows.add({
          'term': term,
          'reading': _readNullableText(lemma, 'reading'),
          'kanjiMeaning': _readNullableText(lemma, 'kanjiMeaning'),
          'sourceVocabId': vocabId,
          'sourceSenseId': senseId,
          'meaning_vi': meaningVi,
          'meaning_en': _readNullableText(sense, 'meaningEn'),
          'level': level,
          'tags': tags,
        });
      }

      return normalizedRows;
    } catch (_) {
      return const [];
    }
  }

  List<Map<String, dynamic>> _mergeLessonRows({
    required List<Map<String, dynamic>> preferred,
    required List<Map<String, dynamic>> fallback,
    required String level,
    required int lessonId,
  }) {
    final merged = <Map<String, dynamic>>[];
    final seen = <String>{};

    void addRow(Map<String, dynamic> raw) {
      final term = _readText(raw, 'term');
      final meaningVi = _firstNonEmpty([
        _readText(raw, 'meaning_vi'),
        _readText(raw, 'meaning'),
      ]);
      if (term.isEmpty || meaningVi.isEmpty) return;

      final reading = _readNullableText(raw, 'reading');
      if (_containsPlaceholder(term) || _containsPlaceholder(reading)) {
        return;
      }
      final kanjiMeaning = _readNullableText(raw, 'kanjiMeaning');
      final sourceVocabId = _readNullableText(raw, 'sourceVocabId');
      final sourceSenseId = _readNullableText(raw, 'sourceSenseId');
      final meaningEn = _readNullableText(raw, 'meaning_en');
      final rowLevel = _firstNonEmpty([_readText(raw, 'level'), level]);
      final tags = _firstNonEmpty([_readText(raw, 'tags'), 'minna_$lessonId']);

      final normalized = <String, dynamic>{
        'term': term,
        'reading': reading,
        'kanjiMeaning': kanjiMeaning,
        'sourceVocabId': sourceVocabId,
        'sourceSenseId': sourceSenseId,
        'meaning_vi': meaningVi,
        'meaning_en': meaningEn,
        'level': rowLevel,
        'tags': tags,
      };

      final key = _exactSignature(normalized);
      if (seen.add(key)) {
        merged.add(normalized);
      }
    }

    for (final item in preferred) {
      addRow(item);
    }
    for (final item in fallback) {
      addRow(item);
    }

    return merged;
  }

  List<Map<String, dynamic>> _collapseExactDuplicateRows(
    List<Map<String, dynamic>> rows,
  ) {
    final aggregateBySignature = <String, _SeedVocabAggregate>{};
    for (final row in rows) {
      final signature = _exactSignature(row);
      final existing = aggregateBySignature[signature];
      if (existing == null) {
        aggregateBySignature[signature] = _SeedVocabAggregate.fromRow(row);
      } else {
        existing.mergeTags(_readNullableText(row, 'tags'));
      }
    }
    return aggregateBySignature.values.map((item) => item.toRow()).toList();
  }

  Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }

  String _readText(Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value == null) return '';
    return value.toString().trim();
  }

  String? _readNullableText(Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    return text;
  }

  int? _readInt(Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  String _firstNonEmpty(List<String?> candidates) {
    for (final candidate in candidates) {
      final normalized = candidate?.trim() ?? '';
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }
    return '';
  }

  String _exactSignature(Map<String, dynamic> row) {
    final term = _readText(row, 'term');
    final reading = _readText(row, 'reading');
    final kanjiMeaning = _readText(row, 'kanjiMeaning');
    final sourceVocabId = _readText(row, 'sourceVocabId');
    final sourceSenseId = _readText(row, 'sourceSenseId');
    final meaningVi = _firstNonEmpty([
      _readText(row, 'meaning_vi'),
      _readText(row, 'meaning'),
    ]);
    final meaningEn = _readText(row, 'meaning_en');
    final level = _readText(row, 'level');
    return '$term|$reading|$kanjiMeaning|$sourceVocabId|$sourceSenseId|$meaningVi|$meaningEn|$level';
  }

  bool _containsPlaceholder(String? value) {
    return (value ?? '').contains('?');
  }

  Future<void> _addColumn<T extends Object>(
    Migrator migrator,
    TableInfo table,
    Column<T> column,
  ) async {
    await migrator.addColumn(table, column as GeneratedColumn);
  }

  Future<void> _reseedMinnaKanji() async {
    // Delete all existing Kanji data to prevent duplicates or stale data
    await delete(kanji).go();

    // Seed new Kanji data
    await _seedMinnaKanji();
  }

  Future<void> _seedMinnaKanji() async {
    final List<String> kanjiFiles = [];

    // N5: Lesson 1 to 25
    for (int i = 1; i <= 25; i++) {
      kanjiFiles.add('assets/data/kanji/n5/kanji_n5_$i.json');
    }

    // N4: Lesson 26 to 50
    for (int i = 26; i <= 50; i++) {
      kanjiFiles.add('assets/data/kanji/n4/kanji_n4_$i.json');
    }

    for (final file in kanjiFiles) {
      try {
        final jsonString = await rootBundle.loadString(file);
        final List<dynamic> jsonList = json.decode(jsonString);

        await batch((batch) {
          for (final item in jsonList) {
            batch.insert(
              kanji,
              KanjiCompanion.insert(
                lessonId: item['lessonId'],
                character: item['character'],
                strokeCount: item['strokeCount'],
                onyomi: Value(item['onyomi']),
                kunyomi: Value(item['kunyomi']),
                meaning: item['meaning'],
                meaningEn: Value(item['meaningEn']),
                mnemonicVi: Value(item['mnemonic_vi']),
                mnemonicEn: Value(item['mnemonic_en']),
                examplesJson: json.encode(item['examples']),
                jlptLevel: item['jlptLevel'],
              ),
            );
          }
        });
      } catch (e) {
        // print('Error seeding Kanji file $file: $e');
      }
    }
  }
}

class _SeedVocabAggregate {
  _SeedVocabAggregate({
    required this.term,
    required this.reading,
    required this.kanjiMeaning,
    required this.sourceVocabId,
    required this.sourceSenseId,
    required this.meaningVi,
    required this.meaningEn,
    required this.level,
    required Iterable<String> tags,
  }) : _tags = LinkedHashSet<String>() {
    _mergeTags(tags);
  }

  final String term;
  final String? reading;
  final String? kanjiMeaning;
  final String? sourceVocabId;
  final String? sourceSenseId;
  final String meaningVi;
  final String? meaningEn;
  final String level;
  final LinkedHashSet<String> _tags;

  factory _SeedVocabAggregate.fromRow(Map<String, dynamic> row) {
    return _SeedVocabAggregate(
      term: row['term'] as String,
      reading: row['reading'] as String?,
      kanjiMeaning: row['kanjiMeaning'] as String?,
      sourceVocabId: row['sourceVocabId'] as String?,
      sourceSenseId: row['sourceSenseId'] as String?,
      meaningVi: row['meaning_vi'] as String,
      meaningEn: row['meaning_en'] as String?,
      level: row['level'] as String,
      tags: _splitTags(row['tags'] as String?),
    );
  }

  void mergeTags(String? tags) {
    _mergeTags(_splitTags(tags));
  }

  Map<String, dynamic> toRow() {
    return {
      'term': term,
      'reading': reading,
      'kanjiMeaning': kanjiMeaning,
      'sourceVocabId': sourceVocabId,
      'sourceSenseId': sourceSenseId,
      'meaning_vi': meaningVi,
      'meaning_en': meaningEn,
      'level': level,
      'tags': _tags.join(','),
    };
  }

  void _mergeTags(Iterable<String> tags) {
    for (final tag in tags) {
      final normalized = tag.trim();
      if (normalized.isNotEmpty) {
        _tags.add(normalized);
      }
    }
  }

  static Iterable<String> _splitTags(String? rawTags) sync* {
    if (rawTags == null || rawTags.trim().isEmpty) {
      return;
    }

    for (final tag in rawTags.split(',')) {
      final normalized = tag.trim();
      if (normalized.isNotEmpty) {
        yield normalized;
      }
    }
  }
}

LazyDatabase _openContentConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'content.sqlite'));
    return NativeDatabase(file);
  });
}
