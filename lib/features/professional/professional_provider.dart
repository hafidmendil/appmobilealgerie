import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/data/wilaya_data.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/models/wilaya_model.dart';
import 'package:projetmascara/core/providers/backend_providers.dart';
import 'package:projetmascara/core/services/professional_repository.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/features/professional/models/center_model.dart';
import 'package:projetmascara/features/professional/models/professional_model.dart';
import 'package:projetmascara/features/professional/models/session_request_model.dart';

final professionalProvider = ChangeNotifierProvider<ProfessionalProvider>((
  ref,
) {
  return ProfessionalProvider(
    repository: ref.watch(professionalRepositoryProvider),
  );
});

final psychologistRequestsProvider = FutureProvider<List<AccessRequest>>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref
      .watch(professionalRepositoryProvider)
      .getRequestsForPsychologist(user.id);
});

final pendingRequestsProvider = FutureProvider<List<AccessRequest>>((
  ref,
) async {
  final requests = await ref.watch(psychologistRequestsProvider.future);
  return requests
      .where((r) => r.status == AccessRequestStatus.pending)
      .toList();
});

final sessionRequestsProvider = FutureProvider<List<SessionRequestModel>>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref.watch(professionalRepositoryProvider).getSessionRequests(user.id);
});

final mySessionRequestsProvider = FutureProvider<List<SessionRequestModel>>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref
      .watch(professionalRepositoryProvider)
      .getSessionRequestsForUser(user.id.hashCode);
});

final authorizedPatientsProvider = FutureProvider<List<UserModel>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref
      .watch(professionalRepositoryProvider)
      .getAuthorizedPatients(user.id);
});

final patientDetailProvider = FutureProvider.family<UserModel?, String>((
  ref,
  id,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return ref.watch(professionalRepositoryProvider).getPatientById(user.id, id);
});

final patientAssessmentsProvider =
    FutureProvider.family<List<AssessmentRecord>, String>((ref, id) async {
      final user = ref.watch(currentUserProvider);
      if (user == null) return [];
      return ref
          .watch(professionalRepositoryProvider)
          .getPatientAssessments(user.id, id);
    });

class ProfessionalProvider extends ChangeNotifier {
  final ProfessionalRepository repository;

  ProfessionalProvider({required this.repository});

  List<Wilaya> _wilayas = [];
  List<Wilaya> get wilayas => _wilayas;

  List<ProfessionalModel> _professionals = [];
  List<ProfessionalModel> get professionals => _professionals;

  List<CenterModel> _centers = [];
  List<CenterModel> get centers => _centers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadWilayas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _wilayas = algerianWilayas;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search({required int wilayaId, String? query}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final normalizedQuery = _normalize(query ?? '');
      final directoryProfessionals = await repository
          .getDirectoryProfessionals();
      final filteredProfessionals = directoryProfessionals.where((
        professional,
      ) {
        final matchesWilaya = professional.wilayaId == wilayaId;
        if (!matchesWilaya) return false;
        if (normalizedQuery.isEmpty) return true;

        final haystack = _normalize(
          '${professional.fullName} ${professional.specialty} ${professional.city}',
        );
        return haystack.contains(normalizedQuery);
      }).toList();

      _professionals = filteredProfessionals;

      final wilaya = algerianWilayas.firstWhere(
        (w) => int.parse(w.code) == wilayaId,
        orElse: () => algerianWilayas.first,
      );
      _centers = [
        CenterModel(
          id: wilayaId * 100 + 1,
          name: 'Centre de Santé Mentale - ${wilaya.nameFr}',
          description: 'Soutien et accompagnement psychologique de proximité.',
          wilayaId: wilayaId,
          city: wilaya.nameFr,
          address: 'Secteur Sanitaire, ${wilaya.nameFr}',
          services: const [
            'Consultation Psychologique',
            'Suivi Post-Traumatique',
          ],
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _normalize(String value) {
    final normalized = value.toLowerCase();
    final accentMap = {
      'à': 'a',
      'á': 'a',
      'â': 'a',
      'ä': 'a',
      'ã': 'a',
      'ç': 'c',
      'è': 'e',
      'é': 'e',
      'ê': 'e',
      'ë': 'e',
      'ì': 'i',
      'í': 'i',
      'î': 'i',
      'ï': 'i',
      'ñ': 'n',
      'ò': 'o',
      'ó': 'o',
      'ô': 'o',
      'ö': 'o',
      'õ': 'o',
      'ù': 'u',
      'ú': 'u',
      'û': 'u',
      'ü': 'u',
      'ý': 'y',
      'ÿ': 'y',
      'ß': 'ss',
    };

    final withoutAccents = normalized
        .split('')
        .map((char) => accentMap[char] ?? char)
        .join();
    return withoutAccents
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
