import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:material/material.dart';

class FractionalStadiumBorder extends OutlinedBorder {
  const FractionalStadiumBorder({
    required this.fraction,
    super.side,
  });

  final double fraction;

  @override
  ShapeBorder scale(double t) => FractionalStadiumBorder(
        fraction: fraction,
        side: side.scale(t),
      );

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is FractionalStadiumBorder) {
      return FractionalStadiumBorder(
        fraction: lerpDouble(a.fraction, fraction, t)!,
        side: BorderSide.lerp(a.side, side, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is FractionalStadiumBorder) {
      return FractionalStadiumBorder(
        fraction: lerpDouble(fraction, b.fraction, t)!,
        side: BorderSide.lerp(side, b.side, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  FractionalStadiumBorder copyWith({
    BorderSide? side,
    double? fraction,
  }) {
    return FractionalStadiumBorder(
      fraction: fraction ?? this.fraction,
      side: side ?? this.side,
    );
  }

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final Radius radius = Radius.circular(rect.shortestSide / 2.0 * fraction);
    final RRect borderRect = RRect.fromRectAndRadius(rect, radius);
    final RRect adjustedRect = borderRect.deflate(side.strokeInset);
    return Path()..addRRect(adjustedRect);
  }

  @override
  Path getOuterPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final Radius radius = Radius.circular(rect.shortestSide / 2.0 * fraction);
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, radius),
      );
  }

  @override
  void paintInterior(
    Canvas canvas,
    Rect rect,
    Paint paint, {
    TextDirection? textDirection,
  }) {
    final Radius radius = Radius.circular(rect.shortestSide / 2.0 * fraction);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, radius),
      paint,
    );
  }

  @override
  bool get preferPaintInterior => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
  }) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final Radius radius = Radius.circular(rect.shortestSide / 2 * fraction);
        final RRect borderRect = RRect.fromRectAndRadius(rect, radius);
        canvas.drawRRect(
          borderRect.inflate(side.strokeOffset / 2),
          side.toPaint(),
        );
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is FractionalStadiumBorder &&
        other.side == side &&
        other.fraction == fraction;
  }

  @override
  int get hashCode => side.hashCode;

  @override
  String toString() {
    return '${objectRuntimeType(this, 'FractionalStadiumBorder')}($side)';
  }
}
