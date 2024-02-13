import 'package:flutter/foundation.dart';
import 'package:notes/widgets/icon.dart';
import 'package:true_material/material.dart';

class InteractiveIconScope extends StatefulWidget {
  const InteractiveIconScope({
    super.key,
    this.enabled = true,
    this.selected = false,
    required this.child,
  });

  final bool enabled;
  final bool selected;

  final Widget child;

  @override
  State<InteractiveIconScope> createState() => _InteractiveIconScopeState();

  static Set<MaterialState>? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InteractiveIconProvider>()
        ?.states;
  }

  static Set<MaterialState> of(BuildContext context) {
    final result = maybeOf(context);
    return result!;
  }
}

class _InteractiveIconScopeState extends State<InteractiveIconScope> {
  late MaterialStatesController _statesController;

  @override
  void initState() {
    super.initState();
    _statesController = MaterialStatesController({
      if (widget.selected) MaterialState.selected,
      if (!widget.enabled) MaterialState.disabled,
    })
      ..addListener(_statesListener);
  }

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  void _statesListener() {
    setState(() {});
  }

  @override
  void didUpdateWidget(InteractiveIconScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _statesController.update(MaterialState.selected, widget.selected);
    }
    if (oldWidget.enabled != widget.enabled) {
      _statesController.update(MaterialState.disabled, !widget.enabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _statesController.update(MaterialState.hovered, true),
      onExit: (event) => _statesController.update(MaterialState.hovered, false),
      child: Listener(
        onPointerDown: (event) =>
            _statesController.update(MaterialState.pressed, true),
        onPointerUp: (event) =>
            _statesController.update(MaterialState.pressed, false),
        child: _InteractiveIconProvider(
          states: _statesController.value,
          child: widget.child,
        ),
      ),
    );
  }
}

class _InteractiveIconProvider extends InheritedWidget {
  const _InteractiveIconProvider({
    super.key,
    required this.states,
    required super.child,
  });

  final Set<MaterialState> states;

  @override
  bool updateShouldNotify(_InteractiveIconProvider oldWidget) {
    return setEquals(oldWidget.states, states);
  }
}

class InteractiveIcon extends StatelessWidget {
  const InteractiveIcon(
    this.icon, {
    super.key,
    this.color,
    this.fill,
    this.weight,
  });

  final IconData icon;

  final MaterialStateProperty<Color?>? color;
  final MaterialStateProperty<double>? weight;
  final MaterialStateProperty<double>? fill;

  @override
  Widget build(BuildContext context) {
    final states = InteractiveIconScope.of(context);

    final defaults = _InteractiveIconDefaults(context);

    final color = this.color ?? defaults.color;
    final weight = this.weight ?? defaults.weight;
    final fill = this.fill ?? defaults.fill;

    return TweenedIcon(
      duration: Durations.short3,
      curve: Easing.standard,
      // Pre-defined
      icon: icon,
      color: color.resolve(states),
      fill: fill.resolve(states),
      // Dynamic
      weight: weight.resolve(states),
    );
  }
}

final class _InteractiveIconDefaults {
  const _InteractiveIconDefaults(this.context);

  final BuildContext context;
  ThemeData get theme => Theme.of(context);

  MaterialStateProperty<Color?> get color =>
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) return theme.disabledColor;
        return null;
      });
  MaterialStateProperty<double> get weight =>
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return states.contains(MaterialState.pressed)
              ? 300
              : states.contains(MaterialState.hovered)
                  ? 400
                  : 700;
        }
        return states.contains(MaterialState.pressed)
            ? 200
            : states.contains(MaterialState.hovered)
                ? 700
                : 400;
      });
  MaterialStateProperty<double> get fill =>
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return 1;
        return 0;
      });
}
