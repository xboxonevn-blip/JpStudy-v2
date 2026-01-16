import 'package:drift/drift.dart';

class SrsState extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabId => integer()();
  IntColumn get box => integer().withDefault(const Constant(1))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  RealColumn get ease => real().withDefault(const Constant(2.5))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  DateTimeColumn get nextReviewAt => dateTime()();
}

class UserProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get day => dateTime()();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
}

class Attempt extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mode => text()();
  TextColumn get level => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  IntColumn get score => integer().nullable()();
  IntColumn get total => integer().nullable()();
}

class AttemptAnswer extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get attemptId => integer().references(Attempt, #id)();
  IntColumn get questionId => integer()();
  IntColumn get selectedIndex => integer()();
  BoolColumn get isCorrect => boolean()();
}
