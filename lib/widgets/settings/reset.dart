import 'package:material/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/settings/settings.dart';

Future<void> showSettingsResetDialog({
  required BuildContext context,
  bool useRootNavigator = false,
}) async {
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final materialLocalizations = MaterialLocalizations.of(context);
  final theme = Theme.of(context);
  final result = await showDialog<bool>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (context) => AlertDialog(
      icon: const Icon(Symbols.reset_wrench_rounded),
      title: const Text("Reset preferences"),
      content: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: "Are you sure you want to reset ALL your preferences?\n\n",
            ),
            TextSpan(
              children: const [
                TextSpan(text: "This action "),
                TextSpan(
                  text: "CANNOT",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: " be undone."),
              ],
              style: TextStyle(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
        style: theme.textTheme.bodyLarge!.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () => navigator.pop(false),
          child: Text(materialLocalizations.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => navigator.pop(true),
          child: Text(materialLocalizations.continueButtonLabel),
        ),
      ],
    ),
  );
  if (result != true || !context.mounted) return;
  Settings.read(context).resetAll();
}
