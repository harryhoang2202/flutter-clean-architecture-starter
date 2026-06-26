import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';

class ProjectListItem extends StatelessWidget {
  const ProjectListItem({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(project.name));
  }
}
