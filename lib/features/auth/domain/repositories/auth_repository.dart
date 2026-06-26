import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';

abstract class AuthRepository {
  Future<Result<Session?>> readSession();

  Future<Result<Stream<Session?>>> watchSession();

  Future<Result<Session>> signIn({
    required String email,
    required String password,
  });

  Future<Result<void>> signOut();
}
