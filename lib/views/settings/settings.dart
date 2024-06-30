import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/views/settings/pages/developer.dart';
import 'package:notes/views/settings/scaffold.dart';
import 'package:notes/views/settings/widgets.dart';
import 'package:notes/views/about/about.dart';
import 'package:notes/widgets/dialog/language_picker.dart';
import 'package:provider/provider.dart';

import 'package:material/material.dart';
import 'package:http/http.dart' as http;
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final settings = context.watch<Settings>();
    return SettingsScaffold.list(
      title: Text(localizations.settings_view),
//       actions: [
//               IconButton(
//                 onPressed: () async {
//                   final snackbar = ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: const Text("Проверка обновлений..."),
//                       action: SnackBarAction(
//                         onPressed: () {},
//                         label: "Cancel",
//                       ),
//                     ),
//                   );
//                   await Future.delayed(Durations.extralong4);
//                   if (!context.mounted) return;
//                   snackbar.close();
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: const Text("Обновление"),
//                       content: const SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Text("Найдена новая версия!"),
//                             MarkdownBody(data: """
// ## 1.1.0
// ### Нововведения
// """),
//                           ],
//                         ),
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context, false),
//                           child: const Text("Отмена"),
//                         ),
//                         TextButton(
//                           onPressed: () => Navigator.pop(context, true),
//                           child: const Text("Установить"),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 icon: const Icon(Symbols.update_rounded),
//               ),
//               const SizedBox(width: 16),
//             ],
      children: [
        // SettingsListTile.topLevel(
        //   leading: const Icon(
        //     Symbols.account_circle_rounded,
        //     fill: 1,
        //     size: 36,
        //   ),
        //   title: Text(
        //     "Аккаунт",
        //     style: theme.textTheme.titleLarge,
        //   ),
        //   trailing: FilledButton(
        //     onPressed: _showAccountPage,
        //     child: const Icon(Symbols.login_rounded),
        //   ),
        // ),
        // SettingsListTile.topLevel(
        //   leading: const CircleAvatar(
        //     foregroundImage: Images.deminearchiver,
        //   ),
        //   title: Text(
        //     "Вход выполнен",
        //     style: theme.textTheme.titleLarge,
        //   ),
        //   subtitle: const Text("deminearchiver"),
        //   trailing: FilledButton.tonal(
        //     onPressed: _showAccountPage,
        //     // child: Text("Параметры"),
        //     child: const Icon(Symbols.settings_rounded),
        //   ),
        // ),
        SettingsSectionHeader(localizations.settings_view_options),
        // if (settings.developerMode)
        //   SettingsListTile.topLevel(
        //     onTap: () => Navigator.push(
        //       context,
        //       MaterialRoute.sharedAxis(
        //         builder: (context) => const SettingsViewGeneralPage(),
        //       ),
        //     ),
        //     leading: const Icon(Symbols.settings_rounded),
        //     title: Text(localizations.settings_general_view),
        //     subtitle: Text(localizations.settings_general_view_description),
        //     trailing: const Icon(Symbols.navigate_next_rounded),
        //   ),
        SettingsListTile.topLevel(
          onTap: () => Navigator.push(
            context,
            MaterialRoute.sharedAxis(
              builder: (context) => const SettingsViewAppearancePage(),
            ),
          ),
          leading: const Icon(
            Symbols.brush_rounded,
            fill: 1,
          ),
          title: Text(localizations.settings_appearance_view),
          subtitle: Text(localizations.settings_appearance_view_description),
          trailing: const Icon(Symbols.navigate_next_rounded),
        ),
        SettingsSectionHeader(localizations.settings_view_other),
        SettingsListTile.topLevel(
          onTap: () => Navigator.push(
            context,
            MaterialRoute.sharedAxis(builder: (context) => const AboutView()),
          ),
          leading: const Icon(Symbols.info_rounded),
          title: Text(localizations.settings_view_about),
          subtitle: Text(localizations.settings_view_about_description),
          trailing: const Icon(Symbols.navigate_next_rounded),
        ),
        // SettingsListTile(
        //   onTap: () => settings.developerMode = !settings.developerMode,
        //   leading: const Icon(Symbols.code_rounded),
        //   title: Text(localizations.settings_view_developer_mode),
        //   subtitle:
        //       Text(localizations.settings_view_developer_mode_description),
        //   trailing: Switch(
        //     onChanged: (value) => settings.developerMode = value,
        //     value: settings.developerMode,
        //   ),
        // ),
        // if (settings.developerMode)
        //   SettingsListTile(
        //     leading: const Icon(Symbols.podium_rounded),
        //     title: Text(localizations.settings_view_demo_mode),
        //     subtitle: Text(localizations.settings_view_demo_mode_description),
        //     trailing: FilledButton(
        //       onPressed: Database.createDemoRecords,
        //       child: Text(localizations.settings_view_demo_mode_action),
        //     ),
        //   ),
        // if (settings.developerMode)
        //   SettingsListTile(
        //     leading: const Icon(Symbols.clear_all_rounded),
        //     title: Text(localizations.settings_view_clear_database),
        //     subtitle:
        //         Text(localizations.settings_view_clear_database_description),
        //     trailing: FilledButton(
        //       onPressed: () => Database.clear(),
        //       child: Text(localizations.settings_view_clear_database_action),
        //     ),
        //   ),
        SettingsListTile.topLevel(
          onTap: () => Navigator.push(
            context,
            MaterialRoute.sharedAxis(
                builder: (context) => const SettingsViewDeveloperPage()),
          ),
          leading: const Icon(Symbols.code_rounded),
          title: Text("Для разработчиков"),
          subtitle: Text("Продвинутая функциональность"),
          trailing: const Icon(Symbols.navigate_next_rounded),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton.icon(
            onPressed: () async {
              final result = await showDialog<bool?>(
                context: context,
                builder: (context) => AlertDialog(
                  icon: const Icon(Symbols.reset_wrench_rounded),
                  title: Text(localizations.reset_settings),
                  content: Text(localizations.reset_settings_confirmation),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        MaterialLocalizations.of(context).okButtonLabel,
                      ),
                    ),
                  ],
                ),
              );
              if (result == true) {
                if (!context.mounted) return;
                context.read<Settings>().reset();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.reset_settings_success),
                    showCloseIcon: true,
                  ),
                );
              }
            },
            icon: const Icon(Symbols.reset_wrench_rounded),
            label: Text(localizations.reset_settings),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class SettingsViewGeneralPage extends StatelessWidget {
  const SettingsViewGeneralPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return SettingsScaffold.list(
      title: Text(localizations.settings_general_view),
      children: const [],
    );
  }
}

