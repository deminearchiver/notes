// import 'dart:async';
// import 'dart:ui';

// import 'package:fleather/fleather.dart';
// import 'package:flutter/gestures.dart';
// // import 'package:notes/constants/images.dart';
// import 'package:notes/database/database.dart';
// import 'package:notes/database/note.dart';
// import 'package:notes/theme.dart';
// import 'package:notes/utils/extensions.dart';
// import 'package:notes/views/settings/settings.dart';
// import 'package:notes/widgets/fleather/buttons.dart';
// import 'package:notes/widgets/scroll_to_top.dart';
// import 'package:notes/widgets/switcher/switcher.dart';
// import 'package:notes/widgets/title_bar.dart';
// import 'package:notes/flutter.dart';
// import 'package:window_manager/window_manager.dart';

// class ExpandedApp extends StatefulWidget {
//   const ExpandedApp({super.key});

//   @override
//   State<ExpandedApp> createState() => _ExpandedAppState();
// }

// class _ExpandedAppState extends State<ExpandedApp> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();

//   late final ScrollController _scrollController;
//   late final FocusNode _searchNode;

//   late final TextEditingController _searchTextController;

//   final _notesController = StreamController<List<Note>>();
//   StreamSubscription<List<Note>>? _notesSubscription;
//   Completer<void>? _notesCompleter;

//   int _page = 0;

//   Note? _note;
//   String _query = "";
//   bool _searchFocused = false;

//   @override
//   void initState() {
//     super.initState();

//     _scrollController = ScrollController();
//     _searchNode = FocusNode()..addListener(_focusListener);
//     _searchTextController = TextEditingController()
//       ..addListener(
//         () {
//           setState(() => _query = _searchTextController.text);
//         },
//       );

//     _refreshNotes();
//   }

//   @override
//   void dispose() {
//     _notesSubscription?.cancel();
//     _notesController.close();

//     _searchTextController.dispose();
//     _searchNode.dispose();
//     _scrollController.dispose();

//     super.dispose();
//   }

//   Future<void> _refreshNotes() async {
//     final notes = Database.watchSearchNotes(_query);
//     _notesCompleter = Completer();

//     _notesSubscription?.cancel();
//     _notesSubscription = notes.listen((event) {
//       _notesController.add(event);
//       if (_notesCompleter?.isCompleted != true) _notesCompleter?.complete();
//     });

//     return _notesCompleter?.future;
//   }

//   // void _setQuery(String value) {
//   //   setState(() => _query = value);
//   //   _refreshNotes();
//   // }

//   void _focusListener() {
//     if (_searchFocused != _searchNode.hasFocus) {
//       setState(() => _searchFocused = _searchNode.hasFocus);
//     }
//   }

//   void _unfocusSearch() {}

//   void _setPage(int value) {
//     setState(() => _page = value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final media = MediaQuery.of(context);
//     final theme = Theme.of(context);

//     final drawer = NavigationDrawer(
//       onDestinationSelected: _setPage,
//       selectedIndex: _page,
//       children: [
//         const SizedBox(height: 12),
//         if (media.WindowWidthSizeClass.isMedium)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: ListTile(
//               onTap: () => _scaffoldKey.currentState?.closeDrawer(),
//               leading: const Icon(MaterialSymbols.menu_open_rounded),
//               shape: const StadiumBorder(),
//             ),
//           ),
//         NavigationDrawerDestination(
//           icon: Icon(MaterialSymbols.home_rounded, fill: 0),
//           selectedIcon: Icon(MaterialSymbols.home_rounded, fill: 1),
//           label: Text("Home"),
//         ),
//         NavigationDrawerDestination(
//           icon: Icon(MaterialSymbols.notes_rounded, fill: 0),
//           selectedIcon: Icon(MaterialSymbols.notes_rounded, fill: 1),
//           label: Text("Notes"),
//         ),
//         NavigationDrawerDestination(
//           icon: Icon(MaterialSymbols.task_alt_rounded, fill: 0),
//           selectedIcon: Icon(MaterialSymbols.task_alt_rounded, fill: 1),
//           label: Text("To-dos"),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           child: ListTile(
//             onTap: () => Navigator.push(
//               context,
//             MaterialPageRoute<void>(
//                 child: const SettingsView(),
//               ),
//             ),
//             shape: const StadiumBorder(),
//             leading: const Icon(MaterialSymbols.settings_rounded),
//             title: Text("Settings"),
//             titleTextStyle: theme.textTheme.labelLarge?.copyWith(
//               color: theme.colorScheme.onSurfaceVariant,
//             ),
//           ),
//         ),
//       ],
//     );

