import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/core/layout/responsive_constraints.dart';
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
              ),
              ProjectsFailure(:final message) => Center(child: Text(message)),
            };
          },
        ),
      ),
    );
  }
}
