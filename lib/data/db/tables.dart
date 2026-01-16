import 'package:drift/drift.dart';

class VocabItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get term => text()();
  TextColumn get reading => text().nullable()();
  TextColumn get meaning => text()();
  TextColumn get level => text().withDefault(const Constant('N5'))();
  TextColumn get tags => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class SrsReviews extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabId => integer().references(VocabItems, #id)();
  IntColumn get box => integer().withDefault(const Constant(1))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  RealColumn get ease => real().withDefault(const Constant(2.5))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  DateTimeColumn get nextReviewAt => dateTime()();
}

class GrammarQuestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get level => text().withDefault(const Constant('N5'))();
  TextColumn get prompt => text()();
  TextColumn get choicesJson => text()();
  IntColumn get correctIndex => integer()();
  TextColumn get explanation => text().nullable()();
}

class ExamSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get level => text().withDefault(const Constant('N5'))();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get durationSeconds => integer()();
  IntColumn get score => integer().nullable()();
  IntColumn get total => integer().nullable()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
}

class ExamAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(ExamSessions, #id)();
  IntColumn get questionId => integer().references(GrammarQuestions, #id)();
  IntColumn get selectedIndex => integer()();
  BoolColumn get isCorrect => boolean()();
}

class DailyProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get day => dateTime()();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get cardsReviewed => integer().withDefault(const Constant(0))();
  IntColumn get quizzesCompleted => integer().withDefault(const Constant(0))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
}
