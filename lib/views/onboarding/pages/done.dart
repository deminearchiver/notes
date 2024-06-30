import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/views/onboarding/scope.dart';
import 'package:notes/views/onboarding/scaffold.dart';
import 'package:provider/provider.dart';
import 'package:material/material.dart';

class OnboardingDone extends StatelessWidget {
  const OnboardingDone({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return OnboardingScaffold(
      icon: const Icon(Symbols.celebration_rounded),
      title: localizations.onboarding_done_view_title,
      subtitle: localizations.onboarding_done_view_subtitle,
      actions: [
        Expanded(
          child: TextButton(
            onPressed: OnboardingScope.of(context).back,
            child: Text(localizations.onboarding_back),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton(
            onPressed: () {
              context.read<Settings>().firstRun = false;
              OnboardingScope.of(context).close();
            },
            child: Text(localizations.onboarding_done_view_action),
          ),
        ),
      ],
    );
  }
}
