import 'package:notes/flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class _BackIconButtonTag {
  const _BackIconButtonTag();

  @override
  String toString() => "BACK_ICON_BUTTON";
}

class BackIconButton extends StatelessWidget {
  const BackIconButton({super.key, this.heroTag});
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final navigator = Navigator.of(context);
    return IconButton(
      onPressed: navigator.canPop() ? navigator.pop : null,
      icon: const Icon(MaterialSymbols.arrow_back_rounded),
      color: theme.colorScheme.onSurface,
    );
  }
}
