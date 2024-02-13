import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/views/onboarding/scope.dart';
import 'package:notes/views/onboarding/pages/setup.dart';
import 'package:notes/views/onboarding/scaffold.dart';
import 'package:true_material/material.dart';

class OnboardingWelcome extends StatelessWidget {
  const OnboardingWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return OnboardingScaffold(
      supportsBackAction: false,
      icon: const Icon(Symbols.handshake_rounded),
      title: localizations.onboarding_welcome_view_title,
      subtitle: localizations.onboarding_welcome_view_subtitle,
      actions: [
        FilledButton(
          onPressed: () => OnboardingScope.of(context).next(
            const OnboardingSetup(),
          ),
          child: Text(localizations.onboarding_next),
        ),
      ],
    );
  }
}
