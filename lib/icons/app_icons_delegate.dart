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

  IconData get accountCircle;

  IconData get add;

  IconData get add2;

  IconData get arrowBack;

  IconData get arrowBackIos;

  IconData get arrowDownward;

  IconData get arrowDownwardAlt;

  IconData get arrowForward;

  IconData get arrowForwardIos;

  IconData get arrowUpward;

  IconData get chevronBackward;

  IconData get chevronForward;

  IconData get chevronLeft;

  IconData get chevronRight;

  IconData get code;

  IconData get codeBlocks;

  IconData get codeOff;

  IconData get contentCopy;

  IconData get delete;

  IconData get deleteForever;

  IconData get home;

  IconData get info;

  IconData get menu;

  IconData get note;

  IconData get notes;

  IconData get openInBrowser;

  IconData get openInFull;

  IconData get openInNew;

  IconData get redo;

  IconData get schedule;

  IconData get school;

  IconData get search;

  IconData get settings;

  IconData get share;

  IconData get taskAlt;

  IconData get undo;
}

class const _MaterialSymbolsOutlined() implements AppIconsDelegate {
  @override
  IconData get accountCircle => MaterialSymbols.account_circle;

  @override
  IconData get add => MaterialSymbols.add;

  @override
  IconData get add2 => MaterialSymbols.add_2;

  @override
  IconData get arrowBack => MaterialSymbols.arrow_back;

  @override
  IconData get arrowBackIos => MaterialSymbols.arrow_back_ios;

  @override
  IconData get arrowDownward => MaterialSymbols.arrow_downward;

  @override
  IconData get arrowDownwardAlt => MaterialSymbols.arrow_downward_alt;

  @override
  IconData get arrowForward => MaterialSymbols.arrow_forward;

  @override
  IconData get arrowForwardIos => MaterialSymbols.arrow_forward_ios;

  @override
  IconData get arrowUpward => MaterialSymbols.arrow_upward;

  @override
  IconData get chevronBackward => MaterialSymbols.chevron_backward;

  @override
  IconData get chevronForward => MaterialSymbols.chevron_forward;

  @override
  IconData get chevronLeft => MaterialSymbols.chevron_left;

  @override
  IconData get chevronRight => MaterialSymbols.chevron_right;

  @override
  IconData get code => MaterialSymbols.code;

  @override
  IconData get codeBlocks => MaterialSymbols.code_blocks;

  @override
  IconData get codeOff => MaterialSymbols.code_off;

  @override
  IconData get contentCopy => MaterialSymbols.content_copy;

  @override
  IconData get delete => MaterialSymbols.delete;

  @override
  IconData get deleteForever => MaterialSymbols.delete_forever;

  @override
  IconData get home => MaterialSymbols.home;

  @override
  IconData get info => MaterialSymbols.info;

  @override
  IconData get menu => MaterialSymbols.menu;

  @override
  IconData get note => MaterialSymbols.note;

  @override
  IconData get notes => MaterialSymbols.notes;

  @override
  IconData get openInBrowser => MaterialSymbols.open_in_browser;

  @override
  IconData get openInFull => MaterialSymbols.open_in_full;

  @override
  IconData get openInNew => MaterialSymbols.open_in_new;

  @override
  IconData get redo => MaterialSymbols.redo;

  @override
  IconData get schedule => MaterialSymbols.schedule;

  @override
  IconData get school => MaterialSymbols.school;

  @override
  IconData get search => MaterialSymbols.search;

  @override
  IconData get settings => MaterialSymbols.settings;

  @override
  IconData get share => MaterialSymbols.share;

  @override
  IconData get taskAlt => MaterialSymbols.task_alt;

  @override
  IconData get undo => MaterialSymbols.undo;
}

class const _MaterialSymbolsRounded() implements AppIconsDelegate {
  @override
  IconData get accountCircle => MaterialSymbols.account_circle_rounded;

  @override
  IconData get add => MaterialSymbols.add_rounded;

  @override
  IconData get add2 => MaterialSymbols.add_2_rounded;

  @override
  IconData get arrowBack => MaterialSymbols.arrow_back_rounded;

