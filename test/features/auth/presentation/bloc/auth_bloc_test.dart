import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_auth_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/use_cases/sign_in.dart';
import 'package:flutter_clean_architecture_starter/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  blocTest<AuthBloc, AuthState>(
    'emits loading then success when sign-in succeeds',
    build: () {
      final repository = AuthRepositoryImpl(
        authRemoteDataSource: FakeAuthRemoteDataSource(),
        sessionDataSource: FakeSessionDataSource.unauthenticated(),
      );

      return AuthBloc(signIn: SignIn(repository));
    },
    act: (bloc) => bloc.add(
      const AuthSignInRequested(
        email: 'demo@example.com',
        password: 'password',
      ),
    ),
    expect: () => [
      const AuthState.loading(),
      const AuthState.authenticated(userId: 'demo-user'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then failure when sign-in fails',
    build: () {
      final repository = AuthRepositoryImpl(
        authRemoteDataSource: FakeAuthRemoteDataSource(),
        sessionDataSource: FakeSessionDataSource.unauthenticated(),
      );

      return AuthBloc(signIn: SignIn(repository));
    },
    act: (bloc) => bloc.add(
      const AuthSignInRequested(
        email: 'demo@example.com',
        password: 'wrong-password',
      ),
    ),
    expect: () => [
      const AuthState.loading(),
      const AuthState.failure(message: 'Authentication failed.'),
    ],
  );
}
