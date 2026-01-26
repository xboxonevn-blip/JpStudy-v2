import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_language.dart';
import '../../../core/language_provider.dart';
import '../../../data/models/kanji_item.dart';
import '../widgets/handwriting_canvas.dart';

class HandwritingPracticeScreen extends ConsumerStatefulWidget {
  const HandwritingPracticeScreen({
    super.key,
    required this.lessonTitle,
    required this.items,
  });

  final String lessonTitle;
  final List<KanjiItem> items;

  @override
  ConsumerState<HandwritingPracticeScreen> createState() =>
      _HandwritingPracticeScreenState();
}

class _HandwritingPracticeScreenState
    extends ConsumerState<HandwritingPracticeScreen> {
  int _currentIndex = 0;
  int _correctCount = 0;
  bool _checked = false;
  bool _showGuide = true;
  List<List<Offset>> _strokes = [];
  Size _canvasSize = Size.zero;
  _HandwritingEvaluation? _evaluation;

  KanjiItem get _currentItem => widget.items[_currentIndex];

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    if (widget.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${language.handwritingLabel}: ${widget.lessonTitle}'),
        ),
        body: Center(child: Text(language.noKanjiAvailableLabel)),
      );
    }
    final item = _currentItem;
    final meaning = _resolveMeaning(item, language);

    return Scaffold(
      appBar: AppBar(
        title: Text('${language.handwritingLabel}: ${widget.lessonTitle}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgress(language),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                language.handwritingInstructionLabel,
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7390)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _KanjiHeader(
                item: item,
                meaning: meaning,
                language: language,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(
                      constraints.maxWidth,
                      constraints.maxWidth,
                    );
                    _canvasSize = size;
                    return Center(
                      child: SizedBox(
                        width: size.width,
                        height: size.height,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: HandwritingCanvas(
                            strokes: _strokes,
                            showGuide: _showGuide,
                            guideText: item.character,
                            enabled: !_checked,
                            onStrokeStart: _handleStrokeStart,
                            onStrokeUpdate: _handleStrokeUpdate,
                            onStrokeEnd: _handleStrokeEnd,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildControls(language),
            ),
            if (_evaluation != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: _buildResult(language, _evaluation!),
              ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildActionButtons(language),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress(AppLanguage language) {
    final progress = (_currentIndex + 1) / widget.items.length;
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(height: 6),
        Text(
          language.practiceProgressLabel(
            _currentIndex + 1,
            widget.items.length,
          ),
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7390)),
        ),
      ],
    );
  }

  Widget _buildControls(AppLanguage language) {
    final drawnStrokes = _strokeCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          language.handwritingStrokeCountLabel(_currentItem.strokeCount),
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7390)),
        ),
        const SizedBox(height: 4),
        Text(
          language.handwritingStrokesDrawnLabel(drawnStrokes),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: _showGuide,
                  onChanged: (value) {
                    setState(() {
                      _showGuide = value;
                    });
                  },
                ),
                Text(
                  language.handwritingShowGuideLabel,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: _strokes.isEmpty ? null : _undoStroke,
              icon: const Icon(Icons.undo_rounded),
              label: Text(language.handwritingUndoLabel),
            ),
            TextButton.icon(
              onPressed: _strokes.isEmpty ? null : _clearCanvas,
              icon: const Icon(Icons.delete_outline_rounded),
              label: Text(language.handwritingClearLabel),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResult(AppLanguage language, _HandwritingEvaluation evaluation) {
    final color = evaluation.isCorrect ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(
            evaluation.isCorrect ? Icons.check_circle : Icons.cancel,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              evaluation.isCorrect
                  ? language.correctLabel
                  : language.incorrectLabel,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '${evaluation.drawnStrokes}/${evaluation.expectedStrokes}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AppLanguage language) {
    if (!_checked) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: _strokes.isEmpty ? null : _checkAnswer,
          icon: const Icon(Icons.check_circle_outline),
          label: Text(language.handwritingCheckLabel),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _retry,
            icon: const Icon(Icons.refresh),
            label: Text(language.retryLabel),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _next,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(language.nextLabel),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleStrokeStart(Offset point) {
    if (_checked) return;
    setState(() {
      _strokes = [
        ..._strokes,
        [point],
      ];
    });
  }

  void _handleStrokeUpdate(Offset point) {
    if (_checked) return;
    if (_strokes.isEmpty) {
      _handleStrokeStart(point);
      return;
    }
    setState(() {
      final last = List<Offset>.from(_strokes.last)..add(point);
      _strokes = [..._strokes.sublist(0, _strokes.length - 1), last];
    });
  }

  void _handleStrokeEnd() {}

  void _checkAnswer() {
    if (_checked || _strokes.isEmpty) return;
    final evaluation = _evaluate();
    setState(() {
      _checked = true;
      _evaluation = evaluation;
      if (evaluation.isCorrect) {
        _correctCount += 1;
      }
    });
  }

  void _retry() {
    setState(() {
      _checked = false;
      _evaluation = null;
      _strokes = [];
    });
  }

  void _next() {
    if (_currentIndex >= widget.items.length - 1) {
      _showSummary();
      return;
    }
    setState(() {
      _currentIndex += 1;
      _checked = false;
      _evaluation = null;
      _strokes = [];
    });
  }

  void _undoStroke() {
    if (_strokes.isEmpty) return;
    setState(() {
      _strokes = List<List<Offset>>.from(_strokes)..removeLast();
      _checked = false;
      _evaluation = null;
    });
  }

  void _clearCanvas() {
    if (_strokes.isEmpty) return;
    setState(() {
      _strokes = [];
      _checked = false;
      _evaluation = null;
    });
  }

  _HandwritingEvaluation _evaluate() {
    final expected = _currentItem.strokeCount;
    final drawnStrokes = _strokeCount;
    final inkLength = _inkLength;
    final tolerance = expected >= 12
        ? 2
        : expected >= 6
        ? 1
        : 0;
    final strokeOk = (drawnStrokes - expected).abs() <= tolerance;
    final minSide = _canvasSize.shortestSide == 0
        ? 200
        : _canvasSize.shortestSide;
    final minLength = minSide * max(1.0, expected * 0.2);
    final lengthOk = inkLength >= minLength;
    return _HandwritingEvaluation(
      expectedStrokes: expected,
      drawnStrokes: drawnStrokes,
      isCorrect: strokeOk && lengthOk,
    );
  }

  int get _strokeCount {
    return _strokes.where((stroke) => stroke.length > 1).length;
  }

  double get _inkLength {
    double total = 0;
    for (final stroke in _strokes) {
      for (int i = 1; i < stroke.length; i++) {
        total += (stroke[i] - stroke[i - 1]).distance;
      }
    }
    return total;
  }

  String _resolveMeaning(KanjiItem item, AppLanguage language) {
    if (language == AppLanguage.en) {
      final english = (item.meaningEn ?? '').trim();
      return english.isNotEmpty ? english : item.meaning;
    }
    return item.meaning;
  }

  Future<void> _showSummary() async {
    final language = ref.read(appLanguageProvider);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(language.writeCompleteLabel),
        content: Text(
          language.practiceSummaryLabel(_correctCount, widget.items.length),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(language.doneLabel),
          ),
        ],
      ),
    );
  }
}

class _KanjiHeader extends StatelessWidget {
  const _KanjiHeader({
    required this.item,
    required this.meaning,
    required this.language,
  });

  final KanjiItem item;
  final String meaning;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A2E3A59),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            item.character,
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meaning,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                if ((item.kunyomi ?? '').isNotEmpty ||
                    (item.onyomi ?? '').isNotEmpty)
                  Text(
                    [
                      if ((item.kunyomi ?? '').isNotEmpty) item.kunyomi!,
                      if ((item.onyomi ?? '').isNotEmpty) item.onyomi!,
                    ].join(' • '),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7390),
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  language.handwritingStrokeCountLabel(item.strokeCount),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7390),
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

class _HandwritingEvaluation {
  const _HandwritingEvaluation({
    required this.expectedStrokes,
    required this.drawnStrokes,
    required this.isCorrect,
  });

  final int expectedStrokes;
  final int drawnStrokes;
  final bool isCorrect;
}
