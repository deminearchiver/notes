import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/views/onboarding/scope.dart';
import 'package:notes/views/onboarding/pages/setup.dart';
import 'package:notes/views/onboarding/scaffold.dart';
import 'package:material/material.dart';

class OnboardingWelcome extends StatelessWidget {
  const OnboardingWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return OnboardingScaffold(
      icon: const Icon(Symbols.waving_hand_rounded),
      title: localizations.onboarding_welcome_view_title,
      subtitle: localizations.onboarding_welcome_view_subtitle,
      actions: [
        Expanded(
          child: FilledButton.tonal(
            onPressed: () => OnboardingScope.of(context).next(
              const OnboardingSetup(),
            ),
            child: Text(localizations.onboarding_next),
          ),
        ),
      ],
    );
  }
}
