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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(userProgress);
        }
      },
    );
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
