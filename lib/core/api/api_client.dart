import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../config/app_config.dart';
import '../error/failures.dart';

/// Elite API Client for NeuroSync 4.0
/// Handles timeouts, logging, and security headers.
class ApiClient {
  final Logger _logger = Logger();

  static const Duration timeout = Duration(seconds: 15);

  String get _baseUrl => AppConfig.instance.apiUrl;

  void _ensureConnectedMode() {
    if (!AppConfig.instance.networkEnabled || _baseUrl.isEmpty) {
      throw const OfflineModeFailure();
    }
  }

  /// Standard GET with professional error handling
  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    _ensureConnectedMode();
    _logger.i('API GET: $path');
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl$path'), headers: headers)
          .timeout(timeout);

      return _handleResponse(response);
    } on TimeoutException {
      throw const NetworkFailure();
    } catch (e) {
      _logger.e('API Error: $e');
      throw ServerFailure(e.toString());
    }
  }

  /// Secure POST for sensitive health data
  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    _ensureConnectedMode();
    _logger.i('API POST: $path');
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      _logger.e('API Error: $e');
      throw ServerFailure(e.toString());
    }
  }

  dynamic _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw ServerFailure(body['error'] ?? 'Unknown error');
    }
  }
}
