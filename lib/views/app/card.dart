import 'dart:ui';

import 'package:notes/widgets/safe_area.dart';
import 'package:material/material.dart';

class ViewCard extends StatefulWidget {
  const ViewCard({
    super.key,
    this.shape,
    required this.child,
  });

  final ShapeBorder? shape;

  final Widget child;

  static ViewCardState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<ViewCardState>();
  }

  static ViewCardState of(BuildContext context) {
    final result = maybeOf(context);
    return result!;
  }

  @override
  State<ViewCard> createState() => ViewCardState();
}

class ViewCardState extends State<ViewCard> {
  final _cardKey = GlobalKey();

  void openView(WidgetBuilder builder) {
    final navigator = Navigator.of(context);
    navigator.push(
      MaterialRoute.sharedAxis(
        builder: builder,
      ),
    );
    // navigator.push(
    //   _ItemCardRoute(
    //     capturedThemes: InheritedTheme.capture(
    //       from: context,
    //       to: navigator.context,
    //     ),
    //     cardKey: _cardKey,
    //     shape: widget.shape,
    //     contentBuilder: (context) => widget.child,
    //     viewBuilder: builder,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      key: _cardKey,
      shape: widget.shape,
      child: widget.child,
    );
  }
}

class _ItemCardRoute<T> extends PageRoute<T> {
  _ItemCardRoute({
    required this.capturedThemes,
    required this.cardKey,
    this.shape,
    required this.contentBuilder,
    required this.viewBuilder,
    super.barrierDismissible,
    // super.fullscreenDialog = true,
    this.maintainState = true,
    super.settings,
  });

  final CapturedThemes capturedThemes;

  final GlobalKey cardKey;

  final ShapeBorder? shape;

  final WidgetBuilder contentBuilder;
  final WidgetBuilder viewBuilder;

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.32);

  @override
  String? get barrierLabel => null;

  @override
  final bool maintainState;

  @override
  Widget buildModalBarrier() {
    final animation = CurvedAnimation(
      parent: this.animation!,
      curve: Easing.emphasized,
      reverseCurve: Easing.emphasized.flipped,
    );

    Widget barrier;
    if (barrierColor != null && barrierColor!.alpha != 0 && !offstage) {
      // changedInternalState is called if barrierColor or offstage updates
      assert(barrierColor != barrierColor!.withOpacity(0.0));
      final color = animation.drive(
        ColorTween(
          begin: barrierColor!.withOpacity(0.0),
          end:
              barrierColor, // changedInternalState is called if barrierColor updates
        ).chain(CurveTween(
            barrierCurve)), // changedInternalState is called if barrierCurve updates
      );
      barrier = AnimatedModalBarrier(
        color: color,
        dismissible:
            barrierDismissible, // changedInternalState is called if barrierDismissible updates
        semanticsLabel:
            barrierLabel, // changedInternalState is called if barrierLabel updates
        barrierSemanticsDismissible: semanticsDismissible,
      );
    } else {
      barrier = ModalBarrier(
        dismissible:
            barrierDismissible, // changedInternalState is called if barrierDismissible updates
        semanticsLabel:
            barrierLabel, // changedInternalState is called if barrierLabel updates
        barrierSemanticsDismissible: semanticsDismissible,
      );
    }

    return barrier;
  }

  @override
  Duration get transitionDuration => Durations.long4;
  // Duration get transitionDuration => const Duration(seconds: 3);

  @override
  Duration get reverseTransitionDuration => Durations.medium4;

  final _rectTween = RectTween();
  final _shapeTween = ShapeBorderTween(
    end: const RoundedRectangleBorder(),
  );

  final opacitySequence = TweenSequence([
    TweenSequenceItem(
      tween: Tween<double>(begin: 1, end: 0)
          .chain(CurveTween(const Interval(0, 0.5))),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: 0, end: 1)
          .chain(CurveTween(const Interval(0.5, 1))),
      weight: 1,
    ),
  ]);

  void updateTweens() {
    final context = cardKey.currentContext;
    if (context != null) {
      final navigatorBox = Navigator.of(cardKey.currentContext!)
          .context
          .findRenderObject()! as RenderBox;
      final cardBox = cardKey.currentContext!.findRenderObject()! as RenderBox;

      final cardRect = Rect.fromPoints(
        cardBox.localToGlobal(
          Offset.zero,
          ancestor: navigatorBox,
        ),
        cardBox.localToGlobal(cardBox.size.bottomRight(Offset.zero),
            ancestor: navigatorBox),
      );
      final navigatorRect = Rect.fromPoints(
        navigatorBox.localToGlobal(Offset.zero),
        navigatorBox.localToGlobal(
          navigatorBox.size.bottomRight(Offset.zero),
        ),
      );
      _rectTween.begin = cardRect;
      _rectTween.end = navigatorRect;

      final theme = Theme.of(cardKey.currentContext!);
      _shapeTween.begin = shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.outline),
          );
    }
  }

  @override
  TickerFuture didPush() {
    updateTweens();
    return super.didPush();
  }

  @override
  bool didPop(T? result) {
    updateTweens();
    return super.didPop(result);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> linearAnimation,
    Animation<double> _,
  ) {
    final animation = CurvedAnimation(
      parent: linearAnimation,
      curve: Easing.emphasized,
      reverseCurve: Easing.emphasized.flipped,
    );

    final navigatorBox = Navigator.of(cardKey.currentContext!)
        .context
        .findRenderObject()! as RenderBox;
    final cardBox = cardKey.currentContext!.findRenderObject()! as RenderBox;

    final cardRect = Rect.fromPoints(
      cardBox.localToGlobal(
        Offset.zero,
        ancestor: navigatorBox,
      ),
      cardBox.localToGlobal(cardBox.size.bottomRight(Offset.zero),
          ancestor: navigatorBox),
    );
    final navigatorRect = Rect.fromPoints(
      navigatorBox.localToGlobal(Offset.zero),
      navigatorBox.localToGlobal(
        navigatorBox.size.bottomRight(Offset.zero),
      ),
    );

    final content = contentBuilder(context);
    final view = viewBuilder(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final shouldSwitch = animation.value >= 0.5;

        final rect = _rectTween.evaluate(animation)!;

        final safeAreaFraction = lerpDouble(0, 1, animation.value)!;
        final opacity = opacitySequence.evaluate(animation);

        return Align(
          alignment: Alignment.topLeft,
          child: Transform.translate(
            offset: rect.topLeft,
            child: SizedBox(
              width: rect.width,
              height: rect.height,
              child: Card.outlined(
                shape: _shapeTween.evaluate(animation),
                child: Opacity(
                  opacity: opacity,
                  child: shouldSwitch
                      ? OverflowBox(
                          alignment: Alignment.topLeft,
                          maxWidth: navigatorRect.width,
                          maxHeight: navigatorRect.height,
                          child: RemoveSafeArea(
                            left: safeAreaFraction,
                            top: safeAreaFraction,
                            right: safeAreaFraction,
                            bottom: safeAreaFraction,
                            child: view,
                          ),
                        )
                      : Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: cardRect.width,
                            height: cardRect.height,
                            child: content,
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
