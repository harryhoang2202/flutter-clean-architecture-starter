import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/repositories/auth_repository.dart';

class WatchSession extends UseCase<Stream<Session?>, NoParams> {
  const WatchSession(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<Stream<Session?>>> call(NoParams params) {
    return _repository.watchSession();
  }
}
