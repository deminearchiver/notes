import 'package:intl/intl.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:true_material/material.dart';

Future<Locale?> showLanguagePickerDialog({
  Key? key,
  required BuildContext context,
  bool useRootNavigator = true,
  required Locale? initialLocale,
}) async {
  return await showDialog<Locale?>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (context) => LanguageChooserDialog(
      key: key,
      initialLocale: initialLocale,
    ),
  );
}

class LanguageChooserDialog extends StatefulWidget {
  const LanguageChooserDialog({
    super.key,
    required this.initialLocale,
  });

  final Locale? initialLocale;

  @override
  State<LanguageChooserDialog> createState() => _LanguageChooserDialogState();
}

class _LanguageChooserDialogState extends State<LanguageChooserDialog> {
  late Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void _setLocale(Locale? value) {
    setState(() => _locale = value);
  }

  void _popCancel(BuildContext context) {
    Navigator.pop(context, widget.initialLocale);
  }

  void _popResult(BuildContext context) {
    Navigator.pop(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final materialLocalizations = MaterialLocalizations.of(context);

    return AlertDialog(
      title: Text(localizations.pick_language),
      contentPadding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 0),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () => _setLocale(null),
                  selected: _locale == null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  leading: Radio<Locale?>(
                    onChanged: _setLocale,
                    value: null,
                    groupValue: _locale,
                  ),
                  title: Text(
                      localizations.settings_appearance_view_language_system),
                  subtitle: Text(Intl.defaultLocale ?? "..."),
                ),
                ...AppLocalizations.supportedLocales.map(
                  (locale) {
                    return ListTile(
                      onTap: () => _setLocale(locale),
                      selected: _locale == locale,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      leading: Radio<Locale?>(
                        onChanged: _setLocale,
                        value: locale,
                        groupValue: _locale,
                      ),
                      title: Text(
                        lookupAppLocalizations(locale)
                            .locale_name(locale.languageCode),
                      ),
                      subtitle:
                          Text(localizations.locale_name(locale.languageCode)),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 0),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => _popCancel(context),
          child: Text(materialLocalizations.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => _popResult(context),
          child: Text(materialLocalizations.okButtonLabel),
        ),
      ],
    );
  }
}
