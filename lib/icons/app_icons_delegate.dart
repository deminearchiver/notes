import 'package:notes/flutter.dart';

abstract interface class AppIconsDelegate {
  const factory materialSymbolsOutlined() = _MaterialSymbolsOutlined;

  const factory materialSymbolsRounded() = _MaterialSymbolsRounded;

  const factory materialSymbolsSharp() = _MaterialSymbolsSharp;

  const factory googleSymbols() = _GoogleSymbols;

  const factory googleSymbolsOutlined() = _GoogleSymbolsOutlined;

  const factory googleSymbolsRounded() = _GoogleSymbolsRounded;

  const factory googleSymbolsSharp() = _GoogleSymbolsSharp;

  const factory luminousSymbols() = _LuminousSymbols;

  IconData get arrowBack;

  IconData get home;

  IconData get menu;

  IconData get note;

  IconData get redo;

  IconData get search;

  IconData get settings;

  IconData get undo;
}

class const _MaterialSymbolsOutlined() implements AppIconsDelegate {
  @override
  IconData get arrowBack => MaterialSymbols.arrow_back;

  @override
  IconData get home => MaterialSymbols.home;

  @override
  IconData get menu => MaterialSymbols.menu;

  @override
  IconData get note => MaterialSymbols.note;

  @override
  IconData get redo => MaterialSymbols.redo;

  @override
  IconData get search => MaterialSymbols.search;

  @override
  IconData get settings => MaterialSymbols.settings;

  @override
  IconData get undo => MaterialSymbols.undo;
}

class const _MaterialSymbolsRounded() implements AppIconsDelegate {
  @override
  IconData get arrowBack => MaterialSymbols.arrow_back_rounded;

  @override
  IconData get home => MaterialSymbols.home_rounded;

  @override
  IconData get menu => MaterialSymbols.menu_rounded;

  @override
  IconData get note => MaterialSymbols.note_rounded;

  @override
  IconData get redo => MaterialSymbols.redo_rounded;

  @override
  IconData get search => MaterialSymbols.search_rounded;

  @override
  IconData get settings => MaterialSymbols.settings_rounded;

  @override
  IconData get undo => MaterialSymbols.undo_rounded;
}

class const _MaterialSymbolsSharp() implements AppIconsDelegate {
  @override
  IconData get arrowBack => MaterialSymbols.arrow_back_sharp;

  @override
  IconData get home => MaterialSymbols.home_sharp;

  @override
  IconData get menu => MaterialSymbols.menu_sharp;

  @override
  IconData get note => MaterialSymbols.note_sharp;

  @override
  IconData get redo => MaterialSymbols.redo_sharp;

  @override
  IconData get search => MaterialSymbols.search_sharp;

  @override
  IconData get settings => MaterialSymbols.settings_sharp;

  @override
  IconData get undo => MaterialSymbols.undo_sharp;
}

class const _GoogleSymbols() implements AppIconsDelegate {
  @override
  IconData get arrowBack => GoogleSymbols.arrow_back;

  @override
  IconData get home => GoogleSymbols.home;

  @override
  IconData get menu => GoogleSymbols.menu;

  @override
  IconData get note => GoogleSymbols.note;

  @override
  IconData get redo => GoogleSymbols.redo;

  @override
  IconData get search => GoogleSymbols.search;

  @override
  IconData get settings => GoogleSymbols.settings;

  @override
  IconData get undo => GoogleSymbols.undo;
}

class const _GoogleSymbolsOutlined() implements AppIconsDelegate {
  @override
  IconData get arrowBack => GoogleSymbolsOutlined.arrow_back;

  @override
  IconData get home => GoogleSymbolsOutlined.home;

  @override
  IconData get menu => GoogleSymbolsOutlined.menu;

  @override
  IconData get note => GoogleSymbolsOutlined.note;

  @override
  IconData get redo => GoogleSymbolsOutlined.redo;

  @override
  IconData get search => GoogleSymbolsOutlined.search;

  @override
  IconData get settings => GoogleSymbolsOutlined.settings;

  @override
  IconData get undo => GoogleSymbolsOutlined.undo;
}

class const _GoogleSymbolsRounded() implements AppIconsDelegate {
  @override
  IconData get arrowBack => GoogleSymbolsRounded.arrow_back;

  @override
  IconData get home => GoogleSymbolsRounded.home;

  @override
  IconData get menu => GoogleSymbolsRounded.menu;

  @override
  IconData get note => GoogleSymbolsRounded.note;

  @override
  IconData get redo => GoogleSymbolsRounded.redo;

  @override
  IconData get search => GoogleSymbolsRounded.search;

  @override
  IconData get settings => GoogleSymbolsRounded.settings;

  @override
  IconData get undo => GoogleSymbolsRounded.undo;
}

class const _GoogleSymbolsSharp() implements AppIconsDelegate {
  @override
  IconData get arrowBack => GoogleSymbolsSharp.arrow_back;

  @override
  IconData get home => GoogleSymbolsSharp.home;

  @override
  IconData get menu => GoogleSymbolsSharp.menu;

  @override
  IconData get note => GoogleSymbolsSharp.note;

  @override
  IconData get redo => GoogleSymbolsSharp.redo;

  @override
  IconData get search => GoogleSymbolsSharp.search;

  @override
  IconData get settings => GoogleSymbolsSharp.settings;

  @override
  IconData get undo => GoogleSymbolsSharp.undo;
}

class const _LuminousSymbols() implements AppIconsDelegate {
  @override
  IconData get arrowBack => LuminousSymbols.arrow_back;

  @override
  IconData get home => LuminousSymbols.home;

  @override
  IconData get menu => LuminousSymbols.menu;

  @override
  IconData get note => LuminousSymbols.note;

  @override
  IconData get redo => LuminousSymbols.redo;

  @override
  IconData get search => LuminousSymbols.search;

  @override
  IconData get settings => LuminousSymbols.settings;

  @override
  IconData get undo => LuminousSymbols.undo;
}

enum AppIconResolver(final IconData Function(AppIconsDelegate) _resolve)
    implements CustomIconResolver {
  arrowBack(_arrowBack),
  home(_home),
  menu(_menu),
  note(_note),
  redo(_redo),
  search(_search),
  settings(_settings),
  undo(_undo);

  @override
  IconData resolve(BuildContext context) =>
      _resolve(AppIconsScope.delegateOf(context));

  static IconData _arrowBack(AppIconsDelegate icons) => icons.arrowBack;
  static IconData _home(AppIconsDelegate icons) => icons.home;
  static IconData _menu(AppIconsDelegate icons) => icons.menu;
  static IconData _note(AppIconsDelegate icons) => icons.note;
  static IconData _redo(AppIconsDelegate icons) => icons.redo;
  static IconData _search(AppIconsDelegate icons) => icons.search;
  static IconData _settings(AppIconsDelegate icons) => icons.settings;
  static IconData _undo(AppIconsDelegate icons) => icons.undo;
}
