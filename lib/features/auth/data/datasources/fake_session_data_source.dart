import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture_starter/features/auth/domain/entities/session.dart';

class FakeSessionDataSource extends ChangeNotifier {
  FakeSessionDataSource({Session? initialSession})
    : _currentSession = initialSession;

  FakeSessionDataSource.unauthenticated() : this();

  Session? _currentSession;

  Session? get currentSession => _currentSession;

  bool get hasSession => _currentSession != null;
}
