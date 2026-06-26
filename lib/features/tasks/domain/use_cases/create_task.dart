import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/repositories/tasks_repository.dart';

class CreateTask extends UseCase<Task, CreateTaskParams> {
  const CreateTask(this._repository);

  final TasksRepository _repository;

  @override
  Future<Result<Task>> call(CreateTaskParams params) {
    return _repository.createTask(
      projectId: params.projectId,
      title: params.title,
    );
  }
}

class CreateTaskParams {
  const CreateTaskParams({required this.projectId, required this.title});

  final String projectId;
  final String title;
}
