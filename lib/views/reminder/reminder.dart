import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:notes/database/database.dart';
import 'package:notes/database/models/todo.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:material/material.dart';

class ReminderView extends StatefulWidget {
  const ReminderView({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  State<ReminderView> createState() => _ReminderViewState();
}

class _ReminderViewState extends State<ReminderView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDismissClicked() {
    _close();
  }

  Future<void> _onDoneClicked() async {
    final todo = widget.todo;
    todo.completed = true;
    Database.addTodo(todo);

    _close();
  }

  void _close() {
    if (!mounted) return;
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                !widget.todo.important
                    ? const Icon(
                        Symbols.notification_important_rounded,
                        color: Colors.red,
                        size: 36,
                      )
                    : const Icon(
                        Symbols.notifications_rounded,
                        size: 36,
                      ),
                const SizedBox(height: 16),
                Text(
                  widget.todo.label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.todo.details,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: _onDismissClicked,
                        icon: const Icon(Symbols.close_rounded),
                        label: Text(localizations.reminder_view_dismiss),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _onDoneClicked,
                        icon: const Icon(Symbols.check_rounded),
                        label: Text(localizations.reminder_view_done),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     IconButton.filled(
                //       onPressed: () {},
                //       iconSize: 36,
                //       icon: const Icon(Symbols.close_rounded),
                //     ),
                //     IconButton.filled(
                //       onPressed: () {},
                //       iconSize: 36,
                //       icon: const Icon(Symbols.done_rounded),
                //     ),
                //   ],
                // ),
                // Card.filled(
                //   color: theme.colorScheme.secondaryContainer,
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(28)),
                //   child: SizedBox(
                //     height: 80,
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Expanded(
                //           child: Well(
                //             onTap: _onDismissClicked,
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Icon(
                //                   Symbols.close_rounded,
                //                   color: theme.colorScheme.onSecondaryContainer,
                //                 ),
                //                 Text(
                //                   localizations.reminder_view_dismiss,
                //                   style: theme.textTheme.bodyMedium?.copyWith(
                //                     color:
                //                         theme.colorScheme.onSecondaryContainer,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //         VerticalDivider(
                //           thickness: 2,
                //           width: 2,
                //           color: theme.colorScheme.surface,
                //         ),
                //         Expanded(
                //           child: Well(
                //             onTap: _onDoneClicked,
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Icon(
                //                   Symbols.check_rounded,
                //                   color: theme.colorScheme.onSecondaryContainer,
                //                 ),
                //                 Text(
                //                   localizations.reminder_view_done,
                //                   style: theme.textTheme.bodyMedium?.copyWith(
                //                     color:
                //                         theme.colorScheme.onSecondaryContainer,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
