import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/error/remote_exception.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_auth_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    FakeAuthRemoteDataSource authRemoteDataSource =
        const FakeAuthRemoteDataSource(),
    required FakeSessionDataSource sessionDataSource,
  }) : _authRemoteDataSource = authRemoteDataSource,
       _sessionDataSource = sessionDataSource;

  final FakeAuthRemoteDataSource _authRemoteDataSource;
  final FakeSessionDataSource _sessionDataSource;

  @override
  Future<Result<Session?>> readSession() async {
    try {
      return Result.success(await _sessionDataSource.readSession());
    } on RemoteException catch (error) {
      return Result.failure(RemoteFailure(message: error.message));
    }
  }

  @override
  Future<Result<Stream<Session?>>> watchSession() async {
    return Result.success(_sessionDataSource.watchSession());
  }

  @override
  Future<Result<Session>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _authRemoteDataSource.signIn(
        email: email,
        password: password,
      );
      await _sessionDataSource.saveSession(session);
      return Result.success(session);
    } on RemoteException catch (error) {
      return Result.failure(RemoteFailure(message: error.message));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    await _sessionDataSource.clearSession();
    return const Result.success(null);
  }
}
