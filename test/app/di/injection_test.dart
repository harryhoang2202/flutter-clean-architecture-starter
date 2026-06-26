import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture_starter/app/app.dart';
import 'package:flutter_clean_architecture_starter/app/di/app_dependencies.dart';
import 'package:flutter_clean_architecture_starter/app/di/injection.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_environment.dart';
import 'package:flutter_clean_architecture_starter/core/routing/app_routes.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  testWidgets('app can build using configured dependencies', (tester) async {
    final dependencies = GetIt.asNewInstance();
    addTearDown(dependencies.reset);

    configureDependencies(
      instance: dependencies,
      config: const AppConfig(
        environment: AppEnvironment.dev,
        appName: 'Flutter Clean Architecture Starter',
        useFakeApi: true,
      ),
      initialLocation: AppRoutes.authentication,
    );

    await tester.pumpWidget(
      StarterApp(dependencies: AppDependencies.fromGetIt(dependencies)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Authentication'), findsOneWidget);
  });

  testWidgets('auth flow uses dependencies from composition', (tester) async {
    final dependencies = GetIt.asNewInstance();
    addTearDown(dependencies.reset);

    configureDependencies(
      instance: dependencies,
      config: const AppConfig(
        environment: AppEnvironment.dev,
        appName: 'Flutter Clean Architecture Starter',
        useFakeApi: true,
      ),
      initialLocation: AppRoutes.authentication,
    );

    await tester.pumpWidget(
      StarterApp(dependencies: AppDependencies.fromGetIt(dependencies)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('auth-email-field')),
      'demo@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('auth-password-field')),
      'password',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Projects'), findsOneWidget);
    expect(
      dependencies<FakeSessionDataSource>().currentSession?.userId,
      'demo-user',
    );
  });
}
