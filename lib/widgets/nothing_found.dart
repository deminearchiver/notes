import 'package:notes/flutter.dart';
import 'package:notes/l10n/l10n.dart';

class NothingFound extends StatelessWidget {
  const NothingFound({super.key, required this.icon});

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    return Flex.vertical(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconTheme.mergeWithData(
          data: IconThemeDataPartial.from(
            size: 36,
            color: theme.colorScheme.primary,
          ),
          child: icon,
        ),
        const SizedBox(height: 16),
        Text(localizations.search_no_results, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}
