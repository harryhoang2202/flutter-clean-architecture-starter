import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/error/remote_exception.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/datasources/fake_projects_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/repositories/projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  ProjectsRepositoryImpl({FakeProjectsRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? FakeProjectsRemoteDataSource();

  final FakeProjectsRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<Project>>> loadProjects() async {
    try {
      final projects = await _remoteDataSource.loadProjects();
      return Result.success(
        projects.map((project) => project.toDomain()).toList(),
      );
    } on RemoteException catch (error) {
      return Result.failure(RemoteFailure(message: error.message));
    }
  }

  @override
  Future<Result<Project>> createProject({required String name}) async {
    try {
      final project = await _remoteDataSource.createProject(name: name);
      return Result.success(project.toDomain());
    } on RemoteException catch (error) {
      return Result.failure(RemoteFailure(message: error.message));
    }
  }

  @override
  Future<Result<Project>> updateProject({
    required String projectId,
    required String name,
  }) async {
    try {
      final project = await _remoteDataSource.updateProject(
        projectId: projectId,
        name: name,
      );
      return Result.success(project.toDomain());
    } on RemoteException catch (error) {
      return Result.failure(RemoteFailure(message: error.message));
    }
  }

  @override
  Future<Result<void>> deleteProject({required String projectId}) async {
    try {
      await _remoteDataSource.deleteProject(projectId: projectId);
      return const Result.success(null);
    } on RemoteException catch (error) {
      return Result.failure(RemoteFailure(message: error.message));
    }
  }
}
