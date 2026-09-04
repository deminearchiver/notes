import 'dart:async';

import 'package:notes/constants/images.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/main.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:notes/widgets/switcher/top_level.dart';
import 'package:notes/flutter.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

enum _AboutPage { application, author }

const copyright = "Copyright (c) 2024, deminearchiver";

class _AboutViewState extends State<AboutView> {
  late ScrollController _scrollController;

  _AboutPage _page = _AboutPage.application;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ignore: unused_element
  void _goToPage(_AboutPage value) {
    setState(() => _page = value);
    unawaited(
      _scrollController.animateTo(
        0,
        duration: Durations.medium4,
        curve: Easing.standardDecelerate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    const icon = Image(image: Images.ic_launcher);
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            toolbarHeight: 64,
            leadingWidth: 64,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const AppIcon(.arrowBack),
            ),
            title: Text(
              localizations.about_app,
            ), //TODO: remove when add segmented button
            // START FLEXIBLE SPACE
            // toolbarHeight: 80,
            // flexibleSpace: Flex.vertical(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            //       // padding: const EdgeInsets.all(16),
            //       child: SegmentedButton(
            //         onSelectionChanged: (value) => _goToPage(value.first),
            //         selected: {_page},
            //         showSelectedIcon: false,
            //         segments: [
            //           ButtonSegment(
            //             value: _AboutPage.application,
            //             icon: const Icon(
            //               MaterialSymbols.smartphone_rounded,
            //               fill: 1,
            //             ),
            //             label: Text(localizations.about_app),
            //           ),
            //           ButtonSegment(
            //             value: _AboutPage.author,
            //             icon: const Icon(
            //               MaterialSymbols.person_rounded,
            //               fill: 1,
            //             ),
            //             label: Text(localizations.about_author),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // END FLEXIBLE SPACE

            // bottom: settings.developerMode
            //     ? PreferredSize(
            //         // preferredSize: const Size.fromHeight(64),
            //         preferredSize: const Size.fromHeight(72),
            //         child: Padding(
            //           padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            //           // padding: const EdgeInsets.all(16),
            //           child: SegmentedButton(
            //             onSelectionChanged: (value) => _goToPage(value.first),
            //             selected: {_page},
            //             showSelectedIcon: false,
            //             segments: [
            //               ButtonSegment(
            //                 value: _AboutPage.application,
            //                 icon: const Icon(
            //                   MaterialSymbols.smartphone_rounded,
            //                   fill: 1,
            //                 ),
            //                 label: Text(localizations.about_app),
            //               ),
            //               ButtonSegment(
            //                 value: _AboutPage.author,
            //                 icon: const Icon(
            //                   MaterialSymbols.person_rounded,
            //                   fill: 1,
            //                 ),
            //                 label: Text(localizations.about_author),
            //               ),
            //             ],
            //           ),
            //         ),
            //       )
            //     : null,
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            sliver: TopLevelSwitcher.sliver(
              sliver: KeyedSubtree(
                key: ValueKey(_page),
                child: switch (_page) {
                  _AboutPage.application => SliverList.list(
                    children: [
                      const SizedBox.square(dimension: 96, child: icon),
                      const SizedBox(height: 8),
                      Text(
                        localizations.app_name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        appVersion,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      SectionHeader(localizations.about_view_technologies),
                      ListTile(
                        onTap: () =>
                            launchUrl(Uri.parse("https://flutter.dev")),
                        leading: const Icon(SimpleIcons.flutter),
                        title: const Text("Flutter"),
                        subtitle: Text(localizations.framework),
                        trailing: const AppIcon(.openInNew),
                      ),
                      ListTile(
                        onTap: () =>
                            launchUrl(Uri.parse("https://m3.material.io")),
                        leading: const Icon(
                          MaterialSymbols.design_services_rounded,
                        ),
                        title: const Text("Material Design"),
                        subtitle: Text(localizations.design_system),
                        trailing: const AppIcon(.openInNew),
                      ),
                      ListTile(
                        onTap: () => launchUrl(
                          Uri.parse("https://fonts.google.com/icons"),
                        ),
                        leading: const Icon(SimpleIcons.materialdesignicons),
                        title: const Text("Material Symbols"),
                        subtitle: Text(localizations.icons),
                        trailing: const AppIcon(.openInNew),
                      ),
                      // if (settings.developerMode)
                      //   ListTile(
                      //     onTap: () => launchUrl(
                      //         Uri.parse("https://fonts.google.com/noto")),
                      //     leading: const Icon(SimpleIcons.googlefonts),
                      //     title: const Text("Noto Sans"),
                      //     subtitle: Text(localizations.font),
                      //     trailing: const Icon(MaterialSymbols.open_in_new_rounded),
                      //   ),
                      const Divider(),
                      SectionHeader(localizations.about_view_links),
                      ListTile(
                        onTap: () => launchUrl(
                          Uri.parse("https://github.com/deminearchiver/notes"),
                        ),
                        leading: const Icon(SimpleIcons.github),
                        title: const Text("GitHub"),
                        subtitle: const Text("deminearchiver/notes"),
                        trailing: const AppIcon(.openInNew),
                      ),
                      ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => LicensePage(
                              applicationIcon: const Padding(
                                padding: EdgeInsets.all(8),
                                child: SizedBox.square(
                                  dimension: 96,
                                  child: icon,
                                ),
                              ),
                              applicationName: localizations.app_name,
                              applicationVersion: appVersion,
                            ),
                          ),
                        ),
                        leading: const Icon(MaterialSymbols.license_rounded),
                        subtitle: const Text(copyright),
                        title: Text(localizations.about_view_licenses),
                        trailing: const AppIcon(.chevronForward),
                      ),
                    ],
                  ),
                  _AboutPage.author => SliverList.list(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: Images.deminearchiver),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "deminearchiver",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineLarge,
                      ),
                      // const SizedBox(height: 8),
                      // Text(
                      //   localizations.aka(localizations.app_author_nickname),
                      //   textAlign: TextAlign.center,
                      //   style: theme.textTheme.bodyLarge,
                      // ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SectionHeader("Опыт"),
                      ListTile(
                        onTap: () {},
                        leading: const Icon(SimpleIcons.flutter),
                        title: const Text("Dart и Flutter"),
                        subtitle: const Text("1 год - с 2023"),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: const Icon(SimpleIcons.javascript),
                        title: const Text(
                          "JavaScript, TypeScript и веб-технологии",
                        ),
                        subtitle: const Text("3 года - с 2021"),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: const Icon(SimpleIcons.qt),
                        title: const Text("C++, Qt и пр."),
                        subtitle: const Text("2 года - с 2022"),
                      ),
                      ListTile(
                        onTap: () {},
                        enabled: false,
                        // leading: const Icon(SimpleIcons.csharp),
                        title: const Text("C# и разработка игр"),
                        subtitle: const Text("1 год - в 2020"),
                      ),
                      const Divider(),
                      const SectionHeader("Социальные сети"),
                      ListTile(
                        onTap: () => launchUrl(
                          Uri.parse("https://github.com/deminearchiver"),
                        ),
                        leading: const Icon(SimpleIcons.github),
                        title: const Text("GitHub"),
                        subtitle: const Text("deminearchiver"),
                        trailing: const AppIcon(.openInNew),
                      ),
                      ListTile(
                        onTap: () => launchUrl(
                          Uri.parse("https://youtube.com/@deminearchiver"),
                        ),
                        leading: const Icon(SimpleIcons.youtube),
                        title: const Text("YouTube"),
                        subtitle: const Text("@deminearchiver"),
                        trailing: const AppIcon(.openInNew),
                      ),
                      ListTile(
                        onTap: () => launchUrl(
                          Uri.parse("https://twitch.tv/deminearchiver"),
                        ),
                        leading: const Icon(SimpleIcons.twitch),
                        title: const Text("Twitch"),
                        subtitle: const Text("deminearchiver"),
                        trailing: const AppIcon(.openInNew),
                      ),
                      ListTile(
                        onTap: () async {
                          unawaited(
                            Clipboard.setData(
                              const ClipboardData(text: "@deminearchiver"),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Скопировано в буфер обмена!"),
                            ),
                          );
                        },
                        leading: const Icon(SimpleIcons.discord),
                        title: const Text("Discord"),
                        subtitle: const Text("@deminearchiver"),
                        trailing: const AppIcon(.contentCopy),
                      ),
                      // ListTile(
                      //   onTap: () =>
                      //       launchUrl(Uri.parse("https://discord.com")),
                      //   enabled: false,
                      //   leading: const Icon(SimpleIcons.discord),
                      //   title: Text("Сервер Discord"),
                      //   subtitle: Text("discord.gg/xxxxx"),
                      //   trailing: const Icon(MaterialSymbols.open_in_new_rounded),
                      // ),
                      // ListTile(
                      //   onTap: () => launchUrl(Uri.parse(
                      //       "https://twitter.com/deminearchiver")),
                      //   leading: const Icon(SimpleIcons.x),
                      //   title: Text("X"),
                      //   subtitle: Text("@minearchiver"),
                      //   trailing: const Icon(MaterialSymbols.open_in_new_rounded),
                      // ),
                    ],
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
