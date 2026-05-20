import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/app/theme/app_spacing.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/features/common/widgets/compact_ui.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_practice_args.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_relationship_graph.dart';
import 'package:jpstudy/features/kanji_hub/providers/kanji_relationship_graph_provider.dart';
import 'package:jpstudy/features/kanji_hub/widgets/kanji_relationship_graph.dart';

class KanjiRelationshipGraphScreen extends ConsumerWidget {
  const KanjiRelationshipGraphScreen({super.key, required this.character});

  final String character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final decodedCharacter = _decodeRouteCharacter(character);
    final graphAsync = ref.watch(
      kanjiRelationshipGraphProvider(decodedCharacter),
    );

    return Scaffold(
      appBar: AppBar(title: Text(_title(language, decodedCharacter))),
      body: AppPageShell(
        topPadding: AppSpacing.md,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppFeatureCard(
              key: const ValueKey('kanji_graph_header'),
              icon: Icons.hub_rounded,
              title: _title(language, decodedCharacter),
              subtitle: _subtitle(language),
              primaryLabel: _backLabel(language),
              onPrimaryTap: () => context.go(AppRoutePath.kanji),
              compact: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 560,
              child: graphAsync.when(
                data: (graphData) => KanjiRelationshipGraph(
                  graphData: graphData,
                  language: language,
                  onNodeSelected: (nextCharacter) {
                    context.go(
                      '/kanji/${Uri.encodeComponent(nextCharacter)}/graph',
                    );
                  },
                  onPracticeCluster: () =>
                      _openClusterPractice(context, graphData),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, stackTrace) => AppFeatureCard(
                  key: const ValueKey('kanji_graph_error'),
                  icon: Icons.error_outline_rounded,
                  title: _errorTitle(language),
                  subtitle: _errorSubtitle(language),
                  primaryLabel: _retryLabel(language),
                  onPrimaryTap: () => ref.invalidate(
                    kanjiRelationshipGraphProvider(decodedCharacter),
                  ),
                  compact: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openClusterPractice(
    BuildContext context,
    KanjiRelationshipGraphData graphData,
  ) {
    final ids = <int>{
      for (final node in graphData.nodes)
        if (node.item != null) node.item!.id,
    }.toList();
    final characters = <String>{
      for (final node in graphData.nodes)
        if (node.item != null) node.character,
    }.toList();
    if (ids.isEmpty && characters.isEmpty) return;
    context.push(
      AppRoutePath.kanjiPractice,
      extra: KanjiPracticeArgs(
        mode: KanjiPracticeMode.both,
        source: 'graph_cluster',
        levelCode: graphData.focus.item?.jlptLevel,
        kanjiIds: ids,
        kanjiCharacters: characters,
        preferredKanjiId: graphData.focus.item?.id ?? ids.first,
        preferredKanjiCharacter: graphData.focus.character,
      ),
    );
  }

  String _title(AppLanguage language, String character) => switch (language) {
    AppLanguage.vi => 'Mạng kanji $character',
    AppLanguage.en => '$character relationship graph',
    AppLanguage.ja => '$character 関連グラフ',
  };

  String _subtitle(AppLanguage language) => switch (language) {
    AppLanguage.vi =>
      'Xem thành phần cấu tạo, kanji liên quan, rồi luyện cả cụm trong một lượt.',
    AppLanguage.en =>
      'Explore components and related kanji, then practice the visible cluster.',
    AppLanguage.ja => '構成要素と関連漢字を確認し、このグループをまとめて練習します。',
  };

  String _backLabel(AppLanguage language) => switch (language) {
    AppLanguage.vi => 'Quay về Kanji',
    AppLanguage.en => 'Back to Kanji',
    AppLanguage.ja => '漢字へ戻る',
  };

  String _errorTitle(AppLanguage language) => switch (language) {
    AppLanguage.vi => 'Chưa tải được mạng kanji',
    AppLanguage.en => 'Could not load the graph',
    AppLanguage.ja => 'グラフを読み込めません',
  };

  String _errorSubtitle(AppLanguage language) => switch (language) {
    AppLanguage.vi => 'Thử tải lại hoặc quay về màn Kanji để chọn chữ khác.',
    AppLanguage.en => 'Try again or return to Kanji and choose another item.',
    AppLanguage.ja => '再読み込みするか、漢字画面で別の字を選んでください。',
  };

  String _retryLabel(AppLanguage language) => switch (language) {
    AppLanguage.vi => 'Tải lại',
    AppLanguage.en => 'Retry',
    AppLanguage.ja => '再読み込み',
  };
}

String _decodeRouteCharacter(String character) {
  final trimmed = character.trim();
  if (!trimmed.contains('%')) return trimmed;
  return Uri.decodeComponent(trimmed).trim();
}
