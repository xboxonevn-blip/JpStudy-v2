import 'package:flutter/material.dart';

enum LabStage { discover, visual, validate }

class DesignLabScreen extends StatefulWidget {
  const DesignLabScreen({super.key});

  @override
  State<DesignLabScreen> createState() => _DesignLabScreenState();
}

class _DesignLabScreenState extends State<DesignLabScreen> {
  LabStage _stage = LabStage.discover;
  final Set<int> _checkedTaskIds = {1, 2};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design Lab')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF9FAFF), Color(0xFFF3F6FF), Color(0xFFEFFBFF)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 920;
              final content = <Widget>[
                _heroCard(),
                const SizedBox(height: 16),
                _stageSwitch(),
                const SizedBox(height: 16),
                _stageCanvas(),
                const SizedBox(height: 16),
                _progressChecklist(),
              ];

              if (isWide) {
                return Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: content.sublist(0, 3),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                        children: content.sublist(3),
                      ),
                    ),
                  ],
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: content,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220F172A),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live UI/UX Workflow',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Use this screen to review wireframe -> visual -> validation flow '
            'before shipping a real screen.',
            style: TextStyle(color: Color(0xFFD9E7FF), height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _stageSwitch() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCE7FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Stage',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SegmentedButton<LabStage>(
            segments: const [
              ButtonSegment(
                value: LabStage.discover,
                icon: Icon(Icons.grid_view_rounded),
                label: Text('Discover'),
              ),
              ButtonSegment(
                value: LabStage.visual,
                icon: Icon(Icons.palette_outlined),
                label: Text('Visual'),
              ),
              ButtonSegment(
                value: LabStage.validate,
                icon: Icon(Icons.task_alt_outlined),
                label: Text('Validate'),
              ),
            ],
            selected: {_stage},
            onSelectionChanged: (value) {
              setState(() => _stage = value.first);
            },
          ),
        ],
      ),
    );
  }

  Widget _stageCanvas() {
    switch (_stage) {
      case LabStage.discover:
        return _panel(
          title: 'Wireframe Snapshot',
          subtitle: 'Block-level layout before visual polish.',
          child: Column(
            children: [
              _skeletonBlock(height: 36),
              const SizedBox(height: 12),
              _skeletonBlock(height: 92),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _skeletonBlock(height: 110)),
                  const SizedBox(width: 12),
                  Expanded(child: _skeletonBlock(height: 110)),
                ],
              ),
            ],
          ),
        );
      case LabStage.visual:
        return _panel(
          title: 'Visual Direction',
          subtitle: 'Color, spacing, and card rhythm review.',
          child: Column(
            children: [
              Container(
                height: 112,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFEDD5), Color(0xFFFDE68A)],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _swatchCard('Primary', const Color(0xFF0F766E)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _swatchCard('Accent', const Color(0xFFFB7185)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _swatchCard('Neutral', const Color(0xFF334155)),
                  ),
                ],
              ),
            ],
          ),
        );
      case LabStage.validate:
        return _panel(
          title: 'Validation Notes',
          subtitle: 'Quick quality readout before merge.',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _MetricChip(label: 'Tap targets >= 44px', ok: true),
              _MetricChip(label: 'Text contrast pass', ok: true),
              _MetricChip(label: 'Scroll behavior checked', ok: true),
              _MetricChip(label: 'Animation intensity reviewed', ok: false),
              _MetricChip(label: 'QA walkthrough pass', ok: false),
            ],
          ),
        );
    }
  }

  Widget _progressChecklist() {
    final tasks = const [
      (1, 'Wireframe approved in team review'),
      (2, 'Visual style tokenized (color/spacing/type)'),
      (3, 'Prototype tested on desktop + mobile'),
      (4, 'Feedback log written in docs/uiux-progress.md'),
      (5, 'Ready for handoff to production screen'),
    ];
    return _panel(
      title: 'Process Checklist',
      subtitle: 'Track each iteration in one place.',
      child: Column(
        children: [
          for (final (id, label) in tasks)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _checkedTaskIds.contains(id),
              title: Text(label),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _checkedTaskIds.add(id);
                  } else {
                    _checkedTaskIds.remove(id);
                  }
                });
              },
            ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Next: update docs/uiux-progress.md and docs/uiux-review-checklist.md',
              style: TextStyle(
                color: Colors.blueGrey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDCE7FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.blueGrey.shade700)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _skeletonBlock({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF8),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _swatchCard(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.ok});

  final String label;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final bg = ok ? const Color(0xFFE8F7EE) : const Color(0xFFFFF1F2);
    final fg = ok ? const Color(0xFF166534) : const Color(0xFF9F1239);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.error_outline,
            size: 16,
            color: fg,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: fg, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
