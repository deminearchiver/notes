import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notes/database/models/todo.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:material/material.dart';

//? TODO: the notification channel name is shown in android Settings > Apps > Notes > Notifications > Other

abstract final class NotificationService {
  static final plugin = FlutterLocalNotificationsPlugin();

  static Future<NotificationAppLaunchDetails?> getLaunchDetails() async {
    if (Platform.isWindows) return null;
    return plugin.getNotificationAppLaunchDetails();
  }

  static final _initializer = Completer<void>();

  static Future<void> init({
    required void Function(NotificationResponse details) onReceive,
  }) async {
    if (Platform.isWindows) return;
    const initializationSettings = InitializationSettings(
      android:
          AndroidInitializationSettings("notification"), // @mipmap/ic_launcher
    );
    await plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onReceive,
    );
    _initializer.complete();
  }

  static final permission = ValueNotifier<bool?>(null);

  static Future<bool> get hasPermission async {
    if (permission.value == null) {
      final completer = Completer<bool>();
      void listener() {
        permission.removeListener(listener);
        completer.complete(permission.value);
      }

      permission.addListener(listener);

      return completer.future;
    } else {
      return permission.value!;
    }
  }

  // static final _permissionController = StreamController<bool>.broadcast();
  // static Stream<bool> get permission => _permissionController.stream;
  // static Future<bool> get hasPermission {
  //   final completer = Completer<bool>();
  //   late StreamSubscription subscription;
  //   subscription = permission.listen((event) {
  //     completer.complete(event);
  //     subscription.cancel();
  //   });
  //   return completer.future;
  // }

  static Future<bool> requestPermission() async {
    bool gotPermission;
    if (Platform.isAndroid) {
      final android = plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!;
      gotPermission = await android.requestNotificationsPermission() ?? false;
    } else if (Platform.isIOS) {
      final ios = plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()!;
      gotPermission = await ios.requestPermissions() ?? false;
    } else if (Platform.isMacOS) {
      final macos = plugin.resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()!;
      gotPermission = await macos.requestPermissions() ?? false;
    } else if (Platform.isWindows) {
      gotPermission = true;
    } else {
      gotPermission = false;
    }

    permission.value = gotPermission;

    return gotPermission;
  }

  static const reminderChannelId = "todo";

  // TODO: investigate whether it is possible to use localizations here
  static const reminderChannelName = "Reminders";
  static const reminderChannelDescription = "Description";

  static Future<void> scheduleTodoNotification(Todo todo) async {
    if (!(await hasPermission)) return;

    if (!todo.date.isAfter(DateTime.now())) return;
    if (Platform.isWindows) return;
    await plugin.zonedSchedule(
      todo.id,
      todo.label,
      todo.details,
      tz.TZDateTime.from(todo.date, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          reminderChannelId,
          reminderChannelName,
          // channelDescription: reminderChannelDescription,
          playSound:
              true, // TODO: implement alarm sound and make this false or dont do anything and make this true
          actions: [
            // TODO: localize labels
            AndroidNotificationAction(
              "dismiss",
              "Dismiss",
              showsUserInterface: true,
            ),
            AndroidNotificationAction(
              "done",
              "Done",
              showsUserInterface: true,
            ),
          ],
        ),
      ),
      payload: todo.id.toString(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancel(int id) async {
    // ui.ToastNotificationManager.createToastNotifierWithId(applicationId)
    if (!(await hasPermission)) return;
    if (!Platform.isWindows) {
      await plugin.cancel(id);
    }
  }

  static Future<void> cancelAll() async {
    if (!(await hasPermission)) return;
    if (!Platform.isWindows) {
      await plugin.cancelAll();
    }
  }
}
