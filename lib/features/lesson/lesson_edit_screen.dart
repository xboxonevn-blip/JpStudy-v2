import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';

class LessonEditScreen extends ConsumerStatefulWidget {
  const LessonEditScreen({super.key, required this.lessonId});

  final int lessonId;

  @override
  ConsumerState<LessonEditScreen> createState() => _LessonEditScreenState();
}

class _LessonEditScreenState extends ConsumerState<LessonEditScreen> {
  final List<_EditableTerm> _terms = [];
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  bool _hintsEnabled = true;
  bool _isPublic = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final repo = ref.read(lessonRepositoryProvider);
    final level = ref.read(studyLevelProvider)?.shortLabel ?? 'N5';
    final defaultTitle = 'Minna No Nihongo ${widget.lessonId}';
    final lesson = await repo.ensureLesson(
      lessonId: widget.lessonId,
      level: level,
      title: defaultTitle,
    );
    await repo.seedTermsIfEmpty(widget.lessonId);
    final terms = await repo.fetchTerms(widget.lessonId);
    if (!mounted) {
      return;
    }
    setState(() {
      _isPublic = lesson.isPublic;
      _titleController.text = lesson.title;
      _descriptionController.text = lesson.description;
      _terms
        ..clear()
        ..addAll(
          terms.map(
            (term) => _EditableTerm(
              id: term.id,
              term: term.term,
              reading: term.reading,
              definition: term.definition,
            ),
          ),
        );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final repo = ref.read(lessonRepositoryProvider);
    final level = ref.watch(studyLevelProvider) ?? StudyLevel.n5;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: TextButton.icon(
          onPressed: () => _exit(context),
          icon: const Icon(Icons.chevron_left, size: 18),
          label: Text(language.backToLessonLabel),
        ),
        leadingWidth: 180,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () => _exit(context),
              child: Text(language.doneLabel),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          _Pill(
            label: language.publicLabel,
            icon: Icons.public,
            active: _isPublic,
            onTap: () async {
              final nextValue = !_isPublic;
              setState(() => _isPublic = nextValue);
              await repo.updateLessonPublic(widget.lessonId, nextValue);
            },
          ),
          const SizedBox(height: 16),
          _LabeledField(
            label: language.titleLabel,
            child: TextField(
              controller: _titleController,
              onChanged: (value) => _onTitleChanged(repo, value),
              decoration: const InputDecoration(),
            ),
          ),
          const SizedBox(height: 12),
          _LabeledField(
            label: language.descriptionLabel,
            child: TextField(
              controller: _descriptionController,
              onChanged: (value) =>
                  repo.updateLessonDescription(widget.lessonId, value),
              decoration: const InputDecoration(),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _GhostButton(
                label: language.addTermLabel,
                icon: Icons.add,
                onPressed: () async {
                  await repo.addTerm(widget.lessonId);
                  final terms = await repo.fetchTerms(widget.lessonId);
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    _terms
                      ..clear()
                      ..addAll(
                        terms.map(
                          (term) => _EditableTerm(
                            id: term.id,
                            term: term.term,
                            reading: term.reading,
                            definition: term.definition,
                          ),
                        ),
                      );
                  });
                },
              ),
              const SizedBox(width: 10),
              _GhostButton(
                label: language.addDiagramLabel,
                icon: Icons.add_box_outlined,
                onPressed: () {},
              ),
              const Spacer(),
              Text(language.hintsLabel),
              const SizedBox(width: 8),
              Switch(
                value: _hintsEnabled,
                onChanged: (value) => setState(() => _hintsEnabled = value),
              ),
              const SizedBox(width: 8),
              _IconCircleButton(icon: Icons.swap_horiz, onTap: () {}),
              const SizedBox(width: 8),
              _IconCircleButton(icon: Icons.keyboard, onTap: () {}),
              const SizedBox(width: 8),
              _IconCircleButton(
                icon: Icons.delete_outline,
                onTap: () async {
                  if (_terms.isNotEmpty) {
                    final term = _terms.removeLast();
                    setState(() {});
                    await repo.deleteTerm(term.id);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < _terms.length; i++)
            _TermCard(
              key: ValueKey(_terms[i].id),
              index: i + 1,
              term: _terms[i],
              language: language,
              onRemove: () async {
                final term = _terms.removeAt(i);
                setState(() {});
                await repo.deleteTerm(term.id);
              },
              onTermChanged: (value) {
                final parsed = _parseTerm(value);
                _terms[i] = _terms[i].copyWith(
                  term: parsed.term,
                  reading: parsed.reading,
                );
                repo.updateTerm(
                  _terms[i].id,
                  term: parsed.term,
                  reading: parsed.reading,
                );
              },
              onDefinitionChanged: (value) {
                _terms[i] = _terms[i].copyWith(definition: value);
                repo.updateTerm(_terms[i].id, definition: value);
              },
            ),
          const SizedBox(height: 12),
          Text(
            '${language.levelLabelPrefix}${level.shortLabel}',
            style: const TextStyle(color: Color(0xFF8F9BB3)),
          ),
        ],
      ),
    );
  }

