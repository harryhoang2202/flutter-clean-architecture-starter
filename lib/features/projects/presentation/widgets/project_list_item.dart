import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_starter/core/routing/app_routes.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:go_router/go_router.dart';

class ProjectListItem extends StatelessWidget {
  const ProjectListItem({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(project.name),
      onTap: () => context.go(AppRoutes.projectDetail(project.id)),
    );
  }
}
