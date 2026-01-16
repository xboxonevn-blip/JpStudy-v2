import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

enum _LessonMode { learn, test, flashcards }

enum _MenuAction { edit, reset, combine, report }

class LessonDetailScreen extends ConsumerStatefulWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final int lessonId;

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  bool _showHints = true;
  bool _trackProgress = false;
  bool _autoPlay = false;
  bool _shuffle = false;
  bool _focusMode = false;
  double _speed = 1.0;
  _LessonMode _mode = _LessonMode.learn;
  int _currentIndex = 0;
  final Set<int> _starredTermIds = {};
  final Random _random = Random();
  List<int>? _shuffledOrder;
  Timer? _autoTimer;
  int _autoTotal = 0;

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider) ?? StudyLevel.n5;
    final fallbackTitle = language.lessonTitle(widget.lessonId);
    final titleAsync = ref.watch(
      lessonTitleProvider(LessonTitleArgs(widget.lessonId, fallbackTitle)),
    );
    final termsAsync = ref.watch(
      lessonTermsProvider(
        LessonTermsArgs(widget.lessonId, level.shortLabel, fallbackTitle),
      ),
    );

    final title = titleAsync.maybeWhen(
      data: (value) => value,
      orElse: () => fallbackTitle,
    );
    final terms = termsAsync.asData?.value ?? const <UserLessonTermData>[];
    final displayTerms = _orderedTerms(terms);
    final totalTerms = displayTerms.length;
    final currentIndex = totalTerms == 0
        ? 0
        : _currentIndex.clamp(0, totalTerms - 1);
    final currentTerm =
        totalTerms == 0 ? null : displayTerms.elementAt(currentIndex);
    final isSaved = terms.isNotEmpty && _starredTermIds.length == terms.length;
    final isStarred = currentTerm != null &&
        _starredTermIds.contains(currentTerm.id);

    if (_autoPlay && totalTerms != _autoTotal) {
      _autoTotal = totalTerms;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _syncAutoTimer(totalTerms);
        }
      });
    }

    return Scaffold(
      appBar: _focusMode
          ? null
          : AppBar(
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              tooltip: language.backToLessonLabel,
              onPressed: () => context.pop(),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${level.shortLabel} / $title',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          _SavedPill(
            label: language.savedLabel,
            active: isSaved,
            onTap: totalTerms == 0 ? null : () => _toggleSaved(terms),
          ),
          const SizedBox(width: 8),
          _OverflowMenu(
            language: language,
            onSelected: (action) => _handleMenu(action, context),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, _focusMode ? 20 : 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!_focusMode) ...[
                  _ModeSwitcher(
                    language: language,
                    mode: _mode,
                    onModeChanged: (mode) => setState(() => _mode = mode),
                  ),
                  const SizedBox(height: 20),
                ],
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: SizedBox(
                      height: _focusMode ? 520 : 460,
                      child: _LessonCard(
                        language: language,
                        termsAsync: termsAsync,
                        term: currentTerm,
                        showHints: _showHints,
                        trackProgress: _trackProgress,
                        isStarred: isStarred,
                        onShowHintsChanged: (value) =>
                            setState(() => _showHints = value),
                        onEdit: () => context.push(
                          '/lesson/${widget.lessonId}/edit',
                        ),
                        onAudio: () => _showAudioNotice(language),
                        onStar: currentTerm == null
                            ? null
                            : () => _toggleStar(currentTerm),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _PlayerBar(
        language: language,
        trackProgress: _trackProgress,
        onTrackProgressChanged: (value) =>
            setState(() => _trackProgress = value),
        currentIndex: currentIndex,
        total: totalTerms,
        onPrev: () => _goPrev(totalTerms),
        onNext: () => _goNext(totalTerms),
        shuffle: _shuffle,
        autoPlay: _autoPlay,
        speed: _speed,
        fullscreen: _focusMode,
        onToggleShuffle: () => _toggleShuffle(terms),
        onToggleAuto: () => _toggleAuto(totalTerms),
        onSpeedChanged: (value) => _setSpeed(value, totalTerms),
        onSettings: () => _showSettings(language, totalTerms, terms),
        onFullscreen: () => setState(() => _focusMode = !_focusMode),
      ),
    );
  }

  List<UserLessonTermData> _orderedTerms(List<UserLessonTermData> terms) {
    if (!_shuffle) {
      _shuffledOrder = null;
      return terms;
    }
    if (terms.isEmpty) {
      _shuffledOrder = null;
      return terms;
    }
    final ids = terms.map((term) => term.id).toSet();
    final order = _shuffledOrder;
    if (order == null ||
        order.length != ids.length ||
        !order.every(ids.contains)) {
      final nextOrder = ids.toList()..shuffle(_random);
      _shuffledOrder = nextOrder;
    }
    final lookup = {for (final term in terms) term.id: term};
    return _shuffledOrder!.map((id) => lookup[id]!).toList();
  }

  void _toggleSaved(List<UserLessonTermData> terms) {
    setState(() {
      if (_starredTermIds.length == terms.length) {
        _starredTermIds.clear();
      } else {
        _starredTermIds
          ..clear()
          ..addAll(terms.map((term) => term.id));
      }
    });
  }

  void _toggleStar(UserLessonTermData term) {
    setState(() {
      if (_starredTermIds.contains(term.id)) {
        _starredTermIds.remove(term.id);
      } else {
        _starredTermIds.add(term.id);
      }
    });
  }

  void _goPrev(int total) {
    if (total == 0) {
      return;
    }
    setState(() {
      _currentIndex = (_currentIndex - 1).clamp(0, total - 1);
    });
  }

  void _goNext(int total) {
    if (total == 0) {
      return;
    }
    setState(() {
      _currentIndex = (_currentIndex + 1).clamp(0, total - 1);
    });
  }

  void _goNextAuto(int total) {
    if (total == 0) {
      return;
    }
    setState(() {
      _currentIndex = (_currentIndex + 1) % total;
    });
  }

  void _showAudioNotice(AppLanguage language) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(language.audioComingSoon)),
    );
  }

  void _handleMenu(_MenuAction action, BuildContext context) {
    if (action == _MenuAction.edit) {
      context.push('/lesson/${widget.lessonId}/edit');
    }
  }

  void _toggleShuffle(List<UserLessonTermData> terms) {
    final currentId = _currentTermId(terms);
    setState(() {
      _shuffle = !_shuffle;
      if (_shuffle) {
        final ids = terms.map((term) => term.id).toList();
        if (ids.isEmpty) {
          _shuffledOrder = null;
          _currentIndex = 0;
          return;
        }
        ids.shuffle(_random);
        _shuffledOrder = ids;
        if (currentId != null) {
          _currentIndex = ids.indexOf(currentId).clamp(0, ids.length - 1);
        } else {
          _currentIndex = 0;
        }
      } else {
        _shuffledOrder = null;
        if (currentId != null) {
          final index =
              terms.indexWhere((term) => term.id == currentId);
          _currentIndex = index == -1 ? 0 : index;
        } else {
          _currentIndex = 0;
        }
      }
    });
  }

  int? _currentTermId(List<UserLessonTermData> terms) {
    final ordered = _orderedTerms(terms);
    if (ordered.isEmpty) {
      return null;
    }
    final index = _currentIndex.clamp(0, ordered.length - 1);
    return ordered[index].id;
  }

  void _toggleAuto(int total) {
    setState(() => _autoPlay = !_autoPlay);
    _syncAutoTimer(total);
  }

  void _setSpeed(double value, int total) {
    setState(() => _speed = value);
    _syncAutoTimer(total);
  }

  void _syncAutoTimer(int total) {
    _autoTimer?.cancel();
    if (!_autoPlay || total == 0) {
      return;
    }
    final intervalMs =
        (3800 / _speed).round().clamp(900, 8000).toInt();
    _autoTimer = Timer.periodic(
      Duration(milliseconds: intervalMs),
      (_) {
        if (!mounted || !_autoPlay) {
          return;
        }
        _goNextAuto(total);
      },
    );
  }

  Future<void> _showSettings(
    AppLanguage language,
    int total,
    List<UserLessonTermData> terms,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.settingsLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(language.showHintsLabel),
                      value: _showHints,
                      onChanged: (value) {
                        setState(() => _showHints = value);
                        setModalState(() {});
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(language.trackProgressLabel),
                      value: _trackProgress,
                      onChanged: (value) {
                        setState(() => _trackProgress = value);
                        setModalState(() {});
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(language.shuffleLabel),
                      value: _shuffle,
                      onChanged: (value) {
                        _toggleShuffle(terms);
                        setModalState(() {});
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(language.autoLabel),
                      value: _autoPlay,
                      onChanged: (value) {
                        setState(() => _autoPlay = value);
                        _syncAutoTimer(total);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(language.speedLabel),
                    Slider(
                      value: _speed,
                      min: 0.8,
                      max: 2.0,
                      divisions: 6,
                      label: '${_speed.toStringAsFixed(1)}x',
                      onChanged: (value) {
                        setState(() => _speed = value);
                        _syncAutoTimer(total);
                        setModalState(() {});
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SavedPill extends StatelessWidget {
  const _SavedPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEFF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? const Color(0xFFD6DDFF) : const Color(0xFFE1E6F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? Icons.star : Icons.star_border,
              size: 16,
              color: active ? const Color(0xFF4255FF) : null,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({
    required this.language,
    required this.onSelected,
  });

  final AppLanguage language;
  final ValueChanged<_MenuAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuAction>(
      onSelected: onSelected,
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _MenuAction.edit,
          child: Text(language.copySetLabel),
        ),
        PopupMenuItem(
          value: _MenuAction.reset,
          child: Text(language.resetProgressLabel),
        ),
        PopupMenuItem(
          value: _MenuAction.combine,
          child: Text(language.combineSetLabel),
        ),
        PopupMenuItem(
          value: _MenuAction.report,
          child: Text(language.reportLabel),
        ),
      ],
    );
  }
}

class _ModeSwitcher extends StatelessWidget {
  const _ModeSwitcher({
    required this.language,
    required this.mode,
    required this.onModeChanged,
  });

  final AppLanguage language;
  final _LessonMode mode;
  final ValueChanged<_LessonMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SegmentedButton<_LessonMode>(
          segments: [
            ButtonSegment(
              value: _LessonMode.learn,
              label: Text(language.learnAction),
            ),
            ButtonSegment(
              value: _LessonMode.test,
              label: Text(language.testAction),
            ),
            ButtonSegment(
              value: _LessonMode.flashcards,
              label: Text(language.flashcardsAction),
            ),
          ],
          selected: {mode},
          onSelectionChanged: (selection) {
            if (selection.isNotEmpty) {
              onModeChanged(selection.first);
            }
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFF4255FF);
              }
              return Colors.white;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return const Color(0xFF1C2440);
            }),
            side: WidgetStateProperty.all(
              const BorderSide(color: Color(0xFFE1E6F0)),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        _GamesMenu(language: language),
      ],
    );
  }
}

class _GamesMenu extends StatelessWidget {
  const _GamesMenu({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'match',
          child: Text(language.matchAction),
        ),
        PopupMenuItem(
          value: 'blast',
          child: Text(language.blastAction),
        ),
        PopupMenuItem(
          value: 'combine',
          child: Text(language.combineAction),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE1E6F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              language.gamesLabel,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.expand_more, size: 18),
          ],
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.language,
    required this.termsAsync,
    required this.term,
    required this.showHints,
    required this.trackProgress,
    required this.isStarred,
    required this.onShowHintsChanged,
    required this.onEdit,
    required this.onAudio,
    required this.onStar,
  });

  final AppLanguage language;
  final AsyncValue<List<UserLessonTermData>> termsAsync;
  final UserLessonTermData? term;
  final bool showHints;
  final bool trackProgress;
  final bool isStarred;
  final ValueChanged<bool> onShowHintsChanged;
  final VoidCallback onEdit;
  final VoidCallback onAudio;
  final VoidCallback? onStar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A2E3A59),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 18),
                    const SizedBox(width: 6),
                    Text(language.showHintsLabel),
                    const SizedBox(width: 8),
                    Switch(
                      value: showHints,
                      onChanged: onShowHintsChanged,
                    ),
                  ],
                ),
                const Spacer(),
                _ActionPill(
                  isStarred: isStarred,
                  onEdit: onEdit,
                  onAudio: onAudio,
                  onStar: onStar,
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: _CardContent(
                language: language,
                termsAsync: termsAsync,
                term: term,
                showHints: showHints,
              ),
            ),
          ),
          if (trackProgress) _ShortcutBar(language: language),
        ],
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.language,
    required this.termsAsync,
    required this.term,
    required this.showHints,
  });

  final AppLanguage language;
  final AsyncValue<List<UserLessonTermData>> termsAsync;
  final UserLessonTermData? term;
  final bool showHints;

  @override
  Widget build(BuildContext context) {
    if (termsAsync.isLoading) {
      return const CircularProgressIndicator();
    }
    if (termsAsync.hasError) {
      return Text(language.loadErrorLabel);
    }
    if (term == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          term!.term,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C2440),
          ),
          textAlign: TextAlign.center,
        ),
        if (term!.reading.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            term!.reading,
            style: const TextStyle(fontSize: 18, color: Color(0xFF6B7390)),
            textAlign: TextAlign.center,
          ),
        ],
        if (showHints && term!.definition.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            term!.definition,
            style: const TextStyle(fontSize: 16, color: Color(0xFF4D5877)),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class _ShortcutBar extends StatelessWidget {
  const _ShortcutBar({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFE9EBFF),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.keyboard, size: 16),
          ),
          const SizedBox(width: 10),
          Text(
            language.shortcutLabel,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              language.shortcutInstruction,
              style: const TextStyle(color: Color(0xFF4D5877)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.isStarred,
    required this.onEdit,
    required this.onAudio,
    required this.onStar,
  });

  final bool isStarred;
  final VoidCallback onEdit;
  final VoidCallback onAudio;
  final VoidCallback? onStar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E6F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _IconPillButton(icon: Icons.edit_outlined, onTap: onEdit),
          const SizedBox(width: 4),
          _IconPillButton(icon: Icons.volume_up_outlined, onTap: onAudio),
          const SizedBox(width: 4),
          _IconPillButton(
            icon: isStarred ? Icons.star : Icons.star_border,
            onTap: onStar,
            active: isStarred,
          ),
        ],
      ),
    );
  }
}

