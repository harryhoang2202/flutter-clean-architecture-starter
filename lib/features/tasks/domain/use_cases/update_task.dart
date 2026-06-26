import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/repositories/tasks_repository.dart';

class UpdateTask extends UseCase<Task, UpdateTaskParams> {
  const UpdateTask(this._repository);

  final TasksRepository _repository;

  @override
  Future<Result<Task>> call(UpdateTaskParams params) {
    return _repository.updateTask(taskId: params.taskId, title: params.title);
  }
}

class UpdateTaskParams {
  const UpdateTaskParams({required this.taskId, required this.title});

  final String taskId;
  final String title;
}
