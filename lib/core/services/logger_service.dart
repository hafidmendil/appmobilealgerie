import 'package:logger/logger.dart';
import 'package:projetmascara/core/config/app_config.dart';

class LoggerService {
  late final Logger _logger;

  LoggerService() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: AppConfig.instance.enableLogging ? Level.all : Level.warning,
    );
  }

  void d(String message) => _logger.d(message);
  void i(String message) => _logger.i(message);
  void w(String message) => _logger.w(message);
  void e(String message, [dynamic error, StackTrace? stackTrace]) => _logger.e(message, error: error, stackTrace: stackTrace);
  void f(String message, [dynamic error, StackTrace? stackTrace]) => _logger.f(message, error: error, stackTrace: stackTrace);
}

final logger = LoggerService();
