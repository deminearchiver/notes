import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String locale_name(String locale) {
    String _temp0 = intl.Intl.selectLogic(
      locale,
      {
        'other': 'Unknown',
        'en': 'English',
        'ru': 'Russian',
      },
    );
    return '$_temp0';
  }

  @override
  String get design_system => 'Design system';

  @override
  String get icons => 'Icons';

  @override
  String get font => 'Font';

  @override
  String get framework => 'Framework';

  @override
  String get search_no_results => 'No results!';

  @override
  String get delete => 'Delete';

  @override
  String get share => 'Share';

  @override
  String get sort_ascending => 'Ascending';

  @override
  String get sort_descending => 'Descending';

  @override
  String get scroll_to_top => 'Back to top';

  @override
  String get theme_auto => 'Auto';

  @override
  String get theme_auto_tooltip => 'Uses the default theme of your system';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_light_tooltip => 'Uses the light color scheme';

  @override
  String get theme_dark => 'Dark';

  @override
  String get theme_dark_tooltip => 'Uses the dark color scheme';

  @override
  String get app_name => 'Notes';

  @override
  String get app_author => 'deminearchiver';

  @override
  String get about_app => 'About app';

  @override
  String get about_author => 'About author';

  @override
  String get about_view_technologies => 'Technologies';

  @override
  String get about_view_links => 'Links';

  @override
  String get about_view_licenses => 'Open source licenses';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get current_language => 'Current language';

  @override
  String get pick_language => 'Choose a language';

  @override
  String get app_home_view => 'Home';

  @override
  String get app_home_view_search => 'Search';

  @override
  String app_home_view_overdue(int count) {
    return 'Overdue ($count)';
  }

  @override
  String app_home_view_recent(int count) {
    return 'Recent ($count)';
  }

  @override
  String app_home_view_todos(int count) {
    return 'To-dos ($count)';
  }

  @override
  String app_home_view_notes(int count) {
    return 'Notes ($count)';
  }

  @override
  String app_home_view_completed(int count) {
    return 'Completed ($count)';
  }

  @override
  String get app_notes_view => 'Notes';

  @override
  String get app_notes_view_search => 'Search your notes';

  @override
  String get app_notes_view_create => 'Note';

  @override
  String get app_notes_view_sort_title => 'Title';

  @override
  String get app_notes_view_sort_created => 'Date created';

  @override
  String get app_notes_view_sort_modified => 'Date modified';

  @override
  String get app_todos_view => 'To-dos';

  @override
  String get app_todos_view_search => 'Search your to-dos';

  @override
  String get app_todos_view_create => 'To-do';

  @override
  String get app_todos_view_sort_label => 'Label';

  @override
  String get app_todos_view_sort_date => 'Date';

  @override
  String get note_view_title_hint => 'Title';

  @override
  String get todo_view_label_hint => 'Label';

  @override
  String get todo_view_details_hint => 'Details';

  @override
  String get todo_view_options => 'Options';

  @override
  String get todo_view_completed => 'Done';

  @override
  String get todo_view_important => 'Important';

  @override
  String get todo_view_reminder => 'Reminder';

  @override
  String get todo_view_reminder_date => 'Date';

  @override
  String get todo_view_reminder_time => 'Time';

  @override
  String get settings_view => 'Settings';

  @override
  String get settings_view_options => 'Options';

  @override
  String get settings_general_view => 'General';

  @override
  String get settings_general_view_description => 'Behavioural parameters';

  @override
  String get settings_appearance_view => 'Appearance';

  @override
  String get settings_appearance_view_description => 'App appearance parameters';

  @override
  String get settings_appearance_view_language => 'Language';

  @override
  String get settings_appearance_view_language_system => 'System language';

  @override
  String get settings_appearance_view_theme_mode => 'Theme mode';

  @override
  String get settings_view_other => 'Other';

  @override
  String get settings_view_about => 'About';

  @override
  String get settings_view_about_description => 'Information about the app';

  @override
  String get settings_view_developer_mode => 'Developer mode';

  @override
  String get settings_view_developer_mode_description => 'Functionality useful for developers';

  @override
  String get settings_view_demo_mode => 'Demo mode';

  @override
  String get settings_view_demo_mode_description => 'For presentations';

  @override
  String get settings_view_demo_mode_action => 'Enable';

  @override
  String get settings_view_clear_database => 'Clear database';

  @override
  String get settings_view_clear_database_description => 'This action is irreversible';

  @override
  String get settings_view_clear_database_action => 'Clear';

  @override
  String get reset_settings => 'Reset settings';

  @override
  String get reset_settings_confirmation => 'Are you sure you want to reset ALL settings? This action CANNOT be undone.';

  @override
  String get reset_settings_success => 'Settings reset successfully';

  @override
  String get reminder_view_dismiss => 'Dismiss';

  @override
  String get reminder_view_done => 'Done';

  @override
  String get onboarding_back => 'Back';

  @override
  String get onboarding_next => 'Next';

  @override
  String get onboarding_welcome_view_title => 'Welcome!';

  @override
  String get onboarding_welcome_view_subtitle => '\"Notes\" is a note-taking and to-do app';

  @override
  String get onboarding_setup_view_title => 'Set up';

  @override
  String get onboarding_setup_view_subtitle => 'Let\'s get you set up!';

  @override
  String get onboarding_setup_view_permissions => 'Permissions';

  @override
  String get onboarding_setup_view_permission => 'Send notifications';

  @override
  String get onboarding_setup_view_permission_description => 'Tap to request permission';

  @override
  String get onboarding_setup_view_appearance => 'Appearance';

  @override
  String get onboarding_setup_view_theme => 'Choose a theme';

  @override
  String get onboarding_done_view_title => 'Congrats!';

  @override
  String get onboarding_done_view_subtitle => 'You are set up and ready to go';

  @override
  String get onboarding_done_view_action => 'Let\'s go!';
}
