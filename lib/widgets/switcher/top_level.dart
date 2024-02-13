import 'package:notes/widgets/switcher/switcher.dart';
import 'package:true_material/material.dart';

class TopLevelSwitcher extends Switcher {
  const TopLevelSwitcher({
    super.key,
    super.alignment,
    required super.child,
  }) : super.fadeThrough(
          duration: Durations.short4,
        );
  const TopLevelSwitcher.sliver({
    super.key,
    super.alignment,
    required super.sliver,
  }) : super.sliverFadeThrough(
          duration: Durations.short4,
        );
}
