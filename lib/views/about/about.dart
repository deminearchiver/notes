import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:gap/gap.dart';
import 'package:material/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/gen/assets.gen.dart';
import 'package:notes/widgets/back_button.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  late WidgetStatesController _statesController;

  @override
  void initState() {
    super.initState();
    _statesController = WidgetStatesController()
      ..addListener(
        () {
          setState(() {});
        },
      );
  }

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  WidgetStateProperty<TextStyle> get _linkTextStyle =>
      WidgetStateProperty.resolveWith(
        (states) {
          final theme = Theme.of(context);

          final base = theme.colorScheme.primary;
          final overlay = theme.colorScheme.onPrimary;

          Color color = base;
          TextDecoration? decoration;
          if (states.contains(WidgetState.pressed)) {
            color = Color.alphaBlend(overlay.withOpacity(0.1), base);
            decoration = TextDecoration.underline;
          } else if (states.contains(WidgetState.hovered)) {
            color = Color.alphaBlend(overlay.withOpacity(0.08), base);
          }
          return TextStyle(
            color: color,
            decoration: decoration,
          );
        },
      );

  TapGestureRecognizer get _linkRecognizer {
    final recognizer = TapGestureRecognizer();
    recognizer.onTapCancel =
        () => _statesController.update(WidgetState.pressed, false);
    recognizer.onTapUp =
        (event) => _statesController.update(WidgetState.pressed, false);
    recognizer.onTapDown =
        (event) => _statesController.update(WidgetState.pressed, true);
    recognizer.onTap = () => launchUrl(
          Uri.parse("https://github.com/deminearchiver"),
        );
    return recognizer;
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            toolbarHeight: 64,
            leadingWidth: 64,
            automaticallyImplyLeading: false,
            leading: navigator.canPop() ? const BackIconButton() : null,
            title: const Text("About"),
          ),
          SliverList.list(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card.outlined(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(28),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Notes",
                          style: theme.textTheme.headlineLarge!.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: "\" "),
                              TextSpan(
                                text: "A note-taking and to-do app.",
                              ),
                              const TextSpan(text: " \""),
                            ],
                          ),
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: "by "),
                              TextSpan(
                                onEnter: (event) => _statesController.update(
                                  WidgetState.hovered,
                                  true,
                                ),
                                onExit: (event) => _statesController.update(
                                  WidgetState.hovered,
                                  false,
                                ),
                                text: "deminearchiver",
                                recognizer: _linkRecognizer,
                                style: _linkTextStyle
                                    .resolve(_statesController.value),
                              ),
                              const TextSpan(text: " "),
                              WidgetSpan(
                                baseline: TextBaseline.ideographic,
                                alignment: PlaceholderAlignment.middle,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundImage:
                                      Assets.images.deminearchiver.provider(),
                                ),
                              ),
                            ],
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card.outlined(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SectionHeader(
                        "Socials",
                        padding: EdgeInsets.fromLTRB(
                          24,
                          16,
                          24,
                          8,
                        ),
                      ),
                      ListTile(
                        onTap: () => launchUrl(
                          Uri.parse("https://github.com/deminearchiver/notes"),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        leading: const Icon(SimpleIcons.github),
                        title: const Text("GitHub"),
                        subtitle: const Text("github.com/deminearchiver/notes"),
                        trailing: const Icon(Symbols.open_in_new_rounded),
                      ),
                      const Gap(24),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 56,
                ),
                child: BuiltWithLove()),
          )
        ],
      ),
    );
  }
}

class BuiltWithLove extends StatelessWidget {
  const BuiltWithLove({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "💖",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge!.copyWith(
            fontSize: 48,
            shadows: [
              BoxShadow(
                color: theme.colorScheme.error,
                blurRadius: 48,
              ),
            ],
          ),
        ),
        Text(
          "Built with love\nat github.com/deminearchiver",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
