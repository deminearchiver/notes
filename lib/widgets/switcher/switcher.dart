import 'package:sliver_tools/sliver_tools.dart';
import 'package:material/material.dart';

Widget minimumSizeLayoutBuilder(
    Widget? currentChild, List<Widget> previousChildren) {
  return Stack(
    children: [
      ...previousChildren.map(
        (child) => Align(
          alignment: Alignment.topLeft,
          widthFactor: 0,
          heightFactor: 0,
          child: child,
        ),
      ),
      if (currentChild != null) currentChild,
    ],
  );
}

enum _SwitcherVariant {
  fade,
  fadeThrough,
}

class Switcher extends StatelessWidget {
  const Switcher.fade({
    super.key,
    required this.duration,
    this.alignment = Alignment.topLeft,
    this.layoutBuilder,
    required this.child,
  })  : _variant = _SwitcherVariant.fade,
        _isSliver = false;

  const Switcher.fadeThrough({
    super.key,
    required this.duration,
    this.alignment = Alignment.topLeft,
    this.layoutBuilder,
    required this.child,
  })  : _variant = _SwitcherVariant.fadeThrough,
        _isSliver = false;

  const Switcher.sliverFade({
    super.key,
    required this.duration,
    this.alignment = Alignment.topLeft,
    this.layoutBuilder,
    required Widget sliver,
  })  : _variant = _SwitcherVariant.fade,
        _isSliver = true,
        child = sliver;

  const Switcher.sliverFadeThrough({
    super.key,
    required this.duration,
    this.alignment = Alignment.topLeft,
    this.layoutBuilder,
    required Widget sliver,
  })  : _variant = _SwitcherVariant.fadeThrough,
        _isSliver = true,
        child = sliver;

  final _SwitcherVariant _variant;
  final bool _isSliver;

  final Duration duration;

  final Alignment alignment;

  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  final Widget child;

  Widget defaultLayoutBuilder(
      Widget? currentChild, List<Widget> previousChildren) {
    return _isSliver
        ? SliverStack(
            // positionedAlignment: alignment,
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          )
        : Stack(
            alignment: alignment,
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
  }

  Widget fadeTransitionBuilder(
    Widget child,
    Animation<double> animation,
  ) {
    return _isSliver
        ? SliverFadeTransition(
            key: ValueKey<Key?>(child.key),
            opacity: animation,
            sliver: child,
          )
        : FadeTransition(
            key: ValueKey<Key?>(child.key),
            opacity: animation,
            child: child,
          );
  }

  Widget fadeThoughTransitionBuilder(
    Widget child,
    Animation<double> animation,
  ) {
    final opacityTween = Tween<double>(begin: 0, end: 1).chain(
      CurveTween(
        curve: const Interval(0.5, 1),
      ),
    );
    return AnimatedBuilder(
      key: ValueKey(child.key),
      animation: animation,
      child: child,
      builder: (context, child) {
        final double opacity =
            animation.value >= 0.5 ? opacityTween.evaluate(animation) : 0;
        return _isSliver
            ? SliverOpacity(
                opacity: opacity,
                sliver: child,
              )
            : Opacity(
                opacity: opacity,
                child: child,
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      layoutBuilder: layoutBuilder ?? defaultLayoutBuilder,
      transitionBuilder: switch (_variant) {
        _SwitcherVariant.fadeThrough => fadeThoughTransitionBuilder,
        _SwitcherVariant.fade => AnimatedSwitcher.defaultTransitionBuilder,
      },
      child: child,
    );
  }
}