  @override
  IconData get arrowBackIos => MaterialSymbols.arrow_back_ios_rounded;

  @override
  IconData get arrowDownward => MaterialSymbols.arrow_downward_rounded;

  @override
  IconData get arrowDownwardAlt => MaterialSymbols.arrow_downward_alt_rounded;

  @override
  IconData get arrowForward => MaterialSymbols.arrow_forward_rounded;

  @override
  IconData get arrowForwardIos => MaterialSymbols.arrow_forward_ios_rounded;

  @override
  IconData get arrowUpward => MaterialSymbols.arrow_upward_rounded;

  @override
  IconData get chevronBackward => MaterialSymbols.chevron_backward_rounded;

  @override
  IconData get chevronForward => MaterialSymbols.chevron_forward_rounded;

  @override
  IconData get chevronLeft => MaterialSymbols.chevron_left_rounded;

  @override
  IconData get chevronRight => MaterialSymbols.chevron_right_rounded;

  @override
  IconData get code => MaterialSymbols.code_rounded;

  @override
  IconData get codeBlocks => MaterialSymbols.code_blocks_rounded;

  @override
  IconData get codeOff => MaterialSymbols.code_off_rounded;

  @override
  IconData get contentCopy => MaterialSymbols.content_copy_rounded;

  @override
  IconData get delete => MaterialSymbols.delete_rounded;

  @override
  IconData get deleteForever => MaterialSymbols.delete_forever_rounded;

  @override
  IconData get home => MaterialSymbols.home_rounded;

  @override
  IconData get info => MaterialSymbols.info_rounded;

  @override
  IconData get menu => MaterialSymbols.menu_rounded;

  @override
  IconData get note => MaterialSymbols.note_rounded;

  @override
  IconData get notes => MaterialSymbols.notes_rounded;

  @override
  IconData get openInBrowser => MaterialSymbols.open_in_browser_rounded;

  @override
  IconData get openInFull => MaterialSymbols.open_in_full_rounded;

  @override
  IconData get openInNew => MaterialSymbols.open_in_new_rounded;

  @override
  IconData get redo => MaterialSymbols.redo_rounded;

  @override
  IconData get schedule => MaterialSymbols.schedule_rounded;

  @override
  IconData get school => MaterialSymbols.school_rounded;

  @override
  IconData get search => MaterialSymbols.search_rounded;

  @override
  IconData get settings => MaterialSymbols.settings_rounded;

  @override
  IconData get share => MaterialSymbols.share_rounded;

  @override
  IconData get taskAlt => MaterialSymbols.task_alt_rounded;

  @override
  IconData get undo => MaterialSymbols.undo_rounded;
}

class const _MaterialSymbolsSharp() implements AppIconsDelegate {
  @override
  IconData get accountCircle => MaterialSymbols.account_circle_sharp;

  @override
  IconData get add => MaterialSymbols.add_sharp;

  @override
  IconData get add2 => MaterialSymbols.add_2_sharp;

  @override
  IconData get arrowBack => MaterialSymbols.arrow_back_sharp;

  @override
  IconData get arrowBackIos => MaterialSymbols.arrow_back_ios_sharp;

  @override
  IconData get arrowDownward => MaterialSymbols.arrow_downward_sharp;

  @override
  IconData get arrowDownwardAlt => MaterialSymbols.arrow_downward_alt_sharp;

  @override
  IconData get arrowForward => MaterialSymbols.arrow_forward_sharp;

  @override
  IconData get arrowForwardIos => MaterialSymbols.arrow_forward_ios_sharp;

  @override
  IconData get arrowUpward => MaterialSymbols.arrow_upward_sharp;

  @override
  IconData get chevronBackward => MaterialSymbols.chevron_backward_sharp;

  @override
  IconData get chevronForward => MaterialSymbols.chevron_forward_sharp;

  @override
  IconData get chevronLeft => MaterialSymbols.chevron_left_sharp;

  @override
  IconData get chevronRight => MaterialSymbols.chevron_right_sharp;

  @override
  IconData get code => MaterialSymbols.code_sharp;

