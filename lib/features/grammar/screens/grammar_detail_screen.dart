import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/grammar_repository.dart';
import '../../../data/db/app_database.dart';
import '../widgets/grammar_example_widget.dart';

class GrammarDetailScreen extends ConsumerStatefulWidget {
  final int grammarId;

  const GrammarDetailScreen({super.key, required this.grammarId});

  @override
  ConsumerState<GrammarDetailScreen> createState() =>
      _GrammarDetailScreenState();
}

class _GrammarDetailScreenState extends ConsumerState<GrammarDetailScreen> {
  bool _showVietnamese = true; // Default to showing VI if available

  @override
  Widget build(BuildContext context) {
    final grammarAsync = ref.watch(grammarDetailProvider(widget.grammarId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grammar Point'),
        actions: [
          IconButton(
            icon: Icon(_showVietnamese ? Icons.language : Icons.translate),
            tooltip: 'Toggle Language',
            onPressed: () {
              setState(() {
                _showVietnamese = !_showVietnamese;
              });
            },
          ),
        ],
      ),
      body: grammarAsync.when(
        data: (data) {
          if (data == null) {
            return const Center(child: Text('Grammar point not found'));
          }
          final point = data.point;
          final examples = data.examples;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(point),
                const SizedBox(height: 24),
                _buildSectionTitle('Connection / Cấu trúc'),
                const SizedBox(height: 8),
                Text(
                  point.connection,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'RobotoMono',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Explanation / Giải thích'),
                const SizedBox(height: 8),
                _buildExplanation(point),
                const SizedBox(height: 24),
                _buildSectionTitle('Examples / Ví dụ'),
                const SizedBox(height: 8),
                _buildExamples(examples),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: grammarAsync.when(
        data: (data) {
          if (data == null || data.point.isLearned) return null;
          return FloatingActionButton.extended(
            onPressed: () async {
              await ref
                  .read(grammarRepositoryProvider)
                  .markAsLearned(widget.grammarId);
              // Refresh provider
              ref.invalidate(grammarDetailProvider(widget.grammarId));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to your review list!')),
                );
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Mark Learned'),
          );
        },
        loading: () => null,
        error: (_, _) => null,
      ),
    );
  }

  Widget _buildHeader(GrammarPoint point) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                point.jlptLevel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                point.grammarPoint,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _showVietnamese ? (point.meaningVi ?? point.meaning) : point.meaning,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildExplanation(GrammarPoint point) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_showVietnamese || point.explanationVi == null)
            Text(point.explanation),

          if (_showVietnamese && point.explanationVi != null) ...[
            if (!_showVietnamese) const Divider(height: 24),
            Text(point.explanationVi!),
          ],
        ],
      ),
    );
  }

  Widget _buildExamples(List<GrammarExample> examples) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: examples.length,
      separatorBuilder: (context, index) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final ex = examples[index];
        return GrammarExampleWidget(
          japanese: ex.japanese,
          translation: ex.translation,
          translationVi: ex.translationVi,
          showVietnamese: _showVietnamese,
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.tertiary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}

final grammarDetailProvider =
    FutureProvider.family<
      ({GrammarPoint point, List<GrammarExample> examples})?,
      int
    >((ref, id) {
      final repo = ref.watch(grammarRepositoryProvider);
      return repo.getGrammarDetail(id);
    });
