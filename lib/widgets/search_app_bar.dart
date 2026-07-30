import 'dart:ui';

import 'package:material/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/widgets/fractional_stadium_border.dart';

class AppBarSearchController {
  _AppBarSearchState? _state;
  void _attach(_AppBarSearchState state) {
    _state = state;
  }

  void _detach(_AppBarSearchState state) {
    if (_state == state) {
      _state = null;
    }
  }

  void openView() {
    assert(_state != null);
    _state!._openView();
  }
}

class AppBarSearch extends StatefulWidget {
  const AppBarSearch({
    super.key,
    this.controller,
    required this.appBarKey,
    required this.builder,
  });

  final AppBarSearchController? controller;

  final GlobalKey appBarKey;

  final Widget Function(BuildContext context, AppBarSearchController controller)
      builder;

  @override
  State<AppBarSearch> createState() => _AppBarSearchState();
}

class _AppBarSearchState extends State<AppBarSearch> {
  AppBarSearchController? _internalController;
  AppBarSearchController get _controller =>
      widget.controller ?? _internalController!;

  final _anchorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = AppBarSearchController().._attach(this);
    }
    _controller._attach(this);
  }

  @override
  void didUpdateWidget(covariant AppBarSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      if (widget.controller != null) {
        _internalController?._detach(this);
        _internalController = null;
        widget.controller?._attach(this);
      } else {
        assert(_internalController == null);
        _internalController = AppBarSearchController().._attach(this);
      }
    }
    assert(_controller._state == this);
  }

  @override
  void dispose() {
    _controller._detach(this);
    _internalController = null;
    super.dispose();
  }

  void _openView() {
    final navigator = Navigator.of(context);
    navigator.push(
      _AppBarSearchViewRoute(
        appBarKey: widget.appBarKey,
        anchorKey: _anchorKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.builder(context, _controller);
    return KeyedSubtree(
      key: _anchorKey,
      child: child,
    );
  }
}

class _AppBarSearchViewRoute<T> extends PopupRoute<T> {
  _AppBarSearchViewRoute({
    required this.appBarKey,
    required this.anchorKey,
  });

  final GlobalKey anchorKey;
  final GlobalKey appBarKey;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => Durations.long4;
  // Duration get transitionDuration => Duration(seconds: 5);

  @override
  Duration get reverseTransitionDuration => Durations.short2;

  Rect? _getViewportRect() {
    final context = anchorKey.currentContext;
    if (context != null) {
      final navigator = Navigator.of(context);
      final navigatorBox = navigator.context.findRenderObject()! as RenderBox;
      return navigatorBox.localToGlobal(Offset.zero) & navigatorBox.size;
    }
    return null;
  }

  Rect? _getAnchorRect() {
    final context = anchorKey.currentContext;
    if (context != null) {
      final anchorBox = context.findRenderObject()! as RenderBox;
      final navigator = Navigator.of(context);
      return anchorBox.localToGlobal(
            Offset.zero,
            ancestor: navigator.context.findRenderObject(),
          ) &
          anchorBox.size;
    }
    return null;
  }

  Rect? _getAppBarRect() {
    final context = appBarKey.currentContext;
    if (context != null) {
      final appBarBox = context.findRenderObject()! as RenderBox;
      final navigator = Navigator.of(context);
      return appBarBox.localToGlobal(
            Offset.zero,
            ancestor: navigator.context.findRenderObject(),
          ) &
          appBarBox.size;
    }
    return null;
  }

  Widget buildOpenTransition(
    BuildContext context,
    Animation<double> animation,
  ) {
    animation = CurvedAnimation(
      parent: OneSidedAnimation(
        parent: animation,
        direction: AnimationDirection.forward,
      ),
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );
    final isReverse = animation.status == AnimationStatus.reverse;

    final theme = Theme.of(context);
    final padding = MediaQuery.paddingOf(context);

    final viewportRect = _getViewportRect()!;
    final appBarRectWithPadding = _getAppBarRect()!;
    final appBarRect = Rect.fromLTRB(
      appBarRectWithPadding.left,
      appBarRectWithPadding.top + padding.top,
      appBarRectWithPadding.right,
      appBarRectWithPadding.bottom,
    );

    const kSearchBarHeight = 56.0;
    const kSearchBarPadding = 36.0;
    final searchBarVerticalPadding = (appBarRect.height - kSearchBarHeight) / 2;

    final searchBarRect = Rect.fromLTWH(
      kSearchBarPadding,
      appBarRect.top + searchBarVerticalPadding,
      appBarRect.width - kSearchBarPadding * 2,
      kSearchBarHeight,
    );

    final rectTween = RectTween(
      begin: searchBarRect,
      end: viewportRect,
    );
    final borderRadiusTween = BorderRadiusTween(
      begin: const BorderRadius.all(
        Radius.circular(56),
      ),
      end: BorderRadius.zero,
    );

    final colorTween = ColorTween(
      begin: theme.colorScheme.surfaceContainerHighest.withOpacity(0),
      end: theme.colorScheme.surfaceContainerHighest,
    ).chain(
      CurveTween(curve: const Interval(0, 2 / 3)),
    );
    final forwardTween = Tween<double>(begin: 0, end: 1);
    final searchBarOpacityTween = forwardTween.chain(
      CurveTween(curve: const Interval(0, 1 / 3)),
    );

    final viewOffsetTween = Tween<Offset>(
      begin: const Offset(0, -16),
      end: Offset.zero,
    ).chain(
      CurveTween(curve: const Interval(2 / 3, 1)),
    );
    final viewOpacityTween = forwardTween.chain(
      CurveTween(curve: const Interval(2 / 3, 1)),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final rect = rectTween.evaluate(animation)!;
        final borderRadius = borderRadiusTween.evaluate(animation)!;
        return Align(
          alignment: Alignment.topLeft,
          child: Transform.translate(
            offset: rect.topLeft,
            child: SizedBox(
              width: rect.width,
              height: rect.height,
              child: Material(
                clipBehavior: Clip.antiAlias,
                animationDuration: Duration.zero,
                borderRadius: borderRadius,
                color: colorTween.evaluate(animation),
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  minWidth: 0,
                  maxWidth: viewportRect.width,
                  minHeight: 0,
                  maxHeight: viewportRect.height,
                  child: Transform.translate(
                    offset: -rect.topLeft,
                    child: SizedBox(
                      width: viewportRect.width,
                      height: viewportRect.height,
                      child: SafeArea(
                        top: false,
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: Column(
                            children: [
                              Opacity(
                                opacity:
                                    searchBarOpacityTween.evaluate(animation),
                                child: Material(
                                  type: MaterialType.transparency,
                                  animationDuration: Duration.zero,
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  shape: Border(
                                      bottom: BorderSide(
                                    color: theme.colorScheme.outline,
                                  )),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: padding.top),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        height: 72,
                                        child: InkWell(
                                          onTap: () {},
                                          customBorder: const StadiumBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  icon: const Icon(Symbols
                                                      .arrow_back_rounded),
                                                ),
                                                const Gap(8),
                                                Expanded(
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      hintText: "Search",
                                                    ).applyDefaults(
                                                        InputDecorationTheme(
                                                      hintStyle: theme
                                                          .textTheme.bodyLarge!
                                                          .copyWith(
                                                        color: theme.colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      isDense: true,
                                                    )),
                                                    textInputAction:
                                                        TextInputAction.search,
                                                    keyboardType:
                                                        TextInputType.text,
                                                  ),
                                                ),
                                                const Gap(8),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                      Symbols.clear_rounded),
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
                              Expanded(
                                child: Transform.translate(
                                  offset: viewOffsetTween.evaluate(animation),
                                  child: Opacity(
                                    opacity:
                                        viewOpacityTween.evaluate(animation),
                                    child: ListView.builder(
                                      itemBuilder: (context, index) => ListTile(
                                        onTap: () => Navigator.pop(context),
                                        leading:
                                            const Icon(Symbols.history_rounded),
                                        title: Text("Result ${index + 1}"),
                                      ),
                                    ),
                                  ),
                                ),
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
          ),
        );
      },
    );
  }

  Widget buildCloseTransition(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    animation = OneSidedAnimation(
      parent: animation,
      direction: AnimationDirection.reverse,
    );
    final opacityTween = Tween<double>(begin: 0, end: 1);

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) => Opacity(
        opacity: opacityTween.evaluate(animation),
        child: child!,
      ),
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> _,
  ) {
    CurvedAnimation;
    final openTransition = buildOpenTransition(context, animation);
    return buildCloseTransition(
      context,
      animation,
      openTransition,
    );
  }
}

enum AnimationDirection {
  forward,
  reverse,
}

class OneSidedAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  OneSidedAnimation({
    required this.parent,
    required this.direction,
  })  : _previousStatus = parent.status,
        _frozen = switch (direction) {
          AnimationDirection.forward =>
            parent.status == AnimationStatus.completed ||
                parent.status == AnimationStatus.reverse,
          AnimationDirection.reverse =>
            parent.status == AnimationStatus.dismissed ||
                parent.status == AnimationStatus.forward,
        } {
    parent.addStatusListener(_statusListener);
  }

  @override
  final Animation<double> parent;

  final AnimationDirection direction;

  bool _frozen = false;
  AnimationStatus _previousStatus;

  @override
  AnimationStatus get status => _frozen
      ? switch (direction) {
          AnimationDirection.forward => AnimationStatus.completed,
          AnimationDirection.reverse => AnimationStatus.dismissed,
        }
      : parent.status;

  void _statusListener(AnimationStatus status) {
    switch (direction) {
      case AnimationDirection.forward:
        if (_previousStatus == AnimationStatus.forward &&
            status == AnimationStatus.completed) {
          _frozen = true;
        } else if (_previousStatus == AnimationStatus.reverse &&
            status == AnimationStatus.dismissed) {
          _frozen = false;
        }
      case AnimationDirection.reverse:
        if (_previousStatus == AnimationStatus.reverse &&
            status == AnimationStatus.dismissed) {
          _frozen = true;
        } else if (_previousStatus == AnimationStatus.forward &&
            status == AnimationStatus.completed) {
          _frozen = false;
        }
    }
    _previousStatus = status;
  }

  @override
  double get value {
    switch (direction) {
      case AnimationDirection.forward:
        if (_frozen) return 1;
      case AnimationDirection.reverse:
        if (_frozen) {
          if (parent.status == AnimationStatus.forward) return 1;
          return 0;
        }
    }
    return parent.value;
  }
}
