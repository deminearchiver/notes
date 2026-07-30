part of 'route.dart';

enum _MaterialRouteVariant {
  zoom,
  sharedAxis,
}

sealed class _MaterialRouteModel<T> {
  const _MaterialRouteModel(this.variant);

  final _MaterialRouteVariant variant;

  Duration get duration;

  Widget buildTransitions(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );
}

class _ZoomMaterialRouteModel<T> extends _MaterialRouteModel<T> {
  _ZoomMaterialRouteModel() : super(_MaterialRouteVariant.zoom);

  @override
  Duration get duration => Durations.medium2;

  @override
  Widget buildTransitions(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const builder = ZoomPageTransitionsBuilder(
      allowSnapshotting: false,
      allowEnterRouteSnapshotting: false,
    );
    return builder.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}

class _SharedAxisMaterialRouteModel<T> extends _MaterialRouteModel<T> {
  _SharedAxisMaterialRouteModel({
    required this.axis,
    required this.reverse,
  }) : super(_MaterialRouteVariant.sharedAxis);

  final Axis axis;
  final bool reverse;

  @override
  Duration get duration => Durations.long4;

  double get _offset => reverse ? -32.0 : 32.0;
  final _exitInterval = CurveTween(curve: const Interval(0, 0.5));
  final _enterInterval = CurveTween(curve: const Interval(0.5, 1));

  Offset get _enterOffset => switch (axis) {
        Axis.horizontal => Offset(_offset, 0),
        Axis.vertical => Offset(0, _offset),
      };
  Offset get _exitOffset => switch (axis) {
        Axis.horizontal => Offset(-_offset, 0),
        Axis.vertical => Offset(0, -_offset),
      };

  @override
  Widget buildTransitions(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    animation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );
    secondaryAnimation = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );

    final exitOffsetTween = Tween<Offset>(
      begin: Offset.zero,
      end: _exitOffset,
    ).chain(_exitInterval);
    final enterOffsetTween = Tween<Offset>(
      begin: _enterOffset,
      end: Offset.zero,
    ).chain(_enterInterval);

    final exitOpacityTween = Tween<double>(
      begin: 1,
      end: 0,
    ).chain(_exitInterval);
    final enterOpacityTween = Tween<double>(
      begin: 0,
      end: 1,
    ).chain(_enterInterval);

    return Align(
      alignment: Alignment.topLeft,
      child: Transform.translate(
        offset: exitOffsetTween.evaluate(secondaryAnimation) +
            enterOffsetTween.evaluate(animation),
        child: Opacity(
          opacity: exitOpacityTween.evaluate(secondaryAnimation) *
              enterOpacityTween.evaluate(animation),
          child: _MaterialRouteScope(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _MaterialRouteScope extends InheritedWidget {
  const _MaterialRouteScope({
    required this.animation,
    required this.secondaryAnimation,
    required super.child,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;

  @override
  bool updateShouldNotify(covariant _MaterialRouteScope oldWidget) {
    return animation != oldWidget.animation ||
        secondaryAnimation != oldWidget.secondaryAnimation;
  }

  static _MaterialRouteScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_MaterialRouteScope>();
  }

  static _MaterialRouteScope of(BuildContext context) {
    final result = maybeOf(context);
    return result!;
  }
}
