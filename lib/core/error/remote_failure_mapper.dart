import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/error/remote_exception.dart';

Failure failureFromRemoteException(RemoteException error) {
  return switch (error.kind) {
    RemoteExceptionKind.unauthorized => UnauthorizedFailure(
      message: error.message,
    ),
    RemoteExceptionKind.validation => ValidationFailure(
      message: error.message,
      fieldErrors: error.fieldErrors,
    ),
    RemoteExceptionKind.notFound => NotFoundFailure(message: error.message),
    RemoteExceptionKind.network => NetworkFailure(message: error.message),
    RemoteExceptionKind.unknown => RemoteFailure(message: error.message),
  };
}
