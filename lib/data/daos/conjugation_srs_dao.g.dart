// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conjugation_srs_dao.dart';

// ignore_for_file: type=lint
mixin _$ConjugationSrsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ConjugationSrsStateTable get conjugationSrsState =>
      attachedDatabase.conjugationSrsState;
  $UserMistakesTable get userMistakes => attachedDatabase.userMistakes;
  ConjugationSrsDaoManager get managers => ConjugationSrsDaoManager(this);
}

class ConjugationSrsDaoManager {
  final _$ConjugationSrsDaoMixin _db;
  ConjugationSrsDaoManager(this._db);
  $$ConjugationSrsStateTableTableManager get conjugationSrsState =>
      $$ConjugationSrsStateTableTableManager(
        _db.attachedDatabase,
        _db.conjugationSrsState,
      );
  $$UserMistakesTableTableManager get userMistakes =>
      $$UserMistakesTableTableManager(_db.attachedDatabase, _db.userMistakes);
}
