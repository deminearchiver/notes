import 'package:material/material.dart';

class AnimatedLinearProgressIndicator extends StatefulWidget {
  const AnimatedLinearProgressIndicator({
    super.key,
    this.visible = true,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
    this.value,
  });

  final bool visible;
  final EdgeInsets padding;

  final Alignment alignment;

  final double? value;

  @override
  State<AnimatedLinearProgressIndicator> createState() =>
      _AnimatedLinearProgressIndicatorState();
}

class _AnimatedLinearProgressIndicatorState
    extends State<AnimatedLinearProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final height = widget.visible ? 4.0 : 0.0;
    return SizedBox(
      height: 4,
      child: Align(
        alignment: widget.alignment,
        child: TweenAnimationBuilder(
          tween: Tween<double>(end: height),
          duration: Durations.medium4,
          curve: Easing.standard,
          builder: (context, height, child) => height > 0
              ? Padding(
                  padding: widget.padding,
                  child: LinearProgressIndicator(
                    value: widget.value,
                    minHeight: height,
                    borderRadius: BorderRadius.circular(2),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
