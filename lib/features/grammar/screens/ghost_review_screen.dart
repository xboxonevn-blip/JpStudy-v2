import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_language.dart';
import '../../../core/language_provider.dart';
import '../../../data/db/app_database.dart';
import '../../../features/grammar/grammar_providers.dart';
import '../../../theme/app_theme_v2.dart';
import '../../common/widgets/clay_card.dart';
import '../models/grammar_point_data.dart';
import 'ghost_practice_screen.dart';

class GhostReviewScreen extends ConsumerWidget {
  const GhostReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final ghostsAsync = ref.watch(grammarGhostsProvider);

    return Scaffold(
      backgroundColor: AppThemeV2.surface,
      appBar: AppBar(
        title: const Text('Ghost Reviews', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppThemeV2.textMain,
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
                   // Placeholder for Mascot
                  const Icon(Icons.check_circle_outline, size: 80, color: AppThemeV2.primary),
                  const SizedBox(height: 16),
                  Text(
                    'No Ghosts!',
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                      color: AppThemeV2.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You haven\'t missed any grammar points yet.\nKeep up the good work!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppThemeV2.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
            itemCount: ghosts.length,
            itemBuilder: (context, index) {
              final data = ghosts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _GhostClayCard(data: data, language: language),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: ghostsAsync.valueOrNull?.isNotEmpty == true
          ? Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: FloatingActionButton.extended(
                backgroundColor: AppThemeV2.primary,
                foregroundColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => GhostPracticeScreen(ghosts: ghostsAsync.value!),
                  ));
                },
                label: const Text('Practice Ghosts', style: TextStyle(fontWeight: FontWeight.bold)),
                icon: const Icon(Icons.videogame_asset),
              ),
            )
          : null,
    );
  }
}

class _GhostClayCard extends StatefulWidget {
  final GrammarPointData data;
  final AppLanguage language;

  const _GhostClayCard({required this.data, required this.language});

  @override
  State<_GhostClayCard> createState() => _GhostClayCardState();
}

class _GhostClayCardState extends State<_GhostClayCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final point = widget.data.point;
    final isVietnamese = widget.language == AppLanguage.vi;
    final title = isVietnamese ? point.meaningVi : point.titleEn ?? point.grammarPoint;
    final explanation = isVietnamese ? point.explanationVi : point.explanationEn;
    final connection = isVietnamese ? point.connection : point.connectionEn;

    return ClayCard(
      color: Colors.white,
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.pest_control, size: 24, color: Colors.red), // Fixed Icon
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      point.grammarPoint,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppThemeV2.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title ?? '', 
                      style: const TextStyle(fontSize: 14, color: AppThemeV2.textSub),
                    ),
                  ],
                ),
              ),
              Icon(
                _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                color: AppThemeV2.textSub,
              ),
            ],
          ),
          
          if (_isExpanded) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            _buildLabel('Connection'),
            Text(connection ?? '', style: const TextStyle(fontFamily: 'Monospace', color: AppThemeV2.textMain)),
            const SizedBox(height: 16),
            _buildLabel('Explanation'),
            Text(explanation ?? '', style: const TextStyle(color: AppThemeV2.textMain, height: 1.4)),
            const SizedBox(height: 16),
            _buildLabel('Examples'),
            ...widget.data.examples.map((ex) => Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppThemeV2.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ex.japanese, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(
                          isVietnamese ? ex.translationVi ?? ex.translation : ex.translationEn ?? ex.translation,
                          style: TextStyle(fontSize: 13, color: AppThemeV2.textSub),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppThemeV2.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
