import 'package:fleather/fleather.dart';
import 'package:notes/flutter.dart';

Widget customToggleStyleButtonBuilder(
  BuildContext context,
  ParchmentAttribute<Object?> attribute,
  IconData icon,
  bool isToggled,
  VoidCallback? onPressed,
) {
  // final theme = Theme.of(context);
  // final isEnabled = onPressed != null;
  // final iconColor = isEnabled
  //     ? isToggled
  //         ? theme.primaryIconTheme.color
  //         : theme.iconTheme.color
  //     : theme.disabledColor;

  return isToggled
      ? IconButton.filled(onPressed: onPressed, icon: Icon(icon))
      : IconButton(onPressed: onPressed, icon: Icon(icon));
}

class FleatherToggleStyleButton extends ToggleStyleButton {
  const FleatherToggleStyleButton({
    super.key,
    required super.controller,
    required super.attribute,
    required super.icon,
    super.childBuilder = customToggleStyleButtonBuilder,
  });
}

class FleatherIndentationButton extends StatelessWidget {
  final bool increase;
  final FleatherController controller;

  const FleatherIndentationButton({
    super.key,
    this.increase = true,
    required this.controller,
  });
  ParchmentStyle get _selectionStyle => controller.getSelectionStyle();

  void _onPressed() {
    final indentLevel =
        _selectionStyle.get(ParchmentAttribute.indent)?.value ?? 0;
    if (indentLevel == 0 && !increase) {
      return;
    }
    if (indentLevel == 1 && !increase) {
      controller.formatSelection(ParchmentAttribute.indent.unset);
    } else {
      controller.formatSelection(
        ParchmentAttribute.indent.withLevel(indentLevel + (increase ? 1 : -1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final enabled = !_selectionStyle.containsSame(
          ParchmentAttribute.block.code,
        );
        return IconButton(
          onPressed: enabled ? _onPressed : null,
          icon: Icon(
            increase
                ? MaterialSymbols.format_indent_increase
                : MaterialSymbols.format_indent_decrease,
          ),
        );
      },
    );
  }
}

class FleatherClearStyleButton extends StatelessWidget {
  final FleatherController controller;

  const FleatherClearStyleButton({super.key, required this.controller});

  static final _attributes = <ParchmentAttribute<Object?>>[
    ParchmentAttribute.bold,
    ParchmentAttribute.italic,
    ParchmentAttribute.underline,
    ParchmentAttribute.checked,
    ParchmentAttribute.ol,
    ParchmentAttribute.ul,
    ParchmentAttribute.cl,
  ].map((e) => e.unset);

  void _onPressed() {
    _attributes.forEach(controller.formatSelection);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return IconButton(
          onPressed: _onPressed,
          icon: const Icon(MaterialSymbols.format_clear_rounded),
        );
      },
    );
  }
}

class FleatherHistoryButton extends StatelessWidget {
  final FleatherController controller;
  final _UndoRedoButtonVariant _variant;

  const FleatherHistoryButton._(this.controller, this._variant, {super.key});

  const FleatherHistoryButton.undo({
    Key? key,
    required FleatherController controller,
  }) : this._(controller, _UndoRedoButtonVariant.undo, key: key);

  const FleatherHistoryButton.redo({
    Key? key,
    required FleatherController controller,
  }) : this._(controller, _UndoRedoButtonVariant.redo, key: key);

  bool _isEnabled() {
    if (_variant == _UndoRedoButtonVariant.undo) {
      return controller.canUndo;
    } else {
      return controller.canRedo;
    }
  }

  void _onPressed() {
    if (_variant == _UndoRedoButtonVariant.undo) {
      controller.undo();
    } else {
      controller.redo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final isEnabled = _isEnabled();
        return IconButton(
          onPressed: isEnabled ? _onPressed : null,
          icon: switch (_variant) {
            .redo => const AppIcon(.redo),
            .undo => const AppIcon(.undo),
          },
        );
      },
    );
  }
}

enum _UndoRedoButtonVariant { undo, redo }

// TODO: use
void fleatherInsertImage_prototype({
  required FleatherController controller,
  required String source,
}) {
  final index = controller.selection.baseOffset;
  final length = controller.selection.extentOffset - index;
  // Move the cursor to the beginning of the line right after the embed.
  // 2 = 1 for the embed itself and 1 for the newline after it
  final newSelection = controller.selection.copyWith(
    baseOffset: index + 2,
    extentOffset: index + 2,
  );
  controller.replaceText(
    index,
    length,
    BlockEmbed.image(source),
    selection: newSelection,
  );
}
