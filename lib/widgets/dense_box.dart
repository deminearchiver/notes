import 'package:flutter/material.dart';

class DenseBox extends StatelessWidget {
  const DenseBox({
    super.key,
    this.width = 0,
    this.height = 0,
    this.child,
  });

  const DenseBox.square({
    required double dimension,
    this.child,
  })  : width = dimension,
        height = dimension;

  final double width;
  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final visualDensity = Theme.of(context).visualDensity;
    return SizedBox(
      width: width + visualDensity.baseSizeAdjustment.dx,
      height: height + visualDensity.baseSizeAdjustment.dy,
      child: child,
    );
  }
}
