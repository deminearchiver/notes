import 'dart:async';

import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/database/database.dart';
import 'package:notes/database/models/note.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/views/app/card.dart';
import 'package:notes/views/note/note.dart';
import 'package:notes/widgets/nothing_found.dart';
import 'package:notes/widgets/scroll_to_top.dart';
import 'package:notes/widgets/sort.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:material/material.dart';

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
          BuildContext context, void Function(String value) onQueryChanged)?
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

    _reload();
  }

  @override
  void dispose() {
    _refreshCompleter = null;
    _notesSubscription?.cancel();
    _notes.close();
    super.dispose();
  }

  Future<void> _reload() async {
    final notes = Database.watchSearchNotes(
      _query,
      sort: _sortBy,
      order: _sortOrder,
    );
    _refreshCompleter = Completer();

    _notesSubscription?.cancel();
    _notesSubscription = notes.listen(
      (event) {
        _notes.add(event);
        if (_refreshCompleter?.isCompleted ?? false) return;
        _refreshCompleter?.complete();
      },
    );

    return _refreshCompleter?.future;
  }

  void _setQuery(String value) {
    setState(() => _query = value);
    _reload();
  }

  void _setSort(SortDetails<NotesSortBy> value) {
    setState(() {
      _sortBy = value.sort;
      _sortOrder = value.order;
    });
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: _reload,
      child: ScrollToTop(
        controller: widget.scrollController,
        top: 72 + 16 + 32 + 8,
        minOffset: 160,
        child: CustomScrollView(
          key: widget.scrollableKey,
          controller: widget.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (widget.headerBuilder != null)
              widget.headerBuilder!(
                context,
                _setQuery,
              ),
            widget.contentBuilder(
              context,
              MultiSliver(
                children: [
                  SliverPinnedHeader(
                    child: Material(
                      child: SortRow(
                        onSortChanged: _setSort,
                        selected: _sortBy,
                        order: _sortOrder,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        types: [
                          SortType(
                            value: NotesSortBy.title,
                            icon: const Icon(Symbols.sort_by_alpha_rounded),
                            label: localizations.app_notes_view_sort_title,
                          ),
                          SortType(
                            value: NotesSortBy.createdAt,
                            icon: const Icon(Symbols.schedule_rounded),
                            label: localizations.app_notes_view_sort_created,
                          ),
                          SortType(
                            value: NotesSortBy.updatedAt,
                            icon: const Icon(Symbols.history_rounded),
                            label: localizations.app_notes_view_sort_modified,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: StreamBuilder(
                      stream: _notes.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final notes = snapshot.data!;
                        return notes.isEmpty
                            ? const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: NothingFound(
                                    icon: Icon(Symbols.find_in_page_rounded),
                                  ),
                                ),
                              )
                            : SliverList.separated(
                                itemCount: notes.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) => NoteCard(
                                  key: ValueKey(notes[index].id),
                                  note: notes[index],
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteCard extends StatefulWidget {
  const NoteCard({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late Note _note;

  final _cardKey = GlobalKey<ViewCardState>();

  @override
  void initState() {
    super.initState();
    _note = widget.note;
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
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () => Navigator.pop(context, "share"),
            leading: const Icon(
              Symbols.share_rounded,
              fill: 1,
            ),
            title: Text(localizations.share),
          ),
          ListTile(
            onTap: () => Navigator.pop(context, "delete"),
            leading: const Icon(Symbols.delete_rounded),
            title: Text(localizations.delete),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
    switch (result) {
      case "delete":
        await Database.deleteNote(_note.id);
      case "share":
        await Share.share(
          "${_note.title}\n"
          "${_note.contentText}",
          subject: _note.title,
        );
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final formatter = DateFormat.yMMMEd(localizations.localeName);
    return ViewCard(
      key: _cardKey,
      child: InkWell(
        onTap: () {
          _cardKey.currentState?.openView(
            (context) => NoteView(
              note: _note,
            ),
          );
        },
        onLongPress: () => _showBottomSheet(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    formatter.format(
                      _note.updatedAt,
                    ),
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _note.contentText.trim().split("\n").reduce((value, element) =>
                    value.length > element.length ? value : element),
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
