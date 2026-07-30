import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:notes/database/models/todo.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/theme.dart';
import 'package:notes/views/onboarding/onboarding.dart';
import 'package:notes/views/settings/settings.dart';
import 'package:notes/widgets/route/route.dart';
import 'package:notes/widgets/title_bar.dart';
import 'package:provider/provider.dart';
import 'package:material/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.settings,
    this.todo,
  });

  final Settings settings;
  final Todo? todo;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    // NotificationService.init(
    //   onReceive: _notificationsListener,
    // ).then(
    //   (_) => FlutterNativeSplash.remove(),
    // );
    FlutterNativeSplash.remove();
  }

  // void _notificationsListener(NotificationResponse details) async {
  //   FlutterNativeSplash.remove();
  //   if (details.id != null) {
  //     final todo = await Database.getTodo(details.id!);
  //     if (todo == null || todo.completed) return;

  //     switch (details.actionId) {
  //       case "dismiss":
  //         break;
  //       case "done":
  //         todo.completed = true;
  //         await Database.addTodo(todo);

  //       default:
  //         if (mounted) {
  //           _navigatorKey.currentState?.push(
  //             MaterialRoute.sharedAxis(
  //               builder: (context) => ReminderView(
  //                 todo: todo,
  //               ),
  //             ),
  //           );
  //         }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => widget.settings),
      ],
      builder: (context, child) => DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          final settings = Settings.watch(context);

          ColorScheme? light;
          ColorScheme? dark;

          if (lightDynamic != null &&
              darkDynamic != null &&
              settings.useDynamicColor) {
            light = lightDynamic.harmonized();
            dark = darkDynamic.harmonized();
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,

            localizationsDelegates: const [
              ...AppLocalizations.localizationsDelegates,
            ],
            locale: settings.locale.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (context) => AppLocalizations.of(context).app_name,

            theme: AppTheme.createTheme(
              brightness: Brightness.light,
              colorScheme: light,
            ),
            darkTheme: AppTheme.createTheme(
              brightness: Brightness.dark,
              colorScheme: dark,
            ),

            themeAnimationCurve: Easing.standard,
            themeAnimationDuration: Durations.medium4,
            themeMode: settings.themeMode,

            builder: (context, child) => TitleBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: child ?? const SizedBox.shrink(),
            ),

            home: const AppNavigation(),

            // Navigation

            // navigatorKey: _navigatorKey,
            // initialRoute: Navigator.defaultRouteName,
            // onGenerateInitialRoutes: (initialRoute) {
            //   final results = <Route>[];

            //   results.add(
            //     MaterialRoute.sharedAxis(
            //       builder: (context) => const AppView(),
            //     ),
            //   );
            //   if (settings.firstRun) {
            //     results.add(
            //       MaterialRoute.sharedAxis(
            //         builder: (context) => const OnboardingScope(),
            //       ),
            //     );
            //   } else if (widget.todo != null) {
            //     results.add(
            //       MaterialRoute.sharedAxis(
            //         builder: (context) => ReminderView(
            //           todo: widget.todo!,
            //         ),
            //       ),
            //     );
            //   }
            //   return results;
            // },
            // onGenerateRoute: (settings) {
            //   return MaterialRoute.sharedAxis(
            //     builder: (context) => const AppView(),
            //   );
            // },
          );
        },
      ),
    );
  }
}

class AppNavigation extends StatefulWidget {
  const AppNavigation({
    super.key,
  });

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

final navigatorKey = GlobalKey<NavigatorState>();

class _AppNavigationState extends State<AppNavigation> {
  late HeroController _heroController;

  @override
  void initState() {
    super.initState();
    _heroController = HeroController();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NavigatorPopHandler(
      onPop: navigatorKey.currentState?.pop,
      // onWillPop: () async {
      //   final shouldPop = navigatorKey.currentState?.canPop() ?? false;
      //   if (shouldPop) navigatorKey.currentState?.pop();
      //   return !shouldPop;
      // },
      child: ColoredBox(
        color: theme.colorScheme.surface,
        child: HeroControllerScope(
          controller: _heroController,
          child: Navigator(
            key: navigatorKey,
            onGenerateInitialRoutes: (navigator, initialRoute) {
              final results = <Route>[
                MaterialRoute.sharedAxis(
                  builder: (context) => const SettingsView(),
                ),
              ];
              results.add(
                MaterialRoute.sharedAxis(
                  builder: (context) => const OnboardingView(),
                ),
              );
              // if (settings.firstRun) {
              //   results.add(
              //     MaterialRoute.sharedAxis(
              //       reverse: true,
              //       builder: (context) => const OnboardingScope(),
              //     ),
              //   );
              // }
              return results;
            },
          ),
        ),
      ),
    );
  }
}
