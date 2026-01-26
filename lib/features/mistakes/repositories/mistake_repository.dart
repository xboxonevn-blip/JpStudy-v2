import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/daos/mistake_dao.dart';
import '../../../data/models/mistake_context.dart';

final mistakeRepositoryProvider = Provider<MistakeRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return MistakeRepository(db.mistakeDao);
});

final mistakesByTypeProvider = FutureProvider.family<List<UserMistake>, String>(
  (ref, type) async {
    final repo = ref.watch(mistakeRepositoryProvider);
    return repo.getMistakesByType(type);
  },
);

class MistakeRepository {
  final MistakeDao _dao;

  MistakeRepository(this._dao);

  Stream<int> watchTotalMistakes() {
    return _dao.watchTotalMistakes();
  }

  Stream<int> watchVocabMistakeItemCount() {
    return _dao.watchMistakeItemCount(type: 'vocab');
  }

  Future<void> addMistake({
    required String type,
    required int itemId,
    MistakeContext? context,
  }) async {
    await _dao.addMistake(
      type,
      itemId,
      prompt: context?.prompt,
      correctAnswer: context?.correctAnswer,
      userAnswer: context?.userAnswer,
      source: context?.source,
      extraJson: context?.extraJson,
    );
  }

  Future<void> removeMistake({
    required String type,
    required int itemId,
  }) async {
    await _dao.removeMistake(type, itemId);
  }

  Future<void> markCorrect({required String type, required int itemId}) async {
    await _dao.markCorrect(type, itemId);
  }

  Future<List<UserMistake>> getMistakesByType(String type) {
    return _dao.getMistakesByType(type);
  }

  Stream<List<UserMistake>> watchAllMistakes() {
    return _dao.watchAllMistakes();
  }
}