//     return TitleBar(
//       backgroundColor: _scaffoldKey.currentState?.isDrawerOpen == true
//           ? theme.colorScheme.surface
//           : ElevationOverlay.applySurfaceTint(
//               theme.colorScheme.surface, theme.colorScheme.surfaceTint, 1),
//       child: Flex.vertical(
//         children: [
//           TitleBarTest(),
//           Flexible.tight(
//             child: Scaffold(
//               key: _scaffoldKey,
//               onDrawerChanged: (isOpened) => setState(() {}),
//               drawer: media.windowClass >= WindowWidthSizeClass.large ? drawer : null,
//               bottomNavigationBar: media.windowClass <= WindowWidthSizeClass.medium
//                   ? NavigationBar(
//                       destinations: const [
//                         NavigationDestination(
//                           icon: Icon(MaterialSymbols.home_rounded, fill: 0),
//                           selectedIcon: Icon(MaterialSymbols.home_rounded, fill: 1),
//                           label: "Home",
//                         ),
//                         NavigationDestination(
//                           icon: Icon(MaterialSymbols.notes_rounded, fill: 0),
//                           selectedIcon: Icon(MaterialSymbols.notes_rounded, fill: 1),
//                           label: "Notes",
//                         ),
//                         NavigationDestination(
//                           icon: Icon(MaterialSymbols.task_alt_rounded, fill: 0),
//                           selectedIcon: Icon(MaterialSymbols.task_alt_rounded, fill: 1),
//                           label: "To-dos",
//                         ),
//                       ],
//                     )
//                   : null,
//               body: Material(
//                 type: MaterialType.canvas,
//                 elevation: 1,
//                 surfaceTintColor: theme.colorScheme.surfaceTint,
//                 child: Flex.horizontal(
//                   children: [
//                     if (media.windowClass > WindowWidthSizeClass.medium)
//                       media.WindowWidthSizeClass.isExtraLarge
//                           ? DrawerTheme(
//                               data: const DrawerThemeData(
//                                 shape: RoundedRectangleBorder(),
//                               ),
//                               child: drawer,
//                             )
//                           : NavigationRail(
//                               onDestinationSelected: _setPage,
//                               selectedIndex: _page,
//                               labelType: NavigationRailLabelType.all,
//                               backgroundColor: Colors.transparent,
//                               leading: IconButton(
//                                 onPressed: () =>
//                                     _scaffoldKey.currentState?.openDrawer(),
//                                 icon: const Icon(MaterialSymbols.menu_rounded),
//                               ),
//                               trailing: IconButton(
//                                 onPressed: () => Navigator.push(
//                                   context,
//                                 MaterialPageRoute<void>(
//                                     child: const SettingsView(),
//                                   ),
//                                 ),
//                                 icon: const Icon(MaterialSymbols.settings_rounded),
//                               ),
//                               destinations: const [
//                                 NavigationRailDestination(
//                                   icon: Icon(MaterialSymbols.home_rounded, fill: 0),
//                                   selectedIcon:
//                                       Icon(MaterialSymbols.home_rounded, fill: 1),
//                                   label: Text("Home"),
//                                 ),
//                                 NavigationRailDestination(
//                                   icon: Icon(MaterialSymbols.notes_rounded, fill: 0),
//                                   selectedIcon:
//                                       Icon(MaterialSymbols.notes_rounded, fill: 1),
//                                   label: Text("Notes"),
//                                 ),
//                                 NavigationRailDestination(
//                                   icon: Icon(MaterialSymbols.task_alt_rounded, fill: 0),
//                                   selectedIcon:
//                                       Icon(MaterialSymbols.task_alt_rounded, fill: 1),
//                                   label: Text("To-dos"),
//                                 ),
//                               ],
//                             ),
//                     Flexible.tight(
//                       flex: media.windowClass > WindowWidthSizeClass.medium ? 2 : 1,
//                       child: ScrollToTop(
//                         controller: _scrollController,
//                         top: 88,
//                         child: CustomScrollView(
//                           controller: _scrollController,
//                           slivers: [
//                             SliverAppBar(
//                               pinned: true,
//                               floating: true,
//                               forceElevated: true,
//                               scrolledUnderElevation: 1,
//                               toolbarHeight: 0,
//                               bottom: PreferredSize(
//                                 preferredSize: const Size.fromHeight(88),
//                                 child: Padding(
//                                   padding: EdgeInsets.fromLTRB(
//                                     media.windowClass <= WindowWidthSizeClass.medium
//                                         ? 16
//                                         : 0,
//                                     16,
//                                     16,
//                                     16,
//                                   ),
//                                   child: SearchBar(
//                                     controller: _searchTextController,
//                                     focusNode: _searchNode,
//                                     // onChanged: _setQuery,
//                                     padding: const WidgetStatePropertyAll(
//                                       EdgeInsets.symmetric(horizontal: 16),
//                                     ),
//                                     // elevation: const WidgetStatePropertyAll(6),
//                                     shadowColor: const WidgetStatePropertyAll(
//                                         Colors.transparent),
//                                     leading: Switcher.fadeThrough(
//                                       duration: Durations.short4,
//                                       alignment: Alignment.center,
//                                       child: KeyedSubtree(
//                                         key: ValueKey(_searchFocused),
//                                         child: _searchFocused
//                                             ? IconButton(
//                                                 onPressed: () =>
//                                                     _searchNode.unfocus(),
//                                                 icon: const Icon(
//                                                     MaterialSymbols.arrow_back_rounded),
//                                               )
//                                             : const SizedBox.square(
//                                                 dimension: 40,
//                                                 child: Icon(
//                                                     MaterialSymbols.search_rounded),
//                                               ),
//                                       ),
//                                     ),
//                                     hintText: "Search notes",
//                                     trailing: [
//                                       _searchTextController.text.isNotEmpty
//                                           ? IconButton(
//                                               onPressed: () =>
//                                                   _searchTextController.clear(),
//                                               icon: const Icon(
//                                                   MaterialSymbols.clear_rounded),
//                                             )
//                                           : IconButton(
//                                               onPressed: _refreshNotes,
//                                               icon: const Icon(
//                                                   MaterialSymbols.refresh_rounded),
//                                             ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SliverPadding(
//                               padding: EdgeInsets.fromLTRB(
//                                   media.windowClass <= WindowWidthSizeClass.medium
//                                       ? 24
//                                       : 0,
//                                   0,
//                                   16,
//                                   16),
//                               sliver: StreamBuilder(
//                                 stream: _notesController.stream,
//                                 builder: (context, snapshot) {
//                                   if (!snapshot.hasData) {
//                                     return const SliverFillRemaining(
//                                       child: Align.center(
//                                         child: CircularProgressIndicator(value:null),
//                                       ),
//                                     );
//                                   }

