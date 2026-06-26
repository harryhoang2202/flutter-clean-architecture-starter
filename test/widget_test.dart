import 'package:flutter_clean_architecture_starter/app/app.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('starter shell describes the reference app', (tester) async {
    await tester.pumpWidget(
      StarterApp(
        config: AppConfig(
          environment: AppEnvironment.dev,
          appName: 'Flutter Clean Architecture Starter',
          useFakeApi: true,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Flutter Clean Architecture Starter'), findsWidgets);
    expect(find.text('Project Management Reference Starter'), findsOneWidget);
  });
}
