import 'package:fleather/fleather.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:true_material/material.dart';

class ExpandedTest extends StatefulWidget {
  const ExpandedTest({super.key});

  @override
  State<ExpandedTest> createState() => _ExpandedTestState();
}

class _ExpandedTestState extends State<ExpandedTest> {
  late ScrollController _rightScrollController;

  late FleatherController _fleatherController;

  int _page = 0;

  int _selected = 1;

  @override
  void initState() {
    super.initState();
    _rightScrollController = ScrollController();
    _fleatherController = FleatherController();
  }

  @override
  void dispose() {
    _fleatherController.dispose();
    _rightScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Symbols.add_rounded),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Row(
        children: [
          NavigationRail(
            onDestinationSelected: (value) => setState(() => _page = value),
            selectedIndex: _page,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Symbols.menu_rounded),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Symbols.settings_rounded),
            ),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(
                  Symbols.home_rounded,
                  fill: 0,
                ),
                selectedIcon: Icon(
                  Symbols.home_rounded,
                  fill: 1,
                ),
                label: Text("Home"),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Symbols.notes_rounded,
                  fill: 0,
                ),
                selectedIcon: Icon(
                  Symbols.notes_rounded,
                  fill: 1,
                ),
                label: Text("Notes"),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Symbols.task_alt_rounded,
                  fill: 0,
                ),
                selectedIcon: Icon(
                  Symbols.task_alt_rounded,
                  fill: 1,
                ),
                label: Text("To-dos"),
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    scrolledUnderElevation: 0,
                    toolbarHeight: 0,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(72),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
                        child: SearchBar(
                          onTap: () {},
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.only(left: 16, right: 16)),
                          leading: const Icon(Symbols.search_rounded),
                          shadowColor: const MaterialStatePropertyAll(
                              Colors.transparent),
                          hintText: "Search notes",
                          trailing: [
                            CircleAvatar(
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Symbols.account_circle_rounded,
                                  fill: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
                    sliver: SliverList.separated(
                      itemCount: 32,
                      itemBuilder: (context, index) => KeyedSubtree(
                        key: ValueKey(index),
                        child:
                            (_selected == index ? Card.filled : Card.outlined)(
                          well: WellEvents(
                            onTap: () => setState(() => _selected = index),
                            onSecondaryTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Actions"),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 16, 0, 24),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Divider(),
                                      SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24),
                                              leading: const Icon(
                                                  Symbols.export_notes_rounded),
                                              title: Text("Export"),
                                            ),
                                            ListTile(
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24),
                                              leading: const Icon(
                                                  Symbols.delete_rounded),
                                              title: Text("Delete"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        MaterialLocalizations.of(context)
                                            .cancelButtonLabel,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: Icon(
                                        Symbols.account_circle_rounded,
                                        fill: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name",
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                          Text(
                                            "Date",
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Symbols.share_rounded,
                                        fill: 1,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Symbols.star_rounded,
                                        fill: index % 2 == 0 ? 1 : 0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Title",
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    "Cillum aute anim nisi incididunt exercitation do officia ullamco veniam.")
                              ],
                            ),
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox.expand(
                child: Card.outlined(
                  child: CustomScrollView(
                    controller: _rightScrollController,
                    slivers: [
                      SliverAppBar.large(
                        leadingWidth: 64,
                        scrolledUnderElevation: 0,
                        leading: IconButton(
                          onPressed: () {},
                          icon: const Icon(Symbols.arrow_back_rounded),
                        ),
                        title: Builder(
                          builder: (context) => TextField(
                            style: DefaultTextStyle.of(context).style,
                            decoration: InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText: "Title",
                            ),
                          ),
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Symbols.undo_rounded),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Symbols.redo_rounded),
                          ),
                          const SizedBox(width: 16),
                          FilledButton.icon(
                            onPressed: () {},
                            icon: const Icon(Symbols.save_rounded),
                            label: Text("Save"),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: FleatherEditor(
                          controller: _fleatherController,
                          scrollController: _rightScrollController,
                          scrollable: false,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}
