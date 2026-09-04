import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';

const _icons = <String, _Icon>{
  "arrowBack": .new("arrow_back"),
  "home": .new("home"),
  "menu": .new("menu"),
  "note": .new("note"),
  "redo": .new("redo"),
  "search": .new("search"),
  "settings": .new("settings"),
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
    buffer.writeln("part of 'app_icons.dart';");
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

  final path = packageRoot.resolve("lib/icons/app_icons.g.dart").toFilePath();
  final file = File(path);
  await file.create(recursive: true);
  await file.writeAsString(code);
}
