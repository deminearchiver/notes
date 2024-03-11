import 'dart:ui';

import 'package:notes/widgets/safe_area.dart';
import 'package:material/material.dart';

class ExpandableFloatingActionButton extends StatefulWidget {
  const ExpandableFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  final VoidCallback? onPressed;

  final Widget icon;
  final Widget label;

  static ExpandableFloatingActionButtonState? maybeOf(BuildContext context) {
    return context
        .findAncestorStateOfType<ExpandableFloatingActionButtonState>();
  }

  static ExpandableFloatingActionButtonState of(BuildContext context) {
    final result = maybeOf(context);
    return result!;
  }

  @override
  State<ExpandableFloatingActionButton> createState() =>
      ExpandableFloatingActionButtonState();
}

class ExpandableFloatingActionButtonState
    extends State<ExpandableFloatingActionButton> {
  final _buttonKey = GlobalKey();

  Future<T?> openView<T>(Widget child) {
    final navigator = Navigator.of(context);
    return navigator.push<T>(
      _FloatingActionButtonRoute(
        buttonKey: _buttonKey,
        icon: widget.icon,
        label: widget.label,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      key: _buttonKey,
      onPressed: widget.onPressed,
      icon: widget.icon,
      label: widget.label,
    );
  }
}

class _FloatingActionButtonRoute<T> extends PageRoute<T> {
  _FloatingActionButtonRoute({
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.child,
    this.maintainState = true,
    super.allowSnapshotting = false,
    super.fullscreenDialog = true,
    super.settings,
  });

  final GlobalKey buttonKey;

  final Widget icon;
  final Widget label;

  final Widget child;

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => null;

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => Durations.long4;
  // Duration get transitionDuration => const Duration(seconds: 3);

  @override
  Widget buildPage(BuildContext context, Animation<double> linearAnimation,
      Animation<double> _) {
    final animation = CurvedAnimation(
      parent: linearAnimation,
      curve: Easing.emphasized,
      reverseCurve: Easing.emphasized.flipped,
    );
    final navigatorBox = Navigator.of(buttonKey.currentContext!)
        .context
        .findRenderObject()! as RenderBox;
    final navigatorRect =
        navigatorBox.localToGlobal(Offset.zero) & navigatorBox.size;

    final buttonBox =
        buttonKey.currentContext!.findRenderObject()! as RenderBox;

    final buttonRect =
        buttonBox.localToGlobal(Offset.zero, ancestor: navigatorBox) &
            buttonBox.size;

    final rectTween = RectTween(
      begin: buttonRect,
      end: navigatorRect,
    );

    final theme = Theme.of(context);

    final borderRadiusTween = BorderRadiusTween(
      begin: BorderRadius.circular(16),
      end: BorderRadius.zero,
    );

    final opacitySequence = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0).chain(
          CurveTween(
            curve: const Interval(0, 1 / 3),
          ),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1 / 3, end: 1).chain(
          CurveTween(
            curve: const Interval(0.5, 1),
          ),
        ),
        weight: 1,
      ),
    ]);

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final rect = rectTween.evaluate(animation)!;
        final safeAreaMargin = lerpDouble(0, 1, animation.value)!;

        final shouldSwitch = animation.value >= 0.5;

        return Align(
          alignment: Alignment.topLeft,
          child: Transform.translate(
            offset: rect.topLeft,
            child: SizedBox(
              width: rect.width,
              height: rect.height,
              child: Material(
                type: MaterialType.button,
                shadowColor: theme.colorScheme.shadow,
                elevation: 6,
                clipBehavior: Clip.antiAlias,
                animationDuration: Duration.zero,
                color: theme.colorScheme.primaryContainer,
                borderRadius: borderRadiusTween.evaluate(animation),
                child: Opacity(
                  opacity: opacitySequence.evaluate(animation),
                  child: shouldSwitch
                      ? OverflowBox(
                          alignment: Alignment.topLeft,
                          maxWidth: navigatorRect.width,
                          maxHeight: navigatorRect.height,
                          child: RemoveSafeArea(
                            left: safeAreaMargin,
                            top: safeAreaMargin,
                            right: safeAreaMargin,
                            bottom: safeAreaMargin,
                            child: child!,
                          ),
                        )
                      : Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              width: buttonRect.width,
                              height: buttonRect.height,
                              child: Row(
                                children: [
                                  IconTheme.merge(
                                    data: IconThemeData(
                                        color: theme
                                            .colorScheme.onPrimaryContainer),
                                    child: icon,
                                  ),
                                  const SizedBox(width: 8),
                                  DefaultTextStyle.merge(
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                    child: label,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
