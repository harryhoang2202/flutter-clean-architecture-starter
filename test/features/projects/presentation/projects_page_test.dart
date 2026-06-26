import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/app/app.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_environment.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/datasources/fake_projects_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/load_projects.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/pages/projects_page.dart';
import 'package:flutter_clean_architecture_starter/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('authenticated user can load Projects', (tester) async {
    await tester.pumpWidget(
      StarterApp(
        config: AppConfig(
          environment: AppEnvironment.dev,
          appName: 'Flutter Clean Architecture Starter',
          useFakeApi: true,
        ),
        initialLocation: '/projects',
        sessionDataSource: FakeSessionDataSource(
          initialSession: const Session(userId: 'demo-user'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('Reference Starter'), findsOneWidget);
    expect(find.text('Architecture Cleanup'), findsOneWidget);
  });

  testWidgets('empty Project list has an explicit empty state', (tester) async {
    final repository = ProjectsRepositoryImpl(
      remoteDataSource: FakeProjectsRemoteDataSource(projects: []),
    );

    await tester.pumpWidget(
      _LocalizedTestApp(
        home: BlocProvider(
          create: (_) =>
              ProjectsBloc(loadProjects: LoadProjects(repository))
                ..add(const ProjectsLoadRequested()),
          child: const ProjectsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('No Projects yet.'), findsOneWidget);
  });

  testWidgets('fake remote project failure becomes a presentation failure', (
    tester,
  ) async {
    final repository = ProjectsRepositoryImpl(
      remoteDataSource: FakeProjectsRemoteDataSource.unavailable(),
    );

    await tester.pumpWidget(
      _LocalizedTestApp(
        home: BlocProvider(
          create: (_) =>
              ProjectsBloc(loadProjects: LoadProjects(repository))
                ..add(const ProjectsLoadRequested()),
          child: const ProjectsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Projects source is unavailable.'), findsOneWidget);
  });
}

class _LocalizedTestApp extends StatelessWidget {
  const _LocalizedTestApp({required this.home});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );
  }
}
