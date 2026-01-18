import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/notifications/notification_service.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/core/gamification/level_calculator.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/home/widgets/bento_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefDailyReminder = 'notifications.daily';
const _prefDailyReminderTime = 'notifications.daily.time';
const _prefDailyReminderLast = 'notifications.daily.last';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _inAppReminderTimer;
  SharedPreferences? _prefs;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  bool _reminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadReminderPrefs();
  }

  @override
  void dispose() {
    _inAppReminderTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          onLanguageTap: () => _showLanguageSheet(context),
          onLevelChanged: (selected) => _setLevel(selected),
          onSettingsTap: () => _showSettingsSheet(context),
        ),
      ),
      body: level == null
          ? _LevelGate(
              language: language,
              onSelected: (selected) => _setLevel(selected),
            )
          : _LessonHome(
              level: level,
              language: language,
            ),
    );
  }

  void _setLevel(StudyLevel selected) {
    ref.read(studyLevelProvider.notifier).state = selected;
    if (selected != StudyLevel.n3 &&
        ref.read(appLanguageProvider) == AppLanguage.ja) {
      ref.read(appLanguageProvider.notifier).state = AppLanguage.en;
    }
  }

  void _showLanguageSheet(BuildContext context) {
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

  void _showSettingsSheet(BuildContext context) {
    final language = ref.read(appLanguageProvider);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final prefs = snapshot.data!;
            final supportsNotifications =
                NotificationService.instance.isSupported;
            var reminderEnabled =
                prefs.getBool(_prefDailyReminder) ?? false;
            if (_prefs == null) {
              _prefs = prefs;
              _reminderEnabled = reminderEnabled;
              _reminderTime = _reminderTimeFromPrefs(prefs) ??
                  const TimeOfDay(hour: 20, minute: 0);
            }
            return StatefulBuilder(
              builder: (context, setModalState) {
                return SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: [
                      Text(
                        language.settingsLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(language.languageMenuLabel),
                        onTap: () {
                          Navigator.of(context).pop();
                          _showLanguageSheet(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.school_outlined),
                        title: Text(language.levelMenuTitle),
                        onTap: () {
                          ref.read(studyLevelProvider.notifier).state = null;
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.insights_outlined),
                        title: Text(language.progressTitle),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.push('/progress');
                        },
                      ),
                      const Divider(),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(language.reminderDailyLabel),
                        subtitle: Text(language.reminderDailyHint),
                        value: reminderEnabled,
                        onChanged: (value) async {
                          reminderEnabled = value;
                          await _setDailyReminder(
                            value,
                            prefs: prefs,
                            language: language,
                          );
                          if (!supportsNotifications && value) {
                            if (!context.mounted) {
                              return;
                            }
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: _reminderTime,
                            );
                            if (picked != null) {
                              _reminderTime = picked;
                              await _saveReminderTime(prefs, picked);
                              _scheduleInAppReminder();
                            }
                          }
                          setModalState(() {});
                        },
                      ),
                      if (!supportsNotifications) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            language.reminderUnsupportedLabel,
                            style: const TextStyle(color: Color(0xFF6B7390)),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.schedule_outlined),
                          title: Text(language.reminderTimeLabel),
                          subtitle: Text(_formatTime(_reminderTime, context)),
                          onTap: reminderEnabled
                              ? () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: _reminderTime,
                                  );
                                  if (picked == null) {
                                    return;
                                  }
                                  _reminderTime = picked;
                                  await _saveReminderTime(prefs, picked);
                                  if (reminderEnabled) {
                                    _scheduleInAppReminder();
                                  }
                                  setModalState(() {});
                                }
                              : null,
                        ),
                      ],
                      TextButton.icon(
                        onPressed: supportsNotifications
                            ? () => NotificationService.instance
                                .showTestNotification(
                              title: language.reminderTitle,
                              body: language.reminderTestBody,
                            )
                            : () => _showInAppReminder(language),
                        icon: const Icon(Icons.notifications_active_outlined),
                        label: Text(language.reminderTestLabel),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.save_alt_outlined),
                        title: Text(language.backupExportLabel),
                        onTap: () => _exportBackup(context, language),
                      ),
                      ListTile(
                        leading: const Icon(Icons.restore_outlined),
                        title: Text(language.backupImportLabel),
                        onTap: () => _importBackup(context, language),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _exportBackup(
    BuildContext context,
    AppLanguage language,
  ) async {
    final repo = ref.read(lessonRepositoryProvider);
    final data = await repo.exportBackup();
    final jsonText = const JsonEncoder.withIndent('  ').convert(data);
    final location = await getSaveLocation(
      suggestedName: 'jpstudy_backup.json',
      acceptedTypeGroups: const [
        XTypeGroup(label: 'JSON', extensions: ['json']),
      ],
    );
    if (location == null) {
      return;
    }
    try {
      await File(location.path).writeAsString(jsonText, flush: true);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language.backupExportSuccess)),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language.backupExportError)),
      );
    }
  }

  Future<void> _importBackup(
    BuildContext context,
    AppLanguage language,
  ) async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(label: 'JSON', extensions: ['json']),
      ],
    );
    if (file == null) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    final shouldImport = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(language.backupImportTitle),
        content: Text(language.backupImportBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(language.backupImportConfirmLabel),
          ),
        ],
      ),
    );
    if (shouldImport != true) {
      return;
    }
    try {
      final content = await File(file.path).readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;
      final repo = ref.read(lessonRepositoryProvider);
      await repo.importBackup(data);
      ref.invalidate(lessonMetaProvider);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language.backupImportSuccess)),
      );
      } catch (_) {
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(language.backupImportError)),
        );
      }
    }

  Future<void> _loadReminderPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }
    _prefs = prefs;
    _reminderEnabled = prefs.getBool(_prefDailyReminder) ?? false;
    _reminderTime = _reminderTimeFromPrefs(prefs) ??
        const TimeOfDay(hour: 20, minute: 0);
    if (_reminderEnabled && !NotificationService.instance.isSupported) {
      _scheduleInAppReminder();
    }
  }

  TimeOfDay? _reminderTimeFromPrefs(SharedPreferences prefs) {
    final stored = prefs.getString(_prefDailyReminderTime);
    if (stored == null || stored.isEmpty) {
      return null;
    }
    final parts = stored.split(':');
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _saveReminderTime(
    SharedPreferences prefs,
    TimeOfDay time,
  ) async {
    final value = '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
    await prefs.setString(_prefDailyReminderTime, value);
  }

  Future<void> _setDailyReminder(
    bool enabled, {
    required SharedPreferences prefs,
    required AppLanguage language,
  }) async {
    _reminderEnabled = enabled;
    await prefs.setBool(_prefDailyReminder, enabled);
    if (NotificationService.instance.isSupported) {
      if (enabled) {
        await NotificationService.instance.enableDailyReminder(
          title: language.reminderTitle,
          body: language.reminderBody,
        );
      } else {
        await NotificationService.instance.disableDailyReminder();
      }
    } else {
      if (enabled) {
        _scheduleInAppReminder();
      } else {
        _inAppReminderTimer?.cancel();
      }
    }
  }

  void _scheduleInAppReminder() {
    _inAppReminderTimer?.cancel();
    if (!_reminderEnabled) {
      return;
    }
    final now = DateTime.now();
    final next = _nextReminderTime(now, _reminderTime);
    final delay = next.difference(now);
    _inAppReminderTimer = Timer(delay, _handleInAppReminder);
  }

  DateTime _nextReminderTime(DateTime now, TimeOfDay time) {
    var next = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (!next.isAfter(now)) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }

  Future<void> _handleInAppReminder() async {
    if (!mounted) {
      return;
    }
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs ??= prefs;
    final todayKey = _dateKey(DateTime.now());
    final lastShown = prefs.getString(_prefDailyReminderLast);
    if (lastShown != todayKey) {
      await prefs.setString(_prefDailyReminderLast, todayKey);
      _showInAppReminder(ref.read(appLanguageProvider));
    }
    _scheduleInAppReminder();
  }

  String _dateKey(DateTime time) {
    return '${time.year.toString().padLeft(4, '0')}-'
        '${time.month.toString().padLeft(2, '0')}-'
        '${time.day.toString().padLeft(2, '0')}';
  }

  void _showInAppReminder(AppLanguage language) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(language.reminderBody)),
    );
  }

  String _formatTime(TimeOfDay time, BuildContext context) {
    return MaterialLocalizations.of(context).formatTimeOfDay(time);
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
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

class _LessonHome extends ConsumerStatefulWidget {
  const _LessonHome({
    required this.level,
    required this.language,
  });

  final StudyLevel level;
  final AppLanguage language;

  @override
  ConsumerState<_LessonHome> createState() => _LessonHomeState();
}

class _LessonHomeState extends ConsumerState<_LessonHome> {
  late final TextEditingController _searchController;
  String _filter = 'all';
  String _sort = 'recent';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metaAsync = ref.watch(lessonMetaProvider(widget.level.shortLabel));
    final meta = metaAsync.asData?.value ?? const <LessonMeta>[];
    final lessons = _buildLessonSummaries(
      widget.level,
      widget.language,
      meta,
    );
    final filtered = _applyFilters(lessons);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        // Bento Grid Section
        BentoGrid(
          level: widget.level,
          language: widget.language,
          recentLesson: meta.isNotEmpty ? meta.first : null, // Todo: better recent logic?
          onContinueTap: () {
            if (meta.isNotEmpty) {
              final latest = meta.first;
              context.push(
                '/lesson/${latest.id}?level=${widget.level.shortLabel}',
                extra: latest.title,
              );
            } else {
               _createLesson(context);
            }
          },
          onLessonTap: () {},
        ),
        const SizedBox(height: 32),
        // Toolbar
        _LessonToolbar(
          level: widget.level,
          language: widget.language,
          searchController: _searchController,
          filter: _filter,
          sort: _sort,
          onSearchChanged: (value) => setState(() {}),
          onFilterChanged: (value) => setState(() => _filter = value),
          onSortChanged: (value) => setState(() => _sort = value),
          onCreateLesson: () => _createLesson(context),
        ),
        const SizedBox(height: 16),
        if (metaAsync.isLoading)
          const LinearProgressIndicator(minHeight: 2),
        if (metaAsync.isLoading) const SizedBox(height: 12),
        if (filtered.isEmpty)
          const SizedBox.shrink()
        else
          for (final lesson in filtered)
            _LessonCard(
              lesson: lesson,
              language: widget.language,
              levelLabel: widget.level.shortLabel,
              onTap: () => context.push('/lesson/${lesson.id}'),
              onEdit: () => context.push('/lesson/${lesson.id}/edit'),
              metaText: _lessonMeta(widget.language, lesson),
            ),
      ],
    );
  }

  List<_LessonSummary> _applyFilters(List<_LessonSummary> lessons) {
    final query = _searchController.text.trim().toLowerCase();
    var results = lessons;
    if (query.isNotEmpty) {
      results = results
          .where(
            (lesson) =>
                lesson.title.toLowerCase().contains(query) ||
                lesson.id.toString() == query,
          )
          .toList();
    }
    switch (_filter) {
      case 'has_data':
        results = results.where((lesson) => lesson.termCount > 0).toList();
        break;
      case 'empty':
        results = results.where((lesson) => lesson.termCount == 0).toList();
        break;
      case 'custom':
        results = results
            .where((lesson) => lesson.isCustomLesson || lesson.isCustomTitle)
            .toList();
        break;
    }
    results.sort((a, b) {
      switch (_sort) {
        case 'az':
          final titleCompare =
              a.title.toLowerCase().compareTo(b.title.toLowerCase());
          return titleCompare != 0 ? titleCompare : a.id.compareTo(b.id);
        case 'progress':
          final progressCompare = b.progress.compareTo(a.progress);
          return progressCompare != 0 ? progressCompare : a.id.compareTo(b.id);
        case 'terms':
          final countCompare = b.termCount.compareTo(a.termCount);
          return countCompare != 0 ? countCompare : a.id.compareTo(b.id);
        case 'recent':
        default:
          final recentCompare =
              a.lastStudiedMinutes.compareTo(b.lastStudiedMinutes);
          return recentCompare != 0 ? recentCompare : a.id.compareTo(b.id);
      }
    });
    return results;
  }

  List<_LessonSummary> _buildLessonSummaries(
    StudyLevel level,
    AppLanguage language,
    List<LessonMeta> meta,
  ) {
    final defaults = _lessonDefaults(level);
    final metaById = {for (final lesson in meta) lesson.id: lesson};
    final summaries = <_LessonSummary>[];

    for (final stub in defaults) {
      final fallbackTitle = language.lessonTitle(stub.index);
      final stored = metaById.remove(stub.index);
      final title = stored == null
          ? fallbackTitle
          : (stored.isCustomTitle ? stored.title : fallbackTitle);
      final lastStudiedMinutes = stored?.updatedAt == null
          ? stub.lastStudiedMinutes
          : _minutesSince(stored!.updatedAt!, stub.lastStudiedMinutes);
      final termCount = stored?.termCount ?? stub.termCount;
      final progress = stored == null
          ? 0.0
          : _progressFromCounts(stored.completedCount, termCount);
      final dueCount = stored?.dueCount ?? 0;

      summaries.add(
        _LessonSummary(
          id: stub.index,
          title: title,
          fallbackTitle: fallbackTitle,
          termCount: termCount,
          lastStudiedMinutes: lastStudiedMinutes,
          progress: progress,
          dueCount: dueCount,
          tags: stored?.tags ?? '',
          isCustomTitle: stored?.isCustomTitle ?? false,
          isCustomLesson: false,
        ),
      );
    }

    for (final stored in metaById.values) {
      final fallbackTitle = language.lessonTitle(stored.id);
      final title =
          stored.isCustomTitle ? stored.title : fallbackTitle;
      final lastStudiedMinutes = stored.updatedAt == null
          ? 0
          : _minutesSince(stored.updatedAt!, 0);
      final progress =
          _progressFromCounts(stored.completedCount, stored.termCount);
      summaries.add(
        _LessonSummary(
          id: stored.id,
          title: title,
          fallbackTitle: fallbackTitle,
          termCount: stored.termCount,
          lastStudiedMinutes: lastStudiedMinutes,
          progress: progress,
          dueCount: stored.dueCount,
          tags: stored.tags,
          isCustomTitle: stored.isCustomTitle,
          isCustomLesson: true,
        ),
      );
    }

    return summaries;
  }

  int _minutesSince(DateTime value, int fallback) {
    final diff = DateTime.now().difference(value).inMinutes;
    return diff.isNegative ? fallback : diff;
  }

  double _progressFromCounts(int completed, int total) {
    if (total <= 0) {
      return 0;
    }
    final ratio = completed / total;
    return ratio.clamp(0.0, 1.0).toDouble();
  }

  String _lessonMeta(AppLanguage language, _LessonSummary lesson) {
    final countText = language.termsCountLabel(lesson.termCount);
    final timeText = language.lastStudiedLabel(
      language.relativeTimeLabel(lesson.lastStudiedMinutes),
    );
    final tags = lesson.tags.trim();
    if (tags.isEmpty) {
      return '$countText - $timeText';
    }
    return '$countText - $timeText - ${language.tagsMetaLabel(tags)}';
  }

  Future<void> _createLesson(BuildContext context) async {
    final repo = ref.read(lessonRepositoryProvider);
    final level = widget.level.shortLabel;
    final nextId = await repo.nextLessonId();
    if (!context.mounted) {
      return;
    }
    final defaultTitle = widget.language.lessonTitle(nextId);
    final controller = TextEditingController(text: defaultTitle);
    var isPublic = true;

    final created = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.language.createLessonLabel),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: defaultTitle,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(widget.language.publicLabel),
                    value: isPublic,
                    onChanged: (value) =>
                        setDialogState(() => isPublic = value),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(widget.language.createLessonLabel),
            ),
          ],
        );
      },
    );

    if (created != true || !context.mounted) {
      controller.dispose();
      return;
    }

    final title = controller.text.trim();
    controller.dispose();
    final resolvedTitle = title.isEmpty ? defaultTitle : title;
    final isCustomTitle = resolvedTitle != defaultTitle;
    final lessonId = await repo.createLesson(
      level: level,
      title: resolvedTitle,
      isPublic: isPublic,
      isCustomTitle: isCustomTitle,
    );
    ref.invalidate(lessonMetaProvider(level));
    if (!context.mounted) {
      return;
    }
    context.push('/lesson/$lessonId/edit');
  }
}

