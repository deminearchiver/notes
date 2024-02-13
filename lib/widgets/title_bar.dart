import 'package:flutter/material.dart';
import 'package:notes/native.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({
    super.key,
    required this.backgroundColor,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    NativeService.setWindowCaptionColor(backgroundColor);
    return child;
  }
}
