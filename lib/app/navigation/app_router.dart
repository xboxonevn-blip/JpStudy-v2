import 'package:go_router/go_router.dart';
import 'package:jpstudy/features/exam/exam_screen.dart';
import 'package:jpstudy/features/grammar/grammar_screen.dart';
import 'package:jpstudy/features/home/home_screen.dart';
import 'package:jpstudy/features/lesson/lesson_detail_screen.dart';
import 'package:jpstudy/features/lesson/lesson_edit_screen.dart';
import 'package:jpstudy/features/lesson/lesson_practice_screen.dart';
import 'package:jpstudy/features/progress/progress_screen.dart';
import 'package:jpstudy/features/vocab/vocab_screen.dart';
import 'package:jpstudy/features/games/match_game/match_game_screen.dart';
import 'package:jpstudy/features/learn/integration/learn_mode_integration.dart';
import 'package:jpstudy/features/test/integration/test_mode_integration.dart';
import 'package:jpstudy/features/test/screens/test_history_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/vocab',
        builder: (context, state) => const VocabScreen(),
      ),
      GoRoute(
        path: '/grammar',
        builder: (context, state) => const GrammarScreen(),
      ),
      GoRoute(
        path: '/exam',
        builder: (context, state) => const ExamScreen(),
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: '/lesson/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return LessonDetailScreen(lessonId: id ?? 1);
        },
      ),
      GoRoute(
        path: '/lesson/:id/edit',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return LessonEditScreen(lessonId: id ?? 1);
        },
      ),
      GoRoute(
        path: '/lesson/:id/practice/:mode',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final modeValue = state.pathParameters['mode'] ?? 'learn';
          final mode = lessonPracticeModeFromPath(modeValue) ??
              LessonPracticeMode.learn;
          return LessonPracticeScreen(
            lessonId: id ?? 1,
            mode: mode,
          );
        },
      ),
      GoRoute(
        path: '/match',
        builder: (context, state) => const MatchGameScreen(),
      ),
      // Enhanced Learn Mode with config screen
      GoRoute(
        path: '/lesson/:id/learn-enhanced',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final title = state.uri.queryParameters['title'] ?? 'Lesson';
          return LearnModeIntegration(
            lessonId: id ?? 1,
            lessonTitle: title,
          );
        },
      ),
      // Enhanced Test Mode with config screen  
      GoRoute(
        path: '/lesson/:id/test-enhanced',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final title = state.uri.queryParameters['title'] ?? 'Lesson';
          return TestModeIntegration(
            lessonId: id ?? 1,
            lessonTitle: title,
          );
        },
      ),
      // Test History Screen
      GoRoute(
        path: '/lesson/:id/test-history',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final title = state.uri.queryParameters['title'] ?? 'Lesson';
          return TestHistoryScreen(
            lessonId: id ?? 1,
            lessonTitle: title,
          );
        },
      ),
    ],
  );
}
