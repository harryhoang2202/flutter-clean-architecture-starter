import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/datasources/fake_tasks_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/dtos/task_dto.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/create_task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/delete_task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/load_project_tasks.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/toggle_task_completion.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/update_task.dart';
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

  blocTest<TasksBloc, TasksState>(
    'adds a created Task to the visible list',
    build: () => _buildBloc(FakeTasksRemoteDataSource(tasks: [])),
    seed: () => const TasksState.empty(),
    act: (bloc) => bloc.add(
      const TasksCreateRequested(
        projectId: 'reference-starter',
        title: 'Write CRUD Tests',
      ),
    ),
    expect: () => [
      const TasksState.loaded(
        tasks: [
          Task(
            id: 'write-crud-tests',
            projectId: 'reference-starter',
            title: 'Write CRUD Tests',
            isCompleted: false,
          ),
        ],
      ),
    ],
  );

  blocTest<TasksBloc, TasksState>(
    'updates a visible Task',
    build: () => _buildBloc(
      FakeTasksRemoteDataSource(
        tasks: const [
          TaskDto(
            id: 'write-tests',
            projectId: 'reference-starter',
            title: 'Write Tests',
            isCompleted: false,
          ),
        ],
      ),
    ),
    seed: () => const TasksState.loaded(
      tasks: [
        Task(
          id: 'write-tests',
          projectId: 'reference-starter',
          title: 'Write Tests',
          isCompleted: false,
        ),
      ],
    ),
    act: (bloc) => bloc.add(
      const TasksUpdateRequested(
        taskId: 'write-tests',
        title: 'Write Better Tests',
      ),
    ),
    expect: () => [
      const TasksState.loaded(
        tasks: [
          Task(
            id: 'write-tests',
            projectId: 'reference-starter',
            title: 'Write Better Tests',
            isCompleted: false,
          ),
        ],
      ),
    ],
  );

  blocTest<TasksBloc, TasksState>(
    'deletes a visible Task',
    build: () => _buildBloc(
      FakeTasksRemoteDataSource(
        tasks: const [
          TaskDto(
            id: 'write-tests',
            projectId: 'reference-starter',
            title: 'Write Tests',
            isCompleted: false,
          ),
        ],
      ),
    ),
    seed: () => const TasksState.loaded(
      tasks: [
        Task(
          id: 'write-tests',
          projectId: 'reference-starter',
          title: 'Write Tests',
          isCompleted: false,
        ),
      ],
    ),
    act: (bloc) => bloc.add(const TasksDeleteRequested(taskId: 'write-tests')),
    expect: () => [const TasksState.empty()],
  );
}

TasksBloc _buildBloc(FakeTasksRemoteDataSource remoteDataSource) {
  final repository = TasksRepositoryImpl(remoteDataSource: remoteDataSource);

  return TasksBloc(
    loadProjectTasks: LoadProjectTasks(repository),
    toggleTaskCompletion: ToggleTaskCompletion(repository),
    createTask: CreateTask(repository),
    updateTask: UpdateTask(repository),
    deleteTask: DeleteTask(repository),
  );
}
