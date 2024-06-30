import 'package:fleather/fleather.dart';
import 'package:notes/database/database.dart';
import 'package:notes/database/models/note.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/theme.dart';
import 'package:notes/utils/utils.dart';
import 'package:notes/views/settings/settings.dart';
import 'package:notes/widgets/fleather/buttons.dart';
import 'package:material/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class NoteView extends StatefulWidget {
  const NoteView({
    super.key,
    this.note,
  });

  final Note? note;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late bool _new;
  late Note _note;

  late ScrollController _scrollController;
  late ScrollController _toolbarController;

  late FocusNode _titleNode;
  late FocusNode _contentNode;

  late TextEditingController _titleController;
  late FleatherController _contentController;

  int _length = 0;

  @override
  void initState() {
    super.initState();
    _new = widget.note == null;
    _note = widget.note ?? Database.createNote(title: "");

    _scrollController = ScrollController();
    _toolbarController = ScrollController();

    _titleNode = FocusNode();
    _contentNode = FocusNode();

    _titleController = TextEditingController(text: _note.title)
      ..addListener(_titleListener);
    _note.content = ParchmentDocument.fromDelta(_note.content.toDelta());
    _contentController = FleatherController(
      document: _note.content,
    );
    _length = _contentController.document.length;
  }

  @override
  void dispose() {
    _save();

    _contentController.dispose();
    _titleController.dispose();

    _toolbarController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _titleListener() {
    _note.title = _titleController.text;
  }

  void _save() {
    _note.title = _titleController.text;
    if (_note.title.isEmpty) {
      if (_new) return;
      _note.title = "New note (${_note.id})";
    }
    _note.content = _contentController.document;
    _note.updatedAt = DateTime.now();
    Database.addNote(_note);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      // TODO: implement embedding images using MenuFAB
      // floatingActionButton: Padding(
      //   padding: MediaQuery.viewInsetsOf(context),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     children: [
      //       Text(
      //         _length.toString(),
      //         style: Theme.of(context).textTheme.labelSmall,
      //       ),
      //       const SizedBox(height: 16),
      //       FloatingActionButton(
      //         onPressed: () {},
      //         child: Icon(Symbols.add_rounded),
      //       ),
      //       const SizedBox(height: 12),
      //     ],
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BottomAppBar(
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _toolbarController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FleatherToggleStyleButton(
                            controller: _contentController,
                            attribute: ParchmentAttribute.bold,
                            icon: Symbols.format_bold_rounded,
                          ),
                          FleatherToggleStyleButton(
                            controller: _contentController,
                            attribute: ParchmentAttribute.italic,
                            icon: Symbols.format_italic_rounded,
                          ),
                          FleatherToggleStyleButton(
                            controller: _contentController,
                            attribute: ParchmentAttribute.underline,
                            icon: Symbols.format_underlined_rounded,
                          ),
                          FleatherClearStyleButton(
                            controller: _contentController,
                          ),
                          const VerticalDivider(),
                          FleatherToggleStyleButton(
                            controller: _contentController,
                            attribute: ParchmentAttribute.ol,
                            icon: Symbols.format_list_numbered_rounded,
                          ),
                          FleatherToggleStyleButton(
                            controller: _contentController,
                            attribute: ParchmentAttribute.ul,
                            icon: Symbols.format_list_bulleted_rounded,
                          ),
                          FleatherToggleStyleButton(
                            controller: _contentController,
                            attribute: ParchmentAttribute.cl,
                            icon: Symbols.check_box_rounded,
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
                            icon: Symbols.format_h1_rounded,
                            controller: _contentController,
                          ),
                          const VerticalDivider(),
                          FleatherToggleStyleButton(
                            controller: _contentController,
                            attribute: ParchmentAttribute.inlineCode,
                            icon: Symbols.code_rounded,
                          ),
                          FleatherToggleStyleButton(
                            controller: _contentController,
                            attribute: ParchmentAttribute.code,
                            icon: Symbols.code_blocks_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // TODO: uncomment when added FloatingActionButton
                  // const SizedBox(width: 72),
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
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Symbols.arrow_back_rounded),
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
              FleatherHistoryButton.undo(
                controller: _contentController,
              ),
              FleatherHistoryButton.redo(
                controller: _contentController,
              ),
              // const SizedBox(width: 16),
              // FilledButton(
              //   onPressed: () {},
              //   child: Icon(Symbols.save_rounded),
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
    );
  }
}
