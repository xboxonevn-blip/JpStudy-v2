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
    final allowJapanese = level == StudyLevel.n3;
    final actions = <Widget>[
      TextButton(
        onPressed: () => _showLanguageSheet(context, ref),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 18),
            const SizedBox(width: 6),
            Text(
              language.shortCode,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    ];
    if (level != null) {
      actions.add(
        TextButton(
          onPressed: () => _showLevelSheet(context, ref),
          child: Text(
            level.shortLabel,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('JpStudy'),
        actions: actions,
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
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _LevelHeader(level: level, language: language),
          const SizedBox(height: 16),
          Text(
            language.mvpModulesTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _ModuleCard(
            title: language.vocabTitle,
            subtitle: language.vocabSubtitle,
            onTap: () => _push(context, '/vocab'),
          ),
          _ModuleCard(
            title: language.grammarTitle,
            subtitle: language.grammarSubtitle(level.shortLabel),
            onTap: () => _push(context, '/grammar'),
          ),
          _ModuleCard(
            title: language.examTitle,
            subtitle: language.examSubtitle(level.shortLabel),
            onTap: () => _push(context, '/exam'),
          ),
          _ModuleCard(
            title: language.progressTitle,
            subtitle: language.progressSubtitle,
            onTap: () => _push(context, '/progress'),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, String route) {
    context.push(route);
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
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          language.levelMenuTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(language.levelMenuSubtitle),
        const SizedBox(height: 16),
        _LevelCard(
          level: StudyLevel.n5,
          language: language,
          onSelected: onSelected,
        ),
        _LevelCard(
          level: StudyLevel.n4,
          language: language,
          onSelected: onSelected,
        ),
        _LevelCard(
          level: StudyLevel.n3,
          language: language,
          onSelected: onSelected,
        ),
      ],
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
          _LevelCard(
            level: StudyLevel.n5,
            language: language,
            onSelected: onSelected,
          ),
          _LevelCard(
            level: StudyLevel.n4,
            language: language,
            onSelected: onSelected,
          ),
          _LevelCard(
            level: StudyLevel.n3,
            language: language,
            onSelected: onSelected,
          ),
        ],
      ),
    );
  }
}

class _LevelHeader extends StatelessWidget {
  const _LevelHeader({required this.level, required this.language});

  final StudyLevel level;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${language.levelLabelPrefix}${level.shortLabel}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.language,
    required this.onSelected,
  });

  final StudyLevel level;
  final AppLanguage language;
  final ValueChanged<StudyLevel> onSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(level.shortLabel),
        subtitle: Text(level.description(language)),
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
          const Text(
            'Language',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
