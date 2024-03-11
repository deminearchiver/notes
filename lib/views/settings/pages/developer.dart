import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/database/database.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/views/settings/scaffold.dart';
import 'package:notes/views/settings/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:material/material.dart';

class SettingsViewDeveloperPage extends StatefulWidget {
  const SettingsViewDeveloperPage({super.key});

  @override
  State<SettingsViewDeveloperPage> createState() =>
      _SettingsViewDeveloperPageState();
}

class _SettingsViewDeveloperPageState extends State<SettingsViewDeveloperPage> {
  bool _createdDemos = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final settings = context.watch<Settings>();
    return SettingsScaffold.sliver(
      title: Text("Для разработчиков"),
      slivers: [
        SliverPinnedHeader(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Card.filled(
              color: theme.colorScheme.secondaryContainer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
              child: ListTile(
                onTap: () => settings.developerMode = !settings.developerMode,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                leading: Icon(
                  Symbols.code_rounded,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                title: Text(
                  "Режим разработчика",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                trailing: Switch(
                  onChanged: (value) => settings.developerMode = value,
                  value: settings.developerMode,
                ),
              ),
            ),
          ),
        ),
        SliverClip(
          child: SliverList.list(
            children: [
              SettingsSectionHeader("Демо-режим",
                  enabled: settings.developerMode),
              SettingsListTile(
                enabled: settings.developerMode,
                leading: Icon(Symbols.podium_rounded),
                title: Text("Демо записи"),
                subtitle: Text("Заметки и задачи для презентации"),
                trailing: FilledButton.tonal(
                  onPressed: settings.developerMode && !_createdDemos
                      ? () async {
                          Database.createDemoRecords();
                          if (context.mounted) {
                            setState(() => _createdDemos = true);
                          }
                        }
                      : null,
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedSize(
                        duration: Durations.medium4,
                        curve: Easing.emphasized,
                        alignment: Alignment.centerRight,
                        clipBehavior: Clip.none,
                        child: _createdDemos
                            ? const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(Symbols.check_rounded),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const Text("Создать"),
                    ],
                  ),
                ),
              ),
              SettingsListTile(
                enabled: settings.developerMode,
                leading: const Icon(Symbols.delete_forever_rounded),
                title: Text("Очистить базу данных"),
                subtitle: Text("Удалить все записи из базы данных"),
                trailing: OutlinedButton(
                  onPressed: settings.developerMode
                      ? () async {
                          await Database.clear();
                          if (context.mounted) {
                            setState(() => _createdDemos = false);
                          }
                        }
                      : null,
                  child: Text("Очистить"),
                ),
              ),
              // SettingsListTile.toggle(
              //   onChanged: settings.developerMode ? (value) {} : null,
              //   value: false,
              //   leading: Icon(Symbols.update_rounded),
              //   title: Text("Авто-обновление"),
              //   subtitle: Text("Обновлять демо-записи при запуске"),
              // ),
              // SettingsSectionHeader("Отладка", enabled: settings.developerMode),
            ],
          ),
        ),
      ],
    );
  }
}
