import 'dart:async';

import 'package:async/async.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/database/database.dart';
import 'package:notes/database/models/note.dart';
import 'package:notes/database/models/todo.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/views/app/notes.dart';
import 'package:notes/views/app/todos.dart';
import 'package:notes/widgets/nothing_found.dart';
import 'package:notes/widgets/scroll_to_top.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:material/material.dart';

class AppViewHomePage extends StatefulWidget {
  const AppViewHomePage({
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
  State<AppViewHomePage> createState() => _AppViewHomePageState();
}

class _AppViewHomePageState extends State<AppViewHomePage> {
  final _notesController = StreamController<List<Note>>();
  final _todosController = StreamController<List<Todo>>();

  StreamSubscription<List<Note>>? _notesSubscription;
  StreamSubscription<List<Todo>>? _todosSubscription;

  Completer<void>? _notesCompleter;
  Completer<void>? _todosCompleter;

  String _query = "";

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _todosCompleter = null;
    _notesCompleter = null;

    _todosSubscription?.cancel();
    _notesSubscription?.cancel();

    _todosController.close();
    _notesController.close();
    super.dispose();
  }

  Future<void> _reload() async {}

  Future<void> _refresh() async {
    final notes = Database.watchSearchNotes(_query);
    final todos = Database.watchSearchTodos(_query);

    _notesSubscription?.cancel();
    _todosSubscription?.cancel();

    _todosCompleter = Completer<void>();
    _notesCompleter = Completer<void>();

    _notesSubscription = notes.listen((event) {
      if (!_notesController.isClosed) _notesController.add(event);
      if (_notesCompleter?.isCompleted ?? false) return;
      _notesCompleter?.complete();
    });
    _todosSubscription = todos.listen((event) {
      if (!_todosController.isClosed) _todosController.add(event);
      if (_todosCompleter?.isCompleted ?? false) return;
      _todosCompleter?.complete();
    });

    final group = FutureGroup<void>();
    if (_notesCompleter != null) group.add(_notesCompleter!.future);
    if (_todosCompleter != null) group.add(_todosCompleter!.future);
    group.close();

    await group.future;
  }

  void _setQuery(String value) {
    setState(() => _query = value);
    _refresh();
  }

  Widget _buildLoadingIndicator() {
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPadding(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ScrollToTop(
        controller: widget.scrollController,
        top: 72,
        minOffset: 72 + 28,
        child: CustomScrollView(
          key: widget.scrollableKey,
          controller: widget.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (widget.headerBuilder != null)
              widget.headerBuilder!(context, _setQuery),
            widget.contentBuilder(
              context,
              StreamBuilder(
                stream: _notesController.stream,
                builder: (context, notesSnapshot) {
                  return StreamBuilder(
                    stream: _todosController.stream,
                    builder: (context, todosSnapshot) {
                      if (!notesSnapshot.hasData || !todosSnapshot.hasData) {
                        return _buildLoadingIndicator();
                      }
                      final notes = notesSnapshot.data!;
                      final todos = todosSnapshot.data!;

                      if (notes.isEmpty && todos.isEmpty) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: NothingFound(
                              icon: Icon(Symbols.receipt_long_rounded),
                            ),
                          ),
                        );
                      }

                      final now = DateTime.now();

                      final recentNotes = <Note>[];
                      final otherNotes = <Note>[];
                      for (final note in notes) {
                        if (note.updatedAt.isAfter(
                          now.subtract(const Duration(days: 7)),
                        )) {
                          recentNotes.add(note);
                        } else {
                          otherNotes.add(note);
                        }
                      }

                      final overdueTodos = <Todo>[];
                      final completedTodos = <Todo>[];
                      final otherTodos = <Todo>[];
                      for (final todo in todos) {
                        if (todo.date.isBefore(now) && !todo.completed) {
                          overdueTodos.add(todo);
                        } else if (todo.completed) {
                          completedTodos.add(todo);
                        } else {
                          otherTodos.add(todo);
                        }
                      }
                      return SliverList.list(
                        children: [
                          if (overdueTodos.isNotEmpty)
                            SectionHeader(
                              localizations
                                  .app_home_view_overdue(overdueTodos.length),
                              icon: const Icon(Symbols.priority_high_rounded),
                            ),
                          ...overdueTodos.map(
                            (todo) => _buildPadding(
                              TodoCard(
                                key: ValueKey(todo.id),
                                todo: todo,
                              ),
                            ),
                          ),
                          if (recentNotes.isNotEmpty)
                            SectionHeader(
                              localizations
                                  .app_home_view_recent(recentNotes.length),
                              icon: const Icon(Symbols.update_rounded),
                            ),
                          ...recentNotes.map(
                            (note) => _buildPadding(
                              NoteCard(
                                key: ValueKey(note.id),
                                note: note,
                              ),
                            ),
                          ),
                          if (otherTodos.isNotEmpty)
                            SectionHeader(
                              localizations
                                  .app_home_view_todos(otherTodos.length),
                              icon: const Icon(
                                  Symbols.radio_button_unchecked_rounded),
                            ),
                          ...otherTodos.map(
                            (todo) => _buildPadding(
                              TodoCard(
                                key: ValueKey(todo.id),
                                todo: todo,
                              ),
                            ),
                          ),
                          if (otherNotes.isNotEmpty)
                            SectionHeader(
                              localizations
                                  .app_home_view_notes(otherNotes.length),
                              icon: const Icon(Symbols.notes_rounded),
                            ),
                          ...otherNotes.map(
                            (note) => _buildPadding(
                              NoteCard(
                                key: ValueKey(note.id),
                                note: note,
                              ),
                            ),
                          ),
                          if (completedTodos.isNotEmpty)
                            SectionHeader(
                              localizations.app_home_view_completed(
                                  completedTodos.length),
                              icon: const Icon(Symbols.task_alt_rounded),
                            ),
                          ...completedTodos.map(
                            (todo) => _buildPadding(
                              TodoCard(
                                key: ValueKey(todo.id),
                                todo: todo,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
