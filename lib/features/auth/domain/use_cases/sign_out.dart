import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/repositories/auth_repository.dart';

class SignOut extends UseCase<void, NoParams> {
  const SignOut(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) {
    return _repository.signOut();
  }
}
