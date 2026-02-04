import 'package:go_router/go_router.dart';
import 'package:jpstudy/features/exam/exam_screen.dart';
import 'package:jpstudy/features/grammar/grammar_screen.dart';
import 'package:jpstudy/features/grammar/screens/grammar_detail_screen.dart';
import 'package:jpstudy/features/grammar/screens/grammar_practice_screen.dart';
import 'package:jpstudy/features/home/home_screen.dart';
import 'package:jpstudy/features/lesson/lesson_detail_screen.dart';
import 'package:jpstudy/features/lesson/lesson_edit_screen.dart';
import 'package:jpstudy/features/lesson/lesson_practice_screen.dart';
import 'package:jpstudy/features/progress/progress_screen.dart';
import 'package:jpstudy/features/vocab/vocab_screen.dart';
import 'package:jpstudy/features/vocab/screens/term_review_screen.dart';
import 'package:jpstudy/features/games/match_game/match_game_screen.dart';
import 'package:jpstudy/features/games/match_game/lesson_match_screen.dart';
import 'package:jpstudy/features/games/kanji_dash/kanji_dash_screen.dart';
import 'package:jpstudy/features/learn/integration/learn_mode_integration.dart';
import 'package:jpstudy/features/learn/models/learn_session_args.dart';
import 'package:jpstudy/features/learn/screens/learn_screen.dart';
import 'package:jpstudy/features/learn/integration/write_mode_integration.dart';
import 'package:jpstudy/features/test/integration/test_mode_integration.dart';
import 'package:jpstudy/features/test/screens/test_history_screen.dart';
import 'package:jpstudy/features/mistakes/screens/mistake_screen.dart';
import 'package:jpstudy/features/immersion/immersion_home_screen.dart';
import 'package:jpstudy/features/achievements/achievements_screen.dart';
import 'package:jpstudy/features/design_lab/design_lab_screen.dart';
import 'package:jpstudy/features/write/screens/home_handwriting_practice_screen.dart';
import 'package:jpstudy/features/test/screens/home_mock_exam_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/vocab', builder: (context, state) => const VocabScreen()),
      GoRoute(
        path: '/vocab/review',
        builder: (context, state) => const TermReviewScreen(),
      ),
      GoRoute(
        path: '/grammar',
        builder: (context, state) => const GrammarScreen(),
      ),
      GoRoute(path: '/exam', builder: (context, state) => const ExamScreen()),
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
        path: '/grammar/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return GrammarDetailScreen(grammarId: id ?? 1);
        },
      ),
      GoRoute(
        path: '/grammar-practice',
        builder: (context, state) {
          List<int>? ids;
          GrammarPracticeMode mode = GrammarPracticeMode.normal;

          if (state.extra is List<int>) {
            ids = state.extra as List<int>;
          } else if (state.extra is GrammarPracticeMode) {
            mode = state.extra as GrammarPracticeMode;
          } else if (state.extra is Map) {
            final map = state.extra as Map;
            ids = map['ids'];
            mode = map['mode'] ?? GrammarPracticeMode.normal;
          }

          return GrammarPracticeScreen(initialIds: ids, mode: mode);
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
          final mode =
              lessonPracticeModeFromPath(modeValue) ?? LessonPracticeMode.learn;
          return LessonPracticeScreen(lessonId: id ?? 1, mode: mode);
        },
      ),
      GoRoute(
        path: '/match',
        builder: (context, state) => const MatchGameScreen(),
      ),
      GoRoute(
        path: '/kanji-dash',
        builder: (context, state) => const KanjiDashScreen(),
      ),
      GoRoute(
        path: '/immersion',
        builder: (context, state) => const ImmersionHomeScreen(),
      ),
      // Enhanced Learn Mode with config screen
      GoRoute(
        path: '/lesson/:id/learn-enhanced',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final title = state.uri.queryParameters['title'] ?? 'Lesson';
          return LearnModeIntegration(lessonId: id ?? 1, lessonTitle: title);
        },
      ),
      // Enhanced Test Mode with config screen
      GoRoute(
        path: '/lesson/:id/test-enhanced',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final title = state.uri.queryParameters['title'] ?? 'Lesson';
          return TestModeIntegration(lessonId: id ?? 1, lessonTitle: title);
        },
      ),
      // Test History Screen
      GoRoute(
        path: '/lesson/:id/test-history',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final title = state.uri.queryParameters['title'] ?? 'Lesson';
          return TestHistoryScreen(lessonId: id ?? 1, lessonTitle: title);
        },
      ),
      // Write Mode (fillBlank only)
      GoRoute(
        path: '/lesson/:id/write-mode',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final title = state.uri.queryParameters['title'] ?? 'Lesson';
          return WriteModeIntegration(lessonId: id ?? 1, lessonTitle: title);
        },
      ),
      // Match Mode for lessons
      GoRoute(
        path: '/lesson/:id/match-mode',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final title = state.uri.queryParameters['title'] ?? 'Lesson';
          return LessonMatchScreen(lessonId: id ?? 1, lessonTitle: title);
        },
      ),
      GoRoute(
        path: '/mistakes',
        builder: (context, state) => const MistakeScreen(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/design-lab',
        builder: (context, state) => const DesignLabScreen(),
      ),
      GoRoute(
        path: '/practice/handwriting',
        builder: (context, state) => const HomeHandwritingPracticeScreen(),
      ),
      GoRoute(
        path: '/practice/mock-exam',
        builder: (context, state) => const HomeMockExamScreen(),
      ),
      GoRoute(
        path: '/learn/session',
        builder: (context, state) {
          final args = state.extra;
          if (args is LearnSessionArgs) {
            return LearnScreen(
              lessonId: args.lessonId,
              lessonTitle: args.lessonTitle,
              items: args.items,
              enabledTypes: args.enabledTypes,
            );
          }
          return const HomeScreen();
        },
      ),
    ],
  );
}
