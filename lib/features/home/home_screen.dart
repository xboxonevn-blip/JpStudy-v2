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
import 'package:jpstudy/features/home/screens/learning_path_screen.dart';
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
          : const LearningPathScreen(),
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
