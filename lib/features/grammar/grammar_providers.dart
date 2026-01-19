import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/repositories/grammar_repository.dart';

final grammarPointsProvider = FutureProvider.family<List<GrammarPoint>, String>((ref, level) {
  final repo = ref.watch(grammarRepositoryProvider);
  return repo.fetchPointsByLevel(level);
});

final grammarDueCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(grammarRepositoryProvider);
  final points = await repo.fetchDuePoints();
  return points.length;
});
