import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_starter/app/app.dart';
import 'package:flutter_clean_architecture_starter/app/di/app_dependencies.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'user signs in, opens Project Tasks, toggles a Task, signs out, and returns to Authentication',
    (tester) async {
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
      await tester.tap(find.text('Reference Starter'));
      await tester.pumpAndSettle();

      expect(find.text('Trace Session Guard'), findsOneWidget);
      expect(find.text('Load Project List'), findsOneWidget);

      final taskTile = find.widgetWithText(
        CheckboxListTile,
        'Load Project List',
      );
      Checkbox checkbox() {
        return tester.widget<Checkbox>(
          find.descendant(of: taskTile, matching: find.byType(Checkbox)),
        );
      }

      expect(checkbox().value, isFalse);

      await tester.tap(taskTile);
      await tester.pumpAndSettle();

      expect(checkbox().value, isTrue);

      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();

      expect(find.text('Authentication'), findsOneWidget);
      expect(find.text('Projects'), findsNothing);
    },
  );
}
