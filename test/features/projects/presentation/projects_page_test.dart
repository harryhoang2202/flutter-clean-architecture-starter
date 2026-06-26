import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/app/app.dart';
import 'package:flutter_clean_architecture_starter/app/di/app_dependencies.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_environment.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/datasources/fake_projects_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/create_project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/delete_project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/load_projects.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/update_project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/pages/projects_page.dart';
import 'package:flutter_clean_architecture_starter/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('authenticated user can load Projects', (tester) async {
    await tester.pumpWidget(
      StarterApp(
        dependencies: AppDependencies.create(
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
              _buildBloc(repository)..add(const ProjectsLoadRequested()),
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
              _buildBloc(repository)..add(const ProjectsLoadRequested()),
          child: const ProjectsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Projects source is unavailable.'), findsOneWidget);
  });

  testWidgets('user can create a Project', (tester) async {
    final repository = ProjectsRepositoryImpl(
      remoteDataSource: FakeProjectsRemoteDataSource(projects: []),
    );

    await tester.pumpWidget(
      _LocalizedTestApp(
        home: BlocProvider(
          create: (_) =>
              _buildBloc(repository)..add(const ProjectsLoadRequested()),
          child: const ProjectsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('create-project-action')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('project-name-field')),
      'Mobile App',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Mobile App'), findsOneWidget);
  });
}

ProjectsBloc _buildBloc(ProjectsRepositoryImpl repository) {
  return ProjectsBloc(
    loadProjects: LoadProjects(repository),
    createProject: CreateProject(repository),
    updateProject: UpdateProject(repository),
    deleteProject: DeleteProject(repository),
  );
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