class _LessonToolbar extends StatelessWidget {
  const _LessonToolbar({
    required this.level,
    required this.language,
    required this.searchController,
    required this.filter,
    required this.sort,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.onCreateLesson,
  });

  final StudyLevel level;
  final AppLanguage language;
  final TextEditingController searchController;
  final String filter;
  final String sort;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSortChanged;
  final VoidCallback onCreateLesson;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 980;
    final title = language.lessonListTitle(level.shortLabel);
    final actions = _ToolbarActions(
      language: language,
      searchController: searchController,
      filter: filter,
      sort: sort,
      onSearchChanged: onSearchChanged,
      onFilterChanged: onFilterChanged,
      onSortChanged: onSortChanged,
      onCreateLesson: onCreateLesson,
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
    required this.searchController,
    required this.filter,
    required this.sort,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.onCreateLesson,
  });

  final AppLanguage language;
  final TextEditingController searchController;
  final String filter;
  final String sort;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSortChanged;
  final VoidCallback onCreateLesson;

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
            controller: searchController,
            onChanged: onSearchChanged,
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
            _MenuOption('has_data', language.filterHasDataLabel),
            _MenuOption('empty', language.filterEmptyLabel),
            _MenuOption('custom', language.filterCustomLabel),
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
          onPressed: onCreateLesson,
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

