import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/create_project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/delete_project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/load_projects.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/update_project.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc({
    required LoadProjects loadProjects,
    required CreateProject createProject,
    required UpdateProject updateProject,
    required DeleteProject deleteProject,
  }) : _loadProjects = loadProjects,
       _createProject = createProject,
       _updateProject = updateProject,
       _deleteProject = deleteProject,
       super(const ProjectsState.initial()) {
    on<ProjectsLoadRequested>(_onLoadRequested);
    on<ProjectsCreateRequested>(_onCreateRequested);
    on<ProjectsUpdateRequested>(_onUpdateRequested);
    on<ProjectsDeleteRequested>(_onDeleteRequested);
  }

  final LoadProjects _loadProjects;
  final CreateProject _createProject;
  final UpdateProject _updateProject;
  final DeleteProject _deleteProject;

  Future<void> _onLoadRequested(
    ProjectsLoadRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(const ProjectsState.loading());

    final result = await _loadProjects(const NoParams());

    switch (result) {
      case Success(value: final projects):
        if (projects.isEmpty) {
          emit(const ProjectsState.empty());
          return;
        }

        emit(ProjectsState.loaded(projects: projects));
      case FailureResult(failure: final failure):
        emit(ProjectsState.failure(message: failure.message));
    }
  }

  Future<void> _onCreateRequested(
    ProjectsCreateRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    final previousProjects = _projectsFrom(state);
    final result = await _createProject(CreateProjectParams(name: event.name));

    switch (result) {
      case Success(value: final createdProject):
        emit(
          ProjectsState.loaded(projects: [...previousProjects, createdProject]),
        );
      case FailureResult(failure: final failure):
        emit(ProjectsState.failure(message: failure.message));
    }
  }

  Future<void> _onUpdateRequested(
    ProjectsUpdateRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProjectsLoaded) {
      return;
    }

    final result = await _updateProject(
      UpdateProjectParams(projectId: event.projectId, name: event.name),
    );

    switch (result) {
      case Success(value: final updatedProject):
        emit(
          ProjectsState.loaded(
            projects: currentState.projects
                .map(
                  (project) => project.id == updatedProject.id
                      ? updatedProject
                      : project,
                )
                .toList(),
          ),
        );
      case FailureResult(failure: final failure):
        emit(ProjectsState.failure(message: failure.message));
    }
  }

  Future<void> _onDeleteRequested(
    ProjectsDeleteRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProjectsLoaded) {
      return;
    }

    final result = await _deleteProject(
      DeleteProjectParams(projectId: event.projectId),
    );

    switch (result) {
      case Success():
        final projects = currentState.projects
            .where((project) => project.id != event.projectId)
            .toList();
        emit(
          projects.isEmpty
              ? const ProjectsState.empty()
              : ProjectsState.loaded(projects: projects),
        );
      case FailureResult(failure: final failure):
        emit(ProjectsState.failure(message: failure.message));
    }
  }

  List<Project> _projectsFrom(ProjectsState state) {
    return switch (state) {
      ProjectsLoaded(:final projects) => projects,
      _ => const [],
    };
  }
}
