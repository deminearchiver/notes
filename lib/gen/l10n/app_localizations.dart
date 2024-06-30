import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// Localized name of all locales
  ///
  /// In en, this message translates to:
  /// **'{locale, select, other{Unknown} en{English} ru{Russian}}'**
  String locale_name(String locale);

  /// No description provided for @design_system.
  ///
  /// In en, this message translates to:
  /// **'Design system'**
  String get design_system;

  /// No description provided for @icons.
  ///
  /// In en, this message translates to:
  /// **'Icons'**
  String get icons;

  /// No description provided for @font.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get font;

  /// No description provided for @framework.
  ///
  /// In en, this message translates to:
  /// **'Framework'**
  String get framework;

  /// No description provided for @search_no_results.
  ///
  /// In en, this message translates to:
  /// **'No results!'**
  String get search_no_results;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @sort_ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get sort_ascending;

  /// No description provided for @sort_descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get sort_descending;

  /// No description provided for @scroll_to_top.
  ///
  /// In en, this message translates to:
  /// **'Back to top'**
  String get scroll_to_top;

  /// No description provided for @theme_auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get theme_auto;

  /// No description provided for @theme_auto_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Uses the default theme of your system'**
  String get theme_auto_tooltip;

  /// No description provided for @theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_light;

  /// No description provided for @theme_light_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Uses the light color scheme'**
  String get theme_light_tooltip;

  /// No description provided for @theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark;

  /// No description provided for @theme_dark_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Uses the dark color scheme'**
  String get theme_dark_tooltip;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get app_name;

  /// No description provided for @app_author.
  ///
  /// In en, this message translates to:
  /// **'deminearchiver'**
  String get app_author;

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'About app'**
  String get about_app;

  /// No description provided for @about_author.
  ///
  /// In en, this message translates to:
  /// **'About author'**
  String get about_author;

  /// No description provided for @about_view_technologies.
  ///
  /// In en, this message translates to:
  /// **'Technologies'**
  String get about_view_technologies;

  /// No description provided for @about_view_links.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get about_view_links;

  /// No description provided for @about_view_licenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get about_view_licenses;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @current_language.
  ///
  /// In en, this message translates to:
  /// **'Current language'**
  String get current_language;

  /// No description provided for @pick_language.
  ///
  /// In en, this message translates to:
  /// **'Choose a language'**
  String get pick_language;

  /// No description provided for @app_home_view.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get app_home_view;

  /// No description provided for @app_home_view_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get app_home_view_search;

  /// No description provided for @app_home_view_overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue ({count})'**
  String app_home_view_overdue(int count);

  /// No description provided for @app_home_view_recent.
  ///
  /// In en, this message translates to:
  /// **'Recent ({count})'**
  String app_home_view_recent(int count);

  /// No description provided for @app_home_view_todos.
  ///
  /// In en, this message translates to:
  /// **'To-dos ({count})'**
  String app_home_view_todos(int count);

  /// No description provided for @app_home_view_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes ({count})'**
  String app_home_view_notes(int count);

  /// No description provided for @app_home_view_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed ({count})'**
  String app_home_view_completed(int count);

  /// No description provided for @app_notes_view.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get app_notes_view;

  /// No description provided for @app_notes_view_search.
  ///
  /// In en, this message translates to:
  /// **'Search your notes'**
  String get app_notes_view_search;

  /// No description provided for @app_notes_view_create.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get app_notes_view_create;

  /// No description provided for @app_notes_view_sort_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get app_notes_view_sort_title;

  /// No description provided for @app_notes_view_sort_created.
  ///
  /// In en, this message translates to:
  /// **'Date created'**
  String get app_notes_view_sort_created;

  /// No description provided for @app_notes_view_sort_modified.
  ///
  /// In en, this message translates to:
  /// **'Date modified'**
  String get app_notes_view_sort_modified;

  /// No description provided for @app_todos_view.
  ///
  /// In en, this message translates to:
  /// **'To-dos'**
  String get app_todos_view;

  /// No description provided for @app_todos_view_search.
  ///
  /// In en, this message translates to:
  /// **'Search your to-dos'**
  String get app_todos_view_search;

  /// No description provided for @app_todos_view_create.
  ///
  /// In en, this message translates to:
  /// **'To-do'**
  String get app_todos_view_create;

  /// No description provided for @app_todos_view_sort_label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get app_todos_view_sort_label;

  /// No description provided for @app_todos_view_sort_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get app_todos_view_sort_date;

  /// No description provided for @note_view_title_hint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get note_view_title_hint;

  /// No description provided for @todo_view_label_hint.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get todo_view_label_hint;

  /// No description provided for @todo_view_details_hint.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get todo_view_details_hint;

  /// No description provided for @todo_view_options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get todo_view_options;

  /// No description provided for @todo_view_completed.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get todo_view_completed;

  /// No description provided for @todo_view_important.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get todo_view_important;

  /// No description provided for @todo_view_reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get todo_view_reminder;

  /// No description provided for @todo_view_reminder_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get todo_view_reminder_date;

  /// No description provided for @todo_view_reminder_time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get todo_view_reminder_time;

  /// No description provided for @settings_view.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_view;

  /// No description provided for @settings_view_options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get settings_view_options;

  /// No description provided for @settings_general_view.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settings_general_view;

  /// No description provided for @settings_general_view_description.
  ///
  /// In en, this message translates to:
  /// **'Behavioural parameters'**
  String get settings_general_view_description;

  /// No description provided for @settings_appearance_view.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_appearance_view;

  /// No description provided for @settings_appearance_view_description.
  ///
  /// In en, this message translates to:
  /// **'App appearance parameters'**
  String get settings_appearance_view_description;

  /// No description provided for @settings_appearance_view_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_appearance_view_language;

  /// No description provided for @settings_appearance_view_language_system.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get settings_appearance_view_language_system;

  /// No description provided for @settings_appearance_view_theme_mode.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get settings_appearance_view_theme_mode;

  /// No description provided for @settings_view_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get settings_view_other;

  /// No description provided for @settings_view_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_view_about;

  /// No description provided for @settings_view_about_description.
  ///
  /// In en, this message translates to:
  /// **'Information about the app'**
  String get settings_view_about_description;

  /// No description provided for @settings_view_developer_mode.
  ///
  /// In en, this message translates to:
  /// **'Developer mode'**
  String get settings_view_developer_mode;

  /// No description provided for @settings_view_developer_mode_description.
  ///
  /// In en, this message translates to:
  /// **'Functionality useful for developers'**
  String get settings_view_developer_mode_description;

  /// No description provided for @settings_view_demo_mode.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get settings_view_demo_mode;

  /// No description provided for @settings_view_demo_mode_description.
  ///
  /// In en, this message translates to:
  /// **'For presentations'**
  String get settings_view_demo_mode_description;

  /// No description provided for @settings_view_demo_mode_action.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get settings_view_demo_mode_action;

  /// No description provided for @settings_view_clear_database.
  ///
  /// In en, this message translates to:
  /// **'Clear database'**
  String get settings_view_clear_database;

  /// No description provided for @settings_view_clear_database_description.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible'**
  String get settings_view_clear_database_description;

  /// No description provided for @settings_view_clear_database_action.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get settings_view_clear_database_action;

  /// No description provided for @reset_settings.
  ///
  /// In en, this message translates to:
  /// **'Reset settings'**
  String get reset_settings;

  /// No description provided for @reset_settings_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset ALL settings? This action CANNOT be undone.'**
  String get reset_settings_confirmation;

  /// No description provided for @reset_settings_success.
  ///
  /// In en, this message translates to:
  /// **'Settings reset successfully'**
  String get reset_settings_success;

  /// No description provided for @reminder_view_dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get reminder_view_dismiss;

  /// No description provided for @reminder_view_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get reminder_view_done;

  /// No description provided for @onboarding_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboarding_back;

  /// No description provided for @onboarding_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// No description provided for @onboarding_welcome_view_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get onboarding_welcome_view_title;

  /// No description provided for @onboarding_welcome_view_subtitle.
  ///
  /// In en, this message translates to:
  /// **'\"Notes\" is a note-taking and to-do app'**
  String get onboarding_welcome_view_subtitle;

  /// No description provided for @onboarding_setup_view_title.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get onboarding_setup_view_title;

  /// No description provided for @onboarding_setup_view_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you set up!'**
  String get onboarding_setup_view_subtitle;

  /// No description provided for @onboarding_setup_view_permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get onboarding_setup_view_permissions;

  /// No description provided for @onboarding_setup_view_permission.
  ///
  /// In en, this message translates to:
  /// **'Send notifications'**
  String get onboarding_setup_view_permission;

  /// No description provided for @onboarding_setup_view_permission_description.
  ///
  /// In en, this message translates to:
  /// **'Tap to request permission'**
  String get onboarding_setup_view_permission_description;

  /// No description provided for @onboarding_setup_view_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get onboarding_setup_view_appearance;

  /// No description provided for @onboarding_setup_view_theme.
  ///
  /// In en, this message translates to:
  /// **'Choose a theme'**
  String get onboarding_setup_view_theme;

  /// No description provided for @onboarding_done_view_title.
  ///
  /// In en, this message translates to:
  /// **'Congrats!'**
  String get onboarding_done_view_title;

  /// No description provided for @onboarding_done_view_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You are set up and ready to go'**
  String get onboarding_done_view_subtitle;

  /// No description provided for @onboarding_done_view_action.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go!'**
  String get onboarding_done_view_action;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
