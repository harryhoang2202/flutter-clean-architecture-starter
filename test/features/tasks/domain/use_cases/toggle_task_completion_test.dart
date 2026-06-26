import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/toggle_task_completion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ToggleTaskCompletion calls repository with Task identity', () async {
    final repository = _SpyTasksRepository(
      toggleResult: const Result.success(
        Task(
          id: 'load-project-list',
          projectId: 'reference-starter',
          title: 'Load Project List',
          isCompleted: true,
        ),
      ),
    );
    final toggleTaskCompletion = ToggleTaskCompletion(repository);

    final result = await toggleTaskCompletion(
      const ToggleTaskCompletionParams(taskId: 'load-project-list'),
    );

    expect(repository.toggleTaskCompletionCalls, ['load-project-list']);
    expect(result, isA<Success<Task>>());
    expect(result.valueOrNull?.title, 'Load Project List');
    expect(result.valueOrNull?.isCompleted, isTrue);
  });
}

class _SpyTasksRepository implements TasksRepository {
  _SpyTasksRepository({required this.toggleResult});

  final Result<Task> toggleResult;
  final List<String> toggleTaskCompletionCalls = [];

  @override
  Future<Result<List<Task>>> loadProjectTasks({required String projectId}) {
    throw UnimplementedError();
  }

  @override
  Future<Result<Task>> toggleTaskCompletion({required String taskId}) async {
    toggleTaskCompletionCalls.add(taskId);
    return toggleResult;
  }

  @override
  Future<Result<Task>> createTask({
    required String projectId,
    required String title,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Result<Task>> updateTask({
    required String taskId,
    required String title,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> deleteTask({required String taskId}) {
    throw UnimplementedError();
  }
}
