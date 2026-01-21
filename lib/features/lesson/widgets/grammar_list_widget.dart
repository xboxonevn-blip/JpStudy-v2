import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/data/db/app_database.dart';

class GrammarListWidget extends ConsumerWidget {
  const GrammarListWidget({
    super.key,
    required this.lessonId,
    required this.level,
    required this.language,
  });

  final int lessonId;
  final String level;
  final AppLanguage language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grammarAsync = ref.watch(
      lessonGrammarProvider(LessonTermsArgs(lessonId, level, '')),
    );

    return grammarAsync.when(
      data: (grammarList) {
        if (grammarList.isEmpty) {
          return Center(
            child: Text(
              language == AppLanguage.vi
                  ? 'Chưa có dữ liệu ngữ pháp.'
                  : 'No grammar data available.',
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: grammarList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final data = grammarList[index];
            return _GrammarPointCard(
              index: index + 1,
              data: data,
              language: language,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _GrammarPointCard extends StatelessWidget {
  const _GrammarPointCard({
    required this.index,
    required this.data,
    required this.language,
  });

  final int index;
  final GrammarPointData data;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final point = data.point;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Determine Display Values based on Language
    String title = point.grammarPoint;
    String structure = point.connection;
    String meaning = point.grammarPoint; // Fallback
    String explanation = '';

    switch (language) {
      case AppLanguage.vi:
        title = point.grammarPoint;
        meaning = point.meaningVi ?? point.meaning;
        explanation = point.explanationVi ?? point.explanation;
        break;
      case AppLanguage.en:
        title = point.titleEn ?? point.grammarPoint;
        structure = point.connectionEn ?? point.connection;
        meaning = point.meaningEn ?? point.meaning;
        explanation = point.explanationEn ?? point.explanation;
        break;
      case AppLanguage.ja:
        title = point.grammarPoint;
        explanation = point.connection; 
        break;
    }

    // Fallbacks
    if (explanation.isEmpty) explanation = point.explanation;

    // Clean up structure for display
    final displayStructure = language == AppLanguage.en 
        ? structure 
        : _formatStructure(structure, language);

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: const Border(), // Remove default borders
        collapsedShape: const Border(),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
             color: colorScheme.primaryContainer,
             borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '$index', 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: colorScheme.onPrimaryContainer,
                fontSize: 16,
              )
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildChip(
                  context, 
                  point.jlptLevel, 
                  colorScheme.tertiaryContainer, 
                  colorScheme.onTertiaryContainer
                ),
                const SizedBox(width: 8),
                if (point.isLearned)
                  _buildChip(
                    context, 
                    'Mastered', 
                    Colors.green.shade100, 
                    Colors.green.shade900
                  )
                else
                  _buildChip(
                    context, 
                    'New', 
                    colorScheme.secondaryContainer, 
                    colorScheme.onSecondaryContainer
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              language == AppLanguage.en ? title : _formatStructure(title, language),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
             meaning,
             style: theme.textTheme.bodyMedium?.copyWith(
               color: colorScheme.onSurfaceVariant,
               fontWeight: FontWeight.w500,
             ),
          ),
        ),
        children: [
          const Divider(height: 32),
          
          // Structure Section
          if (displayStructure.isNotEmpty) ...[
            _buildSectionHeader(context, 'Structure', Icons.account_tree_outlined),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Text(
                displayStructure,
                style: const TextStyle(
                  fontFamily: 'Courier', 
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Explanation Section
          _buildSectionHeader(context, 'Explanation', Icons.info_outline),
           const SizedBox(height: 8),
          Text(
            explanation,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),

          // Examples Section
          if (data.examples.isNotEmpty) ...[
             _buildSectionHeader(context, 'Examples', Icons.format_quote_rounded),
             const SizedBox(height: 12),
             ...data.examples.map((ex) => _buildExampleItem(context, ex, language)),
          ],

          // Action Section (Optional: Mark as learned if needed in future, hidden for now as it's implied by Lesson)
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildExampleItem(BuildContext context, GrammarExample ex, AppLanguage language) {
    String translation = '';
    switch (language) {
      case AppLanguage.vi:
        translation = ex.translationVi ?? ex.translation;
        break;
      case AppLanguage.en:
        translation = ex.translationEn ?? ex.translation;
        break;
      case AppLanguage.ja:
        translation = '';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
             ex.japanese,
             style: const TextStyle(
               fontSize: 16,
               fontWeight: FontWeight.w500,
             ),
           ),
           if (translation.isNotEmpty) ...[
             const SizedBox(height: 4),
             Text(
               translation,
               style: TextStyle(
                 fontSize: 14,
                 color: Theme.of(context).colorScheme.outline,
                 fontStyle: FontStyle.italic,
               ),
             ),
           ],
        ],
      ),
    );
  }

  String _formatStructure(String text, AppLanguage language) {
    if (language == AppLanguage.vi) return text;
    // Simple filter to keep it clean - logic remains similar but simplified regex for robustness
    // Only keeping characters, Basic punctuations, and Japanese characters
    // Removing parentheses content that looks localized if needed
    // For now, reusing the previous logic logic implicitly or simplified:
    return text.replaceAll(RegExp(r'\([^)]*[àáảãạăắằẳẵặâấầẩẫậèéẻẽẹêếềểễệìíỉĩịòóỏõọôốồổỗộơớờởỡợùúủũụưứừửữựỳýỷỹỵđĐ]+[^)]*\)'), '').trim();
  }
}
