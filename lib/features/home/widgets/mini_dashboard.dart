import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';
import '../../common/widgets/clay_card.dart';
import '../../../theme/app_theme_v2.dart';

class MiniDashboard extends ConsumerWidget {
  const MiniDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return dashboardAsync.when(
      data: (state) => _buildContent(context, state),
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(BuildContext context, DashboardState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClayCard(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              context,
              icon: Icons.local_fire_department_rounded,
              color: AppThemeV2.tertiary,
              value: '${state.streak}',
              label: 'Streak',
            ),
            _buildStatItem(
              context,
              icon: Icons.star_rounded,
              color: const Color(0xFFFFC800),
              value: '${state.todayXp}',
              label: 'XP',
            ),
            _buildStatItem(
              context,
              icon: Icons.school_rounded,
              color: AppThemeV2.primary,
              value: '${state.vocabDue + state.grammarDue}',
              label: 'Reviews',
            ),
            if (state.mistakeCount > 0)
              _buildStatItem(
                context,
                icon: Icons.error_outline_rounded,
                color: AppThemeV2.error,
                value: '${state.mistakeCount}',
                label: 'Mistakes',
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
