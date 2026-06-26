import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:flutter_clean_architecture_starter/l10n/generated/app_localizations.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    required this.task,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return CheckboxListTile(
      value: task.isCompleted,
      onChanged: (_) =>
          context.read<TasksBloc>().add(TasksToggleRequested(taskId: task.id)),
      title: Text(task.title),
      secondary: PopupMenuButton<_TaskAction>(
        onSelected: (action) {
          switch (action) {
            case _TaskAction.edit:
              onEdit();
            case _TaskAction.delete:
              onDelete();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: _TaskAction.edit,
            child: Text(strings.editAction),
          ),
          PopupMenuItem(
            value: _TaskAction.delete,
            child: Text(strings.deleteAction),
          ),
        ],
      ),
    );
  }
}

enum _TaskAction { edit, delete }
