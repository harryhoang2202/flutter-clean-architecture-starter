import 'package:flutter_clean_architecture_starter/app/di/injection.config.dart';
import 'package:flutter_clean_architecture_starter/core/config/app_config.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
GetIt configureDependencies({
  GetIt? instance,
  required AppConfig config,
  String? initialLocation,
  FakeSessionDataSource? sessionDataSource,
}) {
  final dependencies = instance ?? getIt;

  return dependencies.init(
    config: config,
    initialLocation: initialLocation,
    sessionDataSource: sessionDataSource,
  );
}
