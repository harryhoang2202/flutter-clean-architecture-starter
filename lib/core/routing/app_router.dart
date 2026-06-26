import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture_starter/core/routing/app_routes.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/auth/presentation/bloc/sign_out_cubit.dart';
import 'package:flutter_clean_architecture_starter/features/auth/presentation/pages/auth_page.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/pages/project_detail_page.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/pages/projects_page.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter({
  required FakeSessionDataSource sessionDataSource,
  required AuthBloc Function() createAuthBloc,
  required SignOutCubit Function() createSignOutCubit,
  required ProjectsBloc Function() createProjectsBloc,
  required TasksBloc Function() createTasksBloc,
  String? initialLocation,
}) {
  return GoRouter(
    initialLocation: initialLocation ?? AppRoutes.projects,
    refreshListenable: sessionDataSource,
    redirect: (BuildContext context, GoRouterState state) {
      final isGoingToProjects = state.uri.path.startsWith(AppRoutes.projects);

      if (isGoingToProjects && !sessionDataSource.hasSession) {
        return AppRoutes.authentication;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.authentication,
        builder: (context, state) => BlocProvider(
          create: (_) => createAuthBloc(),
          child: const AuthPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.projects,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              createProjectsBloc()..add(const ProjectsLoadRequested()),
          child: const ProjectsPage(),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.projects}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => createSignOutCubit()),
              BlocProvider(
                create: (_) =>
                    createTasksBloc()
                      ..add(TasksLoadRequested(projectId: projectId)),
              ),
            ],
            child: ProjectDetailPage(projectId: projectId),
          );
        },
      ),
    ],
  );
}