//                                   final notes = snapshot.data!;

//                                   return notes.isEmpty
//                                       ? SliverFillRemaining(
//                                           child: Align.center(
//                                             child: Text(
//                                               "No results found!",
//                                               style: theme.textTheme.bodyLarge,
//                                             ),
//                                           ),
//                                         )
//                                       : SliverList.separated(
//                                           itemCount: notes.length,
//                                           itemBuilder: (context, index) =>
//                                               Card(
//                                             key: ValueKey(notes[index].id),
//                                             elevation: 0,
//                                             color: _note?.id == notes[index].id
//                                                 ? theme.colorScheme
//                                                     .secondaryContainer
//                                                 : null,
//                                             child: InkWell(
//                                               onTap: () => setState(
//                                                   () => _note = notes[index]),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(16),
//                                                 child: Flex.vertical(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Flex.horizontal(
//                                                       children: [
//                                                         Flex.vertical(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             Text(
//                                                               notes[index]
//                                                                   .updatedAt
//                                                                   .toString(),
//                                                               style: theme
//                                                                   .textTheme
//                                                                   .bodySmall,
//                                                             ),
//                                                             Text(
//                                                               notes[index]
//                                                                   .title,
//                                                               style: theme
//                                                                   .textTheme
//                                                                   .titleLarge,
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         const Flexible.space(),
//                                                         IconButton(
//                                                           onPressed: () =>
//                                                               setState(() => notes[
//                                                                           index]
//                                                                       .favorite =
//                                                                   !notes[index]
//                                                                       .favorite),
//                                                           style: notes[index]
//                                                                   .favorite
//                                                               ? ButtonStyle(
//                                                                   backgroundColor:
//                                                                       WidgetStatePropertyAll(
//                                                                     theme
//                                                                         .colorScheme
//                                                                         .surface,
//                                                                   ),
//                                                                 )
//                                                               : null,
//                                                           icon: Icon(
//                                                             Symbols
//                                                                 .star_rounded,
//                                                             fill: notes[index]
//                                                                     .favorite
//                                                                 ? 1
//                                                                 : 0,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     const SizedBox(height: 8),
//                                                     Text(
//                                                       notes[index].contentText,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       maxLines: 2,
//                                                       style: theme
//                                                           .textTheme.bodyMedium,
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           separatorBuilder: (context, index) =>
//                                               const SizedBox(height: 8),
//                                         );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Flexible.tight(
//                       flex: media.windowClass > WindowWidthSizeClass.medium ? 3 : 1,
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(8, 16, 24, 16),
//                         child: Card(
//                           elevation: 0,
//                           child: AnimatedSize(
//                             duration: Durations.medium4,
//                             curve: Curves.easeInOutCubicEmphasized,
//                             alignment: Alignment.centerRight,
//                             child: _note != null
//                                 ? NoteEditPage(
//                                     key: ValueKey(_note!.id),
//                                     note: _note!,
//                                     onBackButtonPressed: () =>
//                                         setState(() => _note = null),
//                                   )
//                                 : const SizedBox(
//                                     height: double.infinity,
//                                   ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // const SizedBox(width: 24),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class NoteEditPage extends StatefulWidget {
//   const NoteEditPage({
//     super.key,
//     required this.note,
//     this.onBackButtonPressed,
//   });

