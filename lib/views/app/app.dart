import 'package:notes/l10n/l10n.dart';
import 'package:notes/utils/extensions.dart';
import 'package:notes/views/app/home.dart';
import 'package:notes/views/app/new/expanded.dart';
import 'package:notes/views/app/notes.dart';
import 'package:notes/views/app/todos.dart';
import 'package:notes/views/note/note.dart';
import 'package:notes/views/settings/settings.dart';
import 'package:notes/views/todo/todo.dart';
import 'package:notes/widgets/expandable_floating_action_button.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:notes/widgets/switcher/switcher.dart';
import 'package:true_material/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/widgets/switcher/top_level.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _appBarKey = GlobalKey();
  final _switcherKey = GlobalKey();
  final _scrollableKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late ScrollController _scrollController;

  late FocusNode _searchNode;
  bool _searchFocused = false;

  int _page = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _searchNode = FocusNode()..addListener(_searchFocusListener);
  }

  @override
  void dispose() {
    _searchNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // TODO: implement unfocus on scroll up from search bar
    // if (_searchFocused && _scrollController.position.pixels < 64) {
    //   _searchNode.unfocus();
    // }
  }

  void _scrollTo(double position) {
    if (_scrollController.position.maxScrollExtent == 0) return;
    _scrollController.animateTo(
      position,
      duration: Durations.medium4,
      curve: Easing.standardDecelerate,
    );
  }

  void _searchFocusListener() {
    if (_searchNode.hasFocus) {
      _scrollTo(64);
    }
    if (_searchFocused != _searchNode.hasFocus) {
      setState(() => _searchFocused = _searchNode.hasFocus);
    }
  }

  void _unfocusSearch() {
    _searchNode.unfocus();
    _scrollTo(0);
  }

  // TODO: find a use for this
  void _goToPage(int value) {
    setState(() => _page = value);
    _scrollTo(0);
  }

  Widget _buildHeader(
    BuildContext context,
    void Function(String value) onQueryChanged,
  ) {
    final media = MediaQuery.of(context);

    final localizations = AppLocalizations.of(context);
    return SliverAppBar(
      key: _appBarKey,
      pinned: true,
      floating: true,
      toolbarHeight: 64,
      leadingWidth: 64,
      scrolledUnderElevation: 0,
      leading: !media.windowClass.isCompact
          ? IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(Symbols.menu_rounded),
            )
          : null,
      title: Switcher.fadeThrough(
        duration: Durations.medium2,
        child: Text(
          switch (_page) {
            0 => localizations.app_home_view,
            1 => localizations.app_notes_view,
            2 => localizations.app_todos_view,
            _ => "",
          },
          key: ValueKey(_page),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialRoute.zoom(
              child: const SettingsView(),
            ),
          ),
          icon: const Icon(
            Symbols.settings_rounded,
            fill: 1,
          ),
        ),
        const SizedBox(width: 16),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SearchBar(
            onChanged: onQueryChanged,
            focusNode: _searchNode,
            shadowColor: const MaterialStatePropertyAll(Colors.transparent),
            elevation: const MaterialStatePropertyAll(6),
            padding: const MaterialStatePropertyAll(EdgeInsets.only(
              right: 16, // TODO: make 4 when using trailing
            )),
            leading: Switcher.fadeThrough(
              duration: Durations.short4,
              alignment: Alignment.centerRight,
              child: KeyedSubtree(
                key: ValueKey(_searchFocused),
                child: _searchFocused
                    ? Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: IconButton(
                          onPressed: _unfocusSearch,
                          icon: const Icon(Symbols.arrow_back_rounded),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 12, 8),
                        child: Icon(Symbols.search_rounded),
                      ),
              ),
            ),
            hintText: switch (_page) {
              0 => localizations.app_home_view_search,
              1 => localizations.app_notes_view_search,
              2 => localizations.app_todos_view_search,
              _ => null,
            },
            // TODO: add functonality to hide app bar title, and when enabled move the settings button here
            // TODO: when searching replace with an "advanced search" button here (Symbols.tune_rounded)
            // trailing: [
            //   IconButton(
            //     onPressed: () => Navigator.push(
            //       context,
            //       MaterialRoute.zoom(child: const SettingsView()),
            //     ),
            //     icon: const Icon(Symbols.settings_rounded),
            //   ),
            // ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Widget sliver) {
    return TopLevelSwitcher.sliver(
      key: _switcherKey,
      sliver: KeyedSubtree(
        key: ValueKey(_page),
        child: sliver,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    // return ExpandedTest();
    return Scaffold(
      key: _scaffoldKey,
      drawer: !media.windowClass.isCompact
          ? NavigationDrawer(
              onDestinationSelected: _goToPage,
              selectedIndex: _page,
              children: [
                // const SizedBox(height: 12),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 12),
                //   child: ListTile(
                //     onTap: () => _scaffoldKey.currentState?.closeDrawer(),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(28),
                //     ),
                //     leading: Icon(
                //       Symbols.menu_open_rounded,
                //       color: theme.colorScheme.onSurfaceVariant,
                //     ),
                //     title: Text("Закрыть"),
                //     titleTextStyle: theme.textTheme.labelLarge
                //         ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 20,
                  ),
                  child: Text(
                    "Страницы",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                NavigationDrawerDestination(
                  icon: const Icon(
                    Symbols.home_rounded,
                    fill: 0,
                  ),
                  selectedIcon: const Icon(
                    Symbols.home_rounded,
                    fill: 1,
                  ),
                  label: Text(localizations.app_home_view),
                ),
                NavigationDrawerDestination(
                  icon: const Icon(
                    Symbols.notes_rounded,
                    fill: 0,
                  ),
                  selectedIcon: const Icon(
                    Symbols.notes_rounded,
                    fill: 1,
                  ),
                  label: Text(localizations.app_notes_view),
                ),
                NavigationDrawerDestination(
                  icon: const Icon(
                    Symbols.task_alt_rounded,
                    fill: 0,
                  ),
                  selectedIcon: const Icon(
                    Symbols.task_alt_rounded,
                    fill: 1,
                  ),
                  label: Text(localizations.app_todos_view),
                ),
                Divider(
                  color: theme.colorScheme.outline,
                  indent: 28,
                  endIndent: 28,
                ),
              ],
            )
          : null,
      floatingActionButton: switch (_page) {
        // 0 => const _FloatingActionButtonTest(),
        1 => FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialRoute.zoom(
                child: const NoteView(),
              ),
            ),
            icon: Switcher.fadeThrough(
              key: const ValueKey("fab_icon"),
              duration: Durations.short4,
              child: Icon(
                Symbols.note_add_rounded,
                key: ValueKey(_page),
              ),
            ),
            label: AnimatedSize(
              key: const ValueKey("fab_size"),
              duration: Durations.medium4,
              curve: Easing.emphasized,
              child: Switcher.fadeThrough(
                duration: Durations.short4,
                layoutBuilder: minimumSizeLayoutBuilder,
                child: Text(
                  localizations.app_notes_view_create,
                  key: ValueKey(_page),
                ),
              ),
            ),
          ),
        2 => FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialRoute.zoom(
                child: const TodoView(),
              ),
            ),
            icon: Switcher.fadeThrough(
              key: const ValueKey("fab_icon"),
              duration: Durations.short4,
              child: Icon(
                Symbols.add_task_rounded,
                key: ValueKey(_page),
              ),
            ),
            label: AnimatedSize(
              key: const ValueKey("fab_size"),
              duration: Durations.medium4,
              curve: Easing.emphasized,
              child: Switcher.fadeThrough(
                duration: Durations.short4,
                layoutBuilder: minimumSizeLayoutBuilder,
                child: Text(
                  localizations.app_todos_view_create,
                  key: ValueKey(_page),
                ),
              ),
            ),
          ),
        _ => null,
      },
      bottomNavigationBar: media.windowClass.isCompact
          ? NavigationBar(
              // onDestinationSelected: (value) => setState(() => _page = value),
              onDestinationSelected: _goToPage,
              selectedIndex: _page,
              destinations: [
                NavigationDestination(
                  icon: const Icon(
                    Symbols.home_rounded,
                    fill: 0,
                  ),
                  selectedIcon: const Icon(
                    Symbols.home_rounded,
                    fill: 1,
                  ),
                  label: localizations.app_home_view,
                ),
                NavigationDestination(
                  icon: const Icon(
                    Symbols.notes_rounded,
                    fill: 0,
                  ),
                  selectedIcon: const Icon(
                    Symbols.notes_rounded,
                    fill: 1,
                  ),
                  label: localizations.app_notes_view,
                ),
                NavigationDestination(
                  icon: const Icon(
                    Symbols.task_alt_rounded,
                    fill: 0,
                  ),
                  selectedIcon: const Icon(
                    Symbols.task_alt_rounded,
                    fill: 1,
                  ),
                  label: localizations.app_todos_view,
                ),
              ],
            )
          : null,
      body: switch (_page) {
        0 => AppViewHomePage(
            scrollableKey: _scrollableKey,
            scrollController: _scrollController,
            headerBuilder: _buildHeader,
            contentBuilder: _buildContent,
          ),
        1 => AppViewNotesPage(
            scrollableKey: _scrollableKey,
            scrollController: _scrollController,
            headerBuilder: _buildHeader,
            contentBuilder: _buildContent,
          ),
        2 => AppViewTodosPage(
            scrollableKey: _scrollableKey,
            scrollController: _scrollController,
            headerBuilder: _buildHeader,
            contentBuilder: _buildContent,
          ),
        _ => throw Error(),
      },
    );
  }
}

class _FloatingActionButtonTest extends StatefulWidget {
  const _FloatingActionButtonTest({
    super.key,
  });

  @override
  State<_FloatingActionButtonTest> createState() =>
      __FloatingActionButtonTestState();
}

class __FloatingActionButtonTestState extends State<_FloatingActionButtonTest> {
  final _buttonKey = GlobalKey<ExpandableFloatingActionButtonState>();

  @override
  Widget build(BuildContext context) {
    return ExpandableFloatingActionButton(
      key: _buttonKey,
      onPressed: () => _buttonKey.currentState?.openView(
        Scaffold(
          appBar: AppBar(),
        ),
      ),
      icon: const Icon(Symbols.add_rounded),
      label: const Text("New"),
    );
  }
}
