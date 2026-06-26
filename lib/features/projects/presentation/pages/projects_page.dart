import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/core/layout/responsive_constraints.dart';
import 'package:flutter_clean_architecture_starter/core/widgets/text_entry_dialog.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/widgets/project_list.dart';
import 'package:flutter_clean_architecture_starter/l10n/generated/app_localizations.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(strings.projectsTitle)),
      floatingActionButton: FloatingActionButton(
        key: const Key('create-project-action'),
        onPressed: () => _createProject(context, strings),
        child: const Icon(Icons.add),
      ),
      body: ResponsiveConstraints(
        child: BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) {
            return switch (state) {
              ProjectsInitial() => const SizedBox.shrink(),
              ProjectsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              ProjectsEmpty() => Center(child: Text(strings.noProjectsMessage)),
              ProjectsLoaded(:final projects) => ProjectList(
                projects: projects,
                onEdit: (project) => _updateProject(context, strings, project),
                onDelete: (project) => context.read<ProjectsBloc>().add(
                  ProjectsDeleteRequested(projectId: project.id),
                ),
              ),
              ProjectsFailure(:final message) => Center(child: Text(message)),
            };
          },
        ),
      ),
    );
  }

  Future<void> _createProject(
    BuildContext context,
    AppLocalizations strings,
  ) async {
    final name = await _showProjectNameDialog(
      context: context,
      strings: strings,
      title: strings.createProjectTitle,
    );
    if (name == null || !context.mounted) {
      return;
    }

    context.read<ProjectsBloc>().add(ProjectsCreateRequested(name: name));
  }

  Future<void> _updateProject(
    BuildContext context,
    AppLocalizations strings,
    Project project,
  ) async {
    final name = await _showProjectNameDialog(
      context: context,
      strings: strings,
      title: strings.updateProjectTitle,
      initialValue: project.name,
    );
    if (name == null || !context.mounted) {
      return;
    }

    context.read<ProjectsBloc>().add(
      ProjectsUpdateRequested(projectId: project.id, name: name),
    );
  }

  Future<String?> _showProjectNameDialog({
    required BuildContext context,
    required AppLocalizations strings,
    required String title,
    String initialValue = '',
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => TextEntryDialog(
        title: title,
        fieldLabel: strings.projectNameLabel,
        cancelLabel: strings.cancelAction,
        saveLabel: strings.saveAction,
        fieldKey: const Key('project-name-field'),
        initialValue: initialValue,
      ),
    );
  }
}
