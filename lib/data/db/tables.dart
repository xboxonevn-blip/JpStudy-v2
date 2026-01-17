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

class UserLesson extends Table {
  IntColumn get id => integer()();
  TextColumn get level => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  BoolColumn get isPublic => boolean().withDefault(const Constant(true))();
  BoolColumn get isCustomTitle => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserLessonTerm extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(UserLesson, #id)();
  TextColumn get term => text().withDefault(const Constant(''))();
  TextColumn get reading => text().withDefault(const Constant(''))();
  TextColumn get definition => text().withDefault(const Constant(''))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
}
