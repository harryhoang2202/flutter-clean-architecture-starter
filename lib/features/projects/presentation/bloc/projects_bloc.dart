import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/load_projects.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc({required LoadProjects loadProjects})
    : _loadProjects = loadProjects,
      super(const ProjectsState.initial()) {
    on<ProjectsLoadRequested>(_onLoadRequested);
  }

  final LoadProjects _loadProjects;

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
}
