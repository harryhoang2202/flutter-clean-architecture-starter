part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated({required String userId}) =
      AuthAuthenticated;
  const factory AuthState.failure({required String message}) = AuthFailure;
}

final class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

final class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object?> get props => [];
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

final class AuthFailure extends AuthState {
  const AuthFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
