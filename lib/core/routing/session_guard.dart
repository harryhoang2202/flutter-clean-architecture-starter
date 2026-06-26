import 'package:flutter/foundation.dart';

abstract interface class SessionGuard extends Listenable {
  bool get hasSession;
}
