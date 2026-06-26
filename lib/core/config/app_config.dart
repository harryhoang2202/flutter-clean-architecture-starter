import 'package:flutter_clean_architecture_starter/core/config/app_environment.dart';

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.appName,
    required this.useFakeApi,
  });

  final AppEnvironment environment;
  final String appName;
  final bool useFakeApi;

  bool get isDev => environment == AppEnvironment.dev;
}
