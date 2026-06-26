import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/error/remote_exception.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';

class AuthRepositoryImpl {
  const AuthRepositoryImpl({required FakeSessionDataSource sessionDataSource})
    : _sessionDataSource = sessionDataSource;

  final FakeSessionDataSource _sessionDataSource;

  Future<Result<Session?>> readSession() async {
    try {
      return Result.success(await _sessionDataSource.readSession());
    } on RemoteException catch (error) {
      return Result.failure(RemoteFailure(message: error.message));
    }
  }
}