  @override
  IconData get codeBlocks => MaterialSymbols.code_blocks_sharp;

  @override
  IconData get codeOff => MaterialSymbols.code_off_sharp;

  @override
  IconData get contentCopy => MaterialSymbols.content_copy_sharp;

  @override
  IconData get delete => MaterialSymbols.delete_sharp;

  @override
  IconData get deleteForever => MaterialSymbols.delete_forever_sharp;

  @override
  IconData get home => MaterialSymbols.home_sharp;

  @override
  IconData get info => MaterialSymbols.info_sharp;

  @override
  IconData get menu => MaterialSymbols.menu_sharp;

  @override
  IconData get note => MaterialSymbols.note_sharp;

  @override
  IconData get notes => MaterialSymbols.notes_sharp;

  @override
  IconData get openInBrowser => MaterialSymbols.open_in_browser_sharp;

  @override
  IconData get openInFull => MaterialSymbols.open_in_full_sharp;

  @override
  IconData get openInNew => MaterialSymbols.open_in_new_sharp;

  @override
  IconData get redo => MaterialSymbols.redo_sharp;

  @override
  IconData get schedule => MaterialSymbols.schedule_sharp;

  @override
  IconData get school => MaterialSymbols.school_sharp;

  @override
  IconData get search => MaterialSymbols.search_sharp;

  @override
  IconData get settings => MaterialSymbols.settings_sharp;

  @override
  IconData get share => MaterialSymbols.share_sharp;

  @override
  IconData get taskAlt => MaterialSymbols.task_alt_sharp;

  @override
  IconData get undo => MaterialSymbols.undo_sharp;
}

class const _GoogleSymbols() implements AppIconsDelegate {
  @override
  IconData get accountCircle => GoogleSymbols.account_circle;

  @override
  IconData get add => GoogleSymbols.add;

  @override
  IconData get add2 => GoogleSymbols.add_2;

  @override
  IconData get arrowBack => GoogleSymbols.arrow_back;

  @override
  IconData get arrowBackIos => GoogleSymbols.arrow_back_ios;

  @override
  IconData get arrowDownward => GoogleSymbols.arrow_downward;

  @override
  IconData get arrowDownwardAlt => GoogleSymbols.arrow_downward_alt;

  @override
  IconData get arrowForward => GoogleSymbols.arrow_forward;

  @override
  IconData get arrowForwardIos => GoogleSymbols.arrow_forward_ios;

  @override
  IconData get arrowUpward => GoogleSymbols.arrow_upward;

  @override
  IconData get chevronBackward => GoogleSymbols.chevron_backward;

  @override
  IconData get chevronForward => GoogleSymbols.chevron_forward;

  @override
  IconData get chevronLeft => GoogleSymbols.chevron_left;

  @override
  IconData get chevronRight => GoogleSymbols.chevron_right;

  @override
  IconData get code => GoogleSymbols.code;

  @override
  IconData get codeBlocks => GoogleSymbols.code_blocks;

  @override
  IconData get codeOff => GoogleSymbols.code_off;

  @override
  IconData get contentCopy => GoogleSymbols.content_copy;

  @override
  IconData get delete => GoogleSymbols.delete;

  @override
  IconData get deleteForever => GoogleSymbols.delete_forever;

  @override
  IconData get home => GoogleSymbols.home;

  @override
  IconData get info => GoogleSymbols.info;

  @override
  IconData get menu => GoogleSymbols.menu;

  @override
  IconData get note => GoogleSymbols.note;

  @override
  IconData get notes => GoogleSymbols.notes;

  @override
  IconData get openInBrowser => GoogleSymbols.open_in_browser;

  @override
  IconData get openInFull => GoogleSymbols.open_in_full;

  @override
  IconData get openInNew => GoogleSymbols.open_in_new;

  @override
  IconData get redo => GoogleSymbols.redo;

  @override
  IconData get schedule => GoogleSymbols.schedule;

  @override
  IconData get school => GoogleSymbols.school;

  @override
  IconData get search => GoogleSymbols.search;

  @override
  IconData get settings => GoogleSymbols.settings;

  @override
  IconData get share => GoogleSymbols.share;

