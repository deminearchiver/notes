import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';

const _icons = <String, _Icon>{
  "accountCircle": .new("account_circle"),
  "add": .new("add"),
  "add2": .new("add_2"),
  "arrowBack": .new("arrow_back"),
  "arrowBackIos": .new("arrow_back_ios"),
  "arrowDownward": .new("arrow_downward"),
  "arrowDownwardAlt": .new("arrow_downward_alt"),
  "arrowForward": .new("arrow_forward"),
  "arrowForwardIos": .new("arrow_forward_ios"),
  "arrowUpward": .new("arrow_upward"),
  "chevronBackward": .new("chevron_backward"),
  "chevronForward": .new("chevron_forward"),
  "chevronLeft": .new("chevron_left"),
  "chevronRight": .new("chevron_right"),
  "code": .new("code"),
  "codeBlocks": .new("code_blocks"),
  "codeOff": .new("code_off"),
  "contentCopy": .new("content_copy", overrides: {.luminousSymbols: "copy"}),
  "delete": .new("delete"),
  "deleteForever": .new("delete_forever"),
  "home": .new("home"),
  "info": .new("info"),
  "menu": .new("menu"),
  "note": .new("note"),
  "notes": .new("notes"),
  "openInBrowser": .new("open_in_browser"),
  "openInFull": .new("open_in_full"),
  "openInNew": .new("open_in_new"),
  "redo": .new("redo"),
  "schedule": .new("schedule"),
  "school": .new("school"),
  "search": .new("search"),
  "settings": .new("settings"),
  "share": .new("share", overrides: {.luminousSymbols: "share_2"}),
  "taskAlt": .new("task_alt"),
  "undo": .new("undo"),
};

class const _Icon(
  final String name, {
  final Map<_Font, String> overrides = const {},
});

class const _ResolvedIcon({
  required final String identifier,
  required String name,
  super.overrides,
}) extends _Icon {
  this : super(name);
}

enum _Font({required final String className}) {
  // materialSymbols(className: "_MaterialSymbols"),
  materialSymbolsOutlined(className: "_MaterialSymbolsOutlined"),
  materialSymbolsRounded(className: "_MaterialSymbolsRounded"),
  materialSymbolsSharp(className: "_MaterialSymbolsSharp"),
  googleSymbols(className: "_GoogleSymbols"),
  googleSymbolsOutlined(className: "_GoogleSymbolsOutlined"),
  googleSymbolsRounded(className: "_GoogleSymbolsRounded"),
  googleSymbolsSharp(className: "_GoogleSymbolsSharp"),
  luminousSymbols(className: "_LuminousSymbols");

  String expression(_Icon icon) {
    final className = switch (this) {
      .materialSymbolsOutlined ||
      .materialSymbolsRounded ||
      .materialSymbolsSharp => "MaterialSymbols",
      .googleSymbols => "GoogleSymbols",
      .googleSymbolsOutlined => "GoogleSymbolsOutlined",
      .googleSymbolsRounded => "GoogleSymbolsRounded",
      .googleSymbolsSharp => "GoogleSymbolsSharp",
      .luminousSymbols => "LuminousSymbols",
    };
    final identifier =
        icon.overrides[this] ??
        switch (this) {
          .materialSymbolsRounded => "${icon.name}_rounded",
          .materialSymbolsSharp => "${icon.name}_sharp",
          _ => icon.name,
        };
    return "$className.$identifier";
  }
}

Future<void> main(List<String> arguments) async {
  final icons = _icons.entries
      .map(
        (entry) => _ResolvedIcon(
          identifier: entry.key,
          name: entry.value.name,
          overrides: entry.value.overrides,
        ),
      )
      .sortedBy((icon) => icon.identifier);

  final buffer = StringBuffer();

  {
    buffer.writeln("import 'package:notes/flutter.dart';");
  }

  buffer
    ..writeln()
    ..write("abstract interface class AppIconsDelegate {");
  for (final font in _Font.values) {
    buffer
      ..writeln()
      ..writeln("  const factory ${font.name}() = ${font.className};");
  }
  for (final icon in icons) {
    buffer
      ..writeln()
      ..writeln("  IconData get ${icon.identifier};");
  }
  buffer.writeln("}");

  for (final font in _Font.values) {
    buffer
      ..writeln()
      ..write("class const ${font.className}() implements AppIconsDelegate {");

    for (final icon in icons) {
      buffer
        ..writeln()
        ..writeln(
          "  @override IconData get ${icon.identifier} => ${font.expression(icon)};",
        );
    }

    buffer.writeln("}");
  }
  {
    buffer
      ..writeln()
      ..writeln(
        "enum AppIconResolver(final IconData Function(AppIconsDelegate) _resolve) implements CustomIconResolver {",
      )
      ..write(
        icons
            .map((icon) => "  ${icon.identifier}(_${icon.identifier})")
            .join(",\n"),
      )
      ..writeln(";")
      ..writeln()
      ..writeln(
        "  @override IconData resolve(BuildContext context) => _resolve(AppIconsScope.delegateOf(context));",
      )
      ..writeln();
    for (final icon in icons) {
      buffer.writeln(
        "  static IconData _${icon.identifier}(AppIconsDelegate icons) => icons.${icon.identifier};",
      );
    }
    buffer.writeln("}");
  }

  final formatter = DartFormatter(
    languageVersion: DartFormatter.latestLanguageVersion,
  );
  final code = formatter.format(buffer.toString());

  final packageRoot = Platform.script.resolve("../");

  final path = packageRoot
      .resolve("lib/icons/app_icons_delegate.dart")
      .toFilePath();
  final file = File(path);
  await file.create(recursive: true);
  await file.writeAsString(code);
}
