import 'dart:async';

import 'package:intl/intl.dart';
import 'package:notes/constants/constants.dart';
import 'package:notes/database/database.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/services/notifications.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:notes/flutter.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key, this.todo});

  final Todo? todo;

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  late Todo _todo;
  AppDatabase? _database;

  late String _savedLabel;
  late String _savedDetails;
  late bool _savedImportant;
  late bool _savedCompleted;
  late DateTime _savedDate;

  bool _isSaving = false;
  bool _hasPendingSave = false;
  bool _disposed = false;

  late FocusNode _labelNode;
  late FocusNode _detailsNode;

  late TextEditingController _labelController;
  late TextEditingController _detailsController;

  final _now = DateTime.now().copyWith(second: 0);

  @override
  void initState() {
    super.initState();

    _todo =
        widget.todo ??
        Todo(
          id: 0,
          label: "",
          details: "",
          important: false,
          completed: false,
          date: _now,
        );

    _savedLabel = _todo.label;
    _savedDetails = _todo.details;
    _savedImportant = _todo.important;
    _savedCompleted = _todo.completed;
    _savedDate = _todo.date;

    _labelNode = FocusNode();
    _detailsNode = FocusNode();
    _labelController = TextEditingController(text: _todo.label)
      ..addListener(_titleListener);
    _detailsController = TextEditingController(text: _todo.details)
      ..addListener(_contentListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _database ??= AppDatabase.of(context);
  }

  @override
  void dispose() {
    _disposed = true;
    _detailsController.removeListener(_contentListener);
    _labelController.removeListener(_titleListener);
    unawaited(_save());

    _detailsController.dispose();
    _labelController.dispose();
    _detailsNode.dispose();
    _labelNode.dispose();
    super.dispose();
  }

  String _format() {
    final formatter = DateFormat.yMMMEd(
      Localizations.localeOf(context).toString(),
    );
    return "${TimeOfDay.fromDateTime(_todo.date).format(context)} / ${formatter.format(_todo.date)}";
  }

  Future<void> _save() async {
    if (_labelController.text.isEmpty) return;
    await _setTodo(
      label: _labelController.text,
      details: _detailsController.text,
    );
  }

  Future<void> _setTodo({
    String? label,
    String? details,
    bool? important,
    bool? completed,
    DateTime? date,
  }) async {
    final nextLabel = label ?? _todo.label;
    final nextDetails = details ?? _todo.details;
    final nextImportant = important ?? _todo.important;
    final nextCompleted = completed ?? _todo.completed;
    final nextDate = date ?? _todo.date;

    _todo = _todo.copyWith(
      label: nextLabel,
      details: nextDetails,
      important: nextImportant,
      completed: nextCompleted,
      date: nextDate,
    );

    if (mounted && !_disposed) {
      setState(() {});
    }

    if (_isSaving) {
      _hasPendingSave = true;
      return;
    }
    _isSaving = true;

    try {
      do {
        _hasPendingSave = false;
        final db = _database;
        if (db == null) return;

        final currentLabel = _todo.label;
        final currentDetails = _todo.details;
        final currentImportant = _todo.important;
        final currentCompleted = _todo.completed;
        final currentDate = _todo.date;

        if (_todo.id == 0) {
          if (currentLabel.isEmpty) return;

          final id = await db
              .into(db.todos)
              .insert(
                TodosCompanion.insert(
                  label: currentLabel,
                  details: .new(currentDetails),
                  important: .new(currentImportant),
                  completed: .new(currentCompleted),
                  date: currentDate,
                ),
              );
          final created = await db.todoById(id).getSingleOrNull();
          if (created != null) {
            _todo = created;
            if (mounted && !_disposed) {
              setState(() {});
            }
            _savedLabel = created.label;
            _savedDetails = created.details;
            _savedImportant = created.important;
            _savedCompleted = created.completed;
            _savedDate = created.date;
          }
          await NotificationService.cancel(_todo.id);
          if (!_todo.completed) {
            await NotificationService.scheduleTodoNotification(_todo);
          }
        } else {
          // Check if anything actually changed
          if (currentLabel == _savedLabel &&
              currentDetails == _savedDetails &&
              currentImportant == _savedImportant &&
              currentCompleted == _savedCompleted &&
              currentDate == _savedDate) {
            continue;
          }

          final companion = TodosCompanion(
            label: .new(currentLabel),
            details: .new(currentDetails),
            important: .new(currentImportant),
            completed: .new(currentCompleted),
            date: .new(currentDate),
          );

          await (db.update(
            db.todos,
          )..where((t) => t.id.equals(_todo.id))).write(companion);

          final updated = await db.todoById(_todo.id).getSingleOrNull();
          if (updated != null) {
            _todo = updated;
            if (mounted && !_disposed) {
              setState(() {});
            }
            _savedLabel = updated.label;
            _savedDetails = updated.details;
            _savedImportant = updated.important;
            _savedCompleted = updated.completed;
            _savedDate = updated.date;
          }
          await NotificationService.cancel(_todo.id);
          if (!_todo.completed) {
            await NotificationService.scheduleTodoNotification(_todo);
          }
        }
      } while (_hasPendingSave);
    } finally {
      _isSaving = false;
    }
  }

  void _titleListener() {
    unawaited(_setTodo(label: _labelController.text));
  }

  void _contentListener() {
    unawaited(_setTodo(details: _detailsController.text));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          unawaited(_save());
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              toolbarHeight: 64,
              expandedHeight: 112,
              leadingWidth: 64,
              leading: IconButton(
                onPressed: () async {
                  await _save();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                icon: const AppIcon(.arrowBack),
              ),
              title: Builder(
                builder: (context) => TextField(
                  controller: _labelController,
                  focusNode: _labelNode,
                  onTapOutside: (event) => _labelNode.unfocus(),
                  style: DefaultTextStyle.of(context).style,
                  decoration: InputDecoration.collapsed(
                    hintText: localizations.todo_view_label_hint,
                  ),
                ),
              ),
              // actions: [
              //   const SizedBox(width: 16),
              //   FilledButton(
              //     onPressed: () {},
              //     child: Icon(MaterialSymbols.save_rounded),
              //   ),
              //   const SizedBox(width: 16),
              // ],
              // actions: [
              //   IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       MaterialSymbols.share_rounded,
              //       fill: 1,
              //     ),
              //     tooltip: "Поделиться",
              //   ),
              //   const SizedBox(width: 8),
              //   Tooltip(
              //     message: "Сохранить",
              //     child: FilledButton(
              //       onPressed: _save,
              //       child: const Icon(MaterialSymbols.save_rounded),
              //     ),
              //   ),
              //   const SizedBox(width: 16),
              // ],
            ),
            SliverList.list(
              children: [
                TextField(
                  controller: _detailsController,
                  focusNode: _detailsNode,
                  onTapOutside: (event) => _detailsNode.unfocus(),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                    labelText: localizations.todo_view_details_hint,
                  ),
                ),
                const Divider(),
                SectionHeader(localizations.todo_view_options),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Card.outlined(
                    child: Flex.vertical(
                      children: [
                        ListTile(
                          onTap: () => _setTodo(completed: !_todo.completed),
                          leading: const Icon(MaterialSymbols.task_alt_rounded),
                          trailing: Checkbox.bistate(
                            onCheckedChanged: (value) =>
                                _setTodo(completed: value),
                            checked: _todo.completed,
                          ),
                          title: Text(localizations.todo_view_completed),
                        ),
                        ListTile(
                          onTap: () => _setTodo(important: !_todo.important),
                          leading: const Icon(
                            MaterialSymbols.priority_high_rounded,
                          ),
                          title: Text(localizations.todo_view_important),
                          trailing: Switch(
                            onCheckedChanged: (value) =>
                                _setTodo(important: value),
                            checked: _todo.important,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Flex.vertical(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flex.horizontal(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8, right: 16),
                                child: Icon(
                                  MaterialSymbols.notifications_active_rounded,
                                  size: 32,
                                ),
                              ),
                              Flexible.tight(
                                child: Flex.vertical(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      localizations.todo_view_reminder,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _format(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Flex.horizontal(
                            children: [
                              Flexible.tight(
                                child: FilledButton.icon(
                                  onPressed: () async {
                                    final result = await showDatePicker(
                                      context: context,
                                      initialDate: _todo.date,
                                      firstDate: _now,
                                      lastDate: kMaxDate,
                                    );
                                    if (result != null && context.mounted) {
                                      await _setTodo(
                                        date: _todo.date.copyWith(
                                          year: result.year,
                                          month: result.month,
                                          day: result.day,
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    MaterialSymbols.date_range_rounded,
                                  ),
                                  label: Text(
                                    localizations.todo_view_reminder_date,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible.tight(
                                child: FilledButton.tonalIcon(
                                  onPressed: () async {
                                    final result = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                        _todo.date,
                                      ),
                                    );
                                    if (result != null && context.mounted) {
                                      await _setTodo(
                                        date: _todo.date.copyWith(
                                          hour: result.hour,
                                          minute: result.minute,
                                        ),
                                      );
                                    }
                                  },
                                  icon: const AppIcon(.schedule),
                                  label: Text(
                                    localizations.todo_view_reminder_time,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
