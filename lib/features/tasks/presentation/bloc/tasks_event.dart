part of 'tasks_bloc.dart';

sealed class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

final class TasksLoadRequested extends TasksEvent {
  const TasksLoadRequested({required this.projectId});

  final String projectId;

  @override
  List<Object?> get props => [projectId];
}

final class TasksToggleRequested extends TasksEvent {
  const TasksToggleRequested({required this.taskId});

  final String taskId;

  @override
  List<Object?> get props => [taskId];
}
