import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture_starter/core/routing/app_routes.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/use_cases/sign_in.dart';
import 'package:flutter_clean_architecture_starter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/auth/presentation/pages/auth_page.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/pages/projects_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter({
  required FakeSessionDataSource sessionDataSource,
  String? initialLocation,
}) {
  return GoRouter(
    initialLocation: initialLocation ?? AppRoutes.projects,
    refreshListenable: sessionDataSource,
    redirect: (BuildContext context, GoRouterState state) {
      final isGoingToProjects = state.uri.path == AppRoutes.projects;

      if (isGoingToProjects && !sessionDataSource.hasSession) {
        return AppRoutes.authentication;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.authentication,
        builder: (context, state) {
          final authRepository = AuthRepositoryImpl(
            sessionDataSource: sessionDataSource,
          );

          return BlocProvider(
            create: (_) => AuthBloc(signIn: SignIn(authRepository)),
            child: const AuthPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.projects,
        builder: (context, state) => const ProjectsPage(),
      ),
    ],
  );
}
