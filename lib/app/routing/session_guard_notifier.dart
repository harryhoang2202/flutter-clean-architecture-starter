import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture_starter/core/routing/session_guard.dart';

class SessionGuardNotifier extends ChangeNotifier implements SessionGuard {
  SessionGuardNotifier({
    required bool hasInitialSession,
    required Stream<Object?> sessionChanges,
  }) : _hasSession = hasInitialSession {
    _sessionSubscription = sessionChanges.listen(_updateSession);
  }

  late final StreamSubscription<Object?> _sessionSubscription;
  bool _hasSession;

  @override
  bool get hasSession => _hasSession;

  void _updateSession(Object? session) {
    final hasSession = session != null;
    if (_hasSession == hasSession) {
      return;
    }

    _hasSession = hasSession;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_sessionSubscription.cancel());
    super.dispose();
  }
}
