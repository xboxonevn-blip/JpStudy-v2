import 'package:flutter/animation.dart';

abstract final class AppMotionTokens {
  static const Duration instant = Duration.zero;
  static const Duration snap = Duration(milliseconds: 120);
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration smooth = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 360);

  static const Curve snapCurve = Curves.easeOutCubic;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.easeOutBack;
}
