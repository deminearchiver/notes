// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:material/material.dart';

// class AnimatedIndexedStack extends StatefulWidget {
//   const AnimatedIndexedStack({
//     super.key,
//     required this.index,
//     required this.children,
//   });

//   final int index;
//   final List<Widget> children;

//   @override
//   State<AnimatedIndexedStack> createState() => _AnimatedIndexedStackState();
// }

// class _AnimatedIndexedStackState extends State<AnimatedIndexedStack>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   late int _index;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Durations.long4,
//       value: 1,
//     );
//     _animation = Tween<double>(begin: 0.5, end: 1).animate(_controller);

//     _index = widget.index;
//   }

//   @override
//   void didUpdateWidget(covariant AnimatedIndexedStack oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.index != oldWidget.index) {}
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       child: IndexedStack(
//         index: _index,
//         children: widget.children,
//       ),
//       builder: (context, child) {
//         // debugPrint("${_animation.value}");
//         return Opacity(
//           opacity: _animation.value,
//           child: child,
//         );
//       },
//     );
//   }
// }

// class AnimatedIndexedStack extends StatefulWidget {
//   const AnimatedIndexedStack({
//     super.key,
//     required this.index,
//     required this.children,
//     this.duration = const Duration(milliseconds: 800),
//   });

//   final int index;
//   final List<Widget> children;
//   final Duration duration;

//   @override
//   State<AnimatedIndexedStack> createState() => _AnimatedIndexedStackState();
// }

// class _AnimatedIndexedStackState extends State<AnimatedIndexedStack>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void didUpdateWidget(AnimatedIndexedStack oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.index != oldWidget.index) {
//       _controller.forward(from: 0.0);
//     }
//   }

//   @override
//   void initState() {
//     _controller = AnimationController(vsync: this, duration: widget.duration);
//     _controller.forward();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _controller,
//       child: IndexedStack(
//         index: widget.index,
//         children: widget.children,
//       ),
//     );
//   }
// }

class AnimatedIndexedStack extends StatefulWidget {
  const AnimatedIndexedStack({
    super.key,
    required this.index,
    required this.children,
  });
  final int index;
  final List<Widget> children;

  @override
  State<AnimatedIndexedStack> createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<AnimatedIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int _index;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Durations.short2,
      value: 1,
    )..addStatusListener(_animationStatusListener);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _index = widget.index;
  }

  @override
  void didUpdateWidget(AnimatedIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != _index) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      setState(() => _index = widget.index);
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: IndexedStack(
        index: _index,
        children: widget.children,
      ),
    );
  }
}