  @override
  IconData get taskAlt => GoogleSymbols.task_alt;

  @override
  IconData get undo => GoogleSymbols.undo;
}

class const _GoogleSymbolsOutlined() implements AppIconsDelegate {
  @override
  IconData get accountCircle => GoogleSymbolsOutlined.account_circle;

  @override
  IconData get add => GoogleSymbolsOutlined.add;

  @override
  IconData get add2 => GoogleSymbolsOutlined.add_2;

  @override
  IconData get arrowBack => GoogleSymbolsOutlined.arrow_back;

  @override
  IconData get arrowBackIos => GoogleSymbolsOutlined.arrow_back_ios;

  @override
  IconData get arrowDownward => GoogleSymbolsOutlined.arrow_downward;

  @override
  IconData get arrowDownwardAlt => GoogleSymbolsOutlined.arrow_downward_alt;

  @override
  IconData get arrowForward => GoogleSymbolsOutlined.arrow_forward;

  @override
  IconData get arrowForwardIos => GoogleSymbolsOutlined.arrow_forward_ios;

  @override
  IconData get arrowUpward => GoogleSymbolsOutlined.arrow_upward;

  @override
  IconData get chevronBackward => GoogleSymbolsOutlined.chevron_backward;

  @override
  IconData get chevronForward => GoogleSymbolsOutlined.chevron_forward;

  @override
  IconData get chevronLeft => GoogleSymbolsOutlined.chevron_left;

  @override
  IconData get chevronRight => GoogleSymbolsOutlined.chevron_right;

  @override
  IconData get code => GoogleSymbolsOutlined.code;

  @override
  IconData get codeBlocks => GoogleSymbolsOutlined.code_blocks;

  @override
  IconData get codeOff => GoogleSymbolsOutlined.code_off;

  @override
  IconData get contentCopy => GoogleSymbolsOutlined.content_copy;

  @override
  IconData get delete => GoogleSymbolsOutlined.delete;

  @override
  IconData get deleteForever => GoogleSymbolsOutlined.delete_forever;

  @override
  IconData get home => GoogleSymbolsOutlined.home;

  @override
  IconData get info => GoogleSymbolsOutlined.info;

  @override
  IconData get menu => GoogleSymbolsOutlined.menu;

  @override
  IconData get note => GoogleSymbolsOutlined.note;

  @override
  IconData get notes => GoogleSymbolsOutlined.notes;

  @override
  IconData get openInBrowser => GoogleSymbolsOutlined.open_in_browser;

  @override
  IconData get openInFull => GoogleSymbolsOutlined.open_in_full;

  @override
  IconData get openInNew => GoogleSymbolsOutlined.open_in_new;

  @override
  IconData get redo => GoogleSymbolsOutlined.redo;

  @override
  IconData get schedule => GoogleSymbolsOutlined.schedule;

  @override
  IconData get school => GoogleSymbolsOutlined.school;

  @override
  IconData get search => GoogleSymbolsOutlined.search;

  @override
  IconData get settings => GoogleSymbolsOutlined.settings;

  @override
  IconData get share => GoogleSymbolsOutlined.share;

  @override
  IconData get taskAlt => GoogleSymbolsOutlined.task_alt;

  @override
  IconData get undo => GoogleSymbolsOutlined.undo;
}

class const _GoogleSymbolsRounded() implements AppIconsDelegate {
  @override
  IconData get accountCircle => GoogleSymbolsRounded.account_circle;

  @override
  IconData get add => GoogleSymbolsRounded.add;

  @override
  IconData get add2 => GoogleSymbolsRounded.add_2;

  @override
  IconData get arrowBack => GoogleSymbolsRounded.arrow_back;

  @override
  IconData get arrowBackIos => GoogleSymbolsRounded.arrow_back_ios;

  @override
  IconData get arrowDownward => GoogleSymbolsRounded.arrow_downward;

  @override
  IconData get arrowDownwardAlt => GoogleSymbolsRounded.arrow_downward_alt;

  @override
  IconData get arrowForward => GoogleSymbolsRounded.arrow_forward;

