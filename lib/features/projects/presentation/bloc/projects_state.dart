part of 'projects_bloc.dart';

sealed class ProjectsState extends Equatable {
  const ProjectsState();

  const factory ProjectsState.initial() = ProjectsInitial;
  const factory ProjectsState.loading() = ProjectsLoading;
  const factory ProjectsState.empty() = ProjectsEmpty;
  const factory ProjectsState.loaded({required List<Project> projects}) =
      ProjectsLoaded;
  const factory ProjectsState.failure({required String message}) =
      ProjectsFailure;

  @override
  List<Object?> get props => [];
}

final class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

final class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

final class ProjectsEmpty extends ProjectsState {
  const ProjectsEmpty();
}

final class ProjectsLoaded extends ProjectsState {
  const ProjectsLoaded({required this.projects});

  final List<Project> projects;

  @override
  List<Object?> get props => [projects];
}

final class ProjectsFailure extends ProjectsState {
  const ProjectsFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
