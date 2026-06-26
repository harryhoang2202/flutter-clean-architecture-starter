import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/presentation/bloc/tasks_bloc.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: task.isCompleted,
      onChanged: (_) =>
          context.read<TasksBloc>().add(TasksToggleRequested(taskId: task.id)),
      title: Text(task.title),
    );
  }
}
