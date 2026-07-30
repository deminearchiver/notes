import 'package:flutter_quill/flutter_quill.dart';
import 'package:material/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/views/about/about.dart';
import 'package:notes/views/settings/settings.dart';
import 'package:notes/widgets/animated_indexed_stack.dart';

enum PageIdentifier {
  search,
  home,
  settings;

  factory PageIdentifier.fromIndex(int? index) => switch (index) {
        null => PageIdentifier.search,
        0 => PageIdentifier.home,
        1 => PageIdentifier.settings,
        _ => throw RangeError.range(
            index,
            0,
            values.length - 2, // One value is skipped
          ),
      };

  int? toIndex() => switch (this) {
        PageIdentifier.search => null,
        PageIdentifier.home => 0,
        PageIdentifier.settings => 1,
      };
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _testKey = GlobalKey();
  final _appBarKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _quillController = QuillController.basic();

  int _page = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final windowSizeClass = WindowSize.of(context);

    final backgroundColor = windowSizeClass > WindowSize.medium
        ? theme.colorScheme.surfaceContainer
        : theme.colorScheme.surface;

    final menuButton = IconButton(
      onPressed: () => _scaffoldKey.currentState?.openDrawer,
      icon: const Icon(Symbols.menu_rounded),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      body: AnimatedIndexedStack(
        index: _page,
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text("TEST"),
            ),
          ),
          const AboutView(),
        ],
      ),
      // body: Row(
      //   children: [
      //     if (windowSizeClass > WindowSizeClass.medium)
      //       NavigationRail(
      //         selectedIndex: 0,
      //         leading: menuButton,
      //         destinations: const [
      //           NavigationRailDestination(
      //               icon: Icon(Symbols.home_rounded), label: Text("Home")),
      //           NavigationRailDestination(
      //               icon: Icon(Symbols.home_rounded), label: Text("Home")),
      //         ],
      //       ),
      //     // Expanded(
      //     //   child: Column(
      //     //     children: [
      //     //       AppBar(
      //     //         toolbarHeight: 64,
      //     //         leadingWidth: 64,
      //     //         automaticallyImplyLeading: false,
      //     //         leading: Center(
      //     //           child: IconButton(
      //     //             onPressed: () {},
      //     //             icon: const Icon(Symbols.search_rounded),
      //     //           ),
      //     //         ),
      //     //         centerTitle: true,
      //     //         title: const Text("Home"),
      //     //       ),
      //     //     ],
      //     //   ),
      //     // ),
      //     Expanded(
      //       child: AnimatedIndexedStack(
      //         key: const ValueKey(0),
      //         index: _page,
      //         children: [
      //           Scaffold(
      //             appBar: AppBar(
      //               title: Text("Home"),
      //             ),
      //           ),
      //           const SettingsView(),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      bottomNavigationBar: windowSizeClass <= WindowSize.medium
          ? NavigationBar(
              onDestinationSelected: (value) => setState(() => _page = value),
              selectedIndex: _page,
              destinations: const [
                NavigationBarDestination(
                  icon: Icon(
                    Symbols.home_rounded,
                    fill: 0,
                  ),
                  selectedIcon: Icon(
                    Symbols.home_rounded,
                    fill: 1,
                  ),
                  label: "Home",
                ),
                NavigationBarDestination(
                  icon: Icon(
                    Symbols.settings_rounded,
                    fill: 0,
                  ),
                  selectedIcon: Icon(
                    Symbols.settings_rounded,
                    fill: 1,
                  ),
                  label: "Settings",
                ),
              ],
            )
          : null,
    );
  }
}
