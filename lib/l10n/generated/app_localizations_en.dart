// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Clean Architecture Starter';

  @override
  String get referenceStarterSubtitle => 'Project Management Reference Starter';

  @override
  String get authenticationTitle => 'Authentication';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signInAction => 'Sign in';

  @override
  String get signOutAction => 'Sign out';

  @override
  String get projectsTitle => 'Projects';

  @override
  String get noProjectsMessage => 'No Projects yet.';

  @override
  String get noTasksMessage => 'No Tasks yet.';

  @override
  String get referenceStarterProjectTitle => 'Reference Starter';

  @override
  String get architectureCleanupProjectTitle => 'Architecture Cleanup';

  @override
  String sliceZeroStatus(String environment) {
    return 'Slice 0 is running in $environment mode.';
  }
}
