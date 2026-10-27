import '../../models/user_model.dart';
import '../../auth/user_role.dart';
import '../../../features/professional/models/access_request.dart';
import '../../../features/assessment/assessment_record.dart';
import '../../../features/adaptive_assessment/domain/models/assessment_question.dart';
import 'admin_repository.dart';
import 'package:hive/hive.dart';
import '../../data/hive_config.dart';

class HiveAdminRepository implements AdminRepository {
  static const String questionsBox = 'questions_box';

  Box<T> _getBox<T>(String name) {
    return Hive.box<T>(name);
  }

  @override
  Future<List<AssessmentQuestion>> getQuestions() async {
    final box = await Hive.openBox<AssessmentQuestion>(questionsBox);
    return box.values.toList();
  }

  @override
  Future<void> saveQuestion(AssessmentQuestion question) async {
    final box = await Hive.openBox<AssessmentQuestion>(questionsBox);
    await box.put(question.id, question);
  }

  @override
  Future<void> deleteQuestion(String id) async {
    final box = await Hive.openBox<AssessmentQuestion>(questionsBox);
    await box.delete(id);
  }

  @override
  Future<void> resetAlgorithm() async {
    // For now, just clear questions and they will re-seed on next load if implemented that way,
    // or we can just provide a success feedback.
    final box = await Hive.openBox<AssessmentQuestion>(questionsBox);
    await box.clear();
  }

  @override
  Future<Map<String, dynamic>> getGlobalStatistics() async {
    try {
      final usersBox = _getBox<UserModel>(HiveConfig.usersBox);
      final assessmentsBox = Hive.box<AssessmentRecord>(
        HiveConfig.assessmentResultsBox,
      );
      final requestsBox = _getBox<AccessRequest>(HiveConfig.accessRequestsBox);

      final totalUsers = usersBox.values
          .where((u) => u.role == UserRole.user)
          .length;
      final totalProfessionals = usersBox.values
          .where((u) => u.role == UserRole.psychologist)
          .length;
      final pendingProfessionals = usersBox.values
          .where(
            (u) => u.role == UserRole.psychologist && u.status == 'pending',
          )
          .length;
      final totalAssessments = assessmentsBox.length;
      final pendingAccessRequests = requestsBox.values
          .where((r) => r.status == AccessRequestStatus.pending)
          .length;

      return {
        'totalUsers': totalUsers,
        'totalProfessionals': totalProfessionals,
        'pendingProfessionals': pendingProfessionals,
        'totalAssessments': totalAssessments,
        'pendingAccessRequests': pendingAccessRequests,
      };
    } catch (e) {
      throw Exception('Erreur lors de la récupération des statistiques: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final box = _getBox<UserModel>(HiveConfig.usersBox);
      return box.values.where((u) => u.role == UserRole.user).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des utilisateurs: $e');
    }
  }

  @override
  Future<List<UserModel>> getProfessionals() async {
    try {
      final box = _getBox<UserModel>(HiveConfig.usersBox);
      return box.values.where((u) => u.role == UserRole.psychologist).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des professionnels: $e');
    }
  }

  @override
  Future<void> updateProfessionalStatus(String userId, String status) async {
    try {
      final box = _getBox<UserModel>(HiveConfig.usersBox);
      final user = box.get(userId);
      if (user != null) {
        await box.put(
          userId,
          user.copyWith(status: status, updatedAt: DateTime.now()),
        );
      } else {
        throw Exception('Professionnel non trouvé');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du statut: $e');
    }
  }

  @override
  Future<void> updateUserStatus(String userId, String status) async {
    try {
      final box = _getBox<UserModel>(HiveConfig.usersBox);
      final user = box.get(userId);
      if (user != null) {
        await box.put(
          userId,
          user.copyWith(status: status, updatedAt: DateTime.now()),
        );
      } else {
        throw Exception('Utilisateur non trouvé');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du statut: $e');
    }
  }
}
