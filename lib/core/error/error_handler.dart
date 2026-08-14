import 'package:flutter/foundation.dart';
import 'package:projetmascara/core/services/logger_service.dart';

class ErrorHandler {
  static void initialize() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _logError(details.exception, details.stack);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      _logError(error, stack);
      return true;
    };
  }

  static void _logError(Object error, StackTrace? stack) {
    logger.e('Uncaught Error', error, stack);
    // TODO: Send to external monitoring service (e.g., Sentry)
  }

  static void handle(Object error, [StackTrace? stack]) {
    logger.e('Handled Error', error, stack);
  }
}
