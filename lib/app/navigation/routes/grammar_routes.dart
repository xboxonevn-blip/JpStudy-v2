import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/app/navigation/app_route_builders.dart';
import 'package:jpstudy/features/conjugation/models/conjugation_practice_args.dart';
import 'package:jpstudy/features/conjugation/screens/conjugation_hub_screen.dart';
import 'package:jpstudy/features/conjugation/screens/conjugation_practice_screen.dart';
import 'package:jpstudy/features/grammar/grammar_screen.dart';
import 'package:jpstudy/features/grammar/screens/grammar_detail_screen.dart';

StatefulShellBranch buildGrammarBranch() {
  return StatefulShellBranch(routes: buildGrammarRoutes());
}

List<RouteBase> buildGrammarRoutes() {
  return [
    GoRoute(
      path: AppRoutePath.grammar,
      name: AppRouteName.grammar,
      builder: (context, state) => const GrammarScreen(),
    ),
    GoRoute(
      path: AppRoutePath.grammarPractice,
      name: AppRouteName.grammarPractice,
      builder: buildGrammarPracticeScreen,
    ),
    GoRoute(
      path: AppRoutePath.grammarConjugation,
      name: AppRouteName.grammarConjugation,
      builder: (context, state) => const ConjugationHubScreen(),
    ),
    GoRoute(
      path: AppRoutePath.grammarConjugationPractice,
      name: AppRouteName.grammarConjugationPractice,
      builder: (context, state) => ConjugationPracticeScreen(
        args: state.extra is ConjugationPracticeArgs
            ? state.extra as ConjugationPracticeArgs
            : const ConjugationPracticeArgs(),
      ),
    ),
    GoRoute(
      path: AppRoutePath.grammarConjugationWord,
      name: AppRouteName.grammarConjugationWord,
      builder: (context, state) => ConjugationHubScreen(
        contentVocabId: routeInt(state, 'contentVocabId'),
      ),
    ),
    GoRoute(
      path: AppRoutePath.grammarDetail,
      name: AppRouteName.grammarDetail,
      builder: (context, state) =>
          GrammarDetailScreen(grammarId: routeInt(state, 'id')),
    ),
  ];
}
