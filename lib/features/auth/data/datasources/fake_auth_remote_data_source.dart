import 'package:flutter_clean_architecture_starter/core/error/remote_exception.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';

class FakeAuthRemoteDataSource {
  const FakeAuthRemoteDataSource();

  Future<Session> signIn({
    required String email,
    required String password,
  }) async {
    if (email == 'demo@example.com' && password == 'password') {
      return const Session(userId: 'demo-user');
    }

    throw const RemoteException(message: 'Authentication failed.');
  }
}
