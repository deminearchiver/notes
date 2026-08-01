import 'dart:async';

import 'package:notes/database/isar/database.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/views/settings/scaffold.dart';
import 'package:notes/views/settings/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart' show SliverPinnedHeader;
import 'package:notes/flutter.dart';

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
    final settings = context.watch<Settings>();
    return SettingsScaffold.sliver(
      title: const Text("Для разработчиков"),
      slivers: [
        SliverPinnedHeader(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Card.filled(
              color: theme.colorScheme.secondaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: ListTile(
                onTap: () => settings.developerMode = !settings.developerMode,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                leading: Icon(
                  MaterialSymbols.code_rounded,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                title: Text(
                  "Режим разработчика",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                trailing: Switch(
                  onCheckedChanged: (value) => settings.developerMode = value,
                  checked: settings.developerMode,
                ),
              ),
            ),
          ),
        ),
        SliverClip(
          child: SliverList.list(
            children: [
              SettingsSectionHeader(
                "Демо-режим",
                enabled: settings.developerMode,
              ),
              SettingsListTile(
                enabled: settings.developerMode,
                leading: const Icon(MaterialSymbols.podium_rounded),
                title: const Text("Демо записи"),
                subtitle: const Text("Заметки и задачи для презентации"),
                trailing: FilledButton.tonal(
                  onPressed: settings.developerMode && !_createdDemos
                      ? () async {
                          unawaited(Database.createDemoRecords());
                          if (context.mounted) {
                            setState(() => _createdDemos = true);
                          }
                        }
                      : null,
                  clipBehavior: Clip.antiAlias,
                  child: Flex.horizontal(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedSize(
                        duration: Durations.medium4,
                        curve: Curves.easeInOutCubicEmphasized,
                        alignment: Alignment.centerRight,
                        clipBehavior: Clip.none,
                        child: _createdDemos
                            ? const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(MaterialSymbols.check_rounded),
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
                leading: const Icon(MaterialSymbols.delete_forever_rounded),
                title: const Text("Очистить базу данных"),
                subtitle: const Text("Удалить все записи из базы данных"),
                trailing: OutlinedButton(
                  onPressed: settings.developerMode
                      ? () async {
                          await Database.clear();
                          if (context.mounted) {
                            setState(() => _createdDemos = false);
                          }
                        }
                      : null,
                  child: const Text("Очистить"),
                ),
              ),
              // SettingsListTile.toggle(
              //   onChanged: settings.developerMode ? (value) {} : null,
              //   value: false,
              //   leading: Icon(MaterialSymbols.update_rounded),
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
