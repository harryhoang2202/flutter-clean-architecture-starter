import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/datasources/fake_tasks_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/toggle_task_completion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toggling Task completion returns the updated Task', () async {
    final repository = TasksRepositoryImpl(
      remoteDataSource: FakeTasksRemoteDataSource(),
    );
    final toggleTaskCompletion = ToggleTaskCompletion(repository);

    final result = await toggleTaskCompletion(
      const ToggleTaskCompletionParams(taskId: 'load-project-list'),
    );

    expect(result, isA<Success<Task>>());
    expect(result.valueOrNull?.title, 'Load Project List');
    expect(result.valueOrNull?.isCompleted, isTrue);
  });
}
