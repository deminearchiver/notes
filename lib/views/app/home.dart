import 'dart:async';

import 'package:async/async.dart';
import 'package:drift/drift.dart';
import 'package:notes/database/database.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/views/app/notes.dart';
import 'package:notes/views/app/todos.dart';
import 'package:notes/widgets/scroll_to_top.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:notes/flutter.dart';

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
    BuildContext context,
    void Function(String value) onQueryChanged,
  )?
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
    unawaited(_refresh());
  }

  @override
  void dispose() {
    _todosCompleter = null;
    _notesCompleter = null;

    unawaited(_todosSubscription?.cancel());
    unawaited(_notesSubscription?.cancel());

    unawaited(_todosController.close());
    unawaited(_notesController.close());
    super.dispose();
  }

  Future<void> _refresh() async {
    final database = AppDatabase.of(context, listen: false);

    final Stream<List<Note>> notes;
    final Stream<List<Todo>> todos;

    final trimmed = _query.trim();
    if (trimmed.isEmpty) {
      notes =
          (database.select(database.notes)..orderBy([
                (t) => OrderingTerm(
                  expression: t.updatedAt,
                  mode: OrderingMode.desc,
                ),
              ]))
              .watch();
      todos =
          (database.select(database.todos)..orderBy([
                (t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc),
              ]))
              .watch();
    } else {
      notes = database
          .searchNotes(
            trimmed,
            orderBy: (n, fts) => OrderBy([
              OrderingTerm(expression: n.updatedAt, mode: OrderingMode.desc),
            ]),
          )
          .watch();

      todos = database
          .searchTodos(
            trimmed,
            orderBy: (t, fts) => OrderBy([
              OrderingTerm(expression: t.date, mode: OrderingMode.asc),
            ]),
          )
          .watch();
    }

    unawaited(_notesSubscription?.cancel());
    unawaited(_todosSubscription?.cancel());

    _todosCompleter = Completer<void>();
    _notesCompleter = Completer<void>();

    _notesSubscription = notes.listen(
      (event) {
        if (!_notesController.isClosed) _notesController.add(event);
        if (_notesCompleter?.isCompleted ?? false) return;
        _notesCompleter?.complete();
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!_notesController.isClosed) {
          _notesController.addError(error, stackTrace);
        }
        if (_notesCompleter?.isCompleted ?? false) return;
        _notesCompleter?.complete();
      },
    );
    _todosSubscription = todos.listen(
      (event) {
        if (!_todosController.isClosed) _todosController.add(event);
        if (_todosCompleter?.isCompleted ?? false) return;
        _todosCompleter?.complete();
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!_todosController.isClosed) {
          _todosController.addError(error, stackTrace);
        }
        if (_todosCompleter?.isCompleted ?? false) return;
        _todosCompleter?.complete();
      },
    );

    final group = FutureGroup<void>();
    if (_notesCompleter != null) group.add(_notesCompleter!.future);
    if (_todosCompleter != null) group.add(_todosCompleter!.future);
    group.close();

    await group.future;
  }

  void _setQuery(String value) {
    setState(() => _query = value);
    unawaited(_refresh());
  }

  Widget _buildLoadingIndicator() {
    return const SliverFillRemaining(
      child: Align.center(child: CircularProgressIndicator(value: null)),
    );
  }

  Widget _buildPadding(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1.0),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return ScrollToTop(
      controller: widget.scrollController,
      top: 96,
      minOffset: kToolbarHeight + 28,
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
                      return SliverToBoxAdapter(
                        child: Align.center(
                          child: Text(
                            localizations.search_no_results,
                            style: Theme.of(context).textTheme.bodyLarge,
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
                            localizations.app_home_view_overdue(
                              overdueTodos.length,
                            ),
                            icon: const Icon(
                              MaterialSymbols.priority_high_rounded,
                            ),
                          ),
                        ...overdueTodos.map(
                          (todo) => _buildPadding(
                            TodoCard(key: ValueKey(todo.id), todo: todo),
                          ),
                        ),
                        if (recentNotes.isNotEmpty)
                          SectionHeader(
                            localizations.app_home_view_recent(
                              recentNotes.length,
                            ),
                            icon: const Icon(MaterialSymbols.update_rounded),
                          ),
                        ...recentNotes.map(
                          (note) => _buildPadding(
                            NoteCard(key: ValueKey(note.id), note: note),
                          ),
                        ),
                        if (otherTodos.isNotEmpty)
                          SectionHeader(
                            localizations.app_home_view_todos(
                              otherTodos.length,
                            ),
                            icon: const Icon(
                              MaterialSymbols.radio_button_unchecked_rounded,
                            ),
                          ),
                        ...otherTodos.map(
                          (todo) => _buildPadding(
                            TodoCard(key: ValueKey(todo.id), todo: todo),
                          ),
                        ),
                        if (otherNotes.isNotEmpty)
                          SectionHeader(
                            localizations.app_home_view_notes(
                              otherNotes.length,
                            ),
                            icon: const Icon(MaterialSymbols.notes_rounded),
                          ),
                        ...otherNotes.map(
                          (note) => _buildPadding(
                            NoteCard(key: ValueKey(note.id), note: note),
                          ),
                        ),
                        if (completedTodos.isNotEmpty)
                          SectionHeader(
                            localizations.app_home_view_completed(
                              completedTodos.length,
                            ),
                            icon: const Icon(MaterialSymbols.task_alt_rounded),
                          ),
                        ...completedTodos.map(
                          (todo) => _buildPadding(
                            TodoCard(key: ValueKey(todo.id), todo: todo),
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
    );
  }
}
