import 'dart:async';

import 'package:fleather/fleather.dart';
import 'package:notes/database/database.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/theme.dart';
import 'package:notes/utils/utils.dart';
import 'package:notes/widgets/fleather/buttons.dart';
import 'package:notes/flutter.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key, this.note});

  final Note? note;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late bool _new;
  late Note _note;
  AppDatabase? _database;

  late String _savedTitle;
  late String _savedContentText;

  bool _isSaving = false;
  bool _hasPendingSave = false;

  late ScrollController _scrollController;
  late ScrollController _toolbarController;

  late FocusNode _titleNode;
  late FocusNode _contentNode;

  late TextEditingController _titleController;
  late FleatherController _contentController;

  // int _length = 0;

  @override
  void initState() {
    super.initState();
    _new = widget.note == null;
    final now = DateTime.now();
    _note =
        widget.note ??
        Note(
          id: 0,
          title: "",
          content: ParchmentDocument(),
          contentText: "",
          createdAt: now,
          updatedAt: now,
          favorite: false,
        );

    _savedTitle = _note.title;
    _savedContentText = _note.contentText;

    _scrollController = ScrollController();
    _toolbarController = ScrollController();

    _titleNode = FocusNode();
    _contentNode = FocusNode();

    _titleController = TextEditingController(text: _note.title)
      ..addListener(_titleListener);
    _contentController = FleatherController(
      document: ParchmentDocument.fromDelta(_note.content.toDelta()),
    )..addListener(_contentListener);
    // _length = _contentController.document.length;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _database ??= AppDatabase.of(context);
  }

  @override
  void dispose() {
    _contentController.removeListener(_contentListener);
    _titleController.removeListener(_titleListener);
    unawaited(_save());

    _contentController.dispose();
    _titleController.dispose();

    _toolbarController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _titleListener() {
    unawaited(_save());
  }

  void _contentListener() {
    unawaited(_save());
  }

  Future<void> _save() async {
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

        var title = _titleController.text;
        if (title.isEmpty) {
          if (_new) return;
          title = "New note (${_note.id})";
        }
        final content = _contentController.document;
        final contentText = content.toPlainText();

        // Check if title or content text actually changed
        if (!_new && title == _savedTitle && contentText == _savedContentText) {
          continue;
        }

        final now = DateTime.now();

        _note = _note.copyWith(
          title: title,
          content: content,
          contentText: contentText,
          updatedAt: now,
        );

        if (_note.id == 0) {
          final id = await db
              .into(db.notes)
              .insert(
                NotesCompanion.insert(
                  title: _note.title,
                  content: _note.content,
                  contentText: _note.contentText,
                  createdAt: _note.createdAt,
                  updatedAt: _note.updatedAt,
                  favorite: _note.favorite,
                ),
              );
          _new = false;
          _note = _note.copyWith(id: id);
        } else {
          await db.update(db.notes).replace(_note);
        }

        _savedTitle = title;
        _savedContentText = contentText;
      } while (_hasPendingSave);
    } finally {
      _isSaving = false;
    }
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
        bottomNavigationBar: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: Flex.vertical(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BottomAppBar(
                child: Flex.horizontal(
                  children: [
                    Flexible.tight(
                      child: SingleChildScrollView(
                        controller: _toolbarController,
                        scrollDirection: Axis.horizontal,
                        child: Flex.horizontal(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FleatherToggleStyleButton(
                              controller: _contentController,
                              attribute: ParchmentAttribute.bold,
                              icon: MaterialSymbols.format_bold_rounded,
                            ),
                            FleatherToggleStyleButton(
                              controller: _contentController,
                              attribute: ParchmentAttribute.italic,
                              icon: MaterialSymbols.format_italic_rounded,
                            ),
                            FleatherToggleStyleButton(
                              controller: _contentController,
                              attribute: ParchmentAttribute.underline,
                              icon: MaterialSymbols.format_underlined_rounded,
                            ),
                            FleatherClearStyleButton(
                              controller: _contentController,
                            ),
                            const VerticalDivider(),
                            FleatherToggleStyleButton(
                              controller: _contentController,
                              attribute: ParchmentAttribute.ol,
                              icon:
                                  MaterialSymbols.format_list_numbered_rounded,
                            ),
                            FleatherToggleStyleButton(
                              controller: _contentController,
                              attribute: ParchmentAttribute.ul,
                              icon:
                                  MaterialSymbols.format_list_bulleted_rounded,
                            ),
                            FleatherToggleStyleButton(
                              controller: _contentController,
                              attribute: ParchmentAttribute.cl,
                              icon: MaterialSymbols.check_box_rounded,
                            ),
                            const VerticalDivider(),
                            FleatherIndentationButton(
                              controller: _contentController,
                              increase: true,
                            ),
                            FleatherIndentationButton(
                              controller: _contentController,
                              increase: false,
                            ),
                            const VerticalDivider(),
                            FleatherToggleStyleButton(
                              attribute: ParchmentAttribute.h1,
                              icon: MaterialSymbols.format_h1_rounded,
                              controller: _contentController,
                            ),
                            const VerticalDivider(),
                            FleatherToggleStyleButton(
                              controller: _contentController,
                              attribute: ParchmentAttribute.inlineCode,
                              icon: MaterialSymbols.code_rounded,
                            ),
                            FleatherToggleStyleButton(
                              controller: _contentController,
                              attribute: ParchmentAttribute.code,
                              icon: MaterialSymbols.code_blocks_rounded,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar.medium(
              leading: IconButton(
                onPressed: () async {
                  await _save();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(MaterialSymbols.arrow_back_rounded),
              ),
              expandedHeight: 112,
              title: Builder(
                builder: (context) => TextField(
                  controller: _titleController,
                  focusNode: _titleNode,
                  onTapOutside: (event) => _titleNode.unfocus(),
                  style: DefaultTextStyle.of(context).style,
                  decoration: InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText: localizations.note_view_title_hint,
                  ),
                ),
              ),
              actions: [
                FleatherHistoryButton.undo(controller: _contentController),
                FleatherHistoryButton.redo(controller: _contentController),
                // const SizedBox(width: 16),
                // FilledButton(
                //   onPressed: () {},
                //   child: Icon(MaterialSymbols.save_rounded),
                // ),
                const SizedBox(width: 16),
              ],
            ),
            // This actually works (SliverToBoxAdapter + scrollController + scrollable: false)
            SliverToBoxAdapter(
              child: FleatherTheme(
                data: CustomFleatherThemeData.fallback(Theme.of(context)),
                child: FleatherEditor(
                  scrollController: _scrollController,
                  scrollable: false,
                  onLaunchUrl: openUrlString,
                  focusNode: _contentNode,
                  controller: _contentController,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
