import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/repositories/tasks_repository.dart';

class DeleteTask extends UseCase<void, DeleteTaskParams> {
  const DeleteTask(this._repository);

  final TasksRepository _repository;

  @override
  Future<Result<void>> call(DeleteTaskParams params) {
    return _repository.deleteTask(taskId: params.taskId);
  }
}

class DeleteTaskParams {
  const DeleteTaskParams({required this.taskId});

  final String taskId;
}
