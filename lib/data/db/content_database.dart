import 'dart:convert';
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
  ],
)
class ContentDatabase extends _$ContentDatabase {
  ContentDatabase() : super(_openContentConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedMinnaVocabulary();
        await _seedMinnaGrammar();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(userProgress);
        }
        if (from < 3) {
          await m.addColumn(vocab, vocab.kanjiMeaning);
        }
        if (from < 6) {
           await m.addColumn(vocab, vocab.meaningEn); // Keep original from < 6 for vocab.meaningEn
        }
        if (from < 7) {
          await m.createTable(grammarPoint);
          await m.createTable(grammarExample);
          
          // Seed grammar for the first time
          await _seedMinnaGrammar();
        }
        
        // Always re-seed Minna vocabulary (delete old + insert new)
        await _reseedMinnaVocabulary();
      },
    );
  }

  Future<void> _reseedMinnaVocabulary() async {
    // Delete all old Minna vocabulary (both N5 and N4)
    await (delete(vocab)..where((tbl) => tbl.tags.like('%minna_%'))).go();
    
    // Seed new vocabulary
    await _seedMinnaVocabulary();
  }

  Future<void> _seedMinnaVocabulary() async {
    // Seed N5 Vocabulary from JSON files
    await _seedFromJsonFiles(isN5: true);
    
    // Seed N4 Vocabulary from JSON files
    await _seedFromJsonFiles(isN5: false);
  }

  Future<void> _seedMinnaGrammar() async {
    // Seeding Minna Grammar Lessons 1-5 (Batch 1)
    final List<String> grammarFiles = [
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
      // Add more files here as we create them
    ];

    for (final file in grammarFiles) {
      try {
        final jsonString = await rootBundle.loadString(file);
        final List<dynamic> points = json.decode(jsonString);

        for (final pointData in points) {
          // Insert Grammar Point
          final pointId = await into(grammarPoint).insert(
            GrammarPointCompanion.insert(
              lessonId: pointData['lessonId'] as int,
              title: pointData['title'] as String,
              structure: pointData['structure'] as String,
              explanation: pointData['explanation'] as String,
              explanationEn: Value(pointData['explanationEn'] as String?),
              level: pointData['level'] as String,
              tags: Value(pointData['tags'] as String?),
            ),
            mode: InsertMode.insertOrReplace,
          );

          // Insert Examples
          final List<dynamic> examples = pointData['examples'] ?? [];
          for (final ex in examples) {
            await into(grammarExample).insert(
              GrammarExampleCompanion.insert(
                grammarPointId: pointId,
                sentence: ex['sentence'] as String,
                translation: ex['translation'] as String,
                translationEn: Value(ex['translationEn'] as String?),
                audioUrl: Value(ex['audioUrl'] as String?),
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
    final List<String> jsonFiles = [];
    if (isN5) {
      // N5: Lesson 1 to 25
      for (int i = 1; i <= 25; i++) {
        jsonFiles.add('assets/data/vocab/n5/vocab_n5_$i.json');
      }
    } else {
      // N4: Lesson 26 to 50
      for (int i = 26; i <= 50; i++) {
        jsonFiles.add('assets/data/vocab/n4/vocab_n4_$i.json');
      }
    }
    
    for (final file in jsonFiles) {
      try {
        final jsonString = await rootBundle.loadString(file);
        final List<dynamic> items = json.decode(jsonString);
        
        for (final item in items) {
          await into(vocab).insert(
            VocabCompanion.insert(
              term: item['term'] as String,
              reading: Value(item['reading'] as String?),
              kanjiMeaning: Value(item['kanjiMeaning'] as String?),
              meaning: (item['meaning_vi'] ?? item['meaning']) as String,
              meaningEn: Value(item['meaning_en'] as String?),
              level: item['level'] as String,
              tags: Value(item['tags'] as String?),
            ),
            mode: InsertMode.insertOrIgnore,
          );
        }
      } catch (e) {
        // File might not exist or be invalid, skip silently
        // debugPrint('Error loading $file: $e'); 
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
