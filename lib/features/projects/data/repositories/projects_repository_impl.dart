import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/error/remote_exception.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/datasources/fake_projects_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/repositories/projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  const ProjectsRepositoryImpl({
    FakeProjectsRemoteDataSource remoteDataSource =
        const FakeProjectsRemoteDataSource(),
  }) : _remoteDataSource = remoteDataSource;

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
}
