import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/repositories/tasks_repository.dart';

class ToggleTaskCompletion extends UseCase<Task, ToggleTaskCompletionParams> {
  const ToggleTaskCompletion(this._repository);

  final TasksRepository _repository;

  @override
  Future<Result<Task>> call(ToggleTaskCompletionParams params) {
    return _repository.toggleTaskCompletion(taskId: params.taskId);
  }
}

class ToggleTaskCompletionParams {
  const ToggleTaskCompletionParams({required this.taskId});

  final String taskId;
}