  void _exit(BuildContext context) {
    ref.invalidate(lessonTitleProvider);
    ref.invalidate(lessonTermsProvider);
    Navigator.of(context).pop();
  }

  _ParsedTerm _parseTerm(String value) {
    final lines = value.split('\n');
    final term = lines.isNotEmpty ? lines.first.trim() : '';
    final reading = lines.length > 1 ? lines.sublist(1).join('\n').trim() : '';
    return _ParsedTerm(term: term, reading: reading);
  }

  void _onTitleChanged(LessonRepository repo, String value) {
    repo.updateLessonTitle(widget.lessonId, value);
    ref.invalidate(lessonTitleProvider);
  }
}

class _ParsedTerm {
  const _ParsedTerm({required this.term, required this.reading});

  final String term;
  final String reading;
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEFF2FF) : const Color(0xFFF1F3F7),
          borderRadius: BorderRadius.circular(16),
          border: active ? Border.all(color: const Color(0xFFD6DDFF)) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8F9BB3)),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        side: const BorderSide(color: Color(0xFFE1E6F0)),
        foregroundColor: const Color(0xFF1C2440),
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F7),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _TermCard extends StatelessWidget {
  const _TermCard({
    super.key,
    required this.index,
    required this.term,
    required this.language,
    required this.onRemove,
    required this.onTermChanged,
    required this.onDefinitionChanged,
  });

  final int index;
  final _EditableTerm term;
  final AppLanguage language;
  final VoidCallback onRemove;
  final ValueChanged<String> onTermChanged;
  final ValueChanged<String> onDefinitionChanged;

  @override
  Widget build(BuildContext context) {
    final termValue = term.reading.isEmpty
        ? term.term
        : '${term.term}\n${term.reading}';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                index.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              _IconCircleButton(icon: Icons.drag_indicator, onTap: () {}),
              const SizedBox(width: 8),
              _IconCircleButton(icon: Icons.delete_outline, onTap: onRemove),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _TermField(
                  label: language.termLabel,
                  initialValue: termValue,
                  onChanged: onTermChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TermField(
                  label: language.definitionLabel,
                  initialValue: term.definition,
                  onChanged: onDefinitionChanged,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TermField extends StatelessWidget {
  const _TermField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8F9BB3)),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          maxLines: 2,
          decoration: const InputDecoration(),
        ),
      ],
    );
  }
}

class _EditableTerm {
  const _EditableTerm({
    required this.id,
    required this.term,
    required this.reading,
    required this.definition,
  });

  final int id;
  final String term;
  final String reading;
  final String definition;

  _EditableTerm copyWith({
    String? term,
    String? reading,
    String? definition,
  }) {
    return _EditableTerm(
      id: id,
      term: term ?? this.term,
      reading: reading ?? this.reading,
      definition: definition ?? this.definition,
    );
  }
}
