// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_dao.dart';

// ignore_for_file: type=lint
mixin _$TestDaoMixin on DatabaseAccessor<AppDatabase> {
  $TestSessionsTable get testSessions => attachedDatabase.testSessions;
  $TestAnswersTable get testAnswers => attachedDatabase.testAnswers;
  TestDaoManager get managers => TestDaoManager(this);
}

class TestDaoManager {
  final _$TestDaoMixin _db;
  TestDaoManager(this._db);
  $$TestSessionsTableTableManager get testSessions =>
      $$TestSessionsTableTableManager(_db.attachedDatabase, _db.testSessions);
  $$TestAnswersTableTableManager get testAnswers =>
      $$TestAnswersTableTableManager(_db.attachedDatabase, _db.testAnswers);
}
