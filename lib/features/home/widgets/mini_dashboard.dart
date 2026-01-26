import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';
import '../../grammar/grammar_providers.dart';
import '../../../theme/app_theme_v2.dart';
import '../../../core/language_provider.dart';
import '../../../core/app_language.dart';

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
      data: (state) => _buildContent(context, state, language, ghostCount),
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DashboardState state,
    AppLanguage language,
    int ghostCount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF64748B).withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: 16,
          runSpacing: 12,
          children: [
            _buildStatItem(
              context,
              icon: Icons.local_fire_department_rounded,
              color: AppThemeV2.tertiary,
              value: '${state.streak}',
              label: language.streakLabel,
            ),
            _buildStatItem(
              context,
              icon: Icons.star_rounded,
              color: const Color(0xFFFFC800),
              value: '${state.todayXp}',
              label: language.xpLabel,
            ),
            _buildStatItem(
              context,
              icon: Icons.school_rounded,
              color: AppThemeV2.primary,
              value: '${state.vocabDue + state.grammarDue + state.kanjiDue}',
              label: language.reviewsLabel,
            ),
            if (state.totalMistakeCount > 0)
              _buildStatItem(
                context,
                icon: Icons.error_outline_rounded,
                color: AppThemeV2.error,
                value: '${state.totalMistakeCount}',
                label: language.mistakesLabel,
              ),
            if (ghostCount > 0)
              _buildStatItem(
                context,
                icon: Icons.auto_fix_high_rounded,
                color: const Color(0xFF7C3AED),
                value: '$ghostCount',
                label: language.ghostReviewsLabel,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppThemeV2.textMain,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppThemeV2.textSub,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
