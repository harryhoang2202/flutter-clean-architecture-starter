enum RemoteExceptionKind {
  unknown,
  unauthorized,
  validation,
  notFound,
  network,
}

class RemoteException implements Exception {
  const RemoteException({
    required this.message,
    this.kind = RemoteExceptionKind.unknown,
    this.fieldErrors = const {},
  });

  const RemoteException.unauthorized({required String message})
    : this(message: message, kind: RemoteExceptionKind.unauthorized);

  const RemoteException.validation({
    required String message,
    Map<String, String> fieldErrors = const {},
  }) : this(
         message: message,
         kind: RemoteExceptionKind.validation,
         fieldErrors: fieldErrors,
       );

  const RemoteException.notFound({required String message})
    : this(message: message, kind: RemoteExceptionKind.notFound);

  const RemoteException.network({required String message})
    : this(message: message, kind: RemoteExceptionKind.network);

  final String message;
  final RemoteExceptionKind kind;
  final Map<String, String> fieldErrors;
}
