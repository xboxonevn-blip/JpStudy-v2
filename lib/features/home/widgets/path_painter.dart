import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;

  PathPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];

      // Simple cubic bezier implementation for smooth curves
      final controlPoint1 = Offset(p1.dx, p1.dy + (p2.dy - p1.dy) / 2);
      final controlPoint2 = Offset(p2.dx, p2.dy - (p2.dy - p1.dy) / 2);

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p2.dx,
        p2.dy,
      );
    }

    // Draw the main path (thick background)
    canvas.drawPath(path, paint);

    // Draw dashed overlay (optional detailed look)
    final dashPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    _drawDashedPath(canvas, path, dashPaint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      var distance = 0.0;
      final dashWidth = 10.0;
      final dashSpace = 8.0;

      while (distance < metric.length) {
        final cutPath = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(cutPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
