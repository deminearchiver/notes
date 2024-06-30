import 'package:flutter/services.dart';
import 'package:material/material.dart';

import 'pages/welcome.dart';

class OnboardingScope extends StatefulWidget {
  const OnboardingScope({super.key});

  static OnboardingState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<OnboardingState>();
  }

  static OnboardingState of(BuildContext context) {
    final result = maybeOf(context);
    return result!;
  }

  @override
  State<OnboardingScope> createState() => OnboardingState();
}

class OnboardingState extends State<OnboardingScope> {
  late HeroController _heroController;

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    _heroController = HeroController();
  }

  @override
  void dispose() {
    _heroController.dispose();
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  Future<T?> next<T>(Widget child) {
    return _navigatorKey.currentState!.push<T>(
      MaterialRoute.sharedAxis(builder: (context) => child),
    );
  }

  void back<T>([T? result]) {
    return _navigatorKey.currentState!.pop(result);
  }

  void close() {
    return Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return HeroControllerScope(
      controller: _heroController,
      child: Navigator(
        key: _navigatorKey,
        observers: [_heroController],
        onGenerateInitialRoutes: (navigator, initialRoute) {
          return [
            MaterialRoute.sharedAxis(
                builder: (context) => const OnboardingWelcome()),
          ];
        },
      ),
    );
  }
}
