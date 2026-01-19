// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_dao.dart';

// ignore_for_file: type=lint
mixin _$LearnDaoMixin on DatabaseAccessor<AppDatabase> {
  $LearnSessionsTable get learnSessions => attachedDatabase.learnSessions;
  $LearnAnswersTable get learnAnswers => attachedDatabase.learnAnswers;
  LearnDaoManager get managers => LearnDaoManager(this);
}

class LearnDaoManager {
  final _$LearnDaoMixin _db;
  LearnDaoManager(this._db);
  $$LearnSessionsTableTableManager get learnSessions =>
      $$LearnSessionsTableTableManager(_db.attachedDatabase, _db.learnSessions);
  $$LearnAnswersTableTableManager get learnAnswers =>
      $$LearnAnswersTableTableManager(_db.attachedDatabase, _db.learnAnswers);
}
