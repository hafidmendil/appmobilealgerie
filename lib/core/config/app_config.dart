enum Environment { dev, prod }

class AppConfig {
  final Environment environment;
  final String apiUrl;
  final bool enableLogging;
  final String version = '1.0.0';

  AppConfig({
    required this.environment,
    required this.apiUrl,
    this.enableLogging = true,
  });

  static AppConfig? _instance;

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig not initialized. Call AppConfig.init()');
    }
    return _instance!;
  }

  static void init({required Environment env}) {
    switch (env) {
      case Environment.dev:
        _instance = AppConfig(
          environment: Environment.dev,
          apiUrl: 'https://dev.api.neurosync.com',
          enableLogging: true,
        );
        break;
      case Environment.prod:
        _instance = AppConfig(
          environment: Environment.prod,
          apiUrl: 'https://api.neurosync.com',
          enableLogging: false,
        );
        break;
    }
  }
}
