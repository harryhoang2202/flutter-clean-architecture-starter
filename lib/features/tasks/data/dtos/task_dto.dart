import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';

class TaskDto {
  const TaskDto({
    required this.id,
    required this.projectId,
    required this.title,
    required this.isCompleted,
  });

  final String id;
  final String projectId;
  final String title;
  final bool isCompleted;

  TaskDto copyWith({bool? isCompleted}) {
    return TaskDto(
      id: id,
      projectId: projectId,
      title: title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Task toDomain() {
    return Task(
      id: id,
      projectId: projectId,
      title: title,
      isCompleted: isCompleted,
    );
  }
}
