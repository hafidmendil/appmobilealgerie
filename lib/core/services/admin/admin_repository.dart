import 'package:projetmascara/core/models/user_model.dart';

abstract class AdminRepository {
  Future<Map<String, dynamic>> getGlobalStatistics();
  Future<List<UserModel>> getUsers();
  Future<List<UserModel>> getProfessionals();
  Future<void> updateProfessionalStatus(String userId, String status);
  Future<void> updateUserStatus(String userId, String status);
}
