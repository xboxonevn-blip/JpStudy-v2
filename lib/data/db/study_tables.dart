import 'package:drift/drift.dart';

/// Learn session tracking table
class LearnSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().unique()();
  IntColumn get lessonId => integer()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get totalQuestions => integer()();
  IntColumn get correctCount => integer().withDefault(const Constant(0))();
  IntColumn get wrongCount => integer().withDefault(const Constant(0))();
  IntColumn get currentRound => integer().withDefault(const Constant(1))();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  BoolColumn get isPerfect => boolean().withDefault(const Constant(false))();
}

/// Individual answer records for learn sessions
class LearnAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().references(LearnSessions, #sessionId)();
  IntColumn get questionIndex => integer()();
  IntColumn get termId => integer()();
  TextColumn get questionType => text()();
  TextColumn get userAnswer => text().nullable()();
  BoolColumn get isCorrect => boolean()();
  IntColumn get timeTakenMs => integer()();
  DateTimeColumn get answeredAt => dateTime()();
}

/// Test session tracking table
class TestSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().unique()();
  IntColumn get lessonId => integer()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get totalQuestions => integer()();
  IntColumn get correctCount => integer()();
  IntColumn get wrongCount => integer()();
  IntColumn get score => integer()(); // Percentage 0-100
  TextColumn get grade => text()(); // A, B, C, D, F
  IntColumn get xpEarned => integer()();
  IntColumn get timeLimitMinutes => integer().nullable()();
}

/// Individual answer records for test sessions
class TestAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().references(TestSessions, #sessionId)();
  IntColumn get questionIndex => integer()();
  IntColumn get termId => integer()();
  TextColumn get questionType => text()();
  TextColumn get userAnswer => text().nullable()();
  BoolColumn get isCorrect => boolean()();
  DateTimeColumn get answeredAt => dateTime()();
}

/// Achievement records
class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'perfect_round', 'streak', 'level_up'
  IntColumn get lessonId => integer().nullable()();
  TextColumn get sessionId => text().nullable()();
  IntColumn get value => integer()(); // streak count, xp amount, etc.
  DateTimeColumn get earnedAt => dateTime()();
  BoolColumn get isNotified => boolean().withDefault(const Constant(false))();
}
