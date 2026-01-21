import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';

class MiniDashboard extends ConsumerWidget {
  const MiniDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return dashboardAsync.when(
      data: (state) => _buildContent(context, state),
      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(BuildContext context, DashboardState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                context,
                icon: Icons.local_fire_department_rounded,
                color: Colors.orange,
                value: '${state.streak}',
                label: 'Streak',
              ),
              _buildVerticalDivider(context),
              _buildStatItem(
                context,
                icon: Icons.star_rounded,
                color: Colors.amber,
                value: '${state.todayXp}',
                label: 'Today XP',
              ),
              _buildVerticalDivider(context),
              _buildStatItem(
                context,
                icon: Icons.school_rounded,
                color: Colors.blue,
                value: '${state.vocabDue + state.grammarDue}',
                label: 'Reviews',
              ),
              if (state.mistakeCount > 0) ...[
                _buildVerticalDivider(context),
                 _buildStatItem(
                  context,
                  icon: Icons.error_outline_rounded,
                  color: Colors.redAccent,
                  value: '${state.mistakeCount}',
                  label: 'Mistakes',
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Container(
      height: 32,
      width: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
