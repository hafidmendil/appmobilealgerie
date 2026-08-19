import 'package:supabase_flutter/supabase_flutter.dart';
import 'remote_data_source.dart';
import '../../features/assessment/assessment_record.dart';
import '../../features/professional/models/access_request.dart';

class SupabaseRemoteDataSource implements AssessmentRemoteDataSource, ProfessionalRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  // --- AssessmentRemoteDataSource ---

  @override
  Future<List<AssessmentRecord>> fetchAssessments(String userId) async {
    final List<dynamic> data = await _supabase
        .from('assessments')
        .select()
        .eq('user_id', userId);
    
    return data.map((d) => _mapToAssessmentRecord(d)).toList();
  }

  @override
  Future<void> uploadAssessment(AssessmentRecord record) async {
    await _supabase.from('assessments').insert({
      'id': record.id,
      'user_id': record.userId,
      'answers': record.answers,
      'safety_answers': record.safetyAnswers,
      'final_message': record.finalMessage,
      'created_at': record.createdAt.toIso8601String(),
    });
  }

  AssessmentRecord _mapToAssessmentRecord(Map<String, dynamic> d) {
    return AssessmentRecord(
      id: d['id'],
      userId: d['user_id'],
      answers: Map<String, int>.from(d['answers']),
      safetyAnswers: Map<String, bool>.from(d['safety_answers']),
      createdAt: DateTime.parse(d['created_at']),
      finalMessage: d['final_message'],
      syncStatus: 'synced',
    );
  }

  // --- ProfessionalRemoteDataSource ---

  @override
  Future<List<AccessRequest>> fetchAccessRequests(String professionalId) async {
    final List<dynamic> data = await _supabase
        .from('access_requests')
        .select()
        .eq('professional_id', professionalId);
    
    return data.map((d) => _mapToAccessRequest(d)).toList();
  }

  @override
  Future<void> updateAccessRequest(AccessRequest request) async {
    await _supabase.from('access_requests').update({
      'status': request.status.name,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', request.id);
  }

  @override
  Future<void> sendAccessRequest(AccessRequest request) async {
    await _supabase.from('access_requests').insert({
      'id': request.id,
      'user_id': request.userId,
      'professional_id': request.professionalId,
      'status': request.status.name,
      'message': request.message,
      'created_at': request.createdAt.toIso8601String(),
    });
  }

  AccessRequest _mapToAccessRequest(Map<String, dynamic> d) {
    return AccessRequest(
      id: d['id'],
      userId: d['user_id'],
      professionalId: d['professional_id'],
      status: AccessRequestStatus.values.firstWhere((e) => e.name == d['status']),
      createdAt: DateTime.parse(d['created_at']),
      message: d['message'],
      updatedAt: d['updated_at'] != null ? DateTime.parse(d['updated_at']) : null,
    );
  }
}
