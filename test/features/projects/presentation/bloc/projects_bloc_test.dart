import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/datasources/fake_projects_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/dtos/project_dto.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/load_projects.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/bloc/projects_bloc.dart';

void main() {
  blocTest<ProjectsBloc, ProjectsState>(
    'emits loading then success when Projects are available',
    build: () {
      final repository = ProjectsRepositoryImpl(
        remoteDataSource: FakeProjectsRemoteDataSource(
          projects: [
            ProjectDto(id: 'reference-starter', name: 'Reference Starter'),
          ],
        ),
      );

      return ProjectsBloc(loadProjects: LoadProjects(repository));
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

      return ProjectsBloc(loadProjects: LoadProjects(repository));
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

      return ProjectsBloc(loadProjects: LoadProjects(repository));
    },
    act: (bloc) => bloc.add(const ProjectsLoadRequested()),
    expect: () => [
      const ProjectsState.loading(),
      const ProjectsState.failure(message: 'Projects source is unavailable.'),
    ],
  );
}
