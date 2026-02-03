import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  PathPainter({required this.points, required this.color});

  final List<Offset> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final path = _buildPath();
    final shaderRect = Rect.fromLTWH(0, 0, size.width, size.height);

    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final mainPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(color, const Color(0xFF60A5FA), 0.36) ??
              const Color(0xFF60A5FA),
          Color.lerp(color, const Color(0xFF3B82F6), 0.52) ??
              const Color(0xFF3B82F6),
          const Color(0xFF2563EB),
        ],
      ).createShader(shaderRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, trackPaint);
    canvas.drawPath(path, mainPaint);
    canvas.drawPath(path, highlightPaint);
  }

  Path _buildPath() {
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final cp1 = Offset(p1.dx, p1.dy + (p2.dy - p1.dy) * 0.5);
      final cp2 = Offset(p2.dx, p2.dy - (p2.dy - p1.dy) * 0.5);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
