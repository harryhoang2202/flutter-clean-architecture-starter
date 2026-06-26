import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/widgets/project_list_item.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({required this.projects, super.key});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: projects.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ProjectListItem(project: projects[index]);
      },
    );
  }
}
