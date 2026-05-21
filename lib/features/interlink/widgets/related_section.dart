import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_language.dart';
import '../../common/widgets/compact_ui.dart';
import '../models/interlink_graph.dart';
import '../providers/interlink_graph_provider.dart';

class RelatedSection extends ConsumerWidget {
  const RelatedSection({
    super.key,
    required this.nodeId,
    required this.language,
    this.onOpen,
    this.useFluidCard = true,
  }) : type = null,
       level = null,
       lookupId = null,
       label = null;

  const RelatedSection.lookup({
    super.key,
    required this.type,
    required this.level,
    required this.language,
    this.lookupId,
    this.label,
    this.onOpen,
    this.useFluidCard = true,
  }) : nodeId = null;

  final String? nodeId;
  final String? type;
  final String? level;
  final String? lookupId;
  final String? label;
  final AppLanguage language;
  final ValueChanged<InterlinkNode>? onOpen;
  final bool useFluidCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graphAsync = ref.watch(interlinkGraphProvider);
    return graphAsync.when(
      data: (graph) {
        final resolvedNodeId =
            nodeId ??
            graph
                .findNode(
                  type: type ?? '',
                  level: level ?? '',
                  id: lookupId,
                  label: label,
                )
                ?.id;
        if (resolvedNodeId == null) return const SizedBox.shrink();
        final sections = graph.relatedSections(resolvedNodeId);
        if (sections.isEmpty) return const SizedBox.shrink();
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _title(language),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            for (final section in sections) ...[
              Text(
                _sectionTitle(language, section.kind),
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              for (final item in section.items)
                _RelatedRow(item: item, onTap: () => _open(context, item.node)),
              const SizedBox(height: 12),
            ],
          ],
        );
        if (useFluidCard) {
          return AppSectionCard(
            padding: const EdgeInsets.all(16),
            child: content,
          );
        }
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: content,
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  void _open(BuildContext context, InterlinkNode node) {
    final callback = onOpen;
    if (callback != null) {
      callback(node);
      return;
    }
    GoRouter.maybeOf(context)?.go(node.route);
  }
}

class _RelatedRow extends StatelessWidget {
  const _RelatedRow({required this.item, required this.onTap});

  final InterlinkRelatedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.node.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              item.node.level,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

String _title(AppLanguage language) {
  return switch (language) {
    AppLanguage.en => 'Related',
    AppLanguage.vi => 'Liên quan',
    AppLanguage.ja => '関連',
  };
}

String _sectionTitle(AppLanguage language, RelatedSectionKind kind) {
  return switch (kind) {
    RelatedSectionKind.grammar => switch (language) {
      AppLanguage.en => 'Grammar using this item',
      AppLanguage.vi => 'Ngữ pháp dùng mục này',
      AppLanguage.ja => 'この項目を使う文法',
    },
    RelatedSectionKind.vocab => switch (language) {
      AppLanguage.en => 'Vocabulary containing this item',
      AppLanguage.vi => 'Từ vựng chứa mục này',
      AppLanguage.ja => 'この項目を含む語彙',
    },
    RelatedSectionKind.kanji => switch (language) {
      AppLanguage.en => 'Kanji in this item',
      AppLanguage.vi => 'Kanji trong mục này',
      AppLanguage.ja => 'この項目の漢字',
    },
    RelatedSectionKind.conjugation => switch (language) {
      AppLanguage.en => 'Related conjugation',
      AppLanguage.vi => 'Chia thể liên quan',
      AppLanguage.ja => '関連する活用',
    },
    RelatedSectionKind.reading => switch (language) {
      AppLanguage.en => 'Reading passages using this item',
      AppLanguage.vi => 'Bài đọc dùng mục này',
      AppLanguage.ja => 'この項目を使う読解',
    },
  };
}
