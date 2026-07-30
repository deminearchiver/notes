import 'package:material/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:visibility_detector/visibility_detector.dart';

class _BackIconButtonTag {
  const _BackIconButtonTag();

  @override
  String toString() => "BACK_ICON_BUTTON";
}

class BackIconButton extends StatelessWidget {
  const BackIconButton({
    super.key,
    this.enabled = true,
    this.onPressed,
    this.heroTag,
  });

  final bool enabled;
  final VoidCallback? onPressed;

  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final navigator = Navigator.of(context);
    return Center(
      child: Hero(
        tag: heroTag ?? const _BackIconButtonTag(),
        child: IconButton(
          onPressed: enabled
              ? onPressed ?? (navigator.canPop() ? navigator.pop : null)
              : null,
          icon: const Icon(Symbols.arrow_back_rounded),
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
