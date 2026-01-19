import 'dart:io';

import '../daos/achievement_dao.dart';
import '../daos/learn_dao.dart';
import '../daos/test_dao.dart';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'study_tables.dart';
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
    // Study Tables
    LearnSessions,
    LearnAnswers,
    TestSessions,
    TestAnswers,
    Achievements,
  ],
  daos: [
    LearnDao,
    TestDao,
    AchievementDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 10;

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
          if (from < 5) {
            await migrator.addColumn(userLessonTerm, userLessonTerm.isStarred);
            await migrator.addColumn(userLessonTerm, userLessonTerm.isLearned);
            await customStatement(
              "UPDATE user_lesson_term "
              "SET is_learned = CASE "
              "WHEN TRIM(definition) <> '' THEN 1 ELSE 0 END",
            );
          }
          if (from < 6) {
            await customStatement(
              "INSERT INTO srs_state "
              "(vocab_id, box, repetitions, ease, last_reviewed_at, next_review_at) "
              "SELECT id, 1, 0, 2.5, CURRENT_TIMESTAMP, datetime(CURRENT_TIMESTAMP, '+1 day') "
              "FROM user_lesson_term "
              "WHERE is_learned = 1 "
              "AND id NOT IN (SELECT vocab_id FROM srs_state)",
            );
          }
          if (from < 7) {
            await migrator.addColumn(userLesson, userLesson.tags);
          }
          if (from < 8) {
            await migrator.addColumn(userLesson, userLesson.learnTermLimit);
            await migrator.addColumn(userLesson, userLesson.testQuestionLimit);
            await migrator.addColumn(userLesson, userLesson.matchPairLimit);
            await migrator.addColumn(userProgress, userProgress.reviewedCount);
            await migrator.addColumn(userProgress, userProgress.reviewAgainCount);
            await migrator.addColumn(userProgress, userProgress.reviewHardCount);
            await migrator.addColumn(userProgress, userProgress.reviewGoodCount);
            await migrator.addColumn(userProgress, userProgress.reviewEasyCount);
          }
          if (from < 9) {
            await migrator.addColumn(userLessonTerm, userLessonTerm.kanjiMeaning);
          }
          if (from < 10) {
            await migrator.createTable(learnSessions);
            await migrator.createTable(learnAnswers);
            await migrator.createTable(testSessions);
            await migrator.createTable(testAnswers);
            await migrator.createTable(achievements);
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
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'jpstudy.sqlite'));
    return NativeDatabase(file);
  });
}
