import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:notes/database/isar/database.dart';
import 'package:notes/database/isar/todo.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/services/notifications.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/views/app/app.dart';
import 'package:notes/views/onboarding/scope.dart';
import 'package:notes/views/reminder/reminder.dart';
import 'package:notes/flutter.dart';

class App extends StatefulWidget {
  const App({super.key, this.todo});

  final Todo? todo;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  Future<void> _notificationsListener(NotificationResponse details) async {
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
            unawaited(
              _navigatorKey.currentState?.push(
                MaterialPageRoute<void>(
                  builder: (context) => ReminderView(todo: todo),
                ),
              ),
            );
          }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    unawaited(
      NotificationService.init(
        onReceive: _notificationsListener,
      ).then((_) => FlutterNativeSplash.remove()),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildNavigatorWrapper(BuildContext context, Widget? child) {
    if (child == null) return const SizedBox.shrink();
    final colorTheme = ColorTheme.of(context);
    final typescaleTheme = TypescaleTheme.of(context);
    return DefaultLocalizedTextStyle(
      style: typescaleTheme.bodyLarge.toTextStyle(color: colorTheme.onSurface),
      child: TouchGroup(child: child),
    );
  }

  Widget _buildApp(BuildContext context) {
    final settings = Settings.of(context);
    return RawMaterialApp(
      // Debugging
      debugShowCheckedModeBanner: false,
      scrollBehavior: kDebugMode
          ? const MaterialScrollBehavior().copyWith(
              dragDevices: PointerDeviceKind.values.toSet(),
            )
          : null,

      // Localization
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
      ],
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context).app_name,

      // Navigation
      // navigatorKey: globalNavigatorKey,
      builder: _buildNavigatorWrapper,
      navigatorKey: _navigatorKey,
      initialRoute: Navigator.defaultRouteName,
      onGenerateInitialRoutes: (initialRoute) {
        final results = <Route<void>>[
          MaterialPageRoute<void>(builder: (context) => const AppView()),
        ];

        if (settings.firstRun) {
          results.add(
            MaterialPageRoute<void>(
              builder: (context) => const OnboardingScope(),
            ),
          );
        } else if (widget.todo != null) {
          results.add(
            MaterialPageRoute<void>(
              builder: (context) => ReminderView(todo: widget.todo!),
            ),
          );
        }
        return results;
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const AppView());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Settings.instance,
      child: AppThemes(child: Builder(builder: _buildApp)),
    );
    // return _buildThemes(context, appBuilder);
    // return ChangeNotifierProvider(
    //   create: (context) => Settings.instance,
    //   builder: (context, _) {
    //     final settings = context.watch<Settings>();
    //     return MaterialApp(
    //       debugShowCheckedModeBanner: false,

    //       // Localizations
    //       localizationsDelegates: const [
    //         ...AppLocalizations.localizationsDelegates,
    //       ],
    //       locale: context.watch<Settings>().locale,
    //       supportedLocales: AppLocalizations.supportedLocales,
    //       onGenerateTitle: (context) => AppLocalizations.of(context).app_name,

    //       // Theme
    //       theme: AppTheme.light(),
    //       darkTheme: AppTheme.dark(),

    //       themeAnimationCurve: Easing.standard,
    //       themeAnimationDuration: Durations.medium4,
    //       themeMode: settings.themeMode,

    //       // themeMode: ThemeMode.dark,
    //       builder: (context, child) => TitleBar(
    //         backgroundColor: Theme.of(context).colorScheme.surface,
    //         child: child ?? const SizedBox.shrink(),
    //       ),

    //       // Navigation
    //       navigatorKey: _navigatorKey,
    //       initialRoute: Navigator.defaultRouteName,
    //       onGenerateInitialRoutes: (initialRoute) {
    //         final results = <Route<void>>[
    //           MaterialPageRoute<void>(builder: (context) => const AppView()),
    //         ];

