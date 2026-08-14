import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/services/professional_repository.dart';
import 'package:projetmascara/core/services/mock_professional_service.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';

import 'package:projetmascara/features/professional/models/professional_profile.dart';

final professionalRepositoryProvider = Provider<ProfessionalRepository>((ref) {
  return MockProfessionalService();
});

final allProfessionalsProvider = FutureProvider<List<ProfessionalProfile>>((ref) async {
  return ref.watch(professionalRepositoryProvider).getAllProfessionals();
});

final psychologistRequestsProvider = FutureProvider<List<AccessRequest>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.role != UserRole.psychologist) return [];
  return ref.watch(professionalRepositoryProvider).getRequestsForPsychologist(user.id);
});

final pendingRequestsProvider = Provider<AsyncValue<List<AccessRequest>>>((ref) {
  return ref.watch(psychologistRequestsProvider).whenData(
    (requests) => requests.where((r) => r.status == AccessRequestStatus.pending).toList(),
  );
});

final userRequestsProvider = FutureProvider<List<AccessRequest>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref.watch(professionalRepositoryProvider).getRequestsForUser(user.id);
});

final authorizedPatientsProvider = FutureProvider<List<UserModel>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.role != UserRole.psychologist) return [];
  return ref.watch(professionalRepositoryProvider).getAuthorizedPatients(user.id);
});

final patientDetailProvider = FutureProvider.family<UserModel?, String>((ref, patientId) async {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.role != UserRole.psychologist) return null;
  return ref.watch(professionalRepositoryProvider).getPatientById(user.id, patientId);
});

final patientAssessmentsProvider = FutureProvider.family<List<AssessmentRecord>, String>((ref, patientId) async {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.role != UserRole.psychologist) return [];
  return ref.watch(professionalRepositoryProvider).getPatientAssessments(user.id, patientId);
});
