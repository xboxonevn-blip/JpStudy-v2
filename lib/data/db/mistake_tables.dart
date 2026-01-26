import 'package:drift/drift.dart';

class UserMistakes extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 'vocab', 'grammar', 'kanji'
  TextColumn get type => text()();

  // References the ID in the respective table (vocab_id, grammar_id, etc.)
  IntColumn get itemId => integer()();

  // How many times the user got this wrong since it was added
  IntColumn get wrongCount => integer().withDefault(const Constant(1))();

  // When the last mistake occurred (for sorting/aging)
  DateTimeColumn get lastMistakeAt => dateTime()();

  // Context snapshot of the last mistake
  TextColumn get prompt => text().nullable()();
  TextColumn get correctAnswer => text().nullable()();
  TextColumn get userAnswer => text().nullable()();
  TextColumn get source => text().nullable()();
  TextColumn get extraJson => text().nullable()();

  // Ensure we don't have duplicate entries for the same item
  @override
  List<Set<Column>> get uniqueKeys => [
    {type, itemId},
  ];
}
