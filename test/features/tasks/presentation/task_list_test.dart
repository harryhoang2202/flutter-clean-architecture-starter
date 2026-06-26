import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/app/app.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_environment.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/pages/project_detail_page.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/datasources/fake_tasks_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/load_project_tasks.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/toggle_task_completion.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:flutter_clean_architecture_starter/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('loading Tasks requires a Project identity', (tester) async {
    await tester.pumpWidget(
      StarterApp(
        config: AppConfig(
          environment: AppEnvironment.dev,
          appName: 'Flutter Clean Architecture Starter',
          useFakeApi: true,
        ),
        initialLocation: '/projects/reference-starter',
        sessionDataSource: FakeSessionDataSource(
          initialSession: const Session(userId: 'demo-user'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Reference Starter'), findsOneWidget);
    expect(find.text('Trace Session Guard'), findsOneWidget);
    expect(find.text('Plan Task Scope'), findsNothing);
  });

  testWidgets('empty Task list has an explicit empty state', (tester) async {
    const projectId = 'reference-starter';
    final repository = TasksRepositoryImpl(
      remoteDataSource: FakeTasksRemoteDataSource(tasks: []),
    );

    await tester.pumpWidget(
      _LocalizedTestApp(
        home: BlocProvider(
          create: (_) => TasksBloc(
            loadProjectTasks: LoadProjectTasks(repository),
            toggleTaskCompletion: ToggleTaskCompletion(repository),
          )..add(const TasksLoadRequested(projectId: projectId)),
          child: const ProjectDetailPage(projectId: projectId),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Reference Starter'), findsOneWidget);
    expect(find.text('No Tasks yet.'), findsOneWidget);
  });

  testWidgets('fake remote task failure becomes a presentation failure', (
    tester,
  ) async {
    const projectId = 'reference-starter';
    final repository = TasksRepositoryImpl(
      remoteDataSource: FakeTasksRemoteDataSource.unavailable(),
    );

    await tester.pumpWidget(
      _LocalizedTestApp(
        home: BlocProvider(
          create: (_) => TasksBloc(
            loadProjectTasks: LoadProjectTasks(repository),
            toggleTaskCompletion: ToggleTaskCompletion(repository),
          )..add(const TasksLoadRequested(projectId: projectId)),
          child: const ProjectDetailPage(projectId: projectId),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Tasks source is unavailable.'), findsOneWidget);
  });

  testWidgets('toggling Task completion updates visible Task state', (
    tester,
  ) async {
    const projectId = 'reference-starter';
    final repository = TasksRepositoryImpl(
      remoteDataSource: FakeTasksRemoteDataSource(),
    );

    await tester.pumpWidget(
      _LocalizedTestApp(
        home: BlocProvider(
          create: (_) => TasksBloc(
            loadProjectTasks: LoadProjectTasks(repository),
            toggleTaskCompletion: ToggleTaskCompletion(repository),
          )..add(const TasksLoadRequested(projectId: projectId)),
          child: const ProjectDetailPage(projectId: projectId),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final taskTile = find.widgetWithText(CheckboxListTile, 'Load Project List');
    Checkbox checkbox() {
      return tester.widget<Checkbox>(
        find.descendant(of: taskTile, matching: find.byType(Checkbox)),
      );
    }

    expect(checkbox().value, isFalse);

    await tester.tap(taskTile);
    await tester.pumpAndSettle();

    expect(checkbox().value, isTrue);
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
