import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../db/study_tables.dart';

part 'learn_dao.g.dart';

@DriftAccessor(tables: [LearnSessions, LearnAnswers])
class LearnDao extends DatabaseAccessor<AppDatabase> with _$LearnDaoMixin {
  LearnDao(super.db);

  /// Create a new session
  Future<int> createSession(LearnSessionsCompanion session) {
    return into(learnSessions).insert(session);
  }

  /// Update an existing session
  Future<bool> updateSession(LearnSessionsCompanion session) {
    return update(learnSessions).replace(session);
  }

  /// Get session by ID
  Future<LearnSession?> getSession(String id) {
    return (select(
      learnSessions,
    )..where((t) => t.sessionId.equals(id))).getSingleOrNull();
  }

  /// Get incomplete sessions for a lesson
  Future<List<LearnSession>> getIncompleteSessions(int lessonId) {
    return (select(learnSessions)
          ..where((t) => t.lessonId.equals(lessonId))
          ..where((t) => t.completedAt.isNull()))
        .get();
  }

  /// Get completed sessions (history) for a lesson
  Future<List<LearnSession>> getSessionHistory(int lessonId) {
    return (select(learnSessions)
          ..where((t) => t.lessonId.equals(lessonId))
          ..where((t) => t.completedAt.isNotNull())
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.completedAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  /// Record an answer
  Future<int> recordAnswer(LearnAnswersCompanion answer) {
    return into(learnAnswers).insert(answer);
  }

  /// Get answers for a session
  Future<List<LearnAnswer>> getSessionAnswers(String sessionId) {
    return (select(learnAnswers)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm(expression: t.questionIndex)]))
        .get();
  }
}
