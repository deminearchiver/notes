import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/constants/constants.dart';
import 'package:notes/database/database.dart';
import 'package:notes/database/todo.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/widgets/section_header.dart';
import 'package:material/material.dart';

class TodoView extends StatefulWidget {
  const TodoView({
    super.key,
    this.todo,
  });

  final Todo? todo;

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  late Todo _todo;

  late FocusNode _labelNode;
  late FocusNode _detailsNode;

  late TextEditingController _labelController;
  late TextEditingController _detailsController;

  final _now = DateTime.now().copyWith(second: 0);

  @override
  void initState() {
    super.initState();

    _todo = widget.todo ??
        Database.createTodo(
          label: "",
          date: _now,
        );

    _labelNode = FocusNode();
    _detailsNode = FocusNode();
    _labelController = TextEditingController(text: _todo.label)
      ..addListener(_titleListener);
    _detailsController = TextEditingController(text: _todo.details)
      ..addListener(_contentListener);
  }

  @override
  void dispose() {
    _save();

    _detailsController.dispose();
    _labelController.dispose();
    _detailsNode.dispose();
    _labelNode.dispose();
    super.dispose();
  }

  String _format() {
    final formatter =
        DateFormat.yMMMEd(Localizations.localeOf(context).toString());
    return "${TimeOfDay.fromDateTime(_todo.date).format(context)} / ${formatter.format(_todo.date)}";
  }

  void _save() {
    if (_todo.label.isEmpty) return;

    Database.addTodo(_todo);
  }

  void _setTodo({
    String? label,
    String? details,
    bool? important,
    bool? completed,
    DateTime? date,
  }) {
    setState(() {
      if (label != null) _todo.label = label;
      if (details != null) _todo.details = details;
      if (important != null) _todo.important = important;
      if (completed != null) _todo.completed = completed;
      if (date != null) _todo.date = date;
    });
    _save();
  }

  void _titleListener() {
    _todo.label = _labelController.text;
  }

  void _contentListener() {
    _todo.details = _detailsController.text;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            toolbarHeight: 64,
            expandedHeight: 112,
            leadingWidth: 64,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Symbols.arrow_back_rounded),
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
            //     child: Icon(Symbols.save_rounded),
            //   ),
            //   const SizedBox(width: 16),
            // ],
            // actions: [
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Icon(
            //       Symbols.share_rounded,
            //       fill: 1,
            //     ),
            //     tooltip: "Поделиться",
            //   ),
            //   const SizedBox(width: 8),
            //   Tooltip(
            //     message: "Сохранить",
            //     child: FilledButton(
            //       onPressed: _save,
            //       child: const Icon(Symbols.save_rounded),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card.outlined(
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () => _setTodo(completed: !_todo.completed),
                        leading: const Icon(Symbols.task_alt_rounded),
                        trailing: Checkbox(
                          onChanged: (value) => _setTodo(completed: value),
                          value: _todo.completed,
                        ),
                        title: Text(localizations.todo_view_completed),
                      ),
                      ListTile(
                        onTap: () => _setTodo(important: !_todo.important),
                        leading: const Icon(Symbols.priority_high_rounded),
                        title: Text(localizations.todo_view_important),
                        trailing: Switch(
                          onChanged: (value) => _setTodo(important: value),
                          value: _todo.important,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8, right: 16),
                              child: Icon(
                                Symbols.notifications_active_rounded,
                                size: 32,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    localizations.todo_view_reminder,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _format(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: () => showDatePicker(
                                  context: context,
                                  initialDate: _todo.date,
                                  firstDate: _now,
                                  lastDate: kMaxDate,
                                ),
                                icon: const Icon(Symbols.date_range_rounded),
                                label:
                                    Text(localizations.todo_view_reminder_date),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: () async {
                                  final result = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        TimeOfDay.fromDateTime(_todo.date),
                                  );
                                  if (result != null && context.mounted) {
                                    _setTodo(
                                      date: _todo.date.copyWith(
                                        hour: result.hour,
                                        minute: result.minute,
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Symbols.schedule_rounded),
                                label:
                                    Text(localizations.todo_view_reminder_time),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
