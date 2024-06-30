import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/constants/images.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/main.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/views/license/license.dart';
import 'package:notes/widgets/back_button.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:notes/widgets/switcher/top_level.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:material/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

const copyright = "Copyright (c) 2024, deminearchiver";

class _AboutViewState extends State<AboutView> {
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
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            toolbarHeight: 64,
            leadingWidth: 64,
            leading: const BackIconButton(),
            title: Text(localizations.about_app),
          ),
          MultiSliver(
            pushPinnedChildren: true,
            children: [
              SliverList.list(
                children: [
                  const SizedBox(height: 16),
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
                    appVersion,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: FilledButton.tonalIcon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialRoute.sharedAxis(
                          builder: (context) => LicensePage(
                            applicationIcon: const Padding(
                              padding: EdgeInsets.all(16),
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
                      icon: const Icon(Symbols.license_rounded),
                      label: const Text("View open source licenses"),
                    ),
                  ),
                  Center(
                    child: FilledButton.tonalIcon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialRoute.sharedAxis(
                          builder: (context) => const LicensesView(),
                        ),
                      ),
                      icon: const Icon(Symbols.license_rounded),
                      label: const Text("View open source licenses"),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // SectionHeader(
                  //     localizations.about_view_technologies),
                  // ListTile(
                  //   onTap: () =>
                  //       launchUrl(Uri.parse("https://flutter.dev")),
                  //   leading: const Icon(SimpleIcons.flutter),
                  //   title: const Text("Flutter"),
                  //   subtitle: Text(localizations.framework),
                  //   trailing: const Icon(Symbols.open_in_new_rounded),
                  // ),
                  // ListTile(
                  //   onTap: () => launchUrl(
                  //       Uri.parse("https://m3.material.io")),
                  //   leading:
                  //       const Icon(Symbols.design_services_rounded),
                  //   title: const Text("Material Design"),
                  //   subtitle: Text(localizations.design_system),
                  //   trailing: const Icon(Symbols.open_in_new_rounded),
                  // ),
                  // ListTile(
                  //   onTap: () => launchUrl(
                  //       Uri.parse("https://fonts.google.com/icons")),
                  //   leading:
                  //       const Icon(SimpleIcons.materialdesignicons),
                  //   title: const Text("Material Symbols"),
                  //   subtitle: Text(localizations.icons),
                  //   trailing: const Icon(Symbols.open_in_new_rounded),
                  // ),
                  // if (settings.developerMode)
                  //   ListTile(
                  //     onTap: () => launchUrl(
                  //         Uri.parse("https://fonts.google.com/noto")),
                  //     leading: const Icon(SimpleIcons.googlefonts),
                  //     title: const Text("Noto Sans"),
                  //     subtitle: Text(localizations.font),
                  //     trailing: const Icon(Symbols.open_in_new_rounded),
                  //   ),
                  // const Divider(),
                  // SectionHeader(localizations.about_view_links),
                  // ListTile(
                  //   onTap: () => launchUrl(Uri.parse(
                  //       "https://github.com/deminearchiver/notes")),
                  //   leading: const Icon(SimpleIcons.github),
                  //   title: Text("GitHub"),
                  //   subtitle: Text("deminearchiver/notes"),
                  //   trailing: const Icon(Symbols.open_in_new_rounded),
                  // ),
                  // ListTile(
                  //   onTap: () => Navigator.push(
                  //     context,
                  //     MaterialRoute.adaptive(
                  //       builder: (context) => LicensePage(
                  //         applicationIcon: Padding(
                  //           padding: const EdgeInsets.all(8),
                  //           child: SizedBox.square(
                  //             dimension: 96,
                  //             child: icon,
                  //           ),
                  //         ),
                  //         applicationName: localizations.app_name,
                  //         applicationVersion: appVersion,
                  //       ),
                  //     ),
                  //   ),
                  //   leading: const Icon(Symbols.license_rounded),
                  //   subtitle: const Text(copyright),
                  //   title: Text(localizations.about_view_licenses),
                  //   trailing:
                  //       const Icon(Symbols.navigate_next_rounded),
                  // ),
                ],
              ),
              const SliverToBoxAdapter(
                child: SectionHeader(
                  "Links",
                  showDivider: true,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverGrid.extent(
                  maxCrossAxisExtent: 256,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    LinkCard(
                      onTap: () => launchUrl(
                        Uri.parse("https://github.com/deminearchiver/notes"),
                      ),
                      icon: const Icon(SimpleIcons.github),
                      title: const Text("Repository"),
                      subtitle: const Text("View app's source code"),
                      tooltip: "github.com/deminearchiver/notes",
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: SectionHeader(
                  "Technologies",
                  showDivider: true,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverGrid.extent(
                  maxCrossAxisExtent: 256,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    LinkCard(
                      onTap: () => launchUrl(
                        Uri.parse("https://flutter.dev"),
                      ),
                      icon: const Icon(SimpleIcons.flutter),
                      title: const Text("Flutter"),
                      subtitle: const Text("Framework"),
                      tooltip: "flutter.dev",
                    ),
                    LinkCard(
                      onTap: () => launchUrl(
                        Uri.parse("https://m3.material.io"),
                      ),
                      icon: const Icon(Symbols.design_services_rounded),
                      title: const Text("Material You"),
                      subtitle: const Text("Design system"),
                      tooltip: "m3.material.io",
                    ),
                    LinkCard(
                      onTap: () => launchUrl(
                        Uri.parse("https://fonts.google.com/icons"),
                      ),
                      icon: const Icon(Symbols.design_services_rounded),
                      title: const Text("Material Symbols"),
                      subtitle: const Text("Icons"),
                      tooltip: "fonts.google.com/icons",
                    ),
                    LinkCard(
                      onTap: () => launchUrl(
                        Uri.parse("https://fleather-editor.github.io"),
                      ),
                      icon: const Icon(Symbols.font_download_rounded),
                      title: const Text("Fleather"),
                      subtitle: const Text("Rich text editor"),
                      tooltip: "fleather-editor.github.io",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LinkCard extends StatelessWidget {
  const LinkCard({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
    this.subtitle,
    this.tooltip,
  });

  final VoidCallback? onTap;

  final Widget icon;
  final Widget title;
  final Widget? subtitle;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Widget widget = Card.outlined(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme.merge(
                data: IconThemeData(
                  color: theme.colorScheme.primary,
                  size: 36,
                ),
                child: icon,
              ),
              const SizedBox(height: 8),
              DefaultTextStyle(
                style: theme.textTheme.titleMedium!,
                textAlign: TextAlign.center,
                child: title,
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: DefaultTextStyle(
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.disabledColor,
                    ),
                    textAlign: TextAlign.center,
                    child: subtitle!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    return tooltip != null
        ? Tooltip(
            message: tooltip,
            child: widget,
          )
        : widget;
  }
}
