import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/constants/images.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:notes/widgets/switcher/top_level.dart';
import 'package:provider/provider.dart';
import 'package:true_material/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

enum _AboutPage {
  application,
  author,
}

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
    _scrollController.animateTo(
      0,
      duration: Durations.medium4,
      curve: Easing.standardDecelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final settings = context.watch<Settings>();
    const icon = Image(
      image: Images.ic_launcher,
    );
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
            scrolledUnderElevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Symbols.arrow_back_rounded),
            ),
            title: Text(localizations
                .about_app), //TODO: remove when add segmented button
            // START FLEXIBLE SPACE
            // toolbarHeight: 80,
            // flexibleSpace: Column(
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
            //               Symbols.smartphone_rounded,
            //               fill: 1,
            //             ),
            //             label: Text(localizations.about_app),
            //           ),
            //           ButtonSegment(
            //             value: _AboutPage.author,
            //             icon: const Icon(
            //               Symbols.person_rounded,
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
            //                   Symbols.smartphone_rounded,
            //                   fill: 1,
            //                 ),
            //                 label: Text(localizations.about_app),
            //               ),
            //               ButtonSegment(
            //                 value: _AboutPage.author,
            //                 icon: const Icon(
            //                   Symbols.person_rounded,
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
                        SizedBox.square(
                          dimension: 96,
                          child: icon,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations.app_name,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "1.0.0",
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
                          title: Text("Flutter"),
                          subtitle: Text(localizations.framework),
                          trailing: const Icon(Symbols.open_in_new_rounded),
                        ),
                        ListTile(
                          onTap: () =>
                              launchUrl(Uri.parse("https://m3.material.io")),
                          leading: const Icon(Symbols.design_services_rounded),
                          title: const Text("Material Design"),
                          subtitle: Text(localizations.design_system),
                          trailing: const Icon(Symbols.open_in_new_rounded),
                        ),
                        ListTile(
                          onTap: () => launchUrl(
                              Uri.parse("https://fonts.google.com/icons")),
                          leading: const Icon(SimpleIcons.materialdesignicons),
                          title: const Text("Material Symbols"),
                          subtitle: Text(localizations.icons),
                          trailing: const Icon(Symbols.open_in_new_rounded),
                        ),
                        // if (settings.developerMode)
                        //   ListTile(
                        //     onTap: () => launchUrl(
                        //         Uri.parse("https://fonts.google.com/noto")),
                        //     leading: const Icon(SimpleIcons.googlefonts),
                        //     title: const Text("Noto Sans"),
                        //     subtitle: Text(localizations.font),
                        //     trailing: const Icon(Symbols.open_in_new_rounded),
                        //   ),
                        const Divider(),
                        SectionHeader(localizations.about_view_links),
                        ListTile(
                          onTap: () => launchUrl(Uri.parse(
                              "https://github.com/deminearchiver/notes")),
                          leading: const Icon(SimpleIcons.github),
                          title: Text("GitHub"),
                          subtitle: Text("deminearchiver/notes"),
                          trailing: const Icon(Symbols.open_in_new_rounded),
                        ),
                        ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialRoute.zoom(
                              child: LicensePage(
                                applicationIcon: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SizedBox.square(
                                    dimension: 96,
                                    child: icon,
                                  ),
                                ),
                                applicationName: localizations.app_name,
                                applicationVersion: "0.0.1",
                              ),
                            ),
                          ),
                          leading: const Icon(Symbols.license_rounded),
                          subtitle: const Text(copyright),
                          title: Text(localizations.about_view_licenses),
                          trailing: const Icon(Symbols.navigate_next_rounded),
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
                            image: DecorationImage(
                              image: Images.deminearchiver,
                            ),
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
                        SectionHeader("Опыт"),
                        ListTile(
                          onTap: () {},
                          leading: const Icon(SimpleIcons.flutter),
                          title: Text("Dart и Flutter"),
                          subtitle: Text("1 год - с 2023"),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: const Icon(SimpleIcons.javascript),
                          title:
                              Text("JavaScript, TypeScript и веб-технологии"),
                          subtitle: Text("3 года - с 2021"),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: const Icon(SimpleIcons.qt),
                          title: Text("C++, Qt и пр."),
                          subtitle: Text("2 года - с 2022"),
                        ),
                        ListTile(
                          onTap: () {},
                          enabled: false,
                          leading: const Icon(SimpleIcons.csharp),
                          title: Text("C# и разработка игр"),
                          subtitle: Text("1 год - в 2020"),
                        ),
                        const Divider(),
                        SectionHeader("Социальные сети"),
                        ListTile(
                          onTap: () => launchUrl(
                              Uri.parse("https://github.com/deminearchiver")),
                          leading: const Icon(SimpleIcons.github),
                          title: Text("GitHub"),
                          subtitle: Text("deminearchiver"),
                          trailing: const Icon(Symbols.open_in_new_rounded),
                        ),
                        ListTile(
                          onTap: () => launchUrl(
                              Uri.parse("https://youtube.com/@deminearchiver")),
                          leading: const Icon(SimpleIcons.youtube),
                          title: Text("YouTube"),
                          subtitle: Text("@deminearchiver"),
                          trailing: const Icon(Symbols.open_in_new_rounded),
                        ),
                        ListTile(
                          onTap: () => launchUrl(
                              Uri.parse("https://twitch.tv/deminearchiver")),
                          leading: const Icon(SimpleIcons.twitch),
                          title: Text("Twitch"),
                          subtitle: Text("deminearchiver"),
                          trailing: const Icon(Symbols.open_in_new_rounded),
                        ),
                        ListTile(
                          onTap: () async {
                            Clipboard.setData(
                              const ClipboardData(text: "@deminearchiver"),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Скопировано в буфер обмена!"),
                              ),
                            );
                          },
                          leading: const Icon(SimpleIcons.discord),
                          title: Text("Discord"),
                          subtitle: Text("@deminearchiver"),
                          trailing: const Icon(Symbols.content_copy_rounded),
                        ),
                        // ListTile(
                        //   onTap: () =>
                        //       launchUrl(Uri.parse("https://discord.com")),
                        //   enabled: false,
                        //   leading: const Icon(SimpleIcons.discord),
                        //   title: Text("Сервер Discord"),
                        //   subtitle: Text("discord.gg/xxxxx"),
                        //   trailing: const Icon(Symbols.open_in_new_rounded),
                        // ),
                        // ListTile(
                        //   onTap: () => launchUrl(Uri.parse(
                        //       "https://twitter.com/deminearchiver")),
                        //   leading: const Icon(SimpleIcons.x),
                        //   title: Text("X"),
                        //   subtitle: Text("@minearchiver"),
                        //   trailing: const Icon(Symbols.open_in_new_rounded),
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
