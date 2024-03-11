import 'dart:async';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/database/database.dart';
import 'package:notes/database/todo.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/views/app/card.dart';
import 'package:notes/views/todo/todo.dart';
import 'package:notes/widgets/safe_area.dart';
import 'package:notes/widgets/scroll_to_top.dart';
import 'package:notes/widgets/sort.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:material/material.dart';

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
          BuildContext context, void Function(String value) onQueryChanged)?
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

    _reload();
  }

  @override
  void dispose() {
    _refreshCompleter = null;
    _todosSubscription?.cancel();
    _todos.close();
    super.dispose();
  }

  Future<void> _reload() async {
    final todos = Database.watchSearchTodos(
      _query,
      sort: _sortBy,
      order: _sortOrder,
    );

    _todosSubscription?.cancel();
    _refreshCompleter = Completer();
    _todosSubscription = todos.listen(
      (event) {
        _todos.add(event);
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

  void _setSort(SortDetails<TodosSortBy> value) {
    setState(() {
      _sortBy = value.sort;
      _sortOrder = value.order;
    });
    _reload();
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
                  icon: const Icon(Symbols.sort_by_alpha_rounded),
                  label: localizations.app_todos_view_sort_label,
                ),
                SortType(
                  value: TodosSortBy.date,
                  icon: const Icon(Symbols.schedule_rounded),
                  label: localizations.app_todos_view_sort_date,
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          StreamBuilder(
            stream: _todos.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final todos = snapshot.data!;
              return todos.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          localizations.search_no_results,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )
                  : SliverList.separated(
                      itemCount: todos.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
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
    return RefreshIndicator(
      onRefresh: _reload,
      child: ScrollToTop(
        controller: widget.scrollController,
        top: 96,
        minOffset: 120,
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
              _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoCard extends StatefulWidget {
  const TodoCard({
    super.key,
    required this.todo,
  });
  final Todo todo;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late Todo _todo;

  final _cardKey = GlobalKey<ViewCardState>();

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

  Future<void> _setTodo({
    bool? completed,
    bool? important,
  }) async {
    if (completed != null) _todo.completed = completed;
    if (important != null) _todo.important = important;
    await Database.addTodo(_todo);
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
        Database.deleteTodo(_todo.id);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleTextStyle = theme.textTheme.titleMedium;
    final subtitleTextStyle = _todo.completed
        ? theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor)
        : theme.textTheme.bodySmall;
    final iconColor = subtitleTextStyle?.color;

    final dateFormat =
        DateFormat.yMMMEd(Localizations.localeOf(context).toLanguageTag());
    final timeFormat =
        DateFormat.Hm(Localizations.localeOf(context).toLanguageTag());

    return ViewCard(
      key: _cardKey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _todo.completed
              ? theme.colorScheme.outline.withOpacity(0.12)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: () => _cardKey.currentState?.openView(
          (context) => TodoView(
            todo: _todo,
          ),
        ),
        // onTap: () => Navigator.push(
        //   context,
        //   MaterialRoute.zoom(
        //     child: TodoView(
        //       todo: _todo,
        //     ),
        //   ),
        // ),
        onLongPress: () => _showBottomSheet(context),
        onSecondaryTap: () => _showBottomSheet(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Row(
            children: [
              Checkbox(
                onChanged: (value) => _setTodo(completed: value),
                value: _todo.completed,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _todo.label,
                    style: _todo.completed
                        ? titleTextStyle?.copyWith(
                            color: theme.disabledColor,
                          )
                        : titleTextStyle,
                  ),
                  Text.rich(
                    TextSpan(children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Symbols.calendar_month_rounded,
                          opticalSize: 20,
                          size: 16,
                          color: iconColor,
                        ),
                      ),
                      TextSpan(
                        text: " ${dateFormat.format(_todo.date)} ",
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Symbols.schedule_rounded,
                          opticalSize: 20,
                          size: 16,
                          color: iconColor,
                        ),
                      ),
                      TextSpan(
                        text: " ${timeFormat.format(_todo.date)}",
                      ),
                    ]),
                    style: subtitleTextStyle,
                  )
                ],
              ),
              const Spacer(),
              if (_todo.important) ...[
                const SizedBox(width: 8),
                Icon(
                  Symbols.priority_high_rounded,
                  color: _todo.completed ? theme.disabledColor : Colors.red,
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
//       curve: Easing.emphasized,
//       reverseCurve: Easing.emphasized.flipped,
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
//       child: Row(
//         children: [
//           Checkbox(
//             onChanged: (value) {},
//             value: todo.completed,
//           ),
//           const SizedBox(width: 8),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 todo.label,
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
//                       Symbols.calendar_month_rounded,
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
//                       Symbols.schedule_rounded,
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
//           const Spacer(),
//           if (todo.important) ...[
//             const SizedBox(width: 8),
//             Icon(
//               Symbols.priority_high_rounded,
//               color: todo.completed ? theme.disabledColor : Colors.red,
//             ),
//           ],
//         ],
//       ),
//     );
//     final Widget childView = TodoView(
//       todo: todo,
//     );
//     // CONTENT

//     final borderColor = todo.completed
//         ? theme.colorScheme.outlineVariant
//         : theme.colorScheme.outline;
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
