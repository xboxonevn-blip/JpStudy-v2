import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/core/gamification/level_calculator.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

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
    return Row(
      children: [
        _HeaderLeft(
          level: level,
          language: language,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Center(
            child: level == null
                ? const SizedBox.shrink()
                : _LevelSegmented(
                    value: level!,
                    onChanged: onLevelChanged,
                  ),
          ),
        ),
        const SizedBox(width: 16),
        _HeaderRight(
          language: language,
          onLanguageTap: onLanguageTap,
          onSettingsTap: onSettingsTap,
        ),
      ],
    );
  }
}

class _HeaderLeft extends StatelessWidget {
  const _HeaderLeft({
    required this.level,
    required this.language,
  });

  final StudyLevel? level;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'JpStudy',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        const SizedBox(width: 10),
        if (level != null)
          _BreadcrumbChip(label: level!.shortLabel)
        else
          _BreadcrumbChip(label: language.filterAllLabel),
      ],
    );
  }
}

class _BreadcrumbChip extends StatelessWidget {
  const _BreadcrumbChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E6F0)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}

class _LevelSegmented extends StatelessWidget {
  const _LevelSegmented({
    required this.value,
    required this.onChanged,
  });

  final StudyLevel value;
  final ValueChanged<StudyLevel> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<StudyLevel>(
      segments: const [
        ButtonSegment(value: StudyLevel.n5, label: Text('N5')),
        ButtonSegment(value: StudyLevel.n4, label: Text('N4')),
        ButtonSegment(value: StudyLevel.n3, label: Text('N3')),
      ],
      selected: {value},
      onSelectionChanged: (selection) {
        if (selection.isNotEmpty) {
          onChanged(selection.first);
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFFEFF2FF);
          }
          return const Color(0xFFF7F9FC);
        }),
        side: WidgetStateProperty.all(
          const BorderSide(color: Color(0xFFE1E6F0)),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _HeaderRight extends ConsumerWidget {
  const _HeaderRight({
    required this.language,
    required this.onLanguageTap,
    required this.onSettingsTap,
  });

  final AppLanguage language;
  final VoidCallback onLanguageTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressSummaryProvider);
    final totalXp = progressAsync.asData?.value.totalXp ?? 0;
    final levelInfo = LevelCalculator.calculate(totalXp);

    return Row(
      children: [
        _LanguageChip(
          language: language,
          onTap: onLanguageTap,
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onSettingsTap,
          icon: const Icon(Icons.settings_outlined),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: '${levelInfo.currentXp} / ${levelInfo.nextLevelXp} XP',
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEFF2FF),
              border: Border.all(color: const Color(0xFFD6DDFF), width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: levelInfo.progress,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF6366F1)),
                  strokeWidth: 3,
                ),
                Text(
                  '${levelInfo.level}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.language,
    required this.onTap,
  });

  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF2FF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFD6DDFF)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 16),
            const SizedBox(width: 6),
            Text(
              language.shortCode,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