class SettingsViewAppearancePage extends StatelessWidget {
  const SettingsViewAppearancePage({super.key});

  Future<void> _chooseLanguage(BuildContext context) async {
    final settings = context.read<Settings>();
    final result = await showLanguagePickerDialog(
      context: context,
      initialLocale: settings.locale,
    );
    settings.locale = result;
    return;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return SettingsScaffold.list(
      title: Text(localizations.settings_appearance_view),
      children: [
        SettingsListTile(
          onTap: () => _chooseLanguage(context),
          leading: const Icon(Symbols.language_rounded),
          title: Text(localizations.settings_appearance_view_language),
          subtitle: Text(localizations
              .locale_name(Localizations.localeOf(context).languageCode)),
        ),
        const Divider(),
        SettingsListTile(
          leading: const Icon(Symbols.brightness_6_rounded),
          title: Text(localizations.settings_appearance_view_theme_mode),
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
    );
  }
}

class SettingsViewChangelogPage extends StatefulWidget {
  const SettingsViewChangelogPage({super.key});

  @override
  State<SettingsViewChangelogPage> createState() =>
      _SettingsViewChangelogPageState();
}

class _SettingsViewChangelogPageState extends State<SettingsViewChangelogPage> {
  static final _changelogUrl = Uri.parse(
    // "https://raw.githubusercontent.com/deminearchiver/notes/main/CHANGELOG.md",
    "https://raw.githubusercontent.com/deminearchiver/tab/main/README.md",
  );

  late Future<String> _changelog;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<String> _fetchChangelog() async {
    final response = await http.get(_changelogUrl);
    if (response.statusCode == 200) {
      final raw = response.body;
      final firstHeader = RegExp(r"^##? .+$", multiLine: true);
      return raw.trim().replaceFirst(firstHeader, "");
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> _reload() async {
    final changelog = _fetchChangelog();

    setState(() {
      _changelog = changelog;
    });

    await changelog.catchError((error) => "");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SettingsScaffold.sliver(
      onRefresh: _reload,
      title: Text("Changelog"),
      actions: [
        IconButton(
          onPressed: () => launchUrl(_changelogUrl),
          icon: const Icon(Symbols.open_in_new_rounded),
        ),
        const SizedBox(width: 16),
      ],
      slivers: [
        FutureBuilder(
          future: _changelog,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return SliverFillRemaining(
                child: Center(
                  child: Text(
                    "Failed to load changelog!\n"
                    "${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              );
            }
            return snapshot.connectionState == ConnectionState.done
                ? SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: MarkdownBody(
                        extensionSet: md.ExtensionSet.gitHubWeb,
                        data: snapshot.data!,
                      ),
                    ),
                  )
                : const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
          },
        ),
      ],
    );
  }
}
