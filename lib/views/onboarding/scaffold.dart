import 'package:notes/flutter.dart';

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
      child: Flex.vertical(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: IconTheme.mergeWithData(
                data: IconThemeDataPartial.from(
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
                icon: const Icon(MaterialSymbols.arrow_back_rounded),
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Flex.vertical(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (content == null) Flexible.tight(child: heading),
              if (content != null) ...[
                heading,
                const SizedBox(height: 16),
                Flexible.tight(child: SingleChildScrollView(child: content!)),
                // const Flexible.space(),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: actionsLayout == OnboardingActionsLayout.column
                    ? Flex.vertical(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: actions,
                      )
                    : Flex.horizontal(children: actions),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
