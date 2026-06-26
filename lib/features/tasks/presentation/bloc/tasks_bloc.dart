import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/create_task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/delete_task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/load_project_tasks.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/toggle_task_completion.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/update_task.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc({
    required LoadProjectTasks loadProjectTasks,
    required ToggleTaskCompletion toggleTaskCompletion,
    required CreateTask createTask,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
  }) : _loadProjectTasks = loadProjectTasks,
       _toggleTaskCompletion = toggleTaskCompletion,
       _createTask = createTask,
       _updateTask = updateTask,
       _deleteTask = deleteTask,
       super(const TasksState.initial()) {
    on<TasksLoadRequested>(_onLoadRequested);
    on<TasksToggleRequested>(_onToggleRequested);
    on<TasksCreateRequested>(_onCreateRequested);
    on<TasksUpdateRequested>(_onUpdateRequested);
    on<TasksDeleteRequested>(_onDeleteRequested);
  }

  final LoadProjectTasks _loadProjectTasks;
  final ToggleTaskCompletion _toggleTaskCompletion;
  final CreateTask _createTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;

  Future<void> _onLoadRequested(
    TasksLoadRequested event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksState.loading());

    final result = await _loadProjectTasks(
      LoadProjectTasksParams(projectId: event.projectId),
    );

    switch (result) {
      case Success(value: final tasks):
        if (tasks.isEmpty) {
          emit(const TasksState.empty());
          return;
        }

        emit(TasksState.loaded(tasks: tasks));
      case FailureResult(failure: final failure):
        emit(TasksState.failure(message: failure.message));
    }
  }

  Future<void> _onToggleRequested(
    TasksToggleRequested event,
    Emitter<TasksState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TasksLoaded) {
      return;
    }

    final result = await _toggleTaskCompletion(
      ToggleTaskCompletionParams(taskId: event.taskId),
    );

    switch (result) {
      case Success(value: final updatedTask):
        emit(
          TasksState.loaded(
            tasks: currentState.tasks
                .map((task) => task.id == updatedTask.id ? updatedTask : task)
                .toList(),
          ),
        );
      case FailureResult(failure: final failure):
        emit(TasksState.failure(message: failure.message));
    }
  }

  Future<void> _onCreateRequested(
    TasksCreateRequested event,
    Emitter<TasksState> emit,
  ) async {
    final previousTasks = _tasksFrom(state);
    final result = await _createTask(
      CreateTaskParams(projectId: event.projectId, title: event.title),
    );

    switch (result) {
      case Success(value: final createdTask):
        emit(TasksState.loaded(tasks: [...previousTasks, createdTask]));
      case FailureResult(failure: final failure):
        emit(TasksState.failure(message: failure.message));
    }
  }

  Future<void> _onUpdateRequested(
    TasksUpdateRequested event,
    Emitter<TasksState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TasksLoaded) {
      return;
    }

    final result = await _updateTask(
      UpdateTaskParams(taskId: event.taskId, title: event.title),
    );

    switch (result) {
      case Success(value: final updatedTask):
        emit(
          TasksState.loaded(
            tasks: currentState.tasks
                .map((task) => task.id == updatedTask.id ? updatedTask : task)
                .toList(),
          ),
        );
      case FailureResult(failure: final failure):
        emit(TasksState.failure(message: failure.message));
    }
  }

  Future<void> _onDeleteRequested(
    TasksDeleteRequested event,
    Emitter<TasksState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TasksLoaded) {
      return;
    }

    final result = await _deleteTask(DeleteTaskParams(taskId: event.taskId));

    switch (result) {
      case Success():
        final tasks = currentState.tasks
            .where((task) => task.id != event.taskId)
            .toList();
        emit(
          tasks.isEmpty
              ? const TasksState.empty()
              : TasksState.loaded(tasks: tasks),
        );
      case FailureResult(failure: final failure):
        emit(TasksState.failure(message: failure.message));
    }
  }

  List<Task> _tasksFrom(TasksState state) {
    return switch (state) {
      TasksLoaded(:final tasks) => tasks,
      _ => const [],
    };
  }
}