  @override
  IconData get arrowForwardIos => GoogleSymbolsRounded.arrow_forward_ios;

  @override
  IconData get arrowUpward => GoogleSymbolsRounded.arrow_upward;

  @override
  IconData get chevronBackward => GoogleSymbolsRounded.chevron_backward;

  @override
  IconData get chevronForward => GoogleSymbolsRounded.chevron_forward;

  @override
  IconData get chevronLeft => GoogleSymbolsRounded.chevron_left;

  @override
  IconData get chevronRight => GoogleSymbolsRounded.chevron_right;

  @override
  IconData get code => GoogleSymbolsRounded.code;

  @override
  IconData get codeBlocks => GoogleSymbolsRounded.code_blocks;

  @override
  IconData get codeOff => GoogleSymbolsRounded.code_off;

  @override
  IconData get contentCopy => GoogleSymbolsRounded.content_copy;

  @override
  IconData get delete => GoogleSymbolsRounded.delete;

  @override
  IconData get deleteForever => GoogleSymbolsRounded.delete_forever;

  @override
  IconData get home => GoogleSymbolsRounded.home;

  @override
  IconData get info => GoogleSymbolsRounded.info;

  @override
  IconData get menu => GoogleSymbolsRounded.menu;

  @override
  IconData get note => GoogleSymbolsRounded.note;

  @override
  IconData get notes => GoogleSymbolsRounded.notes;

  @override
  IconData get openInBrowser => GoogleSymbolsRounded.open_in_browser;

  @override
  IconData get openInFull => GoogleSymbolsRounded.open_in_full;

  @override
  IconData get openInNew => GoogleSymbolsRounded.open_in_new;

  @override
  IconData get redo => GoogleSymbolsRounded.redo;

  @override
  IconData get schedule => GoogleSymbolsRounded.schedule;

  @override
  IconData get school => GoogleSymbolsRounded.school;

  @override
  IconData get search => GoogleSymbolsRounded.search;

  @override
  IconData get settings => GoogleSymbolsRounded.settings;

  @override
  IconData get share => GoogleSymbolsRounded.share;

  @override
  IconData get taskAlt => GoogleSymbolsRounded.task_alt;

  @override
  IconData get undo => GoogleSymbolsRounded.undo;
}

class const _GoogleSymbolsSharp() implements AppIconsDelegate {
  @override
  IconData get accountCircle => GoogleSymbolsSharp.account_circle;

  @override
  IconData get add => GoogleSymbolsSharp.add;

  @override
  IconData get add2 => GoogleSymbolsSharp.add_2;

  @override
  IconData get arrowBack => GoogleSymbolsSharp.arrow_back;

  @override
  IconData get arrowBackIos => GoogleSymbolsSharp.arrow_back_ios;

  @override
  IconData get arrowDownward => GoogleSymbolsSharp.arrow_downward;

  @override
  IconData get arrowDownwardAlt => GoogleSymbolsSharp.arrow_downward_alt;

  @override
  IconData get arrowForward => GoogleSymbolsSharp.arrow_forward;

  @override
  IconData get arrowForwardIos => GoogleSymbolsSharp.arrow_forward_ios;

  @override
  IconData get arrowUpward => GoogleSymbolsSharp.arrow_upward;

  @override
  IconData get chevronBackward => GoogleSymbolsSharp.chevron_backward;

  @override
  IconData get chevronForward => GoogleSymbolsSharp.chevron_forward;

  @override
  IconData get chevronLeft => GoogleSymbolsSharp.chevron_left;

  @override
  IconData get chevronRight => GoogleSymbolsSharp.chevron_right;

  @override
  IconData get code => GoogleSymbolsSharp.code;

  @override
  IconData get codeBlocks => GoogleSymbolsSharp.code_blocks;

  @override
  IconData get codeOff => GoogleSymbolsSharp.code_off;

  @override
  IconData get contentCopy => GoogleSymbolsSharp.content_copy;

  @override
  IconData get delete => GoogleSymbolsSharp.delete;

  @override
  IconData get deleteForever => GoogleSymbolsSharp.delete_forever;

  @override
  IconData get home => GoogleSymbolsSharp.home;