//   final Note note;

//   final VoidCallback? onBackButtonPressed;

//   @override
//   State<NoteEditPage> createState() => _NoteEditPageState();
// }

// class _NoteEditPageState extends State<NoteEditPage> {
//   late final ScrollController _scrollController;

//   late final TextEditingController _titleController;
//   late final FleatherController _contentController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();

//     _titleController = TextEditingController(
//       text: widget.note.title,
//     );
//     _contentController = FleatherController(
//       document: widget.note.content,
//     );
//   }

//   @override
//   void dispose() {
//     _contentController.dispose();
//     _titleController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {},
//       //   child: const Icon(MaterialSymbols.add_rounded),
//       // ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
//       bottomNavigationBar: BottomAppBar(
//         elevation: 0,
//         child: Flex.horizontal(
//           children: [
//             Flexible.tight(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Flex.horizontal(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     FleatherToggleStyleButton(
//                       controller: _contentController,
//                       attribute: ParchmentAttribute.bold,
//                       icon: MaterialSymbols.format_bold_rounded,
//                     ),
//                     FleatherToggleStyleButton(
//                       controller: _contentController,
//                       attribute: ParchmentAttribute.italic,
//                       icon: MaterialSymbols.format_italic_rounded,
//                     ),
//                     FleatherToggleStyleButton(
//                       controller: _contentController,
//                       attribute: ParchmentAttribute.underline,
//                       icon: MaterialSymbols.format_underlined_rounded,
//                     ),
//                     FleatherClearStyleButton(
//                       controller: _contentController,
//                     ),
//                     const VerticalDivider(),
//                     MenuAnchor(
//                       menuChildren: [
//                         MenuItemButton(
//                           onPressed: () {},
//                           leadingIcon: const Icon(MaterialSymbols.format_h1_rounded),
//                           child: Text("Header 1"),
//                         ),
//                         MenuItemButton(
//                           onPressed: () {},
//                           leadingIcon: const Icon(MaterialSymbols.format_h2_rounded),
//                           child: Text("Header 2"),
//                         ),
//                         MenuItemButton(
//                           onPressed: () {},
//                           leadingIcon: const Icon(MaterialSymbols.format_h3_rounded),
//                           child: Text("Header 3"),
//                         ),
//                         MenuItemButton(
//                           onPressed: () {},
//                           leadingIcon: const Icon(MaterialSymbols.format_h4_rounded),
//                           child: Text("Header 4"),
//                         ),
//                         MenuItemButton(
//                           onPressed: () {},
//                           leadingIcon: const Icon(MaterialSymbols.format_h5_rounded),
//                           child: Text("Header 5"),
//                         ),
//                         MenuItemButton(
//                           onPressed: () {},
//                           leadingIcon: const Icon(MaterialSymbols.format_h6_rounded),
//                           child: Text("Header 6"),
//                         ),
//                       ],
//                       builder: (context, controller, child) =>
//                           FilledButton.tonalIcon(
//                         onPressed: controller.open,
//                         icon: const Icon(MaterialSymbols.add_rounded),
//                         label: const Text("Header"),
//                       ),
//                     ),
//                     const VerticalDivider(),
//                     FleatherToggleStyleButton(
//                       controller: _contentController,
//                       attribute: ParchmentAttribute.ol,
//                       icon: MaterialSymbols.format_list_numbered_rounded,
//                     ),
//                     FleatherToggleStyleButton(
//                       controller: _contentController,
//                       attribute: ParchmentAttribute.ul,
//                       icon: MaterialSymbols.format_list_bulleted_rounded,
//                     ),
//                     FleatherToggleStyleButton(
//                       controller: _contentController,
//                       attribute: ParchmentAttribute.cl,
//                       icon: MaterialSymbols.check_box_rounded,
//                     ),
//                     FleatherToggleStyleButton(
//                       controller: _contentController,
//                       attribute: ParchmentAttribute.code,
//                       icon: MaterialSymbols.code_blocks_rounded,
//                     ),
//                     const VerticalDivider(),
//                     FleatherIndentationButton(
//                       controller: _contentController,
//                       increase: true,
//                     ),
//                     FleatherIndentationButton(
//                       controller: _contentController,
//                       increase: false,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // const SizedBox(
//             //   width: 72,
//             // ),
//           ],
//         ),
//       ),
//       body: CustomScrollView(
//         controller: _scrollController,
//         slivers: [
//           SliverAppBar.large(
//             scrolledUnderElevation: 0,
//             leadingWidth: 64,
//             leading: widget.onBackButtonPressed != null
//                 ? IconButton(
//                     onPressed: widget.onBackButtonPressed!,
//                     icon: const Icon(MaterialSymbols.arrow_back_rounded),
//                   )
//                 : null,
//             title: Builder(
//               builder: (context) => TextField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   hintText: "Title",
//                   border: InputBorder.none,
//                 ),
//                 style: DefaultTextStyle.of(context).style,
//               ),
//             ),
//             actions: [
//               FleatherHistoryButton.undo(
//                 controller: _contentController,
//               ),
//               FleatherHistoryButton.redo(
//                 controller: _contentController,
//               ),
//               const SizedBox(width: 16),
//               FilledButton.tonalIcon(
//                 onPressed: () {},
//                 icon: const Icon(MaterialSymbols.save_rounded),
//                 label: const Text("Save"),
//               ),
//               const SizedBox(width: 16),
//             ],
//           ),
//           SliverToBoxAdapter(
//             child: FleatherTheme(
//               data: CustomFleatherThemeData.fallback(Theme.of(context)),
//               child: FleatherEditor(
//                 controller: _contentController,
//                 scrollController: _scrollController,
//                 scrollable: false,
//                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TitleBarTest extends StatefulWidget {
//   const TitleBarTest({super.key});

