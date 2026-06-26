import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/datasources/fake_tasks_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('repository creates, updates, and deletes Tasks', () async {
    final repository = TasksRepositoryImpl(
      remoteDataSource: FakeTasksRemoteDataSource(tasks: []),
    );

    final createResult = await repository.createTask(
      projectId: 'reference-starter',
      title: 'Write CRUD Tests',
    );
    expect(
      createResult.valueOrNull,
      const Task(
        id: 'write-crud-tests',
        projectId: 'reference-starter',
        title: 'Write CRUD Tests',
        isCompleted: false,
      ),
    );

    final updateResult = await repository.updateTask(
      taskId: 'write-crud-tests',
      title: 'Write Better CRUD Tests',
    );
    expect(
      updateResult.valueOrNull,
      const Task(
        id: 'write-crud-tests',
        projectId: 'reference-starter',
        title: 'Write Better CRUD Tests',
        isCompleted: false,
      ),
    );

    final deleteResult = await repository.deleteTask(
      taskId: 'write-crud-tests',
    );
    expect(deleteResult, isA<Success<void>>());

    final loadResult = await repository.loadProjectTasks(
      projectId: 'reference-starter',
    );
    expect(loadResult.valueOrNull, isEmpty);
  });

  test('repository maps unavailable Tasks source to NetworkFailure', () async {
    final repository = TasksRepositoryImpl(
      remoteDataSource: FakeTasksRemoteDataSource.unavailable(),
    );

    final result = await repository.loadProjectTasks(
      projectId: 'reference-starter',
    );

    expect(result, isA<FailureResult<List<Task>>>());
    expect(result.failureOrNull, isA<NetworkFailure>());
    expect(result.failureOrNull?.message, 'Tasks source is unavailable.');
  });

  test('repository maps invalid Task title to ValidationFailure', () async {
    final repository = TasksRepositoryImpl(
      remoteDataSource: FakeTasksRemoteDataSource(tasks: []),
    );

    final result = await repository.createTask(
      projectId: 'reference-starter',
      title: '',
    );

    expect(result, isA<FailureResult<Task>>());
    final failure = result.failureOrNull;
    expect(failure, isA<ValidationFailure>());
    expect(failure?.message, 'Task title is required.');
    expect((failure as ValidationFailure).fieldErrors, {
      'title': 'Task title is required.',
    });
  });

  test('repository maps missing Task to NotFoundFailure', () async {
    final repository = TasksRepositoryImpl(
      remoteDataSource: FakeTasksRemoteDataSource(tasks: []),
    );

    final result = await repository.toggleTaskCompletion(
      taskId: 'missing-task',
    );

    expect(result, isA<FailureResult<Task>>());
    expect(result.failureOrNull, isA<NotFoundFailure>());
    expect(result.failureOrNull?.message, 'Task was not found.');
  });
}
