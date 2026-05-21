import 'package:flutter/widgets.dart';

enum Breakpoint { mobile, tabletPortrait, tabletLandscape, desktop }

abstract final class Breakpoints {
  static Breakpoint fromWidth(double width) {
    if (width < 768) return Breakpoint.mobile;
    if (width < 1024) return Breakpoint.tabletPortrait;
    if (width < 1280) return Breakpoint.tabletLandscape;
    return Breakpoint.desktop;
  }
}

class BreakpointBuilder extends StatelessWidget {
  const BreakpointBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, Breakpoint breakpoint) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, Breakpoints.fromWidth(constraints.maxWidth));
      },
    );
  }
}
