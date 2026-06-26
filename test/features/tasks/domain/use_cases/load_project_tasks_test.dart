import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/datasources/fake_tasks_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/load_project_tasks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Tasks returned for one Project exclude Tasks from other Projects',
    () async {
      final repository = TasksRepositoryImpl(
        remoteDataSource: FakeTasksRemoteDataSource(),
      );
      final loadProjectTasks = LoadProjectTasks(repository);

      final result = await loadProjectTasks(
        const LoadProjectTasksParams(projectId: 'reference-starter'),
      );

      expect(result, isA<Success<List<Task>>>());
      expect(
        result.valueOrNull?.map((task) => task.title),
        containsAll(['Trace Session Guard', 'Load Project List']),
      );
      expect(
        result.valueOrNull?.map((task) => task.title),
        isNot(contains('Plan Task Scope')),
      );
    },
  );
}
