import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/use_cases/sign_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required SignIn signIn})
    : _signIn = signIn,
      super(const AuthState.initial()) {
    on<AuthSignInRequested>(_onSignInRequested);
  }

  final SignIn _signIn;

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _signIn(
      SignInParams(email: event.email, password: event.password),
    );

    switch (result) {
      case Success(value: final session):
        emit(AuthState.authenticated(userId: session.userId));
      case FailureResult(failure: final failure):
        emit(AuthState.failure(message: failure.message));
    }
  }
}
