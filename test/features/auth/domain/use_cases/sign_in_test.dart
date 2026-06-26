import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_auth_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/use_cases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('signing in with accepted credentials establishes a Session', () async {
    final repository = AuthRepositoryImpl(
      authRemoteDataSource: FakeAuthRemoteDataSource(),
      sessionDataSource: FakeSessionDataSource.unauthenticated(),
    );
    final signIn = SignIn(repository);

    final result = await signIn(
      const SignInParams(email: 'demo@example.com', password: 'password'),
    );

    expect(result, isA<Success<Session>>());
    expect(result.valueOrNull?.userId, 'demo-user');
    expect((await repository.readSession()).valueOrNull?.userId, 'demo-user');
  });

  test(
    'signing in with rejected credentials returns UnauthorizedFailure',
    () async {
      final repository = AuthRepositoryImpl(
        authRemoteDataSource: FakeAuthRemoteDataSource(),
        sessionDataSource: FakeSessionDataSource.unauthenticated(),
      );
      final signIn = SignIn(repository);

      final result = await signIn(
        const SignInParams(
          email: 'demo@example.com',
          password: 'wrong-password',
        ),
      );

      expect(result, isA<FailureResult<Session>>());
      expect(result.failureOrNull, isA<UnauthorizedFailure>());
      expect(result.failureOrNull?.message, 'Authentication failed.');
      expect((await repository.readSession()).valueOrNull, isNull);
    },
  );
}
