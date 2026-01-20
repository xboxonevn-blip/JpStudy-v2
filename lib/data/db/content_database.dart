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
    Grammar,
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
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedMinnaVocabulary();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(userProgress);
        }
        if (from < 3) {
          await m.addColumn(vocab, vocab.kanjiMeaning);
        }
        if (from < 6) {
          await m.addColumn(vocab, vocab.meaningEn);
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
  
  Future<void> _seedFromJsonFiles({bool isN5 = false}) async {
    final List<String> jsonFiles = [];
    if (isN5) {
      // N5: Lesson 1 to 25
      for (int i = 1; i <= 25; i++) {
        jsonFiles.add('assets/data/vocab_n5_$i.json');
      }
    } else {
      // N4: Lesson 26 to 50
      for (int i = 26; i <= 50; i++) {
        jsonFiles.add('assets/data/vocab_n4_$i.json');
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
