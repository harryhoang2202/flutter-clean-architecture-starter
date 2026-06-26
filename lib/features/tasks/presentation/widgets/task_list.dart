import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/presentation/widgets/task_list_item.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<Task> tasks;
  final ValueChanged<Task> onEdit;
  final ValueChanged<Task> onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return TaskListItem(
          task: tasks[index],
          onEdit: () => onEdit(tasks[index]),
          onDelete: () => onDelete(tasks[index]),
        );
      },
    );
  }
}