  @override
  IconData get info => GoogleSymbolsSharp.info;

  @override
  IconData get menu => GoogleSymbolsSharp.menu;

  @override
  IconData get note => GoogleSymbolsSharp.note;

  @override
  IconData get notes => GoogleSymbolsSharp.notes;

  @override
  IconData get openInBrowser => GoogleSymbolsSharp.open_in_browser;

  @override
  IconData get openInFull => GoogleSymbolsSharp.open_in_full;

  @override
  IconData get openInNew => GoogleSymbolsSharp.open_in_new;

  @override
  IconData get redo => GoogleSymbolsSharp.redo;

  @override
  IconData get schedule => GoogleSymbolsSharp.schedule;

  @override
  IconData get school => GoogleSymbolsSharp.school;

  @override
  IconData get search => GoogleSymbolsSharp.search;

  @override
  IconData get settings => GoogleSymbolsSharp.settings;

  @override
  IconData get share => GoogleSymbolsSharp.share;

  @override
  IconData get taskAlt => GoogleSymbolsSharp.task_alt;

  @override
  IconData get undo => GoogleSymbolsSharp.undo;
}

class const _LuminousSymbols() implements AppIconsDelegate {
  @override
  IconData get accountCircle => LuminousSymbols.account_circle;

  @override
  IconData get add => LuminousSymbols.add;

  @override
  IconData get add2 => LuminousSymbols.add_2;

  @override
  IconData get arrowBack => LuminousSymbols.arrow_back;

  @override
  IconData get arrowBackIos => LuminousSymbols.arrow_back_ios;

  @override
  IconData get arrowDownward => LuminousSymbols.arrow_downward;

  @override
  IconData get arrowDownwardAlt => LuminousSymbols.arrow_downward_alt;

  @override
  IconData get arrowForward => LuminousSymbols.arrow_forward;

  @override
  IconData get arrowForwardIos => LuminousSymbols.arrow_forward_ios;

  @override
  IconData get arrowUpward => LuminousSymbols.arrow_upward;

  @override
  IconData get chevronBackward => LuminousSymbols.chevron_backward;

  @override
  IconData get chevronForward => LuminousSymbols.chevron_forward;

  @override
  IconData get chevronLeft => LuminousSymbols.chevron_left;

  @override
  IconData get chevronRight => LuminousSymbols.chevron_right;

  @override
  IconData get code => LuminousSymbols.code;

  @override
  IconData get codeBlocks => LuminousSymbols.code_blocks;

  @override
  IconData get codeOff => LuminousSymbols.code_off;

  @override
  IconData get contentCopy => LuminousSymbols.copy;

  @override
  IconData get delete => LuminousSymbols.delete;

  @override
  IconData get deleteForever => LuminousSymbols.delete_forever;

  @override
  IconData get home => LuminousSymbols.home;

  @override
  IconData get info => LuminousSymbols.info;

  @override
  IconData get menu => LuminousSymbols.menu;

  @override
  IconData get note => LuminousSymbols.note;

  @override
  IconData get notes => LuminousSymbols.notes;

  @override
  IconData get openInBrowser => LuminousSymbols.open_in_browser;

  @override
  IconData get openInFull => LuminousSymbols.open_in_full;

  @override
  IconData get openInNew => LuminousSymbols.open_in_new;

  @override
  IconData get redo => LuminousSymbols.redo;

  @override
  IconData get schedule => LuminousSymbols.schedule;

  @override
  IconData get school => LuminousSymbols.school;

  @override
  IconData get search => LuminousSymbols.search;

  @override
  IconData get settings => LuminousSymbols.settings;

  @override
  IconData get share => LuminousSymbols.share_2;

  @override
  IconData get taskAlt => LuminousSymbols.task_alt;

  @override
  IconData get undo => LuminousSymbols.undo;
}

