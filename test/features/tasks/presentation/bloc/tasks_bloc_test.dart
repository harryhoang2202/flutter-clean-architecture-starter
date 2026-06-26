import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/datasources/fake_tasks_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/load_project_tasks.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/toggle_task_completion.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/presentation/bloc/tasks_bloc.dart';

void main() {
  blocTest<TasksBloc, TasksState>(
    'emits loading then success when Project Tasks are available',
    build: () => _buildBloc(FakeTasksRemoteDataSource()),
    act: (bloc) =>
        bloc.add(const TasksLoadRequested(projectId: 'reference-starter')),
    expect: () => [
      const TasksState.loading(),
      const TasksState.loaded(
        tasks: [
          Task(
            id: 'trace-session-guard',
            projectId: 'reference-starter',
            title: 'Trace Session Guard',
            isCompleted: true,
          ),
          Task(
            id: 'load-project-list',
            projectId: 'reference-starter',
            title: 'Load Project List',
            isCompleted: false,
          ),
        ],
      ),
    ],
  );

  blocTest<TasksBloc, TasksState>(
    'emits loading then empty when no Tasks are available',
    build: () => _buildBloc(FakeTasksRemoteDataSource(tasks: [])),
    act: (bloc) =>
        bloc.add(const TasksLoadRequested(projectId: 'reference-starter')),
    expect: () => [const TasksState.loading(), const TasksState.empty()],
  );

  blocTest<TasksBloc, TasksState>(
    'emits loading then failure when Tasks cannot be loaded',
    build: () => _buildBloc(FakeTasksRemoteDataSource.unavailable()),
    act: (bloc) =>
        bloc.add(const TasksLoadRequested(projectId: 'reference-starter')),
    expect: () => [
      const TasksState.loading(),
      const TasksState.failure(message: 'Tasks source is unavailable.'),
    ],
  );

  blocTest<TasksBloc, TasksState>(
    'updates visible Task state when completion is toggled',
    build: () => _buildBloc(FakeTasksRemoteDataSource()),
    seed: () => const TasksState.loaded(
      tasks: [
        Task(
          id: 'load-project-list',
          projectId: 'reference-starter',
          title: 'Load Project List',
          isCompleted: false,
        ),
      ],
    ),
    act: (bloc) =>
        bloc.add(const TasksToggleRequested(taskId: 'load-project-list')),
    expect: () => [
      const TasksState.loaded(
        tasks: [
          Task(
            id: 'load-project-list',
            projectId: 'reference-starter',
            title: 'Load Project List',
            isCompleted: true,
          ),
        ],
      ),
    ],
  );
}

TasksBloc _buildBloc(FakeTasksRemoteDataSource remoteDataSource) {
  final repository = TasksRepositoryImpl(remoteDataSource: remoteDataSource);

  return TasksBloc(
    loadProjectTasks: LoadProjectTasks(repository),
    toggleTaskCompletion: ToggleTaskCompletion(repository),
  );
}
