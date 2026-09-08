import 'package:flutter/foundation.dart';

/// Centralized logger using Flutter's debugPrint.
/// Automatically muted in Release builds.
void appLog(Object? message, {String name = 'APP'}) {
  if (kDebugMode) {
    debugPrint('[$name] $message');
  }
}
