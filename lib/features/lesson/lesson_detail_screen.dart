import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/study_level.dart';

class LessonDetailScreen extends ConsumerWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final int lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider);
    final levelLabel = level?.shortLabel ?? 'N5';
    final flashcards = ref.watch(_flashcardsProvider);
    final trackProgress = ref.watch(_trackProgressProvider);
    final allStarred = flashcards.every((item) => item.isStarred);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          _HeaderRow(
            levelLabel: levelLabel,
            language: language,
            saved: allStarred,
            onSavedToggle: () {
              ref
                  .read(_flashcardsProvider.notifier)
                  .setAllStarred(!allStarred);
            },
          ),
          const SizedBox(height: 16),
          Text(
            language.lessonTitle(lessonId),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _StatsRow(language: language),
          const SizedBox(height: 18),
          _ActionGrid(language: language),
          const SizedBox(height: 18),
          _FlashcardPreview(
            language: language,
            card: flashcards.first,
            onToggleStar: () {
              ref.read(_flashcardsProvider.notifier).toggleStar(0);
            },
            onPlayAudio: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(language.audioComingSoon)),
              );
            },
            showShortcut: trackProgress,
          ),
          const SizedBox(height: 16),
          _BottomControls(
            language: language,
            trackProgress: trackProgress,
            onTrackProgressChanged: (value) {
              ref.read(_trackProgressProvider.notifier).state = value;
            },
          ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.levelLabel,
    required this.language,
    required this.saved,
    required this.onSavedToggle,
  });

  final String levelLabel;
  final AppLanguage language;
  final bool saved;
  final VoidCallback onSavedToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.folder_outlined, size: 20),
        const SizedBox(width: 6),
        Text(
          levelLabel,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        _ChipButton(
          icon: Icons.bookmark,
          label: language.savedLabel,
          filled: true,
          active: saved,
          onTap: onSavedToggle,
        ),
        const SizedBox(width: 8),
        _OverflowMenu(language: language),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final lastStudiedText =
        language.lastStudiedLabel(language.lastStudiedSample);
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.schedule, size: 18, color: Color(0xFF4D5877)),
            const SizedBox(width: 6),
            Text(lastStudiedText),
          ],
        ),
      ],
    );
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final items = [
      _ActionItem(
        label: language.flashcardsAction,
        icon: Icons.view_agenda_outlined,
        color: const Color(0xFF5B6CFF),
      ),
      _ActionItem(
        label: language.learnAction,
        icon: Icons.school_outlined,
        color: const Color(0xFF7A5BFF),
      ),
      _ActionItem(
        label: language.testAction,
        icon: Icons.task_alt_outlined,
        color: const Color(0xFF2B8EF5),
      ),
      _ActionItem(
        label: language.matchAction,
        icon: Icons.grid_view_outlined,
        color: const Color(0xFF5B6CFF),
      ),
      _ActionItem(
        label: language.blastAction,
        icon: Icons.rocket_launch_outlined,
        color: const Color(0xFF7A5BFF),
      ),
      _ActionItem(
        label: language.combineAction,
        icon: Icons.merge_type_outlined,
        color: const Color(0xFF2B8EF5),
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final item in items) _ActionButton(item: item),
      ],
    );
  }
}

class _ActionItem {
  const _ActionItem({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.item});

