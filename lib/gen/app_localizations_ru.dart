import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String locale_name(String locale) {
    String _temp0 = intl.Intl.selectLogic(
      locale,
      {
        'other': 'Unknown',
        'en': 'Английский',
        'ru': 'Русский',
      },
    );
    return '$_temp0';
  }

  @override
  String get design_system => 'Система дизайна';

  @override
  String get icons => 'Иконки';

  @override
  String get font => 'Шрифт';

  @override
  String get framework => 'Фреймворк';

  @override
  String get search_no_results => 'Ничего не найдено!';

  @override
  String get delete => 'Удалить';

  @override
  String get share => 'Поделиться';

  @override
  String get sort_ascending => 'По возрастанию';

  @override
  String get sort_descending => 'По убыванию';

  @override
  String get scroll_to_top => 'Наверх';

  @override
  String get theme_auto => 'Авто';

  @override
  String get theme_auto_tooltip => 'Использует тему системы';

  @override
  String get theme_light => 'Светлая';

  @override
  String get theme_light_tooltip => 'Использует светлые цвета';

  @override
  String get theme_dark => 'Тёмная';

  @override
  String get theme_dark_tooltip => 'Использует тёмные цвета';

  @override
  String get app_name => 'Заметки';

  @override
  String get app_author => 'deminearchiver';

  @override
  String get about_app => 'О приложении';

  @override
  String get about_author => 'Об авторе';

  @override
  String get about_view_technologies => 'Технологии';

  @override
  String get about_view_links => 'Ссылки';

  @override
  String get about_view_licenses => 'Open-source лицензии';

  @override
  String get close => 'Закрыть';

  @override
  String get cancel => 'Отмена';

  @override
  String get ok => 'ОК';

  @override
  String get current_language => 'Текущий язык';

  @override
  String get pick_language => 'Выберите язык';

  @override
  String get app_home_view => 'Обзор';

  @override
  String get app_home_view_search => 'Поиск';

  @override
  String app_home_view_overdue(int count) {
    return 'Просроченные ($count)';
  }

  @override
  String app_home_view_recent(int count) {
    return 'Недавно открытые ($count)';
  }

  @override
  String app_home_view_todos(int count) {
    return 'Задачи ($count)';
  }

  @override
  String app_home_view_notes(int count) {
    return 'Заметки ($count)';
  }

  @override
  String app_home_view_completed(int count) {
    return 'Завершённые ($count)';
  }

  @override
  String get app_notes_view => 'Заметки';

  @override
  String get app_notes_view_search => 'Поиск в заметках';

  @override
  String get app_notes_view_create => 'Заметка';

  @override
  String get app_notes_view_sort_title => 'Название';

  @override
  String get app_notes_view_sort_created => 'Дата создания';

  @override
  String get app_notes_view_sort_modified => 'Дата изменения';

  @override
  String get app_todos_view => 'Задачи';

  @override
  String get app_todos_view_search => 'Поиск в задачах';

  @override
  String get app_todos_view_create => 'Задача';

  @override
  String get app_todos_view_sort_label => 'Название';

  @override
  String get app_todos_view_sort_date => 'Дата';

  @override
  String get note_view_title_hint => 'Заголок';

  @override
  String get todo_view_label_hint => 'Название';

  @override
  String get todo_view_details_hint => 'Подробности';

  @override
  String get todo_view_options => 'Опции';

  @override
  String get todo_view_completed => 'Сделано';

  @override
  String get todo_view_important => 'Важное';

  @override
  String get todo_view_reminder => 'Напоминание';

  @override
  String get todo_view_reminder_date => 'Дата';

  @override
  String get todo_view_reminder_time => 'Время';

  @override
  String get settings_view => 'Настройки';

  @override
  String get settings_view_options => 'Опции';

  @override
  String get settings_general_view => 'Основное';

  @override
  String get settings_general_view_description => 'Поведенческие параметры';

  @override
  String get settings_appearance_view => 'Внешний вид';

  @override
  String get settings_appearance_view_description => 'Параметры внешнего вида приложения';

  @override
  String get settings_appearance_view_language => 'Язык';

  @override
  String get settings_appearance_view_language_system => 'Язык системы';

  @override
  String get settings_appearance_view_theme_mode => 'Тема';

  @override
  String get settings_view_other => 'Прочее';

  @override
  String get settings_view_about => 'О приложении';

  @override
  String get settings_view_about_description => 'Информации о приложении';

  @override
  String get settings_view_developer_mode => 'Режим разработчика';

  @override
  String get settings_view_developer_mode_description => 'Функционал, полезный для разработчиков';

  @override
  String get settings_view_demo_mode => 'Демо-режим';

  @override
  String get settings_view_demo_mode_description => 'Для презентаций';

  @override
  String get settings_view_demo_mode_action => 'Включить';

  @override
  String get settings_view_clear_database => 'Очистить базу данных';

  @override
  String get settings_view_clear_database_description => 'Это действие нельзя будет отменить';

  @override
  String get settings_view_clear_database_action => 'Очистить';

  @override
  String get reset_settings => 'Сбросить настройки';

  @override
  String get reset_settings_confirmation => 'Вы уверены, что хотите сбросить ВСЕ настройки? Это действие НЕЛЬЗЯ будет отменить.';

  @override
  String get reset_settings_success => 'Настройки успешно сброшены';

  @override
  String get reminder_view_dismiss => 'Закрыть';

  @override
  String get reminder_view_done => 'Сделано';

  @override
  String get onboarding_back => 'Назад';

  @override
  String get onboarding_next => 'Далее';

  @override
  String get onboarding_welcome_view_title => 'Добро пожаловать!';

  @override
  String get onboarding_welcome_view_subtitle => '\"Заметки\" - это приложение для заметок и задач';

  @override
  String get onboarding_setup_view_title => 'Настройка';

  @override
  String get onboarding_setup_view_subtitle => 'Настроим всё для вашего лучшего опыта';

  @override
  String get onboarding_setup_view_permissions => 'Разрешения';

  @override
  String get onboarding_setup_view_permission => 'Присылать уведомления';

  @override
  String get onboarding_setup_view_permission_description => 'Нажмите, чтобы запросить разрешение';

  @override
  String get onboarding_setup_view_appearance => 'Внешний вид';

  @override
  String get onboarding_setup_view_theme => 'Выберите тему';

  @override
  String get onboarding_done_view_title => 'Поздравляем!';

  @override
  String get onboarding_done_view_subtitle => 'Всё настроено и готово к работе';

  @override
  String get onboarding_done_view_action => 'Поехали!';
}
