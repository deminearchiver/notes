import 'package:true_material/material.dart';

class TweenedIcon extends ImplicitlyAnimatedWidget {
  const TweenedIcon({
    super.key,
    required super.duration,
    super.curve,
    super.onEnd,
    required this.icon,
    this.size,
    this.color,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
  });

  final IconData icon;

  final double? size;
  final Color? color;
  final double? fill;
  final double? weight;
  final double? grade;
  final double? opticalSize;

  @override
  ImplicitlyAnimatedWidgetState<TweenedIcon> createState() =>
      _TweenedIconState();
}

class _TweenedIconState extends AnimatedWidgetBaseState<TweenedIcon> {
  Tween<double>? _sizeTween;
  ColorTween? _colorTween;
  Tween<double>? _fillTween;
  Tween<double>? _weightTween;
  Tween<double>? _gradeTween;
  Tween<double>? _opticalSizeTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    if (widget.size != null) {
      _sizeTween = visitor(
        _sizeTween,
        widget.size,
        (targetValue) => Tween<double>(begin: targetValue),
      ) as Tween<double>;
    }
    if (widget.color != null) {
      _colorTween = visitor(
        _colorTween,
        widget.color,
        (targetValue) => ColorTween(begin: targetValue as Color),
      ) as ColorTween;
    }
    if (widget.fill != null) {
      _fillTween = visitor(
        _fillTween,
        widget.fill,
        (targetValue) => Tween<double>(begin: targetValue),
      ) as Tween<double>;
    }
    if (widget.weight != null) {
      _weightTween = visitor(
        _weightTween,
        widget.weight,
        (targetValue) => Tween<double>(begin: targetValue),
      ) as Tween<double>;
    }
    if (widget.grade != null) {
      _gradeTween = visitor(
        _gradeTween,
        widget.grade,
        (targetValue) => Tween<double>(begin: targetValue),
      ) as Tween<double>;
    }
    if (widget.opticalSize != null) {
      _opticalSizeTween = visitor(
        _opticalSizeTween,
        widget.opticalSize,
        (targetValue) => Tween<double>(begin: targetValue),
      ) as Tween<double>;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      size: _sizeTween?.evaluate(animation),
      color: _colorTween?.evaluate(animation),
      fill: _fillTween?.evaluate(animation),
      weight: _weightTween?.evaluate(animation),
      grade: _gradeTween?.evaluate(animation),
      opticalSize: _opticalSizeTween?.evaluate(animation),
    );
  }
}
