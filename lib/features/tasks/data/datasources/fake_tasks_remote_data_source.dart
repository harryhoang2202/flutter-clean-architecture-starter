import 'package:flutter_clean_architecture_starter/core/error/remote_exception.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/dtos/task_dto.dart';

class FakeTasksRemoteDataSource {
  FakeTasksRemoteDataSource({
    List<TaskDto> tasks = _defaultTasks,
    RemoteException? loadException,
  }) : _tasks = List.of(tasks),
       _loadException = loadException;

  FakeTasksRemoteDataSource.unavailable()
    : this(
        loadException: const RemoteException(
          message: 'Tasks source is unavailable.',
        ),
      );

  static const _defaultTasks = [
    TaskDto(
      id: 'trace-session-guard',
      projectId: 'reference-starter',
      title: 'Trace Session Guard',
      isCompleted: true,
    ),
    TaskDto(
      id: 'load-project-list',
      projectId: 'reference-starter',
      title: 'Load Project List',
      isCompleted: false,
    ),
    TaskDto(
      id: 'plan-task-scope',
      projectId: 'architecture-cleanup',
      title: 'Plan Task Scope',
      isCompleted: false,
    ),
  ];

  final List<TaskDto> _tasks;
  final RemoteException? _loadException;

  Future<List<TaskDto>> loadProjectTasks({required String projectId}) async {
    final loadException = _loadException;
    if (loadException != null) {
      throw loadException;
    }

    return _tasks.where((task) => task.projectId == projectId).toList();
  }

  Future<TaskDto> toggleTaskCompletion({required String taskId}) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      throw const RemoteException(message: 'Task is unavailable.');
    }

    final updatedTask = _tasks[index].copyWith(
      isCompleted: !_tasks[index].isCompleted,
    );
    _tasks[index] = updatedTask;
    return updatedTask;
  }
}
