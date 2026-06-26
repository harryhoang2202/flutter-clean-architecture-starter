import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task({
    required this.id,
    required this.projectId,
    required this.title,
    required this.isCompleted,
  });

  final String id;
  final String projectId;
  final String title;
  final bool isCompleted;

  Task copyWith({bool? isCompleted}) {
    return Task(
      id: id,
      projectId: projectId,
      title: title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [id, projectId, title, isCompleted];
}
