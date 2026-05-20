import 'package:drift/drift.dart';

class ConjugationSrsState extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get contentVocabId => integer()();
  TextColumn get formKey => text()();
  TextColumn get direction => text()();
  RealColumn get stability => real().withDefault(const Constant(1.0))();
  RealColumn get difficulty => real().withDefault(const Constant(5.0))();
  IntColumn get fsrsState => integer().withDefault(const Constant(1))();
  IntColumn get fsrsStep => integer().nullable()();
  IntColumn get lastConfidence => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  DateTimeColumn get nextReviewAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {contentVocabId, formKey, direction},
  ];
}
