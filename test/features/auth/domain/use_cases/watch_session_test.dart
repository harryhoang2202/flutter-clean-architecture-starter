import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/datasources/fake_session_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/use_cases/sign_out.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/use_cases/watch_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'watching Session reports the current Session and later changes',
    () async {
      final repository = AuthRepositoryImpl(
        sessionDataSource: FakeSessionDataSource(
          initialSession: const Session(userId: 'demo-user'),
        ),
      );
      final watchSession = WatchSession(repository);
      final signOut = SignOut(repository);

      final result = await watchSession(const NoParams());

      expect(result, isA<Success<Stream<Session?>>>());
      final sessionExpectation = expectLater(
        result.valueOrNull,
        emitsInOrder([
          isA<Session>().having(
            (session) => session.userId,
            'userId',
            'demo-user',
          ),
          isNull,
        ]),
      );

      await Future<void>.delayed(Duration.zero);
      await signOut(const NoParams());
      await sessionExpectation;
    },
  );
}
