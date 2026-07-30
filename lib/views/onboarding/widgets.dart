import 'package:material/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    this.showBackButton = false,
    this.actions = const [],
    this.icon,
    required this.title,
    this.subtitle,
    this.scrollController,
    this.slivers,
    this.disclaimer,
    this.footer,
  }) : assert(scrollController == null || slivers != null);

  /// Useful for moments when going back is a low-priority option
  final bool showBackButton;
  final List<Widget> actions;

  final Widget? icon;
  final Widget title;
  final Widget? subtitle;

  final ScrollController? scrollController;
  final List<Widget>? slivers;

  final Widget? disclaimer;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);

    final Widget? leading = showBackButton && navigator.canPop()
        ? IconButton(
            onPressed: navigator.pop,
            icon: const Icon(Symbols.arrow_back_rounded),
          )
        : null;

    final top = [
      if (icon != null) ...[
        IconTheme.merge(
          data: IconThemeData(
              color: theme.colorScheme.primary, size: 36, opticalSize: 36),
          child: icon!,
        ),
        const Gap(16),
      ],
      DefaultTextStyle(
        style: theme.textTheme.headlineLarge!,
        textAlign: TextAlign.center,
        child: title,
      ),
      if (subtitle != null) ...[
        const Gap(8),
        DefaultTextStyle(
          style: theme.textTheme.bodyLarge!
              .copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
          child: subtitle!,
        ),
      ],
    ];

    final bottom = [
      if (disclaimer != null) ...[
        DefaultTextStyle(
          style: theme.textTheme.bodySmall!
              .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.38)),
          child: disclaimer!,
        ),
      ],
      if (footer != null) footer!,
    ];

    return Scaffold(
      appBar: slivers == null
          ? AppBar(
              toolbarHeight: 64,
              leadingWidth: 64,
              automaticallyImplyLeading: false,
              leading: leading,
              actions: actions,
            )
          : null,
      body: slivers != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverAppBar.large(
                        toolbarHeight: 64,
                        leadingWidth: 64,
                        automaticallyImplyLeading: false,
                        leading: leading,
                        title: title,
                        actions: actions,
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        sliver: SliverList.list(
                          children: [
                            if (subtitle != null)
                              DefaultTextStyle(
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                child: subtitle!,
                              )
                          ],
                        ),
                      ),
                      ...slivers!,
                      // SliverPadding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   sliver: SliverFillRemaining(
                      //     fillOverscroll: false,
                      //     hasScrollBody: false,
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       children: [
                      //         const Gap(16),
                      //         ...bottom,
                      //         const Gap(16),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                if (footer != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: footer,
                  ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (slivers == null) const Spacer(flex: 3),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: top,
                    ),
                  ),
                  if (slivers == null) const Spacer(flex: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: bottom,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
