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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language.practiceHubTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            language.practiceHubSubtitle,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7390)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _PracticeTile(
                title: language.practiceMatchLabel,
                subtitle: language.practiceMatchSubtitle,
                icon: Icons.extension_rounded,
                color: const Color(0xFF2563EB),
                onTap: () => context.push('/match'),
              ),
              _PracticeTile(
                title: language.practiceGhostLabel,
                subtitle: language.practiceGhostSubtitle,
                icon: Icons.auto_fix_high_rounded,
                color: const Color(0xFF7C3AED),
                badgeCount: ghostCount > 0 ? ghostCount : null,
                onTap: () => context.push(
                  '/grammar-practice',
                  extra: GrammarPracticeMode.ghost,
                ),
              ),
              _PracticeTile(
                title: language.practiceKanjiDashLabel,
                subtitle: language.practiceKanjiDashSubtitle,
                icon: Icons.flash_on_rounded,
                color: const Color(0xFFF59E0B),
                onTap: () => context.push('/kanji-dash'),
              ),
              _PracticeTile(
                title: language.practiceExamLabel,
                subtitle: language.practiceExamSubtitle,
                icon: Icons.quiz_rounded,
                color: const Color(0xFF8B5CF6),
                onTap: () => context.push('/exam'),
              ),
              _PracticeTile(
                title: language.practiceImmersionLabel,
                subtitle: language.practiceImmersionSubtitle,
                icon: Icons.newspaper_rounded,
                color: const Color(0xFF10B981),
                onTap: () => context.push('/immersion'),
              ),
              _PracticeTile(
                title: language.practiceMistakesLabel,
                subtitle: language.practiceMistakesSubtitle,
                icon: Icons.warning_amber_rounded,
                color: const Color(0xFFEF4444),
                badgeCount: mistakeCount > 0 ? mistakeCount : null,
                onTap: () => context.push('/mistakes'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PracticeTile extends StatelessWidget {
  const _PracticeTile({
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE8ECF5)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A2E3A59),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                if (badgeCount != null && badgeCount! > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7390)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
