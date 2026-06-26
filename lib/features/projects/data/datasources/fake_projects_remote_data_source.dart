import 'package:flutter_clean_architecture_starter/core/error/remote_exception.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/dtos/project_dto.dart';

class FakeProjectsRemoteDataSource {
  FakeProjectsRemoteDataSource({
    List<ProjectDto> projects = _defaultProjects,
    RemoteException? loadException,
  }) : _projects = List.of(projects),
       _loadException = loadException;

  FakeProjectsRemoteDataSource.unavailable()
    : this(
        loadException: const RemoteException.network(
          message: 'Projects source is unavailable.',
        ),
      );

  static const _defaultProjects = [
    ProjectDto(id: 'reference-starter', name: 'Reference Starter'),
    ProjectDto(id: 'architecture-cleanup', name: 'Architecture Cleanup'),
  ];

  final List<ProjectDto> _projects;
  final RemoteException? _loadException;

  Future<List<ProjectDto>> loadProjects() async {
    final loadException = _loadException;
    if (loadException != null) {
      throw loadException;
    }

    return List.unmodifiable(_projects);
  }

  Future<ProjectDto> createProject({required String name}) async {
    _validateProjectName(name);
    final project = ProjectDto(id: _uniqueIdFor(name), name: name);
    _projects.add(project);
    return project;
  }

  Future<ProjectDto> updateProject({
    required String projectId,
    required String name,
  }) async {
    _validateProjectName(name);
    final index = _indexOf(projectId);
    final updatedProject = _projects[index].copyWith(name: name);
    _projects[index] = updatedProject;
    return updatedProject;
  }

  Future<void> deleteProject({required String projectId}) async {
    _projects.removeAt(_indexOf(projectId));
  }

  int _indexOf(String projectId) {
    final index = _projects.indexWhere((project) => project.id == projectId);
    if (index == -1) {
      throw const RemoteException.notFound(message: 'Project was not found.');
    }

    return index;
  }

  void _validateProjectName(String name) {
    if (name.trim().isEmpty) {
      throw const RemoteException.validation(
        message: 'Project name is required.',
        fieldErrors: {'name': 'Project name is required.'},
      );
    }
  }

  String _uniqueIdFor(String name) {
    final slug = name
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final base = slug.isEmpty ? 'project' : slug;

    var candidate = base;
    var suffix = 2;
    while (_projects.any((project) => project.id == candidate)) {
      candidate = '$base-$suffix';
      suffix += 1;
    }

    return candidate;
  }
}
