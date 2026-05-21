import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_locations.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/features/learn/models/learn_session.dart';

import '../../common/widgets/compact_ui.dart';
import '../models/interlink_graph.dart';
import '../providers/interlink_graph_provider.dart';
import '../services/recommendation_engine.dart';

class LessonCompletionRecommendations extends ConsumerWidget {
  const LessonCompletionRecommendations({super.key, required this.session});

  final LearnSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final graphAsync = ref.watch(interlinkGraphProvider);
    return graphAsync.when(
      data: (graph) {
        final recommendations = _buildRecommendations(graph, language);
        if (recommendations.isEmpty) return const SizedBox.shrink();
        return AppSectionCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _title(language),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              for (final item in recommendations)
                _RecommendationTile(
                  item: item,
                  language: language,
                  onTap: () => GoRouter.maybeOf(context)?.go(item.route),
                ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  List<LearningRecommendation> _buildRecommendations(
    InterlinkGraph graph,
    AppLanguage language,
  ) {
    final learned = <String>{};
    final weak = <String>{};
    for (final question in session.questions) {
      final item = question.targetItem;
      final node = graph.findNode(
        type: 'vocab',
        level: item.level,
        id: 'vocab:${item.level.toLowerCase()}:${item.term}',
        label: item.term,
      );
      if (node == null) continue;
      learned.add(node.id);
      if (session.weakTermIds.contains(item.id)) {
        weak.add(node.id);
        for (final related in graph.related(node.id, limit: 12)) {
          weak.add(related.node.id);
        }
      }
    }

    final level = session.questions.isEmpty
        ? null
        : session.questions.first.targetItem.level;
    final nextLessonId = session.lessonId + 1;
    return const RecommendationEngine().afterLessonComplete(
      graph: graph,
      learnedNodeIds: learned,
      dueNodeIds: weak,
      nextLessonLabel: _nextLessonLabel(language),
      nextLessonRoute: level == null
          ? AppRouteLocation.lessonDetail(nextLessonId)
          : AppRouteLocation.lessonDetail(nextLessonId, levelCode: level),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({
    required this.item,
    required this.language,
    required this.onTap,
  });

  final LearningRecommendation item;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final color = switch (item.type) {
      RecommendationType.srsDue => palette.error,
      RecommendationType.nextLesson => palette.primary,
      RecommendationType.related => palette.info,
      RecommendationType.fallback => palette.success,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: color.withValues(alpha: 0.25)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(_icon(item.type), color: color, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayLabel(language, item),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        _subtitle(language, item.type),
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.ink.withValues(alpha: 0.58),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _title(AppLanguage language) {
  return switch (language) {
    AppLanguage.en => 'Recommended after this lesson',
    AppLanguage.vi => 'Gợi ý sau bài này',
    AppLanguage.ja => 'このレッスン後のおすすめ',
  };
}

String _nextLessonLabel(AppLanguage language) {
  return switch (language) {
    AppLanguage.en => 'Next lesson',
    AppLanguage.vi => 'Bài kế tiếp',
    AppLanguage.ja => '次のレッスン',
  };
}

String _displayLabel(AppLanguage language, LearningRecommendation item) {
  if (item.type != RecommendationType.fallback) return item.label;
  return switch (item.route) {
    '/review' => switch (language) {
      AppLanguage.en => 'Review due items',
      AppLanguage.vi => 'Ôn mục đến hạn',
      AppLanguage.ja => '期限レビュー',
    },
    '/immersion' => switch (language) {
      AppLanguage.en => 'Read a short passage',
      AppLanguage.vi => 'Đọc một đoạn ngắn',
      AppLanguage.ja => '短い読解を読む',
    },
    '/kanji/practice' => switch (language) {
      AppLanguage.en => 'Practice kanji',
      AppLanguage.vi => 'Luyện kanji',
      AppLanguage.ja => '漢字を練習',
    },
    _ => item.label,
  };
}

String _subtitle(AppLanguage language, RecommendationType type) {
  return switch (type) {
    RecommendationType.srsDue => switch (language) {
      AppLanguage.en => 'Due now from this lesson cluster',
      AppLanguage.vi => 'Đến hạn từ cụm vừa học',
      AppLanguage.ja => 'この学習クラスタから期限到来',
    },
    RecommendationType.nextLesson => switch (language) {
      AppLanguage.en => 'Continue the textbook path',
      AppLanguage.vi => 'Đi tiếp lộ trình giáo trình',
      AppLanguage.ja => '教材ルートを続ける',
    },
    RecommendationType.related => switch (language) {
      AppLanguage.en => 'Linked by the curriculum graph',
      AppLanguage.vi => 'Liên kết bởi graph nội dung',
      AppLanguage.ja => 'カリキュラムグラフで関連',
    },
    RecommendationType.fallback => switch (language) {
      AppLanguage.en => 'Useful next action',
      AppLanguage.vi => 'Bước học tiếp theo',
      AppLanguage.ja => '次に役立つ行動',
    },
  };
}

IconData _icon(RecommendationType type) {
  return switch (type) {
    RecommendationType.srsDue => Icons.schedule_rounded,
    RecommendationType.nextLesson => Icons.arrow_circle_right_rounded,
    RecommendationType.related => Icons.account_tree_rounded,
    RecommendationType.fallback => Icons.auto_awesome_rounded,
  };
}
