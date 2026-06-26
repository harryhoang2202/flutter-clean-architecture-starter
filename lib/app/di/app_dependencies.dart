import 'package:flutter_clean_architecture_starter/app/di/injection.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AppDependencies {
  AppDependencies._(this._dependencies, {required this.disposeDependencies});

  factory AppDependencies.create({
    required AppConfig config,
    String? initialLocation,
    FakeSessionDataSource? sessionDataSource,
  }) {
    final dependencies = GetIt.asNewInstance();

    configureDependencies(
      instance: dependencies,
      config: config,
      initialLocation: initialLocation,
      sessionDataSource: sessionDataSource,
    );

    return AppDependencies._(dependencies, disposeDependencies: true);
  }

  factory AppDependencies.fromGetIt(
    GetIt dependencies, {
    bool disposeDependencies = false,
  }) {
    return AppDependencies._(
      dependencies,
      disposeDependencies: disposeDependencies,
    );
  }

  final GetIt _dependencies;
  final bool disposeDependencies;

  AppConfig get config => _dependencies<AppConfig>();

  GoRouter get router => _dependencies<GoRouter>();

  Future<void> dispose() {
    if (!disposeDependencies) {
      return Future.value();
    }

    return _dependencies.reset();
  }
}
