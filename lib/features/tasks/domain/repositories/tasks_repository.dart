import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';

abstract class TasksRepository {
  Future<Result<List<Task>>> loadProjectTasks({required String projectId});

  Future<Result<Task>> toggleTaskCompletion({required String taskId});
}