class _IconPillButton extends StatelessWidget {
  const _IconPillButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEFF2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? const Color(0xFF4255FF) : null,
        ),
      ),
    );
  }
}

class _PlayerBar extends StatelessWidget {
  const _PlayerBar({
    required this.language,
    required this.trackProgress,
    required this.onTrackProgressChanged,
    required this.currentIndex,
    required this.total,
    required this.onPrev,
    required this.onNext,
    required this.shuffle,
    required this.autoPlay,
    required this.speed,
    required this.fullscreen,
    required this.onToggleShuffle,
    required this.onToggleAuto,
    required this.onSpeedChanged,
    required this.onSettings,
    required this.onFullscreen,
  });

  final AppLanguage language;
  final bool trackProgress;
  final ValueChanged<bool> onTrackProgressChanged;
  final int currentIndex;
  final int total;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final bool shuffle;
  final bool autoPlay;
  final double speed;
  final bool fullscreen;
  final VoidCallback onToggleShuffle;
  final VoidCallback onToggleAuto;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onSettings;
  final VoidCallback onFullscreen;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE8ECF5))),
        ),
        child: Row(
          children: [
            Row(
              children: [
                Text(language.trackProgressLabel),
                const SizedBox(width: 8),
                Switch(
                  value: trackProgress,
                  onChanged: onTrackProgressChanged,
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: onPrev,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  '${total == 0 ? 0 : currentIndex + 1} / $total',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const Spacer(),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _PlayerChip(
                  icon: Icons.shuffle,
                  label: language.shuffleLabel,
                  active: shuffle,
                  onTap: onToggleShuffle,
                ),
                _PlayerChip(
                  icon: Icons.play_circle_outline,
                  label: language.autoLabel,
                  active: autoPlay,
                  onTap: onToggleAuto,
                ),
                PopupMenuButton<double>(
                  onSelected: onSpeedChanged,
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 0.8, child: Text('0.8x')),
                    PopupMenuItem(value: 1.0, child: Text('1x')),
                    PopupMenuItem(value: 1.2, child: Text('1.2x')),
                    PopupMenuItem(value: 1.5, child: Text('1.5x')),
                    PopupMenuItem(value: 2.0, child: Text('2x')),
                  ],
                  child: _PlayerChip(
                    icon: Icons.speed,
                    label: '${language.speedLabel} ${_speedLabel(speed)}',
                    onTap: null,
                  ),
                ),
                _PlayerChip(
                  icon: Icons.settings_outlined,
                  label: language.settingsLabel,
                  onTap: onSettings,
                ),
                _PlayerChip(
                  icon: Icons.fullscreen,
                  label: language.fullscreenLabel,
                  active: fullscreen,
                  onTap: onFullscreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _speedLabel(double value) {
    final clean = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
    return '${clean}x';
  }
}

class _PlayerChip extends StatelessWidget {
  const _PlayerChip({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEFF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: active ? const Color(0xFFD6DDFF) : const Color(0xFFE1E6F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? const Color(0xFF4255FF) : null,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
