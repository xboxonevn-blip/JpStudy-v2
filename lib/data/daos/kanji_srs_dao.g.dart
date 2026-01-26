// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kanji_srs_dao.dart';

// ignore_for_file: type=lint
mixin _$KanjiSrsDaoMixin on DatabaseAccessor<AppDatabase> {
  $KanjiSrsStateTable get kanjiSrsState => attachedDatabase.kanjiSrsState;
  KanjiSrsDaoManager get managers => KanjiSrsDaoManager(this);
}

class KanjiSrsDaoManager {
  final _$KanjiSrsDaoMixin _db;
  KanjiSrsDaoManager(this._db);
  $$KanjiSrsStateTableTableManager get kanjiSrsState =>
      $$KanjiSrsStateTableTableManager(_db.attachedDatabase, _db.kanjiSrsState);
}
