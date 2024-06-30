import 'dart:async';

import 'package:intl/intl.dart';
import 'package:material/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/database/database.dart';
import 'package:notes/database/models/note.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/views/note/note.dart';
import 'package:notes/widgets/dense_box.dart';
import 'package:notes/widgets/title_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

const _kResizeDuration = Durations.long4;

class ExpandedApp extends StatefulWidget {
  const ExpandedApp({super.key});

  @override
  State<ExpandedApp> createState() => _ExpandedAppState();
}

class _ExpandedAppState extends State<ExpandedApp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _page = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _setPage(int value) {
    setState(() => _page = value);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    final destinations = [
      AdaptiveDestination(
        icon: const Icon.outlined(Symbols.home_rounded),
        selectedIcon: const Icon.filled(Symbols.home_rounded),
        label: localizations.app_home_view,
      ),
      AdaptiveDestination(
        icon: const Icon(Symbols.notes_rounded),
        label: localizations.app_notes_view,
      ),
      AdaptiveDestination(
        icon: const Icon(Symbols.task_alt_rounded),
        label: localizations.app_todos_view,
      ),
      if (media.windowClass > WindowClass.compact)
        AdaptiveDestination(
          icon: const Icon(Symbols.settings_rounded),
          selectedIcon: const Icon.filled(Symbols.settings_rounded),
          label: localizations.settings_view,
        ),
    ];

    final backgroundColor = media.windowClass >= WindowClass.medium
        ? theme.colorScheme.surfaceContainer
        : theme.colorScheme.surface;

    final useNavigationRail = media.windowClass > WindowClass.medium;
    // &&    media.windowClass < WindowClass.extraLarge;

    final navigationDrawer = NavigationDrawer(
      onDestinationSelected: _setPage,
      selectedIndex: _page,
      children: [
        const SizedBox(height: 12),
        ...destinations.toDrawerDestinations(),
      ],
    );
    final navigationBar = AnimatedAlign(
      duration: _kResizeDuration,
      curve: Easing.emphasized,
      alignment: Alignment.topCenter,
      heightFactor: media.windowClass <= WindowClass.medium ? 1 : 0,
      child: NavigationBar(
        onDestinationSelected: _setPage,
        selectedIndex: _page,
        destinations: destinations.toBarDestinations(),
      ),
    );

    return _BackgroundColorBuilder(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: Row(
          children: [
            AnimatedAlign(
              duration: _kResizeDuration,
              curve: Easing.emphasized,
              alignment: Alignment.centerRight,
              widthFactor: useNavigationRail ? 1 : 0,
              child: NavigationRail(
                onDestinationSelected: _setPage,
                selectedIndex: _page,
                labelType: NavigationRailLabelType.all,
                backgroundColor: backgroundColor,
                leading: IconButton(
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(Symbols.menu_rounded),
                ),
                destinations: destinations.toRailDestinations(),
              ),
            ),
            Expanded(
              child: switch (_page) {
                1 => const _NotesBody(),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
      builder: (context, backgroundColor, child) => TitleBar(
        backgroundColor: backgroundColor,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: backgroundColor,
          drawer: navigationDrawer,
          body: child!,
          bottomNavigationBar: navigationBar,
        ),
      ),
    );
  }
}

class _BackgroundColorBuilder extends StatelessWidget {
  const _BackgroundColorBuilder({
    super.key,
    required this.backgroundColor,
    this.child,
    required this.builder,
  });
  final Color backgroundColor;
  final Widget? child;
  final Function(BuildContext context, Color value, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: ColorTween(end: backgroundColor),
      duration: Durations.medium4,
      curve: Easing.standard,
      child: child,
      builder: (context, value, child) => builder(context, value!, child),
    );
  }
}

class _NotesBody extends StatefulWidget {
  const _NotesBody({super.key});

  @override
  State<_NotesBody> createState() => __NotesBodyState();
}

class __NotesBodyState extends State<_NotesBody> {
  final _notesController = StreamController<List<Note>>();
  StreamSubscription<List<Note>>? _notesSubscription;
  Completer<void>? _refreshCompleter;

  String _query = "";

  late FocusNode _searchNode;

  Note? _selected;

  @override
  void initState() {
    super.initState();
    _searchNode = FocusNode()
      ..addListener(() {
        setState(() {});
      });

    // _refresh();
  }

  @override
  void dispose() {
    _searchNode.dispose();

    _refreshCompleter = null;
    _notesSubscription?.cancel();
    _notesController.close();

    super.dispose();
  }

  Future<void> _refresh() async {
    final notes = Database.watchSearchNotes(_query);

    _refreshCompleter = Completer();

    _notesSubscription?.cancel();
    _notesSubscription = notes.listen(
      (event) {
        _notesController.add(event);
        if (_refreshCompleter?.isCompleted == false) {
          _refreshCompleter!.complete();
          _refreshCompleter = null;
        }
      },
    );

    await _refreshCompleter?.future;
  }

  void _setSelected(Note? selected) {
    setState(() => _selected = selected);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    final localizations = AppLocalizations.of(context);

    final dateFormat = DateFormat.yMMMEd(localizations.localeName);
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
                child: SearchBar(
                  focusNode: _searchNode,
                  onChanged: (value) => setState(() => _query = value),
                  leading: _searchNode.hasFocus
                      ? IconButton(
                          onPressed: _searchNode.unfocus,
                          icon: const Icon(Symbols.arrow_back_rounded),
                        )
                      : const DenseBox.square(
                          dimension: 48,
                          child: Icon(Symbols.search_rounded),
                        ),
                  hintText: localizations.app_notes_view_search,
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _notesController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Skeletonizer(
                        child: ListView.separated(
                          itemCount: 32,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) => Card.filled(
                            child: SizedBox(
                              height: 10,
                            ),
                          ),
                        ),
                      );
                    }
                    final notes = snapshot.data!;
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(0, 8, 16, 16),
                      itemCount: notes.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Card.surface(
                          color: _selected?.id == note.id
                              ? theme.colorScheme.secondaryContainer
                              : theme.colorScheme.surface,
                          child: InkWell(
                            onTap: () => _setSelected(note),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        note.title,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      const Spacer(),
                                      Text(
                                        dateFormat.format(note.updatedAt),
                                        style: theme.textTheme.labelMedium,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    note.contentText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 24, 24),
            child: Card.surface(
              child: _selected != null
                  ? NoteView(
                      key: ValueKey(_selected!.id),
                      note: _selected,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}
