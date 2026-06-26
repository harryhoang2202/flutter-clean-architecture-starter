import 'package:flutter_clean_architecture_starter/core/error/remote_exception.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/dtos/project_dto.dart';

class FakeProjectsRemoteDataSource {
  const FakeProjectsRemoteDataSource({
    this.projects = _defaultProjects,
    RemoteException? loadException,
  }) : _loadException = loadException;

  const FakeProjectsRemoteDataSource.unavailable()
    : this(
        loadException: const RemoteException(
          message: 'Projects source is unavailable.',
        ),
      );

  static const _defaultProjects = [
    ProjectDto(id: 'reference-starter', name: 'Reference Starter'),
    ProjectDto(id: 'architecture-cleanup', name: 'Architecture Cleanup'),
  ];

  final List<ProjectDto> projects;
  final RemoteException? _loadException;

  Future<List<ProjectDto>> loadProjects() async {
    final loadException = _loadException;
    if (loadException != null) {
      throw loadException;
    }

    return projects;
  }
}
