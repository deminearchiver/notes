import 'dart:async';

import 'package:notes/widgets/safe_area.dart';
import 'package:notes/flutter.dart';

class ViewCard extends StatefulWidget {
  const ViewCard({super.key, this.shape, required this.child});

  final ShapeBorder? shape;

  final Widget child;

  @override
  State<ViewCard> createState() => ViewCardState();
}

class ViewCardState extends State<ViewCard> {
  final _cardKey = GlobalKey();

  final _layoutLink = SingleLeaderLayoutLink();

  _ViewCardRoute? _route;

  Future<void> openView(WidgetBuilder builder) async {
    if (!mounted) return;

    if (_route != null) return;

    final navigator = Navigator.of(context);
    final route = _ViewCardRoute(
      state: this,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      cardKey: _cardKey,
      shape: widget.shape,
      contentBuilder: (context) => widget.child,
      viewBuilder: builder,
    );
    setState(() => _route = route);
    await navigator.push(route);
  }

  // void _markNeedsBuild() {
  //   setState(() {});
  // }

  @override
  void dispose() {
    // if (_route case final route?) {
    //   route.navigator?.removeRoute(route);
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = ColorTheme.of(context);
    final shapeTheme = ShapeTheme.of(context);

    return SingleLayoutLeader(
      layoutLink: _layoutLink,
      child: Surface(
        key: _cardKey,
        clipBehavior: .antiAlias,
        shape: shapeTheme.applyCorner(corner: shapeTheme.cornerLarge),
        color: colorTheme.surfaceContainer,
        // shape: widget.shape,
        child: widget.child,
      ),
    );
  }
}

class _ViewCardRoute<T extends Object?> extends PageRoute<T> {
  _ViewCardRoute({
    required this.state,
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

  final ViewCardState state;

  final CapturedThemes capturedThemes;

  final GlobalKey cardKey;

  final ShapeBorder? shape;

  final WidgetBuilder contentBuilder;
  final WidgetBuilder viewBuilder;

  @override
  Color? get barrierColor => Colors.black.withValues(alpha: 0.32);

  @override
  String? get barrierLabel => null;

  @override
  final bool maintainState;

  @override
  void dispose() {
    state._route = null;
    super.dispose();
  }

  @override
  Widget buildModalBarrier() {
    final animation = CurvedAnimation(
      parent: this.animation!,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );

    Widget barrier;
    if (barrierColor != null && barrierColor!.a > 0.0 && !offstage) {
      // changedInternalState is called if barrierColor or offstage updates
      assert(barrierColor != barrierColor!.withValues(alpha: 0.0));
      final color = animation.drive(
        ColorTween(
          begin: barrierColor!.withValues(alpha: 0.0),
          end:
              barrierColor, // changedInternalState is called if barrierColor updates
        ).chain(
          CurveTween(curve: barrierCurve),
        ), // changedInternalState is called if barrierCurve updates
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
  final _shapeTween = ShapeBorderTween(end: const RoundedRectangleBorder());

  final opacitySequence = TweenSequence([
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 1,
        end: 0,
      ).chain(CurveTween(curve: const Interval(0, 0.5))),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 0,
        end: 1,
      ).chain(CurveTween(curve: const Interval(0.5, 1))),
      weight: 1,
    ),
  ]);

  void updateTweens() {
    final context = cardKey.currentContext;
    if (context != null) {
      final navigatorBox =
          Navigator.of(cardKey.currentContext!).context.findRenderObject()!
              as RenderBox;
      final cardBox = cardKey.currentContext!.findRenderObject()! as RenderBox;

      final cardRect = Rect.fromPoints(
        cardBox.localToGlobal(Offset.zero, ancestor: navigatorBox),
        cardBox.localToGlobal(
          cardBox.size.bottomRight(Offset.zero),
          ancestor: navigatorBox,
        ),
      );
      final navigatorRect = Rect.fromPoints(
        navigatorBox.localToGlobal(Offset.zero),
        navigatorBox.localToGlobal(navigatorBox.size.bottomRight(Offset.zero)),
      );
      _rectTween.begin = cardRect;
      _rectTween.end = navigatorRect;

      final theme = Theme.of(cardKey.currentContext!);
      _shapeTween.begin =
          shape ??
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
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );

    final navigatorBox =
        Navigator.of(cardKey.currentContext!).context.findRenderObject()!
            as RenderBox;
    final cardBox = cardKey.currentContext!.findRenderObject()! as RenderBox;

    final cardRect = Rect.fromPoints(
      cardBox.localToGlobal(Offset.zero, ancestor: navigatorBox),
      cardBox.localToGlobal(
        cardBox.size.bottomRight(Offset.zero),
        ancestor: navigatorBox,
      ),
    );
    final navigatorRect = Rect.fromPoints(
      navigatorBox.localToGlobal(Offset.zero),
      navigatorBox.localToGlobal(navigatorBox.size.bottomRight(Offset.zero)),
    );

    final content = contentBuilder(context);
    final view = viewBuilder(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final shouldSwitch = animation.value >= 0.5;

        final rect = _rectTween.evaluate(animation)!;

        final safeAreaFraction = lerpDouble(0, 1, animation.value);
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

// class _ViewCardRouteLayout extends SingleChildRenderObjectWidget {
//   const _ViewCardRouteLayout({super.key, required Widget super.child});

//   @override
//   _RenderViewCardRouteLayout createRenderObject(BuildContext context) => .new();
// }

// class _RenderViewCardRouteLayout extends RenderShiftedBox {
//   _RenderViewCardRouteLayout({RenderBox? child}) : super(child);

//   @override
//   bool get sizedByParent => true;

//   @override
//   Size computeDryLayout(covariant BoxConstraints constraints) =>
//       constraints.biggest;

//   @override
//   void performLayout() {
//     child?.layout(constraints);
//   }
// }
