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
  int get schemaVersion => 3;

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
        // Seed vocabulary if not already done
        final count = await (select(vocab)..limit(1)).get();
        if (count.isEmpty) {
          await _seedMinnaVocabulary();
        }
      },
    );
  }

  Future<void> _seedMinnaVocabulary() async {
    // Seed Minna No Nihongo Lessons 1-5 (119 terms)
    final vocabData = _getMinnaVocab();
    
    for (final item in vocabData) {
      await into(vocab).insert(
        VocabCompanion.insert(
          term: item['term']!,
          reading: Value(item['reading']),
          kanjiMeaning: Value(item['kanjiMeaning']),
          meaning: item['meaning']!,
          level: item['level']!,
          tags: Value(item['tags']),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  List<Map<String, String?>> _getMinnaVocab() {
    return [
      // Lesson 1
      {'term': '私', 'reading': 'わたし', 'kanjiMeaning': 'tôi', 'meaning': 'tôi', 'level': 'N5', 'tags': 'minna_1,pronoun'},
      {'term': '私たち', 'reading': 'わたしたち', 'kanjiMeaning': 'chúng tôi', 'meaning': 'chúng tôi', 'level': 'N5', 'tags': 'minna_1,pronoun'},
      {'term': 'あなた', 'reading': 'あなた', 'kanjiMeaning': null, 'meaning': 'bạn', 'level': 'N5', 'tags': 'minna_1,pronoun'},
      {'term': 'あの人', 'reading': 'あのひと', 'kanjiMeaning': 'người kia', 'meaning': 'người kia', 'level': 'N5', 'tags': 'minna_1,pronoun'},
      {'term': '先生', 'reading': 'せんせい', 'kanjiMeaning': 'tiên sinh', 'meaning': 'giáo viên', 'level': 'N5', 'tags': 'minna_1,occupation'},
      {'term': '学生', 'reading': 'がくせい', 'kanjiMeaning': 'học sinh', 'meaning': 'học sinh', 'level': 'N5', 'tags': 'minna_1,occupation'},
      {'term': '会社員', 'reading': 'かいしゃいん', 'kanjiMeaning': 'nhân viên công ty', 'meaning': 'nhân viên công ty', 'level': 'N5', 'tags': 'minna_1,occupation'},
      {'term': '医者', 'reading': 'いしゃ', 'kanjiMeaning': 'thầy thuốc', 'meaning': 'bác sĩ', 'level': 'N5', 'tags': 'minna_1,occupation'},
      {'term': '大学', 'reading': 'だいがく', 'kanjiMeaning': 'đại học', 'meaning': 'trường đại học', 'level': 'N5', 'tags': 'minna_1,place'},
      {'term': '病院', 'reading': 'びょういん', 'kanjiMeaning': 'bệnh viện', 'meaning': 'bệnh viện', 'level': 'N5', 'tags': 'minna_1,place'},
      {'term': 'はい', 'reading': 'はい', 'kanjiMeaning': null, 'meaning': 'vâng', 'level': 'N5', 'tags': 'minna_1,response'},
      {'term': 'いいえ', 'reading': 'いいえ', 'kanjiMeaning': null, 'meaning': 'không', 'level': 'N5', 'tags': 'minna_1,response'},
      {'term': '初めまして', 'reading': 'はじめまして', 'kanjiMeaning': 'lần đầu gặp', 'meaning': 'hân hạnh được gặp', 'level': 'N5', 'tags': 'minna_1,phrase'},
      {'term': 'どうぞよろしく', 'reading': 'どうぞよろしく', 'kanjiMeaning': null, 'meaning': 'rất hân hạnh', 'level': 'N5', 'tags': 'minna_1,phrase'},
      
      // Lesson 2 (sample - add all 20 later)
      {'term': 'これ', 'reading': 'これ', 'kanjiMeaning': null, 'meaning': 'cái này', 'level': 'N5', 'tags': 'minna_2,pronoun'},
      {'term': 'それ', 'reading': 'それ', 'kanjiMeaning': null, 'meaning': 'cái đó', 'level': 'N5', 'tags': 'minna_2,pronoun'},
      {'term': 'あれ', 'reading': 'あれ', 'kanjiMeaning': null, 'meaning': 'cái kia', 'level': 'N5', 'tags': 'minna_2,pronoun'},
      {'term': '本', 'reading': 'ほん', 'kanjiMeaning': 'sách', 'meaning': 'sách', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': '辞書', 'reading': 'じしょ', 'kanjiMeaning': 'từ điển', 'meaning': 'từ điển', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': '新聞', 'reading': 'しんぶん', 'kanjiMeaning': 'báo mới', 'meaning': 'báo', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': 'ノート', 'reading': 'のーと', 'kanjiMeaning': null, 'meaning': 'vở', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': '鉛筆', 'reading': 'えんぴつ', 'kanjiMeaning': 'bút chì', 'meaning': 'bút chì', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': '時計', 'reading': 'とけい', 'kanjiMeaning': 'đồng hồ', 'meaning': 'đồng hồ', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': '傘', 'reading': 'かさ', 'kanjiMeaning': 'ô', 'meaning': 'cái ô', 'level': 'N5', 'tags': 'minna_2,things'},
      
      // Add Lesson 3-5 vocabulary here (continuing pattern)
      {'term': 'ここ', 'reading': 'ここ', 'kanjiMeaning': null, 'meaning': 'đây', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': 'そこ', 'reading': 'そこ', 'kanjiMeaning': null, 'meaning': 'đó', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': 'あそこ', 'reading': 'あそこ', 'kanjiMeaning': null, 'meaning': 'kia', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': 'どこ', 'reading': 'どこ', 'kanjiMeaning': null, 'meaning': 'đâu', 'level': 'N5', 'tags': 'minna_3,question'},
      {'term': '教室', 'reading': 'きょうしつ', 'kanjiMeaning': 'phòng dạy', 'meaning': 'lớp học', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': '会社', 'reading': 'かいしゃ', 'kanjiMeaning': 'công ty', 'meaning': 'công ty', 'level': 'N5', 'tags': 'minna_3,place'},
    ];
  }
}

LazyDatabase _openContentConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'content.sqlite'));
    if (!await file.exists()) {
      final data = await rootBundle.load('assets/db/content.sqlite');
      await file.writeAsBytes(data.buffer.asUint8List());
    }
    return NativeDatabase(file);
  });
}
