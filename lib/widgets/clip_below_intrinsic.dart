import 'package:flutter/rendering.dart';
import 'package:material/material.dart';

class ClipBelowIntrinsic extends SingleChildRenderObjectWidget {
  const ClipBelowIntrinsic({
    super.key,
    this.clipWidth = false,
    super.child,
  });

  final bool clipWidth;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderClipBelowIntrinsic(clipWidth: clipWidth);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderClipBelowIntrinsic renderObject,
  ) {
    renderObject.clipWidth = clipWidth;
  }
}

class RenderClipBelowIntrinsic extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  RenderClipBelowIntrinsic({required bool clipWidth}) : _clipWidth = clipWidth {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    _screenSize = view.physicalSize / view.devicePixelRatio;

    _layout = _onFirstLayout;
    _clipper = _clipWidth ? _clipWidthAndHeight : _clipHeightOnly;
  }

  late final Size _screenSize;
  late void Function(PaintingContext, Offset) _clipper;

  late void Function() _layout;
  late Size _intrinsicSize;

  bool _clipWidth;
  set clipWidth(bool value) {
    if (_clipWidth == value) return;
    _clipWidth = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    _layout();

    final width =
        constraints.hasTightWidth ? constraints.maxWidth : _intrinsicSize.width;

    final height = constraints.hasTightHeight
        ? constraints.maxHeight
        : _intrinsicSize.height;

    size = constraints.constrain(Size(width, height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    /// Clip the painted area to [size], which allows the [child] height to
    /// be greater than [size] visual overflow.
    size.height < _intrinsicSize.height
        ? _clipper(context, offset)
        : context.paintChild(child!, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    var childParentData = child!.parentData as BoxParentData;

    final isHit = result.addWithPaintOffset(
      offset: childParentData.offset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        assert(transformed == position - childParentData.offset);
        return child!.hitTest(result, position: transformed);
      },
    );

    return isHit;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      child!.getDryLayout(constraints);

  @override
  double computeMinIntrinsicWidth(double height) =>
      hasSize ? size.width : child!.getMinIntrinsicWidth(height);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      hasSize ? size.width : child!.getMaxIntrinsicWidth(height);

  @override
  double computeMinIntrinsicHeight(double width) =>
      hasSize ? size.height : child!.getMinIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      hasSize ? size.height : child!.getMaxIntrinsicHeight(width);

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      child!.getDistanceToActualBaseline(baseline);

  @override
  bool get sizedByParent => false;

  void _onFirstLayout() {
    child!.layout(
      BoxConstraints(maxWidth: constraints.maxWidth),
      parentUsesSize: true,
    );
    _intrinsicSize = child!.size;
    _layout = _onSubsequentLayout;
  }

  void _onSubsequentLayout() {
    final childConstraints = BoxConstraints.loose(
      Size(
        /// Ensure the child's width is never below its intrinsic width.
        constraints.maxWidth < _intrinsicSize.width
            ? _intrinsicSize.width
            : constraints.maxWidth,

        /// Ensure the child's height is never below its intrinsic height.
        constraints.maxHeight < _intrinsicSize.height
            ? _intrinsicSize.height
            : constraints.maxHeight,
      ),
    );

    child!.layout(childConstraints);
  }

  void _clipHeightOnly(PaintingContext context, Offset offset) {
    context.pushClipRect(
      true,
      offset,
      Offset.zero & Size(_screenSize.width, size.height),
      (context, offset) => context.paintChild(child!, offset),
    );
  }

  void _clipWidthAndHeight(PaintingContext context, Offset offset) {
    context.pushClipRect(
      true,
      offset,
      Offset.zero & size,
      (context, offset) => context.paintChild(child!, offset),
    );
  }
}
