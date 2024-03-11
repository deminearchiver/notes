import 'dart:io';

import 'package:flutter/services.dart';
import 'package:material/material.dart';

class Ringtone {
  const Ringtone({
    required this.id,
    required this.title,
    required this.uri,
  });

  final String id;
  final String title;
  final Uri uri;

  @override
  String toString() {
    return "Ringtone{ id: $id, title: $title, uri: $uri }";
  }
}

class NativeService {
  static const platform = MethodChannel("dev.deminearchiver.notes/native");

  static Future<List<Ringtone>> getAllAlarms() async {
    try {
      final result = await platform.invokeListMethod("getAllAlarms");
      return result?.map(
            (e) {
              final map = (e as Map).cast<String, dynamic>();
              return Ringtone(
                id: map["id"],
                title: map["title"],
                uri: Uri.parse(map["uri"]),
              );
            },
          ).toList() ??
          [];
    } on PlatformException catch (_) {
      return [];
    }
  }

  static Future<void> playDefaultAlarm() async {
    try {
      await platform.invokeMethod("playDefaultAlarm");
    } on PlatformException catch (_) {}
  }

  static Future<bool> setWindowCaptionColor(Color color) async {
    if (!Platform.isWindows) return false;
    try {
      await platform.invokeMethod(
        "setWindowCaptionColor",
        Uint8List.fromList([color.red, color.green, color.blue]),
      );
      return true;
    } on PlatformException catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }
}
