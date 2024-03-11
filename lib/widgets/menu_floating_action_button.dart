import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/widgets/intrinsic_align.dart';
import 'package:material/material.dart';

enum _MenuFloatingActionButtonVariant {
  regular,
  large,
}

class MenuFloatingActionButton extends StatefulWidget {
  const MenuFloatingActionButton({
    super.key,
    required this.icon,
    required this.label,
  }) : _variant = _MenuFloatingActionButtonVariant.regular;
  const MenuFloatingActionButton.large({
    super.key,
    required this.icon,
    required this.label,
  }) : _variant = _MenuFloatingActionButtonVariant.large;

  final _MenuFloatingActionButtonVariant _variant;

  final Widget icon;
  final Widget label;

  @override
  State<MenuFloatingActionButton> createState() =>
      _MenuFloatingActionButtonState();
}

class _MenuFloatingActionButtonState extends State<MenuFloatingActionButton> {
  final _key = GlobalKey();
  bool _visible = true;

  void _openMenu() {
    Navigator.push(
      context,
      _MenuFloatingActionButtonRoute(
        key: _key,
        setVisible: _setVisible,
        variant: widget._variant,
        icon: widget.icon,
        label: widget.label,
      ),
    );
  }

  void _setVisible(bool value) {
    setState(() {
      _visible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility.maintain(
      visible: _visible,
      // maintainInteractivity: false,
      child: FloatingActionButton.large(
        key: _key,
        onPressed: _openMenu,
        child: widget.icon,
      ),
    );
  }
}

class _MenuFloatingActionButtonRoute extends PopupRoute {
  _MenuFloatingActionButtonRoute({
    // Internal
    required this.key,
    required this.setVisible,
    // Parent data
    required this.variant,
    required this.icon,
    required this.label,
    // Route
    super.filter,
    super.traversalEdgeBehavior,
    super.settings,
  });

  final GlobalKey key;
  final void Function(bool value) setVisible;

  final _MenuFloatingActionButtonVariant variant;
  final Widget icon;
  final Widget label;

  @override
  Color? get barrierColor => Colors.black26;

  @override
  String? get barrierLabel => null;

  @override
  bool get barrierDismissible => true;

  @override
  bool get maintainState => true;

  @override
  // Duration get transitionDuration => Durations.medium4;
  // Duration get transitionDuration => Durations.long2;
  Duration get transitionDuration => const Duration(seconds: 3);

  @override
  Duration get reverseTransitionDuration => Durations.medium4;

  @override
  TickerFuture didPush() {
    setVisible(false);
    animation?.addListener(_animationListener);
    return super.didPush();
  }

  @override
  void dispose() {
    animation?.removeListener(_animationListener);
    setVisible(true);
    super.dispose();
  }

  void _animationListener() {
    if (animation?.isDismissed ?? false) setVisible(true);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> linearAnimation,
    Animation<double> linearSecondaryAnimation,
  ) {
    final animation = CurvedAnimation(
      parent: linearAnimation,
      curve: Easing.emphasized,
      reverseCurve: Easing.emphasized.flipped,
    );

    final theme = Theme.of(context);

    final box = key.currentContext!.findRenderObject()! as RenderBox;
    final navigatorBox =
        Navigator.of(context).context.findRenderObject()! as RenderBox;

    final borderRadiusTween = BorderRadiusTween(
      begin: BorderRadius.circular(28),
      end: BorderRadius.circular(16),
    );
    final iconSizeTween = Tween<double>(begin: 36, end: 24);
    final linearTween = Tween<double>(begin: 0, end: 1);

    final enterInterval = CurveTween(curve: const Interval(0, 0.5));
    final exitInterval = CurveTween(curve: const Interval(0.5, 1));
    final enterOpacityTween =
        Tween<double>(begin: 1, end: 0).chain(enterInterval);
    final exitOpacityTween =
        Tween<double>(begin: 0, end: 1).chain(exitInterval);
    return Align(
      alignment: Alignment.bottomRight,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final borderRadius = borderRadiusTween.evaluate(animation)!;
          final iconSize = variant == _MenuFloatingActionButtonVariant.large
              ? iconSizeTween.evaluate(animation)
              : 24.0;
          final widget = Transform.translate(
            offset: box.localToGlobal(box.size.bottomRight(Offset.zero)) -
                navigatorBox.size.bottomRight(Offset.zero),
            child: Card.elevated(
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...<(IconData, String)>[
                      (Symbols.note_add_rounded, "Заметка"),
                      (Symbols.add_task_rounded, "Задача"),
                    ].map(
                      (item) => IntrinsicAlign(
                        alignment: Alignment.bottomCenter,
                        widthFactor: linearTween.evaluate(animation),
                        heightFactor: linearTween.evaluate(animation),
                        child: InkWell(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialRoute.zoom(
                              builder: (context) => Scaffold(
                                appBar: AppBar(),
                              ),
                            ),
                          ),
                          child: Padding(
                            // padding: const EdgeInsets.only(left: 16, right: 20),
                            padding: const EdgeInsets.fromLTRB(16, 16, 20, 16),
                            child: Row(
                              children: [
                                Icon(
                                  item.$1,
                                  color: theme.colorScheme.onSurface,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  item.$2,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card.filled(
                      color: theme.colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: borderRadius),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsetsGeometryTween(
                            begin: const EdgeInsets.all(30),
                            end: const EdgeInsetsDirectional.fromSTEB(
                              16,
                              16,
                              20,
                              16,
                            ),
                          ).evaluate(animation),
                          child: Row(
                            children: [
                              IconTheme.merge(
                                data: IconThemeData(
                                  size: iconSize,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                                child: Opacity(
                                  opacity: animation.value >= 0.5
                                      ? exitOpacityTween.evaluate(animation)
                                      : enterOpacityTween.evaluate(animation),
                                  child: animation.value >= 0.5
                                      ? const Icon(Symbols.arrow_back_rounded)
                                      : icon,
                                ),
                              ),
                              IntrinsicAlign(
                                widthFactor: linearTween.evaluate(animation),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Opacity(
                                    opacity:
                                        exitOpacityTween.evaluate(animation),
                                    child: DefaultTextStyle(
                                      style:
                                          theme.textTheme.labelLarge!.copyWith(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                      ),
                                      child: label,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          return !animation.isCompleted &&
                  animation.status == AnimationStatus.reverse
              ? IgnorePointer(
                  child: widget,
                )
              : widget;
        },
      ),
    );
  }
}
