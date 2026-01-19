// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammar_dao.dart';

// ignore_for_file: type=lint
mixin _$GrammarDaoMixin on DatabaseAccessor<AppDatabase> {
  $GrammarPointsTable get grammarPoints => attachedDatabase.grammarPoints;
  $GrammarExamplesTable get grammarExamples => attachedDatabase.grammarExamples;
  $GrammarSrsStateTable get grammarSrsState => attachedDatabase.grammarSrsState;
  GrammarDaoManager get managers => GrammarDaoManager(this);
}

class GrammarDaoManager {
  final _$GrammarDaoMixin _db;
  GrammarDaoManager(this._db);
  $$GrammarPointsTableTableManager get grammarPoints =>
      $$GrammarPointsTableTableManager(_db.attachedDatabase, _db.grammarPoints);
  $$GrammarExamplesTableTableManager get grammarExamples =>
      $$GrammarExamplesTableTableManager(
        _db.attachedDatabase,
        _db.grammarExamples,
      );
  $$GrammarSrsStateTableTableManager get grammarSrsState =>
      $$GrammarSrsStateTableTableManager(
        _db.attachedDatabase,
        _db.grammarSrsState,
      );
}