enum AppIconResolver(final IconData Function(AppIconsDelegate) _resolve)
    implements CustomIconResolver {
  accountCircle(_accountCircle),
  add(_add),
  add2(_add2),
  arrowBack(_arrowBack),
  arrowBackIos(_arrowBackIos),
  arrowDownward(_arrowDownward),
  arrowDownwardAlt(_arrowDownwardAlt),
  arrowForward(_arrowForward),
  arrowForwardIos(_arrowForwardIos),
  arrowUpward(_arrowUpward),
  chevronBackward(_chevronBackward),
  chevronForward(_chevronForward),
  chevronLeft(_chevronLeft),
  chevronRight(_chevronRight),
  code(_code),
  codeBlocks(_codeBlocks),
  codeOff(_codeOff),
  contentCopy(_contentCopy),
  delete(_delete),
  deleteForever(_deleteForever),
  home(_home),
  info(_info),
  menu(_menu),
  note(_note),
  notes(_notes),
  openInBrowser(_openInBrowser),
  openInFull(_openInFull),
  openInNew(_openInNew),
  redo(_redo),
  schedule(_schedule),
  school(_school),
  search(_search),
  settings(_settings),
  share(_share),
  taskAlt(_taskAlt),
  undo(_undo);

  @override
  IconData resolve(BuildContext context) =>
      _resolve(AppIconsScope.delegateOf(context));

  static IconData _accountCircle(AppIconsDelegate icons) => icons.accountCircle;
  static IconData _add(AppIconsDelegate icons) => icons.add;
  static IconData _add2(AppIconsDelegate icons) => icons.add2;
  static IconData _arrowBack(AppIconsDelegate icons) => icons.arrowBack;
  static IconData _arrowBackIos(AppIconsDelegate icons) => icons.arrowBackIos;
  static IconData _arrowDownward(AppIconsDelegate icons) => icons.arrowDownward;
  static IconData _arrowDownwardAlt(AppIconsDelegate icons) =>
      icons.arrowDownwardAlt;
  static IconData _arrowForward(AppIconsDelegate icons) => icons.arrowForward;
  static IconData _arrowForwardIos(AppIconsDelegate icons) =>
      icons.arrowForwardIos;
  static IconData _arrowUpward(AppIconsDelegate icons) => icons.arrowUpward;
  static IconData _chevronBackward(AppIconsDelegate icons) =>
      icons.chevronBackward;
  static IconData _chevronForward(AppIconsDelegate icons) =>
      icons.chevronForward;
  static IconData _chevronLeft(AppIconsDelegate icons) => icons.chevronLeft;
  static IconData _chevronRight(AppIconsDelegate icons) => icons.chevronRight;
  static IconData _code(AppIconsDelegate icons) => icons.code;
  static IconData _codeBlocks(AppIconsDelegate icons) => icons.codeBlocks;
  static IconData _codeOff(AppIconsDelegate icons) => icons.codeOff;
  static IconData _contentCopy(AppIconsDelegate icons) => icons.contentCopy;
  static IconData _delete(AppIconsDelegate icons) => icons.delete;
  static IconData _deleteForever(AppIconsDelegate icons) => icons.deleteForever;
  static IconData _home(AppIconsDelegate icons) => icons.home;
  static IconData _info(AppIconsDelegate icons) => icons.info;
  static IconData _menu(AppIconsDelegate icons) => icons.menu;
  static IconData _note(AppIconsDelegate icons) => icons.note;
  static IconData _notes(AppIconsDelegate icons) => icons.notes;
  static IconData _openInBrowser(AppIconsDelegate icons) => icons.openInBrowser;
  static IconData _openInFull(AppIconsDelegate icons) => icons.openInFull;
  static IconData _openInNew(AppIconsDelegate icons) => icons.openInNew;
  static IconData _redo(AppIconsDelegate icons) => icons.redo;
  static IconData _schedule(AppIconsDelegate icons) => icons.schedule;
  static IconData _school(AppIconsDelegate icons) => icons.school;
  static IconData _search(AppIconsDelegate icons) => icons.search;
  static IconData _settings(AppIconsDelegate icons) => icons.settings;
  static IconData _share(AppIconsDelegate icons) => icons.share;
  static IconData _taskAlt(AppIconsDelegate icons) => icons.taskAlt;
  static IconData _undo(AppIconsDelegate icons) => icons.undo;
}
