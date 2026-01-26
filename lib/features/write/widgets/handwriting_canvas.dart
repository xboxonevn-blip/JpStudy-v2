import 'package:flutter/material.dart';

class HandwritingCanvas extends StatelessWidget {
  const HandwritingCanvas({
    super.key,
    required this.strokes,
    required this.onStrokeStart,
    required this.onStrokeUpdate,
    required this.onStrokeEnd,
    required this.showGuide,
    required this.guideText,
    this.enabled = true,
  });

  final List<List<Offset>> strokes;
  final ValueChanged<Offset> onStrokeStart;
  final ValueChanged<Offset> onStrokeUpdate;
  final VoidCallback onStrokeEnd;
  final bool showGuide;
  final String guideText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: enabled
          ? (details) => onStrokeStart(details.localPosition)
          : null,
      onPanUpdate: enabled
          ? (details) => onStrokeUpdate(details.localPosition)
          : null,
      onPanEnd: enabled ? (_) => onStrokeEnd() : null,
      child: CustomPaint(
        painter: _HandwritingPainter(
          strokes: strokes,
          showGuide: showGuide,
          guideText: guideText,
          textStyle: Theme.of(context).textTheme.displayMedium,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _HandwritingPainter extends CustomPainter {
  _HandwritingPainter({
    required this.strokes,
    required this.showGuide,
    required this.guideText,
    required this.textStyle,
  });

  final List<List<Offset>> strokes;
  final bool showGuide;
  final String guideText;
  final TextStyle? textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    if (showGuide && guideText.trim().isNotEmpty) {
      _drawGuide(canvas, size);
    }
    _drawStrokes(canvas);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;
    final thirdW = size.width / 3;
    final thirdH = size.height / 3;
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(thirdW * i, 0),
        Offset(thirdW * i, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(0, thirdH * i),
        Offset(size.width, thirdH * i),
        paint,
      );
    }
    final borderPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(Offset.zero & size, borderPaint);
  }

  void _drawGuide(Canvas canvas, Size size) {
    final style = (textStyle ?? const TextStyle()).copyWith(
      fontSize: size.shortestSide * 0.6,
      color: const Color(0xFF1F2937).withValues(alpha: 0.12),
      fontWeight: FontWeight.w600,
    );
    final painter = TextPainter(
      text: TextSpan(text: guideText, style: style),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);
    final offset = Offset(
      (size.width - painter.width) / 2,
      (size.height - painter.height) / 2,
    );
    painter.paint(canvas, offset);
  }

  void _drawStrokes(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    for (final stroke in strokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HandwritingPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.showGuide != showGuide ||
        oldDelegate.guideText != guideText;
  }
}
