// import 'package:notes/flutter.dart';

// class InteractiveIconScope extends StatefulWidget {
//   const InteractiveIconScope({
//     super.key,
//     this.enabled = true,
//     this.selected = false,
//     required this.child,
//   });

//   final bool enabled;
//   final bool selected;

//   final Widget child;

//   @override
//   State<InteractiveIconScope> createState() => _InteractiveIconScopeState();

//   static Set<WidgetState>? maybeOf(BuildContext context) {
//     return context
//         .dependOnInheritedWidgetOfExactType<_InteractiveIconProvider>()
//         ?.states;
//   }

//   static Set<WidgetState> of(BuildContext context) {
//     final result = maybeOf(context);
//     return result!;
//   }
// }

// class _InteractiveIconScopeState extends State<InteractiveIconScope> {
//   late WidgetStatesController _statesController;

//   @override
//   void initState() {
//     super.initState();
//     _statesController = WidgetStatesController({
//       if (widget.selected) WidgetState.selected,
//       if (!widget.enabled) WidgetState.disabled,
//     })
//       ..addListener(_statesListener);
//   }

//   @override
//   void dispose() {
//     _statesController.dispose();
//     super.dispose();
//   }

//   void _statesListener() {
//     setState(() {});
//   }

//   @override
//   void didUpdateWidget(InteractiveIconScope oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.selected != widget.selected) {
//       _statesController.update(WidgetState.selected, widget.selected);
//     }
//     if (oldWidget.enabled != widget.enabled) {
//       _statesController.update(WidgetState.disabled, !widget.enabled);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (event) => _statesController.update(WidgetState.hovered, true),
//       onExit: (event) => _statesController.update(WidgetState.hovered, false),
//       child: Listener(
//         onPointerDown: (event) =>
//             _statesController.update(WidgetState.pressed, true),
//         onPointerUp: (event) =>
//             _statesController.update(WidgetState.pressed, false),
//         child: _InteractiveIconProvider(
//           states: _statesController.value,
//           child: widget.child,
//         ),
//       ),
//     );
//   }
// }

// class _InteractiveIconProvider extends InheritedWidget {
//   const _InteractiveIconProvider({
//     super.key,
//     required this.states,
//     required super.child,
//   });

//   final Set<WidgetState> states;

//   @override
//   bool updateShouldNotify(_InteractiveIconProvider oldWidget) {
//     return setEquals(oldWidget.states, states);
//   }
// }

// class InteractiveIcon extends StatelessWidget {
//   const InteractiveIcon(
//     this.icon, {
//     super.key,
//     this.color,
//     this.fill,
//     this.weight,
//   });

//   final IconData icon;

//   final WidgetStateProperty<Color?>? color;
//   final WidgetStateProperty<double>? weight;
//   final WidgetStateProperty<double>? fill;

//   @override
//   Widget build(BuildContext context) {
//     final states = InteractiveIconScope.of(context);

//     final defaults = _InteractiveIconDefaults(context);

//     final color = this.color ?? defaults.color;
//     final weight = this.weight ?? defaults.weight;
//     final fill = this.fill ?? defaults.fill;

//     return TweenedIcon(
//       duration: Durations.short3,
//       curve: Easing.standard,
//       // Pre-defined
//       icon: icon,
//       color: color.resolve(states),
//       fill: fill.resolve(states),
//       // Dynamic
//       weight: weight.resolve(states),
//     );
//   }
// }

// final class _InteractiveIconDefaults {
//   const _InteractiveIconDefaults(this.context);

//   final BuildContext context;
//   ThemeData get theme => Theme.of(context);

//   WidgetStateProperty<Color?> get color =>
//       WidgetStateProperty.resolveWith((states) {
//         if (states.contains(WidgetState.disabled)) return theme.disabledColor;
//         return null;
//       });
//   WidgetStateProperty<double> get weight =>
//       WidgetStateProperty.resolveWith((states) {
//         if (states.contains(WidgetState.selected)) {
//           return states.contains(WidgetState.pressed)
//               ? 300
//               : states.contains(WidgetState.hovered)
//                   ? 400
//                   : 700;
//         }
//         return states.contains(WidgetState.pressed)
//             ? 200
//             : states.contains(WidgetState.hovered)
//                 ? 700
//                 : 400;
//       });
//   WidgetStateProperty<double> get fill =>
//       WidgetStateProperty.resolveWith((states) {
//         if (states.contains(WidgetState.selected)) return 1;
//         return 0;
//       });
// }