//   @override
//   State<TitleBarTest> createState() => _TitleBarTestState();
// }

// class _TitleBarTestState extends State<TitleBarTest> {
//   @override
//   Widget build(BuildContext context) {
//     final media = MediaQuery.of(context);
//     final theme = Theme.of(context);
//     return SizedBox(
//       height: 48,
//       child: GestureDetector(
//         onPanStart: (event) => windowManager.startDragging(),
//         dragStartBehavior: DragStartBehavior.start,
//         child: Material(
//           type: MaterialType.canvas,
//           color: theme.colorScheme.surface,
//           surfaceTintColor: theme.colorScheme.surfaceTint,
//           elevation: 1,
//           child: Flex.horizontal(
//             children: [
//               const TitleBarBackButton(),
//               // const SizedBox(width: 8),
//               InkWell(
//                 onTap: () {},
//                 customBorder: const StadiumBorder(),
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
//                   child: Flex.horizontal(
//                     children: [
//                       const Image(
//                         image: Images.ic_launcher,
//                         width: 32,
//                         height: 32,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         "Notes",
//                         style: theme.textTheme.bodyMedium,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {},
//                 borderRadius:
//                     BorderRadius.horizontal(left: Radius.circular(12)),
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   child: SizedBox(
//                     height: 40,
//                     child: AppIcon(.arrowBack),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {},
//                 borderRadius:
//                     BorderRadius.horizontal(right: Radius.circular(12)),
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
//                   child: SizedBox(
//                     height: 40,
//                     child: Flex.horizontal(
//                       children: [
//                         const Image(
//                           image: Images.ic_launcher,
//                           width: 32,
//                           height: 32,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           "Notes",
//                           style: theme.textTheme.bodyMedium,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const Flexible.space(),
//               if (media.windowClass >= WindowWidthSizeClass.medium)
//                 SearchBarTheme(
//                   data: const SearchBarThemeData(
//                     shadowColor: WidgetStatePropertyAll(Colors.transparent),
//                   ),
//                   child: SearchAnchor.bar(
//                     suggestionsBuilder: (context, controller) => [],
//                     constraints: BoxConstraints.tight(const Size(360, 32)),
//                     viewShape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     barLeading: Icon(
//                       MaterialSymbols.search_rounded,
//                       size: 20,
//                       opticalSize: 20,
//                     ),
//                     barHintText: "Search",
//                     barTextStyle: WidgetStatePropertyAll(
//                       theme.textTheme.bodySmall
//                           ?.copyWith(color: theme.colorScheme.onSurface),
//                     ),
//                   ),
//                 ),
//               // SearchBar(
//               //   constraints: BoxConstraints.tight(const Size(360, 48)),
//               //   leading: const SizedBox(
//               //     width: 40,
//               //     height: 40,
//               //     child: Icon(
//               //       MaterialSymbols.search_rounded,
//               //       size: 20,
//               //       opticalSize: 20,
//               //     ),
//               //   ),
//               //   hintText: "Search",
//               //   elevation: const WidgetStatePropertyAll(0),
//               //   shadowColor: const WidgetStatePropertyAll(Colors.transparent),
//               // ),
//               const Flexible.space(),
//               TitleBarMinimizeButton(),
//               TitleBarMaximizeButton(),
//               TitleBarCloseButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// final defaultForegroundColor = WidgetStateColor.resolveWith(
//   (states) {
//     if (states.contains(WidgetState.pressed)) {
//       return Colors.white.withOpacity(0.786);
//     }
//     return Colors.white;
//   },
// );

// class TitleBarMinimizeButton extends StatefulWidget {
//   const TitleBarMinimizeButton({super.key});

//   @override
//   State<TitleBarMinimizeButton> createState() => _TitleBarMinimizeButtonState();
// }

// class _TitleBarMinimizeButtonState extends State<TitleBarMinimizeButton> {
//   late WidgetStatesController _statesController;

//   @override
//   void initState() {
//     super.initState();
//     _statesController = WidgetStatesController();
//   }

//   @override
//   void dispose() {
//     _statesController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final foregroundColor = defaultForegroundColor;

//     final hoverColor = Colors.white.withOpacity(0.0605);
//     final pressedColor = Colors.white.withOpacity(0.0419);

//     return SizedBox(
//       width: 48,
//       height: 48,
//       child: InkWell(
//         onTap: () => windowManager.minimize(),
//         statesController: _statesController,
//         hoverColor: hoverColor,
//         highlightColor: pressedColor,
//         child: Icon(
//           const IconData(
//             0xE921,
//             fontFamily: "Segoe Fluent Icons",
//           ),
//           color: foregroundColor.resolve(_statesController.value),
//           size: 10,
//         ),
//       ),
//     );
//   }
// }

// class TitleBarBackButton extends StatefulWidget {
//   const TitleBarBackButton({super.key});

//   @override
//   State<TitleBarBackButton> createState() => _TitleBarBackButtonState();
// }

// class _TitleBarBackButtonState extends State<TitleBarBackButton> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(4),
//       child: SizedBox(
//         width: 40,
//         height: 40,
//         child: InkWell(
//           onTap: () {},
//           borderRadius: BorderRadius.circular(4),
//           hoverColor: Colors.white.withOpacity(0.0605),
//           highlightColor: Colors.white.withOpacity(0.0419),
//           child: const Icon(
//             IconData(0xE830, fontFamily: "Segoe Fluent Icons"),
//             size: 12,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TitleBarMaximizeButton extends StatefulWidget {
//   const TitleBarMaximizeButton({super.key});

//   @override
//   State<TitleBarMaximizeButton> createState() => _TitleBarMaximizeButtonState();
// }

// class _TitleBarMaximizeButtonState extends State<TitleBarMaximizeButton>
//     with WindowListener {
//   late WidgetStatesController _statesController;

//   bool _maximized = false;

//   @override
//   void initState() {
//     super.initState();
//     _statesController = WidgetStatesController();
//     windowManager.addListener(this);
//   }

//   @override
//   void dispose() {
//     windowManager.removeListener(this);
//     _statesController.dispose();
//     super.dispose();
//   }

//   @override
//   void onWindowMaximize() {
//     setState(() => _maximized = true);
//   }

//   @override
//   void onWindowUnmaximize() {
//     setState(() => _maximized = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final foregroundColor = defaultForegroundColor;

//     final hoverColor = Colors.white.withOpacity(0.0605);
//     final pressedColor = Colors.white.withOpacity(0.0419);

//     return SizedBox(
//       width: 48,
//       height: 48,
//       child: InkWell(
//         onTap: _maximized ? windowManager.unmaximize : windowManager.maximize,
//         statesController: _statesController,
//         hoverColor: hoverColor,
//         highlightColor: pressedColor,
//         child: Icon(
//           IconData(
//             _maximized ? 0xE923 : 0xE922,
//             fontFamily: "Segoe Fluent Icons",
//           ),
//           color: foregroundColor.resolve(_statesController.value),
//           size: 10,
//         ),
//       ),
//     );
//   }
// }

// class TitleBarCloseButton extends StatefulWidget {
//   const TitleBarCloseButton({super.key});

//   @override
//   State<TitleBarCloseButton> createState() => _TitleBarCloseButtonState();
// }

// class _TitleBarCloseButtonState extends State<TitleBarCloseButton> {
//   late WidgetStatesController _statesController;

//   @override
//   void initState() {
//     super.initState();
//     _statesController = WidgetStatesController();
//   }

//   @override
//   void dispose() {
//     _statesController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final foregroundColor = defaultForegroundColor;

//     return SizedBox(
//       width: 48,
//       height: double.infinity,
//       child: InkWell(
//         onTap: () => windowManager.close(),
//         statesController: _statesController,
//         hoverColor: const Color(0xFFc42b1c),
//         highlightColor: const Color(0xFFb32a1c),
//         child: Icon(
//           const IconData(
//             0xE8BB,
//             fontFamily: "Segoe Fluent Icons",
//           ),
//           color: foregroundColor.resolve(_statesController.value),
//           size: 10,
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:notes/constants/images.dart';
import 'package:notes/icons/segoe.dart';
import 'package:notes/native.dart';
import 'package:notes/widgets/scroll_to_top.dart';
import 'package:notes/widgets/title_bar/windows.dart';
import 'package:notes/flutter.dart';
import 'package:window_manager/window_manager.dart';

class AdaptiveInfo {
  const AdaptiveInfo(this.windowWidthSizeClass);

  final WindowWidthSizeClass windowWidthSizeClass;

  bool get shouldUseNavigationBar =>
      windowWidthSizeClass <= WindowWidthSizeClass.medium;

  bool get shouldUseNavigationDrawer =>
      windowWidthSizeClass >= WindowWidthSizeClass.extraLarge;

  bool get shouldUseNavigationRail =>
      !shouldUseNavigationBar && !shouldUseNavigationDrawer;

  bool get shouldUseSideNavigation =>
      shouldUseNavigationRail || shouldUseNavigationDrawer;

  bool get shouldUseTwoPanelLayout =>
      windowWidthSizeClass >= WindowWidthSizeClass.medium;

  bool get shouldUseEqualPanels =>
      windowWidthSizeClass <= WindowWidthSizeClass.medium;
}

class AdaptiveDestination {
  const AdaptiveDestination({
    // this.key,
    this.enabled = true,
    required this.icon,
    this.selectedIcon,
    required this.label,
  });

  // final Key? key;

  final bool enabled;

  final Widget icon;
  final Widget? selectedIcon;
  final String label;

  NavigationDestination get barDestination => NavigationDestination(
    // key: key,
    enabled: enabled,
    icon: icon,
    selectedIcon: selectedIcon,
    label: label,
  );
  NavigationRailDestination get railDestination => NavigationRailDestination(
    disabled: !enabled,
    icon: icon,
    selectedIcon: selectedIcon,
    label: Text(label),
  );
  NavigationDrawerDestination get drawerDestination =>
      NavigationDrawerDestination(
        // key: key,
        enabled: enabled,
        icon: icon,
        selectedIcon: selectedIcon,
        label: Text(label),
      );
}

extension AdaptiveDestinationList on List<AdaptiveDestination> {
  List<NavigationDestination> toBarDestinations() =>
      map((e) => e.barDestination).toList();
  List<NavigationRailDestination> toRailDestinations() =>
      map((e) => e.railDestination).toList();
  List<NavigationDrawerDestination> toDrawerDestinations() =>
      map((e) => e.drawerDestination).toList();
}

class ExpandedApp extends StatefulWidget {
  const ExpandedApp({super.key});

  @override
  State<ExpandedApp> createState() => _ExpandedAppState();
}

class _ExpandedAppState extends State<ExpandedApp> {
  late final ScrollController _scrollController;

  late final FocusNode _searchNode;

  int? _selected;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchNode = FocusNode();
  }

  @override
  void dispose() {
    _searchNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final media = MediaQuery.of(context);
  //   final windowClass = media.windowClass;

  //   final shouldUseNavigationBar = windowClass <= WindowWidthSizeClass.medium;
  //   final shouldUseNavigationRail = windowClass > WindowWidthSizeClass.medium;
  //   final shouldUseNavigationDrawer = windowClass >= WindowWidthSizeClass.extraLarge;
  //   final shouldUseTwoPanelLayout = windowClass >= WindowWidthSizeClass.medium;

  //   debugPrint(
  //     <String, bool>{
  //       "navigationBar": shouldUseNavigationBar,
  //       "navigationRail": shouldUseNavigationRail,
  //       "navigationDrawer": shouldUseNavigationDrawer,
  //       "twoPanelLayout": shouldUseTwoPanelLayout,
  //     }.toString(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final adaptive = AdaptiveInfo(WindowWidthSizeClass.of(context));

    final theme = Theme.of(context);

    final backgroundColor = ElevationOverlay.applySurfaceTint(
      theme.colorScheme.surface,
      theme.colorScheme.surfaceTint,
      adaptive.shouldUseTwoPanelLayout ? 1 : 0,
    );

    const destinations = <AdaptiveDestination>[
      AdaptiveDestination(
        icon: Icon(MaterialSymbols.home_rounded, fill: 0),
        selectedIcon: Icon(MaterialSymbols.home_rounded, fill: 1),
        label: "Home",
      ),
      AdaptiveDestination(
        icon: Icon(MaterialSymbols.notes_rounded, fill: 0),
        selectedIcon: Icon(MaterialSymbols.notes_rounded, fill: 1),
        label: "Notes",
      ),
      AdaptiveDestination(
        icon: Icon(MaterialSymbols.task_alt_rounded, fill: 0),
        selectedIcon: Icon(MaterialSymbols.task_alt_rounded, fill: 1),
        label: "To-dos",
      ),
    ];

    unawaited(windowManager.setTitleBarStyle(TitleBarStyle.hidden));
    unawaited(NativeService.setWindowCaptionColor(backgroundColor));

    return Flex.vertical(
      children: [
        Surface(
          color: backgroundColor,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) => windowManager.startDragging(),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: Flex.horizontal(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(4),
                      child: const SizedBox.square(
                        dimension: 40,
                        child: Icon(SegoeIcons.chrome_back, size: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Image(image: Images.ic_launcher, width: 32, height: 32),
                  const SizedBox(width: 8),
                  Text("Notes", style: theme.textTheme.bodySmall),
                  const Flexible.space(),
                  WindowsTitleBarControls(compact: false),
                ],
              ),
            ),
          ),
        ),
        Flexible.tight(
          child: Scaffold(
            backgroundColor: backgroundColor,
            bottomNavigationBar: adaptive.shouldUseNavigationBar
                ? NavigationBar(
                    onDestinationSelected: (value) {},
                    selectedIndex: 0,
                    destinations: destinations.toBarDestinations(),
                  )
                : null,
            body: adaptive.shouldUseTwoPanelLayout
                ? Flex.horizontal(
                    children: [
                      if (adaptive.shouldUseNavigationRail)
                        NavigationRail(
                          onDestinationSelected: (value) {},
                          selectedIndex: 0,
                          backgroundColor: backgroundColor,
                          leading: IconButton(
                            onPressed: () {},
                            icon: const Icon(MaterialSymbols.menu_rounded),
                          ),
                          labelType: NavigationRailLabelType.all,
                          destinations: destinations.toRailDestinations(),
                        ),
                      if (adaptive.shouldUseNavigationDrawer)
                        NavigationDrawer(
                          children: [...destinations.toDrawerDestinations()],
                        ),
                      Flexible.tight(
                        flex: adaptive.shouldUseEqualPanels ? 1 : 2,
                        child: ScrollToTop(
                          controller: _scrollController,
                          top: 72,
                          minOffset: 120,
                          child: CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              SliverAppBar(
                                pinned: true,
                                // floating: true,
                                forceElevated: true,
                                toolbarHeight: 0,
                                // leadingWidth: 64,
                                // leading: IconButton(
                                //   onPressed: () {},
                                //   icon: Icon(MaterialSymbols.arrow_back_rounded),
                                // ),
                                // title: Text("Home"),
                                bottom: PreferredSize(
                                  preferredSize: const Size.fromHeight(72),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      16,
                                      16,
                                    ),
                                    child: SearchBar(
                                      focusNode: _searchNode,
                                      // shadowColor:
                                      //     WidgetStateColor.transparent,
                                      padding: const WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(horizontal: 16),
                                      ),
                                      leading: const SizedBox.square(
                                        dimension: 40,
                                        child: AppIcon(.search),
                                      ),
                                      trailing: [
                                        CircleAvatar(
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              MaterialSymbols
                                                  .account_circle_rounded,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  0,
                                  16,
                                  16,
                                ),
                                sliver: SliverList.separated(
                                  itemCount: 32,
                                  itemBuilder: (context, index) => KeyedSubtree(
                                    key: ValueKey(index),
                                    child: Card(
                                      // animationDuration: Durations.short4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          index == _selected ? 28 : 12,
                                        ),
                                      ),
                                      color: index == _selected
                                          ? theme.colorScheme.secondaryContainer
                                          : null,
                                      elevation: 0,
                                      child: InkWell(
                                        onTap: () =>
                                            setState(() => _selected = index),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 24,
                                          ),
                                          child: Flex.vertical(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                "Title",
                                                style:
                                                    theme.textTheme.titleLarge,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "Do duis culpa qui excepteur ex dolor enim qui aute excepteur. Ut deserunt cupidatat culpa do sint est cupidatat et cillum. Id aliquip amet adipisicing pariatur Lorem consequat mollit est ullamco laboris ea dolore est est. Officia ea sit elit est eu deserunt aliqua dolor quis nulla id culpa est est. Pariatur minim in ipsum eu dolor. Eiusmod nulla deserunt irure magna minim enim culpa dolore mollit consectetur culpa nisi nulla.",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    theme.textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 8),
                                ),
                              ),
                              // const SliverToBoxAdapter(child: SizedBox(height: 1000)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible.tight(
                        flex: adaptive.shouldUseEqualPanels ? 1 : 3,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 24, 24),
                          child: Card(
                            elevation: 0,
                            child: Scaffold(
                              body: CustomScrollView(
                                slivers: [
                                  SliverAppBar.large(
                                    leadingWidth: 64,
                                    toolbarHeight: 64,
                                    scrolledUnderElevation: 0,
                                    leading: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        MaterialSymbols.close_rounded,
                                      ),
                                    ),
                                    title: Builder(
                                      builder: (context) => TextField(
                                        // controller: TextEditingController(text: "Title"),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Give this note a title!",
                                        ),
                                        style: DefaultTextStyle.of(context)
                                            .style,
                                      ),
                                    ),
                                    actions: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const AppIcon(.undo),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const AppIcon(.redo),
                                      ),
                                      const SizedBox(width: 16),
                                      FilledButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(
                                          MaterialSymbols.save_rounded,
                                        ),
                                        label: const Text("Save"),
                                      ),
                                      const SizedBox(width: 16),
                                    ],
                                  ),
                                  const SliverToBoxAdapter(
                                    child: SizedBox(height: 1000),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
