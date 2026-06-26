import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a successful use case returns a typed success Result', () async {
    final useCase = _LoadReferenceStarterName();

    final result = await useCase(NoParams());

    expect(result, isA<Success<String>>());
    expect(result.valueOrNull, 'Flutter Clean Architecture Starter');
  });

  test('a failed operation returns a domain-facing Failure', () async {
    final useCase = _LoadUnavailableReferenceStarterName();

    final result = await useCase(NoParams());

    expect(result, isA<FailureResult<String>>());
    expect(result.failureOrNull, isA<UnexpectedFailure>());
    expect(result.failureOrNull?.message, 'Reference starter is unavailable.');
  });
}

class _LoadReferenceStarterName extends UseCase<String, NoParams> {
  @override
  Future<Result<String>> call(NoParams params) async {
    return const Result.success('Flutter Clean Architecture Starter');
  }
}

class _LoadUnavailableReferenceStarterName extends UseCase<String, NoParams> {
  @override
  Future<Result<String>> call(NoParams params) async {
    return const Result.failure(
      UnexpectedFailure(message: 'Reference starter is unavailable.'),
    );
  }
}
