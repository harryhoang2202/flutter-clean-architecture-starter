import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture_starter/core/error/remote_exception.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';

class FakeSessionDataSource extends ChangeNotifier {
  FakeSessionDataSource({
    Session? initialSession,
    RemoteException? readException,
  }) : _currentSession = initialSession,
       _readException = readException;

  FakeSessionDataSource.unauthenticated() : this();
  FakeSessionDataSource.unavailable()
    : this(
        readException: const RemoteException(
          message: 'Session source is unavailable.',
        ),
      );

  Session? _currentSession;
  final RemoteException? _readException;

  Session? get currentSession => _currentSession;

  bool get hasSession => _currentSession != null;

  Future<Session?> readSession() async {
    final readException = _readException;
    if (readException != null) {
      throw readException;
    }

    return _currentSession;
  }
}
