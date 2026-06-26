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

final class TasksCreateRequested extends TasksEvent {
  const TasksCreateRequested({required this.projectId, required this.title});

  final String projectId;
  final String title;

  @override
  List<Object?> get props => [projectId, title];
}

final class TasksUpdateRequested extends TasksEvent {
  const TasksUpdateRequested({required this.taskId, required this.title});

  final String taskId;
  final String title;

  @override
  List<Object?> get props => [taskId, title];
}

final class TasksDeleteRequested extends TasksEvent {
  const TasksDeleteRequested({required this.taskId});

  final String taskId;

  @override
  List<Object?> get props => [taskId];
}
