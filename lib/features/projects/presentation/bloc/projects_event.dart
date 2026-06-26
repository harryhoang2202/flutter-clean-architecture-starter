part of 'projects_bloc.dart';

sealed class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

final class ProjectsLoadRequested extends ProjectsEvent {
  const ProjectsLoadRequested();
}

final class ProjectsCreateRequested extends ProjectsEvent {
  const ProjectsCreateRequested({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

final class ProjectsUpdateRequested extends ProjectsEvent {
  const ProjectsUpdateRequested({required this.projectId, required this.name});

  final String projectId;
  final String name;

  @override
  List<Object?> get props => [projectId, name];
}

final class ProjectsDeleteRequested extends ProjectsEvent {
  const ProjectsDeleteRequested({required this.projectId});

  final String projectId;

  @override
  List<Object?> get props => [projectId];
}
