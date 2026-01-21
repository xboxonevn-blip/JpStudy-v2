import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../db/mistake_tables.dart';

part 'mistake_dao.g.dart';

@DriftAccessor(tables: [UserMistakes])
class MistakeDao extends DatabaseAccessor<AppDatabase> with _$MistakeDaoMixin {
  MistakeDao(super.db);

  /// Adds a mistake to the bank.
  /// If it already exists, increments the wrongCount and updates the timestamp.
  Future<void> addMistake(String type, int itemId) async {
    await customStatement(
      'INSERT INTO user_mistakes (type, item_id, wrong_count, last_mistake_at) '
      'VALUES (?, ?, 1, ?) '
      'ON CONFLICT(type, item_id) DO UPDATE SET '
      'wrong_count = wrong_count + 1, '
      'last_mistake_at = ?',
      [
        type,
        itemId,
        DateTime.now().toIso8601String(),
        DateTime.now().toIso8601String(),
      ],
    );
  }

  /// Removes a mistake from the bank (e.g. when answered correctly enough times).
  Future<void> removeMistake(String type, int itemId) async {
    await (delete(userMistakes)
          ..where((tbl) => tbl.type.equals(type) & tbl.itemId.equals(itemId)))
        .go();
  }

  /// Gets the total count of mistakes in the bank.
  Stream<int> watchTotalMistakes() {
    final count = userMistakes.id.count();
    return (selectOnly(userMistakes)..addColumns([count]))
        .map((row) => row.read(count) ?? 0)
        .watchSingle();
  }

  /// Gets key-value pairs of pending mistakes for a specific type.
  Future<List<UserMistake>> getMistakesByType(String type) {
    return (select(userMistakes)..where((tbl) => tbl.type.equals(type))).get();
  }
  
  /// Get all mistakes
  Future<List<UserMistake>> getAllMistakes() {
    return select(userMistakes).get();
  }
}
