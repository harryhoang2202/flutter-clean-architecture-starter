import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/error/remote_exception.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/datasources/fake_tasks_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/repositories/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  TasksRepositoryImpl({FakeTasksRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? FakeTasksRemoteDataSource();

  final FakeTasksRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<Task>>> loadProjectTasks({
    required String projectId,
  }) async {
    try {
      final tasks = await _remoteDataSource.loadProjectTasks(
        projectId: projectId,
      );
      return Result.success(tasks.map((task) => task.toDomain()).toList());
    } on RemoteException catch (error) {
      return Result.failure(RemoteFailure(message: error.message));
    }
  }

  @override
  Future<Result<Task>> toggleTaskCompletion({required String taskId}) async {
    try {
      final task = await _remoteDataSource.toggleTaskCompletion(taskId: taskId);
      return Result.success(task.toDomain());
    } on RemoteException catch (error) {
      return Result.failure(RemoteFailure(message: error.message));
    }
  }
}
