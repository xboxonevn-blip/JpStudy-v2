import 'package:drift/drift.dart';

class Vocab extends Table {
  @override
  String get tableName => 'vocab';

  IntColumn get id => integer()();
  TextColumn get term => text()();
  TextColumn get reading => text().nullable()();
  TextColumn get meaning => text()();
  TextColumn get level => text()();
  TextColumn get tags => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Grammar extends Table {
  @override
  String get tableName => 'grammar';

  IntColumn get id => integer()();
  TextColumn get level => text()();
  TextColumn get title => text()();
  TextColumn get summary => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Question extends Table {
  @override
  String get tableName => 'question';

  IntColumn get id => integer()();
  TextColumn get level => text()();
  TextColumn get prompt => text()();
  TextColumn get choicesJson => text()();
  IntColumn get correctIndex => integer()();
  IntColumn get grammarId => integer().nullable()();
  TextColumn get explanation => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MockTest extends Table {
  @override
  String get tableName => 'mock_test';

  IntColumn get id => integer()();
  TextColumn get level => text()();
  TextColumn get title => text()();
  IntColumn get durationSeconds => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class MockTestSection extends Table {
  @override
  String get tableName => 'mock_test_section';

  IntColumn get id => integer()();
  IntColumn get testId => integer()();
  TextColumn get title => text()();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class MockTestQuestionMap extends Table {
  @override
  String get tableName => 'mock_test_question_map';

  IntColumn get id => integer()();
  IntColumn get testId => integer()();
  IntColumn get sectionId => integer()();
  IntColumn get questionId => integer()();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserProgress extends Table {
  @override
  String get tableName => 'user_progress';

  IntColumn get vocabId => integer().references(Vocab, #id)();
  IntColumn get correctCount => integer().withDefault(const Constant(0))();
  IntColumn get missedCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {vocabId};
}
