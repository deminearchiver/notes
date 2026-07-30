import 'package:material/material.dart';

enum WindowSizeClass {
  compact(600),
  medium(840),
  expanded(1200),
  large(1600),
  extraLarge(double.infinity);

  const WindowSizeClass(this.breakpoint);

  final double breakpoint;

  bool operator >(WindowSizeClass other) {
    return breakpoint > other.breakpoint;
  }

  bool operator >=(WindowSizeClass other) {
    return breakpoint >= other.breakpoint;
  }

  bool operator <(WindowSizeClass other) {
    return breakpoint < other.breakpoint;
  }

  bool operator <=(WindowSizeClass other) {
    return breakpoint <= other.breakpoint;
  }

  static WindowSizeClass fromWidth(double width) {
    return WindowSizeClass.values.reduce(
      (previous, current) => width < previous.breakpoint ? previous : current,
    );
  }

  static WindowSizeClass? maybeOf(BuildContext context) {
    final width = MediaQuery.maybeSizeOf(context)?.width;
    return width != null ? WindowSizeClass.fromWidth(width) : null;
  }

  static WindowSizeClass of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return WindowSizeClass.fromWidth(width);
  }
}

extension MediaQueryDataExtension on MediaQueryData {
  WindowSizeClass get windowSizeClass => WindowSizeClass.fromWidth(size.width);
}

extension SizeExtension on Size {
  WindowSizeClass get windowSizeClass => WindowSizeClass.fromWidth(width);
}

extension RectExtension on Rect {
  WindowSizeClass get windowSizeClass => WindowSizeClass.fromWidth(width);
}
