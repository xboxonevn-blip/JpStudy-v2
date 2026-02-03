import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_language.dart';
import '../../../core/language_provider.dart';
import '../../grammar/grammar_providers.dart';
import '../providers/dashboard_provider.dart';

class MiniDashboard extends ConsumerWidget {
  const MiniDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final language = ref.watch(appLanguageProvider);
    final ghostCount = ref
        .watch(grammarGhostCountProvider)
        .maybeWhen(data: (count) => count, orElse: () => 0);

    return dashboardAsync.when(
      data: (state) => _buildContent(state, language, ghostCount),
      loading: () => const SizedBox(
        height: 88,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(
    DashboardState state,
    AppLanguage language,
    int ghostCount,
  ) {
    final totalDue = state.vocabDue + state.grammarDue + state.kanjiDue;
    final extraBadges = <Widget>[];
    if (state.totalMistakeCount > 0) {
      extraBadges.add(
        _tinyBadge(Icons.warning_amber_rounded, '${state.totalMistakeCount}'),
      );
    }
    if (ghostCount > 0) {
      extraBadges.add(_tinyBadge(Icons.auto_fix_high_rounded, '$ghostCount'));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 760;
          return Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE1E8F4)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F24324D),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            language.progressTitle,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            language.continueJourneyLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF1F5FF),
                        border: Border.all(color: const Color(0xFFD9E1F2)),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (isWide)
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: const Color(0xFFF97316),
                          value: '${state.streak}',
                          suffix: language.streakLabel.toUpperCase(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.star_rounded,
                          iconColor: const Color(0xFF7C3AED),
                          value: '${state.todayXp}',
                          suffix: language.xpLabel.toUpperCase(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.school_rounded,
                          iconColor: const Color(0xFF2563EB),
                          value: '$totalDue',
                          suffix: '${language.reviewsLabel.toUpperCase()} DUE',
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _StatTile(
                        icon: Icons.local_fire_department_rounded,
                        iconColor: const Color(0xFFF97316),
                        value: '${state.streak}',
                        suffix: language.streakLabel.toUpperCase(),
                      ),
                      const SizedBox(height: 8),
                      _StatTile(
                        icon: Icons.star_rounded,
                        iconColor: const Color(0xFF7C3AED),
                        value: '${state.todayXp}',
                        suffix: language.xpLabel.toUpperCase(),
                      ),
                      const SizedBox(height: 8),
                      _StatTile(
                        icon: Icons.school_rounded,
                        iconColor: const Color(0xFF2563EB),
                        value: '$totalDue',
                        suffix: '${language.reviewsLabel.toUpperCase()} DUE',
                      ),
                    ],
                  ),
                if (extraBadges.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: extraBadges,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tinyBadge(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF475569)),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.suffix,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF6)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(alpha: 0.12),
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  suffix,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
