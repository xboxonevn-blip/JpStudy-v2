import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(studyLevelProvider);
    final language = ref.watch(appLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: _HeaderBar(
          level: level,
          language: language,
          onLanguageTap: () => _showLanguageSheet(context, ref),
          onLevelChanged: (selected) => _setLevel(ref, selected),
        ),
      ),
      body: level == null
          ? _LevelGate(
              language: language,
              onSelected: (selected) => _setLevel(ref, selected),
            )
          : _LessonHome(
              level: level,
              language: language,
            ),
    );
  }

  void _setLevel(WidgetRef ref, StudyLevel selected) {
    ref.read(studyLevelProvider.notifier).state = selected;
    if (selected != StudyLevel.n3 &&
        ref.read(appLanguageProvider) == AppLanguage.ja) {
      ref.read(appLanguageProvider.notifier).state = AppLanguage.en;
    }
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

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.level,
    required this.language,
    required this.onLanguageTap,
    required this.onLevelChanged,
  });

  final StudyLevel? level;
  final AppLanguage language;
  final VoidCallback onLanguageTap;
  final ValueChanged<StudyLevel> onLevelChanged;

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

class _HeaderRight extends StatelessWidget {
  const _HeaderRight({
    required this.language,
    required this.onLanguageTap,
  });

  final AppLanguage language;
  final VoidCallback onLanguageTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LanguageChip(
          language: language,
          onTap: onLanguageTap,
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings_outlined),
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFFEFF2FF),
          child: Text(
            'U',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
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
        _LessonToolbar(level: level, language: language),
        const SizedBox(height: 16),
        for (final lesson in lessons)
          _LessonCard(
            lessonId: lesson.index,
            fallbackTitle: language.lessonTitle(lesson.index),
            metaText: _lessonMeta(language, lesson),
            progress: lesson.progress,
            onTap: () => context.push('/lesson/${lesson.index}'),
          ),
      ],
    );
  }

  String _lessonMeta(AppLanguage language, _LessonItem lesson) {
    final countText = language.termsCountLabel(lesson.termCount);
    final timeText = language.lastStudiedLabel(
      language.relativeTimeLabel(lesson.lastStudiedMinutes),
    );
    return '$countText - $timeText';
  }
}

class _LessonToolbar extends StatefulWidget {
  const _LessonToolbar({
    required this.level,
    required this.language,
  });

  final StudyLevel level;
  final AppLanguage language;

  @override
  State<_LessonToolbar> createState() => _LessonToolbarState();
}

class _LessonToolbarState extends State<_LessonToolbar> {
  String _filter = 'all';
  String _sort = 'recent';

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 980;
    final title = widget.language.lessonListTitle(widget.level.shortLabel);
    final actions = _ToolbarActions(
      language: widget.language,
      filter: _filter,
      sort: _sort,
      onFilterChanged: (value) => setState(() => _filter = value),
      onSortChanged: (value) => setState(() => _sort = value),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          actions,
        ],
      );
    }

    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        actions,
      ],
    );
  }
}

class _ToolbarActions extends StatelessWidget {
  const _ToolbarActions({
    required this.language,
    required this.filter,
    required this.sort,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  final AppLanguage language;
  final String filter;
  final String sort;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 380,
          child: TextField(
            decoration: InputDecoration(
              hintText: language.searchLessonsHint,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        _DropdownChip(
          value: filter,
          items: [
            _MenuOption('all', language.filterAllLabel),
          ],
          onChanged: onFilterChanged,
        ),
        _DropdownChip(
          value: sort,
          items: [
            _MenuOption('recent', language.sortRecentLabel),
            _MenuOption('az', language.sortAzLabel),
            _MenuOption('progress', language.sortProgressLabel),
            _MenuOption('terms', language.sortTermCountLabel),
          ],
          onChanged: onSortChanged,
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: Text(language.createLessonLabel),
        ),
      ],
    );
  }
}

class _MenuOption {
  const _MenuOption(this.value, this.label);

  final String value;
  final String label;
}

class _DropdownChip extends StatelessWidget {
  const _DropdownChip({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<_MenuOption> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E6F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.expand_more, size: 18),
          items: [
            for (final item in items)
              DropdownMenuItem(
                value: item.value,
                child: Text(item.label),
              ),
          ],
          onChanged: (next) {
            if (next != null) {
              onChanged(next);
            }
          },
        ),
      ),
    );
  }
}

class _LessonCard extends ConsumerStatefulWidget {
  const _LessonCard({
    required this.lessonId,
    required this.fallbackTitle,
    required this.metaText,
    required this.progress,
    required this.onTap,
  });

  final int lessonId;
  final String fallbackTitle;
  final String metaText;
  final double progress;
  final VoidCallback onTap;

  @override
  ConsumerState<_LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends ConsumerState<_LessonCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final titleAsync = ref.watch(
      lessonTitleProvider(LessonTitleArgs(widget.lessonId, widget.fallbackTitle)),
    );
    final resolvedTitle = titleAsync.maybeWhen(
      data: (value) => value,
      orElse: () => widget.fallbackTitle,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 64,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8ECF5)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book_outlined,
                  color: Color(0xFF4255FF),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      resolvedTitle,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.metaText,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7390),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 110,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: widget.progress,
                              minHeight: 2,
                              backgroundColor: const Color(0xFFE8ECF5),
                              color: const Color(0xFF4255FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedOpacity(
                opacity: _hovering ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: IgnorePointer(
                  ignoring: !_hovering,
                  child: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
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
          '${level.description(language)} - $countLabel',
          style: const TextStyle(color: Color(0xFF6B7390)),
        ),
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
      lastStudiedMinutes: 60 + (index * 35) % 720,
      progress: 0.2 + ((index * 7) % 60) / 100,
    ),
  );
}

class _LessonItem {
  const _LessonItem({
    required this.index,
    required this.termCount,
    required this.lastStudiedMinutes,
    required this.progress,
  });

  final int index;
  final int termCount;
  final int lastStudiedMinutes;
  final double progress;
}
