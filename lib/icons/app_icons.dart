import 'package:notes/flutter.dart';

part 'app_icons.g.dart';

class const AppIconsScope({
  super.key,
  required final AppIconsDelegate delegate,
  required super.child,
}) extends InheritedWidget {
  @override
  bool updateShouldNotify(AppIconsScope oldWidget) =>
      delegate != oldWidget.delegate;

  static AppIconsDelegate? maybeDelegateOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppIconsScope>()?.delegate;

  static AppIconsDelegate delegateOf(BuildContext context) =>
      maybeDelegateOf(context) ?? const .luminousSymbols();
}

class const AppIcon(
  super.resolver, {
  super.key,
  super.roundness,
  super.fill,
  super.weight,
  super.grade,
  super.opticalSize,
  super.size,
  super.color,
  super.shadows,
  super.applyTextScaling,
  super.blendMode,
  super.semanticLabel,
  super.textDirection,
}) extends CustomIcon<AppIconResolver>;
