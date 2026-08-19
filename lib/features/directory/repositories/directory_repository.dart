import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../models/directory_models.dart';

final directoryRepositoryProvider = Provider((ref) => DirectoryRepository(ApiClient()));

class DirectoryRepository {
  final ApiClient _apiClient;

  DirectoryRepository(this._apiClient);

  Future<List<Wilaya>> getWilayas() async {
    final List<dynamic> response = await _apiClient.get('/directory.php?action=wilayas');
    return response.map((json) => Wilaya.fromJson(json)).toList();
  }

  Future<List<Professional>> getProfessionals({int? wilayaId}) async {
    final String path = wilayaId != null 
        ? '/directory.php?action=professionals&wilaya_id=$wilayaId'
        : '/directory.php?action=professionals';
    final List<dynamic> response = await _apiClient.get(path);
    return response.map((json) => Professional.fromJson(json)).toList();
  }

  Future<List<Establishment>> getEstablishments({int? wilayaId, String? type}) async {
    String path = '/directory.php?action=establishments';
    final params = <String>[];
    if (wilayaId != null) params.add('wilaya_id=$wilayaId');
    if (type != null) params.add('type=$type');
    
    if (params.isNotEmpty) path += '&' + params.join('&');
    
    final List<dynamic> response = await _apiClient.get(path);
    return response.map((json) => Establishment.fromJson(json)).toList();
  }

  Future<List<SearchResult>> search({String? query, int? wilayaId, String? type}) async {
    String path = '/directory.php?action=search';
    final params = <String>[];
    if (query != null) params.add('q=$query');
    if (wilayaId != null) params.add('wilaya_id=$wilayaId');
    if (type != null) params.add('type=$type');
    
    if (params.isNotEmpty) path += '&' + params.join('&');
    
    final List<dynamic> response = await _apiClient.get(path);
    return response.map((json) => SearchResult.fromJson(json)).toList();
  }

  Future<void> submitReport({
    required int recordId,
    required String recordType,
    required String reportType,
    String? description,
  }) async {
    await _apiClient.post('/directory.php?action=report', {
      'record_id': recordId,
      'record_type': recordType,
      'report_type': reportType,
      'description': description,
    });
  }
}
