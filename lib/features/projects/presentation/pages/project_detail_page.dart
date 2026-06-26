import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/core/layout/responsive_constraints.dart';
import 'package:flutter_clean_architecture_starter/core/widgets/text_entry_dialog.dart';
import 'package:flutter_clean_architecture_starter/features/auth/presentation/bloc/sign_out_cubit.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/presentation/widgets/task_list.dart';
import 'package:flutter_clean_architecture_starter/l10n/generated/app_localizations.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_projectTitle(projectId, strings)),
        actions: [
          TextButton(
            onPressed: () => context.read<SignOutCubit>().signOut(),
            child: Text(strings.signOutAction),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('create-task-action'),
        onPressed: () => _createTask(context, strings),
        child: const Icon(Icons.add),
      ),
      body: ResponsiveConstraints(
        child: BlocBuilder<TasksBloc, TasksState>(
          builder: (context, state) {
            return switch (state) {
              TasksInitial() => const SizedBox.shrink(),
              TasksLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              TasksEmpty() => Center(child: Text(strings.noTasksMessage)),
              TasksLoaded(:final tasks) => TaskList(
                tasks: tasks,
                onEdit: (task) => _updateTask(context, strings, task),
                onDelete: (task) => context.read<TasksBloc>().add(
                  TasksDeleteRequested(taskId: task.id),
                ),
              ),
              TasksFailure(:final message) => Center(child: Text(message)),
            };
          },
        ),
      ),
    );
  }

  Future<void> _createTask(
    BuildContext context,
    AppLocalizations strings,
  ) async {
    final title = await _showTaskTitleDialog(
      context: context,
      strings: strings,
      title: strings.createTaskTitle,
    );
    if (title == null || !context.mounted) {
      return;
    }

    context.read<TasksBloc>().add(
      TasksCreateRequested(projectId: projectId, title: title),
    );
  }

  Future<void> _updateTask(
    BuildContext context,
    AppLocalizations strings,
    Task task,
  ) async {
    final title = await _showTaskTitleDialog(
      context: context,
      strings: strings,
      title: strings.updateTaskTitle,
      initialValue: task.title,
    );
    if (title == null || !context.mounted) {
      return;
    }

    context.read<TasksBloc>().add(
      TasksUpdateRequested(taskId: task.id, title: title),
    );
  }

  Future<String?> _showTaskTitleDialog({
    required BuildContext context,
    required AppLocalizations strings,
    required String title,
    String initialValue = '',
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => TextEntryDialog(
        title: title,
        fieldLabel: strings.taskTitleLabel,
        cancelLabel: strings.cancelAction,
        saveLabel: strings.saveAction,
        fieldKey: const Key('task-title-field'),
        initialValue: initialValue,
      ),
    );
  }

  String _projectTitle(String projectId, AppLocalizations strings) {
    return switch (projectId) {
      'reference-starter' => strings.referenceStarterProjectTitle,
      'architecture-cleanup' => strings.architectureCleanupProjectTitle,
      _ => projectId,
    };
  }
}
