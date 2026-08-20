import 'package:notes/flutter.dart';

enum _SettingsScaffoldVariant { sliver, list }

class SettingsScaffold extends StatelessWidget {
  const SettingsScaffold.list({
    super.key,
    this.onRefresh,
    this.padding = EdgeInsets.zero,
    required this.title,
    this.actions = const [],
    required this.children,
  }) : _variant = _SettingsScaffoldVariant.list;

  const SettingsScaffold.sliver({
    super.key,
    this.onRefresh,
    this.padding = EdgeInsets.zero,
    required this.title,
    this.actions = const [],
    required List<Widget> slivers,
  }) : _variant = _SettingsScaffoldVariant.sliver,
       children = slivers;

  final _SettingsScaffoldVariant _variant;

  final Future<void> Function()? onRefresh;

  final EdgeInsets padding;

  final Widget title;
  final List<Widget> actions;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final body = CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          toolbarHeight: 64,
          leadingWidth: 64,
          leading: Navigator.canPop(context)
              ? IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(MaterialSymbols.arrow_back_rounded),
                )
              : null,
          title: title,
          actions: actions,
        ),
        if (_variant == _SettingsScaffoldVariant.list)
          SliverPadding(
            padding: padding,
            sliver: SliverList.list(children: children),
          ),
        if (_variant == _SettingsScaffoldVariant.sliver) ...children,
      ],
    );
    return Scaffold(
      body: onRefresh != null
          ? RefreshIndicator(onRefresh: onRefresh!, child: body)
          : body,
    );
  }
}
