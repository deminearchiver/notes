import 'package:notes/l10n/l10n.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/widgets/dialog/language_picker.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:notes/widgets/switcher/switcher.dart';
import 'package:provider/provider.dart';
import 'package:notes/flutter.dart';
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
  Future<void> _chooseLanguage() async {
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
    final localizations = AppLocalizations.of(context);
    return OnboardingScaffold(
      supportsBackAction: false,
      icon: const Icon(MaterialSymbols.settings_rounded),
      title: localizations.onboarding_setup_view_title,
      subtitle: localizations.onboarding_setup_view_subtitle,
      content: Flex.vertical(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            onTap: _chooseLanguage,
            leading: const Icon(MaterialSymbols.language_rounded),
            title: const Text("Язык"),
            trailing: FilledButton.tonal(
              onPressed: _chooseLanguage,
              child: const Text("Выбрать"),
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
                leading: const Icon(
                  MaterialSymbols.notifications_active_rounded,
                ),
                title: const Text("Уведомления"),
                trailing:
                    (value == null ? FilledButton.new : FilledButton.tonal)(
                      onPressed: value == true
                          ? null
                          : NotificationService.requestPermission,
                      child: AnimatedSize(
                        duration: Durations.medium4,
                        curve: Curves.easeInOutCubicEmphasized,
                        clipBehavior: Clip.none,
                        child: Switcher.fadeThrough(
                          duration: Durations.short4,
                          layoutBuilder: (currentChild, previousChildren) {
                            return Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                ...previousChildren.map(
                                  (e) => Align(
                                    alignment: Alignment.center,
                                    widthFactor: 0,
                                    heightFactor: 0,
                                    child: e,
                                  ),
                                ),
                                ?currentChild,
                              ],
                            );
                          },
                          child: KeyedSubtree(
                            key: ValueKey(value),
                            child: switch (value) {
                              true => const Icon(MaterialSymbols.check_rounded),
                              false => const Icon(
                                MaterialSymbols.close_rounded,
                              ),
                              null => const Text("Разрешить"),
                            },
                          ),
                        ),
                      ),
                    ),
              );
            },
          ),
          const Divider(),
          SectionHeader(localizations.onboarding_setup_view_appearance),
          ListTile(
            leading: const Icon(MaterialSymbols.brightness_6_rounded),
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
                    icon: const Icon(MaterialSymbols.light_mode_rounded),
                    label: Text(localizations.theme_light),
                    tooltip: localizations.theme_light_tooltip,
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: const Icon(MaterialSymbols.auto_mode_rounded),
                    label: Text(localizations.theme_auto),
                    tooltip: localizations.theme_auto_tooltip,
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: const Icon(MaterialSymbols.dark_mode_rounded),
                    label: Text(localizations.theme_dark),
                    tooltip: localizations.theme_dark_tooltip,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actionsLayout: OnboardingActionsLayout.row,
      actions: [
        Flexible.tight(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.onboarding_back),
          ),
        ),
        const SizedBox(width: 8),
        Flexible.tight(
          child: FutureBuilder(
            future: NotificationService.hasPermission,
            builder: (context, snapshot) {
              return FilledButton.tonal(
                onPressed: snapshot.hasData
                    ? () => OnboardingScope.of(
                        context,
                      ).next<void>(const OnboardingDone())
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
