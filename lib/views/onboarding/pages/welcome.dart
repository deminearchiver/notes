import 'package:notes/l10n/l10n.dart';
import 'package:notes/views/onboarding/scope.dart';
import 'package:notes/views/onboarding/pages/setup.dart';
import 'package:notes/views/onboarding/scaffold.dart';
import 'package:notes/flutter.dart';

class OnboardingWelcome extends StatelessWidget {
  const OnboardingWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return OnboardingScaffold(
      icon: const Icon(MaterialSymbols.waving_hand_rounded),
      title: localizations.onboarding_welcome_view_title,
      subtitle: localizations.onboarding_welcome_view_subtitle,
      actions: [
        Flexible.tight(
          child: FilledButton.tonal(
            onPressed: () =>
                OnboardingScope.of(context).next(const OnboardingSetup()),
            child: Text(localizations.onboarding_next),
          ),
        ),
      ],
    );
  }
}
