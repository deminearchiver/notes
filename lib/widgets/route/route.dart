import 'package:material/material.dart';
import 'flexible.dart';

part 'models.dart';

class MaterialRoute<T> extends PageRoute<T>
    with FlexibleTransitionRouteMixin<T> {
  static Animation<double> animationOf(BuildContext context) {
    return _MaterialRouteScope.of(context).animation;
  }

  static Animation<double> secondaryAnimationOf(BuildContext context) {
    return _MaterialRouteScope.of(context).secondaryAnimation;
  }

  MaterialRoute.zoom({
    this.maintainState = true,
    required this.builder,
  })  : _model = _ZoomMaterialRouteModel(),
        super(allowSnapshotting: false);

  MaterialRoute.sharedAxis({
    super.settings,
    this.maintainState = true,
    Axis axis = Axis.horizontal,
    bool reverse = false,
    required this.builder,
  })  : _model = _SharedAxisMaterialRouteModel(
          axis: axis,
          reverse: reverse,
        ),
        super(allowSnapshotting: false);

  final _MaterialRouteModel<T> _model;
  final WidgetBuilder builder;

  @override
  final bool maintainState;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => _model.duration;

  @override
  bool canTransitionFrom(TransitionRoute previousRoute) {
    return previousRoute is FlexibleTransitionRouteMixin;
  }

  @override
  bool canTransitionTo(TransitionRoute nextRoute) {
    if (controller != null && controller!.isAnimating) {
      return false;
    }
    return nextRoute is FlexibleTransitionRouteMixin;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildFlexibleTransition(
    FlexibleTransitionRouteMixin<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route is! PageRoute<T>) throw Error();

    final transition = _model.buildTransitions(
      route as PageRoute<T>,
      context,
      animation,
      secondaryAnimation,
      child,
    );
    return animation.isCompleted && secondaryAnimation.isDismissed
        ? transition
        : IgnorePointer(
            child: transition,
          );
  }
}
