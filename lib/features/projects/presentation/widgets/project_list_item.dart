import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_starter/core/routing/app_routes.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ProjectListItem extends StatelessWidget {
  const ProjectListItem({
    required this.project,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Project project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(project.name),
      trailing: PopupMenuButton<_ProjectAction>(
        onSelected: (action) {
          switch (action) {
            case _ProjectAction.edit:
              onEdit();
            case _ProjectAction.delete:
              onDelete();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: _ProjectAction.edit,
            child: Text(strings.editAction),
          ),
          PopupMenuItem(
            value: _ProjectAction.delete,
            child: Text(strings.deleteAction),
          ),
        ],
      ),
      onTap: () => context.go(AppRoutes.projectDetail(project.id)),
    );
  }
}

enum _ProjectAction { edit, delete }
