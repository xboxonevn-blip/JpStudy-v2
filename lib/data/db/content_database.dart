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
  ],
)
class ContentDatabase extends _$ContentDatabase {
  ContentDatabase() : super(_openContentConnection());

  @override
  int get schemaVersion => 1;
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
