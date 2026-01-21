import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/daos/mistake_dao.dart';

final mistakeRepositoryProvider = Provider<MistakeRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return MistakeRepository(db.mistakeDao);
});

class MistakeRepository {
  final MistakeDao _dao;

  MistakeRepository(this._dao);

  Stream<int> watchTotalMistakes() {
    return _dao.watchTotalMistakes();
  }

  Future<void> addMistake({required String type, required int itemId}) async {
    await _dao.addMistake(type, itemId);
  }

  Future<void> removeMistake({required String type, required int itemId}) async {
    await _dao.removeMistake(type, itemId);
  }

  Future<List<UserMistake>> getMistakesByType(String type) {
    return _dao.getMistakesByType(type);
  }
}
