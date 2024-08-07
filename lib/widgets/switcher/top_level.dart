import 'package:notes/widgets/switcher/switcher.dart';
import 'package:material/material.dart';

class TopLevelSwitcher extends Switcher {
  const TopLevelSwitcher({
    super.key,
    super.alignment,
    required super.child,
  }) : super.fadeThrough(
          duration: Durations.short3,
        );
  const TopLevelSwitcher.sliver({
    super.key,
    super.alignment,
    required super.sliver,
  }) : super.sliverFadeThrough(
          duration: Durations.short3,
        );
}
