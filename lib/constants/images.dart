// ignore_for_file: constant_identifier_names

import 'package:notes/utils/utils.dart';
import 'package:material/material.dart';

sealed class Images {
  static Future<void> init() async {
    await loadImage(ic_launcher);
    await loadImage(deminearchiver);
  }

  static const ImageProvider ic_launcher =
      AssetImage("assets/images/ic_launcher.png");
  static const ImageProvider deminearchiver =
      AssetImage("assets/images/deminearchiver.png");
}
