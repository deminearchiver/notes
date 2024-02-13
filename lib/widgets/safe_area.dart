// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:true_material/material.dart';

class RemoveSafeArea extends StatelessWidget {
  const RemoveSafeArea({
    super.key,
    this.left = 1,
    this.top = 1,
    this.right = 1,
    this.bottom = 1,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
    required this.child,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;

  final EdgeInsets minimum;

  final bool maintainBottomViewPadding;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    EdgeInsets safePadding = MediaQuery.paddingOf(context);
    // // Bottom padding has been consumed - i.e. by the keyboard
    if (maintainBottomViewPadding) {
      safePadding = safePadding.copyWith(
          bottom: MediaQuery.viewPaddingOf(context).bottom);
    }

    final media = MediaQuery.of(context);

    return MediaQuery(
      data: media.copyWith(
        padding: EdgeInsets.fromLTRB(
          lerpDouble(minimum.left, safePadding.left, left)!,
          lerpDouble(minimum.top, safePadding.top, top)!,
          lerpDouble(minimum.right, safePadding.right, right)!,
          lerpDouble(minimum.bottom, safePadding.bottom, bottom)!,
        ),
      ),
      child: child,
    );
  }
}
