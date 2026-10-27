enum Environment { dev, prod }

/// The application starts as a self-contained, offline pilot.  A connected
/// mode may only be enabled when a reviewed backend is introduced.
enum DeploymentMode { offline, connected }

class AppConfig {
  final Environment environment;
  final DeploymentMode deploymentMode;
  final String apiUrl;
  final bool enableLogging;
  final bool enableDemoData;
  final String version = '1.0.0';

  AppConfig({
    required this.environment,
    required this.deploymentMode,
    required this.apiUrl,
    this.enableLogging = true,
    this.enableDemoData = false,
  });

  bool get networkEnabled => deploymentMode == DeploymentMode.connected;

  static AppConfig? _instance;

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig not initialized. Call AppConfig.init()');
    }
    return _instance!;
  }

  static void init({
    required Environment env,
    DeploymentMode deploymentMode = DeploymentMode.offline,
    bool enableDemoData = false,
  }) {
    final apiUrl = deploymentMode == DeploymentMode.connected
        ? (env == Environment.dev
              ? 'https://dev.api.neurosync.com'
              : 'https://api.neurosync.com')
        : '';

    switch (env) {
      case Environment.dev:
        _instance = AppConfig(
          environment: Environment.dev,
          deploymentMode: deploymentMode,
          apiUrl: apiUrl,
          enableLogging: true,
          enableDemoData: enableDemoData,
        );
        break;
      case Environment.prod:
        _instance = AppConfig(
          environment: Environment.prod,
          deploymentMode: deploymentMode,
          apiUrl: apiUrl,
          enableLogging: false,
          enableDemoData: enableDemoData,
        );
        break;
    }
  }
}
