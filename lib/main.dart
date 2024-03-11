import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:notes/app.dart';
import 'package:notes/constants/images.dart';
import 'package:notes/database/database.dart';
import 'package:notes/services/notifications.dart';
import 'package:notes/settings/settings.dart';
import 'package:material/material.dart';
import 'package:flutter_timezone_plus/flutter_timezone_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:window_manager/window_manager.dart';

Future<void> loadTimezone() async {
  tz.initializeTimeZones();

  try {
    final local =
        await FlutterTimezone.getLocalTimezone().catchError((_) => null);
    tz.setLocalLocation(tz.getLocation(local!));
  } catch (error) {
    tz.setLocalLocation(tz.UTC);
  }
}

late String appVersion;

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  // Begin initialization
  await loadTimezone();

  await Settings.instance.reload();
  await Database.init();
  await Images.init();

  final packageInfo = await PackageInfo.fromPlatform();
  appVersion = packageInfo.version;

  // await windowManager.ensureInitialized();

  // const windowOptions = WindowOptions(
  //   size: Size(800, 600),
  //   center: true,
  //   titleBarStyle: TitleBarStyle.hidden,
  // );
  // await windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });

  if (!Settings.instance.firstRun) {
    await NotificationService.requestPermission();
  }

  //? We are not removing the splash screen because we will end the initialization in our app

  final launch = await NotificationService.getLaunchDetails();

  if (launch?.notificationResponse?.id != null &&
      launch!.didNotificationLaunchApp) {
    final details = launch.notificationResponse!;

    final todo = await Database.getTodo(details.id!);
    switch (details.actionId) {
      case "done" when todo != null:
        todo.completed = true;
        Database.addTodo(todo);

      case "dismiss":
        break;
      default:
        runApp(
          App(
            todo: todo,
          ),
        );
    }
  } else {
    runApp(const App());
  }
}
