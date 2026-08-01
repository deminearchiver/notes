import 'dart:async';
import 'dart:io';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:notes/app.dart';
import 'package:notes/constants/images.dart';
import 'package:notes/database/database.dart';
import 'package:notes/database/isar/database.dart';
import 'package:notes/services/notifications.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

Future<void> loadTimezone() async {
  tz.initializeTimeZones();

  try {
    final local = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(local.identifier));
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

  // final db = File(
  //   p.join(
  //     (await getApplicationSupportDirectory()).path,
  //     "notes_database.sqlite",
  //   ),
  // );
  // if (db.existsSync()) {
  //   await db.delete();
  // }
  final database = AppDatabase();
  // print(await database.allNotes().get());

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
        unawaited(Database.addTodo(todo));

      case "dismiss":
        break;
      default:
        runApp(
          Provider(
            create: (_) => database,
            dispose: (_, _) {
              unawaited(database.close());
            },
            child: App(todo: todo),
          ),
        );
    }
  } else {
    runApp(
      Provider(
        create: (_) => database,
        dispose: (_, _) {
          unawaited(database.close());
        },
        child: const App(),
      ),
    );
  }
}
