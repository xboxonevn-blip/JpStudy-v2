import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_language.dart';
import '../../../core/language_provider.dart';
import '../../../data/models/kanji_item.dart';
import '../../../data/models/mistake_context.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../mistakes/repositories/mistake_repository.dart';
import '../services/handwriting_template_matcher.dart';
import '../services/kanji_stroke_template_service.dart';
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
  bool _hasCommitted = false;
  KanjiStrokeTemplate? _strokeTemplate;

  KanjiItem get _currentItem => widget.items[_currentIndex];

  @override
  void initState() {
    super.initState();
    _loadStrokeTemplate();
  }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          const SizedBox(height: 6),
          Text(
            [
              'S ${evaluation.score.toStringAsFixed(2)}',
              'Stk ${evaluation.strokeScore.toStringAsFixed(2)}',
              'Shp ${evaluation.shapeScore.toStringAsFixed(2)}',
              'Ord ${evaluation.orderScore.toStringAsFixed(2)}',
              if (evaluation.usedTemplate)
                'Tmp ${evaluation.templateScore.toStringAsFixed(2)}'
                    '(${evaluation.templateQuality})',
            ].join('  |  '),
            style: const TextStyle(
              fontSize: 11,
              fontFeatures: [FontFeature.tabularFigures()],
              color: Color(0xFF4D587A),
            ),
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
      _hasCommitted = false;
    });
  }

  Future<void> _next() async {
    await _commitReviewIfNeeded();
    if (_currentIndex >= widget.items.length - 1) {
      await _showSummary();
      return;
    }
    setState(() {
      _currentIndex += 1;
      _checked = false;
      _evaluation = null;
      _strokes = [];
      _hasCommitted = false;
      _strokeTemplate = null;
    });
    await _loadStrokeTemplate();
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
      _hasCommitted = false;
    });
  }

  _HandwritingEvaluation _evaluate() {
    final expected = _currentItem.strokeCount;
    final meaningfulStrokes = _strokes.where((stroke) => stroke.length > 1).toList();
    final drawnStrokes = meaningfulStrokes.length;
    final inkLength = _inkLength;
    final tolerance = expected >= 12
        ? 2
        : expected >= 6
        ? 1
        : 0;
    final strokeDelta = (drawnStrokes - expected).abs().toDouble();
    final strokeScore = 1.0 - (strokeDelta / (tolerance + 1)).clamp(0.0, 1.0);

    final minSide = _canvasSize.shortestSide == 0
        ? 200
        : _canvasSize.shortestSide;
    final minLength = minSide * max(1.0, expected * 0.2);
    final lengthScore = (inkLength / max(1.0, minLength)).clamp(0.0, 1.0);

    final template = _strokeTemplate;
    final templateScore = template == null
        ? 0.0
        : HandwritingTemplateMatcher.templateScore(
            strokes: meaningfulStrokes,
            template: template,
          );
    final shapeScore = _shapeScore(meaningfulStrokes);
    final orderScore = _orderScore(meaningfulStrokes);
    final useStrongTemplate = template?.isHighConfidence == true;
    final useMediumTemplate = template?.isMediumConfidence == true;
    final totalScore = template == null
        ? (strokeScore * 0.35) +
              (lengthScore * 0.15) +
              (shapeScore * 0.30) +
              (orderScore * 0.20)
        : useStrongTemplate
        ? (strokeScore * 0.25) +
              (lengthScore * 0.10) +
              (shapeScore * 0.20) +
              (orderScore * 0.15) +
              (templateScore * 0.30)
        : useMediumTemplate
        ? (strokeScore * 0.30) +
              (lengthScore * 0.12) +
              (shapeScore * 0.23) +
              (orderScore * 0.19) +
              (templateScore * 0.16)
        : (strokeScore * 0.33) +
              (lengthScore * 0.15) +
              (shapeScore * 0.28) +
              (orderScore * 0.20) +
              (templateScore * 0.04);
    final requiredScore = _showGuide ? 0.58 : 0.68;
    final minTemplateScore = useStrongTemplate
        ? 0.35
        : useMediumTemplate
        ? 0.22
        : 0.0;
    final isCorrect =
        totalScore >= requiredScore &&
        strokeScore >= 0.45 &&
        templateScore >= minTemplateScore;

    return _HandwritingEvaluation(
      expectedStrokes: expected,
      drawnStrokes: drawnStrokes,
      score: totalScore,
      strokeScore: strokeScore,
      shapeScore: shapeScore,
      orderScore: orderScore,
      templateScore: templateScore,
      usedTemplate: template != null,
      templateQuality: template?.normalizedQuality ?? 'none',
      isCorrect: isCorrect,
    );
  }

  double _shapeScore(List<List<Offset>> strokes) {
    if (strokes.isEmpty) return 0;
    final allPoints = <Offset>[
      for (final stroke in strokes) ...stroke,
    ];
    final minX = allPoints.map((p) => p.dx).reduce(min);
    final maxX = allPoints.map((p) => p.dx).reduce(max);
    final minY = allPoints.map((p) => p.dy).reduce(min);
    final maxY = allPoints.map((p) => p.dy).reduce(max);

    final width = max(1.0, maxX - minX);
    final height = max(1.0, maxY - minY);
    final bboxArea = width * height;
    final canvasArea = max(1.0, _canvasSize.width * _canvasSize.height);
    final areaRatio = (bboxArea / canvasArea).clamp(0.0, 1.0);

    // Most handwritten kanji should occupy a moderate area in the box.
    final targetArea = _strokeTemplate?.targetArea ?? 0.32;
    final areaScore = 1.0 -
        ((areaRatio - targetArea).abs() / max(0.1, targetArea))
            .clamp(0.0, 1.0);

    final center = Offset((minX + maxX) / 2, (minY + maxY) / 2);
    final canvasCenter = Offset(_canvasSize.width / 2, _canvasSize.height / 2);
    final maxDistance = max(1.0, _canvasSize.shortestSide / 2);
    final centerDistance = (center - canvasCenter).distance;
    final centerScore = 1.0 - (centerDistance / maxDistance).clamp(0.0, 1.0);

    final aspect = width / height;
    // Keep aspect flexible but discourage extremely flat/tall drawings.
    final targetAspect = _strokeTemplate?.targetAspect ?? 1.0;
    final aspectScore =
        1.0 - ((aspect - targetAspect).abs() / 1.5).clamp(0.0, 1.0);

    return (areaScore * 0.45) + (centerScore * 0.35) + (aspectScore * 0.20);
  }

  double _orderScore(List<List<Offset>> strokes) {
    final template = _strokeTemplate;
    if (template != null &&
        (template.isHighConfidence || template.isMediumConfidence)) {
      return HandwritingTemplateMatcher.templateOrderScore(
        strokes: strokes,
        template: template,
      );
    }
    if (strokes.length <= 1) return 1;
    final starts = strokes.map((stroke) => stroke.first).toList();
    final yThreshold = max(8.0, _canvasSize.height * 0.04);
    final xThreshold = max(8.0, _canvasSize.width * 0.04);
    var violations = 0;

    for (var i = 1; i < starts.length; i++) {
      final prev = starts[i - 1];
      final cur = starts[i];

      // Heuristic: common order is top-to-bottom.
      if (cur.dy + yThreshold < prev.dy) {
        violations += 1;
        continue;
      }

      // Secondary heuristic: when near the same row, usually left-to-right.
      final sameRow = (cur.dy - prev.dy).abs() <= yThreshold;
      if (sameRow && cur.dx + xThreshold < prev.dx) {
        violations += 1;
      }
    }

    final maxViolations = max(1, starts.length - 1);
    return 1.0 - (violations / maxViolations).clamp(0.0, 1.0);
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

  Future<void> _commitReviewIfNeeded() async {
    if (_hasCommitted || _evaluation == null) {
      return;
    }
    _hasCommitted = true;
    final language = ref.read(appLanguageProvider);
    final repo = ref.read(lessonRepositoryProvider);
    final mistakeRepo = ref.read(mistakeRepositoryProvider);
    final evaluation = _evaluation!;
    final isCorrect = evaluation.isCorrect;
    final grade = isCorrect ? (_showGuide ? 3 : 4) : 1;

    await repo.saveKanjiReview(kanjiId: _currentItem.id, grade: grade);

    if (isCorrect) {
      await mistakeRepo.markCorrect(type: 'kanji', itemId: _currentItem.id);
      return;
    }

    final meaning = _resolveMeaning(_currentItem, language);
    final prompt = meaning.isNotEmpty
        ? '${_currentItem.character} - $meaning'
        : _currentItem.character;
    await mistakeRepo.addMistake(
      type: 'kanji',
      itemId: _currentItem.id,
      context: MistakeContext(
        prompt: prompt,
        correctAnswer: _currentItem.character,
        userAnswer: language.handwritingStrokesDrawnLabel(
          evaluation.drawnStrokes,
        ),
        source: 'handwriting',
        extra: {
          'expectedStrokes': evaluation.expectedStrokes,
          'drawnStrokes': evaluation.drawnStrokes,
          'score': evaluation.score,
          'strokeScore': evaluation.strokeScore,
          'shapeScore': evaluation.shapeScore,
          'orderScore': evaluation.orderScore,
          'templateScore': evaluation.templateScore,
          'usedTemplate': evaluation.usedTemplate,
          'templateQuality': evaluation.templateQuality,
          'showGuide': _showGuide,
        },
      ),
    );
  }

  Future<void> _showSummary() async {
    await _commitReviewIfNeeded();
    if (!mounted) {
      return;
    }
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

  Future<void> _loadStrokeTemplate() async {
    if (widget.items.isEmpty) return;
    final template = await KanjiStrokeTemplateService.instance.getTemplate(
      _currentItem.character,
    );
    if (!mounted) return;
    setState(() {
      _strokeTemplate = template;
    });
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
                    ].join(' - '),
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
    required this.score,
    required this.strokeScore,
    required this.shapeScore,
    required this.orderScore,
    required this.templateScore,
    required this.usedTemplate,
    required this.templateQuality,
    required this.isCorrect,
  });

  final int expectedStrokes;
  final int drawnStrokes;
  final double score;
  final double strokeScore;
  final double shapeScore;
  final double orderScore;
  final double templateScore;
  final bool usedTemplate;
  final String templateQuality;
  final bool isCorrect;
}
