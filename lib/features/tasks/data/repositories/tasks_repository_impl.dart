import 'package:flutter_clean_architecture_starter/core/error/remote_exception.dart';
import 'package:flutter_clean_architecture_starter/core/error/remote_failure_mapper.dart';
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
      return Result.failure(failureFromRemoteException(error));
    }
  }

  @override
  Future<Result<Task>> toggleTaskCompletion({required String taskId}) async {
    try {
      final task = await _remoteDataSource.toggleTaskCompletion(taskId: taskId);
      return Result.success(task.toDomain());
    } on RemoteException catch (error) {
      return Result.failure(failureFromRemoteException(error));
    }
  }

  @override
  Future<Result<Task>> createTask({
    required String projectId,
    required String title,
  }) async {
    try {
      final task = await _remoteDataSource.createTask(
        projectId: projectId,
        title: title,
      );
      return Result.success(task.toDomain());
    } on RemoteException catch (error) {
      return Result.failure(failureFromRemoteException(error));
    }
  }

  @override
  Future<Result<Task>> updateTask({
    required String taskId,
    required String title,
  }) async {
    try {
      final task = await _remoteDataSource.updateTask(
        taskId: taskId,
        title: title,
      );
      return Result.success(task.toDomain());
    } on RemoteException catch (error) {
      return Result.failure(failureFromRemoteException(error));
    }
  }

  @override
  Future<Result<void>> deleteTask({required String taskId}) async {
    try {
      await _remoteDataSource.deleteTask(taskId: taskId);
      return const Result.success(null);
    } on RemoteException catch (error) {
      return Result.failure(failureFromRemoteException(error));
    }
  }
}
