import 'package:flutter/rendering.dart';
import 'package:true_material/material.dart';

class IntrinsicAlign extends SingleChildRenderObjectWidget {
  const IntrinsicAlign({
    super.key,
    this.alignment = Alignment.center,
    this.widthFactor,
    this.heightFactor,
    super.child,
  })  : assert(widthFactor == null || widthFactor >= 0.0),
        assert(heightFactor == null || heightFactor >= 0.0);

  final AlignmentGeometry alignment;

  final double? widthFactor;

  final double? heightFactor;

  @override
  RenderIntrinsicAlign createRenderObject(BuildContext context) {
    return RenderIntrinsicAlign(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderIntrinsicAlign renderObject) {
    renderObject
      ..alignment = alignment
      ..widthFactor = widthFactor
      ..heightFactor = heightFactor
      ..textDirection = Directionality.maybeOf(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties
        .add(DoubleProperty('widthFactor', widthFactor, defaultValue: null));
    properties
        .add(DoubleProperty('heightFactor', heightFactor, defaultValue: null));
  }
}

class RenderIntrinsicAlign extends RenderAligningShiftedBox {
  RenderIntrinsicAlign({
    super.child,
    double? widthFactor,
    double? heightFactor,
    super.alignment,
    super.textDirection,
  })  : assert(widthFactor == null || widthFactor >= 0),
        assert(heightFactor == null || heightFactor >= 0),
        _widthFactor = widthFactor,
        _heightFactor = heightFactor;

  double? get widthFactor => _widthFactor;
  double? _widthFactor;
  set widthFactor(double? value) {
    assert(value == null || value >= 0);
    if (_widthFactor == value) {
      return;
    }
    _widthFactor = value;
    markNeedsLayout();
  }

  double? get heightFactor => _heightFactor;
  double? _heightFactor;
  set heightFactor(double? value) {
    assert(value == null || value >= 0);
    if (_heightFactor == value) {
      return;
    }
    _heightFactor = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final childWidth = child?.getMinIntrinsicWidth(height) ?? 0;
    return childWidth * (widthFactor ?? 1);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final childWidth = child?.getMaxIntrinsicWidth(height) ?? 0;
    return childWidth * (widthFactor ?? 1);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final childHeight = child?.getMinIntrinsicHeight(width) ?? 0;
    return childHeight * (heightFactor ?? 1);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final childHeight = child?.getMaxIntrinsicHeight(width) ?? 0;
    return childHeight * (heightFactor ?? 1);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final bool shrinkWrapWidth =
        _widthFactor != null || constraints.maxWidth == double.infinity;
    final bool shrinkWrapHeight =
        _heightFactor != null || constraints.maxHeight == double.infinity;
    if (child != null) {
      final Size childSize = child!.getDryLayout(constraints.loosen());
      // final Size childSize = child!.getDryLayout(constraints);
      return constraints.constrain(Size(
        shrinkWrapWidth
            ? childSize.width * (_widthFactor ?? 1.0)
            : double.infinity,
        shrinkWrapHeight
            ? childSize.height * (_heightFactor ?? 1.0)
            : double.infinity,
      ));
    }
    return constraints.constrain(Size(
      shrinkWrapWidth ? 0.0 : double.infinity,
      shrinkWrapHeight ? 0.0 : double.infinity,
    ));
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool shrinkWrapWidth =
        _widthFactor != null || constraints.maxWidth == double.infinity;
    final bool shrinkWrapHeight =
        _heightFactor != null || constraints.maxHeight == double.infinity;

    if (child != null) {
      child!.layout(constraints.loosen(), parentUsesSize: true);
      size = constraints.constrain(Size(
        shrinkWrapWidth
            ? child!.size.width * (_widthFactor ?? 1)
            : double.infinity,
        shrinkWrapHeight
            ? child!.size.height * (_heightFactor ?? 1)
            : double.infinity,
      ));
      alignChild();
    } else {
      size = constraints.constrain(Size(
        shrinkWrapWidth ? 0 : double.infinity,
        shrinkWrapHeight ? 0 : double.infinity,
      ));
    }
  }
}
