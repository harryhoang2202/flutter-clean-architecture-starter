import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/datasources/fake_projects_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/dtos/project_dto.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/create_project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/delete_project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/load_projects.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/update_project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/bloc/projects_bloc.dart';

void main() {
  blocTest<ProjectsBloc, ProjectsState>(
    'emits loading then loaded when Projects are available',
    build: () {
      final repository = ProjectsRepositoryImpl(
        remoteDataSource: FakeProjectsRemoteDataSource(
          projects: [
            ProjectDto(id: 'reference-starter', name: 'Reference Starter'),
          ],
        ),
      );

      return _buildBloc(repository);
    },
    act: (bloc) => bloc.add(const ProjectsLoadRequested()),
    expect: () => [
      const ProjectsState.loading(),
      const ProjectsState.loaded(
        projects: [Project(id: 'reference-starter', name: 'Reference Starter')],
      ),
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'emits loading then empty when no Projects are available',
    build: () {
      final repository = ProjectsRepositoryImpl(
        remoteDataSource: FakeProjectsRemoteDataSource(projects: []),
      );

      return _buildBloc(repository);
    },
    act: (bloc) => bloc.add(const ProjectsLoadRequested()),
    expect: () => [const ProjectsState.loading(), const ProjectsState.empty()],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'emits loading then failure when Projects cannot be loaded',
    build: () {
      final repository = ProjectsRepositoryImpl(
        remoteDataSource: FakeProjectsRemoteDataSource.unavailable(),
      );

      return _buildBloc(repository);
    },
    act: (bloc) => bloc.add(const ProjectsLoadRequested()),
    expect: () => [
      const ProjectsState.loading(),
      const ProjectsState.failure(message: 'Projects source is unavailable.'),
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'updates list after create',
    build: () => _buildBloc(
      ProjectsRepositoryImpl(
        remoteDataSource: FakeProjectsRemoteDataSource(projects: []),
      ),
    ),
    seed: () => const ProjectsState.empty(),
    act: (bloc) => bloc.add(const ProjectsCreateRequested(name: 'Mobile App')),
    expect: () => [
      const ProjectsState.loaded(
        projects: [Project(id: 'mobile-app', name: 'Mobile App')],
      ),
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'updates list after update',
    build: () => _buildBloc(
      ProjectsRepositoryImpl(
        remoteDataSource: FakeProjectsRemoteDataSource(
          projects: [ProjectDto(id: 'mobile-app', name: 'Mobile App')],
        ),
      ),
    ),
    seed: () => const ProjectsState.loaded(
      projects: [Project(id: 'mobile-app', name: 'Mobile App')],
    ),
    act: (bloc) => bloc.add(
      const ProjectsUpdateRequested(
        projectId: 'mobile-app',
        name: 'Mobile App v2',
      ),
    ),
    expect: () => [
      const ProjectsState.loaded(
        projects: [Project(id: 'mobile-app', name: 'Mobile App v2')],
      ),
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'updates list after delete',
    build: () => _buildBloc(
      ProjectsRepositoryImpl(
        remoteDataSource: FakeProjectsRemoteDataSource(
          projects: [ProjectDto(id: 'mobile-app', name: 'Mobile App')],
        ),
      ),
    ),
    seed: () => const ProjectsState.loaded(
      projects: [Project(id: 'mobile-app', name: 'Mobile App')],
    ),
    act: (bloc) =>
        bloc.add(const ProjectsDeleteRequested(projectId: 'mobile-app')),
    expect: () => [const ProjectsState.empty()],
  );
}

ProjectsBloc _buildBloc(ProjectsRepositoryImpl repository) {
  return ProjectsBloc(
    loadProjects: LoadProjects(repository),
    createProject: CreateProject(repository),
    updateProject: UpdateProject(repository),
    deleteProject: DeleteProject(repository),
  );
}
