import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/presentation/widgets/task_list.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_projectTitle(projectId))),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          return switch (state) {
            TasksInitial() => const SizedBox.shrink(),
            TasksLoading() => const Center(child: CircularProgressIndicator()),
            TasksEmpty() => const Center(child: Text('No Tasks yet.')),
            TasksLoaded(:final tasks) => TaskList(tasks: tasks),
            TasksFailure(:final message) => Center(child: Text(message)),
          };
        },
      ),
    );
  }

  String _projectTitle(String projectId) {
    return switch (projectId) {
      'reference-starter' => 'Reference Starter',
      'architecture-cleanup' => 'Architecture Cleanup',
      _ => projectId,
    };
  }
}
