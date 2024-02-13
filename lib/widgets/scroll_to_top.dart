import 'package:flutter/rendering.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:true_material/material.dart';

class ScrollToTop extends StatefulWidget {
  const ScrollToTop({
    super.key,
    required this.controller,
    this.top = 16,
    this.minOffset = 0,
    required this.child,
  }) : _sliver = false;

  final bool _sliver;

  final ScrollController controller;

  final double top;
  final double minOffset;

  final Widget child;

  @override
  State<ScrollToTop> createState() => _ScrollToTopState();
}

class _ScrollToTopState extends State<ScrollToTop>
    with SingleTickerProviderStateMixin {
  static final _offsetTween = Tween<double>(
    begin: -28,
    end: 0,
  );
  static final _opacityTween = Tween<double>(
    begin: 0,
    end: 1,
  );

  final _dismissableKey = GlobalKey();

  late ScrollController _scrollController;
  late AnimationController _animationController;

  late Animation<double> _animation;

  bool _showButton = false;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller..addListener(_scrollListener);
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.long4,
      reverseDuration: Durations.medium4,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Easing.emphasized,
      reverseCurve: Easing.emphasized.flipped,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(ScrollToTop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _scrollController.removeListener(_scrollListener);
      _scrollController = widget.controller..addListener(_scrollListener);
    }
  }

  void _scrollListener() {
    final top = _scrollController.position.pixels <= widget.minOffset;
    final scrollingDown = _scrollController.position.userScrollDirection ==
        ScrollDirection.reverse;

    _setShowButton(!top && scrollingDown);
    setState(() {});
  }

  void _setShowButton(bool value) {
    if (_showButton == value && !_dismissed) return;
    setState(() {
      _showButton = value;
      _dismissed = false;
    });
    if (_showButton) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Durations.medium4,
      curve: Easing.standardDecelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget._sliver) throw UnimplementedError();

    final localizations = AppLocalizations.of(context);

    return Stack(
      children: [
        widget.child,
        Positioned(
          child: AnimatedBuilder(
            animation: _animation,
            child: Dismissible(
              key: _dismissableKey,
              onDismissed: (direction) {
                _animationController.value = 0;
                setState(() => _dismissed = true);
              },
              direction: DismissDirection.up,
              behavior: HitTestBehavior.deferToChild,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.paddingOf(context).top + widget.top,
                  ),
                  Center(
                    child: FilledButton.icon(
                      onPressed: _scrollToTop,
                      icon: const Icon(Symbols.north_rounded),
                      label: Text(localizations.scroll_to_top),
                    ),
                  ),
                ],
              ),
            ),
            builder: (context, child) {
              if (_dismissed) return const SizedBox.shrink();
              final transition = Transform.translate(
                offset: Offset(0, _offsetTween.evaluate(_animation)),
                child: Opacity(
                  opacity: _opacityTween.evaluate(_animation),
                  child: child!,
                ),
              );
              return !_animation.isDismissed
                  ? transition
                  : IgnorePointer(
                      child: transition,
                    );
            },
          ),
        ),
      ],
    );
  }
}
