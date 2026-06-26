import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/datasources/fake_tasks_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
