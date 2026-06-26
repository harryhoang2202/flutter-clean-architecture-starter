import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/repositories/auth_repository.dart';

class SignIn extends UseCase<Session, SignInParams> {
  const SignIn(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<Session>> call(SignInParams params) {
    return _repository.signIn(email: params.email, password: params.password);
  }
}

class SignInParams {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;
}
