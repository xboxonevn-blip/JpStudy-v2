// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'han_viet_rule_srs_dao.dart';

// ignore_for_file: type=lint
mixin _$HanVietRuleSrsDaoMixin on DatabaseAccessor<AppDatabase> {
  $HanVietRuleSrsStateTable get hanVietRuleSrsState =>
      attachedDatabase.hanVietRuleSrsState;
  HanVietRuleSrsDaoManager get managers => HanVietRuleSrsDaoManager(this);
}

class HanVietRuleSrsDaoManager {
  final _$HanVietRuleSrsDaoMixin _db;
  HanVietRuleSrsDaoManager(this._db);
  $$HanVietRuleSrsStateTableTableManager get hanVietRuleSrsState =>
      $$HanVietRuleSrsStateTableTableManager(
        _db.attachedDatabase,
        _db.hanVietRuleSrsState,
      );
}
