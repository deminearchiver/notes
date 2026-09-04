import 'dart:async';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:notes/database/database.dart';
import 'package:notes/services/notifications.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/views/todo/todo.dart';
import 'package:notes/widgets/scroll_to_top.dart';
import 'package:notes/widgets/sort.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:notes/flutter.dart';

enum TodosSortBy { label, date }

class AppViewTodosPage extends StatefulWidget {
  const AppViewTodosPage({
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
  State<AppViewTodosPage> createState() => _AppViewTodosPageState();
}

class _AppViewTodosPageState extends State<AppViewTodosPage> {
  final _todos = StreamController<List<Todo>>();
  StreamSubscription<List<Todo>>? _todosSubscription;
  Completer<void>? _refreshCompleter;

  String _query = "";
  TodosSortBy _sortBy = TodosSortBy.date;
  Sort _sortOrder = Sort.asc;

  @override
  void initState() {
    super.initState();

    unawaited(_reload());
  }

  @override
  void dispose() {
    _refreshCompleter = null;
    unawaited(_todosSubscription?.cancel());
    unawaited(_todos.close());
    super.dispose();
  }

  Future<void> _reload() async {
    final database = AppDatabase.of(context, listen: false);

    Expression<Object> orderColumn(Todos t) => switch (_sortBy) {
      TodosSortBy.label => t.label,
      TodosSortBy.date => t.date,
    };

    final mode = _sortOrder == Sort.asc ? OrderingMode.asc : OrderingMode.desc;

    final trimmed = _query.trim();
    final Stream<List<Todo>> todosStream;
    if (trimmed.isEmpty) {
      todosStream =
          (database.select(database.todos)..orderBy([
                (t) => OrderingTerm(expression: orderColumn(t), mode: mode),
              ]))
              .watch();
    } else {
      todosStream = database
          .searchTodos(
            trimmed,
            orderBy: (todosTable, todosFts) => OrderBy([
              OrderingTerm(expression: orderColumn(todosTable), mode: mode),
            ]),
          )
          .watch();
    }

    unawaited(_todosSubscription?.cancel());
    _refreshCompleter = Completer();
    _todosSubscription = todosStream.listen(
      (event) {
        _todos.add(event);
        if (_refreshCompleter?.isCompleted ?? false) return;
        _refreshCompleter?.complete();
      },
      onError: (Object error, StackTrace stackTrace) {
        _todos.addError(error, stackTrace);
        if (_refreshCompleter?.isCompleted ?? false) return;
        _refreshCompleter?.complete();
      },
    );

    return _refreshCompleter?.future;
  }

  void _setQuery(String value) {
    setState(() => _query = value);
    unawaited(_reload());
  }

  void _setSort(SortDetails<TodosSortBy> value) {
    setState(() {
      _sortBy = value.sort;
      _sortOrder = value.order;
    });
    unawaited(_reload());
  }

  Widget _buildContent(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return SliverPadding(
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
                  value: TodosSortBy.label,
                  icon: const Icon(MaterialSymbols.sort_by_alpha_rounded),
                  label: localizations.app_todos_view_sort_label,
                ),
                SortType(
                  value: TodosSortBy.date,
                  icon: const AppIcon(.schedule),
                  label: localizations.app_todos_view_sort_date,
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          StreamBuilder(
            stream: _todos.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SliverFillRemaining(
                  child: Align.center(
                    child: CircularProgressIndicator(value: null),
                  ),
                );
              }
              final todos = snapshot.data!;
              return todos.isEmpty
                  ? SliverToBoxAdapter(
                      child: Align.center(
                        child: Text(
                          localizations.search_no_results,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )
                  : SliverList.separated(
                      itemCount: todos.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 2.0),
                      itemBuilder: (context, index) => TodoCard(
                        key: ValueKey(todos[index].id),
                        todo: todos[index],
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          widget.contentBuilder(context, _buildContent(context)),
        ],
      ),
    );
  }
}

class TodoCard extends StatefulWidget {
  const TodoCard({super.key, required this.todo});
  final Todo todo;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late Todo _todo;

  @override
  void initState() {
    super.initState();
    _todo = widget.todo;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TodoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_todo != widget.todo) {
      _todo = widget.todo;
    }
  }

  Future<void> _setTodo({bool? completed, bool? important}) async {
    final database = AppDatabase.of(context, listen: false);

    final companion = TodosCompanion(
      completed: completed != null ? .new(completed) : const .absent(),
      important: important != null ? .new(important) : const .absent(),
    );

    await (database.update(
      database.todos,
    )..where((t) => t.id.equals(_todo.id))).write(companion);

    await NotificationService.cancel(_todo.id);
    final currentCompleted = completed ?? _todo.completed;
    if (!currentCompleted) {
      final updatedTodo = await database.todoById(_todo.id).getSingleOrNull();
      if (updatedTodo != null) {
        await NotificationService.scheduleTodoNotification(updatedTodo);
      }
    }
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
        await NotificationService.cancel(_todo.id);
        await (database.delete(
          database.todos,
        )..where((t) => t.id.equals(_todo.id))).go();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = ColorTheme.of(context);
    // final elevationTheme = ElevationTheme.of(context);
    final shapeTheme = ShapeTheme.of(context);
    // final stateTheme = StateTheme.of(context);
    final typescaleTheme = TypescaleTheme.of(context);

    final titleTextStyle = typescaleTheme.titleMedium.toTextStyle(
      color: _todo.completed
          ? colorTheme.onSurface.withValues(alpha: 0.38)
          : colorTheme.onSurface,
    );
    final subtitleTextStyle = typescaleTheme.bodySmall.toTextStyle(
      color: _todo.completed
          ? colorTheme.onSurface.withValues(alpha: 0.38)
          : colorTheme.onSurface,
    );

    final iconColor = subtitleTextStyle.color;

    final dateFormat = DateFormat.yMMMEd(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final timeFormat = DateFormat.Hm(
      Localizations.localeOf(context).toLanguageTag(),
    );

    return Surface(
      clipBehavior: .antiAlias,
      shape: shapeTheme.applyCorner(corner: shapeTheme.cornerLarge),
      color: _todo.completed
          ? colorTheme.onSurface.withValues(alpha: 0.1)
          : colorTheme.surfaceContainer,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => TodoView(todo: _todo)),
        ),
        onLongPress: () => _showBottomSheet(context),
        onSecondaryTap: () => _showBottomSheet(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
          child: Flex.horizontal(
            children: [
              Stack(
                alignment: .center,
                children: [
                  SizedBox.square(
                    dimension: 40.0,
                    child: Surface(
                      clipBehavior: .antiAlias,
                      shape: shapeTheme.applyCorner(
                        corner: shapeTheme.cornerFull,
                      ),
                      color: colorTheme.surfaceContainer,
                    ),
                  ),
                  Checkbox.bistate(
                    onCheckedChanged: (value) => _setTodo(completed: value),
                    checked: _todo.completed,
                  ),
                ],
              ),

              const SizedBox(width: 12.0),
              Flex.vertical(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_todo.label, style: titleTextStyle),
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            MaterialSymbols.calendar_month_rounded,
                            opticalSize: 20,
                            size: 16,
                            color: iconColor,
                          ),
                        ),
                        TextSpan(text: " ${dateFormat.format(_todo.date)} "),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: AppIcon(
                            .schedule,
                            opticalSize: 20,
                            size: 16,
                            color: iconColor,
                          ),
                        ),
                        TextSpan(text: " ${timeFormat.format(_todo.date)}"),
                      ],
                    ),
                    style: subtitleTextStyle,
                  ),
                ],
              ),
              const Flexible.space(),
              if (_todo.important) ...[
                const SizedBox(width: 8),
                Icon(
                  MaterialSymbols.priority_high_rounded,
                  color: _todo.completed
                      ? colorTheme.onSurface.withValues(alpha: 0.38)
                      : Colors.red,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// class _TodoRoute<T> extends PageRoute<T> {
//   _TodoRoute({
//     required this.cardKey,
//     required this.todo,
//   });

//   final GlobalKey cardKey;
//   final Todo todo;

//   @override
//   Color? get barrierColor => null;

//   @override
//   // TODO: implement barrierLabel
//   String? get barrierLabel => null;

//   @override
//   bool get maintainState => true;

//   @override
//   Duration get transitionDuration => Durations.long4;
//   // Duration get transitionDuration => Duration(seconds: 3);

//   @override
//   Duration get reverseTransitionDuration => Durations.medium4;

//   @override
//   Widget buildPage(BuildContext context, Animation<double> linearAnimation,
//       Animation<double> secondaryAnimation) {
//     final animation = CurvedAnimation(
//       parent: linearAnimation,
//       curve: Curves.easeInOutCubicEmphasized,
//       reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
//     );

//     final navigatorObject = Navigator.of(cardKey.currentContext!)
//         .context
//         .findRenderObject()! as RenderBox;
//     final cardObject = cardKey.currentContext!.findRenderObject()! as RenderBox;

//     final cardRect = Rect.fromPoints(
//       cardObject.localToGlobal(
//         Offset.zero,
//         ancestor: navigatorObject,
//       ),
//       cardObject.localToGlobal(
//         cardObject.size.bottomRight(Offset.zero),
//         ancestor: navigatorObject,
//       ),
//     );
//     // final navigatorRect = Rect.fromPoints(
//     //   navigatorObject.localToGlobal(Offset.zero),
//     //   navigatorObject.localToGlobal(
//     //     navigatorObject.size.bottomRight(Offset.zero),
//     //   ),
//     // );
//     final navigatorRect = Rect.fromPoints(
//       Offset.zero,
//       MediaQuery.of(context).size.bottomRight(Offset.zero),
//     );

//     final theme = Theme.of(context);

//     final rectTween = RectTween(
//       begin: cardRect,
//       end: navigatorRect,
//     );

//     final borderRadiusTween = BorderRadiusTween(
//       begin: BorderRadius.circular(12),
//       end: BorderRadius.zero,
//     );
//     final borderWidthTween = Tween<double>(begin: 1, end: 0);

//     final exit = CurveTween(
//       curve: const Interval(0, 0.5),
//     );

//     final enter = CurveTween(
//       curve: const Interval(0.5, 1),
//     );

//     final opacitySequence = TweenSequence([
//       TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0), weight: 1),
//       TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 1),
//     ]);

//     // CONTENT

//     final titleTextStyle = theme.textTheme.titleMedium;
//     final subtitleTextStyle = todo.completed
//         ? theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor)
//         : theme.textTheme.bodySmall;
//     final iconColor = subtitleTextStyle?.color;

//     final dateFormat =
//         DateFormat.yMMMEd(Localizations.localeOf(context).toLanguageTag());
//     final timeFormat =
//         DateFormat.Hm(Localizations.localeOf(context).toLanguageTag());

//     final Widget childContent = Padding(
//       padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
//       child: Flex.horizontal(
//         children: [
//           Checkbox(
//             onChanged: (value) {},
//             value: todo.completed,
//           ),
//           const SizedBox(width: 8),
//           Flex.vertical(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 //todo.label,
//                 style: todo.completed
//                     ? titleTextStyle?.copyWith(
//                         color: theme.disabledColor,
//                       )
//                     : titleTextStyle,
//               ),
//               Text.rich(
//                 TextSpan(children: [
//                   WidgetSpan(
//                     alignment: PlaceholderAlignment.middle,
//                     child: Icon(
//                       MaterialSymbols.calendar_month_rounded,
//                       opticalSize: 20,
//                       size: 16,
//                       color: iconColor,
//                     ),
//                   ),
//                   TextSpan(
//                     text: " ${dateFormat.format(todo.date)} ",
//                   ),
//                   WidgetSpan(
//                     alignment: PlaceholderAlignment.middle,
//                     child: Icon(
//                       MaterialSymbols.schedule_rounded,
//                       opticalSize: 20,
//                       size: 16,
//                       color: iconColor,
//                     ),
//                   ),
//                   TextSpan(
//                     text: " ${timeFormat.format(todo.date)}",
//                   ),
//                 ]),
//                 style: subtitleTextStyle,
//               )
//             ],
//           ),
//           const Flexible.space(),
//           if (todo.important) ...[
//             const SizedBox(width: 8),
//             Icon(
//               MaterialSymbols.priority_high_rounded,
//               color: todo.completed ? theme.disabledColor : Colors.red,
//             ),
//           ],
//         ],
//       ),
//     );
//     final Widget childView = TodoView(
//       //todo: todo,
//     );
//     // CONTENT

//     final borderColor = todo.completed
//         ? colorTheme.outlineVariant
//         : colorTheme.outline;
//     final borderColorTween = ColorTween(
//       begin: borderColor,
//       end: borderColor.withOpacity(0),
//     );

//     return AnimatedBuilder(
//       animation: animation,
//       builder: (context, child) {
//         final rect = rectTween.evaluate(animation)!;

//         final safeArea = lerpDouble(0, 1, animation.value)!;

//         final switched = animation.value >= 0.5;

//         return Align(
//           alignment: Alignment.topLeft,
//           child: Transform.translate(
//             offset: rect.topLeft,
//             child: SizedBox(
//               width: rect.width,
//               height: rect.height,
//               child: Card.outlined(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: borderRadiusTween.evaluate(animation)!,
//                   side: BorderSide(
//                     color: borderColorTween.evaluate(animation)!,
//                   ),
//                 ),
//                 child: Opacity(
//                   opacity: opacitySequence.evaluate(animation),
//                   child: animation.value >= 0.5
//                       ? OverflowBox(
//                           maxWidth: navigatorRect.width,
//                           maxHeight: navigatorRect.height,
//                           alignment: Alignment.topLeft,
//                           child: RemoveSafeArea(
//                             left: safeArea,
//                             top: safeArea,
//                             right: safeArea,
//                             bottom: safeArea,
//                             child: Opacity(
//                               opacity: opacitySequence.evaluate(animation),
//                               child: childView,
//                             ),
//                           ),
//                         )
//                       : Align(
//                           alignment: Alignment.topLeft,
//                           child: SizedBox(
//                             width: cardRect.width,
//                             height: cardRect.height,
//                             child: childContent,
//                           ),
//                         ),
//                 ),
//                 // child: OverflowBox(
//                 //   maxWidth: switched ? navigatorRect.width : cardRect.width,
//                 //   maxHeight: switched ? navigatorRect.height : cardRect.height,
//                 //   alignment: Alignment.topLeft,
//                 //   child: RemoveSafeArea(
//                 //     left: safeArea,
//                 //     top: safeArea,
//                 //     right: safeArea,
//                 //     bottom: safeArea,
//                 //     child: Opacity(
//                 //       opacity: opacitySequence.evaluate(animation),
//                 //       child: switched ? childView : childContent,
//                 //     ),
//                 //   ),
//                 // ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
