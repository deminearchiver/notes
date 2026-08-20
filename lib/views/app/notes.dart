import 'dart:async';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:notes/database/database.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/views/note/note.dart';
import 'package:notes/widgets/scroll_to_top.dart';
import 'package:notes/widgets/sort.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:notes/flutter.dart';

enum NotesSortBy { title, createdAt, updatedAt }

class AppViewNotesPage extends StatefulWidget {
  const AppViewNotesPage({
    super.key,
    required this.scrollableKey,
    required this.scrollController,
    this.headerBuilder,
    required this.contentBuilder,
  });

  final Key scrollableKey;

  final ScrollController scrollController;

  final Widget Function(
    BuildContext context,
    void Function(String value) onQueryChanged,
  )?
  headerBuilder;
  final Widget Function(BuildContext context, Widget child) contentBuilder;

  @override
  State<AppViewNotesPage> createState() => _AppViewNotesPageState();
}

class _AppViewNotesPageState extends State<AppViewNotesPage> {
  final _notes = StreamController<List<Note>>();
  StreamSubscription<List<Note>>? _notesSubscription;
  Completer<void>? _refreshCompleter;

  String _query = "";
  NotesSortBy _sortBy = NotesSortBy.updatedAt;
  Sort _sortOrder = Sort.desc;

  @override
  void initState() {
    super.initState();

    unawaited(_reload());
  }

  @override
  void dispose() {
    _refreshCompleter = null;
    unawaited(_notesSubscription?.cancel());
    unawaited(_notes.close());
    super.dispose();
  }

  Future<void> _reload() async {
    final database = AppDatabase.of(context, listen: false);

    Expression<Object> orderColumn(Notes n) => switch (_sortBy) {
      NotesSortBy.title => n.title,
      NotesSortBy.createdAt => n.createdAt,
      NotesSortBy.updatedAt => n.updatedAt,
    };

    final mode = _sortOrder == Sort.asc ? OrderingMode.asc : OrderingMode.desc;

    final trimmed = _query.trim();
    final Stream<List<Note>> notesStream;
    if (trimmed.isEmpty) {
      notesStream =
          (database.select(database.notes)..orderBy([
                (t) => OrderingTerm(expression: orderColumn(t), mode: mode),
              ]))
              .watch();
    } else {
      notesStream = database
          .searchNotes(
            trimmed,
            orderBy: (notesTable, notesFts) => OrderBy([
              OrderingTerm(expression: orderColumn(notesTable), mode: mode),
            ]),
          )
          .watch();
    }
    _refreshCompleter = Completer();

    unawaited(_notesSubscription?.cancel());
    _notesSubscription = notesStream.listen(
      (event) {
        _notes.add(event);
        if (_refreshCompleter?.isCompleted ?? false) return;
        _refreshCompleter?.complete();
      },
      onError: (Object error, StackTrace stackTrace) {
        _notes.addError(error, stackTrace);
        if (_refreshCompleter?.isCompleted ?? false) return;
        _refreshCompleter?.complete();
      },
    );

    await _refreshCompleter?.future;
  }

  void _setQuery(String value) {
    setState(() => _query = value);
    unawaited(_reload());
  }

  void _setSort(SortDetails<NotesSortBy> value) {
    setState(() {
      _sortBy = value.sort;
      _sortOrder = value.order;
    });
    unawaited(_reload());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return ScrollToTop(
      controller: widget.scrollController,
      top: 96,
      minOffset: 120,
      child: CustomScrollView(
        key: widget.scrollableKey,
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (widget.headerBuilder != null)
            widget.headerBuilder!(context, _setQuery),
          widget.contentBuilder(
            context,
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: MultiSliver(
                children: [
                  SliverToBoxAdapter(
                    child: SortRow(
                      onSortChanged: _setSort,
                      selected: _sortBy,
                      order: _sortOrder,
                      types: [
                        SortType(
                          value: NotesSortBy.title,
                          icon: const Icon(
                            MaterialSymbols.sort_by_alpha_rounded,
                          ),
                          label: localizations.app_notes_view_sort_title,
                        ),
                        SortType(
                          value: NotesSortBy.createdAt,
                          icon: const Icon(MaterialSymbols.schedule_rounded),
                          label: localizations.app_notes_view_sort_created,
                        ),
                        SortType(
                          value: NotesSortBy.updatedAt,
                          icon: const Icon(MaterialSymbols.history_rounded),
                          label: localizations.app_notes_view_sort_modified,
                        ),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  StreamBuilder(
                    stream: _notes.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SliverFillRemaining(
                          child: Align.center(
                            child: CircularProgressIndicator(value: null),
                          ),
                        );
                      }
                      final notes = snapshot.data!;
                      return notes.isEmpty
                          ? SliverToBoxAdapter(
                              child: Align.center(
                                child: Text(
                                  localizations.search_no_results,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            )
                          : SliverList.separated(
                              itemCount: notes.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 2.0),
                              itemBuilder: (context, index) => NoteCard(
                                key: ValueKey(notes[index].id),
                                note: notes[index],
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoteCard extends StatefulWidget {
  const NoteCard({super.key, required this.note});

  final Note note;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late Note _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  @override
  void didUpdateWidget(covariant NoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_note != widget.note) {
      _note = widget.note;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    final result = await showModalBottomSheet<String>(
      context: context,
      clipBehavior: Clip.antiAlias,
      showDragHandle: true,
      builder: (context) => Flex.vertical(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () => Navigator.pop(context, "share"),
            leading: const Icon(MaterialSymbols.share_rounded, fill: 1),
            title: Text(localizations.share),
          ),
          ListTile(
            onTap: () => Navigator.pop(context, "delete"),
            leading: const Icon(MaterialSymbols.delete_rounded),
            title: Text(localizations.delete),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
    switch (result) {
      case "delete":
        if (!context.mounted) break;
        final database = AppDatabase.of(context, listen: false);
        await (database.delete(
          database.notes,
        )..where((t) => t.id.equals(_note.id))).go();
      case "share":
        await SharePlus.instance.share(
          .new(
            title: _note.title,
            text: _note.contentText,
            subject: _note.title,
          ),
        );
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final formatter = DateFormat.yMMMEd(localizations.localeName);

    final colorTheme = ColorTheme.of(context);
    // final elevationTheme = ElevationTheme.of(context);
    final shapeTheme = ShapeTheme.of(context);
    // final stateTheme = StateTheme.of(context);
    // final typescaleTheme = TypescaleTheme.of(context);

    return Surface(
      clipBehavior: .antiAlias,
      shape: shapeTheme.applyCorner(corner: shapeTheme.cornerLarge),
      color: colorTheme.surfaceContainer,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => NoteView(note: _note)),
        ),
        onLongPress: () => _showBottomSheet(context),
        onSecondaryTap: () => _showBottomSheet(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Flex.vertical(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flex.horizontal(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible.tight(
                    child: Text(
                      _note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    formatter.format(_note.updatedAt),
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _note.content
                    .toPlainText()
                    .trim()
                    .split("\n")
                    .reduce(
                      (value, element) =>
                          value.length > element.length ? value : element,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
