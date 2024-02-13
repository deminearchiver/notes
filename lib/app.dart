import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:notes/database/database.dart';
import 'package:notes/database/todo.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/native.dart';
import 'package:notes/services/notifications.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/views/app/app.dart';
import 'package:notes/views/onboarding/scope.dart';
import 'package:notes/views/reminder/reminder.dart';
import 'package:notes/widgets/title_bar.dart';
import 'package:provider/provider.dart';
import 'package:true_material/material.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    this.todo,
  });

  final Todo? todo;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    NotificationService.init(
      onReceive: _notificationsListener,
    ).then(
      (_) => FlutterNativeSplash.remove(),
    );
  }

  void _notificationsListener(NotificationResponse details) async {
    FlutterNativeSplash.remove();
    if (details.id != null) {
      final todo = await Database.getTodo(details.id!);
      if (todo == null || todo.completed) return;

      switch (details.actionId) {
        case "dismiss":
          break;
        case "done":
          todo.completed = true;
          await Database.addTodo(todo);

        default:
          if (mounted) {
            _navigatorKey.currentState?.push(
              MaterialRoute.zoom(
                child: ReminderView(
                  todo: todo,
                ),
              ),
            );
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Settings.instance,
      builder: (context, _) {
        final settings = context.watch<Settings>();
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // Localizations
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
          ],
          locale: context.watch<Settings>().locale,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateTitle: (context) => AppLocalizations.of(context).app_name,

          // Theme
          theme: ThemeData(
            platform: TargetPlatform.android,
            splashFactory: InkSparkle.splashFactory,
            brightness: Brightness.light,
            // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
          darkTheme: ThemeData(
            platform: TargetPlatform.android,
            splashFactory: InkSparkle.splashFactory,
            brightness: Brightness.dark,
          ),
          themeAnimationCurve: Easing.standard,
          themeAnimationDuration: Durations.medium4,
          themeMode: settings.themeMode,
          // themeMode: ThemeMode.light,

          builder: (context, child) => TitleBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: child ?? const SizedBox.shrink(),
          ),

          // Navigation
          navigatorKey: _navigatorKey,
          initialRoute: Navigator.defaultRouteName,
          onGenerateInitialRoutes: (initialRoute) {
            final results = <Route>[];

            results.add(
              MaterialRoute.zoom(
                child: const AppView(),
              ),
            );
            if (settings.firstRun) {
              results.add(
                MaterialRoute.zoom(
                  child: const OnboardingScope(),
                ),
              );
            } else if (widget.todo != null) {
              results.add(
                MaterialRoute.zoom(
                  child: ReminderView(
                    todo: widget.todo!,
                  ),
                ),
              );
            }
            return results;
          },
          onGenerateRoute: (settings) {
            return MaterialRoute.zoom(
              child: const AppView(),
            );
          },
        );
      },
    );
  }
}
