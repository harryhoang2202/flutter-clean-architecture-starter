sealed class Failure {
  const Failure({required this.message});

  final String message;
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}

final class RemoteFailure extends Failure {
  const RemoteFailure({required super.message});
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message});
}

final class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.fieldErrors = const {},
  });

  final Map<String, String> fieldErrors;
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

final class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}
