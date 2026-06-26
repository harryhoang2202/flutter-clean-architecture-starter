import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture_starter/app/app.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_environment.dart';
import 'package:flutter_clean_architecture_starter/core/di/app_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('accepted credentials on Authentication page open Projects', (
    tester,
  ) async {
    await tester.pumpWidget(
      StarterApp(
        dependencies: AppDependencies.create(
          config: AppConfig(
            environment: AppEnvironment.dev,
            appName: 'Flutter Clean Architecture Starter',
            useFakeApi: true,
          ),
          initialLocation: '/authentication',
        ),
      ),
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
  });
}
