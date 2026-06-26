import 'package:flutter_clean_architecture_starter/app/app.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_environment.dart';

void main() {
  runStarterApp(
    const AppConfig(
      environment: AppEnvironment.dev,
      appName: 'Flutter Clean Architecture Starter',
      useFakeApi: true,
    ),
  );
}
