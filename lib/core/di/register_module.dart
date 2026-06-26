import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_auth_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:injectable/injectable.dart';

@module
class RegisterModule {
  FakeSessionDataSource get fakeSessionDataSource =>
      FakeSessionDataSource.unauthenticated();

  FakeAuthRemoteDataSource get fakeAuthRemoteDataSource =>
      const FakeAuthRemoteDataSource();
}
