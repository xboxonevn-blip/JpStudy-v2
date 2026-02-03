import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/features/grammar/grammar_providers.dart';
import 'package:jpstudy/features/grammar/screens/grammar_practice_screen.dart';

import '../providers/dashboard_provider.dart';

class PracticeHub extends ConsumerWidget {
  const PracticeHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final ghostCount = ref
        .watch(grammarGhostCountProvider)
        .maybeWhen(data: (count) => count, orElse: () => 0);
    final dashboard = ref.watch(dashboardProvider).valueOrNull;
    final mistakeCount = dashboard?.totalMistakeCount ?? 0;

    final tiles = <_PracticeTileData>[
      _PracticeTileData(
        title: language.practiceMatchLabel,
        subtitle: language.practiceMatchSubtitle,
        icon: Icons.extension_rounded,
        color: const Color(0xFF0EA5E9),
        onTap: () => context.push('/match'),
      ),
      _PracticeTileData(
        title: language.practiceGhostLabel,
        subtitle: language.practiceGhostSubtitle,
        icon: Icons.auto_fix_high_rounded,
        color: const Color(0xFFF43F5E),
        badgeCount: ghostCount > 0 ? ghostCount : null,
        onTap: () =>
            context.push('/grammar-practice', extra: GrammarPracticeMode.ghost),
      ),
      _PracticeTileData(
        title: language.practiceKanjiDashLabel,
        subtitle: language.practiceKanjiDashSubtitle,
        icon: Icons.flash_on_rounded,
        color: const Color(0xFFF59E0B),
        onTap: () => context.push('/kanji-dash'),
      ),
      _PracticeTileData(
        title: language.practiceExamLabel,
        subtitle: language.practiceExamSubtitle,
        icon: Icons.quiz_rounded,
        color: const Color(0xFF14B8A6),
        onTap: () => context.push('/exam'),
      ),
      _PracticeTileData(
        title: language.practiceImmersionLabel,
        subtitle: language.practiceImmersionSubtitle,
        icon: Icons.newspaper_rounded,
        color: const Color(0xFF2563EB),
        onTap: () => context.push('/immersion'),
      ),
      _PracticeTileData(
        title: language.practiceMistakesLabel,
        subtitle: language.practiceMistakesSubtitle,
        icon: Icons.warning_amber_rounded,
        color: const Color(0xFFDC2626),
        badgeCount: mistakeCount > 0 ? mistakeCount : null,
        onTap: () => context.push('/mistakes'),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF6FBFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFDCE8F8)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F2B3F59),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE0F2FE), Color(0xFFDCFCE7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.rocket_launch_rounded,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          language.practiceHubTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          language.practiceHubSubtitle,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 1080
                      ? 3
                      : constraints.maxWidth >= 600
                      ? 2
                      : 2;
                  final aspectRatio = constraints.maxWidth < 420 ? 1.05 : 1.3;
                  return GridView.builder(
                    itemCount: tiles.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: aspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final item = tiles[index];
                      return _PracticeTile(item: item);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeTileData {
  const _PracticeTileData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.badgeCount,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int? badgeCount;
}

class _PracticeTile extends StatelessWidget {
  const _PracticeTile({required this.item});

  final _PracticeTileData item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F5)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x09283A57),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: item.color, size: 20),
                  ),
                  const Spacer(),
                  if (item.badgeCount != null && item.badgeCount! > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${item.badgeCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
