import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../mistakes/repositories/mistake_repository.dart';

final dashboardProvider = FutureProvider<DashboardState>((ref) async {
  final progress = await ref.watch(progressSummaryProvider.future);
  
  final db = ref.watch(databaseProvider);
  final srsDao = db.srsDao;
  final grammarDao = db.grammarDao;
  final mistakeRepo = ref.watch(mistakeRepositoryProvider);

  // Fetch Vocab Due Count
  final vocabDueFunctions = await srsDao.getDueReviews();
  final vocabDueCount = vocabDueFunctions.length;

  // Fetch Grammar Due Count
  final grammarDueFunctions = await grammarDao.getDueReviews();
  final grammarDueCount = grammarDueFunctions.length;

  // Fetch Mistake Count
  final mistakeCountStream = mistakeRepo.watchTotalMistakes();
  final mistakeCount = await mistakeCountStream.first;

  return DashboardState(
    streak: progress.streak,
    todayXp: progress.todayXp,
    vocabDue: vocabDueCount,
    grammarDue: grammarDueCount,
    mistakeCount: mistakeCount,
  );
});

class DashboardState {
  final int streak;
  final int todayXp;
  final int vocabDue;
  final int grammarDue;
  final int mistakeCount;

  const DashboardState({
    required this.streak,
    required this.todayXp,
    required this.vocabDue,
    required this.grammarDue,
    required this.mistakeCount,
  });
}
