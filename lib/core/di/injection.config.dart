import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/core/di/register_module.dart';
import 'package:flutter_clean_architecture_starter/core/routing/app_router.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_auth_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/use_cases/sign_in.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/use_cases/sign_out.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/use_cases/watch_session.dart';
import 'package:flutter_clean_architecture_starter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/datasources/fake_projects_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/repositories/projects_repository.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/load_projects.dart';
import 'package:flutter_clean_architecture_starter/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/datasources/fake_tasks_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/load_project_tasks.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/domain/use_cases/toggle_task_completion.dart';
import 'package:flutter_clean_architecture_starter/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

extension GetItInjectableX on GetIt {
  GetIt init({
    required AppConfig config,
    String? initialLocation,
    FakeSessionDataSource? sessionDataSource,
  }) {
    final registerModule = RegisterModule();

    registerSingleton<AppConfig>(config);
    registerSingleton<FakeSessionDataSource>(
      sessionDataSource ?? registerModule.fakeSessionDataSource,
      dispose: (source) => source.dispose(),
    );
    registerLazySingleton<FakeAuthRemoteDataSource>(
      () => registerModule.fakeAuthRemoteDataSource,
    );
    registerLazySingleton<FakeProjectsRemoteDataSource>(
      () => registerModule.fakeProjectsRemoteDataSource,
    );
    registerLazySingleton<FakeTasksRemoteDataSource>(
      () => registerModule.fakeTasksRemoteDataSource,
    );
    registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSource: this<FakeAuthRemoteDataSource>(),
        sessionDataSource: this<FakeSessionDataSource>(),
      ),
    );
    registerFactory<SignIn>(() => SignIn(this<AuthRepository>()));
    registerFactory<SignOut>(() => SignOut(this<AuthRepository>()));
    registerFactory<WatchSession>(() => WatchSession(this<AuthRepository>()));
    registerFactory<AuthBloc>(() => AuthBloc(signIn: this<SignIn>()));
    registerLazySingleton<ProjectsRepository>(
      () => ProjectsRepositoryImpl(
        remoteDataSource: this<FakeProjectsRemoteDataSource>(),
      ),
    );
    registerFactory<LoadProjects>(
      () => LoadProjects(this<ProjectsRepository>()),
    );
    registerFactory<ProjectsBloc>(
      () => ProjectsBloc(loadProjects: this<LoadProjects>()),
    );
    registerLazySingleton<TasksRepository>(
      () => TasksRepositoryImpl(
        remoteDataSource: this<FakeTasksRemoteDataSource>(),
      ),
    );
    registerFactory<LoadProjectTasks>(
      () => LoadProjectTasks(this<TasksRepository>()),
    );
    registerFactory<ToggleTaskCompletion>(
      () => ToggleTaskCompletion(this<TasksRepository>()),
    );
    registerFactory<TasksBloc>(
      () => TasksBloc(
        loadProjectTasks: this<LoadProjectTasks>(),
        toggleTaskCompletion: this<ToggleTaskCompletion>(),
      ),
    );
    registerLazySingleton<GoRouter>(
      () => createAppRouter(
        sessionDataSource: this<FakeSessionDataSource>(),
        createAuthBloc: () => this<AuthBloc>(),
        createProjectsBloc: () => this<ProjectsBloc>(),
        createTasksBloc: () => this<TasksBloc>(),
        initialLocation: initialLocation,
      ),
      dispose: (router) => router.dispose(),
    );

    return this;
  }
}
