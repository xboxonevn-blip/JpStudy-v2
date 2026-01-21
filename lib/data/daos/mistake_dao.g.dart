// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mistake_dao.dart';

// ignore_for_file: type=lint
mixin _$MistakeDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserMistakesTable get userMistakes => attachedDatabase.userMistakes;
  MistakeDaoManager get managers => MistakeDaoManager(this);
}

class MistakeDaoManager {
  final _$MistakeDaoMixin _db;
  MistakeDaoManager(this._db);
  $$UserMistakesTableTableManager get userMistakes =>
      $$UserMistakesTableTableManager(_db.attachedDatabase, _db.userMistakes);
}
