import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    SrsState,
    UserProgress,
    Attempt,
    AttemptAnswer,
    UserLesson,
    UserLessonTerm,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
        },
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.createTable(userLesson);
            await migrator.createTable(userLessonTerm);
          }
          if (from < 3) {
            await migrator.addColumn(userLesson, userLesson.isCustomTitle);
          }
          if (from < 4) {
            await _removeImagePathColumn(migrator);
          }
        },
      );

  Future<void> _removeImagePathColumn(Migrator migrator) async {
    await customStatement(
      'ALTER TABLE user_lesson_term RENAME TO user_lesson_term_old',
    );
    await migrator.createTable(userLessonTerm);
    await customStatement(
      'INSERT INTO user_lesson_term (id, lesson_id, term, reading, definition, order_index) '
      'SELECT id, lesson_id, term, reading, definition, order_index '
      'FROM user_lesson_term_old',
    );
    await customStatement('DROP TABLE user_lesson_term_old');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'jpstudy.sqlite'));
    return NativeDatabase(file);
  });
}
