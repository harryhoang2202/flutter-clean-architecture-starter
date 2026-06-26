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
        loadException: const RemoteException.network(
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
    final index = _indexOf(taskId);
    final updatedTask = _tasks[index].copyWith(
      isCompleted: !_tasks[index].isCompleted,
    );
    _tasks[index] = updatedTask;
    return updatedTask;
  }

  Future<TaskDto> createTask({
    required String projectId,
    required String title,
  }) async {
    _validateTaskTitle(title);
    final task = TaskDto(
      id: _uniqueIdFor(title),
      projectId: projectId,
      title: title,
      isCompleted: false,
    );
    _tasks.add(task);
    return task;
  }

  Future<TaskDto> updateTask({
    required String taskId,
    required String title,
  }) async {
    _validateTaskTitle(title);
    final index = _indexOf(taskId);
    final updatedTask = _tasks[index].copyWith(title: title);
    _tasks[index] = updatedTask;
    return updatedTask;
  }

  Future<void> deleteTask({required String taskId}) async {
    _tasks.removeAt(_indexOf(taskId));
  }

  int _indexOf(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      throw const RemoteException.notFound(message: 'Task was not found.');
    }

    return index;
  }

  void _validateTaskTitle(String title) {
    if (title.trim().isEmpty) {
      throw const RemoteException.validation(
        message: 'Task title is required.',
        fieldErrors: {'title': 'Task title is required.'},
      );
    }
  }

  String _uniqueIdFor(String title) {
    final slug = title
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final base = slug.isEmpty ? 'task' : slug;

    var candidate = base;
    var suffix = 2;
    while (_tasks.any((task) => task.id == candidate)) {
      candidate = '$base-$suffix';
      suffix += 1;
    }

    return candidate;
  }
}
