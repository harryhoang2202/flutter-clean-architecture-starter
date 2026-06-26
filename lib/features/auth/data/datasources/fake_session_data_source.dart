import 'dart:async';

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
  final StreamController<Session?> _sessionController =
      StreamController<Session?>.broadcast();

  Session? get currentSession => _currentSession;

  bool get hasSession => _currentSession != null;

  Future<Session?> readSession() async {
    final readException = _readException;
    if (readException != null) {
      throw readException;
    }

    return _currentSession;
  }

  Stream<Session?> watchSession() async* {
    yield _currentSession;
    yield* _sessionController.stream;
  }

  Future<void> saveSession(Session session) async {
    _currentSession = session;
    _sessionController.add(_currentSession);
    notifyListeners();
  }

  Future<void> clearSession() async {
    _currentSession = null;
    _sessionController.add(_currentSession);
    notifyListeners();
  }

  @override
  void dispose() {
    _sessionController.close();
    super.dispose();
  }
}
