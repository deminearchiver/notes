import 'dart:ui';

import 'package:material/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/views/about/about.dart';
import 'package:notes/widgets/back_button.dart';
import 'package:notes/widgets/route/route.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:notes/widgets/settings/reset.dart';
import 'package:notes/widgets/settings/tiles.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showBrightnessPicker({
  required BuildContext context,
  bool useRootNavigator = false,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final settings = Settings.watch(context);

      return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              onChanged: (value) => settings.useSystemBrightness = value,
              value: settings.useSystemBrightness,
              secondary: const Icon(Symbols.auto_mode_rounded),
              title: Text("Use system brightness"),
              subtitle: Text("Default brightness of your system"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SegmentedButton<Brightness>(
                onSelectionChanged: !settings.useSystemBrightness
                    ? (values) => settings.brightness = values.first
                    : null,
                selected: {settings.brightness},
                segments: const [
                  ButtonSegment(
                    value: Brightness.light,
                    icon: Icon(Symbols.light_mode_rounded),
                    label: Text("Light"),
                  ),
                  ButtonSegment(
                    value: Brightness.dark,
                    icon: Icon(Symbols.dark_mode_rounded),
                    label: Text("Dark"),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showLanguagePicker({
  required BuildContext context,
  bool useRootNavigator = false,
}) async {
  final materialLocalizations = MaterialLocalizations.of(context);
  final navigator = Navigator.of(context);
  await showDialog(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (context) {
      final settings = Settings.watch(context);
      return AlertDialog(
        title: const Text("Choose a language"),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...SupportedLocale.values.map(
              (value) => RadioListTile(
                value: value,
                groupValue: settings.locale,
                onChanged: (value) => settings.locale = value!,
                contentPadding: EdgeInsets.symmetric(horizontal: 24),
                title: Text(value.name),
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.only(top: 20, bottom: 24),
        actions: [
          TextButton(
            onPressed: navigator.pop,
            child: Text(materialLocalizations.okButtonLabel),
          ),
        ],
      );
    },
  );
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _itemKey = GlobalKey();
  bool _opened = false;

  void _openView() {
    final navigator = Navigator.of(context);
    navigator.push(
      _SettingsOptionRoute(
        itemKey: _itemKey,
        leading: const Icon(Symbols.toolbar_rounded),
        title: Text("Edit toolbar"),
        subtitle: Text("SUBTITLE"),
        trailing: const Icon(Symbols.navigate_next_rounded),
        viewBuilder: (context) => Column(
          children: [
            ListTile(
              onTap: () {},
              title: Text("LOL"),
            ),
          ],
        ),
      ),
    );
    setState(() => _opened = true);
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);

    final settings = Settings.watch(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leadingWidth: 64,
            automaticallyImplyLeading: false,
            leading: navigator.canPop() ? const BackIconButton() : null,
            title: Text("Settings"),
            actions: [
              IconButton(
                onPressed: () => launchUrl(
                  Uri.parse("https://github.com/deminearchiver/notes/wiki"),
                ),
                icon: const Icon(Symbols.help_rounded),
                tooltip: "Help and feedback",
              ),
              const Gap(8),
            ],
          ),
          SliverList.list(
            children: [
              const SectionHeader("Appearance"),
              const DynamicColorSettingsTile(),
              const BrightnessSettingsTile(),
              const SectionHeader("Behaviours"),
              ListTile(
                key: _itemKey,
                onTap: _openView,
                leading: const Icon(Symbols.toolbar_rounded),
                title: Text("Edit toolbar"),
                subtitle: Text("SUBTITLE"),
                trailing: const Icon(Symbols.navigate_next_rounded),
              ),
              const EditorKindSettingsTile(),
              const SectionHeader("Other"),
              ListTile(
                onTap: () => navigator.push(
                  MaterialRoute.sharedAxis(
                    builder: (context) => const AboutView(),
                  ),
                ),
                leading: const Icon(Symbols.info_rounded),
                title: const Text("About"),
                subtitle: const Text("Information about the app"),
                trailing: const Icon(Symbols.navigate_next_rounded),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Center(
                  child: OutlinedButton.icon(
                    onPressed: () => showSettingsResetDialog(
                      context: context,
                    ),
                    icon: const Icon(
                      Symbols.reset_wrench_rounded,
                      size: 18,
                      opticalSize: 18,
                    ),
                    label: const Text("Reset preferences"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsOptionRoute<T> extends PopupRoute<T> {
  _SettingsOptionRoute({
    required this.itemKey,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.viewBuilder,
  });

  final GlobalKey itemKey;

  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;

  final WidgetBuilder viewBuilder;

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.38);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => Durations.long4;
  // Duration get transitionDuration => Duration(seconds: 5);

  @override
  Duration get reverseTransitionDuration => Durations.long4;
  // Duration get reverseTransitionDuration => Duration(seconds: 5);

  @override
  Widget buildModalBarrier() {
    Widget barrier;
    if (barrierColor != null && barrierColor!.alpha != 0 && !offstage) {
      final animation = CurvedAnimation(
        parent: this.animation!,
        curve: Curves.easeInOutCubicEmphasized,
        reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
      );

      assert(barrierColor != barrierColor!.withOpacity(0.0));
      final color = animation.drive(
        ColorTween(
          begin: barrierColor!.withOpacity(0.0),
          end: barrierColor,
        ).chain(
          CurveTween(curve: barrierCurve),
        ),
      );
      barrier = AnimatedModalBarrier(
        color: color,
        dismissible:
            barrierDismissible, // changedInternalState is called if barrierDismissible updates
        semanticsLabel:
            barrierLabel, // changedInternalState is called if barrierLabel updates
        barrierSemanticsDismissible: semanticsDismissible,
      );
    } else {
      barrier = ModalBarrier(
        dismissible:
            barrierDismissible, // changedInternalState is called if barrierDismissible updates
        semanticsLabel:
            barrierLabel, // changedInternalState is called if barrierLabel updates
        barrierSemanticsDismissible: semanticsDismissible,
      );
    }

    return barrier;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    animation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );
    secondaryAnimation = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );

    final media = MediaQuery.of(context);

    final itemBox = itemKey.currentContext!.findRenderObject()! as RenderBox;
    final itemRect = itemBox.localToGlobal(Offset.zero) & itemBox.size;

    const padding = 56.0;
    final viewportRect = Offset.zero & media.size;

    final offsetTween = Tween<Offset>(
      begin: itemRect.topLeft,
      end: Offset.zero,
    );
    final widthTween = Tween<double>(
      begin: itemRect.width,
      end: viewportRect.width - padding * 2,
    );

    final theme = Theme.of(context);

    final borderRadiusTween = BorderRadiusTween(
      begin: BorderRadius.zero,
      end: const BorderRadius.all(
        Radius.circular(28),
      ),
    );

    //* Surface color roles do not seem to work with the dynamic_color package
    // TODO: DO NOT use surface tint color because it is "deprecated". Instead use new surface color roles.
    final backgroundColor = ElevationOverlay.applySurfaceTint(
        theme.colorScheme.surface, theme.colorScheme.surfaceTint, 6);
    final colorTween = ColorTween(
      begin: theme.colorScheme.surface,
      // end: theme.colorScheme.surfaceContainerHigh,
      end: backgroundColor,
    ).chain(
      CurveTween(curve: const Interval(0, 1 / 3)),
    );

    final forwardTween = Tween<double>(begin: 0, end: 1);
    final reverseTween = Tween<double>(begin: 1, end: 0);

    final startInterval = CurveTween(
      curve: const Interval(0, 0.5),
    );
    final endInterval = CurveTween(
      curve: const Interval(0.5, 1),
    );

    final startOpacityTween =
        Tween<double>(begin: 1, end: 0).chain(startInterval);
    final endOpacityTween = Tween<double>(begin: 0, end: 1).chain(endInterval);

    final titleTextStyleTween = TextStyleTween(
      begin: theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      end: theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onSurface,
      ),
    );

    final contentOpacityTween = Tween<double>(begin: 0, end: 1).chain(
      CurveTween(curve: const Interval(2 / 3, 1)),
    );

    final footerOpacityTween = Tween<double>(begin: 0, end: 1).chain(
      CurveTween(curve: const Interval(1 / 3, 2 / 3)),
    );

    final titleExitOpacityTween = Tween<double>(begin: 1, end: 0).chain(
      CurveTween(curve: const Interval(0, 1 / 3)),
    );
    final titleEnterOpacityTween = Tween<double>(begin: 0, end: 1).chain(
      CurveTween(curve: const Interval(1 / 3, 1)),
    );

    final content = viewBuilder(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final borderRadius = borderRadiusTween.evaluate(animation)!;
        final color = colorTween.evaluate(animation)!;
        final width = widthTween.evaluate(animation);
        return Align(
          alignment: AlignmentTween(
            begin: Alignment.topLeft,
            end: Alignment.center,
          ).evaluate(animation),
          child: Transform.translate(
            offset: offsetTween.evaluate(animation),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: viewportRect.height * 2 / 3,
                minWidth: width,
                maxWidth: width,
              ),
              child: Material(
                animationDuration: Duration.zero,
                clipBehavior: Clip.antiAlias,
                borderRadius: borderRadius,
                color: color,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 72,
                      child: animation.value >= 0.5
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Opacity(
                                opacity:
                                    titleEnterOpacityTween.evaluate(animation),
                                child: Center(
                                  child: DefaultTextStyle(
                                    style: theme.textTheme.titleLarge!,
                                    child: title,
                                  ),
                                ),
                              ),
                            )
                          : Opacity(
                              opacity:
                                  titleExitOpacityTween.evaluate(animation),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 24),
                                child: IconTheme.merge(
                                  data: IconThemeData(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  child: Row(
                                    children: [
                                      leading,
                                      const Gap(16),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            DefaultTextStyle(
                                              style: theme.textTheme.bodyLarge!
                                                  .copyWith(
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                              child: title,
                                            ),
                                            DefaultTextStyle(
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                color: theme.colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                              child: subtitle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      trailing,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        heightFactor: forwardTween.evaluate(animation),
                        child: Opacity(
                          opacity: contentOpacityTween.evaluate(animation),
                          child: content,
                        )),
                    Align(
                      alignment: Alignment.bottomCenter,
                      heightFactor: forwardTween.evaluate(animation),
                      child: Padding(
                        padding: EdgeInsetsTween(
                          begin: const EdgeInsets.fromLTRB(
                              16 + padding, 8, 16 + padding, 8),
                          end: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        ).evaluate(animation),
                        child: Opacity(
                          opacity: footerOpacityTween.evaluate(animation),
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: null,
                                child: Text("Undo"),
                              ),
                              const Spacer(),
                              const Gap(8),
                              FilledButton(
                                onPressed: () {},
                                child: Text("Done"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
