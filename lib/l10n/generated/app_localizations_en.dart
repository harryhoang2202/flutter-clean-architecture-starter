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
  String sliceZeroStatus(String environment) {
    return 'Slice 0 is running in $environment mode.';
  }
}
