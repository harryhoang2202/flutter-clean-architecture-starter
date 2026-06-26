import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/repositories/tasks_repository.dart';

class LoadProjectTasks extends UseCase<List<Task>, LoadProjectTasksParams> {
  const LoadProjectTasks(this._repository);

  final TasksRepository _repository;

  @override
  Future<Result<List<Task>>> call(LoadProjectTasksParams params) {
    return _repository.loadProjectTasks(projectId: params.projectId);
  }
}

class LoadProjectTasksParams {
  const LoadProjectTasksParams({required this.projectId});

  final String projectId;
}
