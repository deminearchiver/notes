import 'package:notes/flutter.dart';

class Icons {
  // ignore: prefer_const_declarations
  static final _Icons _icons = const _GoogleSymbolsRounded();

  static IconData get search => _icons.search;
}

sealed class const _Icons() {
  IconData get search;
}

class const _MaterialSymbolsRounded() extends _Icons {
  @override
  IconData get search => MaterialSymbols.search_rounded;
}

class const _GoogleSymbolsRounded() extends _Icons {
  @override
  IconData get search => GoogleSymbolsRounded.search;
}
