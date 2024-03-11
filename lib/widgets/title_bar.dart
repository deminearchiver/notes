import 'package:flutter/material.dart';
import 'package:notes/native.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({
    super.key,
    required this.backgroundColor,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    NativeService.setWindowCaptionColor(backgroundColor);
    return child;
  }
}

class AnimatedTitleBar extends ImplicitlyAnimatedWidget {
  const AnimatedTitleBar({
    super.key,
    required super.duration,
    required this.backgroundColor,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedTitleBarState();
}

class _AnimatedTitleBarState extends AnimatedWidgetBaseState<AnimatedTitleBar> {
  ColorTween? _backgroundColor;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _backgroundColor = visitor(
      _backgroundColor,
      widget.backgroundColor,
      (targetValue) => ColorTween(begin: targetValue),
    ) as ColorTween;
  }

  @override
  Widget build(BuildContext context) {
    NativeService.setWindowCaptionColor(
      _backgroundColor!.evaluate(animation)!,
    );
    return widget.child;
  }
}
