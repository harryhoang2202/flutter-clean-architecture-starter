import 'package:flutter_clean_architecture_starter/app/app.dart';
import 'package:flutter_clean_architecture_starter/app/di/app_dependencies.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'unauthenticated Session cannot access Projects and is sent to Authentication',
    (tester) async {
      await tester.pumpWidget(
        StarterApp(
          dependencies: AppDependencies.create(
            config: AppConfig(
              environment: AppEnvironment.dev,
              appName: 'Flutter Clean Architecture Starter',
              useFakeApi: true,
            ),
            initialLocation: '/projects',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Authentication'), findsOneWidget);
      expect(find.text('Projects'), findsNothing);
    },
  );
}
