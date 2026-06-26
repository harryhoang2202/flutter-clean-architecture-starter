import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/load_project_tasks.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/toggle_task_completion.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc({
    required LoadProjectTasks loadProjectTasks,
    required ToggleTaskCompletion toggleTaskCompletion,
  }) : _loadProjectTasks = loadProjectTasks,
       _toggleTaskCompletion = toggleTaskCompletion,
       super(const TasksState.initial()) {
    on<TasksLoadRequested>(_onLoadRequested);
    on<TasksToggleRequested>(_onToggleRequested);
  }

  final LoadProjectTasks _loadProjectTasks;
  final ToggleTaskCompletion _toggleTaskCompletion;

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
}
