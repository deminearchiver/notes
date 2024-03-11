import 'package:material_symbols_icons/symbols.dart';
import 'package:material/material.dart';

enum OnboardingActionsLayout { column, row }

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    this.supportsBackAction = true,
    this.icon,
    required this.title,
    required this.subtitle,
    this.content,
    this.disclaimer,
    this.actionsLayout = OnboardingActionsLayout.column,
    this.actions = const [],
  });

  final bool supportsBackAction;

  final Widget? icon;
  final String title;
  final String subtitle;
  final Widget? content;

  final String? disclaimer;

  final OnboardingActionsLayout actionsLayout;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final heading = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: IconTheme.merge(
                data: IconThemeData(
                  size: 36,
                  color: theme.colorScheme.primary,
                ),
                child: icon!,
              ),
            ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        leadingWidth: 64,
        automaticallyImplyLeading: false,
        leading: supportsBackAction && Navigator.canPop(context)
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Symbols.arrow_back_rounded),
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (content == null) Expanded(child: heading),
              if (content != null) ...[
                heading,
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: content!,
                  ),
                ),
                // const Spacer(),
              ],
              if (disclaimer != null) ...[
                Text(
                  disclaimer!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.disabledColor,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: actionsLayout == OnboardingActionsLayout.column
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: actions,
                      )
                    : Row(children: actions),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
