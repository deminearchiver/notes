import 'package:flutter/foundation.dart';
import 'package:material/material.dart';

class DefaultPopupListTileController extends StatefulWidget {
  const DefaultPopupListTileController({
    super.key,
    this.child,
    required this.builder,
  });

  final Widget? child;
  final Widget Function(
    BuildContext context,
    PopupListTileController controller,
    Widget? child,
  ) builder;

  @override
  State<DefaultPopupListTileController> createState() =>
      _DefaultPopupListTileControllerState();
}

class _DefaultPopupListTileControllerState
    extends State<DefaultPopupListTileController> {
  final _controller = PopupListTileController();

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller, widget.child);
  }
}

class PopupListTileController {
  _PopupListTileState? _state;

  Future<T?> openView<T>() {
    assert(_state != null);
    return _state!._openView();
  }

  void _attach(_PopupListTileState state) {
    _state = state;
  }

  void _detach(_PopupListTileState state) {
    if (_state == state) {
      _state = null;
    }
  }
}

class PopupListTile extends StatefulWidget {
  const PopupListTile({
    super.key,
    this.controller,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.viewBuilder,
  });

  final PopupListTileController? controller;

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  final WidgetBuilder viewBuilder;

  @override
  State<PopupListTile> createState() => _PopupListTileState();
}

class _PopupListTileState extends State<PopupListTile> {
  PopupListTileController? _internalController;

  PopupListTileController get _controller =>
      widget.controller ?? _internalController!;

  final _listTileKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = PopupListTileController();
    }
  }

  @override
  void dispose() {
    _controller._detach(this);
    _internalController = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PopupListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      if (widget.controller != null) {
        _internalController?._detach(this);
        _internalController = null;
        widget.controller?._attach(this);
      } else {
        assert(_internalController == null);
        _internalController = PopupListTileController().._attach(this);
      }
    }
    assert(_controller._state == this);
  }

  Future<T?> _openView<T>() {
    final navigator = Navigator.of(context);
    return navigator.push<T>(
      _PopupListTileViewRoute(
        listTileKey: _listTileKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: _listTileKey,
    );
  }
}

class _PopupListTileViewRoute<T> extends PopupRoute<T> {
  _PopupListTileViewRoute({
    required this.listTileKey,
  });

  final GlobalKey listTileKey;

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.38);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => Durations.long4;

  @override
  Widget buildModalBarrier() {
    Widget barrier;
    if (barrierColor != null && barrierColor!.alpha != 0 && !offstage) {
      assert(barrierColor != barrierColor!.withOpacity(0.0));

      final animation = CurvedAnimation(
        parent: this.animation!,
        curve: Curves.easeInOutCubicEmphasized,
        reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
      );

      final Animation<Color?> color = animation.drive(
        ColorTween(
          begin: barrierColor!.withOpacity(0.0),
          end: barrierColor,
        ).chain(CurveTween(curve: barrierCurve)),
      );
      barrier = AnimatedModalBarrier(
        color: color,
        dismissible: barrierDismissible,
        semanticsLabel: barrierLabel,
        barrierSemanticsDismissible: semanticsDismissible,
      );
    } else {
      barrier = ModalBarrier(
        dismissible: barrierDismissible,
        semanticsLabel: barrierLabel,
        barrierSemanticsDismissible: semanticsDismissible,
      );
    }
    return barrier;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> _,
  ) {
    animation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );

    final listTileBox =
        listTileKey.currentContext!.findRenderObject()! as RenderBox;
    final listTileRect =
        listTileBox.localToGlobal(Offset.zero) & listTileBox.size;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final view = _PopupListTileView();

        return view;
      },
    );
  }
}

class _PopupListTileView extends StatelessWidget {
  const _PopupListTileView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
    );
  }
}
