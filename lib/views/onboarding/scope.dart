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
  final _navigatorKey = GlobalKey<NavigatorState>();

  Future<T?> next<T>(Widget child) {
    return _navigatorKey.currentState!.push<T>(
      MaterialRoute.sharedAxis(builder: (context) => child),
    );
  }

  void back<T>(T? result) {
    return _navigatorKey.currentState!.pop(result);
  }

  void close() {
    return Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateInitialRoutes: (navigator, initialRoute) {
        return [
          MaterialRoute.sharedAxis(
              builder: (context) => const OnboardingWelcome()),
        ];
      },
    );
  }
}
