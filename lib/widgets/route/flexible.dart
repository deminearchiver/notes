import 'package:material/material.dart';

typedef FlexibleTransitionBuilder<T> = Widget Function(
  FlexibleTransitionRouteMixin<T> route,
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
);

mixin FlexibleTransitionRouteMixin<T> on ModalRoute<T> {
  FlexibleTransitionBuilder? _transitionBuilder;

  @override
  void didChangeNext(Route? nextRoute) {
    if (nextRoute is FlexibleTransitionRouteMixin &&
        canTransitionTo(nextRoute) &&
        navigator != null) {
      _transitionBuilder = nextRoute.buildFlexibleTransition;
    }
    super.didChangeNext(nextRoute);
  }

  @override
  void didPopNext(Route nextRoute) {
    if (nextRoute is FlexibleTransitionRouteMixin &&
        canTransitionTo(nextRoute) &&
        navigator != null) {
      _transitionBuilder = nextRoute.buildFlexibleTransition;
    }
    super.didPopNext(nextRoute);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (_transitionBuilder != null) {
      return _transitionBuilder!(
        this,
        context,
        animation,
        secondaryAnimation,
        child,
      );
    }
    return buildFlexibleTransition(
      this,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }

  Widget buildFlexibleTransition(
    FlexibleTransitionRouteMixin<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );

  @override
  bool didPop(result) {
    _transitionBuilder = null;
    return super.didPop(result);
  }
}
