import '../models/interlink_graph.dart';

enum RecommendationType { srsDue, nextLesson, related, fallback }

class LearningRecommendation {
  const LearningRecommendation({
    required this.type,
    required this.label,
    required this.route,
    required this.score,
    this.node,
    this.reason,
  });

  final RecommendationType type;
  final String label;
  final String route;
  final double score;
  final InterlinkNode? node;
  final String? reason;
}

class RecommendationEngine {
  const RecommendationEngine();

  List<LearningRecommendation> afterLessonComplete({
    required InterlinkGraph graph,
    required Iterable<String> learnedNodeIds,
    required Set<String> dueNodeIds,
    String? nextLessonLabel,
    String? nextLessonRoute,
    int maxCount = 3,
  }) {
    final candidates = <LearningRecommendation>[];

    for (final nodeId in learnedNodeIds.toSet()) {
      for (final related in graph.related(nodeId, limit: 40)) {
        final isDue = dueNodeIds.contains(related.node.id);
        candidates.add(
          LearningRecommendation(
            type: isDue ? RecommendationType.srsDue : RecommendationType.related,
            label: related.node.label,
            route: related.node.route,
            score: (isDue ? 100 : 40) + related.weight,
            node: related.node,
            reason: related.rel,
          ),
        );
      }
    }

    if (nextLessonLabel != null &&
        nextLessonLabel.trim().isNotEmpty &&
        nextLessonRoute != null &&
        nextLessonRoute.trim().isNotEmpty) {
      candidates.add(
        LearningRecommendation(
          type: RecommendationType.nextLesson,
          label: nextLessonLabel,
          route: nextLessonRoute,
          score: 80,
        ),
      );
    }

    candidates.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return a.route.compareTo(b.route);
    });

    final selected = <LearningRecommendation>[];
    final routes = <String>{};
    for (final candidate in candidates) {
      if (routes.add(candidate.route)) {
        selected.add(candidate);
      }
      if (selected.length == maxCount) return selected;
    }

    for (final fallback in _fallbacks()) {
      if (routes.add(fallback.route)) {
        selected.add(fallback);
      }
      if (selected.length == maxCount) break;
    }
    return selected;
  }

  List<LearningRecommendation> _fallbacks() => const [
    LearningRecommendation(
      type: RecommendationType.fallback,
      label: '',
      route: '/review',
      score: 10,
    ),
    LearningRecommendation(
      type: RecommendationType.fallback,
      label: '',
      route: '/immersion',
      score: 9,
    ),
    LearningRecommendation(
      type: RecommendationType.fallback,
      label: '',
      route: '/kanji/practice',
      score: 8,
    ),
  ];
}