  final _ActionItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6EBF5)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlashcardPreview extends StatelessWidget {
  const _FlashcardPreview({
    required this.language,
    required this.card,
    required this.onToggleStar,
    required this.onPlayAudio,
    required this.showShortcut,
  });

  final AppLanguage language;
  final _FlashcardItem card;
  final VoidCallback onToggleStar;
  final VoidCallback onPlayAudio;
  final bool showShortcut;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, size: 18),
              const SizedBox(width: 8),
              Text(
                language.showHintsLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              _IconButton(
                icon: Icons.volume_up_outlined,
                onTap: onPlayAudio,
              ),
              const SizedBox(width: 8),
              _IconButton(
                icon: card.isStarred ? Icons.star : Icons.star_border,
                onTap: onToggleStar,
                active: card.isStarred,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Text(
                  card.term,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '(${card.reading})',
                  style: const TextStyle(fontSize: 22, color: Color(0xFF4D5877)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (showShortcut)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE6E8FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.keyboard, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    language.shortcutLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      language.shortcutInstruction,
                      style: const TextStyle(color: Color(0xFF4D5877)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.language,
    required this.trackProgress,
    required this.onTrackProgressChanged,
  });

  final AppLanguage language;
  final bool trackProgress;
  final ValueChanged<bool> onTrackProgressChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              language.trackProgressLabel,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Switch(
              value: trackProgress,
              onChanged: onTrackProgressChanged,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (trackProgress)
          Row(
            children: const [
              _CircleIcon(icon: Icons.close, color: Color(0xFFEF5B5B)),
              SizedBox(width: 12),
              Text('1 / 46'),
              SizedBox(width: 12),
              _CircleIcon(icon: Icons.check, color: Color(0xFF34C759)),
              Spacer(),
              Icon(Icons.undo, color: Color(0xFF8F9BB3)),
              SizedBox(width: 12),
              Icon(Icons.shuffle, color: Color(0xFF8F9BB3)),
              SizedBox(width: 12),
              Icon(Icons.settings_outlined, color: Color(0xFF8F9BB3)),
              SizedBox(width: 12),
              Icon(Icons.fullscreen, color: Color(0xFF8F9BB3)),
            ],
          ),
      ],
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
    required this.icon,
    required this.label,
    this.filled = false,
    this.active = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? const Color(0xFFEFF2FF) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD6DDFF)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              active ? Icons.star : icon,
              size: 16,
              color: const Color(0xFF4255FF),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    this.onTap,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF2FF),
          borderRadius: BorderRadius.circular(12),
          border: active ? Border.all(color: const Color(0xFF4255FF)) : null,
        ),
        child: Icon(
          icon,
          size: 18,
          color: const Color(0xFF4255FF),
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

final _trackProgressProvider = StateProvider<bool>((ref) => false);

final _flashcardsProvider =
    StateNotifierProvider<_FlashcardStateNotifier, List<_FlashcardItem>>(
  (ref) => _FlashcardStateNotifier(_seedFlashcards()),
);

class _FlashcardItem {
  const _FlashcardItem({
    required this.term,
    required this.reading,
    required this.meaning,
    required this.isStarred,
  });

  final String term;
  final String reading;
  final String meaning;
  final bool isStarred;

  _FlashcardItem copyWith({bool? isStarred}) {
    return _FlashcardItem(
      term: term,
      reading: reading,
      meaning: meaning,
      isStarred: isStarred ?? this.isStarred,
    );
  }
}

class _FlashcardStateNotifier extends StateNotifier<List<_FlashcardItem>> {
  _FlashcardStateNotifier(super.state);

  void toggleStar(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(isStarred: !state[i].isStarred)
        else
          state[i],
    ];
  }

  void setAllStarred(bool value) {
    state = [
      for (final item in state) item.copyWith(isStarred: value),
    ];
  }
}

List<_FlashcardItem> _seedFlashcards() {
  return const [
    _FlashcardItem(
      term: 'わたし',
      reading: '私',
      meaning: 'tôi',
      isStarred: false,
    ),
    _FlashcardItem(
      term: 'あなた',
      reading: 'あなた',
      meaning: 'bạn',
      isStarred: false,
    ),
  ];
}

class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_LessonMenuAction>(
      tooltip: '',
      color: Colors.white,
      offset: const Offset(0, 46),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (context) => [
        _menuItem(
          value: _LessonMenuAction.copy,
          icon: Icons.copy_all_outlined,
          label: language.copySetLabel,
        ),
        _menuItem(
          value: _LessonMenuAction.reset,
          icon: Icons.restart_alt,
          label: language.resetProgressLabel,
        ),
        _menuItem(
          value: _LessonMenuAction.combine,
          icon: Icons.merge_type_outlined,
          label: language.combineSetLabel,
        ),
        _menuItem(
          value: _LessonMenuAction.report,
          icon: Icons.report_outlined,
          label: language.reportLabel,
        ),
      ],
      onSelected: (_) {},
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF2FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.more_horiz, size: 18, color: Color(0xFF4255FF)),
      ),
    );
  }

  PopupMenuItem<_LessonMenuAction> _menuItem({
    required _LessonMenuAction value,
    required IconData icon,
    required String label,
  }) {
    return PopupMenuItem<_LessonMenuAction>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF4D5877)),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}

enum _LessonMenuAction {
  copy,
  reset,
  combine,
  report,
}
