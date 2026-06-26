import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/auth/presentation/bloc/sign_out_cubit.dart';
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
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          return switch (state) {
            TasksInitial() => const SizedBox.shrink(),
            TasksLoading() => const Center(child: CircularProgressIndicator()),
            TasksEmpty() => Center(child: Text(strings.noTasksMessage)),
            TasksLoaded(:final tasks) => TaskList(tasks: tasks),
            TasksFailure(:final message) => Center(child: Text(message)),
          };
        },
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
