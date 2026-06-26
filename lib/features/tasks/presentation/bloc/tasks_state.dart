part of 'tasks_bloc.dart';

sealed class TasksState extends Equatable {
  const TasksState();

  const factory TasksState.initial() = TasksInitial;
  const factory TasksState.loading() = TasksLoading;
  const factory TasksState.empty() = TasksEmpty;
  const factory TasksState.loaded({required List<Task> tasks}) = TasksLoaded;
  const factory TasksState.failure({required String message}) = TasksFailure;

  @override
  List<Object?> get props => [];
}

final class TasksInitial extends TasksState {
  const TasksInitial();
}

final class TasksLoading extends TasksState {
  const TasksLoading();
}

final class TasksEmpty extends TasksState {
  const TasksEmpty();
}

final class TasksLoaded extends TasksState {
  const TasksLoaded({required this.tasks});

  final List<Task> tasks;

  @override
  List<Object?> get props => [tasks];
}

final class TasksFailure extends TasksState {
  const TasksFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
