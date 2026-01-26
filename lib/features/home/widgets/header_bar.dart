import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/study_level.dart';

import '../providers/dashboard_provider.dart';

import '../../../theme/app_theme_v2.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({
    super.key,
    required this.level,
    required this.language,
    required this.onLanguageTap,
    required this.onLevelChanged,
    required this.onSettingsTap,
  });

  final StudyLevel? level;
  final AppLanguage language;
  final VoidCallback onLanguageTap;
  final ValueChanged<StudyLevel> onLevelChanged;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    // Glassmorphism Container
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white.withValues(alpha: 0.7)
                : Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _HeaderStats(level: level, language: language),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onSettingsTap,
                icon: const Icon(Icons.settings, color: AppThemeV2.textSub),
                tooltip: language.settingsLabel,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 8),
              _ProfileAvatar(onTap: onSettingsTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderStats extends ConsumerWidget {
  const _HeaderStats({required this.level, required this.language});

  final StudyLevel? level;
  final AppLanguage language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final stats = dashboardAsync.asData?.value;

    final streak = stats?.streak ?? 0;
    final xp = stats?.todayXp ?? 0;
    // Reviews = Vocab Due + Grammar Due
    final reviews = (stats?.vocabDue ?? 0) + (stats?.grammarDue ?? 0);

    // If loading, show zeros or skeleton? 0s for now.

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Streak
        _StatCapsule(
          icon: Icons.local_fire_department_rounded,
          color: Colors.orange,
          label: streak.toString(),
        ),
        const SizedBox(width: 8),
        // XP
        _StatCapsule(
          icon: Icons.bolt_rounded,
          color: Colors.amber,
          label: xp.toString(),
        ),
        const SizedBox(width: 8),
        // Reviews (NEW) - Only show if there are reviews? Or always?
        // User asked to "show reviews again".
        _StatCapsule(
          icon: Icons.history_edu_rounded,
          color: Colors.blueAccent,
          label: reviews.toString(),
          showPlus: reviews > 99, // e.g. 100+
        ),
        const SizedBox(width: 8),
        // Level Indicator
        if (level != null) _LevelBadge(label: level!.shortLabel),
      ],
    );
  }
}

class _StatCapsule extends StatelessWidget {
  const _StatCapsule({
    required this.icon,
    required this.color,
    required this.label,
    this.showPlus = false,
  });

  final IconData icon;
  final Color color;
  final String label;
  final bool showPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            showPlus ? '$label+' : label,
            style: TextStyle(
              color: const Color(0xFF1F2937),
              fontWeight: FontWeight.w700,
              fontSize: 13,
              fontFamily: 'Outfit',
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: AppThemeV2.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppThemeV2.indigo600.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final VoidCallback onTap;

  const _ProfileAvatar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppThemeV2.surface,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.person, color: AppThemeV2.textSub, size: 20),
        ),
      ),
    );
  }
}
