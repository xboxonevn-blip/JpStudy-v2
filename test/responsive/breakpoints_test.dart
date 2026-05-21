import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/responsive/breakpoints.dart';

void main() {
  test('maps widths to the four phase 6 breakpoints', () {
    expect(Breakpoints.fromWidth(360), Breakpoint.mobile);
    expect(Breakpoints.fromWidth(767), Breakpoint.mobile);
    expect(Breakpoints.fromWidth(768), Breakpoint.tabletPortrait);
    expect(Breakpoints.fromWidth(1023), Breakpoint.tabletPortrait);
    expect(Breakpoints.fromWidth(1024), Breakpoint.tabletLandscape);
    expect(Breakpoints.fromWidth(1279), Breakpoint.tabletLandscape);
    expect(Breakpoints.fromWidth(1280), Breakpoint.desktop);
  });
}
