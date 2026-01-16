import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/study_level.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(studyLevelProvider);
    final language = ref.watch(appLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: _AppTitle(
          language: language,
          onLanguageTap: () => _showLanguageSheet(context, ref),
        ),
        actions: level == null
            ? null
            : [
                _LevelAction(
                  label: level.shortLabel,
                  onTap: () => _showLevelSheet(context, ref),
                ),
              ],
      ),
      body: level == null
          ? _LevelGate(
              language: language,
              onSelected: (selected) {
                ref.read(studyLevelProvider.notifier).state = selected;
                if (selected != StudyLevel.n3 &&
                    ref.read(appLanguageProvider) == AppLanguage.ja) {
                  ref.read(appLanguageProvider.notifier).state = AppLanguage.en;
                }
              },
            )
          : _LessonHome(
              level: level,
              language: language,
            ),
    );
  }

  void _showLevelSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return _LevelPicker(
          language: ref.read(appLanguageProvider),
          onSelected: (level) {
            ref.read(studyLevelProvider.notifier).state = level;
            if (level != StudyLevel.n3 &&
                ref.read(appLanguageProvider) == AppLanguage.ja) {
              ref.read(appLanguageProvider.notifier).state = AppLanguage.en;
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showLanguageSheet(BuildContext context, WidgetRef ref) {
    final level = ref.read(studyLevelProvider);
    final allowJapanese = level == StudyLevel.n3;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return _LanguagePicker(
          allowJapanese: allowJapanese,
          uiLanguage: ref.read(appLanguageProvider),
          onSelected: (language) {
            ref.read(appLanguageProvider.notifier).state = language;
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle({
    required this.language,
    required this.onLanguageTap,
  });

  final AppLanguage language;
  final VoidCallback onLanguageTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('JpStudy'),
        const SizedBox(width: 12),
        _LanguageChip(
          language: language,
          onTap: onLanguageTap,
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

class _LevelAction extends StatelessWidget {
  const _LevelAction({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE1E6F0)),
          ),
          child: Row(
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.expand_more, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelGate extends StatelessWidget {
  const _LevelGate({
    required this.language,
    required this.onSelected,
  });

  final AppLanguage language;
  final ValueChanged<StudyLevel> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          language.levelMenuTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(language.levelMenuSubtitle),
        const SizedBox(height: 20),
        _LevelCard(
          level: StudyLevel.n5,
          language: language,
          countLabel: language.lessonCountLabel(25),
          onSelected: onSelected,
        ),
        _LevelCard(
          level: StudyLevel.n4,
          language: language,
          countLabel: language.lessonCountLabel(25),
          onSelected: onSelected,
        ),
        _LevelCard(
          level: StudyLevel.n3,
          language: language,
          countLabel: language.lessonCountLabel(25),
          onSelected: onSelected,
        ),
      ],
    );
  }
}

class _LessonHome extends StatelessWidget {
  const _LessonHome({
    required this.level,
    required this.language,
  });

  final StudyLevel level;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final lessons = _lessonItems(level);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        _LessonHeader(
          level: level.shortLabel,
          title: language.lessonPickerTitle,
        ),
        const SizedBox(height: 18),
        _FilterRow(language: language),
        const SizedBox(height: 18),
        _RecentAndSearchRow(language: language),
        const SizedBox(height: 16),
        for (final lesson in lessons)
          _LessonCard(
            title: language.lessonTitle(lesson.index),
            subtitle: language.lessonSubtitle(lesson.termCount),
            onTap: () => context.push('/lesson/${lesson.index}'),
          ),
      ],
    );
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({
    required this.level,
    required this.title,
  });

  final String level;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE1E6F0)),
          ),
          child: const Icon(Icons.folder_outlined),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              level,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              title,
              style: const TextStyle(color: Color(0xFF6B7390)),
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.more_horiz, size: 20),
        ),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD6DDFF)),
          ),
          child: Text(
            language.filterAllLabel,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.add, size: 18),
        ),
      ],
    );
  }
}

class _RecentAndSearchRow extends StatelessWidget {
  const _RecentAndSearchRow({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 560;
    final label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          language.recentItemsLabel,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.expand_more, size: 18),
      ],
    );
    final search = SizedBox(
      width: 280,
      child: TextField(
        decoration: InputDecoration(
          hintText: language.searchFolderHint,
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label,
          const SizedBox(height: 12),
          search,
        ],
      );
    }

    return Row(
      children: [
        label,
        const Spacer(),
        search,
      ],
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF5)),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.menu_book_outlined, color: Color(0xFF4255FF)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.more_horiz),
        onTap: onTap,
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.language,
    required this.countLabel,
    required this.onSelected,
  });

  final StudyLevel level;
  final AppLanguage language;
  final String countLabel;
  final ValueChanged<StudyLevel> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF5)),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.folder_open, color: Color(0xFF4255FF)),
        ),
        title: Text(
          level.shortLabel,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${level.description(language)} • $countLabel',
          style: const TextStyle(color: Color(0xFF6B7390)),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => onSelected(level),
      ),
    );
  }
}

class _LevelPicker extends StatelessWidget {
  const _LevelPicker({required this.language, required this.onSelected});

  final AppLanguage language;
  final ValueChanged<StudyLevel> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          Text(
            language.changeLevelLabel,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _SheetLevelCard(level: StudyLevel.n5, onSelected: onSelected),
          _SheetLevelCard(level: StudyLevel.n4, onSelected: onSelected),
          _SheetLevelCard(level: StudyLevel.n3, onSelected: onSelected),
        ],
      ),
    );
  }
}

class _SheetLevelCard extends StatelessWidget {
  const _SheetLevelCard({required this.level, required this.onSelected});

  final StudyLevel level;
  final ValueChanged<StudyLevel> onSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(level.shortLabel),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => onSelected(level),
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({
    required this.allowJapanese,
    required this.uiLanguage,
    required this.onSelected,
  });

  final bool allowJapanese;
  final AppLanguage uiLanguage;
  final ValueChanged<AppLanguage> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          Text(
            uiLanguage.languageMenuLabel,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _LanguageCard(language: AppLanguage.en, onSelected: onSelected),
          _LanguageCard(language: AppLanguage.vi, onSelected: onSelected),
          _LanguageCard(
            language: AppLanguage.ja,
            onSelected: onSelected,
            enabled: allowJapanese,
            disabledLabel: uiLanguage.n3OnlyLabel,
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.language,
    required this.onSelected,
    this.enabled = true,
    this.disabledLabel,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onSelected;
  final bool enabled;
  final String? disabledLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(language.label),
        subtitle: !enabled && disabledLabel != null ? Text(disabledLabel!) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: enabled ? () => onSelected(language) : null,
      ),
    );
  }
}

List<_LessonItem> _lessonItems(StudyLevel level) {
  final base = switch (level) {
    StudyLevel.n5 => 38,
    StudyLevel.n4 => 42,
    StudyLevel.n3 => 45,
  };
  return List.generate(
    25,
    (index) => _LessonItem(
      index: index + 1,
      termCount: base + ((index * 3) % 16),
    ),
  );
}

class _LessonItem {
  const _LessonItem({
    required this.index,
    required this.termCount,
  });

  final int index;
  final int termCount;
}
