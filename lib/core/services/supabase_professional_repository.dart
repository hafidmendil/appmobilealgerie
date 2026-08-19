import '../models/user_model.dart';
import '../../features/professional/models/access_request.dart';
import '../../features/professional/models/professional_profile.dart';
import 'professional_repository.dart';
import '../data/remote_data_source.dart';
import 'sync_service.dart';
import '../models/sync_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/user_role.dart';

class SupabaseProfessionalRepository implements ProfessionalRepository {
  final ProfessionalRemoteDataSource _remoteDataSource;
  final SyncService _syncService;
  final SupabaseClient _supabase = Supabase.instance.client;

  SupabaseProfessionalRepository(this._remoteDataSource, this._syncService);

  @override
  Future<List<ProfessionalProfile>> getAllProfessionals() async {
    final List<dynamic> data = await _supabase
        .from('profiles')
        .select()
        .eq('role', 'psychologist')
        .eq('status', 'approved');
    
    return data.map((d) => ProfessionalProfile(
      id: d['id'],
      name: d['name'] ?? 'Inconnu',
      specialty: 'Psychologue Clinicien',
      wilayaId: d['wilaya_id'],
      email: d['email'],
    )).toList();
  }

  @override
  Future<void> sendRequest(AccessRequest request) async {
    await _remoteDataSource.sendAccessRequest(request);
    // Also add to local queue if needed, but here we call remote directly for immediate feedback
  }

  @override
  Future<List<AccessRequest>> getRequestsForPsychologist(String professionalId) async {
    return await _remoteDataSource.fetchAccessRequests(professionalId);
  }

  @override
  Future<List<AccessRequest>> getRequestsForUser(String userId) async {
    final List<dynamic> data = await _supabase
        .from('access_requests')
        .select()
        .eq('user_id', userId);
    
    return data.map((d) => _mapToAccessRequest(d)).toList();
  }

  @override
  Future<void> respondToRequest(String requestId, AccessRequestStatus status) async {
    await _supabase
        .from('access_requests')
        .update({'status': status.name})
        .eq('id', requestId);
  }

  @override
  Future<List<UserModel>> getAuthorizedPatients(String professionalId) async {
    // This requires a complex join or multiple queries in Supabase
    // For now, get accepted requests first
    final List<dynamic> requests = await _supabase
        .from('access_requests')
        .select('user_id')
        .eq('professional_id', professionalId)
        .eq('status', 'accepted');
    
    if (requests.isEmpty) return [];
    
    final userIds = requests.map((r) => r['user_id']).toList();
    
    final List<dynamic> usersData = await _supabase
        .from('profiles')
        .select()
        .in_('id', userIds);
        
    return usersData.map((d) => _mapToUserModel(d)).toList();
  }

  @override
  Future<UserModel?> getPatientById(String professionalId, String patientId) async {
    // Security check: is there an accepted request?
    final request = await _supabase
        .from('access_requests')
        .select()
        .eq('professional_id', professionalId)
        .eq('user_id', patientId)
        .eq('status', 'accepted')
        .maybeSingle();
        
    if (request == null) return null;
    
    final userData = await _supabase
        .from('profiles')
        .select()
        .eq('id', patientId)
        .single();
        
    return _mapToUserModel(userData);
  }

  @override
  Future<List<AssessmentRecord>> getPatientAssessments(String professionalId, String patientId) async {
     // Security check: is there an accepted request?
    final request = await _supabase
        .from('access_requests')
        .select()
        .eq('professional_id', professionalId)
        .eq('user_id', patientId)
        .eq('status', 'accepted')
        .maybeSingle();
        
    if (request == null) return [];
    
    final List<dynamic> data = await _supabase
        .from('assessments')
        .select()
        .eq('user_id', patientId);
    
    return data.map((d) => AssessmentRecord(
      id: d['id'],
      userId: d['user_id'],
      answers: Map<String, int>.from(d['answers']),
      safetyAnswers: Map<String, bool>.from(d['safety_answers']),
      createdAt: DateTime.parse(d['created_at']),
      syncStatus: 'synced',
    )).toList();
  }

  UserModel _mapToUserModel(Map<String, dynamic> d) {
    return UserModel(
      id: d['id'],
      email: d['email'],
      role: d['role'] == 'psychologist' ? UserRole.psychologist : UserRole.user,
      status: d['status'],
      createdAt: DateTime.parse(d['created_at']),
      updatedAt: DateTime.parse(d['updated_at']),
      name: d['name'],
      wilayaId: d['wilaya_id'],
    );
  }

  AccessRequest _mapToAccessRequest(Map<String, dynamic> d) {
    return AccessRequest(
      id: d['id'],
      userId: d['user_id'],
      professionalId: d['professional_id'],
      status: AccessRequestStatus.values.firstWhere((e) => e.name == d['status']),
      createdAt: DateTime.parse(d['created_at']),
      message: d['message'],
    );
  }
}
