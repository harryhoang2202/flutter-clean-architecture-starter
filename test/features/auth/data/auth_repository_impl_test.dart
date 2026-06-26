import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('repository maps data-source exceptions into Failures', () async {
    final repository = AuthRepositoryImpl(
      sessionDataSource: FakeSessionDataSource.unavailable(),
    );

    final result = await repository.readSession();

    expect(result, isA<FailureResult<Session?>>());
    expect(result.failureOrNull, isA<RemoteFailure>());
    expect(result.failureOrNull?.message, 'Session source is unavailable.');
  });
}