enum _LessonAction { open, edit, rename }

class _LessonCard extends ConsumerStatefulWidget {
  const _LessonCard({
    required this.lesson,
    required this.language,
    required this.levelLabel,
    required this.metaText,
    required this.onTap,
    required this.onEdit,
  });

  final _LessonSummary lesson;
  final AppLanguage language;
  final String levelLabel;
  final String metaText;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  ConsumerState<_LessonCard> createState() => _LessonCardState();
}

class _DueChip extends StatelessWidget {
  const _DueChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFD7B0)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF9A5B1A),
        ),
      ),
    );
  }
}

class _LessonCardState extends ConsumerState<_LessonCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
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
                      widget.lesson.title,
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
                        if (widget.lesson.dueCount > 0) ...[
                          const SizedBox(width: 8),
                          _DueChip(
                            label: widget.language.dueCountLabel(
                              widget.lesson.dueCount,
                            ),
                          ),
                        ],
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 110,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: widget.lesson.progress,
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
                    onPressed: () => _showLessonMenu(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLessonMenu(BuildContext context) async {
    final action = await showModalBottomSheet<_LessonAction>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: Text(widget.language.learnAction),
                onTap: () => Navigator.of(context).pop(_LessonAction.open),
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit'),
                onTap: () => Navigator.of(context).pop(_LessonAction.edit),
              ),
              ListTile(
                leading: const Icon(Icons.drive_file_rename_outline),
                title: const Text('Rename'),
                onTap: () => Navigator.of(context).pop(_LessonAction.rename),
              ),
            ],
          ),
        );
      },
    );

    if (!context.mounted) {
      return;
    }
    if (action == null) {
      return;
    }
    switch (action) {
      case _LessonAction.open:
        widget.onTap();
        break;
      case _LessonAction.edit:
        widget.onEdit();
        break;
      case _LessonAction.rename:
        await _renameLesson(context);
        break;
    }
  }

  Future<void> _renameLesson(BuildContext context) async {
    if (!context.mounted) {
      return;
    }
    final controller = TextEditingController(text: widget.lesson.title);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.language.titleLabel),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: widget.lesson.fallbackTitle,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      controller.dispose();
      return;
    }

    final title = controller.text.trim();
    controller.dispose();
    final resolvedTitle =
        title.isEmpty ? widget.lesson.fallbackTitle : title;
    final isCustomTitle = resolvedTitle != widget.lesson.fallbackTitle;
    final repo = ref.read(lessonRepositoryProvider);
    await repo.updateLessonTitle(
      widget.lesson.id,
      resolvedTitle,
      isCustomTitle: isCustomTitle,
    );
    ref.invalidate(lessonMetaProvider(widget.levelLabel));
    ref.invalidate(
      lessonTitleProvider(
        LessonTitleArgs(widget.lesson.id, widget.lesson.fallbackTitle),
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

List<_LessonStub> _lessonDefaults(StudyLevel level) {
  int startLesson = 1;
  if (level == StudyLevel.n4) {
    startLesson = 26;
  } else if (level == StudyLevel.n3) {
    startLesson = 51;
  }

  return List.generate(
    25,
    (index) => _LessonStub(
      index: startLesson + index,
      termCount: 0,
      lastStudiedMinutes: 0,
      progress: 0,
    ),
  );
}

class _LessonStub {
  const _LessonStub({
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

class _LessonSummary {
  const _LessonSummary({
    required this.id,
    required this.title,
    required this.fallbackTitle,
    required this.termCount,
    required this.lastStudiedMinutes,
    required this.progress,
    required this.dueCount,
    required this.tags,
    required this.isCustomTitle,
    required this.isCustomLesson,
  });

  final int id;
  final String title;
  final String fallbackTitle;
  final int termCount;
  final int lastStudiedMinutes;
  final double progress;
  final int dueCount;
  final String tags;
  final bool isCustomTitle;
  final bool isCustomLesson;
}
