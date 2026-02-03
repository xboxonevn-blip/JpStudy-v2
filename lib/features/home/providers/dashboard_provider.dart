import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../mistakes/repositories/mistake_repository.dart';

final dashboardProvider = StreamProvider<DashboardState>((ref) async* {
  final lessonRepo = ref.watch(lessonRepositoryProvider);
  final db = ref.watch(databaseProvider);
  final srsDao = db.srsDao;
  final grammarDao = db.grammarDao;
  final kanjiSrsDao = db.kanjiSrsDao;
  final mistakeRepo = ref.watch(mistakeRepositoryProvider);
  while (true) {
    final progress = await lessonRepo.fetchProgressSummary();
    final vocabDueCount = (await srsDao.getDueReviews()).length;
    final grammarDueCount = (await grammarDao.getDueReviews()).length;
    final kanjiDueCount = (await kanjiSrsDao.getDueReviews()).length;
    final mistakes = await mistakeRepo.getAllMistakes();
    var vocabMistakeCount = 0;
    var grammarMistakeCount = 0;
    var kanjiMistakeCount = 0;
    for (final mistake in mistakes) {
      if (mistake.type == 'vocab') {
        vocabMistakeCount += 1;
      } else if (mistake.type == 'grammar') {
        grammarMistakeCount += 1;
      } else if (mistake.type == 'kanji') {
        kanjiMistakeCount += 1;
      }
    }
    yield DashboardState(
      streak: progress.streak,
      todayXp: progress.todayXp,
      vocabDue: vocabDueCount,
      grammarDue: grammarDueCount,
      kanjiDue: kanjiDueCount,
      vocabMistakeCount: vocabMistakeCount,
      grammarMistakeCount: grammarMistakeCount,
      kanjiMistakeCount: kanjiMistakeCount,
      totalMistakeCount: mistakes.length,
    );
    await Future<void>.delayed(const Duration(seconds: 10));
  }
});

class DashboardState {
  final int streak;
  final int todayXp;
  final int vocabDue;
  final int grammarDue;
  final int kanjiDue;
  final int vocabMistakeCount;
  final int grammarMistakeCount;
  final int kanjiMistakeCount;
  final int totalMistakeCount;

  const DashboardState({
    required this.streak,
    required this.todayXp,
    required this.vocabDue,
    required this.grammarDue,
    required this.kanjiDue,
    required this.vocabMistakeCount,
    required this.grammarMistakeCount,
    required this.kanjiMistakeCount,
    required this.totalMistakeCount,
  });
}
