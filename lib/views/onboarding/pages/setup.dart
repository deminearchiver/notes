import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/widgets/dialog/language_picker.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:notes/widgets/switcher/switcher.dart';
import 'package:provider/provider.dart';
import 'package:material/material.dart';
import 'package:notes/services/notifications.dart';
import 'package:notes/views/onboarding/scope.dart';
import 'package:notes/views/onboarding/scaffold.dart';

import 'done.dart';

class OnboardingSetup extends StatefulWidget {
  const OnboardingSetup({super.key});

  @override
  State<OnboardingSetup> createState() => _OnboardingSetupState();
}

class _OnboardingSetupState extends State<OnboardingSetup> {
  void _chooseLanguage() async {
    final settings = context.read<Settings>();
    final result = await showLanguagePickerDialog(
      context: context,
      initialLocale: settings.locale,
    );
    if (!context.mounted) return;
    settings.locale = result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    return OnboardingScaffold(
      icon: const Icon(Symbols.settings_rounded),
      title: localizations.onboarding_setup_view_title,
      subtitle: localizations.onboarding_setup_view_subtitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            onTap: _chooseLanguage,
            leading: const Icon(Symbols.language_rounded),
            title: Text("Язык"),
            trailing: FilledButton.tonal(
              onPressed: _chooseLanguage,
              child: Text("Выбрать"),
            ),
          ),
          const Divider(),
          SectionHeader(localizations.onboarding_setup_view_permissions),
          ValueListenableBuilder(
            valueListenable: NotificationService.permission,
            builder: (context, value, child) {
              return ListTile(
                onTap: value == true
                    ? null
                    : NotificationService.requestPermission,
                leading: const Icon(Symbols.notifications_active_rounded),
                title: Text("Уведомления"),
                trailing:
                    (value == null ? FilledButton.new : FilledButton.tonal)(
                  onPressed: value == true
                      ? null
                      : NotificationService.requestPermission,
                  child: AnimatedSize(
                    duration: Durations.medium4,
                    curve: Easing.emphasized,
                    clipBehavior: Clip.none,
                    child: Switcher.fadeThrough(
                      duration: Durations.short4,
                      layoutBuilder: (currentChild, previousChildren) {
                        return Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            ...previousChildren.map((e) => Align(
                                  alignment: Alignment.center,
                                  widthFactor: 0,
                                  heightFactor: 0,
                                  child: e,
                                )),
                            if (currentChild != null) currentChild,
                          ],
                        );
                      },
                      child: KeyedSubtree(
                          key: ValueKey(value),
                          child: switch (value) {
                            true => const Icon(Symbols.check_rounded),
                            false => const Icon(Symbols.close_rounded),
                            null => Text("Разрешить"),
                          }),
                    ),
                  ),
                ),
              );
            },
          ),
          const Divider(),
          SectionHeader(localizations.onboarding_setup_view_appearance),
          ListTile(
            leading: const Icon(Symbols.brightness_6_rounded),
            title: Text(localizations.onboarding_setup_view_theme),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Consumer<Settings>(
              builder: (context, settings, child) => SegmentedButton(
                onSelectionChanged: (value) => settings.themeMode = value.first,
                selected: {settings.themeMode},
                segments: [
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: const Icon(Symbols.light_mode_rounded),
                    label: Text(localizations.theme_light),
                    tooltip: localizations.theme_light_tooltip,
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: const Icon(Symbols.auto_mode_rounded),
                    label: Text(localizations.theme_auto),
                    tooltip: localizations.theme_auto_tooltip,
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: const Icon(Symbols.dark_mode_rounded),
                    label: Text(localizations.theme_dark),
                    tooltip: localizations.theme_dark_tooltip,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        Expanded(
          child: OutlinedButton(
            onPressed: OnboardingScope.of(context).back,
            child: Text(localizations.onboarding_back),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FutureBuilder(
            future: NotificationService.hasPermission,
            builder: (context, snapshot) {
              return FilledButton.tonal(
                onPressed: snapshot.hasData
                    ? () =>
                        OnboardingScope.of(context).next(const OnboardingDone())
                    : null,
                child: Text(localizations.onboarding_next),
              );
            },
          ),
        ),
      ],
    );
  }
}
