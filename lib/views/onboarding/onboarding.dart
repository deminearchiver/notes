import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:material/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/settings/settings.dart';
import 'package:notes/views/app/app.dart';
import 'package:notes/views/settings/settings.dart';
import 'package:notes/widgets/back_button.dart';
import 'package:notes/widgets/linear_progress_indicator.dart';
import 'package:notes/widgets/route/route.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:notes/widgets/settings/tiles.dart';
import 'package:provider/provider.dart';
import 'package:simple_icons/simple_icons.dart';
import 'widgets.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return OnboardingWelcome();
  }
}

class OnboardingWelcome extends StatelessWidget {
  const OnboardingWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return OnboardingScaffold(
      icon: const Icon(Symbols.waving_hand_rounded),
      title: const Text("Welcome to Notes!"),
      subtitle:
          const Text("Notes is a cross-platform note-taking and to-do app."),
      footer: FilledButton(
        onPressed: () => navigator.push(
          MaterialRoute.sharedAxis(
            builder: (context) => const OnboardingSetup(),
          ),
        ),
        child: const Text("Next"),
      ),
    );
  }
}

class OnboardingSetup extends StatefulWidget {
  const OnboardingSetup({super.key});

  @override
  State<OnboardingSetup> createState() => _OnboardingSetupState();
}

class _OnboardingSetupState extends State<OnboardingSetup> {
  late ScrollController _scrollController;

  bool _passedScrollThreshold = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final scroll = _scrollController.position.pixels;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;

    if (scroll >= maxScrollExtent) {
      setState(() => _passedScrollThreshold = true);
      _scrollController.removeListener(_scrollListener);
    }
  }

  void _openLoginScreen() {
    Navigator.of(context).push(
      MaterialRoute.sharedAxis(
        builder: (context) => const LoginView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Settings.watch(context);
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);
    return OnboardingScaffold(
      showBackButton: true,
      actions: [
        TextButton(
          onPressed: () => navigator.push(
            MaterialRoute.sharedAxis(
              builder: (context) => const OnboardingDone(),
            ),
          ),
          child: Text("Skip"),
        ),
        const Gap(16),
      ],
      icon: const Icon(Symbols.manufacturing_rounded),
      title: const Text("Setup"),
      subtitle: const Text("Let's get you set up!"),
      scrollController: _scrollController,
      slivers: [
        SliverList.list(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card.filled(
                color: theme.colorScheme.secondaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: InkWell(
                  onTap: _openLoginScreen,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Symbols.account_circle_rounded,
                          color: theme.colorScheme.onSecondaryContainer,
                          size: 40,
                          opticalSize: 40,
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Account",
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                              Text(
                                "Log in to enable sync",
                                style: theme.textTheme.bodySmall!.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        IgnorePointer(
                          child: FilledButton.icon(
                            onPressed: _openLoginScreen,
                            icon: const Icon(
                              Symbols.login_rounded,
                              size: 18,
                              opticalSize: 18,
                            ),
                            label: Text("Log in"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            const SectionHeader("Appearance"),
            ListTile(
              onTap: () => showLanguagePicker(
                context: context,
              ),
              leading: const Icon(Symbols.translate_rounded),
              title: Text("Language"),
              subtitle: Text(settings.locale.name),
            ),
            const DynamicColorSettingsTile(),
            const BrightnessSettingsTile(),
            const Divider(),
            const SectionHeader("Behaviours"),
            const ExchangeKindsSettingsTile(),
            const Divider(
              indent: 16,
              endIndent: 8,
            ),
          ],
        ),
      ],
      footer: FilledButton.tonal(
        onPressed: _passedScrollThreshold ? () => navigator.push : null,
        child: const Text("Next"),
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

final _random = Random();

class _LoginViewState extends State<LoginView> {
  bool _loading = true;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);
  }

  void _login() async {
    setState(() {
      _loading = true;
      _locked = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final success = _random.nextBool();
    if (success) {
      Navigator.pop(context);
    } else {
      setState(() => _locked = false);
      await Future.delayed(const Duration(milliseconds: 250));
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        leadingWidth: 64,
        automaticallyImplyLeading: false,
        leading: BackIconButton(
          enabled: !_locked,
        ),
        centerTitle: true,
        title: const Text("Log in"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: AnimatedLinearProgressIndicator(
            visible: _loading,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton(
              onSelectionChanged: (values) {},
              selected: const {false},
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: false,
                  icon: Icon(Symbols.login_rounded),
                  label: Text("Sign in"),
                ),
                ButtonSegment(
                  value: true,
                  icon: Icon(Symbols.person_add_rounded),
                  label: Text("Sign up"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                labelText: "Username",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              enableIMEPersonalizedLearning: false,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                labelText: "Password",
                errorText: "AAA",
              ),
            ),
          ),
          const SectionHeader("Authentification providers"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 16,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () {},
                  icon: const Icon(
                    SimpleIcons.google,
                    size: 18,
                  ),
                  label: const Text("Google"),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {},
                  icon: const Icon(
                    SimpleIcons.github,
                    size: 18,
                  ),
                  label: const Text("GitHub"),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FractionallySizedBox(
              widthFactor: 2 / 3,
              child: FilledButton.icon(
                onPressed: !_loading ? _login : null,
                icon: Icon(Symbols.login_rounded),
                label: Text("Log in"),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class ResetIconButton extends StatefulWidget {
  const ResetIconButton({
    super.key,
    required this.onPressed,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  State<ResetIconButton> createState() => _ResetIconButtonState();
}

class _ResetIconButtonState extends State<ResetIconButton> {
  void _onPressed() {
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: widget.onPressed != null ? _onPressed : null,
      tooltip: widget.tooltip ?? "Reset to default",
      icon: const Icon(Symbols.restart_alt_rounded),
    );
  }
}

class OnboardingDone extends StatelessWidget {
  const OnboardingDone({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return OnboardingScaffold(
      icon: const Icon(Symbols.celebration_rounded),
      title: const Text("Done"),
      subtitle: const Text("You are all set up and ready to jump in!"),
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: navigator.pop,
              child: const Text("Back"),
            ),
          ),
          const Gap(8),
          Expanded(
            child: FilledButton(
              onPressed: () => navigator.pushAndRemoveUntil(
                MaterialRoute.sharedAxis(
                  builder: (context) => const AppView(),
                ),
                (route) => !route.isFirst,
              ),
              child: const Text("Let's go!"),
            ),
          ),
        ],
      ),
    );
  }
}
