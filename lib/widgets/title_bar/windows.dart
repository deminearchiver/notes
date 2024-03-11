import 'package:notes/icons/segoe.dart';
import 'package:material/material.dart';
import 'package:window_manager/window_manager.dart';

class _DefaultIconColor implements MaterialStateProperty<Color> {
  const _DefaultIconColor();

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return Colors.white.withOpacity(0.3628);
    } else if (states.contains(MaterialState.pressed)) {
      return Colors.white.withOpacity(0.786);
    }
    return Colors.white;
  }
}

class _DefaultBackgroundColor implements MaterialStateProperty<Color?> {
  const _DefaultBackgroundColor();

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.white.withOpacity(0.0419);
    } else if (states.contains(MaterialState.hovered)) {
      return Colors.white.withOpacity(0.0605);
    }
    return null;
  }
}

class _CloseIconColor implements MaterialStateProperty<Color> {
  const _CloseIconColor();

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return Colors.white.withOpacity(0.3628);
    } else if (states.contains(MaterialState.pressed)) {
      return Colors.white.withOpacity(0.7);
    }
    return Colors.white;
  }
}

class _CloseBackgroundColor implements MaterialStateProperty<Color?> {
  const _CloseBackgroundColor();

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      // opacity: Color(0x --> E6 <-- C42B1C)
      // 255 * 0.9 = 229.5
      // round 229.5. = 230
      // 230 = 0xE6
      return const Color(0xFFC42B1C).withOpacity(0.9);
    } else if (states.contains(MaterialState.hovered)) {
      return const Color(0xFFC42B1C);
    }
    return null;
  }
}

class WindowsTitleBarControl extends StatefulWidget {
  const WindowsTitleBarControl({
    super.key,
    this.onPressed,
    this.compact = true,
    this.iconColor,
    this.backgroundColor,
    required this.icon,
  });

  final VoidCallback? onPressed;

  final bool compact;

  final MaterialStateProperty<Color>? iconColor;
  final MaterialStateProperty<Color?>? backgroundColor;

  final Widget icon;

  @override
  State<WindowsTitleBarControl> createState() => _WindowsTitleBarControlState();
}

class _WindowsTitleBarControlState extends State<WindowsTitleBarControl> {
  late final MaterialStatesController _statesController;

  @override
  void initState() {
    super.initState();
    _statesController = MaterialStatesController()
      ..addListener(_statesListener);
    // ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WindowsTitleBarControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onPressed != oldWidget.onPressed) {
      _statesController.update(
        MaterialState.disabled,
        widget.onPressed == null,
      );
    }
  }

  void _statesListener() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final MaterialStateProperty<Color> iconColor =
        widget.iconColor ?? const _DefaultIconColor();
    final MaterialStateProperty<Color?> backgroundColor =
        widget.backgroundColor ?? const _DefaultBackgroundColor();
    return InkWell(
      statesController: _statesController,
      onTap: widget.onPressed,
      hoverColor: backgroundColor.resolve({
        MaterialState.hovered,
      }),
      highlightColor: backgroundColor.resolve({
        MaterialState.pressed,
      }),
      child: SizedBox(
        width: 46,
        height: widget.compact ? 32 : 48,
        child: IconTheme.merge(
          data: IconThemeData(
            size: 10,
            color: iconColor.resolve(_statesController.value),
          ),
          child: widget.icon,
        ),
      ),
    );
  }
}

enum ControlType {
  minimize,
  maximize,
  close,
}

class WindowsTitleBarControls extends StatefulWidget {
  const WindowsTitleBarControls({
    super.key,
    this.compact = true,
    this.controls = const {
      ControlType.close,
      ControlType.maximize,
      ControlType.minimize,
    },
  }) : assert(controls.length > 0);

  const WindowsTitleBarControls.minimize({
    super.key,
    this.compact = true,
  }) : controls = const {ControlType.minimize};
  const WindowsTitleBarControls.maximize({
    super.key,
    this.compact = true,
  }) : controls = const {ControlType.maximize};
  const WindowsTitleBarControls.close({
    super.key,
    this.compact = true,
  }) : controls = const {ControlType.close};

  final bool compact;
  final Set<ControlType> controls;

  @override
  State<WindowsTitleBarControls> createState() =>
      _WindowsTitleBarControlsState();
}

class _WindowsTitleBarControlsState extends State<WindowsTitleBarControls> {
  Widget _controlFor(ControlType type) {
    return switch (type) {
      ControlType.minimize => _MinimizeControl(
          compact: widget.compact,
        ),
      ControlType.maximize => _MaximizeControl(
          compact: widget.compact,
        ),
      ControlType.close => _CloseControl(
          compact: widget.compact,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.controls.length == 1
        ? _controlFor(widget.controls.single)
        : Row(
            children: [
              if (widget.controls.contains(ControlType.minimize))
                _controlFor(ControlType.minimize),
              if (widget.controls.contains(ControlType.maximize))
                _controlFor(ControlType.maximize),
              if (widget.controls.contains(ControlType.close))
                _controlFor(ControlType.close),
            ],
          );
  }
}

class _MinimizeControl extends StatelessWidget {
  const _MinimizeControl({
    super.key,
    required this.compact,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return WindowsTitleBarControl(
      onPressed: windowManager.minimize,
      compact: compact,
      icon: const Icon(SegoeIcons.chrome_minimize),
    );
  }
}

class _MaximizeControl extends StatefulWidget {
  const _MaximizeControl({
    super.key,
    this.compact = true,
  });

  final bool compact;

  @override
  State<_MaximizeControl> createState() => __MaximizeControlState();
}

class __MaximizeControlState extends State<_MaximizeControl>
    with WindowListener {
  bool _maximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() {
    setState(() => _maximized = true);
  }

  @override
  void onWindowUnmaximize() {
    setState(() => _maximized = false);
  }

  @override
  Widget build(BuildContext context) {
    return WindowsTitleBarControl(
      onPressed: _maximized ? windowManager.unmaximize : windowManager.maximize,
      compact: widget.compact,
      icon: Icon(
        _maximized ? SegoeIcons.chrome_restore : SegoeIcons.chrome_maximize,
      ),
    );
  }
}

class _CloseControl extends StatelessWidget {
  const _CloseControl({
    super.key,
    required this.compact,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return WindowsTitleBarControl(
      onPressed: windowManager.close,
      compact: compact,
      iconColor: const _CloseIconColor(),
      backgroundColor: const _CloseBackgroundColor(),
      icon: const Icon(SegoeIcons.chrome_close),
    );
  }
}
