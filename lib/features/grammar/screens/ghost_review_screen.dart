import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_language.dart';
import '../../../core/language_provider.dart';
import '../../../data/repositories/lesson_repository.dart';
import 'ghost_practice_screen.dart';

class GhostReviewScreen extends ConsumerWidget {
  const GhostReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final ghostsAsync = ref.watch(grammarGhostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghost Reviews'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review grammar points you missed in previous tests.'),
                ),
              );
            },
          ),
        ],
      ),
      body: ghostsAsync.when(
        data: (ghosts) {
          if (ghosts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
                  const SizedBox(height: 16),
                  Text(
                    'No Ghosts!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You haven\'t missed any grammar points yet.\nKeep up the good work!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ghosts.length,
            itemBuilder: (context, index) {
              final data = ghosts[index];
              return _GhostCard(data: data, language: language);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: ghostsAsync.valueOrNull?.isNotEmpty == true
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => GhostPracticeScreen(ghosts: ghostsAsync.value!),
                ));
              },
              label: const Text('Practice Ghosts'),
              icon: const Icon(Icons.quiz),
            )
          : null,
    );
  }
}

class _GhostCard extends StatefulWidget {
  final GrammarPointData data;
  final AppLanguage language;

  const _GhostCard({required this.data, required this.language});

  @override
  State<_GhostCard> createState() => _GhostCardState();
}

class _GhostCardState extends State<_GhostCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final point = widget.data.point;
    final isVietnamese = widget.language == AppLanguage.vi;
    final title = isVietnamese ? point.meaningVi : point.titleEn ?? point.grammarPoint;
    final explanation = isVietnamese ? point.explanationVi : point.explanationEn;
    final connection = isVietnamese ? point.connection : point.connectionEn;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.science, size: 16, color: Colors.red),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      point.grammarPoint,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
              const SizedBox(height: 8),
              Text(title ?? '', style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
              if (_isExpanded) ...[
                const Divider(height: 24),
                Text('Structure:', style: Theme.of(context).textTheme.labelLarge),
                Text(connection ?? '', style: const TextStyle(fontFamily: 'Monospace')),
                const SizedBox(height: 12),
                Text('Explanation:', style: Theme.of(context).textTheme.labelLarge),
                Text(explanation ?? ''),
                const SizedBox(height: 12),
                Text('Examples:', style: Theme.of(context).textTheme.labelLarge),
                ...widget.data.examples.map((ex) => Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ${ex.japanese}', style: const TextStyle(fontWeight: FontWeight.w500)),
                          Text(
                            isVietnamese ? ex.translationVi ?? ex.translation : ex.translationEn ?? ex.translation,
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