    //         if (settings.firstRun) {
    //           results.add(
    //             MaterialPageRoute<void>(
    //               builder: (context) => const OnboardingScope(),
    //             ),
    //           );
    //         } else if (widget.todo != null) {
    //           results.add(
    //             MaterialPageRoute<void>(
    //               builder: (context) => ReminderView(todo: widget.todo!),
    //             ),
    //           );
    //         }
    //         return results;
    //       },
    //       onGenerateRoute: (settings) {
    //         return MaterialPageRoute(builder: (context) => const AppView());
    //       },
    //     );
    //   },
    // );
  }
}

class AppThemes extends SingleChildStatelessWidget {
  const AppThemes({super.key, super.child});

  @override
  SingleChildWidget wrap(BuildContext context, Widget? child) =>
      AppThemes(key: key, child: child);

  SingleChildWidget _buildTypefaceTheme(BuildContext context) =>
      TypefaceTheme.mergeWithData(data: _typography.typeface);

  List<SingleChildWidget> _buildReferenceThemes(BuildContext context) => [
    _buildTypefaceTheme(context),
  ];

  SingleChildWidget _buildColorTheme(
    BuildContext context,
  ) => SingleChildBuilder(
    builder: (context, child) {
      final themeMode = Settings.aspectOf<ThemeMode>(
        context,
        (settings) => settings.themeMode,
      );

      final Brightness brightness = switch (themeMode) {
        .system => MediaQuery.platformBrightnessOf(context),
        .light => .light,
        .dark => .dark,
      };

      final highContrast = MediaQuery.highContrastOf(context);
      final contrastLevel = highContrast ? 1.0 : 0.0;

      final colorTheme = ColorThemeData.fromSeed(
        brightness: brightness,
        contrastLevel: contrastLevel,
        variant: _variant,
        platform: _platform,
        specVersion: _specVersion,
      );

      // final dynamicColorScheme = DynamicColor.dynamicColorScheme(brightness);
      // colorTheme = colorTheme.maybeMerge(dynamicColorScheme?.toColorTheme());

      // final staticColors = StaticColorsData.fallback(
      //   brightness: brightness,
      //   contrastLevel: contrastLevel,
      //   variant: _variant,
      //   platform: _platform,
      //   specVersion: _specVersion,
      // );

      return ColorTheme.replaceWithData(data: colorTheme, child: child);
    },
  );

  SingleChildWidget _buildSpringTheme(BuildContext context) =>
      const SpringTheme.replaceWithData(data: .defaultsExpressive());

  SingleChildWidget _buildTypescaleTheme(BuildContext context) =>
      TypescaleTheme.mergeWithData(data: _typography.typescale);

  List<SingleChildWidget> _buildSystemThemes(BuildContext context) => [
    _buildColorTheme(context),
    _buildSpringTheme(context),
    _buildTypescaleTheme(context),
  ];

  List<SingleChildWidget> _buildComponentThemes(BuildContext context) => [];

  List<SingleChildWidget> _buildLegacyThemes(BuildContext context) {
    final colorTheme = ColorTheme.of(context);
    final elevationTheme = ElevationTheme.of(context);
    final shapeTheme = ShapeTheme.of(context);
    final stateTheme = StateTheme.of(context);
    final typescaleTheme = TypescaleTheme.of(context);
    return [
      SingleChildBuilder(
        builder: (context, child) => Theme(
          data: LegacyThemeFactory.createTheme(
            colorTheme: colorTheme,
            elevationTheme: elevationTheme,
            shapeTheme: shapeTheme,
            stateTheme: stateTheme,
            typescaleTheme: typescaleTheme,
            scaffoldBackgroundColor: colorTheme.surface,
          ),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    ];
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    if (child == null) return const SizedBox.shrink();

    final builders = <List<SingleChildWidget> Function(BuildContext context)>[
      _buildReferenceThemes,
      _buildSystemThemes,
      _buildComponentThemes,
      _buildLegacyThemes,
    ];
    return Nested(
      children: [
        for (final builder in builders)
          SingleChildBuilder(
            builder: (context, child) =>
                Nested(children: builder(context), child: child),
          ),
      ],
      child: child,
    );
  }

  static const _variant = DynamicSchemeVariant.expressive;
  static const _platform = DynamicSchemePlatform.phone;
  static const _specVersion = DynamicSchemeSpecVersion.spec2026;
  static const _typography = TypographyDefaults.expressive2026;
}
