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

  test('repository maps fake remote task failure into a Failure', () async {
    final repository = TasksRepositoryImpl(
      remoteDataSource: FakeTasksRemoteDataSource.unavailable(),
    );

    final result = await repository.loadProjectTasks(
      projectId: 'reference-starter',
    );

    expect(result, isA<FailureResult<List<Task>>>());
    expect(result.failureOrNull, isA<RemoteFailure>());
    expect(result.failureOrNull?.message, 'Tasks source is unavailable.');
  });
}
