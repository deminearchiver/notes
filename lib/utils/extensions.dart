import 'package:isar/isar.dart';
import 'package:true_material/material.dart';

extension SortExtension on Sort {
  Sort reverse() => switch (this) {
        Sort.asc => Sort.desc,
        Sort.desc => Sort.asc,
      };
}

enum WindowClass {
  compact(0, 600),
  medium(600, 840),
  expanded(840, double.infinity);

  const WindowClass(this.minimum, this.maximum);

  final double minimum;
  final double maximum;

  bool get isCompact => this == WindowClass.compact;
  bool get isMedium => this == WindowClass.medium;
  bool get isExpanded => this == WindowClass.expanded;

  static WindowClass fromWidth(double width) {
    // TODO: 840 <= width < 1200*
    // https://m3.material.io/foundations/layout/applying-layout/window-size-classes#9e94b1fb-e842-423f-9713-099b40f13922
    return switch (width) {
      < 600 => WindowClass.compact,
      >= 600 && < 840 => WindowClass.medium,
      _ => WindowClass.expanded,
    };
  }
}

extension MediaQueryExtension on MediaQueryData {
  WindowClass get windowClass => WindowClass.fromWidth(size.width);
}
