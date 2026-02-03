import 'package:drift/drift.dart';

/// User preferences for Flashcard mode
class FlashcardSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get showTermFirst => boolean().withDefault(const Constant(true))();
  BoolColumn get shuffleCards => boolean().withDefault(const Constant(true))();
  BoolColumn get showStarredOnly =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// User preferences for Learn mode
class LearnSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get defaultQuestionCount =>
      integer().withDefault(const Constant(20))();
  BoolColumn get enableMultipleChoice =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get enableTrueFalse =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get enableFillBlank =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get shuffleQuestions =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get enableHints => boolean().withDefault(const Constant(true))();
  BoolColumn get showCorrectAnswer =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// User preferences for Test mode
class TestSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get defaultQuestionCount =>
      integer().withDefault(const Constant(20))();
  IntColumn get defaultTimeLimitMinutes => integer().nullable()();
  BoolColumn get enableMultipleChoice =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get enableTrueFalse =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get enableFillBlank =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get shuffleQuestions =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get shuffleOptions =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get showCorrectAfterWrong =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
