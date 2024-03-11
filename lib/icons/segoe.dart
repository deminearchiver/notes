// ignore_for_file: constant_identifier_names

import 'package:material/material.dart';

class SegoeIconData extends IconData {
  const SegoeIconData(super.codePoint)
      : super(
          fontFamily: "Segoe Fluent Icons",
        );
}

@staticIconProvider
abstract final class SegoeIcons {
  static const chrome_close = SegoeIconData(0xE8BB);
  static const chrome_minimize = SegoeIconData(0xE921);
  static const chrome_maximize = SegoeIconData(0xE922);
  static const chrome_restore = SegoeIconData(0xE923);
  static const chrome_back = SegoeIconData(0xE830);
}
