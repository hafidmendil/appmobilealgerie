import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/core/api/api_client.dart';
import 'package:projetmascara/core/config/app_config.dart';
import 'package:projetmascara/core/error/failures.dart';

void main() {
  test(
    'offline mode has no API endpoint and blocks network requests',
    () async {
      AppConfig.init(
        env: Environment.prod,
        deploymentMode: DeploymentMode.offline,
      );

      expect(AppConfig.instance.apiUrl, isEmpty);
      expect(AppConfig.instance.networkEnabled, isFalse);
      await expectLater(
        ApiClient().get('/health'),
        throwsA(isA<OfflineModeFailure>()),
      );
    },
  );
}
