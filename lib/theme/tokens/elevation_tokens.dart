import 'package:flutter/material.dart';

abstract final class AppElevationTokens {
  static const double dp0 = 0;
  static const double dp1 = 1;
  static const double dp2 = 2;
  static const double dp4 = 4;
  static const double dp8 = 8;

  static const List<double> dp = <double>[dp0, dp1, dp2, dp4, dp8];

  static const List<BoxShadow> shadowDp0 = <BoxShadow>[];
  static const List<BoxShadow> shadowDp1 = <BoxShadow>[
    BoxShadow(color: Color(0x142C3F59), blurRadius: 6, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> shadowDp2 = <BoxShadow>[
    BoxShadow(color: Color(0x182C3F59), blurRadius: 10, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> shadowDp4 = <BoxShadow>[
    BoxShadow(color: Color(0x1C2C3F59), blurRadius: 18, offset: Offset(0, 8)),
  ];
  static const List<BoxShadow> shadowDp8 = <BoxShadow>[
    BoxShadow(color: Color(0x242C3F59), blurRadius: 28, offset: Offset(0, 14)),
  ];
}
