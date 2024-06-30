import 'package:notes/l10n/l10n.dart';
import 'package:notes/views/app/expanded/expanded.dart';
import 'package:notes/views/app/home.dart';
import 'package:notes/views/app/notes.dart';
import 'package:notes/views/app/todos.dart';
import 'package:notes/views/note/note.dart';
import 'package:notes/views/settings/settings.dart';
import 'package:notes/views/todo/todo.dart';
import 'package:notes/widgets/switcher/switcher.dart';
import 'package:material/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/widgets/switcher/top_level.dart';
import 'package:sliver_tools/sliver_tools.dart';

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
  late TextEditingController _searchController;

  int _page = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _searchNode = FocusNode()..addListener(_searchFocusListener);
    _searchController = TextEditingController()
      ..addListener(
        () => setState(() {}),
      );
  }

  @override
  void dispose() {
    _searchController.dispose();
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
      _scrollTo(0);
    }

    setState(() {});
  }

  void _unfocusSearch() {
    _searchNode.unfocus();
    _scrollTo(0);
  }

  void _goToPage(int value) {
    setState(() => _page = value);
    _scrollTo(0);
  }

  Widget _buildHeader(
    BuildContext context,
    void Function(String value) onQueryChanged,
  ) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    final localizations = AppLocalizations.of(context);

    return SliverAppBar(
      key: _appBarKey,
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      flexibleSpace: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Center(
          child: SearchBar(
            controller: _searchController,
            onChanged: onQueryChanged,
            focusNode: _searchNode,
            leading: Switcher.fadeThrough(
              duration: Durations.short4,
              alignment: Alignment.centerRight,
              child: KeyedSubtree(
                key: ValueKey(_searchNode.hasFocus),
                child: _searchNode.hasFocus
                    ? IconButton(
                        onPressed: _unfocusSearch,
                        icon: const Icon(Symbols.arrow_back_rounded),
                      )
                    : SizedBox.square(
                        dimension:
                            48 + theme.visualDensity.baseSizeAdjustment.dx,
                        child: const Icon(Symbols.search_rounded),
                      ),
              ),
            ),
            hintText: switch (_page) {
              0 => localizations.app_home_view_search,
              1 => localizations.app_notes_view_search,
              2 => localizations.app_todos_view_search,
              _ => null,
            },
            trailing: [
              _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: _searchController.text.isNotEmpty
                          ? _searchController.clear
                          : null,
                      icon: const Icon(Symbols.clear_rounded),
                    )
                  : IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialRoute.sharedAxis(
                          builder: (context) => const SettingsView(),
                        ),
                      ),
                      icon: const Icon.filled(Symbols.settings_rounded),
                    ),
            ],
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
    // return const ExpandedApp();
    final localizations = AppLocalizations.of(context);
    return AdaptiveScaffold(
      key: _scaffoldKey,
      topLevelDelegate: AdaptiveTopLevelDelegate(
        onDestinationSelected: _goToPage,
        selectedIndex: _page,
        destinations: [
          AdaptiveDestination(
            icon: const Icon.outlined(Symbols.home_rounded),
            selectedIcon: const Icon.filled(Symbols.home_rounded),
            label: localizations.app_home_view,
          ),
          AdaptiveDestination(
            icon: const Icon.outlined(Symbols.notes_rounded),
            selectedIcon: const Icon.filled(Symbols.notes_rounded),
            label: localizations.app_notes_view,
          ),
          AdaptiveDestination(
            icon: const Icon.outlined(Symbols.task_alt_rounded),
            selectedIcon: const Icon.filled(Symbols.task_alt_rounded),
            label: localizations.app_todos_view,
          ),
        ],
      ),
      // floatingActionButton: switch (_page) {
      //   // 0 => const _FloatingActionButtonTest(),
      //   1 => FloatingActionButton.extended(
      //       onPressed: () => Navigator.push(
      //         context,
      //         MaterialRoute.adaptive(
      //           builder: (context) => const NoteView(),
      //         ),
      //       ),
      //       icon: const Icon(
      //         Symbols.note_add_rounded,
      //       ),
      //       label: AnimatedSize(
      //         key: const ValueKey("fab_size"),
      //         duration: Durations.medium4,
      //         curve: Easing.emphasized,
      //         child: Switcher.fadeThrough(
      //           duration: Durations.short4,
      //           layoutBuilder: minimumSizeLayoutBuilder,
      //           child: Text(
      //             localizations.app_notes_view_create,
      //             key: ValueKey(_page),
      //           ),
      //         ),
      //       ),
      //     ),
      //   2 => FloatingActionButton.extended(
      //       onPressed: () => Navigator.push(
      //         context,
      //         MaterialRoute.adaptive(
      //           builder: (context) => const TodoView(),
      //         ),
      //       ),
      //       icon: const Icon(
      //         Symbols.add_task_rounded,
      //       ),
      //       label: AnimatedSize(
      //         key: const ValueKey("fab_size"),
      //         duration: Durations.medium4,
      //         curve: Easing.emphasized,
      //         child: Text(
      //           localizations.app_todos_view_create,
      //         ),
      //       ),
      //     ),
      //   _ => null,
      // },
      floatingActionButton: switch (_page) {
        1 => FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialRoute.adaptive(
                builder: (context) => const NoteView(),
              ),
            ),
            child: const Icon(
              Symbols.note_add_rounded,
            ),
          ),
        2 => FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialRoute.adaptive(
                builder: (context) => const TodoView(),
              ),
            ),
            child: const Icon(
              Symbols.add_task_rounded,
            ),
          ),
        _ => null,
      },
      // bottomNavigationBar: NavigationBar(
      //         // onDestinationSelected: (value) => setState(() => _page = value),
      //         onDestinationSelected: _goToPage,
      //         selectedIndex: _page,
      //         destinations: [
      //           NavigationDestination(
      //             icon: const Icon(
      //               Symbols.home_rounded,
      //               fill: 0,
      //             ),
      //             selectedIcon: const Icon(
      //               Symbols.home_rounded,
      //               fill: 1,
      //             ),
      //             label: localizations.app_home_view,
      //           ),
      //           NavigationDestination(
      //             icon: const Icon(
      //               Symbols.notes_rounded,
      //               fill: 0,
      //             ),
      //             selectedIcon: const Icon(
      //               Symbols.notes_rounded,
      //               fill: 1,
      //             ),
      //             label: localizations.app_notes_view,
      //           ),
      //           NavigationDestination(
      //             icon: const Icon(
      //               Symbols.task_alt_rounded,
      //               fill: 0,
      //             ),
      //             selectedIcon: const Icon(
      //               Symbols.task_alt_rounded,
      //               fill: 1,
      //             ),
      //             label: localizations.app_todos_view,
      //           ),
      //         ],
      //       ),
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
